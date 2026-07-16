package mylib;

/**
 * Class AppKeys (Từ điển hằng số trung gian)
 * 
 * Mục đích: Lưu trữ tập trung tất cả các Key (Khóa định danh) dạng String dùng cho 
 * HttpSession và HttpServletRequest. Chống lỗi gõ sai chính tả (Typo) giữa các tầng 
 * xử lý Servlet và giao diện JSP.
 * 
 * Đặc tính kỹ thuật:
 * - 'final' class: Ngăn chặn việc kế thừa class này.
 * - 'private' constructor: Khóa hàm khởi tạo, chặn việc dùng lệnh 'new AppKeys()'.
 * - 'public static final': Các hằng số cố định trong bộ nhớ, gọi trực tiếp từ tên Class.
 */
public final class AppKeys {

    // Khóa hàm khởi tạo để đảm bảo class này chỉ dùng để chứa hằng số tĩnh
    private AppKeys() {
    }

    /* =========================================================================
     * 1. SESSION SCOPE KEYS (Các khóa lưu trữ trong HttpSession - Dữ liệu dài hạn)
     * Sống xuyên suốt phiên làm việc của User cho đến khi đóng trình duyệt hoặc Logout.
     * ========================================================================= */

    /** Lưu trữ đối tượng User DTO (chứa toàn bộ thông tin tài khoản sau khi login) */
    public static final String SESSION_ACCOUNT = "account";
    
    /** Lưu trữ tên đầy đủ (Full Name) của User để hiển thị câu chào trên giao diện */
    public static final String SESSION_USER_DISPLAY_NAME = "userDisplayName";
    
    /** Lưu trữ địa chỉ Email của tài khoản đang đăng nhập */
    public static final String SESSION_USER_EMAIL = "userEmail";
    
    /** Lưu trữ tổng số tiền (BigDecimal) mà khách hàng này đã chi tiêu trong hệ thống */
    public static final String SESSION_TOTAL_SPENT_MONEY = "totalSpentMoney";
    
    /** Lưu tổng số điểm tích lũy hiện tại của khách hàng */
    public static final String SESSION_USER_POINTS = "userPoints";

    /** Lưu vai trò (Role) của người dùng để phân quyền (VD: ADMIN, CUSTOMER) */
    public static final String SESSION_USER_ROLE = "userRole";


    /* =========================================================================
     * 2. GENERAL REQUEST SCOPE KEYS (Các khóa lưu thông dụng trong HttpServletRequest)
     * Chỉ sống trong vòng đời của một lượt chuyển tiếp dữ liệu (Forward) từ Servlet sang JSP.
     * ========================================================================= */

    /** Lưu chuỗi thông báo lỗi (Error Message) khi biểu mẫu (form) hoặc nghiệp vụ bị lỗi */
    public static final String REQ_ERROR = "error";

    /** Lưu chuỗi thông báo lỗi khi người dùng không có quyền truy cập (Authorization) */
    public static final String REQ_ERROR_AUTH = "errorAuth";
    
    /** Lưu chuỗi thông báo thành công (Success Message) khi thao tác hoàn tất */
    public static final String REQ_SUCCESS = "success";
    
    /** Lưu lại tên của user nhập từ form đăng ký (dùng để repopulate - giữ lại dữ liệu khi lỗi) */
    public static final String REQ_FULL_NAME = "fullName";
    
    /** Lưu lại email nhập từ form đăng ký (dùng để giữ lại dữ liệu trên form khi có lỗi) */
    public static final String REQ_EMAIL = "email";
    
    /** Lưu lại số điện thoại nhập từ form (dùng để giữ lại dữ liệu trên form khi có lỗi) */
    public static final String REQ_PHONE = "phone";


    /* =========================================================================
     * 3. USER PROFILE & VEHICLE PROFILE KEYS (Quản lý thông tin cá nhân và xe cộ)
     * Sử dụng trong luồng xử lý của ProfileServlet, AddVehicleServlet, EditVehicleServlet.
     * ========================================================================= */

    /** Lưu đối tượng Customer chứa dữ liệu hồ sơ cá nhân hoàn chỉnh lấy từ DB */
    public static final String REQ_USER_PROFILE = "USER_PROFILE";
    
