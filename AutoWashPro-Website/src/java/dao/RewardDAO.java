package dao;

import dto.RewardDTO;
import mylib.DBUtils; 

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RewardDAO {

    private static final Logger LOGGER = Logger.getLogger(RewardDAO.class.getName());

    // 1. Hàm lấy danh sách tất cả phần thưởng
    public List<RewardDTO> getAllRewards() {
        List<RewardDTO> list = new ArrayList<>();
        // Query (Câu truy vấn): Sắp xếp theo điểm tăng dần để lát nữa dễ tìm phần thưởng gần nhất
        String sql = "SELECT reward_id, reward_name, required_points, description FROM Reward ORDER BY required_points ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            // Loop (Vòng lặp) qua từng dòng data lấy được từ DB
            while (rs.next()) {
                RewardDTO reward = new RewardDTO(
                        rs.getInt("reward_id"),
                        rs.getString("reward_name"),
                        rs.getInt("required_points"),
                        rs.getString("description")
                );
                list.add(reward); // Nhét từng cái hộp vào danh sách
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load rewards", e);
        }
        return list;
    }

    // 2. Hàm tính điểm hiện tại của khách hàng dựa trên lịch sử giao dịch
    public int getCurrentPoints(int customerId) {
        int totalPoints = 0;
        /* Logic thực dụng: Theo Workshop, Điểm = Tổng cộng - Tổng tiêu.
           Trong bảng LoyaltyTransaction của em có cột transaction_type ('Earned', 'Spent').
           Ta dùng CASE WHEN trong SQL để cộng điểm nếu là 'Earned', và trừ điểm nếu là 'Spent'.
        */
        String sql = "SELECT SUM(CASE WHEN transaction_type = 'Earned' THEN points " +
                "                WHEN transaction_type = 'Spent' THEN -points " +
                "                ELSE 0 END) AS Balance " +
                "FROM LoyaltyTransaction " +
                "WHERE customer_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set tham số an toàn thay thế cho dấu "?" -> Chống SQL Injection (Tiêm nhiễm mã độc)
            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalPoints = rs.getInt("Balance");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to calculate points for customerId=" + customerId, e);
        }
        return totalPoints; // Trả về con số thực tế
    }
}