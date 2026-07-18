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

    public User login(String email, String password) {

        String query = "SELECT customer_id, full_name, phone, email, password, total_spent_money, total_points, role_name "
            + "FROM Customer WHERE email = ? AND password = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

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
                            rs.getInt("total_points"),
                            rs.getString("role_name")
                    );
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to authenticate user for email: {0}", email);
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        }

        return null;
    }
}
