package controller;

import dao.CustomerDAO;
import dto.CustomerProfileDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đặt tiếng Việt để lỡ có in ra lỗi thì không bị lỗi font chữ
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            /* * LƯU Ý: Vì Thành viên 2 (người làm tính năng Đăng nhập) chưa làm xong, 
             * nên hiện tại web chưa biết ai đang đăng nhập.
             * Để test được code của bạn, chúng ta "giả vờ" khách hàng có ID số 1 đang đăng nhập nhé!
             */
            int currentCustomerId = 1; 

            // 1. Gọi DAO để lấy dữ liệu từ Database
            CustomerDAO dao = new CustomerDAO();
            CustomerProfileDTO profile = dao.getProfileById(currentCustomerId);

            // 2. Kiểm tra xem có lấy được dữ liệu không
            if (profile != null) {
                // Nếu lấy được, ta "đóng gói" cái hộp profile đó với cái tên là "USER_PROFILE"
                request.setAttribute("USER_PROFILE", profile);
                
                // Sau đó, "ship" nó sang cho trang profile.jsp để hiển thị
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            } else {
                // Nếu không tìm thấy khách hàng số 1 trong Database
                response.getWriter().print("<h1>Không tìm thấy thông tin khách hàng này!</h1>");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("<h1>Hệ thống đang lỗi, vui lòng quay lại sau!</h1>");
        }
    }
}