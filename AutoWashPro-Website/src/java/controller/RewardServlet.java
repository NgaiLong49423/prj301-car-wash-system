package controller;

import dao.RewardDAO;
import dao.LoyaltyDAO;
import dto.RewardDTO;
import dto.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

@WebServlet(name = "RewardServlet", urlPatterns = {"/rewards"})
public class RewardServlet extends HttpServlet {

    private static final long SILVER_THRESHOLD = 2_000_000L;
    private static final long GOLD_THRESHOLD = 6_000_000L;
    private static final long PLATINUM_THRESHOLD = 15_000_000L;

    /**
     * Xử lý request GET cho trang Rewards.
     * Input: lấy thông tin người dùng từ HttpSession (AppKeys.SESSION_ACCOUNT) và các giá trị cache trong session
     * (tên hiển thị, tổng chi tiêu, điểm tích lũy) nếu có.
     * Output: set đầy đủ dữ liệu hiển thị vào request scope và forward sang rewards.jsp.
     * DB: gọi RewardDAO#getAllRewards() để lấy danh sách phần thưởng từ bảng Reward.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User account = session != null ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
        if (account == null) {
            // Chưa đăng nhập thì chuyển về luồng Login để tránh truy cập trái phép trang rewards.
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        String displayName = resolveDisplayName(session, account);
        long totalSpentMoney = resolveTotalSpentMoney(session, account);
        int userPoints = resolveUserPoints(session, account, totalSpentMoney);

        // Refresh expiry first, then display the persisted spendable balance.
        try {
            LoyaltyDAO loyaltyDAO = new LoyaltyDAO();
            loyaltyDAO.refreshExpiredPoints(account.getId());
            loyaltyDAO.refreshActiveLoyaltyData(account.getId());
            userPoints = loyaltyDAO.getActivePointBalance(account.getId());
            session.setAttribute(AppKeys.SESSION_USER_POINTS, userPoints);
        } catch (Exception refreshError) {
            getServletContext().log("Could not refresh loyalty data for customerId=" + account.getId(), refreshError);
        }

        RewardDAO dao = new RewardDAO();
        // Lấy danh sách mốc phần thưởng từ DB để tính tiến độ đổi quà.
        List<RewardDTO> rewardList = dao.getAllRewards();

        String memberTier = resolveMemberTier(totalSpentMoney);
        String tierBenefit = resolveTierBenefit(memberTier);
        TierProgress tierProgress = resolveTierProgress(memberTier, totalSpentMoney);
        RewardProgress rewardProgress = resolveRewardProgress(rewardList, userPoints);
        Map<Integer, String> rewardIcons = buildRewardIcons(rewardList);

        // Đẩy toàn bộ dữ liệu đã chuẩn hóa sang request để JSP render.
        request.setAttribute(AppKeys.REQ_USER_DISPLAY_NAME, displayName);
        request.setAttribute(AppKeys.REQ_TOTAL_SPENT_MONEY, totalSpentMoney);
        request.setAttribute(AppKeys.REQ_USER_POINTS, userPoints);
        request.setAttribute(AppKeys.REQ_REWARD_LIST, rewardList);
        request.setAttribute(AppKeys.REQ_REWARD_ICONS, rewardIcons);
        request.setAttribute(AppKeys.REQ_MEMBER_TIER, memberTier);
        request.setAttribute(AppKeys.REQ_TIER_BENEFIT, tierBenefit);
        request.setAttribute(AppKeys.REQ_NEXT_REWARD_NAME, tierProgress.nextTierName);
        request.setAttribute(AppKeys.REQ_NEXT_REWARD_POINTS, tierProgress.nextTierThreshold);
        request.setAttribute(AppKeys.REQ_PROGRESS_PERCENT, tierProgress.progressPercent);
        request.setAttribute(AppKeys.REQ_POINTS_NEEDED, tierProgress.moneyToNextTier);
        request.setAttribute(AppKeys.REQ_NEXT_REWARD_NAME_ALT, rewardProgress.nextRewardName);
        request.setAttribute(AppKeys.REQ_NEXT_REWARD_POINTS_ALT, rewardProgress.nextRewardPoints);
        request.setAttribute(AppKeys.REQ_REWARD_PROGRESS_PERCENT, rewardProgress.progressPercent);
        request.setAttribute(AppKeys.REQ_POINTS_NEEDED_FOR_REWARD, rewardProgress.pointsNeeded);
        request.setAttribute(AppKeys.REQ_NEXT_TIER_NAME, tierProgress.nextTierName);
        request.setAttribute(AppKeys.REQ_NEXT_TIER_POINTS, tierProgress.nextTierThreshold);
        request.setAttribute(AppKeys.REQ_TIER_PROGRESS_PERCENT, tierProgress.progressPercent);
        request.setAttribute(AppKeys.REQ_MONEY_TO_NEXT_TIER, tierProgress.moneyToNextTier);

        request.getRequestDispatcher("/rewards.jsp").forward(request, response);
    }

    /**
     * Chuẩn hóa tên hiển thị của người dùng cho UI.
     * Input: ưu tiên đọc từ session (SESSION_USER_DISPLAY_NAME), fallback sang User trong session account.
     * Output: trả về displayName không rỗng theo thứ tự ưu tiên: session -> fullName -> email.
     * DB: không truy cập DB, xử lý hoàn toàn in-memory.
     */
    private String resolveDisplayName(HttpSession session, User account) {
        String displayName = session != null ? (String) session.getAttribute(AppKeys.SESSION_USER_DISPLAY_NAME) : null;
        // Nếu session chưa có tên hiển thị thì dùng fullName trong object account.
        if (isBlank(displayName)) {
            displayName = account.getFullName();
        }
        // Nếu fullName cũng rỗng thì fallback email để luôn có giá trị hiển thị.
        if (isBlank(displayName)) {
            displayName = account.getEmail();
        }
        return displayName;
    }

