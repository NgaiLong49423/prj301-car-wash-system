package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mylib.DBUtils;

public class LoyaltyDAO {

    // hàm kiểm tra sẽ xem booking đã đc cổng điểm chưa
    // Tại sao có hàm này: Để chống lỗi cộng điểm trùng. Khi khách hàng bấm
    // "Check-in" nhiều lần
    public boolean checkPointsEarned(int bookingId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM LoyaltyTransaction WHERE booking_id = ? AND transaction_type = 'Earned'";
        // Mở kết nối Database và chuẩn bị câu lệnh SQL
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Lấy ra con số đếm được ở cột đầu tiên (cột số 1)
                    int count = rs.getInt(1);

                    // Nếu count > 0 nghĩa là booking này đã được cộng điểm trước đó rồi
                    return count > 0;
                }
            }
        } catch (SQLException e) {
            // In chi tiết lỗi SQL ra màn hình Console của NetBeans để bạn debug
            System.err.println("--- LỖI tại checkPointsEarned (Mã lỗi: " + e.getErrorCode() + ") ---");
            e.printStackTrace(); // In ra toàn bộ dấu vết lỗi dòng nào, lỗi gì
        } catch (ClassNotFoundException e) {
            // Lỗi Driver kết nối database
            System.err.println("--- LỖI không tìm thấy Driver Database tại checkPointsEarned ---");
            e.printStackTrace();
        }
        return false;

    }

    // Mục đích: Thêm một dòng lịch sử mới vào bảng LoyaltyTransaction (ví dụ: cộng
    // điểm sau khi rửa xe, hoặc trừ điểm khi đổi quà).
    // Tại sao cần: Quy tắc nghiệp vụ yêu cầu mọi biến động điểm phải được lưu lại
    // lịch sử rõ ràng để khách hàng và Admin kiểm tra.
    public boolean insertTransaction(int customerId, Integer bookingId, int points, String transactionType)
            throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO LoyaltyTransaction (customer_id, booking_id, points, transaction_type, created_at) "
                + "VALUES (?, ?, ?, ?, GETDATE())";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);

            // Xử lý đặc biệt cho bookingId vì nó có thể bằng null (khi khách đổi quà)
            if (bookingId == null) {
                // Nếu bookingId là null, ta nạp giá trị NULL của SQL Server vào database
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                // Nếu có số bookingId cụ thể, ta nạp số đó vào database
                ps.setInt(2, bookingId);
            }
            ps.setInt(3, points);
            ps.setString(4, transactionType);

            // Chạy lệnh INSERT, nếu số dòng bị tác động (rows) > 0 nghĩa là ghi lịch sử
            // thành công
            int rows = ps.executeUpdate(); // câu lệnh trả về 1 số nguyên để cho người dùng biết bao nhiêu dòng dưới
            // database đã đc thay đổi
            return rows > 0;

        } catch (SQLException e) {
            // In chi tiết lỗi SQL (Ví dụ: Lỗi trùng Unique Index nếu bạn cố tình cộng điểm
            // lần 2)
            System.err.println("--- LỖI tại insertTransaction (Mã lỗi: " + e.getErrorCode() + ") ---");
            System.err.println("Thông điệp lỗi: " + e.getMessage());
            e.printStackTrace();

        } catch (ClassNotFoundException e) {
            System.err.println("--- LỖI không tìm thấy Driver Database tại insertTransaction ---");
            e.printStackTrace();
        }
        return false;
    }

    // (Cập nhật điểm và tiền tích lũy của khách hàng)
    // Mục đích: Cập nhật lại 2 cột total_points và total_spent_money trong bảng
    // Customer.
    // Tại sao cần:
    // Cộng dồn điểm mới vào tài khoản để khách hàng sử dụng.
    // Cộng dồn số tiền của đơn rửa xe vừa xong vào tổng chi tiêu để làm cơ sở xét
    // lên hạng thành viên.
    public boolean updateCustomerPointsAndSpent(int customerId, int pointsToAdd, double spentMoneyToAdd)
            throws SQLException, ClassNotFoundException {

        // Câu lệnh SQL: Cộng dồn điểm mới và số tiền rửa xe mới vào thông tin khách
        // hàng
        String sql = "UPDATE Customer "
                + "SET total_points = total_points + ?, "
                + "    total_spent_money = total_spent_money + ? "
                + "WHERE customer_id = ?";
        // Mở kết nối Database và chuẩn bị câu lệnh SQL
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            // Cộng thêm điểm: Truyền số điểm cần cộng vào dấu hỏi chấm (?) thứ nhất
            ps.setInt(1, pointsToAdd);
            // Cộng thêm tiền: Truyền số tiền chi tiêu mới vào dấu hỏi chấm (?) thứ hai
            ps.setDouble(2, spentMoneyToAdd);
            // Xác định khách hàng nào: Truyền customerId vào dấu hỏi chấm (?) thứ ba
            ps.setInt(3, customerId);
            // Chạy lệnh UPDATE, trả về true nếu cập nhật dữ liệu thành công
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("--- LỖI tại updateCustomerPointsAndSpent (Mã lỗi: " + e.getErrorCode() + ") ---");
            System.err.println("Thông điệp lỗi: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("--- LỖI không tìm thấy Driver Database tại updateCustomerPointsAndSpent ---");
            e.printStackTrace();
        }
        return false;
    }

    // (Cập nhật hạng mới cho khách hàng)
    // Mục đích: Thay đổi giá trị của cột tier_id của khách hàng trong bảng Customer
    // khi họ đủ điều kiện lên hạng mới.
    // Tại sao cần: Đây chính là cốt lõi của tính năng xét hạng tự động.
    // Khi khách hàng đổi sang hạng mới (ví dụ từ Member lên Silver), quyền lợi đặt
    // lịch và tích điểm của họ sẽ tự động thay đổi theo.
    public boolean updateCustomerTier(int customerId, int newTierId)
            throws SQLException, ClassNotFoundException {

        // Câu lệnh SQL: Thay đổi mã hạng thành viên (tier_id) của khách hàng
        String sql = "UPDATE Customer SET tier_id = ? WHERE customer_id = ?";
        // Mở kết nối Database và chuẩn bị câu lệnh SQL
        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            // Truyền mã hạng mới (tier_id mới) vào dấu hỏi chấm (?) thứ nhất
            ps.setInt(1, newTierId);
            // Truyền customerId vào dấu hỏi chấm (?) thứ hai
            ps.setInt(2, customerId);
            // Chạy lệnh UPDATE, trả về true nếu nâng/hạ hạng thành công
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("--- LỖI tại updateCustomerTier (Mã lỗi: " + e.getErrorCode() + ") ---");
            System.err.println("Thông điệp lỗi: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("--- LỖI không tìm thấy Driver Database tại updateCustomerTier ---");
            e.printStackTrace();
        }
        return false;
    }

    // Hàm lấy thông tin giá tiền và ID khách hàng của booking
    public dto.BookingDTO getBookingDetailForLoyalty(int bookingId) {
        String sql = "SELECT customer_id, total_price FROM Booking WHERE booking_id = ?";
        try (Connection conn = mylib.DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId)
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto.BookingDTO booking = new dto.BookingDTO();
                    booking.setCustomerId(rs.getInt("customer_id"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    return booking;
                }
            }
        } catch (Exception e) {
            System.err.println("--- LỖI tại getBookingDetailForLoyalty ---");
            e.printStackTrace();
        }
        return null;
    }

    // Hàm lấy số lần rửa và tổng tiền trong 12 tháng gần nhất để xét hạng
    public dto.Customer getCustomerLoyaltyData12Months(int customerId) {
        String sql = "SELECT COUNT(*) AS washes_12m, SUM(total_price) AS spent_12m "
                + "FROM Booking "
                + "WHERE customer_id = ? "
                + "  AND status = 'Completed' "
                + "  AND booking_date >= DATEADD(month, -12, GETDATE())";

        try (Connection conn = DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto.Customer cus = new dto.Customer();
                    cus.setCustomerId(customerId);
                    // Dùng tạm trường bookingWindowDays để chứa số lượt rửa 12 tháng
                    cus.setBookingWindowDays(rs.getInt("washes_12m"));
                    // Dùng tạm trường totalPoints để chứa tổng tiền 12 tháng (ép kiểu về int)
                    cus.setTotalPoints(rs.getInt("spent_12m"));
                    return cus;
                }
            }
        } catch (Exception e) {
            System.err.println("--- LỖI tại getCustomerLoyaltyData12Months ---");
            e.printStackTrace();
        }
        return null;
    }

    // Hàm xử lý nghiệp vụ tích điểm chính cho FR-09
    // Hàm xử lý nghiệp vụ tích điểm chính cho FR-09 (Đã bỏ hardcode)
    public boolean accumulatePoints(int bookingId) {
        try {
            // Bước 1: Kiểm tra xem booking này đã được cộng điểm trước đó chưa
            if (checkPointsEarned(bookingId)) {
                System.out.println("Booking này đã được cộng điểm trước đó. Bỏ qua!");
                return false;
            }

            // Bước 2: Lấy thông tin giá tiền và ID khách hàng của booking này
            dto.BookingDTO booking = getBookingDetailForLoyalty(bookingId);
            if (booking == null) {
                System.err.println("Không tìm thấy thông tin booking ID: " + bookingId);
                return false;
            }

            int customerId = booking.getCustomerId();
            double price = booking.getTotalPrice() != null ? booking.getTotalPrice().doubleValue() : 0.0;
            if (price <= 0) {
                System.err.println("Giá trị booking không hợp lệ để tích điểm: " + price);
                return false;
            }

            // Bước 3: Lấy thông tin hạng thành viên hiện tại của khách hàng
            CustomerDAO customerDAO = new CustomerDAO();
            dto.Customer customerProfile = customerDAO.getCustomerProfile(customerId);
            String tierName = customerProfile != null ? customerProfile.getTierName() : "Member";

            // BƯỚC THAY THẾ: Lấy tỷ lệ bonus trực tiếp từ database thông qua tên hạng
            double bonusRate = getBonusRateByTierName(tierName);

            // Bước 4: Tính toán điểm số nhận được
            int basePoints = (int) (price / 1000);
            int finalPoints = (int) (basePoints * (1 + bonusRate));

            // Bước 5: Thực hiện cộng điểm và ghi lịch sử
            boolean isLogged = insertTransaction(customerId, bookingId, finalPoints, "Earned");
            boolean isUpdated = updateCustomerPointsAndSpent(customerId, finalPoints, price);

            if (isLogged && isUpdated) {
                System.out.println("Tích điểm thành công cho khách hàng ID: " + customerId + " + " + finalPoints + " điểm (Tỷ lệ bonus: " + (bonusRate * 100) + "%).");
                return true;
            }

        } catch (Exception e) {
            System.err.println("--- LỖI tại accumulatePoints ---");
            e.printStackTrace();
        }
        return false;
    }

    // Hàm lấy tỷ lệ phần trăm bonus điểm của một hạng từ Database
    public double getBonusRateByTierName(String tierName) {
        // Trong bảng MembershipTier đã có sẵn cột discount_percent (dùng làm tỷ lệ bonus điểm)
        // Ví dụ: Silver là 10.00%, Gold là 20.00%, Platinum là 30.00%
        String sql = "SELECT discount_percent FROM MembershipTier WHERE tier_name = ?";

        try (Connection conn = mylib.DBUtils.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tierName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Lấy giá trị phần trăm (Ví dụ: 10.00 hoặc 20.00)
                    double percent = rs.getDouble("discount_percent");
                    // Đổi từ phần trăm sang số thập phân để tính toán (Ví dụ: 20.00% -> 0.20)
                    return percent / 100.0;
                }
            }
        } catch (Exception e) {
            System.err.println("--- LỖI tại getBonusRateByTierName ---");
            e.printStackTrace();
        }
        return 0.0; // Mặc định nếu lỗi hoặc là Member thường thì trả về 0.0
    }
}
