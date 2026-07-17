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
    private static final String BOOKING_HISTORY_CONTROLLER = "/UserBookingHistoryServlet";

    /**
     * Phương thức xử lý tập trung cho mọi yêu cầu HTTP (cả GET và POST) gửi đến ứng dụng.
     * Áp dụng mô hình thiết kế Front Controller Pattern.
     * * Bài toán giải quyết:
     * - Tiếp nhận tất cả các yêu cầu từ Client thông qua tham số `action`.
     * - Phân tích giá trị của `action` để quyết định chuyển hướng luồng xử lý (routing) tới Servlet con hoặc trang JSP phù hợp.
     * - Quản lý việc hiển thị thông báo phản hồi Support Chat và thiết lập Cookie tương ứng cho trang Dashboard.
     * * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input): 
     * + Lấy từ Request Parameter: "action" (Hành động yêu cầu từ người dùng).
     * - Đầu ra (Output):
     * + Chuyển tiếp request và response (Forward) tới servlet hoặc trang JSP đích.
     * + Hoặc gọi hàm xử lý Support Chat chuyên biệt nếu hành động là đề xuất tính năng.
     * * @param request  Đối tượng HttpServletRequest chứa thông tin yêu cầu.
     * @param response Đối tượng HttpServletResponse để gửi phản hồi.
     * @throws ServletException Nếu xảy ra lỗi Servlet.
     * @throws IOException      Nếu xảy ra lỗi luồng I/O.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập kiểu dữ liệu phản hồi là HTML với bộ mã hóa ký tự UTF-8.
        response.setContentType("text/html;charset=UTF-8");

        // Gán trang đích mặc định ban đầu là trang đăng nhập.
        String url = LOGIN_PAGE;

        try {
            // Lấy tham số hành động gửi lên từ request client.
            String action = request.getParameter("action");

            // Hệ thống phân luồng (Routing Table) dựa trên cấu trúc điều kiện rẽ nhánh if-else:
            if (action == null || action.equals("Login")) {
                // Nếu không truyền action hoặc hành động là đăng nhập, chuyển luồng tới LoginServlet
                url = LOGIN_CONTROLLER;
            } else if (action.equals("RegisterPage")) {
                // Chuyển hướng tới trang JSP đăng ký tài khoản
                url = REGISTER_PAGE;
            } else if (action.equals("Register")) {
                // Chuyển luồng xử lý xử lý dữ liệu đăng ký tới RegisterServlet
                url = REGISTER_CONTROLLER;
            } else if (action.equals("Home")) {
                // Điều phối về trang chủ Dashboard
                url = HOME_PAGE;
            } else if (action.equals("Dashboard")) {
                // Điều phối về trang hiển thị Dashboard
                url = DASHBOARD_PAGE;
            } else if (action.equals("AddVehicle")) {
                // Chuyển luồng xử lý thêm xe tới AddVehicleServlet
                url = ADD_VEHICLE_CONTROLLER;
            } else if (action.equals("Profile")) {
                // Chuyển luồng hiển thị thông tin cá nhân và Garage tới ProfileServlet
                url = PROFILE_CONTROLLER;
            } else if (action.equals("Rewards")) {
                // Chuyển luồng tới RewardsServlet
                url = REWARDS_CONTROLLER;
            } else if (action.equals("Logout")) {
                // Chuyển luồng tới LogoutServlet để xóa session
                url = LOGOUT_CONTROLLER;
            } else if (action.equals("ComingSoon")) {
                // Chuyển tới trang tính năng đang phát triển
                url = COMING_SOON_CONTROLLER;
            } else if (action.equals("Booking")) {
                // Chuyển luồng đặt lịch rửa xe tới BookingServlet
                url = BOOKING_CONTROLLER;
            } else if (action.equals("AddVehiclePage")) {
                // Điều phối trực tiếp hiển thị biểu mẫu thêm xe mới jsp
                url = "addvehicle.jsp";
            } else if (action.equals("EditVehicle")) {
                // Chuyển luồng lấy thông tin xe chuẩn bị sửa tới EditVehicleServlet
                url = EDIT_VEHICLE_CONTROLLER;
            } else if (action.equals("BookingHistory") || action.equals("WashingHistory")) {
                // Điều phối luồng xử lý lịch sử sang Servlet lịch sử đặt lịch
                url = BOOKING_HISTORY_CONTROLLER;
            } else if (action.equals(CHAT_SUPPORT_ACTION)) {
                // Nếu là hành động gửi đề xuất chat support, gọi hàm xử lý riêng và kết thúc luôn
                handleSupportChat(request, response);
                return;
            }

            // Kiểm tra xem yêu cầu hiện tại có dẫn đến trang Dashboard hay không
            if (isDashboardAction(action, url)) {
                // Đọc thông tin đề xuất từ Cookie (nếu có) để chuẩn bị hiển thị lời cảm ơn lên Dashboard
                applySupportChatCookie(request, response);
                // Kiểm tra lỗi format nhập đề xuất từ url parameter để đưa thông báo lỗi lên giao diện
                applySupportChatErrorFlag(request);
            }
        } catch (Exception e) {
            // Ghi nhận log lỗi của Front Controller
            log("Error at MainController: " + e.toString());
        }

        // Kiểm tra xem phản hồi đã được hoàn thành (gửi header/redirect) về client hay chưa.
        // Điều này giúp tránh lỗi IllegalStateException nếu trước đó đã thực hiện sendRedirect trong handleSupportChat.
        if (!response.isCommitted()) {
            // Chuyển tiếp request và response nội bộ sang URL đích đã cấu hình ở trên
            request.getRequestDispatcher(url).forward(request, response);
        }
    }

    /**
     * Tiếp nhận yêu cầu HTTP GET.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Tiếp nhận yêu cầu HTTP POST, thiết lập mã hóa UTF-8 trước khi xử lý.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập bộ mã hóa UTF-8 cho luồng nhận dữ liệu POST để tránh lỗi font tiếng Việt
        request.setCharacterEncoding("UTF-8");
        processRequest(request, response);
    }

    /**
     * Kiểm tra xem hành động hiện tại hoặc URL đích có tương ứng với trang Dashboard hay không.
     * * @param action Tên hành động yêu cầu.
     * @param url    URL trang đích.
     * @return true nếu là hành động liên quan tới Dashboard, ngược lại trả về false.
     */
    private boolean isDashboardAction(String action, String url) {
        return "Home".equals(action) || "Dashboard".equals(action) || DASHBOARD_PAGE.equals(url);
    }

    /**
     * Xử lý yêu cầu gửi ý kiến đề xuất tính năng mới qua cổng Support Chat.
     * * Bài toán giải quyết:
     * - Lấy chuỗi đề xuất từ form chat.
     * - Sử dụng biểu thức chính quy (Regex) bóc tách chỉ các phần tính năng được viết trong ngoặc vuông `[...]`.
     * - Nếu cú pháp sai (không có ngoặc vuông hoặc trống), redirect về dashboard kèm mã lỗi định dạng.
     * - Nếu hợp lệ, mã hóa chuỗi theo chuẩn UTF-8, tạo Cookie để lưu trữ đề xuất của khách hàng xuống trình duyệt client.
     * * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input): Request Parameter "supportFeature" chứa nội dung chat đề xuất.
     * - Đầu ra (Output): 
     * + Nếu sai định dạng: Redirect về "/MainController?action=Dashboard&chatError=invalid_format".
     * + Nếu thành công: Tạo Cookie "chatCookie" lưu trữ trên Client và Redirect về trang Dashboard.
     * * @param request  Yêu cầu HTTP gửi tới.
     * @param response Phản hồi HTTP gửi đi.
     * @throws IOException Nếu xảy ra lỗi chuyển hướng hoặc kết nối.
     */
    private void handleSupportChat(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Lấy nội dung tin nhắn chat đề xuất tính năng
        String featureSuggestion = request.getParameter("supportFeature");
        if (featureSuggestion == null) {
            featureSuggestion = "";
        }

        // Bóc tách các chức năng viết trong dấu ngoặc vuông [...]
        featureSuggestion = extractBracketedFeatures(featureSuggestion);
        
        // Nếu chuỗi kết quả trống (người dùng nhập sai cú pháp, không sử dụng dấu ngoặc vuông hoặc để trống)
        if (featureSuggestion.isEmpty()) {
            // Chuyển hướng người dùng về Dashboard kèm tham số báo lỗi sai định dạng
            response.sendRedirect(request.getContextPath() + "/MainController?action=Dashboard&" + CHAT_ERROR_PARAM + "=" + CHAT_ERROR_INVALID_FORMAT);
            return; // Dừng xử lý
        }

        try {
            // Mã hóa chuỗi tính năng đã trích xuất sang định dạng UTF-8 để Cookie có thể lưu trữ ký tự tiếng Việt an toàn
            String encodedValue = URLEncoder.encode(featureSuggestion, "UTF-8");
            // Tạo mới một Cookie lưu trữ thông tin đề xuất
            Cookie chatCookie = new Cookie(CHAT_COOKIE_NAME, encodedValue);
            // Thiết lập thời hạn tồn tại của Cookie (mặc định là 7 ngày)
            chatCookie.setMaxAge(CHAT_COOKIE_MAX_AGE);
            
            // TOÁN TỬ BA NGÔI cấu hình đường dẫn hoạt động của Cookie:
            // - Điều kiện: request.getContextPath().isEmpty() (Kiểm tra xem context path của ứng dụng có phải là thư mục gốc "/" hay không).
            // - Đúng (root path): Thiết lập đường dẫn cookie hoạt động trên toàn domain là "/".
            // - Sai (có context path): Thiết lập đường dẫn cookie chỉ hoạt động trong phạm vi context path của ứng dụng (tránh xung đột cookie).
            chatCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            
            // CƠ CHẾ BẢO MẬT COOKIE:
            // Thiết lập HttpOnly là true để ngăn chặn các đoạn mã Javascript ở phía Client (ví dụ mã độc chèn qua lỗi XSS)
            // có thể đọc hoặc ghi đè lên Cookie này, giúp phòng chống các cuộc tấn công đánh cắp phiên hoặc thông tin nhạy cảm.
            chatCookie.setHttpOnly(true);
            
            // Thêm cookie vừa tạo vào đối tượng response để gửi về lưu trên trình duyệt của Client
            response.addCookie(chatCookie);
        } catch (UnsupportedEncodingException ex) {
            // Ghi nhận lỗi nếu hệ thống không hỗ trợ bảng mã UTF-8 khi encode cookie
            log("Unable to encode support chat cookie: " + ex.getMessage());
        }

        // Chuyển hướng trình duyệt của người dùng quay trở lại trang Dashboard để cập nhật giao diện mới
        response.sendRedirect(request.getContextPath() + "/MainController?action=Dashboard");
    }

    /**
     * Kiểm tra và nạp thông tin đề xuất tính năng từ Cookie của Client vào Request Attribute để hiển thị lên Dashboard.
     * * Bài toán giải quyết:
     * - Đọc các Cookie từ request client gửi lên để tìm kiếm "chatCookie".
     * - Nếu tìm thấy, thực hiện giải mã (decode) chuỗi UTF-8.
     * - Thực hiện chuẩn hóa và làm sạch chuỗi (HTML Escaping) chống tấn công XSS.
     * - Tạo lời nhắn cảm ơn cá nhân hóa thiết lập vào request attribute hiển thị lên giao diện Dashboard.
     * * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input): Mảng cookies của client gửi lên thông qua `request.getCookies()`.
     * - Đầu ra (Output): Thiết lập các request attributes:
     * + "REQ_CHAT_SUPPORT_HAS_COOKIE": boolean (true nếu tìm thấy cookie hợp lệ).
     * + "REQ_CHAT_SUPPORT_FEATURE": Chuỗi tính năng đã làm sạch.
     * + "REQ_CHAT_SUPPORT_RESPONSE": Lời nhắn cảm ơn đã được format.
     * * @param request  Yêu cầu HTTP chứa danh sách cookies.
     * @param response Phản hồi HTTP để xóa cookie nếu dữ liệu rác.
     */
    private void applySupportChatCookie(HttpServletRequest request, HttpServletResponse response) {
        // Lấy danh sách toàn bộ cookie từ request client gửi lên
        Cookie[] cookies = request.getCookies();
        // Nếu không có cookie nào tồn tại
        if (cookies == null) {
            // Gán cờ báo hiệu không có cookie chat support là FALSE và dừng xử lý
            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_HAS_COOKIE, Boolean.FALSE);
            return;
        }

        // Duyệt qua từng cookie nhận được
        for (Cookie cookie : cookies) {
            // Kiểm tra tên cookie xem có trùng khớp với tên cookie đề xuất chat không
            if (!CHAT_COOKIE_NAME.equals(cookie.getName())) {
                continue; // Nếu không trùng, bỏ qua và duyệt tiếp cookie kế tiếp
            }

            // Lấy giá trị chuỗi đã được encode lưu trong cookie
            String featureSuggestion = cookie.getValue();
            try {
                // Thực hiện giải mã URL decode từ chuỗi UTF-8 về dạng tiếng Việt nguyên bản ban đầu
                featureSuggestion = URLDecoder.decode(featureSuggestion, "UTF-8");
            } catch (UnsupportedEncodingException ex) {
                // Log lỗi giải mã cookie
                log("Unable to decode support chat cookie: " + ex.getMessage());
            }

            // Loại bỏ khoảng trắng thừa hai đầu chuỗi tính năng
            featureSuggestion = normalizeStoredFeature(featureSuggestion);

            // Kiểm tra nếu sau khi giải mã và chuẩn hóa chuỗi bị trống (dữ liệu lỗi/rác)
            if (featureSuggestion.isEmpty()) {
                // Tiến hành xóa cookie lỗi này khỏi máy của Client để tránh lặp lại lỗi
                clearSupportChatCookie(request, response);
                continue; // Tiếp tục vòng lặp duyệt cookie
            }

            // PHÒNG CHỐNG TẤN CÔNG XSS (Cross-Site Scripting):
            // Thực hiện escape chuỗi (chuyển đổi các ký tự đặc biệt của HTML như '<', '>' thành thực thể an toàn)
            // trước khi in trực tiếp lên trang Dashboard nhằm loại trừ khả năng thực thi các thẻ script độc hại do hacker cố tình tiêm nhiễm.
            String safeFeatureSuggestion = escapeHtml(featureSuggestion);
            
            // Xây dựng chuỗi thông điệp phản hồi cảm ơn khách hàng đã đề xuất tính năng
            String responseText = "Cảm ơn bạn đã đồng hành cùng Luxe Wash! Hệ thống ghi nhận bạn đã đề xuất chức năng '"
                    + safeFeatureSuggestion
                    + "'. Đội ngũ Software Engineering của chúng tôi đang tiến hành phân tích và phát triển tính năng này trong phiên bản tiếp theo.";

            // Thiết lập các thuộc tính gửi sang giao diện dashboard.jsp để hiển thị
            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_HAS_COOKIE, Boolean.TRUE);
            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_FEATURE, safeFeatureSuggestion);
            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_RESPONSE, responseText);
            return; // Đã tìm thấy cookie hợp lệ, kết thúc hàm
        }

        // Nếu duyệt hết danh sách cookie mà không tìm thấy cookie chat support, set cờ là FALSE
        request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_HAS_COOKIE, Boolean.FALSE);
    }

    /**
     * Xóa bỏ Cookie Support Chat khỏi trình duyệt của client.
     * * Cách hoạt động:
     * - Tạo một cookie mới cùng tên "chatCookie" nhưng có giá trị là chuỗi rỗng.
     * - Thiết lập thời gian sống `MaxAge = 0` để thông báo cho trình duyệt khách hàng xóa cookie này ngay lập tức.
     * * @param request  Yêu cầu HTTP để lấy đường dẫn ngữ cảnh.
     * @param response Phản hồi HTTP để chèn cookie xóa.
     */
    private void clearSupportChatCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie cookie = new Cookie(CHAT_COOKIE_NAME, "");
        cookie.setMaxAge(0); // Thiết lập thời gian sống bằng 0 để xóa cookie ngay lập tức
        // Thiết lập lại context path tương tự khi tạo để đảm bảo tìm đúng cookie cần xóa
        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
    }

    /**
     * Kiểm tra tham số lỗi từ URL gửi về và thiết lập thông báo lỗi chi tiết hiển thị cho người dùng.
     * * @param request Yêu cầu HTTP chứa tham số báo lỗi.
     */
    private void applySupportChatErrorFlag(HttpServletRequest request) {
        String chatError = request.getParameter(CHAT_ERROR_PARAM);
        // Nếu tham số báo lỗi khớp với lỗi sai định dạng cú pháp đề xuất
        if (CHAT_ERROR_INVALID_FORMAT.equals(chatError)) {
            // Đưa thông báo hướng dẫn định dạng đúng vào request attribute hiển thị lên form chat
            request.setAttribute(AppKeys.REQ_CHAT_SUPPORT_ERROR,
                    "Vui lòng nhập đúng cú pháp [Tính năng đề xuất]. Ví dụ: [Theo dõi trạng thái xe].");
        }
    }

    /**
     * Bóc tách tất cả các chuỗi nội dung nằm bên trong các cặp dấu ngoặc vuông `[...]` từ chuỗi chat nhập vào.
     * * Cách thức hoạt động:
     * - Sử dụng Regex Pattern `\\[(.+?)\\]` để tìm kiếm:
     * + `\\[` và `\\]`: đại diện cho hai dấu ngoặc vuông thực tế.
     * + `(.+?)`: Nhóm thu giữ (Capture Group 1) bắt toàn bộ các ký tự bên trong một cách tối thiểu (non-greedy),
     * nghĩa là nó sẽ dừng lại ngay khi gặp dấu đóng ngoặc vuông đầu tiên, hỗ trợ bóc tách nhiều tính năng độc lập.
     * - Ví dụ: "[Rửa xe nhanh] và [Đặt lịch online]" -> "Rửa xe nhanh, Đặt lịch online".
     * * @param value Chuỗi gốc người dùng nhập vào.
     * @return Chuỗi chứa các tính năng đã bóc tách phân tách bởi dấu phẩy, hoặc chuỗi rỗng nếu không khớp định dạng.
     */
    private String extractBracketedFeatures(String value) {
        if (value == null) {
            return "";
        }

        // Loại bỏ khoảng trắng ở hai đầu chuỗi gốc
        String normalized = value.trim();
        // Biên dịch biểu thức chính quy (Regex Pattern)
        Pattern bracketPattern = Pattern.compile("\\[(.+?)\\]");
        Matcher matcher = bracketPattern.matcher(normalized);

        StringBuilder extractedFeatures = new StringBuilder();
        
        // Vòng lặp tìm kiếm tất cả các cụm khớp với Regex trong chuỗi nhập vào
        while (matcher.find()) {
            // TOÁN TỬ BA NGÔI lấy và chuẩn hóa nội dung bên trong dấu ngoặc vuông:
            // - Điều kiện: matcher.group(1) != null (Kiểm tra xem nội dung thu giữ được ở Group 1 có khác null không).
            // - Đúng: Lấy nội dung bên trong dấu ngoặc vuông và tiến hành cắt khoảng trắng thừa hai đầu.
            // - Sai: Trả về chuỗi rỗng "".
            String feature = matcher.group(1) != null ? matcher.group(1).trim() : "";
            
            // Nếu chức năng bóc tách được bị rỗng, bỏ qua và duyệt tiếp cụm tiếp theo
            if (feature.isEmpty()) {
                continue;
            }
            // Nếu đã có tính năng trước đó trong danh sách kết quả, chèn thêm dấu phẩy ngăn cách
            if (extractedFeatures.length() > 0) {
                extractedFeatures.append(", ");
            }
            // Thêm tính năng vừa trích xuất vào kết quả trả về
            extractedFeatures.append(feature);
        }

        return extractedFeatures.toString();
    }

    /**
     * Chuẩn hóa chuỗi ký tự lấy ra từ bộ nhớ Cookie.
     */
    private String normalizeStoredFeature(String value) {
        if (value == null) {
            return "";
        }
        return value.trim();
    }

    /**
     * Chuyển đổi các ký tự HTML đặc biệt thành thực thể HTML an toàn (HTML Entities).
     * * Bài toán giải quyết:
     * - Phòng ngừa lỗ hổng XSS (Cross-Site Scripting). 
     * - Khi dữ liệu lấy ra từ input của người dùng có chứa các thẻ HTML như <script> alert('hack'); </script> 
     * hoặc các thẻ HTML phá vỡ cấu trúc CSS, hàm này sẽ biến đổi chúng thành các chuỗi văn bản thuần túy 
     * vô hại hiển thị lên màn hình (Ví dụ: `<` thành `&lt;`, `>` thành `&gt;`).
     * * @param value Chuỗi văn bản gốc cần xử lý.
     * @return Chuỗi văn bản đã được làm sạch, an toàn để hiển thị trên trang web.
     */
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        // Tiến hành thay thế tuần tự các ký tự nguy hiểm thành các mã thực thể tương đương
        return value
            .replace("&", "&amp;")     // Thay thế ký tự & trước tiên để tránh ghi đè lên mã thực thể của các ký tự khác
            .replace("<", "&lt;")      // Thay thế dấu nhỏ hơn (mở thẻ HTML)
            .replace(">", "&gt;")      // Thay thế dấu lớn hơn (đóng thẻ HTML)
            .replace("\"", "&quot;")   // Thay thế dấu nháy kép dùng trong các thuộc tính HTML
            .replace("'", "&#39;");    // Thay thế dấu nháy đơn
    }
}