    /** Lưu danh sách ArrayList<Vehicle> chứa tất cả các xe mà khách hàng đang sở hữu */
    public static final String REQ_LIST_CARS = "LIST_CARS";
    
    /** Lưu chuỗi số điện thoại định dạng chuẩn của người dùng để hiển thị */
    public static final String REQ_USER_PHONE = "USER_PHONE";
    
    /** Biến cờ (Boolean): True nếu đang ở chế độ chỉnh sửa xe, False nếu là thêm xe mới */
    public static final String REQ_IS_EDIT = "isEdit";
    
    /** Lưu đối tượng Vehicle (Thông tin chiếc xe cụ thể) được chọn để chỉnh sửa */
    public static final String REQ_USER_VEHICLE = "USER_VEHICLE";
    
    /** Lưu tên hiển thị riêng cho module Hồ sơ cá nhân */
    public static final String REQ_PROFILE_FULL_NAME = "PROFILE_FULL_NAME";
    
    /** Lưu số điện thoại riêng cho module Hồ sơ cá nhân */
    public static final String REQ_PROFILE_PHONE = "PROFILE_PHONE";
    
    /** Lưu email riêng cho module Hồ sơ cá nhân */
    public static final String REQ_PROFILE_EMAIL = "PROFILE_EMAIL";
    
    /** Lưu tên hạng thành viên (VD: MEMBER, SILVER, GOLD, PLATINUM) của người dùng */
    public static final String REQ_PROFILE_TIER_NAME = "PROFILE_TIER_NAME";
    
    /** Lưu chuỗi ngày tham gia hệ thống đã được định dạng (dd/MM/yyyy) */
    public static final String REQ_PROFILE_JOIN_DATE = "PROFILE_JOIN_DATE";
    
    /** Lưu điểm số hiển thị riêng trên giao diện Hồ sơ cá nhân */
    public static final String REQ_PROFILE_TOTAL_POINTS = "PROFILE_TOTAL_POINTS";
    
    /** Lưu tổng tiền chi tiêu hiển thị riêng trên giao diện Hồ sơ cá nhân */
    public static final String REQ_PROFILE_TOTAL_SPENT_MONEY = "PROFILE_TOTAL_SPENT_MONEY";
    
    /** Lưu chữ cái đầu tiên của tên User (dùng để vẽ Avatar mặc định theo tên khách) */
    public static final String REQ_PROFILE_AVATAR_INITIAL = "PROFILE_AVATAR_INITIAL";
    
    /** Lưu tổng số lượng xe (Integer) mà khách hàng này đang sở hữu */
    public static final String REQ_PROFILE_TOTAL_CARS = "PROFILE_TOTAL_CARS";
    
    
    /* =========================================================================
     * 4. LOYALTY REWARDS & TIER PROGRESS KEYS (Hệ thống đổi thưởng và Tiến trình hạng)
     * Sử dụng độc quyền cho module RewardServlet tính toán in-memory đẩy ra rewards.jsp.
     * ========================================================================= */

    /** Lưu tổng tiền chi tiêu (Dạng dữ liệu gốc primitive) phục vụ tính toán ở trang thưởng */
    public static final String REQ_TOTAL_SPENT_MONEY = "TOTAL_SPENT_MONEY";
    
    /** Lưu điểm số hiện tại của user phục vụ tính toán thanh tiến độ đổi thưởng */
    public static final String REQ_USER_POINTS = "USER_POINTS";
    
    /** Lưu tên người dùng phục vụ hiển thị câu chào riêng trên trang đổi thưởng */
    public static final String REQ_USER_DISPLAY_NAME = "USER_DISPLAY_NAME";
    
    /** Lưu List<RewardDTO> chứa danh sách tất cả các phần thưởng lấy từ bảng Reward trong DB */
    public static final String REQ_REWARD_LIST = "REWARD_LIST";
    
    /** Lưu Map<Integer, String> ánh xạ vị trí phần thưởng với tên Icon Material Design tương ứng */
    public static final String REQ_REWARD_ICONS = "REWARD_ICONS";
    
    /** Lưu chuỗi tên hạng thành viên hiện tại của khách sau khi tính toán trên RAM */
    public static final String REQ_MEMBER_TIER = "MEMBER_TIER";
    
