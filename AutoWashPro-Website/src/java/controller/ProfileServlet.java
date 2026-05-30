package controller;

import dao.CustomerDAO;
import dao.VehicleDAO;
import dto.Customer;
import dto.Vehicle;
import dto.User;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User account = session != null ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            int currentCustomerId = account.getId();

            CustomerDAO cDao = new CustomerDAO();
            Customer profile = cDao.getCustomerProfile(currentCustomerId);

            if (profile != null && (account.getPhone() == null || account.getPhone().trim().isEmpty())) {
                account.setPhone(profile.getPhone());
                session.setAttribute(AppKeys.SESSION_ACCOUNT, account);
            }
            
            VehicleDAO vDao = new VehicleDAO();
            ArrayList<Vehicle> listCars = vDao.getCars(currentCustomerId);
            
            request.setAttribute("USER_PROFILE", profile);
            request.setAttribute("USER_PHONE", profile != null ? profile.getPhone() : null);
            request.setAttribute("LIST_CARS", listCars != null ? listCars : new ArrayList<Vehicle>());
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}