import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mylib.AppKeys;


@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private static final String CHAT_COOKIE_NAME = "chatCookie";
    private static final int CHAT_COOKIE_MAX_AGE = 7 * 24 * 60 * 60;
    private static final String CHAT_SUPPORT_ACTION = "SupportChat";
    private static final String CHAT_ERROR_PARAM = "chatError";
    private static final String CHAT_ERROR_INVALID_FORMAT = "invalid_format";

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
            } else if (action.equals(CHAT_SUPPORT_ACTION)) {
                handleSupportChat(request, response);
                return;
            }

            if (isDashboardAction(action, url)) {
                applySupportChatCookie(request, response);
                applySupportChatErrorFlag(request);
            }
        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
        }

        if (!response.isCommitted()) {
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
        request.setCharacterEncoding("UTF-8");
        processRequest(request, response);
    }

    private boolean isDashboardAction(String action, String url) {
        return "Home".equals(action) || "Dashboard".equals(action) || DASHBOARD_PAGE.equals(url);
    }

    private void handleSupportChat(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String featureSuggestion = request.getParameter("supportFeature");
        if (featureSuggestion == null) {
            featureSuggestion = "";
        }

        featureSuggestion = extractBracketedFeatures(featureSuggestion);
        if (featureSuggestion.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Dashboard&" + CHAT_ERROR_PARAM + "=" + CHAT_ERROR_INVALID_FORMAT);
            return;
        }

        try {
            String encodedValue = URLEncoder.encode(featureSuggestion, "UTF-8");
            Cookie chatCookie = new Cookie(CHAT_COOKIE_NAME, encodedValue);
            chatCookie.setMaxAge(CHAT_COOKIE_MAX_AGE);
            chatCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            chatCookie.setHttpOnly(true);
            response.addCookie(chatCookie);
        } catch (UnsupportedEncodingException ex) {
            log("Unable to encode support chat cookie: " + ex.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/MainController?action=Dashboard");
    }

    private void applySupportChatCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_HAS_COOKIE, Boolean.FALSE);
            return;
        }

        for (Cookie cookie : cookies) {
            if (!CHAT_COOKIE_NAME.equals(cookie.getName())) {
                continue;
            }

            String featureSuggestion = cookie.getValue();
            try {
                featureSuggestion = URLDecoder.decode(featureSuggestion, "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                log("Unable to decode support chat cookie: " + ex.getMessage());
            }

            featureSuggestion = normalizeStoredFeature(featureSuggestion);

            if (featureSuggestion.isEmpty()) {
                clearSupportChatCookie(request, response);
                continue;
            }

            String safeFeatureSuggestion = escapeHtml(featureSuggestion);
            String responseText = "Cảm ơn bạn đã đồng hành cùng Luxe Wash! Hệ thống ghi nhận bạn đã đề xuất chức năng '"
                    + safeFeatureSuggestion
                    + "'. Đội ngũ Software Engineering của chúng tôi đang tiến hành phân tích và phát triển tính năng này trong phiên bản tiếp theo.";

            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_HAS_COOKIE, Boolean.TRUE);
            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_FEATURE, safeFeatureSuggestion);
            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_RESPONSE, responseText);
            return;
        }

        request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_HAS_COOKIE, Boolean.FALSE);
    }

    private void clearSupportChatCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie cookie = new Cookie(CHAT_COOKIE_NAME, "");
        cookie.setMaxAge(0);
        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
    }

    private void applySupportChatErrorFlag(HttpServletRequest request) {
        String chatError = request.getParameter(CHAT_ERROR_PARAM);
        if (CHAT_ERROR_INVALID_FORMAT.equals(chatError)) {
            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_ERROR,
                    "Vui lòng nhập đúng cú pháp [Tính năng đề xuất]. Ví dụ: [Theo dõi trạng thái xe].");
        }
    }

    private String extractBracketedFeatures(String value) {
        if (value == null) {
            return "";
        }

        String normalized = value.trim();
        Pattern bracketPattern = Pattern.compile("\\[(.+?)\\]");
        Matcher matcher = bracketPattern.matcher(normalized);

        StringBuilder extractedFeatures = new StringBuilder();
        while (matcher.find()) {
            String feature = matcher.group(1) != null ? matcher.group(1).trim() : "";
            if (feature.isEmpty()) {
                continue;
            }
            if (extractedFeatures.length() > 0) {
                extractedFeatures.append(", ");
            }
            extractedFeatures.append(feature);
        }

        return extractedFeatures.toString();
    }

    private String normalizeStoredFeature(String value) {
        if (value == null) {
            return "";
        }
        return value.trim();
    }

            private String escapeHtml(String value) {
            if (value == null) {
                return "";
            }

            return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
            }
}