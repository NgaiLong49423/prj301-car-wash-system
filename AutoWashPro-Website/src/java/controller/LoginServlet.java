package controller;

import dao.UserDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dto.User;
import mylib.AppKeys;

@WebServlet(name = "LoginServlet", urlPatterns = { "/LoginServlet" })
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute(AppKeys.REQ_ERROR, "Vui lòng nhập đầy đủ email và mật khẩu.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        User user = dao.login(email, password);

        if (user != null) {

            HttpSession session = request.getSession();

            session.setAttribute(AppKeys.SESSION_ACCOUNT, user);
            session.setAttribute(AppKeys.SESSION_USER_DISPLAY_NAME, user.getFullName());
            session.setAttribute(AppKeys.SESSION_USER_EMAIL, user.getEmail());
            session.setAttribute(AppKeys.SESSION_TOTAL_SPENT_MONEY,
                    user.getTotalSpentMoney() != null ? user.getTotalSpentMoney() : BigDecimal.ZERO);
            session.setAttribute(AppKeys.SESSION_USER_POINTS, user.getTotalPoints());
            session.setAttribute(AppKeys.REQ_USER_DISPLAY_NAME, user.getFullName());
            session.setAttribute(AppKeys.REQ_TOTAL_SPENT_MONEY,
                    user.getTotalSpentMoney() != null ? user.getTotalSpentMoney() : BigDecimal.ZERO);
            session.setAttribute(AppKeys.REQ_USER_POINTS, user.getTotalPoints());

            // Báo cho MainController biết là hãy mở trang Dashboard
            response.sendRedirect(request.getContextPath() + "/MainController?action=Dashboard");

        } else {

            String error = dao.getLastError();
            request.setAttribute(AppKeys.REQ_ERROR,
                    error != null ? error : "Email hoặc mật khẩu không đúng.");
            // Forward preserves the diagnostic message; redirect previously discarded it.
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            processRequest(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected login error", e);
            throw e;
        }
    }
}
