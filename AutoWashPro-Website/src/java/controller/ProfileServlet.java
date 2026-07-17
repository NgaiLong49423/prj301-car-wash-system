package controller;

import dao.CustomerDAO;
import dao.LoyaltyDAO;
import dao.VehicleDAO;
import dto.Customer;
import dto.Vehicle;
import dto.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ProfileServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User account = session != null ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        try {
            int currentCustomerId = account.getId();

            // Refresh active 12-month loyalty data before displaying the profile.
            try {
                LoyaltyDAO loyaltyDAO = new LoyaltyDAO();
                loyaltyDAO.refreshExpiredPoints(currentCustomerId);
                loyaltyDAO.refreshActiveLoyaltyData(currentCustomerId);
            } catch (Exception refreshError) {
                LOGGER.log(Level.WARNING, "Could not refresh loyalty data for customerId=" + currentCustomerId, refreshError);
            }

            CustomerDAO cDao = new CustomerDAO();
            Customer profile = cDao.getCustomerProfile(currentCustomerId);

            if (profile != null && isBlank(account.getPhone()) && !isBlank(profile.getPhone())) {
                account.setPhone(profile.getPhone());
                session.setAttribute(AppKeys.SESSION_ACCOUNT, account);
            }

            VehicleDAO vDao = new VehicleDAO();
            ArrayList<Vehicle> listCars = vDao.getCars(currentCustomerId);

            String fullName = firstNonBlank(profile != null ? profile.getFullName() : null, account.getFullName(), "Chưa cập nhật tên");
            String phone = firstNonBlank(profile != null ? profile.getPhone() : null, account.getPhone(), "Chưa có SĐT");
            String email = firstNonBlank(profile != null ? profile.getEmail() : null, account.getEmail(), "Chưa có email");
            String tierName = firstNonBlank(profile != null ? profile.getTierName() : null, "Thành viên mới");
            String joinDate = profile != null && profile.getJoinDate() != null
                    ? new SimpleDateFormat("dd/MM/yyyy").format(profile.getJoinDate())
                    : "Chưa có";
            int totalPoints = profile != null ? profile.getTotalPoints() : account.getTotalPoints();
            BigDecimal totalSpentMoney = account.getTotalSpentMoney() != null ? account.getTotalSpentMoney() : BigDecimal.ZERO;
            String avatarInitial = !isBlank(fullName) ? fullName.substring(0, 1).toUpperCase() : "L";
            List<Vehicle> safeCars = listCars != null ? listCars : new ArrayList<Vehicle>();

            request.setAttribute(AppKeys.REQ_USER_PROFILE, profile);
            request.setAttribute(AppKeys.REQ_LIST_CARS, safeCars);
            request.setAttribute(AppKeys.REQ_USER_PHONE, phone);
            request.setAttribute(AppKeys.REQ_PROFILE_FULL_NAME, fullName);
            request.setAttribute(AppKeys.REQ_PROFILE_PHONE, phone);
            request.setAttribute(AppKeys.REQ_PROFILE_EMAIL, email);
            request.setAttribute(AppKeys.REQ_PROFILE_TIER_NAME, tierName);
            request.setAttribute(AppKeys.REQ_PROFILE_JOIN_DATE, joinDate);
            request.setAttribute(AppKeys.REQ_PROFILE_TOTAL_POINTS, totalPoints);
            request.setAttribute(AppKeys.REQ_PROFILE_TOTAL_SPENT_MONEY, totalSpentMoney);
            request.setAttribute(AppKeys.REQ_PROFILE_AVATAR_INITIAL, avatarInitial);
            request.setAttribute(AppKeys.REQ_PROFILE_TOTAL_CARS, safeCars.size());

            request.getRequestDispatcher("/profile.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load profile for customerId=" + account.getId(), e);
            response.sendRedirect(request.getContextPath() + "/MainController?action=ComingSoon");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String firstNonBlank(String primary, String fallback) {
        return firstNonBlank(primary, fallback, null);
    }

    private String firstNonBlank(String primary, String fallback, String defaultValue) {
        if (!isBlank(primary)) {
            return primary;
        }
        if (!isBlank(fallback)) {
            return fallback;
        }
        return defaultValue;
    }
}
