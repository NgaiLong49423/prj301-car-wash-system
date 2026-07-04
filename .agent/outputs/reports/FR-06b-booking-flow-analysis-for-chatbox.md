# FR-06b Booking Flow Analysis For External Chatbox

## 1. Mục tiêu báo cáo

Báo cáo này được lập ra nhằm mục đích phân tích chi tiết luồng xử lý đặt lịch (booking) hiện tại của dự án AutoWashPro. Tài liệu này cung cấp cái nhìn toàn diện và rõ ràng cho một chatbot bên ngoài (chatbot này không có quyền truy cập trực tiếp vào mã nguồn, cấu trúc thư mục hoặc cơ sở dữ liệu hiện tại của hệ thống) để chuẩn bị cho việc hiện thực hóa tính năng **FR-06b Booking Window: Ràng buộc thời gian đặt lịch theo hạng thành viên**.

Thông qua báo cáo này, chatbot có thể nắm bắt chính xác các tệp tin, lớp đối tượng (classes), phương thức (methods), bảng dữ liệu (tables) và các cột dữ liệu (columns) liên quan để hướng dẫn lập trình viên sửa đổi mã nguồn một cách chuẩn xác mà không cần tự suy đoán cấu trúc dự án.

---

## 2. Tóm tắt nghiệp vụ FR-06b

Nghiệp vụ yêu cầu kiểm soát số ngày đặt lịch trước của khách hàng dựa trên hạng thành viên của họ:
* **Khống chế thời gian đặt trước:** Khách hàng chỉ được phép chọn ngày đặt lịch rửa xe (`booking_date`) nằm trong khoảng từ ngày hiện tại cho đến một số ngày tối đa quy định.
* **Số ngày đặt trước phụ thuộc vào Hạng thành viên:**
  - Hạng **Member**: Được đặt trước tối đa **7 ngày** (hôm nay + 7 ngày).
  - Hạng **Silver**: Được đặt trước tối đa **10 ngày** (hôm nay + 10 ngày).
  - Hạng **Gold**: Được đặt trước tối đa **12 ngày** (hôm nay + 12 ngày).
  - Hạng **Platinum**: Được đặt trước tối đa **14 ngày** (hôm nay + 14 ngày).
* **Ràng buộc lưu trữ động:** Số ngày đặt trước tối đa này **PHẢI** được lưu trữ và truy vấn từ cơ sở dữ liệu (trong bảng cấu hình hạng thành viên), không được hardcode (viết cứng) trong code xử lý Java (Servlet/Controller).

---

## 3. Cấu trúc repo liên quan đến booking

Dưới đây là các thư mục và tệp tin trong dự án tham gia vào luồng xử lý booking hoặc quản lý thông tin khách hàng và hạng thành viên:

* **Trang hiển thị giao diện đặt lịch (JSP):**
  - [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp): File giao diện hiển thị biểu mẫu (form) đặt lịch bao gồm chọn phương tiện (Vehicle), chọn gói dịch vụ (Service), chọn ngày đặt lịch (`bookingDate`), và ca đặt lịch (`bookingTime`).
* **Servlet/Controller xử lý yêu cầu đặt lịch:**
  - [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java): Đón nhận yêu cầu GET (để hiển thị form và tải danh sách xe của khách hàng) và POST (để thu thập dữ liệu đặt lịch, thực hiện kiểm tra nghiệp vụ validate ngày, hạng thành viên, và gọi DAO để lưu thông tin đặt lịch).
* **Lớp truy cập dữ liệu (DAO):**
  - [BookingDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/BookingDAO.java): Chứa phương thức `createNewBooking` thực thi các câu lệnh SQL để thêm mới một bản ghi booking vào bảng `Booking` và các dịch vụ tương ứng vào bảng trung gian `BookingService` dưới dạng một Transaction.
  - [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java): Chứa phương thức `getCustomerProfile` thực hiện câu lệnh SQL JOIN giữa bảng khách hàng `Customer` và bảng hạng thành viên `MembershipTier` để tải thông tin hồ sơ của khách hàng bao gồm mã hạng (`tier_id`) và tên hạng (`tier_name`).
* **Lớp đối tượng dữ liệu (DTO/Model):**
  - [Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java): Lớp chứa thông tin chi tiết của khách hàng bao gồm `customerId`, `fullName`, `phone`, `email`, `password`, `joinDate`, `totalPoints`, và thông tin hạng thành viên `tierId`, `tierName`.
  - [User.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/User.java): Lớp đối tượng lưu trữ thông tin tài khoản cơ bản sau khi đăng nhập thành công. Đây là đối tượng được lưu trong Session.
* **Cơ sở dữ liệu / Scripts SQL:**
  - [SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql): Script khởi tạo cấu trúc cơ sở dữ liệu (Schema) bao gồm các bảng `MembershipTier`, `Customer`, `Booking`, `BookingService`, v.v.
  - [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql): Script chèn dữ liệu mẫu cho hệ thống bao gồm các hạng thành viên mẫu (`Member`, `Silver`, `Gold`, `Platinum`) và các tài khoản khách hàng để kiểm thử.
