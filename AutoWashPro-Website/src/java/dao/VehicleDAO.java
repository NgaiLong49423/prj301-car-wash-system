package dao;

import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import mylib.DBUtils;

public class VehicleDAO {

    private static final Logger LOGGER = Logger.getLogger(VehicleDAO.class.getName());
    
    /**
     * Truy vấn danh sách toàn bộ các xe thuộc sở hữu của một khách hàng cụ thể.
     * 
     * Bài toán giải quyết:
     * - Lấy ra danh sách phương tiện của khách hàng để hiển thị lên Garage trong trang Profile.
     * 
     * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input): Mã khách hàng `customerId` (được truyền vào qua đối số hàm).
     * - Đầu ra (Output): Danh sách `ArrayList<Vehicle>` chứa các xe tìm thấy (nếu không có xe nào hoặc lỗi kết nối, trả về một danh sách rỗng).
     * - Tương tác Database: Thực hiện câu lệnh SQL SELECT lọc theo `customer_id` trong bảng `Vehicle`.
     * 
     * @param customerId Mã định danh ID của khách hàng sở hữu xe.
     * @return Danh sách các xe thuộc sở hữu của khách hàng.
     */
    public ArrayList<Vehicle> getCars(int customerId) {
        // Khởi tạo danh sách trống để lưu trữ các đối tượng xe
        ArrayList<Vehicle> list = new ArrayList<>();
        Connection cn = null; // Đối tượng kết nối CSDL
        PreparedStatement st = null; // Đối tượng chuẩn bị câu lệnh SQL
        ResultSet table = null; // Đối tượng chứa kết quả truy vấn từ DB
        
        try {
            // Mở kết nối tới cơ sở dữ liệu qua DBUtils
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Định nghĩa câu lệnh SQL SELECT để lấy các cột cần thiết từ bảng Vehicle lọc theo mã khách hàng
                String sql = "SELECT vehicle_id, customer_id, license_plate, brand, model, color FROM Vehicle WHERE customer_id = ?";
                st = cn.prepareStatement(sql);
                // Truyền tham số mã khách hàng vào vị trí dấu chấm hỏi đầu tiên trong câu lệnh SQL
                st.setInt(1, customerId);
                // Thực thi câu lệnh truy vấn SQL SELECT và lấy về tập kết quả ResultSet
                table = st.executeQuery();
                
                // Duyệt qua từng hàng dữ liệu trả về từ bảng kết quả
                while (table.next()) {
                    // Trích xuất dữ liệu từ các cột tương ứng trong ResultSet
                    int vId = table.getInt("vehicle_id");
                    String licensePlate = table.getString("license_plate");
                    String brand = table.getNString("brand"); // Sử dụng getNString để hỗ trợ đọc chuỗi Unicode (tiếng Việt)
                    String model = table.getNString("model"); // Sử dụng getNString để hỗ trợ đọc chuỗi Unicode
                    String color = table.getNString("color"); // Sử dụng getNString để hỗ trợ đọc chuỗi Unicode
                    
                    // Khởi tạo đối tượng Vehicle từ dữ liệu trích xuất được (Không có ngày tạo do cấu trúc bảng hiện tại không hỗ trợ)
                    Vehicle v = new Vehicle(vId, customerId, licensePlate, brand, model, color);
                    // Thêm xe vừa khởi tạo vào danh sách kết quả
                    list.add(v);
                }
            }
        } catch (Exception e) {
            // Ghi nhận lỗi chi tiết vào Logger nếu quá trình truy vấn danh sách xe bị thất bại
            LOGGER.log(Level.SEVERE, "Failed to load vehicles for customerId=" + customerId, e);
        } finally {
            // Giải phóng các tài nguyên kết nối Database ở khối finally để đảm bảo không bị rò rỉ kết nối (connection leak)
            try {
                // Đóng ResultSet trước
                if (table != null) table.close();
                // Đóng PreparedStatement tiếp theo
                if (st != null) st.close();
                // Đóng Connection cuối cùng
                if (cn != null) cn.close();
            } catch (Exception e) {
                // Ghi nhận lỗi nếu có ngoại lệ xảy ra trong lúc giải phóng tài nguyên
                LOGGER.log(Level.SEVERE, "Failed to close resources when loading vehicles for customerId=" + customerId, e);
            }
        }
        // Trả về danh sách xe đã thu thập được
        return list;
    }

    /**
     * Thêm mới thông tin một chiếc xe vào cơ sở dữ liệu.
     * 
     * Bài toán giải quyết:
     * - Lưu trữ vĩnh viễn thông tin xe mới vào bảng `Vehicle`.
     * - Nhận lại ID tự động tăng được CSDL sinh ra để đồng bộ lại với đối tượng DTO trên Java.
     * 
     * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input): Đối tượng `Vehicle v` chứa thông tin xe (chủ xe, biển số, hãng xe, dòng xe, màu sắc).
     * - Đầu ra (Output): Trả về `true` nếu chèn dữ liệu thành công vào DB, `false` nếu thất bại.
     * - Tương tác Database: Thực hiện lệnh `INSERT INTO Vehicle...` sử dụng `RETURN_GENERATED_KEYS`.
     * 
     * @param v Đối tượng xe chứa thông tin chi tiết cần thêm.
     * @return true nếu thêm xe thành công, ngược lại trả về false.
     */
    public boolean insertVehicle(Vehicle v) {
        Connection cn = null; // Đối tượng kết nối CSDL
        PreparedStatement st = null; // Đối tượng chuẩn bị câu lệnh SQL
        try {
            // Mở kết nối cơ sở dữ liệu
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Câu lệnh SQL chèn bản ghi mới vào bảng Vehicle
                String sql = "INSERT INTO Vehicle(customer_id, license_plate, brand, model, color) VALUES(?,?,?,?,?)";
                // Thiết lập PreparedStatement kèm cờ yêu cầu DB trả về các khóa tự động sinh ra (RETURN_GENERATED_KEYS)
                st = cn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
                // Truyền tuần tự các tham số từ đối tượng Vehicle vào các dấu hỏi chấm trong SQL
                st.setInt(1, v.getCustomerId());
                st.setString(2, v.getLicensePlate());
                st.setNString(3, v.getBrand()); // Hỗ trợ ký tự tiếng Việt Unicode
                st.setNString(4, v.getModel()); // Hỗ trợ ký tự tiếng Việt Unicode
                st.setNString(5, v.getColor()); // Hỗ trợ ký tự tiếng Việt Unicode
                
                // Thực thi câu lệnh SQL INSERT và lấy về số lượng bản ghi bị ảnh hưởng (affected rows)
                int affected = st.executeUpdate();
                
                // Nếu số lượng bản ghi bị ảnh hưởng lớn hơn 0 (nghĩa là đã chèn thành công bản ghi mới)
                if (affected > 0) {
                    // Lấy ra ResultSet chứa các khóa tự động sinh (ID tự tăng)
                    try (ResultSet keys = st.getGeneratedKeys()) {
                        // Nếu có khóa tự động sinh trả về
                        if (keys != null && keys.next()) {
                            // Gán khóa vừa sinh (ở cột số 1) ngược lại vào ID của đối tượng Vehicle truyền vào
                            v.setVehicleId(keys.getInt(1));
                        }
                    }
                    return true; // Trả về kết quả chèn thành công
                }
            }
        } catch (Exception e) {
            // Ghi nhận log lỗi chèn xe mới
            LOGGER.log(Level.SEVERE, "Failed to insert vehicle for customerId=" + v.getCustomerId(), e);
        } finally {
            // Đóng các tài nguyên cơ sở dữ liệu
            try {
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when inserting vehicle", e);
            }
        }
        return false; // Trả về thất bại nếu có lỗi xảy ra hoặc không chèn được dòng nào
    }

    /**
     * Truy vấn thông tin chi tiết của một chiếc xe bằng mã ID xe.
     * 
     * Bài toán giải quyết:
     * - Tìm kiếm xe trong database theo khóa chính để hiển thị thông tin hoặc kiểm tra bảo mật.
     * 
     * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input): Số nguyên `vehicleId` đại diện cho ID xe cần tìm.
     * - Đầu ra (Output): Đối tượng `Vehicle` chứa thông tin xe nếu tìm thấy, hoặc trả về `null` nếu không tồn tại.
     * - Tương tác Database: Thực hiện câu lệnh SQL SELECT lọc theo `vehicle_id = ?`.
     * 
     * @param vehicleId Mã khóa chính của xe cần tìm.
     * @return Đối tượng Vehicle tương ứng hoặc null nếu không thấy.
     */
    public Vehicle getVehicleById(int vehicleId) {
        Connection cn = null; // Kết nối CSDL
        PreparedStatement st = null; // Câu lệnh SQL chuẩn bị trước
        ResultSet rs = null; // Tập kết quả truy vấn CSDL
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Câu lệnh SQL SELECT tìm xe theo khóa chính vehicle_id
                String sql = "SELECT vehicle_id, customer_id, license_plate, brand, model, color FROM Vehicle WHERE vehicle_id = ?";
                st = cn.prepareStatement(sql);
                st.setInt(1, vehicleId);
                // Thực thi câu lệnh
                rs = st.executeQuery();
                // Nếu tìm thấy bản ghi tương ứng
                if (rs.next()) {
                    // Lấy ra các trường thông tin của xe
                    int customerId = rs.getInt("customer_id");
                    String licensePlate = rs.getString("license_plate");
                    String brand = rs.getNString("brand");
                    String model = rs.getNString("model");
                    String color = rs.getNString("color");
                    // Khởi tạo và trả về đối tượng Vehicle
                    return new Vehicle(vehicleId, customerId, licensePlate, brand, model, color);
                }
            }
        } catch (Exception e) {
            // Ghi nhận log lỗi tải xe theo ID
            LOGGER.log(Level.SEVERE, "Failed to load vehicle id=" + vehicleId, e);
        } finally {
            // Giải phóng các kết nối cơ sở dữ liệu
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when loading vehicle id=" + vehicleId, e);
            }
        }
        return null; // Trả về null nếu không tìm thấy xe hoặc xảy ra lỗi
    }

    /**
     * Cập nhật thông tin chi tiết của một chiếc xe hiện có trong database.
     * 
     * Bài toán giải quyết:
     * - Sửa đổi thông tin xe (biển số, hãng xe, model, màu sắc) trong database.
     * - Áp dụng cơ chế an toàn: Chỉ cập nhật nếu xe đó thuộc sở hữu của khách hàng đang đăng nhập,
     *   ngăn chặn việc sửa xe của người khác thông qua sửa đổi ID xe bừa bãi.
     * 
     * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input): Đối tượng `Vehicle v` chứa dữ liệu mới cần cập nhật kèm theo mã xe và mã chủ sở hữu hợp pháp.
     * - Đầu ra (Output): Trả về `true` nếu cập nhật thành công (có ít nhất 1 bản ghi bị ảnh hưởng), ngược lại trả về `false`.
     * - Tương tác Database: Thực hiện câu lệnh SQL UPDATE lọc theo điều kiện kép `vehicle_id = ? AND customer_id = ?`.
     * 
     * @param v Đối tượng xe chứa thông tin cập nhật mới.
     * @return true nếu cập nhật thành công, ngược lại trả về false.
     */
    public boolean updateVehicle(Vehicle v) {
        Connection cn = null; // Kết nối CSDL
        PreparedStatement st = null; // Chuẩn bị SQL
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Câu lệnh SQL cập nhật dữ liệu xe.
                // RÀNG BUỘC BẢO MẬT: Điều kiện WHERE kiểm tra đồng thời cả vehicle_id và customer_id 
                // để đảm bảo một khách hàng không thể cập nhật thông tin của xe thuộc về khách hàng khác.
                String sql = "UPDATE Vehicle SET license_plate = ?, brand = ?, model = ?, color = ? WHERE vehicle_id = ? AND customer_id = ?";
                st = cn.prepareStatement(sql);
                st.setString(1, v.getLicensePlate());
                st.setNString(2, v.getBrand());
                st.setNString(3, v.getModel());
                st.setNString(4, v.getColor());
                st.setInt(5, v.getVehicleId());
                st.setInt(6, v.getCustomerId());
                
                // Thực thi câu lệnh UPDATE và lấy số hàng bị thay đổi
                int affected = st.executeUpdate();
                // Trả về true nếu có ít nhất 1 hàng dữ liệu được cập nhật thành công
                return affected > 0;
            }
        } catch (Exception e) {
            // Ghi nhận log lỗi cập nhật xe
            LOGGER.log(Level.SEVERE, "Failed to update vehicle id=" + v.getVehicleId(), e);
        } finally {
            // Đóng các kết nối CSDL
            try {
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when updating vehicle id=" + v.getVehicleId(), e);
            }
        }
        return false; // Trả về thất bại nếu cập nhật không thành công hoặc lỗi kết nối
    }

    /**
     * Kiểm tra xem một biển số xe có bị trùng lặp với xe khác trong hệ thống hay chưa.
     * 
     * Bài toán giải quyết:
     * - Đảm bảo tính duy nhất của biển số xe trên hệ thống. 
     * - Hỗ trợ cho cả nghiệp vụ sửa xe: Bỏ qua xe hiện tại đang được chỉnh sửa khỏi phép so khớp 
     *   (để nếu khách hàng sửa thông tin khác của xe mà giữ nguyên biển số cũ thì hệ thống không báo trùng biển số của chính mình).
     * 
     * Luồng dữ liệu (Data Flow):
     * - Đầu vào (Input):
     *   + `licensePlate`: Chuỗi biển số xe cần kiểm tra trùng lặp.
     *   + `excludeVehicleId`: ID xe hiện tại cần loại trừ ra khỏi phép kiểm tra trùng (nếu là thêm mới xe thì truyền vào 0).
     * - Đầu ra (Output): Trả về `true` nếu biển số đã tồn tại trên một chiếc xe khác trong DB, ngược lại trả về `false`.
     * - Tương tác Database: Thực hiện câu lệnh SQL SELECT kiểm tra sự tồn tại trong bảng Vehicle với điều kiện `vehicle_id <> ?`.
     * 
     * @param licensePlate Biển số xe cần kiểm tra.
     * @param excludeVehicleId ID của chiếc xe hiện tại cần bỏ qua khi kiểm tra trùng.
     * @return true nếu biển số đã được đăng ký bởi xe khác, ngược lại trả về false.
     */
    public boolean isLicenseTaken(String licensePlate, int excludeVehicleId) {
        Connection cn = null; // Kết nối CSDL
        PreparedStatement st = null; // Chuẩn bị SQL
        ResultSet rs = null; // Tập kết quả từ DB
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Câu lệnh SQL tìm xe có biển số trùng khớp nhưng loại trừ ID xe hiện tại (vehicle_id <> ?)
                String sql = "SELECT vehicle_id FROM Vehicle WHERE license_plate = ? AND vehicle_id <> ?";
                st = cn.prepareStatement(sql);
                st.setString(1, licensePlate);
                st.setInt(2, excludeVehicleId);
                rs = st.executeQuery();
                // Nếu tập kết quả rs.next() trả về true nghĩa là có xe khác đã đăng ký biển số này rồi
                if (rs.next()) return true; 
                return false; // Chưa có xe nào đăng ký biển số này
            }
        } catch (Exception e) {
            // Ghi nhận log lỗi kiểm tra biển số
            LOGGER.log(Level.SEVERE, "Failed to check duplicate license plate: " + licensePlate, e);
        } finally {
            // Đóng kết nối
            try {
                if (rs != null) rs.close();
                if (st != null) st.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to close resources when checking license plate", e);
            }
        }
        return false; // Trả về false nếu kiểm tra không tìm thấy hoặc lỗi kết nối DB
    }
}