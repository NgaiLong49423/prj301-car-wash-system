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

        String email = request.getParameter("email");
        String password = request.getParameter("password");

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
            session.setAttribute(AppKeys.SESSION_USER_ROLE, user.getRoleName());
            session.setAttribute(AppKeys.REQ_USER_DISPLAY_NAME, user.getFullName());
            session.setAttribute(AppKeys.REQ_TOTAL_SPENT_MONEY,
                    user.getTotalSpentMoney() != null ? user.getTotalSpentMoney() : BigDecimal.ZERO);
            session.setAttribute(AppKeys.REQ_USER_POINTS, user.getTotalPoints());

            // Rẽ nhánh theo Role
            if ("ADMIN".equalsIgnoreCase(user.getRoleName())) {
                response.sendRedirect(request.getContextPath() + "/MainController?action=AdminDashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/MainController?action=Dashboard");
            }

        } else {

            request.setAttribute(AppKeys.REQ_ERROR, "Wrong username or password");

            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
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