package dao;

import dto.CustomerProfileDTO;
import mylib.DBUtils;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CustomerDAO {
    
    // Hàm này sẽ nhận vào một con số (ID của khách) và trả về cái hộp (DTO) chứa thông tin của khách đó
    public CustomerProfileDTO getProfileById(int customerId) {
        CustomerProfileDTO profile = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;

        try {
            // 1. Gọi file của leader để mở kết nối với SQL
            conn = DBUtils.getConnection();
            
            if (conn != null) {
                // 2. Viết câu SQL gom 3 bảng lại (Customer, MembershipTier, Vehicle)
                String sql = "SELECT c.full_name, c.phone, v.license_plate, t.tier_name, c.total_points "
                           + "FROM Customer c "
                           + "LEFT JOIN MembershipTier t ON c.tier_id = t.tier_id "
                           + "LEFT JOIN Vehicle v ON c.customer_id = v.customer_id "
                           + "WHERE c.customer_id = ?";

                // 3. Đưa câu SQL vào hệ thống
                ptm = conn.prepareStatement(sql);
                ptm.setInt(1, customerId); // Lắp cái ID khách hàng vào chỗ dấu ?

                // 4. Chạy câu lệnh và hứng kết quả vào biến rs
                rs = ptm.executeQuery();

                // 5. Nếu đọc được dữ liệu từ SQL
                if (rs.next()) {
                    String fullName = rs.getString("full_name");
                    String phone = rs.getString("phone");
                    String licensePlate = rs.getString("license_plate");
                    String tierName = rs.getString("tier_name");
                    int totalPoints = rs.getInt("total_points");
                    
                    // Lỡ khách vừa tạo tài khoản, chưa cập nhật biển số hoặc chưa có hạng
                    if (licensePlate == null) { licensePlate = "Chưa có xe"; }
                    if (tierName == null) { tierName = "Thành viên Mới"; }

                    // Đóng gói 5 món này vào cái "hộp"
                    profile = new CustomerProfileDTO(fullName, phone, licensePlate, tierName, totalPoints);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra màn hình đen nếu có
        } finally {
            // 6. Dọn dẹp: Đóng cửa kết nối (Bắt buộc phải có để không sập server)
            try {
                if (rs != null) rs.close();
                if (ptm != null) ptm.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return profile; // Trả cái hộp lên cho phần giao diện dùng
    }
}