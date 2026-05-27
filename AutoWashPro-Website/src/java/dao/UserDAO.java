package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import dto.User;
import java.sql.SQLException;
import mylib.DBUtils;

public class UserDAO {

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    public User login(String email, String password) {

        String query = "SELECT * FROM Customer "
                + "WHERE email = ? AND password = ?";

        try {

            conn = DBUtils.getConnection();

            ps = conn.prepareStatement(query);

            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {

                return new User(
                        rs.getInt("customer_id"),
                        rs.getString("email"),
                        rs.getString("password")
                );
            }

        } catch (ClassNotFoundException | SQLException e) {

            e.printStackTrace();
        }

        return null;
    }
}