* **Thư viện tiện ích và Cấu hình kết nối:**
  - [DBUtils.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/mylib/DBUtils.java): Chứa phương thức `getConnection()` để tạo kết nối tới cơ sở dữ liệu Microsoft SQL Server (`AutoWashPro_DB`) bằng Driver `com.microsoft.sqlserver.jdbc.SQLServerDriver`.
  - [AppKeys.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/mylib/AppKeys.java): Chứa các hằng số tĩnh đại diện cho các Key lưu trữ trong `HttpSession` và `HttpServletRequest` nhằm tránh lỗi gõ sai chính tả (Typo) giữa Servlet và JSP.

---

## 4. Luồng tạo booking hiện tại từ giao diện đến database

Quá trình người dùng đặt lịch diễn ra tuần tự qua các bước sau:

1. **Truy cập trang đặt lịch:** Người dùng nhấp vào mục "Book Wash" trên thanh điều hướng. Trình duyệt gửi yêu cầu `GET` tới URL `/CreateBookingServlet`.
2. **Hiển thị Form đặt lịch:**
   - [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) trong hàm `doGet` nhận yêu cầu. Nó lấy session hiện tại và lấy đối tượng `User` của khách hàng đang đăng nhập từ `session.getAttribute(AppKeys.SESSION_ACCOUNT)`.
   - Servlet gọi `VehicleDAO.getCars(customerId)` để lấy danh sách các xe mà khách hàng đang sở hữu, đặt vào request attribute `"listVehicles"`, sau đó chuyển tiếp (forward) yêu cầu sang trang giao diện [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp).
3. **Gửi dữ liệu đặt lịch:**
   - Người dùng điền đầy đủ thông tin trên form tại [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp).
   - Biểu mẫu (form) thực hiện gửi yêu cầu bằng phương thức **POST** tới action `"CreateBookingServlet"`.
4. **Các tham số (Parameters) biểu mẫu gửi lên:**
   - `vehicleId`: Mã ID của phương tiện được chọn (được gửi dưới dạng chuỗi số nguyên).
   - `serviceId`: Mã ID của gói dịch vụ được chọn (ví dụ: `1` cho Rửa xe cơ bản, `2` cho Phủ Ceramic).
   - `bookingDate`: Chuỗi ngày đặt lịch có định dạng `YYYY-MM-DD` (do thẻ `<input type="date">` sinh ra).
   - `bookingTime`: Chuỗi giờ đặt lịch tương ứng với ca được chọn (ví dụ: `"08:00"`, `"13:00"`, `"18:00"`).
5. **Xử lý yêu cầu tại Servlet:**
   - Phương thức `doPost` của [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) tiếp nhận yêu cầu.
   - Servlet lấy dữ liệu từ request bằng các dòng lệnh:
     ```java
     String vehicleIdStr = request.getParameter("vehicleId");
     String serviceIdStr = request.getParameter("serviceId");
     String bookingDateStr = request.getParameter("bookingDate");
     String bookingTime = request.getParameter("bookingTime");
     ```
   - Servlet kiểm tra trạng thái đăng nhập bằng cách lấy thông tin tài khoản từ session:
     ```java
     HttpSession session = request.getSession(false);
     User account = (session != null) ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
     ```
     Nếu `account` bằng `null`, người dùng sẽ bị chặn lại và chuyển tiếp về `/login.jsp` kèm thông báo lỗi `"Bạn chưa đăng nhập, vui lòng đăng nhập để tiếp tục!"` đặt ở request attribute `"error"`.
6. **Truy vấn hạng thành viên và kiểm tra điều kiện (Validate):**
   - Servlet lấy ID khách hàng `customerId = account.getId()`.
   - Servlet khởi tạo [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java) và gọi phương thức `customerDAO.getCustomerProfile(customerId)` để lấy đối tượng `Customer customerProfile` chứa thông tin thực tế từ database.
   - Servlet trích xuất mã hạng thành viên bằng `int tierId = customerProfile.getTierId()` và tên hạng thành viên bằng `String tierName = customerProfile.getTierName()`.
   - Servlet chuyển đổi chuỗi ngày `bookingDateStr` sang đối tượng `java.time.LocalDate` và tính khoảng cách ngày so với ngày hiện tại (`LocalDate.now()`) bằng `ChronoUnit.DAYS.between(today, bookingDate)`.
   - **Kiểm tra ngày quá khứ:** Nếu khoảng cách ngày nhỏ hơn 0, hệ thống báo lỗi `"Lỗi: Không thể đặt lịch trong quá khứ!"`.
   - **Kiểm tra số ngày đặt trước:** Hiện tại, Servlet đang sử dụng cấu trúc `switch(tierId)` để kiểm tra số ngày đặt trước tối đa được phép (`maxDaysAllowed` nhận giá trị cố định `7`, `10`, `12`, hoặc `14` ngày tương ứng với hạng `1`, `2`, `3`, `4`).
   - Nếu số ngày đặt trước vượt quá `maxDaysAllowed`, Servlet gửi thông báo lỗi `"Quyền lợi Hạng " + tierName + " chỉ được đặt trước tối đa " + maxDaysAllowed + " ngày!"` và forward về trang đặt lịch.
