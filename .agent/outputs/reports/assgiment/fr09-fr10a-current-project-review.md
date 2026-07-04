# FR-09 + FR-10a Current Project Review (Updated via GitHub Issues)

## 1. Kết luận nhanh

* **Workshop 2 đã hoàn thành mức nào?**
  * **Đã hoàn thành tốt và chạy ổn định**: Khách hàng (Customer) đã có thể đăng nhập, tạo booking thành công với xe và dịch vụ lựa chọn, dữ liệu lưu xuống Database liên kết chính xác với ID của khách hàng (`customer_id`).
  * **Hạng thành viên ảnh hưởng đặt lịch (Tier-based booking window)**: Đã hoạt động tốt. Hệ thống kiểm tra số ngày đặt trước tối đa dựa trên hạng thành viên của khách hàng được lấy từ DB (Member: 7 ngày, Silver: 10 ngày, Gold: 12 ngày, Platinum: 14 ngày).
  * **Hệ thống hàng đợi ưu tiên (Priority queue)**: Đã hoàn thiện ở tầng database và DAO (`HiddenPriorityBookingDAO.java`). Khi tạo booking, hệ thống tự động tính toán điểm ưu tiên dựa trên hạng để gán trạng thái (`CONFIRMED` - trong 10 slot chính, `BACKUP_CONFIRMED` - trong 3 slot dự phòng, hoặc `WAITING` - danh sách chờ).
  * **Lịch sử đặt lịch**: Đã có đầy đủ giao diện hiển thị cho khách hàng gồm lịch sử đặt lịch chung (`booking-history.jsp`) và lịch sử rửa xe đã hoàn thành (`washing-history.jsp`).
  * **Cơ chế hoàn thành booking**: Chưa có trang Admin/Staff chuyên biệt, nhưng hiện tại trong `booking-history.jsp` của Customer đã có nút **Check-in** (khi trạng thái là `pending`). Khi khách hàng nhấn nút này, hệ thống sẽ gọi Servlet cập nhật trạng thái booking sang `Completed`.
* **Có đủ nền để bắt đầu FR-09 + FR-10a chưa?**
  * **Hoàn toàn đầy đủ**: Cả cấu trúc DB, dữ liệu seed mẫu, cấu trúc DTO/DAO cho Booking và Customer đều đã sẵn sàng và thống nhất.
* **Có nên code ngay không, hay cần chuẩn bị DB trước?**
  * **Nên chuẩn bị DB trước**: Cần tạo một Unique Index trên bảng `LoyaltyTransaction` để chống lỗi cộng điểm trùng lặp cho cùng một booking trước khi tiến hành code logic.

---

## 2. Bảng so sánh Tài liệu SRS cũ vs GitHub Issues mới (FR-09 & FR-10a & FR-10b)

