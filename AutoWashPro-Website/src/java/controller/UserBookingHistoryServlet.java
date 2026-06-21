package controller;

import dao.UserBookingHistoryDAO;
import dto.BookingDTO;
import dto.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

@WebServlet(name = "UserBookingHistoryServlet", urlPatterns = {"/UserBookingHistoryServlet"})
public class UserBookingHistoryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy session và kiểm tra đăng nhập bằng AppKeys
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppKeys.SESSION_ACCOUNT) == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        // 2. Lấy đối tượng User từ Session bằng AppKeys
        User user = (User) session.getAttribute(AppKeys.SESSION_ACCOUNT);
        int customerId = user.getId(); 

        try {
            UserBookingHistoryDAO historyDAO = new UserBookingHistoryDAO();
            
            // Lấy tham số subAction để tránh đè lên tham số 'action' của MainController
            String subAction = request.getParameter("subAction"); 
            String view = request.getParameter("view");

            // 3. Xử lý logic Cancel/Checkin bằng subAction công khai
            if ("cancel".equals(subAction)) {
                String idStr = request.getParameter("bookingId");
                if (idStr != null) {
                    historyDAO.updateBookingStatus(Integer.parseInt(idStr), "cancel");
                }
                // Quay về MainController để giữ đúng cấu trúc Filter/Routing tập trung
                response.sendRedirect(request.getContextPath() + "/MainController?action=BookingHistory&view=" + view);
                return;
            } else if ("checkin".equals(subAction)) {
                String idStr = request.getParameter("bookingId");
                if (idStr != null) {
                    historyDAO.updateBookingStatus(Integer.parseInt(idStr), "Completed");
                }
                response.sendRedirect(request.getContextPath() + "/MainController?action=WashingHistory&view=washing");
                return;
            }

            // 4. Xử lý hiển thị view dựa trên 'action' gốc từ MainController truyền xuống
            String mainAction = request.getParameter("action");

            if ("WashingHistory".equals(mainAction) || "washing".equals(view)) {
                // Hiển thị lịch sử các dịch vụ đã hoàn thành (Completed)
                List<BookingDTO> list = historyDAO.getWashingHistoryByCustomerId(customerId);
                request.setAttribute("WASHING_HISTORY", list);
                request.getRequestDispatcher("washing-history.jsp").forward(request, response);
            } else {
                // Mặc định hiển thị tất cả lịch sử đặt lịch (BookingHistory)
                List<BookingDTO> list = historyDAO.getBookingHistoryByCustomerId(customerId);
                request.setAttribute("BOOKING_HISTORY", list);
                request.getRequestDispatcher("booking-history.jsp").forward(request, response);
            }

        } catch (Exception e) {
            log("Error at UserBookingHistoryServlet: " + e.toString());
            request.setAttribute(AppKeys.REQ_ERROR, "An error occurred while loading your history.");
            // Chuyển hướng an toàn nếu lỗi
            response.sendRedirect(request.getContextPath() + "/MainController?action=Dashboard");
        }
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