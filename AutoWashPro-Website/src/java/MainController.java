import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String LOGIN_PAGE = "login.jsp";
    private static final String REGISTER_PAGE = "register.jsp";
    private static final String LOGIN_CONTROLLER = "/LoginServlet";
    private static final String REGISTER_CONTROLLER = "/RegisterServlet";
    private static final String DASHBOARD_PAGE = "dashboard.jsp";
    private static final String HOME_PAGE = "dashboard.jsp";
    private static final String ADD_VEHICLE_CONTROLLER = "/AddVehicleServlet";
    private static final String EDIT_VEHICLE_CONTROLLER = "/EditVehicleServlet";
    private static final String PROFILE_CONTROLLER = "/ProfileServlet";
    private static final String REWARDS_CONTROLLER = "/rewards";
    private static final String LOGOUT_CONTROLLER = "/logout";
    private static final String COMING_SOON_CONTROLLER = "/coming-soon";
    private static final String BOOKING_CONTROLLER = "/booking";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String url = LOGIN_PAGE; 
        
        try {
            String action = request.getParameter("action");
            
            if (action == null || action.equals("Login")) {
                url = LOGIN_CONTROLLER;
            } else if (action.equals("RegisterPage")) {
                url = REGISTER_PAGE;
            } else if (action.equals("Register")) {
                url = REGISTER_CONTROLLER;
            } else if (action.equals("Home")) {
                url = HOME_PAGE;
            } else if (action.equals("Dashboard")) {
                url = DASHBOARD_PAGE;
            } else if (action.equals("AddVehicle")) {
                url = ADD_VEHICLE_CONTROLLER;
            } else if (action.equals("Profile")) {
                url = PROFILE_CONTROLLER;
            } else if (action.equals("Rewards")) {
                url = REWARDS_CONTROLLER;
            } else if (action.equals("Logout")) {
                url = LOGOUT_CONTROLLER;
            } else if (action.equals("ComingSoon")) {
                url = COMING_SOON_CONTROLLER;
            } else if (action.equals("Booking")) {
                url = BOOKING_CONTROLLER;
            } else if (action.equals("AddVehiclePage")) {
                url = "addvehicle.jsp";
            } else if (action.equals("EditVehicle")) {
                url = EDIT_VEHICLE_CONTROLLER;
            }
        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}