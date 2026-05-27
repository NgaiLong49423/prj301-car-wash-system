package controller;

import dao.RewardDAO;
import dto.RewardDTO;

// Đổi toàn bộ jakarta thành javax
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "RewardServlet", urlPatterns = {"/rewards"})
public class RewardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Kiểm tra login
        if (session.getAttribute("userName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ Lấy tiền chi tiêu từ Session (từ LoginServlet)
        BigDecimal totalSpentMoneyObj = (BigDecimal) session.getAttribute("totalSpentMoney");
        long totalSpentMoney = totalSpentMoneyObj != null ? totalSpentMoneyObj.longValue() : 0L;
        
        // ✅ Tính điểm quy từ tiền: 1000 VND = 1 điểm
        int userPoints = (int) (totalSpentMoney / 1000);
        
        // ✅ Lấy danh sách phần thưởng từ Database
        RewardDAO dao = new RewardDAO();
        List<RewardDTO> rewardList = dao.getAllRewards();
        
        // ✅ BE tính toán memberTier dựa trên TIỀN CHI TIÊU (không phải điểm)
        // Ngưỡng: Member(0), Silver(2M), Gold(6M), Platinum(15M)
        String memberTier = "MEMBER";
        if (totalSpentMoney >= 15000000) {  // 15M VND
            memberTier = "PLATINUM";
        } else if (totalSpentMoney >= 6000000) {  // 6M VND
            memberTier = "GOLD";
        } else if (totalSpentMoney >= 2000000) {  // 2M VND
            memberTier = "SILVER";
        }
        
        // ✅ BE tính tierBenefit dựa trên memberTier
        String tierBenefit = "";
        switch(memberTier) {
            case "PLATINUM":
                tierBenefit = "(Được +30% điểm, miễn phí 1 lần rửa hàng tháng)";
                break;
            case "GOLD":
                tierBenefit = "(Được +20% điểm, Priority Slot)";
                break;
            case "SILVER":
                tierBenefit = "(Được +10% điểm, ưu tiên chọn slot)";
                break;
            default:
                tierBenefit = "(Được 1 điểm = 1,000 VND)";
        }
        
        
        // ✅ BE tính next TIER (cấp hạng) - ĐẠY LÀ THANH PROGRESS CHÍNH - dựa TIỀN
        String nextTierName = "";
        long nextTierMoneyNeeded = 0;  // Tiền cần để lên tier kế tiếp
        double tierProgressPercent = 100;
        long moneyToNextTier = 0;
        
        switch(memberTier) {
            case "MEMBER":
                nextTierName = "SILVER";
                nextTierMoneyNeeded = 2000000;  // 2M VND
                break;
            case "SILVER":
                nextTierName = "GOLD";
                nextTierMoneyNeeded = 6000000;  // 6M VND
                break;
            case "GOLD":
                nextTierName = "PLATINUM";
                nextTierMoneyNeeded = 15000000;  // 15M VND
                break;
            case "PLATINUM":
                nextTierName = "MAX";
                nextTierMoneyNeeded = 15000000;
                break;
        }
        
        if (!nextTierName.equals("MAX")) {
            tierProgressPercent = Math.min((double) totalSpentMoney / nextTierMoneyNeeded * 100, 100);
            moneyToNextTier = Math.max(nextTierMoneyNeeded - totalSpentMoney, 0);
        }
        
        // ✅ BE tính next REWARD (để reference sau này) - dựa ĐIỂM
        int nextRewardPoints = 0;
        String nextRewardName = "";
        double rewardProgressPercent = 100;
        int pointsNeededForReward = 0;
        
        if (rewardList != null && !rewardList.isEmpty()) {
            for (RewardDTO r : rewardList) {
                if (userPoints < r.getPointsRequired()) {
                    nextRewardPoints = r.getPointsRequired();
                    nextRewardName = r.getRewardName();
                    pointsNeededForReward = nextRewardPoints - userPoints;
                    rewardProgressPercent = (double) userPoints / nextRewardPoints * 100;
                    break;
                }
            }
        }
        
        // ✅ BE xác định icon dựa trên reward name
        java.util.Map<Integer, String> rewardIcons = new java.util.HashMap<>();
        if (rewardList != null) {
            int index = 0;
            for (RewardDTO r : rewardList) {
                String icon = "payments";
                String name = r.getRewardName();
                if (name.contains("Ceramic") || name.contains("Wax") || name.contains("Phủ")) {
                    icon = "format_paint";
                } else if (name.contains("nội thất")) {
                    icon = "cleaning_services";
                } else if (name.contains("rửa xe") || name.contains("Basic")) {
                    icon = "local_car_wash";
                }
                rewardIcons.put(index, icon);
                index++;
            }
        }

        // ✅ Gắn tất cả data vào Request (FE chỉ hiển thị, không tính toán)
        request.setAttribute("TOTAL_SPENT_MONEY", totalSpentMoney);  // ✅ Hiển thị tiền chi tiêu
        request.setAttribute("USER_POINTS", userPoints);             // ✅ Hiển thị điểm quy từ tiền
        request.setAttribute("REWARD_LIST", rewardList);
        request.setAttribute("REWARD_ICONS", rewardIcons);
        request.setAttribute("MEMBER_TIER", memberTier);
        request.setAttribute("TIER_BENEFIT", tierBenefit);
        
        // 🎯 THANH TIẾN TRÌNH CHÍNH = TIER PROGRESS (lên hạng dựa TIỀN CHI TIÊU)
        request.setAttribute("NEXT_REWARD_NAME", nextTierName);        // Hiển thị: "Lên hạng SILVER"
        request.setAttribute("NEXT_REWARD_POINTS", nextTierMoneyNeeded);    // Hiển thị: Tiền cần
        request.setAttribute("PROGRESS_PERCENT", tierProgressPercent); // Hiển thị: thanh progress %
        request.setAttribute("POINTS_NEEDED", moneyToNextTier);       // Hiển thị: "Còn X VND"
        
        // 📋 REWARD INFO (để reference hoặc sử dụng sau - dựa ĐIỂM)
        request.setAttribute("NEXT_REWARD_NAME_ALT", nextRewardName);
        request.setAttribute("NEXT_REWARD_POINTS_ALT", nextRewardPoints);
        request.setAttribute("REWARD_PROGRESS_PERCENT", rewardProgressPercent);
        request.setAttribute("POINTS_NEEDED_FOR_REWARD", pointsNeededForReward);
        
        request.setAttribute("NEXT_TIER_NAME", nextTierName);
        request.setAttribute("NEXT_TIER_POINTS", nextTierMoneyNeeded);
        request.setAttribute("TIER_PROGRESS_PERCENT", tierProgressPercent);
        request.setAttribute("MONEY_TO_NEXT_TIER", moneyToNextTier);

        // Forward sang rewards.jsp
        request.getRequestDispatcher("rewards.jsp").forward(request, response);
    }
}