package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import dto.CustomerDTO;
import mylib.DBUtils; // Gọi đến file kết nối DB chung của nhóm mình trong mục mylib

public class CustomerDAO {

    // Hàm check xem email người ta nhập vào form đăng ký đã có ai dùng chưa
    public boolean isEmailExist(String email) throws ClassNotFoundException, SQLException {
        String sql = "SELECT customer_id FROM Customer WHERE email = ?";
        
        // Dùng cụm try-with-resources này để nó tự đóng kết nối khi chạy xong, đỡ bị nghẽn DB
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email); // Nhét cái email cần check vào chỗ dấu chấm hỏi
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true; // Nếu rải lệnh ra mà thấy có dòng dữ liệu -> Email bị trùng rồi
                }
            }
        }
        return false; // Đi hết khối lệnh mà không thấy gì tức là email sạch, dùng được
    }

    // Hàm này check trùng số điện thoại, logic chạy y hệt như hàm check email ở trên
    public boolean isPhoneExist(String phone) throws ClassNotFoundException, SQLException {
        String sql = "SELECT customer_id FROM Customer WHERE phone = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return true; // Số điện thoại này có người đăng ký mất rồi
                }
            }
        }
        return false;
    }

    // Hàm chính để bắn thông tin tài khoản mới xuống bảng Customer trong SQL Server
    public boolean registerCustomer(CustomerDTO customer) throws ClassNotFoundException, SQLException {
        // Chú ý: Từ [password] phải bọc trong ngoặc vuông kẻo bị dính trùng từ khóa của SQL Server
        String sql = "INSERT INTO Customer (full_name, phone, email, [password], tier_id) VALUES (?, ?, ?, ?, ?)";
        int kết_quả = 0;
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Lần lượt lấy dữ liệu từ cục DTO gán vào các dấu chấm hỏi theo đúng thứ tự câu lệnh SQL
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getPassword()); // Lưu text thường đồng bộ theo database mẫu của nhóm
            ps.setInt(5, customer.getTierId());      // Gán mã tier_id bằng 1 (mặc định ban đầu là hạng Member)

            kết_quả = ps.executeUpdate(); // Chạy lệnh INSERT, nó trả về số dòng được thêm thành công
        }
        return kết_quả > 0; // Nếu kết quả lớn hơn 0 nghĩa là insert thành công, trả về true
    }
}