    /**
     * Xác định tổng tiền khách đã chi tiêu.
     * Input: ưu tiên BigDecimal từ session (SESSION_TOTAL_SPENT_MONEY), fallback sang account.getTotalSpentMoney().
     * Output: trả về long totalSpentMoney (>= 0), mặc định 0 nếu không có dữ liệu.
     * DB: không gọi DB trực tiếp trong hàm này.
     */
    private long resolveTotalSpentMoney(HttpSession session, User account) {
        BigDecimal totalSpentMoneyObj = session != null ? (BigDecimal) session.getAttribute(AppKeys.SESSION_TOTAL_SPENT_MONEY) : null;
        if (totalSpentMoneyObj == null) {
            // Session không cache thì dùng giá trị hiện có trong account.
            totalSpentMoneyObj = account.getTotalSpentMoney();
        }
        // Quy đổi BigDecimal sang long để đồng nhất với công thức chia mốc hạng.
        return totalSpentMoneyObj != null ? totalSpentMoneyObj.longValue() : 0L;
    }

    /**
     * Xác định điểm hiện tại của người dùng.
     * Input: ưu tiên SESSION_USER_POINTS, fallback account.getTotalPoints(), và nhận thêm totalSpentMoney để suy luận khi thiếu điểm.
     * Output: int userPoints dùng cho hiển thị và tính tiến độ đổi quà.
     * DB: không gọi DB, chỉ xử lý in-memory từ dữ liệu đã có.
     */
    private int resolveUserPoints(HttpSession session, User account, long totalSpentMoney) {
        Integer userPointsObj = session != null ? (Integer) session.getAttribute(AppKeys.SESSION_USER_POINTS) : null;
        int userPoints = userPointsObj != null ? userPointsObj : account.getTotalPoints();
        // Fallback nghiệp vụ: nếu chưa có điểm nhưng có chi tiêu thì tạm tính 1 điểm / 1,000 VND.
        if (userPoints <= 0 && totalSpentMoney > 0) {
            userPoints = (int) (totalSpentMoney / 1000);
        }
        return userPoints;
    }

