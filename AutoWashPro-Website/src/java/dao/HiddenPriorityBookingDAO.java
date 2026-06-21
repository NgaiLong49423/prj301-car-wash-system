package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO phu trach tinh nang an: xep booking vao slot chinh, slot backup hoac waiting list.
 * Class nay khong tao UI moi va khong thay doi cach nguoi dung dat lich.
 */
public class HiddenPriorityBookingDAO {

    private static final String SHIFT_MORNING = "MORNING";
    private static final String SHIFT_AFTERNOON = "AFTERNOON";
    private static final String TYPE_MAIN = "MAIN";
    private static final String TYPE_BACKUP = "BACKUP";
    private static final String TYPE_WAITING = "WAITING";
    private static final int MAIN_SLOT_LIMIT = 10;
    private static final int BACKUP_SLOT_LIMIT = 3;

    public void applyPriority(Connection cn, int bookingId) throws Exception {
        BookingInfo booking = loadBookingInfo(cn, bookingId);
        if (booking == null) {
            return;
        }

        String shiftName = resolveShift(booking.bookingTime);
        if (shiftName == null) {
            updateBookingPriority(cn, bookingId, "PENDING", booking.priorityRank, null);
            return;
        }

        int mainCount = countAllocations(cn, booking.bookingDate, shiftName, TYPE_MAIN);
        if (mainCount < MAIN_SLOT_LIMIT) {
            int slotOrder = mainCount + 1;
            insertAllocation(cn, booking, shiftName, TYPE_MAIN, slotOrder);
            updateBookingPriority(cn, bookingId, "CONFIRMED", booking.priorityRank, null);
            return;
        }

        int backupCount = countAllocations(cn, booking.bookingDate, shiftName, TYPE_BACKUP);
        if (backupCount < BACKUP_SLOT_LIMIT) {
            int slotOrder = backupCount + 1;
            insertAllocation(cn, booking, shiftName, TYPE_BACKUP, slotOrder);
            updateBookingPriority(cn, bookingId, "BACKUP_CONFIRMED", booking.priorityRank, null);
            reorderWaitingList(cn, booking.bookingDate, shiftName);
            return;
        }

        BookingInfo weakestBackup = findWeakestBackup(cn, booking.bookingDate, shiftName);
        if (weakestBackup != null && isHigherPriority(booking, weakestBackup)) {
            replaceAllocationOwner(cn, weakestBackup.allocationId, booking);
            moveBookingToWaiting(cn, weakestBackup, shiftName);
            updateBookingPriority(cn, bookingId, "BACKUP_CONFIRMED", booking.priorityRank, null);
            reorderWaitingList(cn, booking.bookingDate, shiftName);
            return;
        }

        insertAllocation(cn, booking, shiftName, TYPE_WAITING, null);
        updateBookingPriority(cn, bookingId, "WAITING", booking.priorityRank, null);
        reorderWaitingList(cn, booking.bookingDate, shiftName);
    }

