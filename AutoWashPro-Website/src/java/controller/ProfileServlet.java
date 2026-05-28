package controller;

import dao.CustomerDAO;
import dao.VehicleDAO;
import dto.Customer;
import dto.Vehicle;
import java.io.IOException;
import java.util.ArrayList;
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
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Giả lập ID đang login là 1 (Sau này đổi thành lấy từ Session)
            int currentCustomerId = 1; 

            // 1. Gọi CustomerDAO để lấy Profile + Tên Hạng (Tier)
            CustomerDAO cDao = new CustomerDAO();
            Customer profile = cDao.getCustomerProfile(currentCustomerId);
            
            // 2. Gọi VehicleDAO để lấy danh sách xe
            VehicleDAO vDao = new VehicleDAO();
            ArrayList<Vehicle> listCars = vDao.getCars(currentCustomerId);
            
            if (profile != null) {
                request.setAttribute("USER_PROFILE", profile);
                request.setAttribute("LIST_CARS", listCars);
                request.getRequestDispatcher("profile.jsp").forward(request, response);
            } else {
                response.getWriter().print("<h1>Không tìm thấy thông tin khách hàng!</h1>");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}