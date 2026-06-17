package controller;

import dao.BookingDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CreateBookingServlet", urlPatterns = {"/CreateBookingServlet"})
public class CreateBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1.ID khách hàng đang đăng nhâp
            int customerId = 2; 

            // 2. Lấy danh sách xe của khách hàng này từ VehicleDAO
            dao.VehicleDAO vehicleDao = new dao.VehicleDAO();
            java.util.List<dto.Vehicle> listVehicles = vehicleDao.getCars(customerId);
            
            // 3. Truyền danh sách xe sang JSP để vòng lặp JSTL in ra
            request.setAttribute("listVehicles", listVehicles);

            // 4. Bắt ID xe được truyền từ trang Profile (nếu khách bấm nút "Đặt lịch rửa xe này")
            String selectedVehicleId = request.getParameter("selectedVehicleId");
            if (selectedVehicleId != null) {
                request.setAttribute("selectedVehicleId", selectedVehicleId);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 5. Mở cánh cửa sang trang giao diện
        request.getRequestDispatcher("booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 1. Lấy dữ liệu từ JSP
        String vehicleIdStr = request.getParameter("vehicleId");
        String serviceIdStr = request.getParameter("serviceId");
        String bookingDateStr = request.getParameter("bookingDate");
        String bookingTimeStr = request.getParameter("bookingTime");

        // 2. Giả lập Hạng (Tier) và ID của khách hàng
        int tierId = 1;
        int customerId = 2; 
        try {
            LocalDate bookingDate = LocalDate.parse(bookingDateStr);
            LocalTime bookingTime = LocalTime.parse(bookingTimeStr); // Lấy giờ khách chọn
            
            LocalDate today = LocalDate.now();
            LocalTime now = LocalTime.now(); // Lấy giờ hiện tại
            
            long daysBetween = ChronoUnit.DAYS.between(today, bookingDate);

            // Bắt lỗi ngày quá khứ
            if (daysBetween < 0) {
                request.setAttribute("error", "Lỗi: Không thể đặt lịch vào ngày trong quá khứ!");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            // [BUG FIX]: Bắt lỗi giờ quá khứ nếu khách đặt lịch trong ngày hôm nay
            if (daysBetween == 0 && bookingTime.isBefore(now)) {
                request.setAttribute("error", "Lỗi: Thời gian này đã qua. Vui lòng chọn khung giờ khác trong hôm nay!");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            // 3. Logic: Giới hạn ngày theo Hạng 
            int maxDaysAllowed = 0;
            String tierName = "";
            switch (tierId) {
                case 1: maxDaysAllowed = 7; tierName = "Member"; break;
                case 2: maxDaysAllowed = 10; tierName = "Silver"; break;
                case 3: maxDaysAllowed = 12; tierName = "Gold"; break;
                case 4: maxDaysAllowed = 14; tierName = "Platinum"; break;
            }

            // Bắt lỗi vượt số ngày quy định
            if (daysBetween > maxDaysAllowed) {
                request.setAttribute("error", "Quyền lợi Hạng " + tierName + " chỉ được đặt trước tối đa " + maxDaysAllowed + " ngày!");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            // 4. Gọi DAO lưu vào Database
            int vehicleId = Integer.parseInt(vehicleIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);
            double price = (serviceId == 1) ? 100000 : 1500000; 

            BookingDAO dao = new BookingDAO();
            boolean isSuccess = dao.createNewBooking(customerId, vehicleId, serviceId, bookingDateStr, bookingTimeStr, price);

            if (isSuccess) {
                request.setAttribute("success", "🎉 Đặt lịch thành công! Vui lòng đến đúng giờ.");
            } else {
                request.setAttribute("error", "Lỗi hệ thống: Không thể lưu vào Database!");
            }

            request.getRequestDispatcher("booking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi dữ liệu: Vui lòng kiểm tra lại các thông tin đã nhập!");
            request.getRequestDispatcher("booking.jsp").forward(request, response);
        }
    }
}