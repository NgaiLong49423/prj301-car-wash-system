package controller;

import dao.UserDAO;
import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dto.User;
import mylib.AppKeys;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

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
            session.setAttribute(AppKeys.SESSION_USER_EMAIL, user.getFullName());
            session.setAttribute(AppKeys.REQ_USER_DISPLAY_NAME, user.getFullName());
            session.setAttribute(AppKeys.REQ_TOTAL_SPENT_MONEY, user.getTotalSpentMoney() != null ? user.getTotalSpentMoney() : BigDecimal.ZERO);
            session.setAttribute(AppKeys.REQ_USER_POINTS, user.getTotalPoints());
            session.setAttribute("userEmail", user.getEmail());

            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");

        } else {

            request.setAttribute("error", "Wrong username or password");

            request.getRequestDispatcher("login.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
}