package controller;

import dao.VehicleDAO;
import dto.User;
import dto.Vehicle;
import java.io.IOException;
import java.util.regex.Pattern;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

@WebServlet(name = "AddVehicleServlet", urlPatterns = {"/AddVehicleServlet"})
public class AddVehicleServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AddVehicleServlet.class.getName());

    /**
     * Xử lý các yêu cầu HTTP POST gửi đến để thêm mới một xe hoặc cập nhật thông tin một xe hiện có.
     * 
     * Bài toán giải quyết:
     * - Tiếp nhận dữ liệu biểu mẫu (form) của phương tiện từ người dùng.
     * - Kiểm tra tính hợp lệ của dữ liệu đầu vào ở phía Server (Server-side validation) như kiểm tra trống và định dạng biển số xe.
     * - Kiểm tra tính trùng lặp của biển số xe trong cơ sở dữ liệu (ngoại trừ chính chiếc xe đó nếu đang cập nhật).
     * - Thực hiện lưu thông tin (Insert hoặc Update) vào cơ sở dữ liệu và điều hướng người dùng tương ứng.
     * 
     * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input):
     *   + Lấy từ HttpSession: Đối tượng tài khoản người dùng đăng nhập (AppKeys.SESSION_ACCOUNT) để kiểm tra quyền và lấy mã khách hàng (customerId).
     *   + Lấy từ Request Parameter: 
     *     * "licensePlate": Biển số xe cần thêm/sửa.
     *     * "brand": Hãng sản xuất của xe.
     *     * "model": Tên dòng xe (model).
     *     * "color": Màu sắc của xe.
     *     * "vehicleId": Mã ID của xe (nếu bằng 0 hoặc trống tức là thêm mới, nếu lớn hơn 0 tức là cập nhật xe cũ).
     * - Đầu ra (Output):
     *   + Nếu thành công: Redirect (chuyển hướng trình duyệt) tới trang thông tin cá nhân "/MainController?action=Profile".
     *   + Nếu thất bại/Lỗi validation: Thiết lập lỗi vào request attribute "REQ_ERROR", lưu lại thông tin xe đang thao tác vào request attribute và Forward (chuyển tiếp nội bộ) về lại trang hiển thị form "/addvehicle.jsp".
     * - Tương tác Database:
     *   + Gọi `vDao.isLicenseTaken(lic, vehicleId)` để kiểm tra biển số xe đã được đăng ký cho xe khác chưa.
     *   + Gọi `vDao.insertVehicle(v)` để lưu xe mới vào bảng Vehicle.
     *   + Gọi `vDao.updateVehicle(v)` để cập nhật xe cũ trong bảng Vehicle.
     *   + Gọi `vDao.getVehicleById(vehicleId)` để lấy lại dữ liệu xe cũ từ cơ sở dữ liệu khi cần hiển thị lại form lỗi.
     * 
     * @param request  Đối tượng HttpServletRequest chứa thông tin yêu cầu từ client.
     * @param response Đối tượng HttpServletResponse để gửi phản hồi về client.
     * @throws ServletException Nếu xảy ra lỗi liên quan đến Servlet.
     * @throws IOException      Nếu xảy ra lỗi luồng đọc/ghi dữ liệu.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập bộ mã hóa ký tự UTF-8 cho yêu cầu để tránh lỗi hiển thị tiếng Việt có dấu từ form gửi lên.
        request.setCharacterEncoding("UTF-8");
        // Định dạng kiểu phản hồi trả về client là văn bản HTML với bộ mã hóa ký tự UTF-8.
        response.setContentType("text/html;charset=UTF-8");

        // Lấy session hiện tại mà không tự động tạo mới nếu session chưa tồn tại (false).
        HttpSession session = request.getSession(false);
        
        // TOÁN TỬ BA NGÔI lấy thông tin tài khoản người dùng đang đăng nhập:
        // - Điều kiện: session != null (Kiểm tra xem đối tượng session hiện tại có tồn tại hay không).
        // - Đúng (session tồn tại): Ép kiểu và lấy đối tượng User từ thuộc tính session với khóa AppKeys.SESSION_ACCOUNT.
        // - Sai (session chưa được tạo): Gán giá trị null cho đối tượng account.
        User account = session != null ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
        
        // Kiểm tra phân quyền: Nếu account là null (chưa đăng nhập hoặc session đã hết hạn)
        if (account == null) {
            // Chuyển hướng người dùng về trang đăng nhập thông qua MainController với action=Login
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return; // Kết thúc xử lý hàm doPost ngay tại đây
        }

        // Đọc các giá trị parameter gửi lên từ các thẻ input của biểu mẫu (form) nhập thông tin xe
        String license = request.getParameter("licensePlate"); // Biển số xe
        String brand = request.getParameter("brand");               // Hãng xe
        String model = request.getParameter("model");               // Dòng xe
        String color = request.getParameter("color");               // Màu xe

        // Thực hiện kiểm tra tính hợp lệ dữ liệu ở phía Server (Server-side validation) để tránh dữ liệu rác hoặc bypass client-side
        StringBuilder err = new StringBuilder();
        
        // Kiểm tra nếu trường biển số bị bỏ trống hoặc chỉ chứa khoảng trắng
        if (license == null || license.trim().isEmpty()) {
            err.append("Biển số không được để trống. ");
        }
        // Kiểm tra nếu trường hãng xe bị bỏ trống hoặc chỉ chứa khoảng trắng
        if (brand == null || brand.trim().isEmpty()) {
            err.append("Hãng xe không được để trống. ");
        }
        // Kiểm tra nếu trường model xe bị bỏ trống hoặc chỉ chứa khoảng trắng
        if (model == null || model.trim().isEmpty()) {
            err.append("Model xe không được để trống. ");
        }
        // Kiểm tra nếu trường màu sắc bị bỏ trống hoặc chỉ chứa khoảng trắng
        if (color == null || color.trim().isEmpty()) {
            err.append("Màu sắc không được để trống. ");
        }
        
        // Nếu chuỗi thông báo lỗi chứa bất kỳ nội dung nào (độ dài > 0) nghĩa là có trường dữ liệu không hợp lệ
        if (err.length() > 0) {
            // Đưa thông điệp lỗi vào request attribute để trang JSP có thể hiển thị cho người dùng biết
            request.setAttribute(AppKeys.REQ_ERROR, err.toString());
            // Thực hiện chuyển tiếp request và response nội bộ về trang addvehicle.jsp để người dùng nhập lại thông tin
            request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
            return; // Dừng xử lý
        }

        // Chuẩn hóa biển số xe: loại bỏ các khoảng trắng thừa ở hai đầu và chuyển toàn bộ chữ cái thành chữ hoa
        String lic = license.trim().toUpperCase();
        
        // Định nghĩa 2 biểu thức chính quy (Regex Pattern) dùng để kiểm định dạng biển số xe:
        // - Pattern p1: Định dạng biển số xe Việt Nam tiêu chuẩn dạng 5 số mới (Ví dụ: 30A-123.45).
        //   + ^[0-9]{2,3}: Bắt đầu bằng 2 hoặc 3 chữ số (mã tỉnh thành).
        //   + [A-Z]: Một ký tự chữ cái in hoa (loại xe).
        //   + -[0-9]{3}: Dấu gạch ngang kèm theo đúng 3 chữ số tiếp theo.
        //   + \\.[0-9]{2}$: Kết thúc bằng dấu chấm và đúng 2 chữ số cuối.
        Pattern p1 = Pattern.compile("^[0-9]{2,3}[A-Z]-[0-9]{3}\\.[0-9]{2}$"); 
        
        // - Pattern p2: Định dạng dự phòng linh hoạt hơn (mẫu thoáng), cho phép từ 4 đến 12 ký tự chữ số, chữ cái, khoảng trắng, dấu gạch ngang hoặc dấu chấm.
        Pattern p2 = Pattern.compile("^[0-9A-Z .\\-]{4,12}$"); 
        
        // Kiểm tra nếu biển số nhập vào không khớp với bất kỳ biểu mẫu định dạng nào trong hai mẫu trên
        if (! (p1.matcher(lic).matches() || p2.matcher(lic).matches())) {
            // TOÁN TỬ BA NGÔI tạo thông điệp thông báo lỗi biển số:
            // - Điều kiện: err.length() > 0 (Kiểm tra xem trước đó đã có thông báo lỗi nào chưa).
            // - Đúng (đã có lỗi khác): Nối thêm chuỗi lỗi "Biển số không hợp lệ." vào cuối thông báo cũ.
            // - Sai (chưa có lỗi nào): Gán thông báo lỗi chi tiết kèm ví dụ minh họa "Biển số không hợp lệ. Ví dụ hợp lệ: 30A-123.45".
            request.setAttribute(AppKeys.REQ_ERROR, err.length() > 0 ? err.toString() + "Biển số không hợp lệ." : "Biển số không hợp lệ. Ví dụ hợp lệ: 30A-123.45");
            // Forward ngược lại form addvehicle.jsp để yêu cầu chỉnh sửa lại biển số xe
            request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
            return; // Dừng xử lý
        }

        try {
            // Khởi tạo đối tượng truy xuất dữ liệu phương tiện (VehicleDAO)
            VehicleDAO vDao = new VehicleDAO();
            
            // Lấy mã ID của xe cần chỉnh sửa từ request parameter
            String vehicleIdStr = request.getParameter("vehicleId");
            int vehicleId = 0; // Mặc định gán là 0 (đại diện cho thao tác thêm mới xe)
            
            // Kiểm tra xem tham số vehicleId gửi lên từ form có hợp lệ hay không (khác null và không rỗng)
            if (vehicleIdStr != null && !vehicleIdStr.trim().isEmpty()) {
                try { 
                    // Chuyển đổi định dạng chuỗi của ID xe sang kiểu số nguyên int
                    vehicleId = Integer.parseInt(vehicleIdStr); 
                } catch (NumberFormatException ex) { 
                    // Nếu lỗi format (chuỗi không phải là số), gán ID xe về 0 để hệ thống xử lý như thêm mới
                    vehicleId = 0; 
                }
            }

            // Tạo mới một đối tượng Vehicle chứa các thông tin đã chuẩn hóa để chuẩn bị insert hoặc update.
            // Các toán tử ba ngôi lồng bên trong constructor dùng để gán giá trị mặc định cho Hãng, Dòng xe, và Màu sắc:
            // - Điều kiện: brand/model/color != null (Kiểm tra xem tham số có khác null không).
            // - Đúng: Tiến hành loại bỏ khoảng trắng thừa hai đầu bằng trim().
            // - Sai: Gán bằng chuỗi rỗng "" để tránh việc cơ sở dữ liệu lưu giá trị null gây lỗi hiển thị.
            Vehicle v = new Vehicle(
                vehicleId, 
                account.getId(), 
                lic, 
                brand != null ? brand.trim() : "", 
                model != null ? model.trim() : "", 
                color != null ? color.trim() : ""
            );

            // Kiểm tra trùng lặp biển số: Gọi hàm isLicenseTaken trong DAO.
            // Truyền lic (biển số xe cần kiểm tra) và vehicleId (ID của xe hiện tại).
            // Nếu vehicleId > 0, hệ thống sẽ bỏ qua kiểm tra trùng biển số đối với chính chiếc xe đó trong CSDL.
            if (vDao.isLicenseTaken(lic, vehicleId)) {
                // Đưa thông điệp báo trùng biển số xe vào request attribute để hiển thị trên JSP
                request.setAttribute(AppKeys.REQ_ERROR, "Biển số đã tồn tại. Vui lòng kiểm tra lại.");
                
                // TOÁN TỬ BA NGÔI / BIỂU THỨC LOGIC xác định trạng thái form khi phản hồi lỗi:
                // Gán cờ REQ_IS_EDIT là true nếu vehicleId > 0 (đang sửa xe), ngược lại gán false (đang thêm xe).
                request.setAttribute(AppKeys.REQ_IS_EDIT, vehicleId > 0);
                
                // Lưu thông tin xe ban đầu từ DB để hiển thị lại trên form (không dùng đối tượng lỗi v vừa nhập sai biển số)
                request.setAttribute(AppKeys.REQ_USER_VEHICLE, vDao.getVehicleById(vehicleId));
                
                // Quay lại trang jsp để hiển thị lỗi
                request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
                return; // Dừng xử lý
            }

            boolean ok; // Biến cờ lưu kết quả thực thi thao tác lưu dữ liệu (true nếu thành công)
            
            // Phân loại luồng nghiệp vụ dựa trên ID xe:
            if (vehicleId > 0) {
                // Nếu ID xe > 0 nghĩa là xe đã tồn tại trong CSDL, ta thực hiện cập nhật (Update) thông tin xe
                ok = vDao.updateVehicle(v);
            } else {
                // Nếu ID xe = 0 nghĩa là xe chưa tồn tại, ta thực hiện thêm mới (Insert) xe vào garage
                ok = vDao.insertVehicle(v);
            }

            // Nếu thao tác thêm mới hoặc cập nhật cơ sở dữ liệu thành công
            if (ok) {
                // Redirect người dùng về trang quản trị thông tin cá nhân Profile (nơi chứa danh sách Garage)
                response.sendRedirect(request.getContextPath() + "/MainController?action=Profile");
                return; // Kết thúc thành công
            } else {
                // Nếu DB báo lỗi không thực thi được câu lệnh SQL (ví dụ mất kết nối CSDL, sai ràng buộc khóa ngoại...)
                request.setAttribute(AppKeys.REQ_ERROR, "Không thể lưu xe. Vui lòng thử lại.");
                
                // Gán trạng thái cờ edit dựa trên việc vehicleId > 0
                request.setAttribute(AppKeys.REQ_IS_EDIT, vehicleId > 0);
                
                // TOÁN TỬ BA NGÔI thiết lập dữ liệu phương tiện gửi lại cho form JSP:
                // - Điều kiện: vehicleId > 0 (Xác định đây là thao tác cập nhật hay thêm mới).
                // - Đúng (Sửa xe): Truy vấn lại thông tin xe gốc từ database để khôi phục dữ liệu hợp lệ ban đầu trên form.
                // - Sai (Thêm xe): Trả lại chính đối tượng xe lỗi v chứa thông tin người dùng vừa nhập để tránh việc họ phải gõ lại.
                request.setAttribute(AppKeys.REQ_USER_VEHICLE, vehicleId > 0 ? vDao.getVehicleById(vehicleId) : v);
                
                // Quay lại trang nhập xe kèm thông báo lỗi
                request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            // Ghi nhận log chi tiết lỗi hệ thống kèm theo exception e để phục vụ việc debug
            LOGGER.log(Level.SEVERE, "Failed to add/update vehicle", e);
            // Thiết lập thông báo lỗi hệ thống gửi về cho giao diện người dùng
            request.setAttribute(AppKeys.REQ_ERROR, "Lỗi server: " + e.getMessage());
            // Chuyển tiếp request về trang jsp
            request.getRequestDispatcher("/addvehicle.jsp").forward(request, response);
        }
    }
}
