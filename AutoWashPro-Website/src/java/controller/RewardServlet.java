package controller;

import dao.RewardDAO;
import dto.RewardDTO;

// Đổi toàn bộ jakarta thành javax
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RewardServlet", urlPatterns = {"/rewards"})
public class RewardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Lấy ID khách hàng (dùng 1 để test nếu chưa làm chức năng Login)
        Integer customerId = (Integer) session.getAttribute("customerId");
        if (customerId == null) {
            customerId = 1;
        }

        // Gọi DAO lấy data
        RewardDAO dao = new RewardDAO();
        int currentPoints = dao.getCurrentPoints(customerId);
        List<RewardDTO> rewardList = dao.getAllRewards();

        // Gắn data vào Request
        request.setAttribute("USER_POINTS", currentPoints);
        request.setAttribute("REWARD_LIST", rewardList);

        // Ném sang trang JSP
        request.getRequestDispatcher("rewards.jsp").forward(request, response);
    }
}