package controller;

import dao.VehicleDAO;
import dto.User;
import dto.Vehicle;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

@WebServlet(name = "EditVehicleServlet", urlPatterns = {"/EditVehicleServlet"})
public class EditVehicleServlet extends HttpServlet {

    /**
     * Xử lý yêu cầu HTTP GET gửi đến để tải thông tin xe cần chỉnh sửa và hiển thị lên giao diện.
     * 
     * Bài toán giải quyết:
     * - Tiếp nhận yêu cầu sửa đổi thông tin xe dựa trên mã ID xe (`vehicleId`) truyền trên URL.
     * - Kiểm tra xem người dùng đã đăng nhập chưa.
     * - Kiểm tra tính hợp lệ của ID xe và sự tồn tại của xe trong cơ sở dữ liệu.
     * - Kiểm tra quyền sở hữu xe (Access Control): Đảm bảo người dùng chỉ được sửa xe của chính mình,
     *   tránh lỗ hổng IDOR (Insecure Direct Object Reference).
     * - Truyền thông tin xe sang trang JSP hiển thị form sửa xe.
     * 
     * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input):
     *   + Lấy từ HttpSession: Đối tượng tài khoản `User` (AppKeys.SESSION_ACCOUNT) để kiểm tra đăng nhập và đối chiếu ID khách hàng.
     *   + Lấy từ Request Parameter: "vehicleId" (Mã ID của xe cần chỉnh sửa).
     * - Đầu ra (Output):
     *   + Nếu chưa đăng nhập: Chuyển hướng trình duyệt (Redirect) về trang đăng nhập.
     *   + Nếu ID xe không hợp lệ, không tồn tại hoặc không thuộc về người dùng: Chuyển hướng trình duyệt về trang Profile cá nhân.
     *   + Nếu hợp lệ: Thiết lập thuộc tính request "REQ_IS_EDIT" là true, thiết lập đối tượng xe gốc vào request attribute "REQ_USER_VEHICLE" và chuyển tiếp (Forward) sang trang "/addvehicle.jsp".
     * - Tương tác Database:
     *   + Gọi `vDao.getVehicleById(vid)` để truy vấn thông tin chi tiết xe từ DB.
     * 
     * @param request  Đối tượng HttpServletRequest chứa thông tin yêu cầu.
     * @param response Đối tượng HttpServletResponse để gửi phản hồi.
     * @throws ServletException Nếu xảy ra lỗi liên quan đến Servlet.
     * @throws IOException      Nếu xảy ra lỗi luồng đọc/ghi dữ liệu.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy session hiện tại của người dùng, không tạo mới session nếu chưa tồn tại (false)
        HttpSession session = request.getSession(false);
        
        // TOÁN TỬ BA NGÔI lấy thông tin tài khoản người dùng đang đăng nhập:
        // - Điều kiện: session != null (Kiểm tra xem session của client có hợp lệ không).
        // - Đúng (Session tồn tại): Lấy đối tượng User từ session attribute AppKeys.SESSION_ACCOUNT.
        // - Sai (Session null): Trả về giá trị null.
        User account = session != null ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
        
        // Kiểm tra phân quyền đăng nhập
        if (account == null) {
            // Nếu chưa đăng nhập, chuyển hướng người dùng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return; // Dừng xử lý hàm doGet
        }

        // Lấy chuỗi ID xe từ request parameter truyền trên URL
        String idStr = request.getParameter("vehicleId");
        int vid = 0; // Khởi tạo ID xe mặc định là 0 (không hợp lệ)
        
        try { 
            // Cố gắng chuyển đổi tham số ID xe từ chuỗi sang kiểu số nguyên int
            vid = Integer.parseInt(idStr); 
        } catch (Exception e) { 
            // Nếu xảy ra ngoại lệ (ví dụ người dùng nhập chữ viết thay vì số), giữ nguyên vid = 0
            vid = 0; 
        }
        
        // Kiểm tra ID xe: Nếu ID xe nhỏ hơn hoặc bằng 0 (không hợp lệ)
        if (vid <= 0) {
            // Chuyển hướng người dùng quay lại trang quản lý Profile
            response.sendRedirect(request.getContextPath() + "/MainController?action=Profile");
            return; // Dừng xử lý
        }

        // Khởi tạo đối tượng VehicleDAO để làm việc với database
        VehicleDAO vDao = new VehicleDAO();
        // Truy vấn thông tin xe cụ thể từ database dựa trên ID xe hợp lệ vừa nhận được
        Vehicle v = vDao.getVehicleById(vid);
        
        // KIỂM TRA BẢO MẬT & QUYỀN SỞ HỮU XE (Chống lỗ hổng IDOR):
        // Điều kiện kiểm tra:
        // - v == null: Xe không tồn tại trong hệ thống.
        // - Hoặc v.getCustomerId() != account.getId(): Xe tồn tại nhưng mã chủ sở hữu của chiếc xe này 
        //   khác với mã ID của tài khoản người dùng đang đăng nhập.
        if (v == null || v.getCustomerId() != account.getId()) {
            // Ngăn chặn hành vi truy cập trái phép bằng cách chuyển hướng người dùng về lại trang Profile cá nhân của chính họ
            response.sendRedirect(request.getContextPath() + "/MainController?action=Profile");
            return; // Dừng xử lý
        }

        // Nếu mọi kiểm tra đều hợp lệ:
        // Thiết lập cờ báo hiệu cho trang JSP biết đây là chế độ CHỈNH SỬA XE (Edit) chứ không phải thêm mới
        request.setAttribute(AppKeys.REQ_IS_EDIT, true);
        // Lưu đối tượng xe vừa lấy từ DB vào request attribute để điền tự động dữ liệu cũ vào các ô nhập liệu của form
        request.setAttribute(AppKeys.REQ_USER_VEHICLE, v);
        // Chuyển tiếp request và response sang trang addvehicle.jsp để hiển thị form chỉnh sửa xe
        request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
    }
}
