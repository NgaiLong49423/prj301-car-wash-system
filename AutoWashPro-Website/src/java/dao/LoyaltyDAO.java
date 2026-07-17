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
                List<ExpiredPointBatch> dueBatches = loadDuePointBatches(conn, customerId);
                int expiredPoints = 0;
                for (ExpiredPointBatch batch : dueBatches) {
                    if (markPointBatchExpired(conn, batch.pointBatchId) == 1) {
                        insertExpiredTransaction(conn, customerId, batch);
                        expiredPoints += batch.remainingPoints;
                    }
                }
                updateActivePointBalance(conn, customerId);
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
}
