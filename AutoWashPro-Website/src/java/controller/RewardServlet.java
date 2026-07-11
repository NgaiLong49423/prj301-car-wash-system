package controller;

import dao.MembershipTierDAO;
import dao.RewardDAO;
import dto.MembershipTierDTO;
import dto.RewardDTO;
import dto.User;
import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import mylib.AppKeys;
import service.LoyaltyService;

@WebServlet(name="RewardServlet",urlPatterns={"/rewards"})
public class RewardServlet extends HttpServlet {
 @Override protected void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException{
  HttpSession s=req.getSession(false);User u=s==null?null:(User)s.getAttribute(AppKeys.SESSION_ACCOUNT);if(u==null){res.sendRedirect(req.getContextPath()+"/MainController?action=Login");return;}
  try{
   int points=new LoyaltyService().getActivePoints(u.getId());u.setTotalPoints(points);s.setAttribute(AppKeys.SESSION_USER_POINTS,points);
   List<RewardDTO> rewards=new RewardDAO().getAllRewards();MembershipTierDTO tier=new MembershipTierDAO().getTierByCustomerId(u.getId());
   req.setAttribute(AppKeys.REQ_USER_DISPLAY_NAME,u.getFullName());req.setAttribute(AppKeys.REQ_TOTAL_SPENT_MONEY,u.getTotalSpentMoney().longValue());req.setAttribute(AppKeys.REQ_USER_POINTS,points);req.setAttribute(AppKeys.REQ_REWARD_LIST,rewards);req.setAttribute(AppKeys.REQ_REWARD_ICONS,new HashMap<Integer,String>());req.setAttribute(AppKeys.REQ_MEMBER_TIER,tier.getTierName());req.setAttribute(AppKeys.REQ_TIER_BENEFIT,tier.getBenefits());
   req.setAttribute(AppKeys.REQ_NEXT_REWARD_NAME,"");req.setAttribute(AppKeys.REQ_NEXT_REWARD_POINTS,0L);req.setAttribute(AppKeys.REQ_PROGRESS_PERCENT,100d);req.setAttribute(AppKeys.REQ_POINTS_NEEDED,0L);req.setAttribute(AppKeys.REQ_NEXT_REWARD_NAME_ALT,"");req.setAttribute(AppKeys.REQ_NEXT_REWARD_POINTS_ALT,0);req.setAttribute(AppKeys.REQ_REWARD_PROGRESS_PERCENT,100d);req.setAttribute(AppKeys.REQ_POINTS_NEEDED_FOR_REWARD,0);req.setAttribute(AppKeys.REQ_NEXT_TIER_NAME,"");req.setAttribute(AppKeys.REQ_NEXT_TIER_POINTS,0L);req.setAttribute(AppKeys.REQ_TIER_PROGRESS_PERCENT,100d);req.setAttribute(AppKeys.REQ_MONEY_TO_NEXT_TIER,0L);
   req.setAttribute("vouchers",new LoyaltyService().listVouchers(u.getId()));req.getRequestDispatcher("/rewards.jsp").forward(req,res);
  }catch(Exception e){log("Unable to load loyalty page",e);throw new ServletException("Không thể tải thông tin loyalty.",e);}
 }
}