    /**
     * Phân hạng thành viên theo tổng chi tiêu.
     * Input: totalSpentMoney (VND).
     * Output: MEMBER | SILVER | GOLD | PLATINUM.
     * Logic: so sánh ngưỡng từ cao xuống thấp để đảm bảo chọn đúng hạng cao nhất đạt được.
     */
    private String resolveMemberTier(long totalSpentMoney) {
        if (totalSpentMoney >= PLATINUM_THRESHOLD) {
            return "PLATINUM";
        }
        if (totalSpentMoney >= GOLD_THRESHOLD) {
            return "GOLD";
        }
        if (totalSpentMoney >= SILVER_THRESHOLD) {
            return "SILVER";
        }
        return "MEMBER";
    }

    /**
     * Trả về mô tả quyền lợi theo hạng thành viên.
     * Input: memberTier đã được resolve trước đó.
     * Output: chuỗi mô tả benefit để render trên UI.
     * DB: không truy cập DB.
     */
    private String resolveTierBenefit(String memberTier) {
        switch (memberTier) {
            case "PLATINUM":
                return "(Được +30% điểm, miễn phí 1 lần rửa hàng tháng)";
            case "GOLD":
                return "(Được +20% điểm, Priority Slot)";
            case "SILVER":
                return "(Được +10% điểm, ưu tiên chọn slot)";
            default:
                return "(Được 1 điểm = 1,000 VND)";
        }
    }

    /**
     * Tính tiến độ lên hạng tiếp theo.
     * Input: memberTier hiện tại và totalSpentMoney.
     * Output: TierProgress gồm tên hạng kế tiếp, mốc tiền kế tiếp, phần trăm tiến độ, và số tiền còn thiếu.
     * Công thức:
     * - progressPercent = min(totalSpentMoney / nextTierThreshold * 100, 100)
     * - moneyToNextTier = max(nextTierThreshold - totalSpentMoney, 0)
     * Nhánh đặc biệt: nếu đã PLATINUM thì nextTierName = MAX, progress = 100, moneyToNextTier = 0.
     */
    private TierProgress resolveTierProgress(String memberTier, long totalSpentMoney) {
        String nextTierName;
        long nextTierThreshold;

        switch (memberTier) {
            case "MEMBER":
                nextTierName = "SILVER";
                nextTierThreshold = SILVER_THRESHOLD;
                break;
            case "SILVER":
                nextTierName = "GOLD";
                nextTierThreshold = GOLD_THRESHOLD;
                break;
            case "GOLD":
                nextTierName = "PLATINUM";
                nextTierThreshold = PLATINUM_THRESHOLD;
                break;
            default:
                nextTierName = "MAX";
                nextTierThreshold = PLATINUM_THRESHOLD;
                break;
        }

        // Mặc định trạng thái "đã hoàn tất"; chỉ tính lại khi còn hạng kế tiếp.
        double progressPercent = 100.0;
        long moneyToNextTier = 0L;
        if (!"MAX".equals(nextTierName)) {
            // Chuẩn hóa phần trăm về tối đa 100 để tránh vượt mức khi dữ liệu lớn hơn mốc.
            progressPercent = Math.min((double) totalSpentMoney / nextTierThreshold * 100.0, 100.0);
            // Nếu đã vượt mốc thì phần còn thiếu phải là 0.
            moneyToNextTier = Math.max(nextTierThreshold - totalSpentMoney, 0L);
        }

        return new TierProgress(nextTierName, nextTierThreshold, progressPercent, moneyToNextTier);
    }

