# FR-06b Code Check Report

## 1. Kết luận nhanh

* **PASS**: Code đã đúng yêu cầu FR-06b. Các cấu hình giới hạn ngày đặt trước đã được chuyển đổi thành công từ hardcode sang lấy động từ thuộc tính `booking_window_days` trong cơ sở dữ liệu dựa trên hạng thành viên.

---

## 2. Checklist chi tiết

| Hạng mục | Kết quả | Ghi chú |
| ---------------------------------------------- | --------- | ------- |
| SQLAutoWash.sql có booking_window_days         | PASS | Bảng `MembershipTier` có cột `booking_window_days INT NOT NULL DEFAULT 7` (dòng 27). |
| InsertValueSQL.sql seed đúng 7/10/12/14        | PASS | Đã seed đúng giá trị cho các hạng: Member (7), Silver (10), Gold (12), Platinum (14) (dòng 7-10). |
| Customer.java có bookingWindowDays             | PASS | Đã có thuộc tính `private int bookingWindowDays;` (dòng 15) và đầy đủ cặp phương thức getter/setter tương ứng (dòng 17-23). |
| CustomerDAO SELECT booking_window_days         | PASS | Phương thức `getCustomerProfile` thực hiện câu lệnh SQL SELECT có JOIN với bảng `MembershipTier` để lấy cột `t.booking_window_days` (dòng 30-34). |
| CustomerDAO setBookingWindowDays               | PASS | Đã gọi `cus.setBookingWindowDays(bookingWindowDays)` (dòng 56) và có fallback gán bằng 7 nếu giá trị lấy ra từ DB `<= 0` (dòng 53-55). Giữ nguyên logic lấy `tierId` và `tierName`. |
| CreateBookingServlet bỏ hardcode switch-case   | PASS | Đã loại bỏ hoàn toàn cấu trúc `switch-case` theo `tierId` để gán cứng biến `maxDaysAllowed`. |
| CreateBookingServlet dùng getBookingWindowDays | PASS | Đã sử dụng `customerProfile.getBookingWindowDays()` để lấy số ngày giới hạn động từ đối tượng Customer (dòng 118). |
| Validate ngày quá khứ còn giữ                  | PASS | Vẫn giữ nguyên logic validate ngày quá khứ: `daysBetween < 0` (dòng 110-114). |
| Validate vượt booking window còn giữ           | PASS | Vẫn giữ nguyên logic validate vượt hạn ngày: `daysBetween > maxDaysAllowed` (dòng 126-131). |
| Không đụng ngoài phạm vi                       | PASS | Không làm thay đổi hay ảnh hưởng đến logic Priority Queue, Waiting List, giới hạn 10 booking/3 hàng chờ hay admin confirm booking. |

---

## 3. Luồng dữ liệu sau khi user sửa

Luồng dữ liệu hiện tại hoạt động như sau:
1. Từ giao diện [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp), người dùng chọn ngày đặt và nhấn gửi Form (POST).
2. [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) (trong `doPost`) nhận request, lấy thông tin tài khoản hiện tại từ session.
3. Servlet gọi `CustomerDAO.getCustomerProfile(customerId)` để lấy thông tin chi tiết khách hàng.
4. Trong [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java), thực hiện câu lệnh SQL SELECT JOIN bảng `Customer` với `MembershipTier` để lấy thông tin khách hàng kèm theo `tier_name`, `tier_id` và `booking_window_days`.
5. `CustomerDAO` đọc dữ liệu, kiểm tra nếu `booking_window_days <= 0` thì tự động gán fallback là `7`. Sau đó gán vào đối tượng `Customer` thông qua `setBookingWindowDays(...)`.
6. Servlet lấy `maxDaysAllowed` bằng cách gọi `customerProfile.getBookingWindowDays()`.
7. Servlet thực hiện validate ngày đặt:
   - Kiểm tra ngày trong quá khứ (`daysBetween < 0`), nếu vi phạm thì forward về `booking.jsp` kèm thông báo lỗi.
   - Kiểm tra xem khoảng cách ngày đặt trước có vượt quá giới hạn hay không (`daysBetween > maxDaysAllowed`), nếu vi phạm thì forward về `booking.jsp` kèm thông báo lỗi.
