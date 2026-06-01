package controller;

import dao.VehicleDAO;
import dto.User;
import dto.Vehicle;
import java.io.IOException;
import java.util.regex.Pattern;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

@WebServlet(name = "AddVehicleServlet", urlPatterns = {"/AddVehicleServlet"})
public class AddVehicleServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AddVehicleServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User account = session != null ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String license = request.getParameter("licensePlate");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String color = request.getParameter("color");

        // Server-side validation: tất cả 4 trường bắt buộc
        StringBuilder err = new StringBuilder();
        if (license == null || license.trim().isEmpty()) {
            err.append("Biển số không được để trống. ");
        }
        if (brand == null || brand.trim().isEmpty()) {
            err.append("Hãng xe không được để trống. ");
        }
        if (model == null || model.trim().isEmpty()) {
            err.append("Model xe không được để trống. ");
        }
        if (color == null || color.trim().isEmpty()) {
            err.append("Màu sắc không được để trống. ");
        }
        if (err.length() > 0) {
            request.setAttribute(AppKeys.REQ_ERROR, err.toString());
            request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
            return;
        }

        // Validate license plate format (allow common format like 30A-123.45 or a general alphanumeric with separators)
        String lic = license.trim().toUpperCase();
        Pattern p1 = Pattern.compile("^[0-9]{2,3}[A-Z]-[0-9]{3}\\.[0-9]{2}$"); // e.g. 30A-123.45
        Pattern p2 = Pattern.compile("^[0-9A-Z .\\-]{4,12}$"); // fallback permissive pattern
        if (! (p1.matcher(lic).matches() || p2.matcher(lic).matches())) {
            request.setAttribute(AppKeys.REQ_ERROR, err.length() > 0 ? err.toString() + "Biển số không hợp lệ." : "Biển số không hợp lệ. Ví dụ hợp lệ: 30A-123.45");
            request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
            return;
        }

        try {
            VehicleDAO vDao = new VehicleDAO();
            String vehicleIdStr = request.getParameter("vehicleId");
            int vehicleId = 0;
            if (vehicleIdStr != null && !vehicleIdStr.trim().isEmpty()) {
                try { vehicleId = Integer.parseInt(vehicleIdStr); } catch (NumberFormatException ex) { vehicleId = 0; }
            }

            // store normalized (uppercase) license
            Vehicle v = new Vehicle(vehicleId, account.getId(), lic, brand != null ? brand.trim() : "", model != null ? model.trim() : "", color != null ? color.trim() : "");

            // check duplicate license (exclude current vehicle for edit)
            if (vDao.isLicenseTaken(lic, vehicleId)) {
                request.setAttribute(AppKeys.REQ_ERROR, "Biển số đã tồn tại. Vui lòng kiểm tra lại.");
                request.setAttribute(AppKeys.REQ_IS_EDIT, vehicleId > 0);
                request.setAttribute(AppKeys.REQ_USER_VEHICLE, vDao.getVehicleById(vehicleId));
                request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
                return;
            }

            boolean ok;
            if (vehicleId > 0) {
                ok = vDao.updateVehicle(v);
            } else {
                ok = vDao.insertVehicle(v);
            }

            if (ok) {
                response.sendRedirect(request.getContextPath() + "/ProfileServlet");
                return;
            } else {
                request.setAttribute(AppKeys.REQ_ERROR, "Không thể lưu xe. Vui lòng thử lại.");
                request.setAttribute(AppKeys.REQ_IS_EDIT, vehicleId > 0);
                request.setAttribute(AppKeys.REQ_USER_VEHICLE, vehicleId > 0 ? vDao.getVehicleById(vehicleId) : v);
                request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to add/update vehicle", e);
            request.setAttribute(AppKeys.REQ_ERROR, "Lỗi server: " + e.getMessage());
            request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
        }
    }
}
