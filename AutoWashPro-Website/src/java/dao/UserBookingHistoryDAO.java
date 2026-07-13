package dao;

import dto.BookingDTO; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import mylib.DBUtils; 

public class UserBookingHistoryDAO {

    public List<BookingDTO> getBookingHistoryByCustomerId(int customerId) throws SQLException, ClassNotFoundException {
        List<BookingDTO> list = new ArrayList<BookingDTO>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                 String sql = "SELECT booking_id, booking_date, booking_time, vehicle_id, status, total_price, final_amount, loyalty_points_awarded "
                           + "FROM Booking WHERE customer_id = ? "
                           + "ORDER BY booking_date DESC, booking_time DESC";
                ptm = conn.prepareStatement(sql);
                ptm.setInt(1, customerId);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    BookingDTO booking = new BookingDTO();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setBookingDate(rs.getDate("booking_date"));
                    booking.setBookingTime(rs.getTime("booking_time"));
                    booking.setVehicleId(rs.getInt("vehicle_id"));
                    booking.setStatus(rs.getString("status"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setFinalAmount(rs.getBigDecimal("final_amount"));
                    booking.setLoyaltyPointsAwarded(rs.getBoolean("loyalty_points_awarded"));
                    list.add(booking);
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return list;
    }

    public List<BookingDTO> getWashingHistoryByCustomerId(int customerId) throws SQLException, ClassNotFoundException {
        List<BookingDTO> list = new ArrayList<BookingDTO>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                 String sql = "SELECT booking_id, booking_date, booking_time, vehicle_id, status, total_price, final_amount, loyalty_points_awarded "
                           + "FROM Booking WHERE customer_id = ? AND status = 'COMPLETED' "
                           + "ORDER BY booking_date DESC, booking_time DESC";
                ptm = conn.prepareStatement(sql);
                ptm.setInt(1, customerId);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    BookingDTO booking = new BookingDTO();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setBookingDate(rs.getDate("booking_date"));
                    booking.setBookingTime(rs.getTime("booking_time"));
                    booking.setVehicleId(rs.getInt("vehicle_id"));
                    booking.setStatus(rs.getString("status"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setFinalAmount(rs.getBigDecimal("final_amount"));
                    booking.setLoyaltyPointsAwarded(rs.getBoolean("loyalty_points_awarded"));
                    list.add(booking);
                }
            }
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return list;
    }

    public boolean updateBookingStatus(int bookingId, String newStatus) throws SQLException, ClassNotFoundException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                String sql = "UPDATE Booking SET status = ? WHERE booking_id = ?";
                ptm = conn.prepareStatement(sql);
                ptm.setString(1, newStatus);
                ptm.setInt(2, bookingId);
                check = ptm.executeUpdate() > 0;
            }
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return check;
    }
}
