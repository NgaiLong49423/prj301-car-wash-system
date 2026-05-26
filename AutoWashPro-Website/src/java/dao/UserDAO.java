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

    public User login(String username, String password) {

        String query = "SELECT * FROM users "
                + "WHERE username = ? AND password = ?";

        try {

            conn = DBUtils.getConnection();

            ps = conn.prepareStatement(query);

            ps.setString(1, username);
            ps.setString(2, password);

            rs = ps.executeQuery();

            while (rs.next()) {

                return new User(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3)
                );
            }

        } catch (ClassNotFoundException | SQLException e) {
        }

        return null;
    }
}