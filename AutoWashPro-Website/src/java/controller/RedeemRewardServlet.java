package controller;
import dto.User;import java.io.IOException;import java.util.UUID;import javax.servlet.annotation.WebServlet;import javax.servlet.http.*;import mylib.AppKeys;import service.LoyaltyService;
@WebServlet(name="RedeemRewardServlet",urlPatterns={"/rewards/redeem"})
public class RedeemRewardServlet extends HttpServlet{
 protected void doPost(HttpServletRequest q,HttpServletResponse p)throws IOException{HttpSession s=q.getSession(false);User u=s==null?null:(User)s.getAttribute(AppKeys.SESSION_ACCOUNT);if(u==null){p.sendError(401);return;}try{int id=Integer.parseInt(q.getParameter("rewardId"));String token=q.getParameter("requestToken");if(token==null)token=UUID.randomUUID().toString();String code=new LoyaltyService().redeem(u.getId(),id,token);s.setAttribute("flashSuccess","Đổi thưởng thành công. Mã voucher: "+code);}catch(IllegalArgumentException e){s.setAttribute("flashError",e.getMessage());}catch(Exception e){log("Redemption failed",e);s.setAttribute("flashError","Không thể hoàn tất thao tác. Vui lòng thử lại.");}p.sendRedirect(q.getContextPath()+"/rewards");}
}