7. **Lưu thông tin đặt lịch vào Database:**
   - Nếu tất cả các bước kiểm tra đều hợp lệ, Servlet thực hiện chuyển đổi định dạng dữ liệu (`vehicleId = Integer.parseInt(vehicleIdStr)`, `serviceId = Integer.parseInt(serviceIdStr)`).
   - Servlet khởi tạo [BookingDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/BookingDAO.java) và gọi phương thức `createNewBooking(customerId, vehicleId, serviceId, bookingDateStr, bookingTime, price)`.
   - Trong [BookingDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/BookingDAO.java), phương thức `createNewBooking` thực hiện lưu dữ liệu vào 2 bảng theo cơ chế giao dịch (Transaction):
     * **Bảng Booking:** Thực thi lệnh `INSERT INTO Booking (customer_id, vehicle_id, booking_date, booking_time, status, total_price) VALUES (?, ?, ?, ?, 'Pending', ?)` để tạo bản ghi đặt lịch. Đồng thời lấy khóa chính tự tăng vừa tạo (`booking_id`).
     * **Bảng BookingService:** Thực thi lệnh `INSERT INTO BookingService (booking_id, service_id, quantity, price) VALUES (?, ?, 1, ?)` để lưu thông tin dịch vụ đi kèm với booking.
     * Nếu cả hai lệnh đều thành công, DAO sẽ thực hiện `conn.commit()`. Nếu xảy ra bất kỳ lỗi nào, DAO sẽ thực hiện `conn.rollback()`.
8. **Chuyển tiếp và phản hồi kết quả:**
   - Nếu DAO lưu thành công (`isSuccess` là `true`), Servlet gán thuộc tính thông báo thành công `success` là `"🎉 Đặt lịch thành công! Vui lòng đến đúng giờ."`.
   - Nếu thất bại, Servlet gán thuộc tính thông báo lỗi `error` là `"Lỗi hệ thống: Không thể lưu vào Database!"`.
   - Cuối cùng, Servlet thực hiện forward về trang [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp) bằng `request.getRequestDispatcher("booking.jsp").forward(request, response)` để hiển thị kết quả cho người dùng.
   - Nếu trong quá trình xử lý xảy ra ngoại lệ (Exception), hệ thống nhảy vào catch block, đặt thuộc tính `error` bằng `"Lỗi dữ liệu: Vui lòng kiểm tra lại các thông tin đã nhập!"` và forward về trang [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp).

---

## 5. Thông tin session và người dùng hiện tại

* **Lưu trữ tài khoản trong Session:** Sau khi người dùng đăng nhập thành công, thông tin tài khoản được lưu trong đối tượng `HttpSession` bằng khóa (Key) được định nghĩa ở lớp cấu hình:
  - Tên thuộc tính trong code: `AppKeys.SESSION_ACCOUNT`
  - Giá trị thực tế của Key: `"account"`
* **Kiểu dữ liệu đối tượng trong Session:** Đối tượng lưu trữ thuộc lớp [User.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/User.java) (package `dto`).
* **Các thông tin chứa trong đối tượng User:**
  - `id` (int): Mã ID duy nhất của tài khoản.
  - `fullName` (String): Họ và tên của tài khoản.
  - `phone` (String): Số điện thoại đăng ký.
  - `email` (String): Địa chỉ email đăng ký.
  - `password` (String): Mật khẩu.
  - `totalSpentMoney` (BigDecimal): Tổng số tiền đã chi tiêu trong hệ thống.
  - `totalPoints` (int): Tổng điểm tích lũy của khách hàng.
* **Sự thiếu hụt thông tin Hạng thành viên:** Lớp [User.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/User.java) **KHÔNG** chứa các thông tin liên quan đến hạng thành viên như mã hạng (`tier_id`), tên hạng (`tier_name`), hay số ngày đặt lịch trước (`booking_window_days`).
* **Giải pháp lấy thông tin Hạng thành viên hiện tại:** Do session không lưu trữ hạng thành viên, Servlet phải dùng ID người dùng lấy từ session (`account.getId()`) để gọi phương thức `getCustomerProfile(customerId)` của [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java). Phương thức này sẽ thực thi câu lệnh SQL JOIN để tải đối tượng [Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java) (đối tượng này mới chứa các trường `tierId` và `tierName`).

---

## 6. Database hiện tại liên quan đến booking

Cơ sở dữ liệu của dự án có cấu trúc liên quan đến luồng đặt lịch như sau:

