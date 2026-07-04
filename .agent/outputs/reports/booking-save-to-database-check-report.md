# Booking Save To Database Check Report

## 1. Kết luận nhanh

**Trạng thái:** **PASS**

Hệ thống hiện tại có luồng xử lý và lưu thông tin đặt lịch (booking) xuống cơ sở dữ liệu rất rõ ràng, đồng bộ và đầy đủ giữa các lớp từ Client-side (JSP) đến Server-side (Servlet, DTO, DAO) và Database (Schema, Seed Data). Cấu trúc của Database cũng hoàn toàn đảm bảo việc duy trì tính toàn vẹn dữ liệu (qua Transaction và các Foreign Key tương thích).

*Lưu ý: Báo cáo này dựa trên kết quả phân tích tĩnh (Static Code Review) vì môi trường hiện tại chưa được cài đặt Apache Ant trong biến môi trường PATH để chạy thử nghiệm runtime tự động.*

---

## 2. Luồng lưu booking hiện tại

Luồng dữ liệu và lời gọi hàm diễn ra tuần tự như sau khi người dùng thực hiện đặt lịch:

```
[booking.jsp] (Nhấn "Xác nhận đặt lịch" qua form POST)
      │
      ▼ (Gửi parameters: vehicleId, serviceId, bookingDate, bookingTime)
[CreateBookingServlet.doPost]
      │
      ├─► 1. Lấy thông tin tài khoản đăng nhập 'User' từ Session.
      ├─► 2. Gọi CustomerDAO lấy thông tin Hạng thành viên động của khách.
      ├─► 3. Validate ngày đặt lịch:
      │       ├─► Ngày quá khứ (daysBetween < 0)
      │       └─► Giới hạn ngày đặt trước theo Hạng (daysBetween > maxDaysAllowed)
      │
      ▼ (Nếu tất cả các ải validate đều hợp lệ)
[BookingDAO.createNewBooking(...)] (Mở connection, bắt đầu Transaction)
      │
      ├─► 1. Chèn bản ghi mới vào bảng 'Booking' (Lấy ra Generated booking_id).
      ├─► 2. Chèn bản ghi dịch vụ tương ứng vào bảng 'BookingService'.
      │
      ▼ (Nếu cả hai lệnh insert đều thành công)
Giao dịch được COMMIT ──► Lưu dữ liệu vĩnh viễn xuống SQL Server ──► Phản hồi success về JSP
```

---

## 3. Kiểm tra form booking.jsp

Bảng đối chiếu giữa các tham số (Parameters) gửi đi từ giao diện JSP và các tham số được Servlet nhận về:

| Parameter | JSP gửi | Servlet nhận | Kết quả | Ghi chú |
| :--- | :--- | :--- | :---: | :--- |
| **Mã xe** | `name="vehicleId"` | `request.getParameter("vehicleId")` | **PASS** | Khớp hoàn toàn. |
| **Mã dịch vụ** | `name="serviceId"` | `request.getParameter("serviceId")` | **PASS** | Khớp hoàn toàn. |
| **Ngày đặt lịch** | `name="bookingDate"` | `request.getParameter("bookingDate")` | **PASS** | Khớp hoàn toàn (chuỗi dạng `YYYY-MM-DD`). |
| **Giờ / Ca đặt** | `name="bookingTime"` | `request.getParameter("bookingTime")` | **PASS** | Khớp hoàn toàn (chuỗi dạng `"08:00"`, `"13:00"`, `"18:00"`). |

---

## 4. Kiểm tra CreateBookingServlet

Trong phương thức `doPost` của [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java):

* **Có gọi BookingDAO.createNewBooking không?**
  Có. Gọi ở dòng 159 sau khi đã vượt qua toàn bộ các bước kiểm tra (validate) nghiệp vụ ngày đặt lịch.
* **Truyền các tham số gì?**
  Phương thức nhận truyền vào 6 tham số: `customerId` (int), `vehicleId` (int), `serviceId` (int), `bookingDateStr` (String), `bookingTime` (String), và `price` (double).
