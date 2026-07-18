package controller;

import dao.CustomerDAO;
import dao.RewardDAO;
import dao.UserBookingHistoryDAO;
import dto.BookingDTO;
import dto.Customer;
import dto.RewardDTO;
import dto.User;
import java.io.IOException;
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

@WebServlet(name = "DashboardServlet", urlPatterns = {"/DashboardServlet"})
public class DashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        User account = session != null ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
        
        // If not logged in or is an admin, just forward to dashboard.jsp (landing page or they get redirected by filter)
        if (account == null || "ADMIN".equals(account.getRoleName())) {
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            return;
        }

        try {
            int customerId = account.getId();
            
            // 1. Fetch Customer Profile for updated points and tier
            CustomerDAO customerDAO = new CustomerDAO();
            Customer profile = customerDAO.getCustomerProfile(customerId);
            
            // 2. Fetch Recent Bookings
            UserBookingHistoryDAO historyDAO = new UserBookingHistoryDAO();
            List<BookingDTO> bookingHistory = historyDAO.getBookingHistoryByCustomerId(customerId);
            // We only need top 3 for dashboard
            List<BookingDTO> recentBookings = bookingHistory.size() > 3 ? bookingHistory.subList(0, 3) : bookingHistory;
            
            // 3. Fetch Available Rewards
            RewardDAO rewardDAO = new RewardDAO();
            List<RewardDTO> rewards = rewardDAO.getAllRewards();
            List<RewardDTO> topRewards = rewards.size() > 3 ? rewards.subList(0, 3) : rewards;
            
            // Set attributes for JSP
            request.setAttribute("profile", profile);
            request.setAttribute("recentBookings", recentBookings);
            request.setAttribute("topRewards", topRewards);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading customer dashboard data", e);
        }
        
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