### 6.1 Bảng Booking (Đặt lịch)
* **Tên bảng:** `Booking`
* **Các cột trong bảng:**
  - `booking_id` (INT, Khóa chính, Tự động tăng `IDENTITY(1,1)`)
  - `customer_id` (INT, Khóa ngoại liên kết tới bảng `Customer`)
  - `vehicle_id` (INT, Khóa ngoại liên kết tới bảng `Vehicle`)
  - `booking_date` (DATE, Lưu ngày đặt lịch)
  - `booking_time` (TIME, Lưu giờ đặt lịch)
  - `status` (NVARCHAR(50), Trạng thái của booking - mặc định khi tạo mới là `'Pending'`)
  - `total_price` (DECIMAL(18,2), Tổng chi phí của đơn đặt lịch)
* **Cột lưu ngày đặt lịch:** `booking_date` (kiểu dữ liệu `DATE`).
* **Cột lưu mã khách hàng:** `customer_id` (kiểu dữ liệu `INT`).
* **Cột lưu trạng thái đơn đặt:** `status` (kiểu dữ liệu `NVARCHAR(50)`).
* **Cột lưu ca/giờ đặt lịch:** `booking_time` (kiểu dữ liệu `TIME`).

### 6.2 Bảng Customer (Khách hàng)
* **Tên bảng:** `Customer`
* **Các cột quan trọng:**
  - `customer_id` (INT, Khóa chính, Tự động tăng `IDENTITY(1,1)`)
  - `full_name` (NVARCHAR(100), Họ tên đầy đủ)
  - `phone` (VARCHAR(15), Số điện thoại)
  - `email` (VARCHAR(100), Email tài khoản)
  - `password` (NVARCHAR(255), Mật khẩu)
  - `join_date` (DATETIME, Ngày tham gia hệ thống)
  - `total_spent_money` (DECIMAL(18,2), Tổng tiền đã chi tiêu)
  - `total_points` (INT, Tổng điểm tích lũy của khách)
  - `tier_id` (INT, Khóa ngoại liên kết tới bảng `MembershipTier`)
* **Mối quan hệ với Booking:** Một khách hàng (`Customer`) có thể thực hiện nhiều lượt đặt lịch (`Booking`). Đây là quan hệ 1 - Nhiều (One-to-Many). Khóa ngoại `customer_id` trong bảng `Booking` tham chiếu tới khóa chính `customer_id` trong bảng `Customer`.

### 6.3 Bảng MembershipTier (Hạng thành viên)
* **Tên bảng:** `MembershipTier`
* **Các cột trong bảng:**
  - `tier_id` (INT, Khóa chính, Tự động tăng `IDENTITY(1,1)`)
  - `tier_name` (VARCHAR(50), Tên hạng thành viên, ví dụ: `'Member'`, `'Silver'`, `'Gold'`, `'Platinum'`)
  - `min_points` (INT, Mốc điểm tích lũy tối thiểu để đạt hạng)
  - `discount_percent` (DECIMAL(5,2), Phần trăm giảm giá mặc định của hạng)
  - `benefits` (NVARCHAR(MAX), Mô tả các ưu đãi/quyền lợi)
* **Cột lưu tên hạng thành viên:** `tier_name` (kiểu dữ liệu `VARCHAR(50)`).
* **Cột lưu số ngày đặt trước tối đa (`booking_window_days`):** **CHƯA CÓ**. Hiện tại cơ sở dữ liệu chưa hỗ trợ lưu trữ cấu hình số ngày đặt trước cho từng hạng thành viên.
* **Khả năng sử dụng cho FR-06b:** Bảng này hoàn toàn phù hợp để triển khai tính năng FR-06b. Chúng ta cần thiết kế thêm một cột mới có tên là `booking_window_days` kiểu `INT` để lưu cấu hình số ngày đặt trước tối đa của mỗi hạng, tránh việc hardcode dưới Servlet.

---

## 7. Code hiện tại đã có gì cho hạng thành viên?

* **Class hạng thành viên riêng biệt:** **Chưa thấy trong repo**. Dự án chưa định nghĩa một lớp DTO riêng biệt đại diện cho bảng `MembershipTier` (ví dụ `MembershipTier.java` hoặc `MembershipTierDTO.java`).
* **DAO đọc hạng thành viên:** **Chưa thấy trong repo**. Dự án chưa có một lớp DAO riêng để xử lý các truy vấn chuyên biệt trên bảng `MembershipTier` (như `MembershipTierDAO.java` hoặc `TierDAO.java`).
* **Thuộc tính hạng thành viên trong lớp Customer:**
  - Lớp [Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java) đã có sẵn hai trường thông tin là `tierId` (kiểu `int`) và `tierName` (kiểu `String`) cùng các phương thức Getter và Setter tương ứng.
* **Dữ liệu hạng thành viên mẫu:**
  - Trong tệp tin SQL [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql) đã được seed sẵn 4 hạng thành viên bao gồm:
    1. `'Member'` (mã hạng `1`, mốc điểm tối thiểu `0`)
    2. `'Silver'` (mã hạng `2`, mốc điểm tối thiểu `2000`)
    3. `'Gold'` (mã hạng `3`, mốc điểm tối thiểu `6000`)
    4. `'Platinum'` (mã hạng `4`, mốc điểm tối thiểu `15000`)
