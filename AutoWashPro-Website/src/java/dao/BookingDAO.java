package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import mylib.DBUtils;

public class BookingDAO {

    public boolean createNewBooking(int customerId, int vehicleId, int serviceId, String bookingDate, String bookingTime, double price) {
        Connection cn = null;
        PreparedStatement psBooking = null;
        PreparedStatement psService = null;
        ResultSet rs = null;
        boolean isSuccess = false;

        try {
            // Đã cập nhật đúng hàm makeConnection() của nhóm bạn!
            cn = DBUtils.getConnection();
            
            if (cn != null) {
                cn.setAutoCommit(false);

                // 1. INSERT VÀO BẢNG BOOKING
                String sqlBooking = "INSERT INTO Booking (customer_id, vehicle_id, booking_date, booking_time, status, total_price) VALUES (?, ?, ?, ?, 'Pending', ?)";
                psBooking = cn.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS);
                psBooking.setInt(1, customerId);
                psBooking.setInt(2, vehicleId);
                psBooking.setString(3, bookingDate);
                psBooking.setString(4, bookingTime);
                psBooking.setDouble(5, price);
                
                int rowsAffected = psBooking.executeUpdate();

                // 2. INSERT VÀO BẢNG BOOKING_SERVICE
                if (rowsAffected > 0) {
                    rs = psBooking.getGeneratedKeys(); 
                    if (rs.next()) {
                        int newBookingId = rs.getInt(1); 
                        
                        String sqlService = "INSERT INTO BookingService (booking_id, service_id, quantity, price) VALUES (?, ?, 1, ?)";
                        psService = cn.prepareStatement(sqlService);
                        psService.setInt(1, newBookingId);
                        psService.setInt(2, serviceId);
                        psService.setDouble(3, price);
                        
                        psService.executeUpdate();
                        
                        isSuccess = true;
                        cn.commit(); 
                    }
                }
            }
        } catch (Exception e) {
            try { if (cn != null) cn.rollback(); } catch (Exception ex) {} 
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (psService != null) psService.close(); } catch (Exception e) {}
            try { if (psBooking != null) psBooking.close(); } catch (Exception e) {}
            try { if (cn != null) { cn.setAutoCommit(true); cn.close(); } } catch (Exception e) {}
        }
        return isSuccess;
    }
}