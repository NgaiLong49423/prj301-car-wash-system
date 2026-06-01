package controller;

import dao.RewardDAO;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User account = session != null ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String displayName = resolveDisplayName(session, account);
        long totalSpentMoney = resolveTotalSpentMoney(session, account);
        int userPoints = resolveUserPoints(session, account, totalSpentMoney);

        RewardDAO dao = new RewardDAO();
        List<RewardDTO> rewardList = dao.getAllRewards();

        String memberTier = resolveMemberTier(totalSpentMoney);
        String tierBenefit = resolveTierBenefit(memberTier);
        TierProgress tierProgress = resolveTierProgress(memberTier, totalSpentMoney);
        RewardProgress rewardProgress = resolveRewardProgress(rewardList, userPoints);
        Map<Integer, String> rewardIcons = buildRewardIcons(rewardList);

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

    private String resolveDisplayName(HttpSession session, User account) {
        String displayName = session != null ? (String) session.getAttribute(AppKeys.SESSION_USER_DISPLAY_NAME) : null;
        if (isBlank(displayName)) {
            displayName = account.getFullName();
        }
        if (isBlank(displayName)) {
            displayName = account.getEmail();
        }
        return displayName;
    }

    private long resolveTotalSpentMoney(HttpSession session, User account) {
        BigDecimal totalSpentMoneyObj = session != null ? (BigDecimal) session.getAttribute(AppKeys.SESSION_TOTAL_SPENT_MONEY) : null;
        if (totalSpentMoneyObj == null) {
            totalSpentMoneyObj = account.getTotalSpentMoney();
        }
        return totalSpentMoneyObj != null ? totalSpentMoneyObj.longValue() : 0L;
    }

    private int resolveUserPoints(HttpSession session, User account, long totalSpentMoney) {
        Integer userPointsObj = session != null ? (Integer) session.getAttribute(AppKeys.SESSION_USER_POINTS) : null;
        int userPoints = userPointsObj != null ? userPointsObj : account.getTotalPoints();
        if (userPoints <= 0 && totalSpentMoney > 0) {
            userPoints = (int) (totalSpentMoney / 1000);
        }
        return userPoints;
    }

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

        double progressPercent = 100.0;
        long moneyToNextTier = 0L;
        if (!"MAX".equals(nextTierName)) {
            progressPercent = Math.min((double) totalSpentMoney / nextTierThreshold * 100.0, 100.0);
            moneyToNextTier = Math.max(nextTierThreshold - totalSpentMoney, 0L);
        }

        return new TierProgress(nextTierName, nextTierThreshold, progressPercent, moneyToNextTier);
    }

    private RewardProgress resolveRewardProgress(List<RewardDTO> rewardList, int userPoints) {
        if (rewardList == null || rewardList.isEmpty()) {
            return new RewardProgress("", 0, 100.0, 0);
        }

        for (RewardDTO reward : rewardList) {
            if (userPoints < reward.getPointsRequired()) {
                int nextRewardPoints = reward.getPointsRequired();
                return new RewardProgress(reward.getRewardName(), nextRewardPoints,
                        (double) userPoints / nextRewardPoints * 100.0,
                        nextRewardPoints - userPoints);
            }
        }

        return new RewardProgress("", 0, 100.0, 0);
    }

    private Map<Integer, String> buildRewardIcons(List<RewardDTO> rewardList) {
        Map<Integer, String> rewardIcons = new HashMap<>();
        if (rewardList == null) {
            return rewardIcons;
        }

        for (int index = 0; index < rewardList.size(); index++) {
            RewardDTO reward = rewardList.get(index);
            String icon = "payments";
            String name = reward.getRewardName() != null ? reward.getRewardName() : "";
            if (name.contains("Ceramic") || name.contains("Wax") || name.contains("Phủ")) {
                icon = "format_paint";
            } else if (name.contains("nội thất")) {
                icon = "cleaning_services";
            } else if (name.contains("rửa xe") || name.contains("Basic")) {
                icon = "local_car_wash";
            }
            rewardIcons.put(index, icon);
        }
        return rewardIcons;
    }

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