Dữ liệu đặc tả trong tài liệu cũ (SRS) đã được cập nhật bằng các GitHub Issues mới nhất (#41, #42, #58). Dưới đây là các thay đổi quan trọng nhất cần lưu ý trước khi code:

| Tiêu chí | Tài liệu SRS cũ (Đã lỗi thời) | GitHub Issues mới (#41, #42, #58) (Cập nhật) | Ảnh hưởng kỹ thuật (Backend & Database) |
| :--- | :--- | :--- | :--- |
| **Phạm vi tính toán xét hạng (Tier)** | Tính lũy lũy kế trọn đời (Cumulative lifetime) dựa trên trường `total_spent_money` và `total_points` trong bảng `Customer`. | Chỉ tính toán dựa trên dữ liệu còn hiệu lực **trong vòng 12 tháng gần nhất** (Rolling 12-month window). | Không được dùng trực tiếp cột `Customer.total_spent_money`. Phải viết câu lệnh truy vấn sum/count các booking hoàn thành có `booking_date >= DATEADD(month, -12, GETDATE())`. |
| **Cơ chế kích hoạt xét lại hạng (FR-10b)** | Tự động chạy nền đánh giá hàng tháng (Monthly review / Cron job). | **Không sử dụng scheduler hàng tháng** trong phạm vi bài tập này. Kích hoạt theo sự kiện (Event-driven):<br>1. Ngay sau khi booking hoàn thành & cộng điểm (FR-09).<br>2. Khi điểm/lượt rửa cũ hết hạn quá 12 tháng (FR-12).<br>3. Khi Admin thay đổi luật hạng (FR-13a).<br>4. Khi khách hàng/Admin mở xem thông tin loyalty (On-demand refresh). | Loại bỏ hoàn toàn Thread ngầm hay Scheduler. Viết logic xét hạng thành một Service và gọi nó tại các trigger point cụ thể ở Servlet/DAO. |
| **Quy tắc hạ hạng (Downgrade)** | Không mô tả rõ quy tắc hạ hạng. | Khi dữ liệu cũ hết hiệu lực (>12 tháng), hệ thống tính toán lại từ đầu và **hạ thẳng xuống hạng phù hợp nhất**, không hạ từng bậc (ví dụ: hạ thẳng từ Platinum xuống Silver nếu chỉ còn 5 washes). | Hàm xét hạng cần được viết tổng quát (kiểm tra từ Platinum xuống Silver). Mỗi lần chạy sẽ gán lại `tier_id` chính xác dựa trên dữ liệu 12 tháng hiện tại. |
| **Cơ chế tích lũy điểm (FR-09)** | Chỉ nói chung chung là cộng điểm sau khi payment hoàn thành. | Nói rõ luồng nghiệp vụ: Tính điểm dựa trên số tiền của lần rửa xe đó + áp dụng hệ số điểm theo hạng **hiện tại** của khách hàng, ghi lịch sử, cập nhật dữ liệu, sau đó kích hoạt xét hạng. | Logic tính điểm: `points = (booking_price / 1000) * (1 + bonus_percent)`. Phải lấy hạng thành viên *trước khi* hoàn thành booking để tính toán. |

---

## 3. Hiện trạng booking

Các file liên quan đến chức năng Booking hiện tại trong dự án:

| File liên quan | Loại | Mô tả & Trạng thái |
| :--- | :--- | :--- |
| [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) | Controller (Servlet) | Xử lý nhận yêu cầu đặt lịch từ Form POST của khách hàng. Thực hiện check hạn mức ngày đặt trước theo hạng. **Đang được dùng chính cho nút submit trong booking.jsp.** |
| [BookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/BookingServlet.java) | Controller (Servlet) | Xử lý GET để hiển thị trang đặt lịch. Có chứa code xử lý POST hỗ trợ chọn nhiều dịch vụ cùng lúc nhưng hiện tại đang bị bỏ trống (không dùng do form submit trực tiếp sang `CreateBookingServlet`). |
| [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp) | View (JSP) | Form đăng ký lịch rửa xe. Hiện tại đang hardcode danh sách dịch vụ (chỉ hiển thị gói Cơ bản 100k và Ceramic 1.5M). |
| [BookingDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/BookingDAO.java) | DAO | Chứa hàm `createNewBooking` (tạo booking đơn giản) và `createPriorityBooking` (tạo booking ưu tiên có kiểm tra slot trống và trùng ca). |
| [HiddenPriorityBookingDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/HiddenPriorityBookingDAO.java) | DAO | Xử lý xếp vị trí hàng đợi ưu tiên ẩn (`applyPriority`) dựa trên hạng thành viên, tự động gán trạng thái booking. |
| [UserBookingHistoryServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/UserBookingHistoryServlet.java) | Controller (Servlet) | Điều hướng xem lịch sử đặt lịch / lịch sử rửa xe. Đồng thời xử lý `subAction=cancel` và `subAction=checkin`. |
| [UserBookingHistoryDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/UserBookingHistoryDAO.java) | DAO | Lấy danh sách booking/washing history từ DB và hàm `updateBookingStatus` dùng để cập nhật trạng thái. |
| [booking-history.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking-history.jsp) | View (JSP) | Hiển thị lịch sử đặt lịch. Có chứa nút **Check-in** gọi `subAction=checkin` để cập nhật trạng thái thành `Completed`. |
| [washing-history.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/washing-history.jsp) | View (JSP) | Hiển thị các dịch vụ đã hoàn thành (`Completed`). |

---

## 4. Hiện trạng database

Bản phân tích Schema hiện có tại `SQLAutoWash.sql` và `InsertValueSQL.sql`:

* **Bảng Customer**:
  * Lưu trữ thông tin khách hàng.
  * Đã có sẵn cột: `total_spent_money` (DECIMAL(18,2)), `total_points` (INT), và khóa ngoại `tier_id` (INT) liên kết với bảng `MembershipTier`.
* **Bảng Booking**:
  * Đã có sẵn cột: `status` (NVARCHAR(50)) và `total_price` (DECIMAL(18,2)).
* **Bảng MembershipTier (Bảng hạng thành viên)**:
  * Đã có sẵn cột: `tier_id`, `tier_name` (Member, Silver, Gold, Platinum), `booking_window_days` (7, 10, 12, 14), `priority_score`.
* **Bảng LoyaltyTransaction (Bảng lịch sử điểm)**:
  * Đã được định nghĩa sẵn cột: `transaction_id`, `customer_id`, `booking_id`, `points`, `transaction_type` (Earned, Spent), `created_at`.
  * **Thiếu sót**: Cột `booking_id` chưa có ràng buộc duy nhất (Unique) để chặn việc một booking được cộng điểm nhiều lần.

---

## 5. Hiện trạng loyalty/rank/points

* **Những phần đã có**:
  * Cấu trúc bảng và trường dữ liệu tích lũy điểm (`total_points`), tổng chi tiêu (`total_spent_money`), và hạng thành viên (`tier_id`) trong bảng `Customer`.
  * Bảng lưu trữ lịch sử điểm `LoyaltyTransaction` đã có sẵn.
  * Phân hạng thành viên (Member, Silver, Gold, Platinum) đã được seed sẵn trong DB.
  * Trang `rewards.jsp` đã hiển thị được điểm hiện tại của khách hàng cùng thanh tiến trình (progress bar) trực quan hướng tới phần thưởng kế tiếp hoặc hạng kế tiếp.
* **Những phần chưa có (Cần tự code)**:
  * Cơ chế tự động tính và cộng điểm khi booking hoàn thành (FR-09).
  * Cơ chế tự động đánh giá và nâng/hạ hạng thành viên ngay sau khi cộng điểm (FR-10a) dựa trên **dữ liệu 12 tháng gần nhất**.
  * Logic tự động kích hoạt xét hạng (FR-10b) khi loyalty thay đổi (khi check-in hoặc khi vào trang profile xem thông tin).
  * Đồng bộ hóa session sau khi điểm hoặc hạng thay đổi trên giao diện.

---

## 6. Điểm gắn FR-09 (Tích điểm tự động)

Logic tích lũy điểm thưởng tự động nên được kích hoạt ngay khi trạng thái của booking được cập nhật thành `Completed`.

* **Nơi kích hoạt phù hợp nhất ở Servlet**: 
  Trong [UserBookingHistoryServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/UserBookingHistoryServlet.java) ở nhánh xử lý `subAction=checkin`:
  ```java
  } else if ("checkin".equals(subAction)) {
      String idStr = request.getParameter("bookingId");
      if (idStr != null) {
          int bookingId = Integer.parseInt(idStr);
          boolean isCompleted = historyDAO.updateBookingStatus(bookingId, "Completed");
          if (isCompleted) {
              // TODO: Gọi class/method tính & cộng điểm thưởng tại đây!
              // Ví dụ: LoyaltyService.accumulatePoints(bookingId);
          }
      }
  ```
* **Nơi xử lý logic nghiệp vụ và DB**:
  Nên viết một class nghiệp vụ mới (ví dụ: `dao/LoyaltyDAO.java` hoặc `service/LoyaltyService.java`):
  1. Đọc thông tin booking (lấy ra `customer_id`, `total_price` và trạng thái).
  2. Kiểm tra xem booking này đã được cộng điểm trong bảng `LoyaltyTransaction` chưa (phòng tránh cộng trùng).
  3. Lấy hạng thành viên hiện tại của Customer từ bảng `Customer` JOIN `MembershipTier` để xác định tỷ lệ % bonus tương ứng (Silver: +10%, Gold: +20%, Platinum: +30%).
  4. Tính toán số điểm nhận được: `points = (total_price / 1000) * (1 + bonus_rate)`.
  5. Chạy một Transaction đồng thời thực hiện:
     * Ghi 1 dòng lịch sử vào bảng `LoyaltyTransaction` dạng `'Earned'`.
     * Cập nhật cộng dồn số điểm vào cột `total_points` của khách hàng trong bảng `Customer`.
     * Cập nhật cộng dồn số tiền vào cột `total_spent_money` của khách hàng trong bảng `Customer` (để lưu tổng trọn đời).
     * **Kích hoạt xét hạng**: Sau khi cập nhật DB thành công, gọi ngay logic xét hạng FR-10a.

---

## 7. Điểm gắn FR-10a (Xét hạng tự động 12 tháng rolling) & FR-10b (Triggers)

Logic xét hạng thành viên tự động phải dựa trên dữ liệu của **12 tháng gần nhất**.

* **Nơi kích hoạt**: 
  1. Gọi trực tiếp ở cuối luồng tích điểm thành công của FR-09 (khi booking chuyển Completed).
  2. Gọi khi khách hàng truy cập trang Rewards/Profile để hiển thị thông tin loyalty (luồng 4 trong issue #58 - On-demand refresh).
* **Nơi xử lý logic (Ví dụ trong `service/LoyaltyService.java`)**:
  1. **Tính tổng lượt rửa 12 tháng gần nhất**:
     ```sql
     SELECT COUNT(*) FROM Booking 
     WHERE customer_id = ? 
       AND status = 'Completed' 
       AND booking_date >= DATEADD(month, -12, GETDATE())
     ```
  2. **Tính tổng chi tiêu 12 tháng gần nhất**:
     ```sql
     SELECT SUM(total_price) FROM Booking 
     WHERE customer_id = ? 
       AND status = 'Completed' 
       AND booking_date >= DATEADD(month, -12, GETDATE())
     ```
  3. **So sánh điều kiện phân hạng (từ cao xuống thấp - Logic OR)**:
     * **Platinum**: washes_12m >= 30 OR spent_12m >= 15.000.000 VND
     * **Gold**: washes_12m >= 15 OR spent_12m >= 6.000.000 VND
     * **Silver**: washes_12m >= 5 OR spent_12m >= 2.000.000 VND
     * **Member**: Mặc định nếu không thỏa mãn các điều kiện trên.
  4. **Cập nhật database**: Nếu hạng mới khác hạng hiện tại, cập nhật cột `tier_id` của khách hàng trong bảng `Customer`.

---

## 8. Việc tôi nên code đầu tiên

Thứ tự thực hiện chuẩn chỉ để tự code FR-09 + FR-10a + FR-10b:

### Bước 1: Gia cố Database (Chống cộng điểm trùng)
Chạy script SQL tạo Unique Index có điều kiện trên bảng `LoyaltyTransaction`. Ràng buộc này đảm bảo một `booking_id` chỉ được nhận điểm `'Earned'` một lần duy nhất:
```sql
CREATE UNIQUE INDEX UX_LoyaltyTransaction_Booking_Earned
ON LoyaltyTransaction(booking_id)
WHERE booking_id IS NOT NULL AND transaction_type = 'Earned';
```

### Bước 2: Tạo DTO và DAO cho LoyaltyTransaction
* Tạo file `dto/LoyaltyTransactionDTO.java` để đại diện cho bản ghi giao dịch điểm.
* Tạo file `dao/LoyaltyDAO.java` chứa các phương thức:
  * `checkPointsEarned(int bookingId)`: kiểm tra xem booking đã được tích điểm chưa.
  * `insertTransaction(int customerId, Integer bookingId, int points, String type)`: ghi lịch sử điểm.
  * `updateCustomerPointsAndSpent(int customerId, int points, double spentMoney)`: cập nhật điểm tích lũy và tổng chi tiêu của Customer trong bảng `Customer`.

### Bước 3: Viết logic tích điểm tự động (FR-09) & Xét hạng 12 tháng (FR-10a)
* Tạo class nghiệp vụ `service/LoyaltyService.java` chứa:
  * `accumulatePoints(int bookingId)`: tính toán điểm cơ bản + bonus hạng hiện tại, insert giao dịch, cập nhật tổng điểm/chi tiêu trọn đời của Customer.
  * `assessAndUpdateTier(int customerId)`: thực hiện truy vấn washes và spent trong 12 tháng gần nhất, so sánh điều kiện phân hạng (OR) và cập nhật cột `tier_id` trong DB.
  * Phương thức `accumulatePoints` sẽ gọi `assessAndUpdateTier` ở cuối trước khi commit transaction.

### Bước 4: Đấu nối vào Controller
* Mở [UserBookingHistoryServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/UserBookingHistoryServlet.java), tại block xử lý `subAction=checkin`, sau khi update status thành `'Completed'` thành công, gọi `LoyaltyService.accumulatePoints(bookingId)`.
* Thực hiện cập nhật lại dữ liệu User trong Session sau khi tính điểm/xét hạng thành công:
  ```java
  Customer updatedProfile = customerDAO.getCustomerProfile(customerId);
  user.setTotalPoints(updatedProfile.getTotalPoints());
  session.setAttribute(AppKeys.SESSION_USER_POINTS, updatedProfile.getTotalPoints());
  ```

### Bước 5: Tích hợp làm mới hạng khi truy cập trang cá nhân (FR-10b)
* Trong [RewardServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/RewardServlet.java) (hoặc bất kỳ servlet nào hiển thị profile), gọi `LoyaltyService.assessAndUpdateTier(customerId)` trước khi lấy thông tin profile để đảm bảo khách hàng luôn nhìn thấy thông tin hạng chính xác theo thời gian thực (đã trừ đi các lượt rửa/chi tiêu quá hạn 12 tháng).

---

## 9. Những việc chưa nên làm

* **Thiết kế UI Admin**: Bỏ qua UI chỉnh sửa quy tắc hạng. Sử dụng cấu hình cứng trong code hoặc truy vấn tĩnh từ DB.
* **Logic Point Expiry (FR-12)**: Chưa cần viết scheduler quét điểm hết hạn định kỳ. Tạm thời chỉ xử lý xét hạng theo rolling 12 tháng ở FR-10a/10b.
* **Logic đổi điểm lấy quà (Redemption - FR-11)**: Không đụng vào logic đổi quà để tránh làm phình scope của Engine tích điểm & xét hạng.

---

## 10. Rủi ro và lưu ý

* **Rủi ro tính sai hạng do dùng sai trường (Rất cao)**:
  * Tránh dùng trường `Customer.total_spent_money` hay `Customer.total_points` để tính hạng vì các trường này lưu dữ liệu trọn đời (lifetime). Quy tắc mới yêu cầu xét theo **12 tháng gần nhất**. Bắt buộc phải tính tổng số tiền và số lượt rửa thông qua bảng `Booking` có điều kiện thời gian (`booking_date >= DATEADD(month, -12, GETDATE())`).
* **Rủi ro bất đồng nhất hạng thành viên giữa các trang**:
  * Trang `RewardServlet.java` đang tính hạng động bằng code Java dựa trên tổng chi tiêu trọn đời, trong khi hệ thống đặt lịch (`CreateBookingServlet.java`) lại đọc trực tiếp cột `tier_id` trong database.
  * **Giải pháp**: Phải sửa logic của `RewardServlet.java` để đọc hạng trực tiếp từ `Customer.tier_id` (được cập nhật bởi FR-10a/10b) thay vì tự tính toán động, đảm bảo toàn bộ hệ thống thống nhất một nguồn dữ liệu hạng duy nhất.
* **Transaction & Concurrency**:
  * Việc tích điểm và nâng hạng động chạm đến nhiều bảng và thay đổi trạng thái nhạy cảm. Hãy chắc chắn sử dụng Database Transaction (`conn.setAutoCommit(false)`, `commit()`, `rollback()`) để tránh lỗi chỉ cập nhật điểm mà không lưu lịch sử hoặc ngược lại.