* **Logic tự động nâng/hạ hạng (upgrade/downgrade):** **Chưa thấy trong repo**. Code xử lý Java hiện tại chưa có các tác vụ tự động cập nhật lại hạng thành viên của khách hàng khi họ đạt đủ điểm hoặc chi tiêu (chỉ có dữ liệu mẫu được gán sẵn `tier_id` cho khách hàng trong file script).
* **Logic tích điểm/đổi thưởng liên quan:**
  - Dự án đã có lớp [RewardDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/RewardDAO.java) và [RewardDTO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/RewardDTO.java) để thực hiện nghiệp vụ đổi điểm tích lũy lấy các phần quà/ưu đãi (bảng `Reward` và `Redemption` trong DB).

---

## 8. Code hiện tại đã validate ngày booking chưa?

Hệ thống hiện tại đã thực hiện một số bước kiểm tra dữ liệu ngày đặt lịch như sau:

* **Chặn ngày quá khứ:** Có. Servlet tính chênh lệch ngày giữa ngày hiện tại và ngày người dùng chọn (`daysBetween`). Nếu `daysBetween < 0`, Servlet lập tức chặn lại và hiển thị thông báo: `"Lỗi: Không thể đặt lịch trong quá khứ!"`.
* **Chặn đặt lịch quá xa:** Có. Tuy nhiên, việc chặn đặt lịch quá xa hiện tại đang bị **hardcode** trực tiếp trong phương thức `doPost` của Servlet [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) bằng cấu trúc switch-case dựa vào mã hạng thành viên (`tierId`).
* **Kiểm tra ngày hợp lệ:** Có. Hệ thống sử dụng phương thức `LocalDate.parse(bookingDateStr)` để phân tích chuỗi ngày từ form. Nếu chuỗi ngày gửi lên không đúng định dạng chuẩn `YYYY-MM-DD` hoặc ngày không tồn tại, phương thức sẽ ném ra ngoại lệ `DateTimeParseException`. Catch block sẽ bắt ngoại lệ này và phản hồi về giao diện thông báo lỗi: `"Lỗi dữ liệu: Vui lòng kiểm tra lại các thông tin đã nhập!"`.
* **Sử dụng đối tượng thời gian:** Servlet sử dụng lớp `java.time.LocalDate` để thực hiện tính toán khoảng cách ngày. DAO nhận tham số ngày dạng `String` và truyền trực tiếp vào `PreparedStatement.setString(3, bookingDate)` để SQL Server tự động chuyển đổi sang kiểu `DATE` trong cơ sở dữ liệu.
* **Message báo lỗi trả về giao diện:** Khi có lỗi kiểm tra ngày, Servlet thiết lập chuỗi thông báo lỗi vào request attribute với Key `"error"` rồi sử dụng `RequestDispatcher` để forward lại dữ liệu về trang [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp). Đoạn code JSTL/JSP Scriptlet trong trang JSP sẽ kiểm tra sự tồn tại của thuộc tính `"error"` để in thông báo lỗi ra màn hình dưới dạng một hộp thoại màu đỏ.

---

## 9. Gap analysis cho FR-06b

Khi đối chiếu mã nguồn và cấu trúc cơ sở dữ liệu hiện tại với yêu cầu của nghiệp vụ **FR-06b**, các khoảng trống kỹ thuật (Gaps) cần giải quyết bao gồm:

1. **Thiếu trường dữ liệu trong Cơ sở dữ liệu:**
   - Bảng `MembershipTier` chưa có cột cấu hình số ngày đặt lịch trước (ví dụ: `booking_window_days`).
2. **Thiếu dữ liệu cấu hình mẫu:**
   - File seed dữ liệu [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql) chưa chèn thông tin số ngày đặt lịch cho từng hạng.
3. **Thiếu thuộc tính lưu trữ trong DTO:**
   - Lớp [Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java) thiếu thuộc tính `bookingWindowDays` (kiểu `int`) để hứng giá trị cấu hình số ngày đặt trước của khách hàng từ DB.
4. **Truy vấn DAO chưa tải đủ dữ liệu:**
   - Phương thức `getCustomerProfile(int customerId)` trong [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java) chưa thực hiện SELECT cột cấu hình số ngày đặt trước từ bảng `MembershipTier`.
5. **Logic kiểm tra ngày ở Servlet bị Hardcode:**
   - Khóa chặn kiểm tra `maxDaysAllowed` đang được viết cứng thông qua cấu trúc `switch-case` trong [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java). Khi cấu hình ngày thay đổi hoặc có thêm hạng thành viên mới trong DB, hệ thống bắt buộc phải compile lại code Java, vi phạm nguyên tắc thiết kế mở rộng.

---

## 10. Đề xuất database design cho FR-06b

