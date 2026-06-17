package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({ "/home", "/profile", "/coming-soon"})
public class ComingSoonServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy path hiện tại để xác định tính năng nào
        String path = request.getRequestURI();
        String featureName = "";
        String featureIcon = "";

        if (path.contains("/home")) {
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            return;
        } else if (path.contains("/profile")) {
            featureName = "Thông tin Cá nhân";
            featureIcon = "person";
        } else if (path.contains("/booking")) {
            featureName = "Đặt Lịch Rửa Xe";
            featureIcon = "local_car_wash";
        }

        // Set attributes để truyền sang JSP
        request.setAttribute("featureName", featureName);
        request.setAttribute("featureIcon", featureIcon);

        // Forward sang coming-soon.jsp
        request.getRequestDispatcher("coming-soon.jsp").forward(request, response);
    }
}
