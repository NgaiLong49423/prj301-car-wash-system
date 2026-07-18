package controller;

import dao.LoyaltyDAO;
import dto.User;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

/** Handles the customer POST action for GI-06 reward redemption. */
@WebServlet(name = "RedeemRewardServlet", urlPatterns = {"/rewards/redeem"})
public class RedeemRewardServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User account = session == null
                ? null : (User) session.getAttribute(AppKeys.SESSION_ACCOUNT);
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        try {
            int rewardId = Integer.parseInt(request.getParameter("rewardId"));
            String requestToken = request.getParameter("requestToken");
            String voucherCode = new LoyaltyDAO().redeemReward(
                    account.getId(), rewardId, requestToken);
            session.setAttribute("rewardSuccess",
                    "Đổi thưởng thành công. Mã voucher: " + voucherCode);
        } catch (IllegalArgumentException ex) {
            session.setAttribute("rewardError", ex.getMessage());
        } catch (Exception ex) {
            getServletContext().log(
                    "Reward redemption failed for customerId=" + account.getId(), ex);
            session.setAttribute("rewardError",
                    "Không thể hoàn tất đổi thưởng. Vui lòng thử lại.");
        }

        // Post/Redirect/Get prevents browser refresh from resubmitting the form.
        response.sendRedirect(request.getContextPath() + "/rewards");
    }
}