Để lưu trữ động số ngày được phép đặt trước theo hạng thành viên mà không cần sinh thêm bảng mới phức tạp, phương án thiết kế tốt nhất là bổ sung trực tiếp cột cấu hình vào bảng hạng thành viên có sẵn:

* **Tên bảng tác động:** `MembershipTier`
* **Cột đề xuất thêm mới:** `booking_window_days`
  - Kiểu dữ liệu: `INT`
  - Ràng buộc: `NOT NULL`, giá trị mặc định là `7` (đại diện cho hạng cơ bản nhất).
* **Câu lệnh cập nhật cấu trúc DB (ALTER TABLE Script):**
  ```sql
  ALTER TABLE MembershipTier ADD booking_window_days INT NOT NULL DEFAULT 7;
  ```
* **Cập nhật dữ liệu cấu hình thực tế cho các hạng thành viên:**
  ```sql
  UPDATE MembershipTier SET booking_window_days = 7 WHERE tier_name = 'Member';
  UPDATE MembershipTier SET booking_window_days = 10 WHERE tier_name = 'Silver';
  UPDATE MembershipTier SET booking_window_days = 12 WHERE tier_name = 'Gold';
  UPDATE MembershipTier SET booking_window_days = 14 WHERE tier_name = 'Platinum';
  ```

---

## 11. Đề xuất luồng code cho bước sau

Luồng xử lý dự kiến sau khi sửa code (được thực hiện động, lấy dữ liệu cấu hình từ DB thay vì hardcode):

1. **Người dùng gửi yêu cầu:** Form POST gửi tham số ngày đặt lịch `bookingDate` tới Servlet.
2. **Nhận dữ liệu & Kiểm tra đăng nhập:** Servlet lấy `bookingDateStr` từ request và lấy đối tượng `User` hiện tại từ session.
3. **Tải thông tin hồ sơ và cấu hình hạng thành viên:**
   - Gọi `customerDAO.getCustomerProfile(customerId)`.
   - Đối tượng `Customer customerProfile` trả về bây giờ sẽ chứa thêm thuộc tính cấu hình `bookingWindowDays` được tải trực tiếp từ DB.
4. **Phân tích ngày đặt lịch:**
   - Thực hiện parse `bookingDateStr` sang `LocalDate bookingDate`.
   - Tính toán khoảng cách chênh lệch ngày `daysBetween` so với `LocalDate.now()`.
5. **Thực hiện kiểm tra nghiệp vụ:**
   - **Bước 1 (Kiểm tra ngày quá khứ):** Nếu `daysBetween < 0`, báo lỗi `"Lỗi: Không thể đặt lịch trong quá khứ!"` và forward về trang đặt lịch.
   - **Bước 2 (Kiểm tra số ngày đặt trước tối đa theo hạng):**
     - Thay vì sử dụng switch-case, Servlet lấy động giới hạn tối đa:
       ```java
       int maxDaysAllowed = customerProfile.getBookingWindowDays();
       ```
     - So sánh: Nếu `daysBetween > maxDaysAllowed`, Servlet báo lỗi động:
       ```java
       request.setAttribute("error", "Quyền lợi Hạng " + customerProfile.getTierName() + " chỉ được đặt trước tối đa " + maxDaysAllowed + " ngày!");
       ```
       sau đó forward về trang [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp) để ngăn chặn hành động đặt lịch.
6. **Lưu dữ liệu:** Nếu vượt qua các bước validate, tiến hành gọi `BookingDAO` để ghi nhận booking vào Database như bình thường.

---

## 12. Danh sách file dự kiến cần sửa ở bước code

Dưới đây là danh sách chi tiết các file trong repo cần can thiệp để hoàn thành tính năng FR-06b, đi kèm mục đích sửa đổi và đánh giá mức độ rủi ro:

1. **[SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql)**
   - **Nội dung sửa đổi:** Bổ sung cột `booking_window_days INT NOT NULL DEFAULT 7` vào định nghĩa lệnh `CREATE TABLE MembershipTier`.
   - **Mức độ rủi ro:** **Thấp** (Chỉ tác động đến cấu trúc khởi tạo ban đầu của DB).
2. **[InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql)**
   - **Nội dung sửa đổi:** Cập nhật lệnh `INSERT INTO MembershipTier` để chèn thêm giá trị cho cột `booking_window_days` tương ứng là `7`, `10`, `12`, `14`.
   - **Mức độ rủi ro:** **Thấp** (Chỉ thay đổi dữ liệu mẫu).
3. **[Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java)**
   - **Nội dung sửa đổi:** Khai báo thêm thuộc tính `private int bookingWindowDays;` cùng phương thức Getter `public int getBookingWindowDays()` và Setter `public void setBookingWindowDays(int bookingWindowDays)`.
   - **Mức độ rủi ro:** **Thấp** (Chỉ mở rộng thêm thuộc tính dữ liệu trong DTO).