* **Khi nào gọi?**
  Được gọi khi:
  1. Khách hàng đã đăng nhập (session chứa account không bị null).
  2. Hệ thống tải được thông tin hạng thành viên từ DB thành công.
  3. Ngày chọn đặt lịch không ở trong quá khứ (`daysBetween >= 0`).
  4. Số ngày đặt lịch trước không vượt quá quy định của hạng thành viên (`daysBetween <= maxDaysAllowed`).
* **Khi nào không gọi?**
  Sẽ dừng lại ngay (không gọi DAO) và forward về JSP kèm thông báo lỗi màu đỏ nếu vi phạm bất kỳ điều kiện validate nào nêu trên hoặc ném ra ngoại lệ `Exception`.

---

## 5. Kiểm tra BookingDAO

Trong phương thức `createNewBooking` của [BookingDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/BookingDAO.java):

* **Insert vào các bảng nào?**
  - Thực hiện `INSERT` vào bảng `Booking` trước.
  - Sau đó, lấy khóa chính tự tăng vừa sinh (`booking_id`) và tiếp tục `INSERT` vào bảng trung gian `BookingService`.
* **Có transaction không?**
  Có. Sử dụng `cn.setAutoCommit(false)` ở đầu và tắt tự động commit để bó 2 câu lệnh insert vào chung một giao dịch.
* **Có commit/rollback không?**
  - Thực hiện `cn.commit()` khi cả 2 câu lệnh insert đều thực thi thành công.
  - Thực hiện `cn.rollback()` trong khối `catch (Exception e)` nếu xảy ra bất kỳ lỗi truy vấn hay mất kết nối nào trong quá trình insert, đảm bảo không bị rác dữ liệu mồ côi.
* **Có trả về true/false không?**
  Có. Trả về biến `isSuccess` (nhận `true` nếu commit thành công, mặc định ban đầu là `false`).

---

## 6. Kiểm tra database schema

Tại tệp kịch bản [SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql):

* **Bảng Booking:**
  - Có tồn tại bảng `Booking`.
  - Có đầy đủ các cột: `booking_id` (PK, Identity tự tăng), `customer_id` (FK), `vehicle_id` (FK), `booking_date` (DATE), `booking_time` (TIME), `status` (NVARCHAR), `total_price` (DECIMAL).
* **Bảng BookingService:**
  - Có tồn tại bảng `BookingService`.
  - Có các cột: `booking_id` (PK, FK), `service_id` (PK, FK), `quantity` (INT), `price` (DECIMAL).
* **Độ tương thích kiểu dữ liệu:**
  - Cột `booking_date` kiểu `DATE` và `booking_time` kiểu `TIME` hoàn toàn tương thích với chuỗi Java dạng ngày giờ được Servlet truyền qua `setString()`. JDBC Driver của MS SQL Server sẽ tự động parse chuỗi này sang kiểu dữ liệu tương thích trong SQL.

---

## 7. Dữ liệu cần có để test

Để thực hiện kiểm thử thành công, tệp [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql) đã cung cấp đầy đủ dữ liệu mẫu:

* **Tài khoản test (Customer):**
  - Tài khoản Member: `ang@gmail.com` (Mật khẩu: `123456`)
  - Tài khoản Silver: `anv@gmail.com` (Mật khẩu: `123456`)
  - Tài khoản Gold: `btt@gmail.com` (Mật khẩu: `123456`)
  - Tài khoản Platinum: `cvl@gmail.com` (Mật khẩu: `123456`)
* **Xe của tài khoản test (Vehicle):**
  - Khách `ang@gmail.com` có xe biển số `61B1-123.45` (mã `vehicle_id` = 1).
  - Khách `anv@gmail.com` có xe biển số `29A1-234.56` (mã `vehicle_id` = 2).
