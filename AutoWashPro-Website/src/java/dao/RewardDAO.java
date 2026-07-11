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

    /**
     * Lấy toàn bộ danh sách phần thưởng từ database.
     * Input: không nhận tham số từ ngoài.
     * Output: List<RewardDTO> đã map từ bảng Reward, sắp xếp tăng dần theo required_points
     * để thuận tiện cho việc xác định mốc phần thưởng kế tiếp ở tầng controller.
     * DB: SELECT reward_id, reward_name, required_points, description FROM Reward.
     */
    public List<RewardDTO> getAllRewards() {
        List<RewardDTO> list = new ArrayList<>();
        // Sắp xếp theo điểm tăng dần để phía trên có thể duyệt và tìm "mốc chưa đạt đầu tiên".
        String sql = "SELECT reward_id, reward_name, required_points, description, reward_type, reward_value, valid_days, is_active FROM Reward WHERE is_active=1 ORDER BY required_points ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            // Map từng dòng dữ liệu DB thành RewardDTO và thêm vào danh sách kết quả.
            while (rs.next()) {
                RewardDTO reward = new RewardDTO(
                        rs.getInt("reward_id"),
                        rs.getString("reward_name"),
                        rs.getInt("required_points"),
                        rs.getString("description")
                );
                reward.setRewardType(rs.getString("reward_type"));
                reward.setRewardValue(rs.getBigDecimal("reward_value"));
                reward.setValidDays(rs.getInt("valid_days"));
                reward.setActive(rs.getBoolean("is_active"));
                list.add(reward);
            }
        } catch (Exception e) {
            // Ghi log lỗi để theo dõi sự cố truy vấn, đồng thời trả list rỗng để tránh crash luồng UI.
            LOGGER.log(Level.SEVERE, "Failed to load rewards", e);
        }
        return list;
    }

    /**
     * Tính số điểm hiện tại của khách hàng dựa trên lịch sử giao dịch loyalty.
     * Input: customerId lấy từ tầng nghiệp vụ/controller.
     * Output: tổng điểm thực nhận (có thể bằng 0 nếu chưa có giao dịch).
     * DB: đọc bảng LoyaltyTransaction theo customer_id, áp dụng công thức:
     * - Earned  -> cộng points
     * - Spent   -> trừ points
     * - Khác loại -> cộng 0
     * Tổng kết bằng SUM(CASE WHEN ... END).
     */
    /*public int getCurrentPoints(int customerId) {
        int totalPoints = 0;
        // Điểm cuối = tổng Earned - tổng Spent, tính trực tiếp trên DB để tránh sai lệch khi gom dữ liệu ở Java.
        String sql = "SELECT SUM(CASE WHEN transaction_type = 'Earned' THEN points " +
                "                WHEN transaction_type = 'Spent' THEN -points " +
                "                ELSE 0 END) AS Balance " +
                "FROM LoyaltyTransaction " +
                "WHERE customer_id = ?";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Bind tham số cho dấu '?' để lọc đúng khách hàng và tránh SQL Injection.
            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Nếu không có dòng dữ liệu, getInt sẽ trả 0 theo mặc định cho cột số.
                    totalPoints = rs.getInt("Balance");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to calculate points for customerId=" + customerId, e);
        }
        return totalPoints;
    }
*/
}