4. **[CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java)**
   - **Nội dung sửa đổi:**
     - Cập nhật chuỗi SQL SELECT trong phương thức `getCustomerProfile` để lấy thêm cột `t.booking_window_days`:
       ```sql
       SELECT c.customer_id, c.full_name, c.phone, c.email, c.join_date, c.total_points, c.tier_id, t.tier_name, t.booking_window_days ...
       ```
     - Trong khối đọc dữ liệu `ResultSet`, thực hiện gán giá trị:
       ```java
       cus.setBookingWindowDays(table.getInt("booking_window_days"));
       ```
   - **Mức độ rủi ro:** **Trung bình** (Cần kiểm tra kỹ để tránh viết sai cú pháp câu lệnh SQL JOIN và đảm bảo xử lý trường hợp giá trị của cột bị `NULL` một cách an toàn).
5. **[CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java)**
   - **Nội dung sửa đổi:** Loại bỏ toàn bộ khối lệnh `switch(tierId)` đang gán cứng giá trị `maxDaysAllowed`. Thay thế bằng dòng lệnh lấy động: `int maxDaysAllowed = customerProfile.getBookingWindowDays();`.
   - **Mức độ rủi ro:** **Trung bình** (Cần kiểm tra logic so sánh chênh lệch ngày và đảm bảo kiểm thử kỹ lưỡng trường hợp giá trị `maxDaysAllowed` nhận về từ DB là 0 hoặc âm do lỗi nhập liệu của quản trị viên).

---

## 13. Test case cần có cho FR-06b

Các kịch bản kiểm thử thủ công chi tiết để nghiệm thu tính năng sau khi hiện thực:

* **Kịch bản 1: Đặt lịch trong giới hạn của hạng Member**
  - **Tài khoản kiểm thử:** Hạng Member (ví dụ: `ang@gmail.com`). Số ngày cấu hình trong DB: 7 ngày.
  - **Hành động:** Chọn ngày đặt lịch là **hôm nay + 7 ngày**.
  - **Kết quả mong muốn:** Đặt lịch thành công, hiển thị thông báo thành công màu xanh.
* **Kịch bản 2: Đặt lịch vượt giới hạn của hạng Member**
  - **Tài khoản kiểm thử:** Hạng Member (ví dụ: `ang@gmail.com`). Số ngày cấu hình trong DB: 7 ngày.
  - **Hành động:** Chọn ngày đặt lịch là **hôm nay + 8 ngày**.
  - **Kết quả mong muốn:** Hệ thống từ chối lưu, hiển thị thông báo lỗi màu đỏ: `"Quyền lợi Hạng Member chỉ được đặt trước tối đa 7 ngày!"`.
* **Kịch bản 3: Đặt lịch trong giới hạn của hạng Silver**
  - **Tài khoản kiểm thử:** Hạng Silver (ví dụ: `anv@gmail.com`). Số ngày cấu hình trong DB: 10 ngày.
  - **Hành động:** Chọn ngày đặt lịch là **hôm nay + 10 ngày**.
  - **Kết quả mong muốn:** Đặt lịch thành công.
* **Kịch bản 4: Đặt lịch vượt giới hạn của hạng Silver**
  - **Tài khoản kiểm thử:** Hạng Silver (ví dụ: `anv@gmail.com`). Số ngày cấu hình trong DB: 10 ngày.
  - **Hành động:** Chọn ngày đặt lịch là **hôm nay + 11 ngày**.
  - **Kết quả mong muốn:** Đặt lịch thất bại, báo lỗi: `"Quyền lợi Hạng Silver chỉ được đặt trước tối đa 10 ngày!"`.
* **Kịch bản 5: Đặt lịch trong giới hạn của hạng Gold**
  - **Tài khoản kiểm thử:** Hạng Gold (ví dụ: `btt@gmail.com`). Số ngày cấu hình trong DB: 12 ngày.
  - **Hành động:** Chọn ngày đặt lịch là **hôm nay + 12 ngày**.
  - **Kết quả mong muốn:** Đặt lịch thành công.
* **Kịch bản 6: Đặt lịch vượt giới hạn của hạng Gold**
  - **Tài khoản kiểm thử:** Hạng Gold (ví dụ: `btt@gmail.com`). Số ngày cấu hình trong DB: 12 ngày.
  - **Hành động:** Chọn ngày đặt lịch là **hôm nay + 13 ngày**.
  - **Kết quả mong muốn:** Đặt lịch thất bại, báo lỗi: `"Quyền lợi Hạng Gold chỉ được đặt trước tối đa 12 ngày!"`.
* **Kịch bản 7: Đặt lịch trong giới hạn của hạng Platinum**
  - **Tài khoản kiểm thử:** Hạng Platinum (ví dụ: `cvl@gmail.com`). Số ngày cấu hình trong DB: 14 ngày.
  - **Hành động:** Chọn ngày đặt lịch là **hôm nay + 14 ngày**.
  - **Kết quả mong muốn:** Đặt lịch thành công.