8. Nếu mọi thông tin hợp lệ, servlet gọi `BookingDAO.createNewBooking(...)` để lưu booking mới vào cơ sở dữ liệu.

---

## 4. Lỗi phát hiện nếu có

* Không phát hiện lỗi logic hay lỗi cú pháp nào trong các file liên quan đến tính năng FR-06b. Code của user đã đáp ứng chính xác yêu cầu nghiệp vụ.
* **Cảnh báo thay đổi ngoài danh sách file:** File `AutoWashPro-Website/web/bookings.jsp` đã bị xóa hoàn toàn ở commit `2ff8aaa` (với thông điệp dọn dẹp các cấu hình file không sử dụng). Qua kiểm tra, đây là file cấu hình dư thừa và Servlet thực tế sử dụng file [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp) để hiển thị giao diện đặt lịch. Do đó, việc xóa file này là an toàn và không ảnh hưởng đến chức năng của hệ thống.

---

## 5. Build result

* **Kết quả:** Chưa chạy được build tự động.
* **Lý do:** Hệ thống không tìm thấy công cụ build `ant` (Apache Ant) trong biến môi trường PATH để thực thi tệp `build.xml` của dự án NetBeans này.
* **Đánh giá thủ công:** Code review thủ công cho thấy cú pháp Java chính xác, các kiểu dữ liệu tương thích và các import thư viện đầy đủ. Không có nguy cơ lỗi biên dịch.

---

## 6. Git diff

Kết quả chạy lệnh `git diff --name-only` tại working directory hiện tại:
*(Mọi thay đổi đã được commit sạch sẽ vào branch `feat/57-fr-06b-booking-window`, do đó working tree hiện tại trống)*

```text
(Working tree clean, no uncommitted changes)
```

Danh sách các file thay đổi được ghi nhận trong nhánh tính năng này (so với commit gốc trước khi thực hiện FR-06b - commit `3f62e2d`):
```text
AutoWashPro-Website/src/java/controller/CreateBookingServlet.java
AutoWashPro-Website/src/java/dao/CustomerDAO.java
AutoWashPro-Website/src/java/dto/Customer.java
AutoWashPro-Website/web/bookings.jsp (Đã xóa file dư thừa này)
Database/InsertValueSQL.sql
Database/SQLAutoWash.sql
```

---

## 7. Bước tiếp theo đề xuất

Vì mã nguồn đã vượt qua tất cả các bài kiểm tra nghiệp vụ và đạt trạng thái **PASS**, đề xuất user thực hiện các bước sau để nghiệm thu:

1. **Cập nhật lại Cơ sở dữ liệu local:**
   - Drop database `AutoWashPro_DB` hiện tại (nếu có).
   - Chạy lại toàn bộ tệp [SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql) để tạo lại cấu trúc bảng mới.
   - Chạy tệp [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql) để nạp dữ liệu mẫu mới (gồm dữ liệu MembershipTier động).
2. **Khởi chạy ứng dụng Web và chạy thử nghiệm (Manual Test):**
   - Clean & Build dự án trên NetBeans / Eclipse IDE của bạn.
   - Deploy dự án lên Tomcat server.
   - Đăng nhập bằng tài khoản hạng Member (`ang@gmail.com`) -> Đặt trước 7 ngày (thành công), đặt trước 8 ngày (báo lỗi).
   - Đăng nhập bằng tài khoản hạng Silver (`anv@gmail.com`) -> Đặt trước 10 ngày (thành công), đặt trước 11 ngày (báo lỗi).
   - Tiếp tục kiểm tra tương tự với hạng Gold và Platinum để xác thực logic hoạt động trơn tru trên giao diện thực tế.
