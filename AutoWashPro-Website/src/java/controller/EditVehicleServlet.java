package controller;

import dao.VehicleDAO;
import dto.User;
import dto.Vehicle;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

@WebServlet(name = "EditVehicleServlet", urlPatterns = {"/EditVehicleServlet"})
public class EditVehicleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User account = session != null ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        String idStr = request.getParameter("vehicleId");
        int vid = 0;
        try { vid = Integer.parseInt(idStr); } catch (Exception e) { vid = 0; }
        if (vid <= 0) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Profile");
            return;
        }

        VehicleDAO vDao = new VehicleDAO();
        Vehicle v = vDao.getVehicleById(vid);
        if (v == null || v.getCustomerId() != account.getId()) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Profile");
            return;
        }

        request.setAttribute(AppKeys.REQ_IS_EDIT, true);
        request.setAttribute(AppKeys.REQ_USER_VEHICLE, v);
        request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
    }
}
