# FR-06b SQL Only Update Report

## 1. Mục tiêu

Báo cáo này giải thích các thay đổi đối với kịch bản cơ sở dữ liệu (SQL Scripts) để hỗ trợ chức năng **FR-06b Booking Window: Ràng buộc thời gian đặt lịch theo hạng thành viên**. 

Trong bước này, chúng ta **CHỈ** thực hiện cập nhật cấu trúc bảng dữ liệu (schema) và dữ liệu mẫu (seed data) trong các file SQL của dự án. Chúng ta **KHÔNG** can thiệp hay sửa đổi bất kỳ mã nguồn Java, trang JSP, Servlet, DAO hay DTO nào. Các chỉnh sửa logic mã nguồn Java sẽ được thực hiện ở các bước tiếp theo.

---

## 2. File đã sửa

Các file script SQL sau đây đã được sửa đổi thành công:
* [SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql): Script định nghĩa cấu trúc cơ sở dữ liệu.
* [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql): Script chèn dữ liệu mẫu vào cơ sở dữ liệu.

---

## 3. Thay đổi trong SQLAutoWash.sql

Tại tệp [SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql), cấu trúc của bảng `MembershipTier` (Hạng thành viên) đã được bổ sung thêm một cột mới để cấu hình số ngày đặt lịch trước tối đa:

* **Cột thêm mới:** `booking_window_days`
* **Kiểu dữ liệu:** `INT`
* **Ràng buộc:** `NOT NULL DEFAULT 7` (Nếu không chỉ định, mặc định khách hàng được đặt trước tối đa 7 ngày).

**Mã nguồn sau khi sửa đổi:**
```sql
CREATE TABLE MembershipTier (
    tier_id INT PRIMARY KEY IDENTITY(1,1),
    tier_name VARCHAR(50) NOT NULL,
    min_points INT DEFAULT 0,
    discount_percent DECIMAL(5,2),
    benefits NVARCHAR(MAX),
    booking_window_days INT NOT NULL DEFAULT 7
);
```

---

## 4. Thay đổi trong InsertValueSQL.sql

Tại tệp [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql), lệnh chèn dữ liệu mẫu cho bảng `MembershipTier` đã được cập nhật để seed chính xác giá trị số ngày đặt trước tối đa cho từng hạng thành viên:

* Hạng **Member**: `7` ngày.
* Hạng **Silver**: `10` ngày.
* Hạng **Gold**: `12` ngày.
* Hạng **Platinum**: `14` ngày.

**Mã nguồn sau khi sửa đổi:**
```sql
INSERT INTO MembershipTier (tier_name, min_points, discount_percent, benefits, booking_window_days) VALUES
('Member', 0, 0.00, '1 point = 1,000 VND spent', 7),
('Silver', 2000, 0.00, '+10% points, priority slot', 10),
('Gold', 6000, 0.00, '+20% points, free upgrade monthly', 12),
('Platinum', 15000, 0.00, '+30% points, free wash monthly', 14);
```

---

## 5. File không được sửa

Chúng tôi xác nhận và cam kết **KHÔNG** thay đổi bất kỳ file Java/JSP/Servlet/DAO/DTO nào trong dự án trong bước này, bao gồm:
* `Customer.java` (DTO)
* `User.java` (DTO)
* `CustomerDAO.java` (DAO)
* `BookingDAO.java` (DAO)
* `CreateBookingServlet.java` (Servlet)
* `booking.jsp` (JSP)
* Các tệp tin Java/JSP khác trong toàn bộ dự án.

---

## 6. Hướng dẫn setup database

Để áp dụng các thay đổi này vào hệ thống cơ sở dữ liệu hiện hành, người dùng/lập trình viên thực hiện các bước sau:

1. **Xóa cơ sở dữ liệu cũ (DROP DATABASE):**
   - Chạy lệnh hoặc thực thi kịch bản SQL để xóa database `AutoWashPro_DB`.
   *(Lưu ý: Trong file [SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql) dòng 7-12 đã tích hợp sẵn lệnh kiểm tra và tự động DROP database cũ trước khi tạo mới).*
2. **Khởi tạo cấu trúc database mới:**
   - Mở và thực thi toàn bộ nội dung file [SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql).
3. **Nạp dữ liệu mẫu:**
   - Mở và thực thi toàn bộ nội dung file [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql).

---

## 7. Bước tiếp theo

Ở các bước phát triển tiếp theo, các thay đổi đối với phần mã nguồn Java sẽ được triển khai, bao gồm:
1. Thêm thuộc tính `bookingWindowDays` kèm getter/setter vào lớp [Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java).
2. Sửa đổi câu SELECT JOIN trong phương thức `getCustomerProfile(int customerId)` của [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java) để lấy thêm giá trị cột `booking_window_days` và gán vào đối tượng `Customer`.
3. Sửa đổi Servlet [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) để đọc động giới hạn ngày đặt trước của khách hàng (`customerProfile.getBookingWindowDays()`) và so sánh thay thế cho cấu trúc `switch-case` hardcode hiện tại.