    /**
     * Tính tiến độ tới phần thưởng gần nhất chưa đạt.
     * Input: rewardList (đã sort tăng dần theo required_points từ DAO) và userPoints hiện tại.
     * Output: RewardProgress gồm tên quà gần nhất, điểm mốc cần đạt, phần trăm tiến độ, số điểm còn thiếu.
     * Logic:
     * - Duyệt từ mốc nhỏ đến lớn, gặp phần thưởng đầu tiên có required_points > userPoints thì dừng.
     * - progressPercent = userPoints / nextRewardPoints * 100.
     * - pointsNeeded = nextRewardPoints - userPoints.
     * - Nếu không còn mốc nào phía trước (đã đạt tất cả) thì trả tiến độ 100% và pointsNeeded = 0.
     */
    private RewardProgress resolveRewardProgress(List<RewardDTO> rewardList, int userPoints) {
        if (rewardList == null || rewardList.isEmpty()) {
            // Không có dữ liệu quà => coi như không còn mốc cần theo dõi.
            return new RewardProgress("", 0, 100.0, 0);
        }

        for (RewardDTO reward : rewardList) {
            if (userPoints < reward.getPointsRequired()) {
                int nextRewardPoints = reward.getPointsRequired();
                // Vì nextRewardPoints > userPoints, phần trăm luôn nằm trong [0, 100).
                return new RewardProgress(reward.getRewardName(), nextRewardPoints,
                        (double) userPoints / nextRewardPoints * 100.0,
                        nextRewardPoints - userPoints);
            }
        }

        // Người dùng đã vượt hoặc chạm mọi mốc phần thưởng hiện có.
        return new RewardProgress("", 0, 100.0, 0);
    }

    /**
     * Gán icon Material cho từng phần thưởng để hiển thị trực quan trên UI.
     * Input: rewardList lấy từ DB.
     * Output: Map<index, iconName> để JSP đọc theo vị trí item trong danh sách.
     * Logic in-memory: suy luận icon theo từ khóa trong rewardName, có icon mặc định nếu không match.
     */
    private Map<Integer, String> buildRewardIcons(List<RewardDTO> rewardList) {
        Map<Integer, String> rewardIcons = new HashMap<>();
        if (rewardList == null) {
            return rewardIcons;
        }

        for (int index = 0; index < rewardList.size(); index++) {
            RewardDTO reward = rewardList.get(index);
            String icon = "payments";
            String name = reward.getRewardName() != null ? reward.getRewardName() : "";
            // Ưu tiên nhóm dịch vụ chăm sóc sơn/phủ bề mặt.
            if (name.contains("Ceramic") || name.contains("Wax") || name.contains("Phủ")) {
                icon = "format_paint";
            // Nhóm dịch vụ vệ sinh nội thất.
            } else if (name.contains("nội thất")) {
                icon = "cleaning_services";
            // Nhóm rửa xe cơ bản.
            } else if (name.contains("rửa xe") || name.contains("Basic")) {
                icon = "local_car_wash";
            }
            rewardIcons.put(index, icon);
        }
        return rewardIcons;
    }

    /**
     * Kiểm tra chuỗi rỗng/null phục vụ các hàm chuẩn hóa dữ liệu hiển thị.
     */
    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private static final class TierProgress {
        private final String nextTierName;
        private final long nextTierThreshold;
        private final double progressPercent;
        private final long moneyToNextTier;

        private TierProgress(String nextTierName, long nextTierThreshold, double progressPercent, long moneyToNextTier) {
            this.nextTierName = nextTierName;
            this.nextTierThreshold = nextTierThreshold;
            this.progressPercent = progressPercent;
            this.moneyToNextTier = moneyToNextTier;
        }
    }

    private static final class RewardProgress {
        private final String nextRewardName;
        private final int nextRewardPoints;
        private final double progressPercent;
        private final int pointsNeeded;

        private RewardProgress(String nextRewardName, int nextRewardPoints, double progressPercent, int pointsNeeded) {
            this.nextRewardName = nextRewardName;
            this.nextRewardPoints = nextRewardPoints;
            this.progressPercent = progressPercent;
            this.pointsNeeded = pointsNeeded;
        }
    }
}