    /** Lưu mô tả quyền lợi/ưu đãi đặc quyền của hạng thành viên hiện tại */
    public static final String REQ_TIER_BENEFIT = "TIER_BENEFIT";
    
    /** Lưu tên của phần thưởng tiếp theo mà người dùng SẮP ĐẠT ĐƯỢC */
    public static final String REQ_NEXT_REWARD_NAME = "NEXT_REWARD_NAME";
    
    /** Lưu số điểm yêu cầu (mốc điểm) của phần thưởng tiếp theo đó */
    public static final String REQ_NEXT_REWARD_POINTS = "NEXT_REWARD_POINTS";
    
    /** [Khóa cũ/Dự phòng] Lưu phần trăm tiến độ chung */
    public static final String REQ_PROGRESS_PERCENT = "PROGRESS_PERCENT";
    
    /** [Khóa cũ/Dự phòng] Lưu số điểm còn thiếu chung */
    public static final String REQ_POINTS_NEEDED = "POINTS_NEEDED";
    
    /** [Dự phòng] Lưu tên phần thưởng kế tiếp (Phương án thay thế) */
    public static final String REQ_NEXT_REWARD_NAME_ALT = "NEXT_REWARD_NAME_ALT";
    
    /** [Dự phòng] Lưu điểm phần thưởng kế tiếp (Phương án thay thế) */
    public static final String REQ_NEXT_REWARD_POINTS_ALT = "NEXT_REWARD_POINTS_ALT";
    
    /** Lưu giá trị phần trăm (Double: 0.0 -> 100.0) tiến độ tích lũy điểm đổi phần thưởng tiếp theo */
    public static final String REQ_REWARD_PROGRESS_PERCENT = "REWARD_PROGRESS_PERCENT";
    
    /** Lưu số điểm chính xác còn thiếu (Integer) để người dùng đổi được phần thưởng tiếp theo */
    public static final String REQ_POINTS_NEEDED_FOR_REWARD = "POINTS_NEEDED_FOR_REWARD";
    
    /** Lưu tên của HẠNG THÀNH VIÊN TIẾP THEO (VD: Nếu đang là SILVER thì lưu "GOLD") */
    public static final String REQ_NEXT_TIER_NAME = "NEXT_TIER_NAME";
    
    /** Lưu mốc tiền (Long) bắt buộc phải đạt được để thăng lên hạng thành viên tiếp theo */
    public static final String REQ_NEXT_TIER_POINTS = "NEXT_TIER_POINTS";
    
    /** Lưu giá trị phần trăm (Double: 0.0 -> 100.0) tiến độ chi tiêu để thăng hạng thành viên */
    public static final String REQ_TIER_PROGRESS_PERCENT = "TIER_PROGRESS_PERCENT";
    
    /** Lưu số tiền chính xác còn thiếu (Long - VND) để user được thăng lên hạng tiếp theo */
    public static final String REQ_MONEY_TO_NEXT_TIER = "MONEY_TO_NEXT_TIER";


    /* =========================================================================
     * 5. AI CHAT SUPPORT KEYS (Hệ thống Trợ lý ảo Chatbot AI gợi ý tính năng)
     * Sử dụng trong MainController để quản lý cookies và hiển thị hội thoại hỗ trợ.
     * ========================================================================= */

    /** Lưu tên tính năng được đề xuất (Gợi ý từ AI dựa vào hành vi người dùng) */
    public static final String REQ_CHAT_SUPPORT_FEATURE = "CHAT_SUPPORT_FEATURE";
    
    /** Lưu nội dung phản hồi/câu thoại của trợ lý ảo AI gửi tới người dùng */
    public static final String REQ_CHAT_SUPPORT_RESPONSE = "CHAT_SUPPORT_RESPONSE";
    
    /** Biến cờ (Boolean): Xác định xem trình duyệt của user có lưu lịch sử chat bằng Cookie không */
    public static final String REQ_CHAT_SUPPORT_HAS_COOKIE = "CHAT_SUPPORT_HAS_COOKIE";
    
    /** Lưu thông báo lỗi nếu cú pháp lệnh hoặc luồng xử lý Chatbot gặp sự cố */
    public static final String REQ_CHAT_SUPPORT_ERROR = "CHAT_SUPPORT_ERROR";
}