* **Kịch bản 8: Đặt lịch vượt giới hạn của hạng Platinum**
  - **Tài khoản kiểm thử:** Hạng Platinum (ví dụ: `cvl@gmail.com`). Số ngày cấu hình trong DB: 14 ngày.
  - **Hành động:** Chọn ngày đặt lịch là **hôm nay + 15 ngày**.
  - **Kết quả mong muốn:** Đặt lịch thất bại, báo lỗi: `"Quyền lợi Hạng Platinum chỉ được đặt trước tối đa 14 ngày!"`.
* **Kịch bản 9: Đặt lịch ngày trong quá khứ**
  - **Tài khoản kiểm thử:** Bất kỳ tài khoản hạng nào.
  - **Hành động:** Chọn ngày đặt lịch là **ngày hôm qua hoặc xa hơn**.
  - **Kết quả mong muốn:** Đặt lịch thất bại, báo lỗi: `"Lỗi: Không thể đặt lịch trong quá khứ!"`.
* **Kịch bản 10: Tài khoản chưa có hạng thành viên (Dữ liệu lỗi)**
  - **Tài khoản kiểm thử:** Tài khoản khách hàng có trường `tier_id` bị `NULL` trong database.
  - **Hành động:** Đặt lịch vào bất kỳ ngày nào.
  - **Kết quả mong muốn:** Hệ thống xử lý fallback an toàn (mặc định coi khách hàng là hạng Member với số ngày đặt trước mặc định là 7 ngày), không phát sinh lỗi NullPointerException làm sập ứng dụng.
* **Dữ liệu Seed bổ sung:** Chạy lại toàn bộ tập lệnh SQL cập nhật để đồng bộ dữ liệu trước khi kiểm thử.

---

## 14. Câu hỏi cần user xác nhận trước khi code

Để quá trình triển khai mã nguồn diễn ra thuận lợi, cần làm rõ một số điểm sau với lập trình viên/người dùng:

1. **Phương thức cập nhật Database:** Chúng ta sẽ chỉnh sửa trực tiếp vào file kịch bản SQL khởi tạo gốc ([SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql) và [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql)) hay sẽ viết một file kịch bản SQL riêng biệt (ví dụ `update_schema.sql`) để chạy câu lệnh `ALTER TABLE` cập nhật trên hệ thống database đang hoạt động?
2. **Xử lý giá trị NULL/Mặc định:** Nếu khách hàng chưa có hạng thành viên gắn kèm (`tier_id` bị NULL) hoặc giá trị cấu hình `booking_window_days` trong bảng `MembershipTier` bị thiết lập NULL/không hợp lệ, hệ thống sẽ mặc định gán giá trị fallback là 7 ngày (hạng Member) hay lập tức từ chối cho phép đặt lịch và hiển thị lỗi hệ thống?
3. **Ngôn ngữ thông báo lỗi:** Thông báo lỗi phản hồi về cho khách hàng trên trang JSP được yêu cầu viết bằng tiếng Việt (như hiện tại đang sử dụng) hay tiếng Anh?
4. **Kiểm soát Client-side:** Có cần bổ sung thêm mã Javascript ở trang giao diện [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp) để cấu hình động thuộc tính `max` cho thẻ `<input type="date">` dựa trên hạng thành viên của người dùng ngay từ lúc tải trang, nhằm cải thiện trải nghiệm người dùng (ngăn chặn click chọn ngày không hợp lệ ngay từ giao diện trước khi gửi request) hay chỉ cần validate ở Server-side?

---

## 15. Kết luận cho chatbot bên ngoài

* **Tình trạng hiện tại của Repo:**
  - Repo dự án đã trang bị đầy đủ các thành phần cơ bản của luồng đặt lịch: giao diện đặt lịch ([booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp)), xử lý trung gian ([CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java)), và lưu trữ dữ liệu ([BookingDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/BookingDAO.java)).
  - Bảng cơ sở dữ liệu `Customer` và `MembershipTier` đã có liên kết khóa ngoại. Lớp `CustomerDAO` đã hỗ trợ JOIN bảng để lấy thông tin hạng thành viên.
  - Logic validate ngày đặt lịch quá khứ và chặn số ngày đặt trước đã được viết sẵn trong Servlet nhưng đang bị hardcode.
* **Nội dung còn thiếu cần bổ sung:**
  - Cột cấu hình `booking_window_days` trong bảng `MembershipTier` tại database và thuộc tính `bookingWindowDays` tương ứng trong lớp `dto.Customer`.
  - Câu SQL trong `CustomerDAO.getCustomerProfile` để SELECT lấy cột cấu hình này và gán vào đối tượng `Customer`.
  - Thay đổi logic Servlet từ kiểm tra switch-case viết cứng thành kiểm tra động theo thuộc tính của đối tượng `Customer` vừa tải từ DB.
* **Khuyến nghị bước tiếp theo:** Codebase hiện tại đã rất rõ ràng và mạch lạc. Lập trình viên có thể tiến hành viết code sửa đổi ngay sau khi nhận được sự đồng thuận từ phía người dùng về các câu hỏi thảo luận tại Mục 14.
