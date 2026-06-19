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
import java.sql.Savepoint;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
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

        BigDecimal totalPrice = calculateTotalPrice(services);

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

            int bookingId = insertBooking(cn, customerId, vehicleId, bookingDate, bookingTime, "PENDING", totalPrice);
            insertBookingServices(cn, bookingId, services);

            Savepoint beforeHiddenPriority = cn.setSavepoint("beforeHiddenPriority");
            try {
                new HiddenPriorityBookingDAO().applyPriority(cn, bookingId);
            } catch (Exception hiddenPriorityError) {
                cn.rollback(beforeHiddenPriority);
                LOGGER.log(Level.WARNING, "Hidden priority booking is not applied for bookingId=" + bookingId, hiddenPriorityError);
            }

            String status = getBookingStatus(cn, bookingId);
            if (status == null || status.trim().isEmpty()) {
                status = "PENDING";
            }
            cn.commit();

            if ("CONFIRMED".equalsIgnoreCase(status) || "BACKUP_CONFIRMED".equalsIgnoreCase(status)) {
                return new BookingResultDTO(true, status, "Dat lich thanh cong. Lich cua ban da duoc xac nhan.", bookingId, null);
            }
            if ("WAITING".equalsIgnoreCase(status)) {
                return new BookingResultDTO(true, status, "Dat lich thanh cong. Ban dang o danh sach cho.", bookingId, null);
            }
            return new BookingResultDTO(true, status, "Dat lich thanh cong. He thong da ghi nhan lich cua ban.", bookingId, null);
        } catch (Exception e) {
            rollbackQuietly(cn);
            LOGGER.log(Level.SEVERE, "Failed to create priority booking", e);
            int[] fallbackServiceIds = serviceIdsFromServices(services);
            int fallbackBookingId = createNewBooking(customerId, vehicleId, fallbackServiceIds, bookingDate, bookingTime, totalPrice);
            if (fallbackBookingId > 0) {
                return new BookingResultDTO(true, "PENDING",
                        "Dat lich thanh cong. He thong da ghi nhan lich cua ban.", fallbackBookingId, null);
            }
            return new BookingResultDTO(false, "ERROR", "He thong dang ban, vui long thu lai sau.", 0, null);
        } finally {
            closeQuietly(cn);
        }
    }

    public boolean createNewBooking(int customerId, int vehicleId, int serviceId, String bookingDateStr, String bookingTimeStr, double price) {
        String bookingSql = "INSERT INTO Booking (customer_id, vehicle_id, booking_date, booking_time, status, total_price) "
                + "VALUES (?, ?, ?, ?, 'PENDING', ?)";
        String serviceSql = "INSERT INTO BookingService (booking_id, service_id, quantity, price) VALUES (?, ?, 1, ?)";

        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            cn.setAutoCommit(false);

            int bookingId = 0;
            try (PreparedStatement st = cn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
                st.setInt(1, customerId);
                st.setInt(2, vehicleId);
                st.setString(3, bookingDateStr);
                st.setString(4, bookingTimeStr);
                st.setDouble(5, price);

                int rowsAffected = st.executeUpdate();
                if (rowsAffected <= 0) {
                    cn.rollback();
                    return false;
                }

                try (ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) {
                        bookingId = keys.getInt(1);
                    }
                }
            }

            if (bookingId <= 0) {
                cn.rollback();
                return false;
            }

            try (PreparedStatement st = cn.prepareStatement(serviceSql)) {
                st.setInt(1, bookingId);
                st.setInt(2, serviceId);
                st.setDouble(3, price);
                st.executeUpdate();
            }

            Savepoint beforeHiddenPriority = cn.setSavepoint("beforeHiddenPriority");
            try {
                new HiddenPriorityBookingDAO().applyPriority(cn, bookingId);
            } catch (Exception hiddenPriorityError) {
                cn.rollback(beforeHiddenPriority);
                LOGGER.log(Level.WARNING, "Hidden priority booking is not applied for bookingId=" + bookingId, hiddenPriorityError);
            }

            cn.commit();
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to create new booking", e);
            rollbackQuietly(cn);
            return false;
        } finally {
            closeQuietly(cn);
        }
    }

    public List<BookingDTO> getRecentBookingsByCustomer(int customerId) {
        List<BookingDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 10 b.booking_id, b.customer_id, b.vehicle_id, b.booking_date, b.booking_time, "
                + "b.status, b.total_price, v.license_plate, mt.tier_name, "
                + "pa.slot_type, pa.slot_order "
                + "FROM Booking b "
                + "JOIN Vehicle v ON b.vehicle_id = v.vehicle_id "
                + "JOIN Customer c ON b.customer_id = c.customer_id "
                + "LEFT JOIN MembershipTier mt ON c.tier_id = mt.tier_id "
                + "LEFT JOIN BookingPriorityAllocation pa ON b.booking_id = pa.booking_id "
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
            LOGGER.log(Level.WARNING, "Failed to load priority booking detail. Loading simple recent bookings instead.", e);
            list = getSimpleRecentBookingsByCustomer(customerId);
        }
        return list;
    }

    private List<BookingDTO> getSimpleRecentBookingsByCustomer(int customerId) {
        List<BookingDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 10 b.booking_id, b.customer_id, b.vehicle_id, b.booking_date, b.booking_time, "
                + "b.status, b.total_price, v.license_plate, mt.tier_name "
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
                    list.add(mapSimpleBooking(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load simple customer bookings", e);
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
        String sql = "SELECT COUNT(*) FROM Booking WHERE customer_id = ? AND UPPER(status) IN ('PENDING','CONFIRMED','BACKUP_CONFIRMED','WAITING','WAITLIST')";
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
                + "AND UPPER(status) IN ('PENDING','CONFIRMED','BACKUP_CONFIRMED','WAITING','WAITLIST') "
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
            String status, BigDecimal totalPrice) throws Exception {
        String sql = "INSERT INTO Booking(customer_id, vehicle_id, booking_date, booking_time, status, total_price) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, customerId);
            st.setInt(2, vehicleId);
            st.setDate(3, bookingDate);
            st.setTime(4, bookingTime);
            st.setString(5, status);
            st.setBigDecimal(6, totalPrice);
            st.executeUpdate();

            try (ResultSet keys = st.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new IllegalStateException("Cannot create booking id");
    }

    private String getBookingStatus(Connection cn, int bookingId) throws Exception {
        String sql = "SELECT status FROM Booking WHERE booking_id = ?";
        try (PreparedStatement st = cn.prepareStatement(sql)) {
            st.setInt(1, bookingId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    return status != null && !status.trim().isEmpty() ? status : "PENDING";
                }
            }
        }
        return "PENDING";
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

    private int[] serviceIdsFromServices(List<ServiceDTO> services) {
        if (services == null || services.isEmpty()) {
            return new int[0];
        }
        int[] ids = new int[services.size()];
        for (int i = 0; i < services.size(); i++) {
            ids[i] = services.get(i).getServiceId();
        }
        return ids;
    }

    private int createNewBooking(int customerId, int vehicleId, int[] serviceIds, Date bookingDate, Time bookingTime, BigDecimal price) {
        String bookingSql = "INSERT INTO Booking (customer_id, vehicle_id, booking_date, booking_time, status, total_price) "
                + "VALUES (?, ?, ?, ?, 'PENDING', ?)";
        String serviceSql = "INSERT INTO BookingService (booking_id, service_id, quantity, price) VALUES (?, ?, 1, ?)";

        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            cn.setAutoCommit(false);

            int bookingId = 0;
            try (PreparedStatement st = cn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
                st.setInt(1, customerId);
                st.setInt(2, vehicleId);
                st.setDate(3, bookingDate);
                st.setTime(4, bookingTime);
                st.setBigDecimal(5, price);

                int rowsAffected = st.executeUpdate();
                if (rowsAffected <= 0) {
                    cn.rollback();
                    return 0;
                }

                try (ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) {
                        bookingId = keys.getInt(1);
                    }
                }
            }

            if (bookingId <= 0) {
                cn.rollback();
                return 0;
            }

            try (PreparedStatement st = cn.prepareStatement(serviceSql)) {
                for (int serviceId : serviceIds) {
                    st.setInt(1, bookingId);
                    st.setInt(2, serviceId);
                    st.setBigDecimal(3, price);
                    st.addBatch();
                }
                st.executeBatch();
            }

            Savepoint beforeHiddenPriority = cn.setSavepoint("beforeHiddenPriority");
            try {
                new HiddenPriorityBookingDAO().applyPriority(cn, bookingId);
            } catch (Exception hiddenPriorityError) {
                cn.rollback(beforeHiddenPriority);
                LOGGER.log(Level.WARNING, "Hidden priority booking is not applied for bookingId=" + bookingId, hiddenPriorityError);
            }

            cn.commit();
            return bookingId;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to create fallback booking", e);
            rollbackQuietly(cn);
            return 0;
        } finally {
            closeQuietly(cn);
        }
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
        String slotType = rs.getString("slot_type");
        int slotOrder = rs.getInt("slot_order");
        if ("WAITING".equalsIgnoreCase(slotType) && !rs.wasNull()) {
            booking.setQueuePosition(slotOrder);
        }
        booking.setVehiclePlate(rs.getString("license_plate"));
        booking.setTierName(rs.getString("tier_name"));
        return booking;
    }

    private BookingDTO mapSimpleBooking(ResultSet rs) throws Exception {
        BookingDTO booking = new BookingDTO();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setCustomerId(rs.getInt("customer_id"));
        booking.setVehicleId(rs.getInt("vehicle_id"));
        booking.setBookingDate(rs.getDate("booking_date"));
        booking.setBookingTime(rs.getTime("booking_time"));
        booking.setStatus(rs.getString("status"));
        booking.setTotalPrice(rs.getBigDecimal("total_price"));
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
