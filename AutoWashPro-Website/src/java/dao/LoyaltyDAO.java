package dao;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import mylib.DBUtils;

/** Atomic loyalty award flow for a completed booking. */
public class LoyaltyDAO {

    /**
     * Expires due point batches exactly once and rebuilds active_points.
     * Lifetime total_points is intentionally never changed by this flow.
     */
    public int refreshExpiredPoints(int customerId)
            throws SQLException, ClassNotFoundException {
        try (Connection conn = DBUtils.getConnection()) {
            if (conn == null) {
                return 0;
            }
            boolean previousAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try {
                int expiredPoints = refreshExpiredPoints(conn, customerId);
                conn.commit();
                return expiredPoints;
            } catch (SQLException | RuntimeException ex) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    ex.addSuppressed(rollbackError);
                }
                throw ex;
            } finally {
                try {
                    conn.setAutoCommit(previousAutoCommit);
                } catch (SQLException ignored) {
                    // Connection is closing.
                }
            }
        }
    }

    private int refreshExpiredPoints(Connection conn, int customerId) throws SQLException {
        List<ExpiredPointBatch> dueBatches = loadDuePointBatches(conn, customerId);
        int expiredPoints = 0;
        for (ExpiredPointBatch batch : dueBatches) {
            if (markPointBatchExpired(conn, batch.pointBatchId) == 1) {
                insertExpiredTransaction(conn, customerId, batch);
                expiredPoints += batch.remainingPoints;
            }
        }
        updateActivePointBalance(conn, customerId);
        return expiredPoints;
    }

    private List<ExpiredPointBatch> loadDuePointBatches(Connection conn, int customerId)
            throws SQLException {
        String sql = "SELECT point_batch_id, remaining_points "
                + "FROM LoyaltyPointBatch WITH (UPDLOCK, ROWLOCK) "
                + "WHERE customer_id = ? AND status = 'ACTIVE' "
                + "AND remaining_points > 0 AND expires_at <= GETDATE() "
                + "ORDER BY expires_at, earned_at, point_batch_id";
        List<ExpiredPointBatch> batches = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    batches.add(new ExpiredPointBatch(
                            rs.getInt("point_batch_id"), rs.getInt("remaining_points")));
                }
            }
        }
        return batches;
    }

    private int markPointBatchExpired(Connection conn, int pointBatchId) throws SQLException {
        String sql = "UPDATE LoyaltyPointBatch SET status = 'EXPIRED' "
                + "WHERE point_batch_id = ? AND status = 'ACTIVE'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pointBatchId);
            return ps.executeUpdate();
        }
    }

    private void insertExpiredTransaction(Connection conn, int customerId,
            ExpiredPointBatch batch) throws SQLException {
        String sql = "INSERT INTO LoyaltyTransaction "
                + "(customer_id, point_batch_id, points, transaction_type, description, created_at) "
                + "VALUES (?, ?, ?, 'EXPIRED', ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, batch.pointBatchId);
            ps.setInt(3, batch.remainingPoints);
            ps.setString(4, "Remaining points expired from batch #" + batch.pointBatchId);
            ps.executeUpdate();
        }
    }

    private void updateActivePointBalance(Connection conn, int customerId) throws SQLException {
        String sql = "UPDATE Customer SET active_points = ("
                + "SELECT COALESCE(SUM(remaining_points), 0) FROM LoyaltyPointBatch "
                + "WHERE customer_id = ? AND status = 'ACTIVE' AND expires_at > GETDATE()"
                + ") WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, customerId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Customer active point balance was not updated: " + customerId);
            }
        }
    }

    /** Returns the persisted spendable balance after expiry/redemption processing. */
    public int getActivePointBalance(int customerId)
            throws SQLException, ClassNotFoundException {
        String sql = "SELECT active_points FROM Customer WHERE customer_id = ? AND is_active = 1";
        try (Connection conn = DBUtils.getConnection()) {
            if (conn == null) {
                throw new SQLException("Database connection is unavailable");
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, customerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        throw new SQLException("Active customer was not found: " + customerId);
                    }
                    return rs.getInt("active_points");
                }
            }
        }
    }

    /**
     * Redeems one active reward by consuming unexpired point batches in FIFO order.
     * Point deduction, voucher creation, history and active balance share one transaction.
     */
    public String redeemReward(int customerId, int rewardId, String requestToken)
            throws SQLException, ClassNotFoundException {
        if (customerId <= 0 || rewardId <= 0 || requestToken == null
                || requestToken.trim().isEmpty() || requestToken.length() > 64) {
            throw new IllegalArgumentException("Invalid redemption request");
        }

        try (Connection conn = DBUtils.getConnection()) {
            if (conn == null) {
                throw new SQLException("Database connection is unavailable");
            }
            boolean previousAutoCommit = conn.getAutoCommit();
            int previousIsolation = conn.getTransactionIsolation();
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            conn.setAutoCommit(false);
            try {
                String existingVoucher = findVoucherByRequestToken(conn, customerId, requestToken);
                if (existingVoucher != null) {
                    conn.commit();
                    return existingVoucher;
                }

                lockActiveCustomer(conn, customerId);
                RewardRedemptionRule reward = loadActiveRewardForRedemption(conn, rewardId);
                if (reward == null) {
                    throw new IllegalArgumentException("Phần thưởng không tồn tại hoặc đã ngừng hoạt động.");
                }

                // GI-05 must run inside this same transaction before points are checked.
                refreshExpiredPoints(conn, customerId);
                List<RedeemablePointBatch> pointBatches = loadRedeemablePointBatches(conn, customerId);
                int activePoints = sumRemainingPoints(pointBatches);
                if (activePoints < reward.requiredPoints) {
                    throw new IllegalArgumentException("Bạn không đủ điểm để đổi phần thưởng này.");
                }

                deductPointBatchesFifo(conn, pointBatches, reward.requiredPoints);
                String voucherCode = generateVoucherCode();
                int redemptionId = insertRedemption(
                        conn, customerId, rewardId, reward, voucherCode, requestToken);
                insertRedeemedTransaction(
                        conn, customerId, redemptionId, reward.requiredPoints, reward.rewardName);
                updateActivePointBalance(conn, customerId);

                conn.commit();
                return voucherCode;
            } catch (SQLException | RuntimeException ex) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    ex.addSuppressed(rollbackError);
                }
                throw ex;
            } finally {
                try {
                    conn.setTransactionIsolation(previousIsolation);
                    conn.setAutoCommit(previousAutoCommit);
                } catch (SQLException ignored) {
                    // Connection is closing.
                }
            }
        }
    }

    private String findVoucherByRequestToken(Connection conn, int customerId,
            String requestToken) throws SQLException {
        String sql = "SELECT voucher_code FROM Redemption WITH (UPDLOCK, ROWLOCK) "
                + "WHERE customer_id = ? AND request_token = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, requestToken);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString("voucher_code") : null;
            }
        }
    }

    private void lockActiveCustomer(Connection conn, int customerId) throws SQLException {
        String sql = "SELECT customer_id FROM Customer WITH (UPDLOCK, ROWLOCK) "
                + "WHERE customer_id = ? AND is_active = 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalArgumentException("Tài khoản không tồn tại hoặc đã bị khóa.");
                }
            }
        }
    }

    private RewardRedemptionRule loadActiveRewardForRedemption(Connection conn, int rewardId)
            throws SQLException {
        String sql = "SELECT reward_name, required_points, reward_type, reward_value, valid_days "
                + "FROM Reward WITH (UPDLOCK, ROWLOCK) "
                + "WHERE reward_id = ? AND is_active = 1 AND required_points > 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rewardId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return new RewardRedemptionRule(
                        rs.getString("reward_name"), rs.getInt("required_points"),
                        rs.getString("reward_type"), rs.getBigDecimal("reward_value"),
                        rs.getInt("valid_days"));
            }
        }
    }

    private List<RedeemablePointBatch> loadRedeemablePointBatches(Connection conn,
            int customerId) throws SQLException {
        String sql = "SELECT point_batch_id, remaining_points FROM LoyaltyPointBatch "
                + "WITH (UPDLOCK, ROWLOCK) WHERE customer_id = ? AND status = 'ACTIVE' "
                + "AND remaining_points > 0 AND expires_at > GETDATE() "
                + "ORDER BY expires_at, earned_at, point_batch_id";
        List<RedeemablePointBatch> batches = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    batches.add(new RedeemablePointBatch(
                            rs.getInt("point_batch_id"), rs.getInt("remaining_points")));
                }
            }
        }
        return batches;
    }

    private int sumRemainingPoints(List<RedeemablePointBatch> batches) {
        int total = 0;
        for (RedeemablePointBatch batch : batches) {
            total = Math.addExact(total, batch.remainingPoints);
        }
        return total;
    }

    private void deductPointBatchesFifo(Connection conn, List<RedeemablePointBatch> batches,
            int requiredPoints) throws SQLException {
        int pointsLeft = requiredPoints;
        String sql = "UPDATE LoyaltyPointBatch SET remaining_points = ?, status = ? "
                + "WHERE point_batch_id = ? AND status = 'ACTIVE' AND remaining_points = ?";
        for (RedeemablePointBatch batch : batches) {
            if (pointsLeft == 0) {
                break;
            }
            int deducted = Math.min(pointsLeft, batch.remainingPoints);
            int newBalance = batch.remainingPoints - deducted;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, newBalance);
                ps.setString(2, newBalance == 0 ? "USED_UP" : "ACTIVE");
                ps.setInt(3, batch.pointBatchId);
                ps.setInt(4, batch.remainingPoints);
                if (ps.executeUpdate() != 1) {
                    throw new SQLException("Point batch changed during redemption: "
                            + batch.pointBatchId);
                }
            }
            pointsLeft -= deducted;
        }
        if (pointsLeft != 0) {
            throw new SQLException("Active point balance changed during redemption");
        }
    }

    private int insertRedemption(Connection conn, int customerId, int rewardId,
            RewardRedemptionRule reward, String voucherCode, String requestToken)
            throws SQLException {
        String sql = "INSERT INTO Redemption "
                + "(customer_id, reward_id, points_used, redeem_date, valid_from, valid_until, "
                + "status, voucher_code, reward_name_snapshot, reward_type_snapshot, "
                + "reward_value_snapshot, request_token) "
                + "VALUES (?, ?, ?, GETDATE(), GETDATE(), DATEADD(DAY, ?, GETDATE()), "
                + "'AVAILABLE', ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerId);
            ps.setInt(2, rewardId);
            ps.setInt(3, reward.requiredPoints);
            ps.setInt(4, reward.validDays);
            ps.setString(5, voucherCode);
            ps.setString(6, reward.rewardName);
            ps.setString(7, reward.rewardType);
            ps.setBigDecimal(8, reward.rewardValue);
            ps.setString(9, requestToken);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("Could not retrieve redemption id");
                }
                return keys.getInt(1);
            }
        }
    }

    private void insertRedeemedTransaction(Connection conn, int customerId, int redemptionId,
            int pointsUsed, String rewardName) throws SQLException {
        String sql = "INSERT INTO LoyaltyTransaction "
                + "(customer_id, redemption_id, points, transaction_type, description, created_at) "
                + "VALUES (?, ?, ?, 'REDEEMED', ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, redemptionId);
            ps.setInt(3, -pointsUsed);
            ps.setString(4, "Redeemed reward: " + rewardName);
            ps.executeUpdate();
        }
    }

    private String generateVoucherCode() {
        return "LW-" + UUID.randomUUID().toString().replace("-", "")
                .substring(0, 12).toUpperCase(Locale.ENGLISH);
    }

    /** Awards points exactly once for a completed booking. */
    public boolean awardLoyaltyForCompletedBooking(int bookingId)
            throws SQLException, ClassNotFoundException {
        try (Connection conn = DBUtils.getConnection()) {
            if (conn == null) {
                return false;
            }
            boolean previousAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try {
                BookingLoyaltyData booking = loadBookingForAward(conn, bookingId);
                if (booking == null || !"COMPLETED".equalsIgnoreCase(booking.status)
                        || booking.loyaltyPointsAwarded) {
                    conn.rollback();
                    return false;
                }

                TierRule tier = loadTierRule(conn, booking.customerId);
                if (tier == null) {
                    throw new SQLException("No active membership tier for customer " + booking.customerId);
                }

                int expiryMonths = loadPointExpiryMonths(conn);
                int earnedPoints = calculatePoints(booking.finalAmount, tier.pointRate, tier.pointMultiplier);
                int pointBatchId = insertPointBatch(conn, booking.customerId, bookingId, earnedPoints, expiryMonths);
                insertEarnedTransaction(conn, booking.customerId, bookingId, pointBatchId, earnedPoints);
                updateCustomerSummary(conn, booking.customerId, earnedPoints, booking.finalAmount);
                refreshActiveLoyaltyData(conn, booking.customerId);

                if (markBookingAwarded(conn, bookingId) != 1) {
                    throw new SQLException("Booking was already awarded or is no longer completed: " + bookingId);
                }
                conn.commit();
                return true;
            } catch (SQLException | RuntimeException ex) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    ex.addSuppressed(rollbackError);
                }
                throw ex;
            } finally {
                try {
                    conn.setAutoCommit(previousAutoCommit);
                } catch (SQLException ignored) {
                    // Connection is closing.
                }
            }
        }
    }

    /**
     * Rebuilds active 12-month loyalty metrics and assigns the highest eligible tier.
     * Lifetime totals are intentionally not changed by this refresh.
     */
    public boolean refreshActiveLoyaltyData(int customerId)
            throws SQLException, ClassNotFoundException {
        try (Connection conn = DBUtils.getConnection()) {
            if (conn == null) {
                return false;
            }
            boolean previousAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try {
                refreshActiveLoyaltyData(conn, customerId);
                conn.commit();
                return true;
            } catch (SQLException | RuntimeException ex) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    ex.addSuppressed(rollbackError);
                }
                throw ex;
            } finally {
                try {
                    conn.setAutoCommit(previousAutoCommit);
                } catch (SQLException ignored) {
                    // Connection is closing.
                }
            }
        }
    }

    private BookingLoyaltyData loadBookingForAward(Connection conn, int bookingId) throws SQLException {
        String sql = "SELECT customer_id, status, final_amount, loyalty_points_awarded "
                + "FROM Booking WITH (UPDLOCK, ROWLOCK) WHERE booking_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                BookingLoyaltyData booking = new BookingLoyaltyData();
                booking.customerId = rs.getInt("customer_id");
                booking.status = rs.getString("status");
                booking.finalAmount = rs.getBigDecimal("final_amount");
                booking.loyaltyPointsAwarded = rs.getBoolean("loyalty_points_awarded");
                return booking;
            }
        }
    }

    private TierRule loadTierRule(Connection conn, int customerId) throws SQLException {
        String sql = "SELECT t.point_rate, t.point_multiplier "
                + "FROM Customer c JOIN MembershipTier t ON c.tier_id = t.tier_id "
                + "WHERE c.customer_id = ? AND t.is_active = 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                TierRule tier = new TierRule();
                tier.pointRate = rs.getInt("point_rate");
                tier.pointMultiplier = rs.getBigDecimal("point_multiplier");
                return tier;
            }
        }
    }

    private int loadPointExpiryMonths(Connection conn) throws SQLException {
        String sql = "SELECT TRY_CONVERT(INT, config_value) AS expiry_months "
                + "FROM LoyaltyConfig WHERE config_key = 'POINT_EXPIRY_MONTHS'";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (!rs.next() || rs.getObject("expiry_months") == null || rs.getInt("expiry_months") <= 0) {
                throw new SQLException("Missing valid POINT_EXPIRY_MONTHS configuration");
            }
            return rs.getInt("expiry_months");
        }
    }

    private int calculatePoints(BigDecimal finalAmount, int pointRate, BigDecimal pointMultiplier) {
        if (finalAmount == null || finalAmount.signum() < 0 || pointRate <= 0
                || pointMultiplier == null || pointMultiplier.signum() <= 0) {
            throw new IllegalArgumentException("Invalid loyalty award inputs");
        }
        return finalAmount.divide(BigDecimal.valueOf(pointRate), 0, RoundingMode.DOWN)
                .multiply(pointMultiplier)
                .setScale(0, RoundingMode.DOWN)
                .intValueExact();
    }

    private int insertPointBatch(Connection conn, int customerId, int bookingId,
            int earnedPoints, int expiryMonths) throws SQLException {
        String sql = "INSERT INTO LoyaltyPointBatch "
                + "(customer_id, source_booking_id, earned_points, remaining_points, earned_at, expires_at, status) "
                + "VALUES (?, ?, ?, ?, GETDATE(), DATEADD(MONTH, ?, GETDATE()), 'ACTIVE')";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerId);
            ps.setInt(2, bookingId);
            ps.setInt(3, earnedPoints);
            ps.setInt(4, earnedPoints);
            ps.setInt(5, expiryMonths);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("Could not retrieve loyalty point batch id");
                }
                return keys.getInt(1);
            }
        }
    }

    private void insertEarnedTransaction(Connection conn, int customerId, int bookingId,
            int pointBatchId, int points) throws SQLException {
        String sql = "INSERT INTO LoyaltyTransaction "
                + "(customer_id, booking_id, point_batch_id, points, transaction_type, description, created_at) "
                + "VALUES (?, ?, ?, ?, 'EARNED', ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, bookingId);
            ps.setInt(3, pointBatchId);
            ps.setInt(4, points);
            ps.setString(5, "Points earned from completed booking #" + bookingId);
            ps.executeUpdate();
        }
    }

    private void updateCustomerSummary(Connection conn, int customerId, int points,
            BigDecimal finalAmount) throws SQLException {
        String sql = "UPDATE Customer SET active_points = active_points + ?, "
                + "active_spent_money_12m = active_spent_money_12m + ?, "
                + "active_visit_count_12m = active_visit_count_12m + 1, "
                + "lifetime_spent_money = lifetime_spent_money + ?, "
                + "lifetime_visit_count = lifetime_visit_count + 1, "
                + "total_points = total_points + ?, "
                + "total_spent_money = total_spent_money + ? WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, points);
            ps.setBigDecimal(2, finalAmount);
            ps.setBigDecimal(3, finalAmount);
            ps.setInt(4, points);
            ps.setBigDecimal(5, finalAmount);
            ps.setInt(6, customerId);
            if (ps.executeUpdate() != 1) {
                throw new SQLException("Customer summary was not updated: " + customerId);
            }
        }
    }

    private void refreshActiveLoyaltyData(Connection conn, int customerId) throws SQLException {
        BigDecimal spent;
        int visits;
        int activePoints;
        String activeBookingSql = "SELECT COALESCE(SUM(final_amount), 0) AS active_spent, "
                + "COUNT(*) AS active_visits FROM Booking "
                + "WHERE customer_id = ? AND status = 'COMPLETED' "
                + "AND loyalty_points_awarded = 1 "
                + "AND loyalty_awarded_at >= DATEADD(MONTH, -12, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(activeBookingSql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new SQLException("Customer not found: " + customerId);
                }
                spent = rs.getBigDecimal("active_spent");
                visits = rs.getInt("active_visits");
            }
        }

        String activePointsSql = "SELECT COALESCE(SUM(remaining_points), 0) AS active_points "
                + "FROM LoyaltyPointBatch WHERE customer_id = ? "
                + "AND status = 'ACTIVE' AND expires_at > GETDATE()";
        try (PreparedStatement ps = conn.prepareStatement(activePointsSql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new SQLException("Could not refresh active points for customer: " + customerId);
                }
                activePoints = rs.getInt("active_points");
            }
        }

        String tierSql = "SELECT TOP 1 tier_id FROM MembershipTier WHERE is_active = 1 "
                + "AND (min_spent_money <= ? OR min_visit_count <= ?) ORDER BY tier_order DESC";
        int tierId;
        try (PreparedStatement ps = conn.prepareStatement(tierSql)) {
            ps.setBigDecimal(1, spent);
            ps.setInt(2, visits);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new SQLException("No eligible tier for customer: " + customerId);
                }
                tierId = rs.getInt("tier_id");
            }
        }

        String updateSql = "UPDATE Customer SET active_points = ?, "
                + "active_spent_money_12m = ?, active_visit_count_12m = ?, tier_id = ? "
                + "WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
            ps.setInt(1, activePoints);
            ps.setBigDecimal(2, spent);
            ps.setInt(3, visits);
            ps.setInt(4, tierId);
            ps.setInt(5, customerId);
            ps.executeUpdate();
        }
    }

    private int markBookingAwarded(Connection conn, int bookingId) throws SQLException {
        String sql = "UPDATE Booking SET loyalty_points_awarded = 1, loyalty_awarded_at = GETDATE() "
                + "WHERE booking_id = ? AND status = 'COMPLETED' AND loyalty_points_awarded = 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate();
        }
    }

    private static class BookingLoyaltyData {
        private int customerId;
        private String status;
        private BigDecimal finalAmount;
        private boolean loyaltyPointsAwarded;
    }

    private static class TierRule {
        private int pointRate;
        private BigDecimal pointMultiplier;
    }

    private static class ExpiredPointBatch {
        private final int pointBatchId;
        private final int remainingPoints;

        private ExpiredPointBatch(int pointBatchId, int remainingPoints) {
            this.pointBatchId = pointBatchId;
            this.remainingPoints = remainingPoints;
        }
    }

    private static class RedeemablePointBatch {
        private final int pointBatchId;
        private final int remainingPoints;

        private RedeemablePointBatch(int pointBatchId, int remainingPoints) {
            this.pointBatchId = pointBatchId;
            this.remainingPoints = remainingPoints;
        }
    }

    private static class RewardRedemptionRule {
        private final String rewardName;
        private final int requiredPoints;
        private final String rewardType;
        private final BigDecimal rewardValue;
        private final int validDays;

        private RewardRedemptionRule(String rewardName, int requiredPoints,
                String rewardType, BigDecimal rewardValue, int validDays) {
            this.rewardName = rewardName;
            this.requiredPoints = requiredPoints;
            this.rewardType = rewardType;
            this.rewardValue = rewardValue;
            this.validDays = validDays;
        }
    }
}
