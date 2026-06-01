package controller;

import dao.CustomerDAO;
import dto.CustomerDTO;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mylib.AppKeys;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        CustomerDAO dao = new CustomerDAO();
        String errorMessage = "";

        try {
            if (!password.equals(confirmPassword)) {
                errorMessage = "Mật khẩu xác nhận không trùng khớp!";
            } else if (dao.isEmailExist(email)) {
                errorMessage = "Địa chỉ Email này đã có người sử dụng!";
            } else if (dao.isPhoneExist(phone)) {
                errorMessage = "Số điện thoại này đã được đăng ký!";
            }

            if (!errorMessage.isEmpty()) {
                request.setAttribute(AppKeys.REQ_ERROR, errorMessage);
                request.setAttribute(AppKeys.REQ_FULL_NAME, fullName);
                request.setAttribute(AppKeys.REQ_PHONE, phone);
                request.setAttribute(AppKeys.REQ_EMAIL, email);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            CustomerDTO newCustomer = new CustomerDTO(fullName, phone, email, password, 1);
            boolean check = dao.registerCustomer(newCustomer);

            if (check) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            } else {
                request.setAttribute(AppKeys.REQ_ERROR, "Lỗi hệ thống! Không thể thực hiện đăng ký lúc này.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Register failed", e);
            request.setAttribute(AppKeys.REQ_ERROR, "Đã xảy ra lỗi bất ngờ: " + e.getMessage());
            request.setAttribute(AppKeys.REQ_FULL_NAME, fullName);
            request.setAttribute(AppKeys.REQ_PHONE, phone);
            request.setAttribute(AppKeys.REQ_EMAIL, email);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}