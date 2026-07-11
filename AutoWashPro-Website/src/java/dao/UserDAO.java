package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import dto.User;
import mylib.DBUtils;

public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());
    private String lastError;

    public User login(String email, String password) {

        lastError = null;

        try (Connection conn = DBUtils.getConnection()) {
            boolean hasRole = hasColumn(conn, "role_name");
            boolean hasActive = hasColumn(conn, "is_active");
            String query = "SELECT customer_id, full_name, phone, email, password, total_spent_money, total_points"
                    + (hasRole ? ", role_name" : "")
                    + " FROM Customer WHERE email = ? AND password = ?"
                    + (hasActive ? " AND is_active = 1" : "");

            try (PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("customer_id"),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getBigDecimal("total_spent_money"),
                            rs.getInt("total_points"), hasRole ? rs.getString("role_name") : "CUSTOMER"
                    );
                }
            }
            }
        } catch (ClassNotFoundException | SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to authenticate user for email: {0}", email);
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            lastError = "Không thể kết nối cơ sở dữ liệu. Vui lòng kiểm tra SQL Server và cấu hình JDBC.";
        }

        return null;
    }

    public String getLastError() {
        return lastError;
    }

    private boolean hasColumn(Connection conn, String columnName) throws SQLException {
        String sql = "SELECT COL_LENGTH('Customer', ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, columnName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getObject(1) != null;
            }
        }
    }
}