    private BookingInfo loadBookingInfo(Connection cn, int bookingId) throws Exception {
        String sql = "SELECT b.booking_id, b.customer_id, b.booking_date, b.booking_time, "
                + "ISNULL(mt.tier_name, 'Bronze') AS tier_name "
                + "FROM Booking b "
                + "LEFT JOIN Customer c ON b.customer_id = c.customer_id "
                + "LEFT JOIN MembershipTier mt ON c.tier_id = mt.tier_id "
                + "WHERE b.booking_id = ?";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, bookingId);
            try (ResultSet rs = st.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                BookingInfo info = new BookingInfo();
                info.bookingId = rs.getInt("booking_id");
                info.customerId = rs.getInt("customer_id");
                info.bookingDate = rs.getDate("booking_date");
                info.bookingTime = rs.getTime("booking_time");
                info.tierName = normalizeTier(rs.getString("tier_name"));
                info.priorityRank = toPriorityRank(info.tierName);
                return info;
            }
        }
    }

    private int countAllocations(Connection cn, java.sql.Date bookingDate, String shiftName, String slotType) throws Exception {
        String sql = "SELECT COUNT(*) FROM BookingPriorityAllocation a WITH (UPDLOCK, HOLDLOCK) "
                + "JOIN Booking b ON a.booking_id = b.booking_id "
                + "WHERE a.booking_date = ? AND a.shift_name = ? AND a.slot_type = ? "
                + "AND UPPER(b.status) IN ('CONFIRMED', 'BACKUP_CONFIRMED')";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setDate(1, bookingDate);
            st.setString(2, shiftName);
            st.setString(3, slotType);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private BookingInfo findWeakestBackup(Connection cn, java.sql.Date bookingDate, String shiftName) throws Exception {
        String sql = "SELECT TOP 1 a.allocation_id, b.booking_id, b.customer_id, b.booking_date, b.booking_time, "
                + "a.tier_name, a.priority_rank "
                + "FROM BookingPriorityAllocation a WITH (UPDLOCK, HOLDLOCK) "
                + "JOIN Booking b ON a.booking_id = b.booking_id "
                + "WHERE a.booking_date = ? AND a.shift_name = ? AND a.slot_type = 'BACKUP' "
                + "AND UPPER(b.status) = 'BACKUP_CONFIRMED' "
                + "ORDER BY a.priority_rank ASC, a.created_at DESC, b.booking_id DESC";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setDate(1, bookingDate);
            st.setString(2, shiftName);
            try (ResultSet rs = st.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                BookingInfo info = new BookingInfo();
                info.allocationId = rs.getInt("allocation_id");
                info.bookingId = rs.getInt("booking_id");
                info.customerId = rs.getInt("customer_id");
                info.bookingDate = rs.getDate("booking_date");
                info.bookingTime = rs.getTime("booking_time");
                info.tierName = normalizeTier(rs.getString("tier_name"));
                info.priorityRank = rs.getInt("priority_rank");
                return info;
            }
        }
    }

    private void insertAllocation(Connection cn, BookingInfo booking, String shiftName, String slotType, Integer slotOrder) throws Exception {
        String sql = "INSERT INTO BookingPriorityAllocation "
                + "(booking_id, booking_date, shift_name, slot_type, slot_order, tier_name, priority_rank) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, booking.bookingId);
            st.setDate(2, booking.bookingDate);
            st.setString(3, shiftName);
            st.setString(4, slotType);
            if (slotOrder == null) {
                st.setNull(5, java.sql.Types.INTEGER);
            } else {
                st.setInt(5, slotOrder);
            }
            st.setString(6, booking.tierName);
            st.setInt(7, booking.priorityRank);
            st.executeUpdate();
        }
    }

    private void replaceAllocationOwner(Connection cn, int allocationId, BookingInfo booking) throws Exception {
        String sql = "UPDATE BookingPriorityAllocation "
                + "SET booking_id = ?, tier_name = ?, priority_rank = ?, created_at = GETDATE() "
                + "WHERE allocation_id = ?";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, booking.bookingId);
            st.setString(2, booking.tierName);
            st.setInt(3, booking.priorityRank);
            st.setInt(4, allocationId);
            st.executeUpdate();
        }
    }

    private void moveBookingToWaiting(Connection cn, BookingInfo booking, String shiftName) throws Exception {
        insertAllocation(cn, booking, shiftName, TYPE_WAITING, null);
        updateBookingPriority(cn, booking.bookingId, "WAITING", booking.priorityRank, null);
    }

    private void updateBookingPriority(Connection cn, int bookingId, String status, int priorityRank, Integer queuePosition) throws Exception {
        String sql = "UPDATE Booking SET status = ? WHERE booking_id = ?";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setString(1, status);
            st.setInt(2, bookingId);
            st.executeUpdate();
        }
    }

    private void reorderWaitingList(Connection cn, java.sql.Date bookingDate, String shiftName) throws Exception {
        String sql = "SELECT a.allocation_id, a.booking_id "
                + "FROM BookingPriorityAllocation a "
                + "JOIN Booking b ON a.booking_id = b.booking_id "
                + "WHERE a.booking_date = ? AND a.shift_name = ? AND a.slot_type = 'WAITING' "
                + "AND UPPER(b.status) = 'WAITING' "
                + "ORDER BY a.priority_rank DESC, a.created_at ASC, a.allocation_id ASC";
        List<Integer> bookingIds = new ArrayList<>();
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setDate(1, bookingDate);
            st.setString(2, shiftName);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    bookingIds.add(rs.getInt("booking_id"));
                }
            }
        }

        String update = "UPDATE BookingPriorityAllocation SET slot_order = ? WHERE booking_id = ? AND slot_type = 'WAITING'";
        try (PreparedStatement st = cn.prepareStatement(update)) {
            for (int i = 0; i < bookingIds.size(); i++) {
                st.setInt(1, i + 1);
                st.setInt(2, bookingIds.get(i));
                st.addBatch();
            }
            st.executeBatch();
        }
    }

    private boolean isHigherPriority(BookingInfo newBooking, BookingInfo currentBooking) {
        if (newBooking.priorityRank != currentBooking.priorityRank) {
            return newBooking.priorityRank > currentBooking.priorityRank;
        }
        return newBooking.bookingId < currentBooking.bookingId;
    }

    private String resolveShift(Time time) {
        if (time == null) {
            return null;
        }
        int hour = time.toLocalTime().getHour();
        if (hour >= 7 && hour < 12) {
            return SHIFT_MORNING;
        }
        if (hour >= 13 && hour < 18) {
            return SHIFT_AFTERNOON;
        }
        return null;
    }

    private String normalizeTier(String tierName) {
        if (tierName == null || "Member".equalsIgnoreCase(tierName)) {
            return "Bronze";
        }
        if ("Platinum".equalsIgnoreCase(tierName)) {
            return "Platinum";
        }
        if ("Gold".equalsIgnoreCase(tierName)) {
            return "Gold";
        }
        if ("Silver".equalsIgnoreCase(tierName)) {
            return "Silver";
        }
        return "Bronze";
    }

    private int toPriorityRank(String tierName) {
        if ("Platinum".equalsIgnoreCase(tierName)) {
            return 4;
        }
        if ("Gold".equalsIgnoreCase(tierName)) {
            return 3;
        }
        if ("Silver".equalsIgnoreCase(tierName)) {
            return 2;
        }
        return 1;
    }

    private static class BookingInfo {
        private int allocationId;
        private int bookingId;
        private int customerId;
        private java.sql.Date bookingDate;
        private Time bookingTime;
        private String tierName;
        private int priorityRank;
    }
}