* **Dịch vụ mẫu (Service):**
  - Dịch vụ Rửa xe cơ bản có sẵn trong DB với `service_id` = 1.
  - Gói dịch vụ Phủ Ceramic có sẵn trong DB với `service_id` = 2.

Các tài khoản test đều liên kết hợp lệ về mặt khóa ngoại khóa chính, hoàn toàn đủ điều kiện để thực hiện tạo booking trực tiếp trên giao diện mà không lo gặp lỗi vi phạm ràng buộc khóa ngoại (Foreign Key Violation).

---

## 8. Câu SQL user cần chạy để xác nhận

Sau khi chạy web, đăng nhập bằng tài khoản test và nhấn đặt lịch thành công, bạn hãy thực hiện chạy các câu lệnh SQL dưới đây trong SQL Server Management Studio để kiểm tra xem bản ghi đã được ghi xuống hay chưa:

### 8.1 Truy vấn kiểm tra nhanh 10 bản ghi mới nhất ở 2 bảng đơn lẻ
```sql
-- Kiểm tra bảng Booking
SELECT TOP 10 *
FROM Booking
ORDER BY booking_id DESC;

-- Kiểm tra bảng BookingService
SELECT TOP 10 *
FROM BookingService
ORDER BY booking_id DESC;
```

### 8.2 Truy vấn JOIN chi tiết thông tin booking
```sql
SELECT TOP 10
    b.booking_id,
    c.full_name AS [Khách Hàng],
    v.license_plate AS [Biển Số Xe],
    b.booking_date AS [Ngày Đặt],
    b.booking_time AS [Ca Đặt],
    b.status AS [Trạng Thái],
    b.total_price AS [Tổng Tiền],
    s.service_name AS [Tên Dịch Vụ],
    bs.quantity AS [Số Lượng],
    bs.price AS [Đơn Giá]
FROM Booking b
JOIN Customer c ON b.customer_id = c.customer_id
JOIN Vehicle v ON b.vehicle_id = v.vehicle_id
JOIN BookingService bs ON b.booking_id = bs.booking_id
JOIN Service s ON bs.service_id = s.service_id
ORDER BY b.booking_id DESC;
```

---

## 9. Rủi ro nếu có

Khi tiến hành chạy thực tế, hãy lưu ý một số rủi ro có thể gây lỗi hoặc không lưu được dữ liệu:
1. **Lỗi format ngày tháng:** Nếu phía Client/Trình duyệt không tuân thủ định dạng ngày `YYYY-MM-DD` (ví dụ trên các trình duyệt cũ không hỗ trợ `<input type="date">` và gửi chuỗi dạng `DD/MM/YYYY`), Servlet sẽ báo lỗi `DateTimeParseException` và nhảy vào catch block, không thực hiện lưu xuống DB.
2. **Cơ sở dữ liệu chưa được làm sạch:** Nếu cơ sở dữ liệu cũ chưa được DROP và tạo mới hoàn toàn từ file kịch bản cập nhật mới, bảng `MembershipTier` sẽ thiếu cột `booking_window_days`, dẫn đến phương thức `CustomerDAO.getCustomerProfile` bị crash khi thực hiện câu lệnh SQL SELECT JOIN.
3. **Kết nối DBUtils bị cấu hình sai:** Hãy chắc chắn chuỗi kết nối và tài khoản đăng nhập SA trong [DBUtils.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/mylib/DBUtils.java) trùng khớp với dịch vụ SQL Server trên máy chạy thực tế.

---

## 10. Bước tiếp theo đề xuất

Do luồng dữ liệu phân tích tĩnh hoàn toàn chính xác và an toàn:
* **Khuyến nghị:** Bạn nên thực hiện setup lại database bằng cách DROP database cũ, chạy [SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql) và [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql) mới. Sau đó, chạy project trên NetBeans/Eclipse để test luồng đặt lịch trực tiếp trên giao diện và sử dụng các câu lệnh query ở **Mục 8** để kiểm chứng.
