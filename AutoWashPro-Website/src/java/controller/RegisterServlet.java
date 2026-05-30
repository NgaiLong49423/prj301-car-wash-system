package controller;

import dao.CustomerDAO;
import dto.CustomerDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Đặt urlPatterns là "/register", gõ đường dẫn này trên trình duyệt là nó nhảy vào đây xử lý
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    // Hàm doGet chạy khi người ta mới bấm vào link hoặc gõ URL để vào xem giao diện trang đăng ký
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Vì file register.jsp nằm ngoài cùng thư mục Web Pages nên gọi trực tiếp luôn, không qua thư mục con
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    // Hàm doPost chạy khi người ta điền xong dữ liệu và bấm nút Submit "Đăng Ký" trên form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Phải set thuộc tính này sang UTF-8 để lúc hứng data tiếng Việt từ form không bị lỗi font ô vuông
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Dùng request.getParameter để bốc các chuỗi dữ liệu trong mấy ô input dựa theo thuộc tính name="..."
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        CustomerDAO dao = new CustomerDAO();
        String chuỗi_lỗi = ""; // Tạo một biến chuỗi rỗng để lát nữa có lỗi gì thì nhét thông báo vào đây

        try {
            // --- BƯỚC 1: KIỂM TRA LOGIC DỮ LIỆU ĐẦU VÀO (VALIDATION) ---
            if (!password.equals(confirmPassword)) {
                chuỗi_lỗi = "Mật khẩu xác nhận không trùng khớp!";
            } else if (dao.isEmailExist(email)) {
                chuỗi_lỗi = "Địa chỉ Email này đã có người sử dụng!";
            } else if (dao.isPhoneExist(phone)) {
                chuỗi_lỗi = "Số điện thoại này đã được đăng ký!";
            }

            // --- BƯỚC 2: XỬ LÝ NẾU FORM CÓ LỖI ---
            if (!chuỗi_lỗi.isEmpty()) {
                // Đẩy thông báo lỗi ngược ra ngoài trang jsp thông qua setAttribute
                request.setAttribute("error", chuỗi_lỗi);
                
                // Giữ lại mấy cái data cũ họ đã gõ (Họ tên, email, sđt) để họ đỡ phải mất công nhập lại từ đầu
                request.setAttribute("fullName", fullName);
                request.setAttribute("phone", phone);
                request.setAttribute("email", email);
                
                // Trả về lại trang register.jsp để người ta sửa lại chỗ sai
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return; // Chặn luồng ở đây luôn, không cho chạy xuống đoạn code lưu DB bên dưới nữa
            }

            // --- BƯỚC 3: LƯU TÀI KHOẢN VÀO DATABASE NẾU MỌI THỨ NGON LÀNH ---
            // Tạo đối tượng DTO mới, truyền số 1 vào cuối cùng đại diện cho tier_id = 1 (Hạng Member)
            CustomerDTO newCustomer = new CustomerDTO(fullName, phone, email, password, 1);
            boolean check = dao.registerCustomer(newCustomer);

            if (check) {
                // Nếu lưu thành công, tạo một thông báo hoàn tất chuyển sang trang tiếp theo
                request.setAttribute("success", "Đăng ký thành công! Hãy đăng nhập hệ thống.");
                // Đăng ký xong thì điều hướng họ sang trang login chung (hiện tại nhóm đang xài tạm file coming-soon.jsp)
                request.getRequestDispatcher("coming-soon.jsp").forward(request, response);
            } else {
                // Phòng hờ trường hợp câu lệnh SQL bị lỗi gì đó không ghi được vào bảng
                request.setAttribute("error", "Lỗi hệ thống! Không thể thực hiện đăng ký lúc này.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // In chi tiết lỗi ra màn hình đen console của server để mình dễ kiểm tra và sửa bug
            e.printStackTrace();
            // Đẩy một dòng thông báo lỗi chung ra ngoài cho người dùng thấy
            request.setAttribute("error", "Đã xảy ra lỗi bất ngờ: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}