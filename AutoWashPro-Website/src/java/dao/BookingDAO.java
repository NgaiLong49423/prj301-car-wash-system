package dao;

import dto.BookingDTO;
import dto.BookingResultDTO;
import dto.MembershipTierDTO;
import dto.ServiceDTO;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import mylib.DBUtils;

public class BookingDAO {

    private static final Logger LOGGER = Logger.getLogger(BookingDAO.class.getName());
    private static final int DEFAULT_SLOT_CAPACITY = 3;
    private static final int MAX_ACTIVE_BOOKINGS = 3;

    public BookingResultDTO createPriorityBooking(int customerId, int vehicleId, Date bookingDate, Time bookingTime,
            List<ServiceDTO> services, MembershipTierDTO tier) {
        if (services == null || services.isEmpty()) {
            return new BookingResultDTO(false, "ERROR", "Vui long chon it nhat mot dich vu.", 0, null);
        }

        int priorityScore = tier != null ? tier.getPriorityScore() : 10;
        BigDecimal totalPrice = calculateTotalPrice(services);
        Timestamp requestedAt = new Timestamp(System.currentTimeMillis());

        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            cn.setAutoCommit(false);

            if (!isVehicleOwnedByCustomer(cn, vehicleId, customerId)) {
                cn.rollback();
                return new BookingResultDTO(false, "ERROR", "Xe khong hop le hoac khong thuoc tai khoan cua ban.", 0, null);
            }

            if (countActiveBookings(cn, customerId) >= MAX_ACTIVE_BOOKINGS) {
                cn.rollback();
                return new BookingResultDTO(false, "ERROR", "Ban dang co qua nhieu lich hen dang xu ly.", 0, null);
            }

            if (hasScheduleConflict(cn, customerId, vehicleId, bookingDate, bookingTime)) {
                cn.rollback();
                return new BookingResultDTO(false, "ERROR", "Ban da co lich hen trong khung gio nay.", 0, null);
            }

            ensureBookingSlot(cn, bookingDate, bookingTime);
            int capacity = getSlotCapacity(cn, bookingDate, bookingTime);
            int confirmedCount = countConfirmedBookings(cn, bookingDate, bookingTime);

            String status = confirmedCount < capacity ? "CONFIRMED" : "WAITLIST";
            Integer queuePosition = null;

            int bookingId = insertBooking(cn, customerId, vehicleId, bookingDate, bookingTime, status,
                    totalPrice, requestedAt, priorityScore);
            insertBookingServices(cn, bookingId, services);

            if ("WAITLIST".equals(status)) {
                reorderWaitlist(cn, bookingDate, bookingTime);
                queuePosition = getQueuePosition(cn, bookingId);
                writeQueueLog(cn, bookingId, "PENDING", "WAITLIST", "Slot is full, sorted by membership priority.");
            } else {
                updateSlotConfirmedCount(cn, bookingDate, bookingTime);
                writeQueueLog(cn, bookingId, "PENDING", "CONFIRMED", "Slot capacity is available.");
            }

            cn.commit();

            if ("CONFIRMED".equals(status)) {
                return new BookingResultDTO(true, status, "Dat lich thanh cong. Lich cua ban da duoc xac nhan.", bookingId, null);
            }
            return new BookingResultDTO(true, status, "Khung gio da day. Ban da duoc dua vao danh sach cho uu tien.", bookingId, queuePosition);
        } catch (Exception e) {
            rollbackQuietly(cn);
            LOGGER.log(Level.SEVERE, "Failed to create priority booking", e);
            return new BookingResultDTO(false, "ERROR", "He thong dang ban, vui long thu lai sau.", 0, null);
        } finally {
            closeQuietly(cn);
        }
    }

    public List<BookingDTO> getRecentBookingsByCustomer(int customerId) {
        List<BookingDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 10 b.booking_id, b.customer_id, b.vehicle_id, b.booking_date, b.booking_time, "
                + "b.status, b.total_price, b.requested_at, b.priority_score, b.queue_position, "
                + "v.license_plate, mt.tier_name "
                + "FROM Booking b "
                + "JOIN Vehicle v ON b.vehicle_id = v.vehicle_id "
                + "JOIN Customer c ON b.customer_id = c.customer_id "
                + "LEFT JOIN MembershipTier mt ON c.tier_id = mt.tier_id "
                + "WHERE b.customer_id = ? "
                + "ORDER BY b.booking_date DESC, b.booking_time DESC, b.booking_id DESC";

        try (Connection cn = DBUtils.getConnection();
                PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBooking(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load customer bookings", e);
        }
        return list;
    }

    private boolean isVehicleOwnedByCustomer(Connection cn, int vehicleId, int customerId) throws Exception {
        String sql = "SELECT COUNT(*) FROM Vehicle WHERE vehicle_id = ? AND customer_id = ?";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, vehicleId);
            st.setInt(2, customerId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    private int countActiveBookings(Connection cn, int customerId) throws Exception {
        String sql = "SELECT COUNT(*) FROM Booking WHERE customer_id = ? AND UPPER(status) IN ('PENDING','CONFIRMED','WAITLIST')";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private boolean hasScheduleConflict(Connection cn, int customerId, int vehicleId, Date bookingDate, Time bookingTime) throws Exception {
        String sql = "SELECT COUNT(*) FROM Booking "
                + "WHERE booking_date = ? AND booking_time = ? "
                + "AND UPPER(status) IN ('PENDING','CONFIRMED','WAITLIST') "
                + "AND (customer_id = ? OR vehicle_id = ?)";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setDate(1, bookingDate);
            st.setTime(2, bookingTime);
            st.setInt(3, customerId);
            st.setInt(4, vehicleId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    private void ensureBookingSlot(Connection cn, Date bookingDate, Time bookingTime) throws Exception {
        String sql = "IF NOT EXISTS (SELECT 1 FROM BookingSlot WHERE slot_date = ? AND slot_time = ?) "
                + "INSERT INTO BookingSlot(slot_date, slot_time, max_capacity, reserved_vip_capacity, current_confirmed) "
                + "VALUES (?, ?, ?, 1, 0)";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setDate(1, bookingDate);
            st.setTime(2, bookingTime);
            st.setDate(3, bookingDate);
            st.setTime(4, bookingTime);
            st.setInt(5, DEFAULT_SLOT_CAPACITY);
            st.executeUpdate();
        }
    }

    private int getSlotCapacity(Connection cn, Date bookingDate, Time bookingTime) throws Exception {
        String sql = "SELECT max_capacity FROM BookingSlot WHERE slot_date = ? AND slot_time = ?";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setDate(1, bookingDate);
            st.setTime(2, bookingTime);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() ? rs.getInt("max_capacity") : DEFAULT_SLOT_CAPACITY;
            }
        }
    }

    private int countConfirmedBookings(Connection cn, Date bookingDate, Time bookingTime) throws Exception {
        String sql = "SELECT COUNT(*) FROM Booking WHERE booking_date = ? AND booking_time = ? AND UPPER(status) = 'CONFIRMED'";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setDate(1, bookingDate);
            st.setTime(2, bookingTime);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private int insertBooking(Connection cn, int customerId, int vehicleId, Date bookingDate, Time bookingTime,
            String status, BigDecimal totalPrice, Timestamp requestedAt, int priorityScore) throws Exception {
        String sql = "INSERT INTO Booking(customer_id, vehicle_id, booking_date, booking_time, status, total_price, requested_at, priority_score) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, customerId);
            st.setInt(2, vehicleId);
            st.setDate(3, bookingDate);
            st.setTime(4, bookingTime);
            st.setString(5, status);
            st.setBigDecimal(6, totalPrice);
            st.setTimestamp(7, requestedAt);
            st.setInt(8, priorityScore);
            st.executeUpdate();

            try (ResultSet keys = st.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new IllegalStateException("Cannot create booking id");
    }

    private void insertBookingServices(Connection cn, int bookingId, List<ServiceDTO> services) throws Exception {
        String sql = "INSERT INTO BookingService(booking_id, service_id, quantity, price) VALUES (?, ?, 1, ?)";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            for (ServiceDTO service : services) {
                st.setInt(1, bookingId);
                st.setInt(2, service.getServiceId());
                st.setBigDecimal(3, service.getPrice());
                st.addBatch();
            }
            st.executeBatch();
        }
    }

    private void reorderWaitlist(Connection cn, Date bookingDate, Time bookingTime) throws Exception {
        String sql = "SELECT booking_id FROM Booking "
                + "WHERE booking_date = ? AND booking_time = ? AND UPPER(status) = 'WAITLIST' "
                + "ORDER BY priority_score DESC, requested_at ASC, booking_id ASC";
        List<Integer> ids = new ArrayList<>();
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setDate(1, bookingDate);
            st.setTime(2, bookingTime);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("booking_id"));
                }
            }
        }

        String update = "UPDATE Booking SET queue_position = ? WHERE booking_id = ?";
        try (PreparedStatement st = cn.prepareStatement(update)) {
            for (int i = 0; i < ids.size(); i++) {
                st.setInt(1, i + 1);
                st.setInt(2, ids.get(i));
                st.addBatch();
            }
            st.executeBatch();
        }
    }

    private Integer getQueuePosition(Connection cn, int bookingId) throws Exception {
        String sql = "SELECT queue_position FROM Booking WHERE booking_id = ?";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, bookingId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    int value = rs.getInt("queue_position");
                    return rs.wasNull() ? null : value;
                }
            }
        }
        return null;
    }

    private void updateSlotConfirmedCount(Connection cn, Date bookingDate, Time bookingTime) throws Exception {
        String sql = "UPDATE BookingSlot SET current_confirmed = "
                + "(SELECT COUNT(*) FROM Booking WHERE booking_date = ? AND booking_time = ? AND UPPER(status) = 'CONFIRMED') "
                + "WHERE slot_date = ? AND slot_time = ?";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setDate(1, bookingDate);
            st.setTime(2, bookingTime);
            st.setDate(3, bookingDate);
            st.setTime(4, bookingTime);
            st.executeUpdate();
        }
    }

    private void writeQueueLog(Connection cn, int bookingId, String oldStatus, String newStatus, String reason) throws Exception {
        String sql = "INSERT INTO BookingQueueLog(booking_id, old_status, new_status, reason) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, bookingId);
            st.setString(2, oldStatus);
            st.setString(3, newStatus);
            st.setString(4, reason);
            st.executeUpdate();
        }
    }

    private BigDecimal calculateTotalPrice(List<ServiceDTO> services) {
        BigDecimal total = BigDecimal.ZERO;
        for (ServiceDTO service : services) {
            if (service.getPrice() != null) {
                total = total.add(service.getPrice());
            }
        }
        return total;
    }

    private BookingDTO mapBooking(ResultSet rs) throws Exception {
        BookingDTO booking = new BookingDTO();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setCustomerId(rs.getInt("customer_id"));
        booking.setVehicleId(rs.getInt("vehicle_id"));
        booking.setBookingDate(rs.getDate("booking_date"));
        booking.setBookingTime(rs.getTime("booking_time"));
        booking.setStatus(rs.getString("status"));
        booking.setTotalPrice(rs.getBigDecimal("total_price"));
        booking.setRequestedAt(rs.getTimestamp("requested_at"));
        booking.setPriorityScore(rs.getInt("priority_score"));
        int queuePosition = rs.getInt("queue_position");
        booking.setQueuePosition(rs.wasNull() ? null : queuePosition);
        booking.setVehiclePlate(rs.getString("license_plate"));
        booking.setTierName(rs.getString("tier_name"));
        return booking;
    }

    private void rollbackQuietly(Connection cn) {
        if (cn != null) {
            try {
                cn.rollback();
            } catch (Exception ignored) {
            }
        }
    }

    private void closeQuietly(Connection cn) {
        if (cn != null) {
            try {
                cn.setAutoCommit(true);
                cn.close();
            } catch (Exception ignored) {
            }
        }
    }
}
