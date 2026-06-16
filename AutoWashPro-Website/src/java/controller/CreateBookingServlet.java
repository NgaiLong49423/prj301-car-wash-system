package controller;

import dao.BookingDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
// Ngô Gia Long
import javax.servlet.http.HttpSession;
import dto.User;
import dto.Customer;
import dao.CustomerDAO;
import mylib.AppKeys;
//Ngô Gia Long End

@WebServlet(name = "CreateBookingServlet", urlPatterns = { "/CreateBookingServlet" })
public class CreateBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        String bookingTime = request.getParameter("bookingTime");

        // Ngô Gia Long {
        // lấy session hiện có của người dùng
        HttpSession session = request.getSession(false);
        User account = (session != null) ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;

        // kiểm tra bảo mật : Nếu chưa đăng nhập, bắt buộc chặn lại và chuyển về trang
        // login
        if (account == null) {
            request.setAttribute("error", "Bạn chưa đăng nhập, vui lòng đăng nhập để tiếp tục!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Lấy thông tin user từ session
        int customerId = account.getId();
        // Gọi DAO để lấy hồ sơ thông tin hạng thành viên thật từ database
        CustomerDAO customerDAO = new CustomerDAO();
        Customer customerProfile = customerDAO.getCustomerProfile(customerId);

        // Phòng ngừa trường hợp lỗi hệ thống không tải được hồ sơ
        if (customerProfile == null) {
            request.setAttribute("error", "Lỗi hệ thống: Không thể tải thông tin hạng thành viên!");
            request.getRequestDispatcher("booking.jsp").forward(request, response);
            return;
        }

        // Gán mã hạng và tên hạng thật từ database vào các biến xử lý nghiệp vụ
        int tierId = customerProfile.getTierId();
        String tierName = customerProfile.getTierName();

        // } Ngô Gia Long

        try {
            LocalDate bookingDate = LocalDate.parse(bookingDateStr);
            LocalDate today = LocalDate.now();
            long daysBetween = ChronoUnit.DAYS.between(today, bookingDate);

            // Bắt lỗi quá khứ
            if (daysBetween < 0) {
                request.setAttribute("error", "Lỗi: Không thể đặt lịch trong quá khứ!");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            // Ngô Gia Long {
            // 3. Logic: Giới hạn ngày theo Hạng (Workshop 2)
            int maxDaysAllowed = 0;
            switch (tierId) {
                case 1:
                    maxDaysAllowed = 7;
                    break;
                case 2:
                    maxDaysAllowed = 10;
                    break;
                case 3:
                    maxDaysAllowed = 12;
                    break;
                case 4:
                    maxDaysAllowed = 14;
                    break;
                default:
                    request.setAttribute("error",
                            "Lỗi hệ thống: Hạng thành viên của bạn không hợp lệ để đặt lịch trước!");
                    request.getRequestDispatcher("booking.jsp").forward(request, response);
                    return;
            }
            // } Ngô Gia Long

            // Bắt lỗi vượt số ngày quy định
            if (daysBetween > maxDaysAllowed) {
                request.setAttribute("error",
                        "Quyền lợi Hạng " + tierName + " chỉ được đặt trước tối đa " + maxDaysAllowed + " ngày!");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            // --- ĐÂY LÀ PHẦN MỚI THÊM VÀO ---
            // 4. Nếu qua hết các ải, tiến hành gọi DAO lưu vào Database
            int vehicleId = Integer.parseInt(vehicleIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);

            // Giả lập giá tiền dựa trên lựa chọn ở giao diện (1: Cơ bản 100k, 2: Ceramic
            // 1.5M)
            double price = (serviceId == 1) ? 100000 : 1500000;

            BookingDAO dao = new BookingDAO();
            boolean isSuccess = dao.createNewBooking(customerId, vehicleId, serviceId, bookingDateStr, bookingTime,
                    price);

            if (isSuccess) {
                request.setAttribute("success", "🎉 Đặt lịch thành công! Vui lòng đến đúng giờ.");
            } else {
                request.setAttribute("error", "Lỗi hệ thống: Không thể lưu vào Database!");
            }
            // --------------------------------

            request.getRequestDispatcher("booking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi dữ liệu: Vui lòng kiểm tra lại các thông tin đã nhập!");
            request.getRequestDispatcher("booking.jsp").forward(request, response);
        }
    }
}