package dao;

import dto.Customer;
import dto.CustomerDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import mylib.DBUtils;

public class CustomerDAO {

    private static final Logger LOGGER = Logger.getLogger(CustomerDAO.class.getName());

    // Hàm kéo thông tin cá nhân và hạng thành viên
    public Customer getCustomerProfile(int customerId) {
        Customer cus = null;
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Lệnh JOIN bảng Customer và Tier theo đúng thiết kế của Leader
                // Thêm c.tier_id để lấy mã hạng thành viên chuẩn bị cho chức năng FR-06b: ràng
                // buộc thời gian đặt lịch theo hạng thành viên
                String sql = "SELECT c.customer_id, c.full_name, c.phone, c.email, c.join_date, c.total_points, c.tier_id, t.tier_name "
                        + "FROM Customer c "
                        + "LEFT JOIN MembershipTier t ON c.tier_id = t.tier_id "
                        + "WHERE c.customer_id = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, customerId);
                table = st.executeQuery();

                if (table.next()) {
                    cus = new Customer();
                    cus.setCustomerId(table.getInt("customer_id"));
                    cus.setFullName(table.getNString("full_name"));
                    cus.setPhone(table.getString("phone"));
                    cus.setEmail(table.getString("email"));
                    cus.setJoinDate(table.getDate("join_date"));
                    cus.setTotalPoints(table.getInt("total_points"));

                    String tier = table.getString("tier_name");
                    cus.setTierName(tier != null ? tier : "Thành viên mới");
                    // Lấy mã tier_id để chuẩn bị cho chức năng FR-06b: ràng buộc thời gian đặt lịch
                    // theo hạng thành viên
                    cus.setTierId(table.getInt("tier_id")); // Ngô Gia Long
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load customer profile for customerId=" + customerId, e);
        } finally {
            try {
                if (table != null)
                    table.close();
                if (st != null)
                    st.close();
                if (cn != null)
                    cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when loading customer profile", e);
            }
        }
        return cus;
    }

    public boolean isEmailExist(String email) throws ClassNotFoundException, SQLException {
        String sql = "SELECT customer_id FROM Customer WHERE email = ?";

        // Dùng cụm try-with-resources này để nó tự đóng kết nối khi chạy xong, đỡ bị
        // nghẽn DB
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

    public boolean registerCustomer(CustomerDTO customer) throws ClassNotFoundException, SQLException {
        // Chú ý: Từ [password] phải bọc trong ngoặc vuông kẻo bị dính trùng từ khóa của
        // SQL Server
        String sql = "INSERT INTO Customer (full_name, phone, email, [password], tier_id) VALUES (?, ?, ?, ?, ?)";
        int kết_quả = 0;

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            // Lần lượt lấy dữ liệu từ cục DTO gán vào các dấu chấm hỏi theo đúng thứ tự câu
            // lệnh SQL
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getPassword()); // Lưu text thường đồng bộ theo database mẫu của nhóm
            ps.setInt(5, customer.getTierId()); // Gán mã tier_id bằng 1 (mặc định ban đầu là hạng Member)

            kết_quả = ps.executeUpdate(); // Chạy lệnh INSERT, nó trả về số dòng được thêm thành công
        }
        return kết_quả > 0; // Nếu kết quả lớn hơn 0 nghĩa là insert thành công, trả về true
    }

}