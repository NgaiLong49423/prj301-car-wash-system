package Controller;

import dao.UserBookingHistoryDAO;
import dto.BookingDTO; 
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException; // Chuẩn javax cho Tomcat 9
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UserBookingHistoryServlet", urlPatterns = {"/UserBookingHistoryServlet"})
public class UserBookingHistoryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Giả lập customerId = 1 để hiển thị dữ liệu test chạy thử chức năng
            int customerId = 1; 
            
            UserBookingHistoryDAO historyDAO = new UserBookingHistoryDAO();
            String action = request.getParameter("action");
            
            if ("cancel".equals(action)) {
                String idStr = request.getParameter("bookingId");
                if (idStr != null) {
                    int bookingId = Integer.parseInt(idStr);
                    historyDAO.updateBookingStatus(bookingId, "cancel");
                }
                response.sendRedirect("UserBookingHistoryServlet?view=all");
                return;
            } else if ("checkin".equals(action)) {
                String idStr = request.getParameter("bookingId");
                if (idStr != null) {
                    int bookingId = Integer.parseInt(idStr);
                    historyDAO.updateBookingStatus(bookingId, "Completed");
                }
                response.sendRedirect("UserBookingHistoryServlet?view=all");
                return;
            }
            
            String view = request.getParameter("view");
            if ("washing".equals(view)) {
                List<BookingDTO> list = historyDAO.getWashingHistoryByCustomerId(customerId);
                request.setAttribute("WASHING_HISTORY", list);
                request.getRequestDispatcher("washing-history.jsp").forward(request, response);
            } else {
                List<BookingDTO> list = historyDAO.getBookingHistoryByCustomerId(customerId);
                request.setAttribute("BOOKING_HISTORY", list);
                request.getRequestDispatcher("booking-history.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            log("Error at UserBookingHistoryServlet: " + e.toString());
            response.sendRedirect("dashboard.jsp"); 
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