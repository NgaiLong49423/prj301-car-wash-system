/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package java.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lenovo
 */
@WebServlet(name = "RewardServlet", urlPatterns = {"/RewardServlet"})
public class RewardServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RewardServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RewardServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int customerId = 1; // Hardcode ID tạm thời
        int currentPoints = 0;
        List<Map<String, Object>> rewardsList = new ArrayList<>();

        try {
            // 1. Load Driver (Trình điều khiển kết nối)
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // 2. Connection (Thiết lập kết nối DB) - Nhớ đổi password 'sa' của bạn
            String url = "jdbc:sqlserver://localhost:1433;databaseName=AutoWash_Project;encrypt=false";
            Connection conn = DriverManager.getConnection(url, "sa", "123456"); 

            // 3. Truy vấn lấy số dư điểm
            String sqlPoints = "SELECT ISNULL(SUM(PointsAdded), 0) AS Balance FROM Point_Transaction WHERE CustomerID = ?";
            PreparedStatement ps1 = conn.prepareStatement(sqlPoints);
            ps1.setInt(1, customerId);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                currentPoints = rs1.getInt("Balance");
            }

            // 4. Truy vấn lấy danh sách phần thưởng
            String sqlRewards = "SELECT RewardID, RewardName, PointsCost FROM Reward_Promotion";
            PreparedStatement ps2 = conn.prepareStatement(sqlRewards);
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                Map<String, Object> reward = new HashMap<>();
                reward.put("id", rs2.getInt("RewardID"));
                reward.put("name", rs2.getString("RewardName"));
                reward.put("cost", rs2.getInt("PointsCost"));
                rewardsList.add(reward);
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Đẩy dữ liệu thô sang file JSP (Giao diện)
        request.setAttribute("currentPoints", currentPoints);
        request.setAttribute("rewardsList", rewardsList);
        
        // Forward (Chuyển hướng) tới giao diện
        request.getRequestDispatcher("rewards.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
