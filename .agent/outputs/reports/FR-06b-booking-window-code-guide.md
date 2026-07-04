# FR-06b Booking Window Code Guide

## 1. Mục tiêu chức năng

Chức năng **FR-06b Booking Window** quy định giới hạn số ngày mà khách hàng được phép đặt lịch rửa xe trước (đặt trước tối đa bao nhiêu ngày so với ngày hiện tại). Giới hạn này phụ thuộc trực tiếp vào hạng thành viên của khách hàng đó:
- Hạng **Member**: Được đặt trước tối đa **7 ngày**.
- Hạng **Silver**: Được đặt trước tối đa **10 ngày**.
- Hạng **Gold**: Được đặt trước tối đa **12 ngày**.
- Hạng **Platinum**: Được đặt trước tối đa **14 ngày**.

**Yêu cầu thiết kế cốt lõi:** Số ngày được phép đặt trước tối đa này **PHẢI** được lấy động từ cơ sở dữ liệu (cụ thể là cột `booking_window_days` trong bảng `MembershipTier`), tuyệt đối không được viết cứng (hardcode) các giá trị `7`, `10`, `12`, `14` trong mã nguồn Java (Servlet hay Controller). Điều này giúp hệ thống dễ dàng thay đổi cấu hình nghiệp vụ trực tiếp trong database mà không cần phải biên dịch lại mã nguồn Java.

---

## 2. Trạng thái hiện tại của project

Trước khi thực hiện bước này, dự án đang có trạng thái như sau:
* **Giao diện đặt lịch:** File [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp) chứa biểu mẫu (form) cho phép người dùng chọn xe, chọn gói dịch vụ, ngày đặt lịch (`bookingDate`), ca đặt lịch (`bookingTime`) và gửi yêu cầu lên Server.
* **Servlet điều phối:** File [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) tiếp nhận request, lấy tài khoản khách hàng từ session, gọi [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java) để lấy thông tin hồ sơ và thực hiện so sánh ngày đặt trước.
* **Lưu trữ dữ liệu:** File [BookingDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/BookingDAO.java) lưu thông tin booking mới vào cơ sở dữ liệu.
* **Database script:** Bảng `MembershipTier` trong database đã được cập nhật thêm cột `booking_window_days INT NOT NULL DEFAULT 7` và dữ liệu mẫu đã được seed (Member = 7, Silver = 10, Gold = 12, Platinum = 14).
* **Vấn đề tồn tại:** Logic validate số ngày đặt lịch trước trong [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) hiện tại vẫn đang **hardcode** bằng cấu trúc `switch-case` dựa trên mã hạng thành viên (`tierId`).

---

## 3. Luồng dữ liệu booking hiện tại

Luồng dữ liệu khi khách hàng nhấn nút "Xác nhận đặt lịch" hiện tại diễn ra như sau:

1. Khách hàng điền thông tin trên giao diện [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp) và nhấn nút gửi.
2. Biểu mẫu gửi một request `POST` đến Servlet [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java).
3. Servlet lấy các tham số của form: `vehicleId`, `serviceId`, `bookingDate`, `bookingTime`.
4. Servlet kiểm tra session và lấy thông tin tài khoản đăng nhập `User` qua key `AppKeys.SESSION_ACCOUNT` (giá trị là `"account"`).
5. Lấy `customerId = account.getId()`.
6. Servlet gọi phương thức `customerDAO.getCustomerProfile(customerId)` để lấy hồ sơ thông tin khách hàng từ DB (đối tượng [Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java)), nhằm trích xuất `tierId` (mã hạng) và `tierName` (tên hạng).
7. Servlet parse chuỗi ngày `bookingDate` sang `LocalDate` và tính toán chênh lệch ngày `daysBetween` so với ngày hiện tại.
8. **Validate ngày quá khứ:** Nếu `daysBetween < 0`, Servlet báo lỗi `"Lỗi: Không thể đặt lịch trong quá khứ!"` và forward về trang đặt lịch.
9. **Validate ngày đặt trước (Đang hardcode):** Servlet chạy qua `switch (tierId)` để quyết định `maxDaysAllowed` (Hạng 1: 7 ngày, hạng 2: 10 ngày, hạng 3: 12 ngày, hạng 4: 14 ngày). Nếu `daysBetween > maxDaysAllowed`, báo lỗi và forward về trang đặt lịch.
10. **Lưu dữ liệu:** Nếu không có lỗi, Servlet gọi [BookingDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/BookingDAO.java) thực hiện lưu thông tin vào bảng `Booking` và `BookingService`, sau đó trả về thông báo thành công.

---

## 4. Luồng dữ liệu booking sau khi sửa đúng FR-06b

Sau khi thực hiện sửa đổi Java, luồng dữ liệu sẽ được thực hiện động hoàn toàn theo sơ đồ sau:

```
[booking.jsp] (Nhấn đặt lịch)
      │
      ▼  (POST: vehicleId, serviceId, bookingDate, bookingTime)
[CreateBookingServlet] ──(Lấy account từ session)──► [User] (Lấy customerId)
      │
      ├──────────────────► Gọi [CustomerDAO.getCustomerProfile(customerId)]
      │                                    │
      │                                    ▼ (Thực thi SELECT JOIN thêm cột)
      │                             SELECT t.booking_window_days 
      │                             FROM Customer c 
      │                             LEFT JOIN MembershipTier t ON c.tier_id = t.tier_id
      │                                    │
      │                                    ▼ (Hứng dữ liệu và set vào DTO)
      │                             [Customer] (Trích xuất bookingWindowDays)
      │                                    │
      ▼ <─── Trả về đối tượng Customer ────┘
[CreateBookingServlet]
      │
      ├─► Validate 1: bookingDate không ở quá khứ (daysBetween < 0)
      │
      ├─► Lấy động: maxDaysAllowed = customerProfile.getBookingWindowDays()
      │
      ├─► Validate 2: daysBetween > maxDaysAllowed (Không dùng switch-case)
      │         │
      │         ├─► [Nếu Sai] ──► Set attribute "error" ──► Forward về [booking.jsp]
      │         │
      │         └─► [Nếu Đúng]
      │                 │
      ▼                 ▼
[BookingDAO.createNewBooking(...)] ──► Insert dữ liệu vào [Booking] & [BookingService]
      │
      ▼
Forward về [booking.jsp] kèm thông báo thành công hoặc lỗi DB
```

---

## 5. Vì sao phải lấy booking_window_days từ database?

Việc cấu hình động số ngày đặt lịch trước mang lại nhiều lợi ích lớn cho kiến trúc phần mềm và quản lý nghiệp vụ:

1. **Tuân thủ nguyên tắc không hardcode:** Tránh việc đưa các giá trị nghiệp vụ thay đổi thường xuyên vào mã nguồn biên dịch.
2. **Quản lý tập trung dữ liệu hạng thành viên:** Số ngày đặt trước tối đa là thuộc tính cấu hình đặc trưng của từng Hạng thành viên, do đó nó phải đi liền với bảng dữ liệu `MembershipTier` của hạng thành viên đó.
3. **Thay đổi chính sách không cần code lại:** Sau này, nếu quản trị viên muốn thay đổi chính sách (ví dụ: Gold được nâng lên đặt trước 15 ngày, hoặc thêm hạng thành viên mới "Diamond" đặt trước 30 ngày), họ chỉ cần cập nhật dữ liệu trong database mà không cần nhờ lập trình viên sửa code, compile và deploy lại toàn bộ ứng dụng.
4. **Dễ dàng viết kịch bản kiểm thử (Testability):** Có thể viết kiểm thử tự động hoặc kiểm thử thủ công linh hoạt bằng cách thay đổi cấu hình số ngày của hạng trong DB để chạy thử các trường hợp biên mà không cần đụng vào code logic.

**Giải thích các thuật ngữ chuyên môn:**
* **Hardcode:** Việc ghi trực tiếp một giá trị cụ thể (như số hoặc chuỗi) vào mã nguồn chương trình. Giá trị này cố định và chỉ thay đổi được khi viết lại mã nguồn và build lại ứng dụng.
* **Dynamic config (Cấu hình động):** Cơ chế đọc các giá trị cấu hình từ một nguồn lưu trữ ngoài (như database, file cấu hình) tại thời điểm chương trình chạy (runtime), giúp thay đổi hành vi chương trình mà không cần build lại.
* **DTO (Data Transfer Object):** Các lớp đối tượng đơn giản dùng để đóng gói và vận chuyển dữ liệu giữa các phân lớp xử lý (Servlet, DAO, JSP) trong ứng dụng.
* **DAO (Data Access Object):** Phân lớp chứa các đối tượng và phương thức chuyên đảm nhận nhiệm vụ truy vấn, ghi, đọc dữ liệu trực tiếp với cơ sở dữ liệu.
* **Servlet:** Thành phần công nghệ Java Web chạy trên máy chủ (Web Server), chịu trách nhiệm tiếp nhận các yêu cầu HTTP (Request) từ trình duyệt khách hàng, xử lý nghiệp vụ trung gian và trả lại phản hồi HTTP (Response).

---

## 6. Các file cần sửa ở bước code sau

Dưới đây là danh sách 3 file Java cần được sửa đổi ở bước tiếp theo để hiện thực hóa tính năng:

### 1. [Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java) (Lớp DTO)
* **Nhiệm vụ hiện tại:** Lưu trữ hồ sơ thông tin khách hàng lấy từ DB để vận chuyển giữa các tầng.
* **Cần sửa gì:** Khai báo thêm biến thành viên `bookingWindowDays` kèm theo cặp phương thức getter/setter.
* **Vì sao cần sửa:** Lớp này cần có thuộc tính tương ứng để làm cầu nối vận chuyển giá trị cột `booking_window_days` từ DAO sang Servlet.
* **Không được sửa:** Giữ nguyên các trường thông tin cũ như `tierId`, `tierName` và các constructor đã định nghĩa.

### 2. [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java) (Lớp DAO)
* **Nhiệm vụ hiện tại:** Thực hiện truy vấn JOIN bảng lấy thông tin khách hàng và hạng thành viên.
* **Cần sửa gì:** Thêm cột `t.booking_window_days` vào danh sách cột của câu lệnh SQL SELECT. Sau đó đọc giá trị từ ResultSet và set vào đối tượng `Customer`.
* **Vì sao cần sửa:** Đây là nơi duy nhất thực hiện việc tương tác trực tiếp với Database để lấy dữ liệu.
* **Không được sửa:** Không viết các câu lệnh SELECT lấy số ngày đặt trước trực tiếp ở Servlet mà phải thực hiện qua hàm DAO này. Giữ nguyên cấu trúc logic JOIN của câu lệnh SQL hiện tại để không làm hỏng tính năng hiển thị hạng thành viên.

### 3. [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) (Lớp Servlet)
* **Nhiệm vụ hiện tại:** Đón nhận request POST đặt lịch, tính chênh lệch ngày và validate ngày.
* **Cần sửa gì:** Loại bỏ cấu trúc switch-case hardcode. Đọc giá trị động từ đối tượng `CustomerProfile` bằng cách gọi hàm `customerProfile.getBookingWindowDays()`.
* **Vì sao cần sửa:** Để Servlet áp dụng quy tắc kiểm tra động dựa trên dữ liệu cấu hình thực tế tải từ database.
* **Không được sửa:** Không thay đổi flow điều hướng request, không đụng vào logic hàng đợi ưu tiên (Priority Queue) hay hàng chờ (Waiting List) của các issue khác.

*Lưu ý về [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp): File giao diện này đã có sẵn các thẻ JSTL hiển thị thông báo lỗi khi request attribute `"error"` khác null, do đó ở bước sau **không cần thiết** phải chỉnh sửa file JSP này.*

---

## 7. Hướng dẫn sửa Customer.java

Lớp DTO [Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java) cần được khai báo thêm biến thành viên và phương thức truy xuất:

* **Khai báo biến thành viên mới:**
  ```java
  private int bookingWindowDays;
  ```
* **Khai báo phương thức Getter & Setter:**
  ```java
  public int getBookingWindowDays() {
      return bookingWindowDays;
  }

  public void setBookingWindowDays(int bookingWindowDays) {
      this.bookingWindowDays = bookingWindowDays;
  }
  ```
* **Mục đích:** Khi [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java) tải thông tin từ database lên, nó sẽ gán giá trị này vào đối tượng `Customer`. Nhờ đó Servlet có thể truy cập được thông tin này để làm điều kiện validate.
* **Lưu ý an toàn:** Giữ nguyên các thuộc tính cũ như `customerId`, `fullName`, `phone`, `email`, `password`, `joinDate`, `totalPoints`, `tierId`, `tierName`. Không sửa đổi cấu trúc constructor mặc định không tham số của lớp.

---

## 8. Hướng dẫn sửa CustomerDAO.java

Trong lớp [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java), phương thức `getCustomerProfile(int customerId)` cần được cập nhật như sau:

* **Cập nhật câu SQL Select:** Thêm cột `t.booking_window_days` vào sau cột `t.tier_name`:
  ```sql
  String sql = "SELECT c.customer_id, c.full_name, c.phone, c.email, c.join_date, c.total_points, c.tier_id, t.tier_name, t.booking_window_days "
             + "FROM Customer c "
             + "LEFT JOIN MembershipTier t ON c.tier_id = t.tier_id "
             + "WHERE c.customer_id = ?";
  ```
* **Đọc dữ liệu từ ResultSet và gán vào đối tượng:**
  ```java
  if (table.next()) {
      cus = new Customer();
      cus.setCustomerId(table.getInt("customer_id"));
      cus.setFullName(table.getNString("full_name"));
      cus.setPhone(table.getString("phone"));
      cus.setEmail(table.getString("email"));
      cus.setJoinDate(table.getDate("join_date"));
      cus.setTotalPoints(table.getInt("total_points"));
      cus.setTierId(table.getInt("tier_id"));
      
      String tier = table.getString("tier_name");
      cus.setTierName(tier != null ? tier : "Thành viên mới");
      
      // Lấy thêm số ngày đặt trước tối đa từ ResultSet
      int bookingWindow = table.getInt("booking_window_days");
      // Fallback an toàn: nếu database trả về giá trị <= 0 thì mặc định là 7 ngày để hệ thống chạy ổn định
      if (bookingWindow <= 0) {
          bookingWindow = 7;
      }
      cus.setBookingWindowDays(bookingWindow);
  }
  ```
* **Lưu ý an toàn:** Giữ nguyên khối try-catch-finally đóng tài nguyên kết nối để tránh thất thoát tài nguyên cơ sở dữ liệu.

---

## 9. Hướng dẫn sửa CreateBookingServlet.java

Trong phương thức `doPost` của [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java), chúng ta sẽ gỡ bỏ đoạn code switch-case cứng và thay bằng logic cấu hình động:

* **Mã nguồn cũ (Cần gỡ bỏ):**
  ```java
  // Logic cũ bị hardcode
  int maxDaysAllowed = 0;
  switch (tierId) {
      case 1:
          maxDaysAllowed = 7;
          break;
      ...
  }
  ```
* **Mã nguồn mới (Thay thế):**
  ```java
  // Lấy động cấu hình từ đối tượng khách hàng tải từ DB
  int maxDaysAllowed = customerProfile.getBookingWindowDays();
  if (maxDaysAllowed <= 0) {
      maxDaysAllowed = 7; // Fallback an toàn
  }
  ```
* **Cập nhật thông báo lỗi:** Giữ nguyên câu thông báo lỗi chi tiết giúp người dùng dễ nhận biết:
  ```java
  if (daysBetween > maxDaysAllowed) {
      request.setAttribute("error", "Quyền lợi Hạng " + tierName + " chỉ được đặt trước tối đa " + maxDaysAllowed + " ngày!");
      request.getRequestDispatcher("booking.jsp").forward(request, response);
      return;
  }
  ```
* **Mối liên hệ nghiệp vụ:** Servlet chỉ thực hiện các bước điều phối request và validate nghiệp vụ. Bản thân Servlet không quan tâm các con số `7`, `10`, `12`, `14`. Việc này do database cung cấp cho DTO vận chuyển tới Servlet.

---

## 10. booking.jsp có cần sửa không?

* **Kiểm tra trạng thái hiển thị thông báo:** Trang [booking.jsp](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/web/booking.jsp) đã tích hợp sẵn đoạn mã hiển thị thông báo lỗi/thành công ở dòng 80-90:
  ```jsp
  <% String error = (String) request.getAttribute("error"); if (error != null) { %>
      <div class="bg-error-container/20 border border-error-container text-on-error-container px-4 py-3 rounded-lg text-center font-bold flex items-center justify-center gap-2">
          <span class="material-symbols-outlined">error</span><%= error %>
      </div>
  <% } %>
  ```
* **Kết luận:** **Không cần chỉnh sửa** bất kỳ nội dung nào trong file JSP này. Không thực hiện thiết kế lại giao diện và không chèn mã Javascript kiểm tra động ở phía trình duyệt để tránh gây xung đột cấu trúc hiển thị sẵn có của dự án.

---

## 11. Pseudocode luồng xử lý mới

Lập trình viên thực hiện lập trình logic trong phương thức `doPost` của Servlet theo cấu trúc mã giả sau:

```java
doPost(HttpServletRequest request, HttpServletResponse response) {
    // 1. Kiểm tra session đăng nhập
    HttpSession session = request.getSession(false);
    User account = (session != null) ? (User) session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
    if (account == null) {
        request.setAttribute("error", "Bạn chưa đăng nhập, vui lòng đăng nhập để tiếp tục!");
        forward to "/login.jsp";
        return;
    }
    
    // 2. Thu thập dữ liệu từ request
    String vehicleIdStr = request.getParameter("vehicleId");
    String serviceIdStr = request.getParameter("serviceId");
    String bookingDateStr = request.getParameter("bookingDate");
    String bookingTime = request.getParameter("bookingTime");
    
    // 3. Truy vấn hồ sơ khách hàng động từ Database
    int customerId = account.getId();
    Customer customerProfile = customerDAO.getCustomerProfile(customerId);
    if (customerProfile == null) {
        request.setAttribute("error", "Lỗi hệ thống: Không thể tải thông tin hạng thành viên!");
        forward to "booking.jsp";
        return;
    }
    
    try {
        // 4. Parse ngày và tính khoảng cách
        LocalDate bookingDate = LocalDate.parse(bookingDateStr);
        LocalDate today = LocalDate.now();
        long daysBetween = ChronoUnit.DAYS.between(today, bookingDate);
        
        // 5. Kiểm tra ngày quá khứ
        if (daysBetween < 0) {
            request.setAttribute("error", "Lỗi: Không thể đặt lịch trong quá khứ!");
            forward to "booking.jsp";
            return;
        }
        
        // 6. Lấy động giới hạn ngày đặt trước và validate
        int maxDaysAllowed = customerProfile.getBookingWindowDays();
        if (maxDaysAllowed <= 0) {
            maxDaysAllowed = 7; // Fallback an toàn
        }
        
        if (daysBetween > maxDaysAllowed) {
            request.setAttribute("error", "Quyền lợi Hạng " + customerProfile.getTierName() + " chỉ được đặt trước tối đa " + maxDaysAllowed + " ngày!");
            forward to "booking.jsp";
            return;
        }
        
        // 7. Gọi DAO ghi nhận đặt lịch
        int vehicleId = Integer.parseInt(vehicleIdStr);
        int serviceId = Integer.parseInt(serviceIdStr);
        double price = (serviceId == 1) ? 100000 : 1500000; // Hoặc theo dịch vụ thật
        
        boolean isSuccess = bookingDAO.createNewBooking(customerId, vehicleId, serviceId, bookingDateStr, bookingTime, price);
        if (isSuccess) {
            request.setAttribute("success", "🎉 Đặt lịch thành công! Vui lòng đến đúng giờ.");
        } else {
            request.setAttribute("error", "Lỗi hệ thống: Không thể lưu vào Database!");
        }
        
        forward to "booking.jsp";
        
    } catch (Exception e) {
        request.setAttribute("error", "Lỗi dữ liệu: Vui lòng kiểm tra lại các thông tin đã nhập!");
        forward to "booking.jsp";
    }
}
```

---

## 12. Test case sau khi code

Các trường hợp kiểm thử để nghiệm thu chức năng:

* **Test Case 1 (Hạng Member):** Đăng nhập tài khoản hạng Member (ví dụ: `ang@gmail.com`). 
  - Chọn ngày đặt lịch cách hôm nay **7 ngày** -> Hệ thống phải báo thành công.
  - Chọn ngày đặt lịch cách hôm nay **8 ngày** -> Hệ thống phải từ chối và báo lỗi chỉ được đặt tối đa 7 ngày.
* **Test Case 2 (Hạng Silver):** Đăng nhập tài khoản hạng Silver (ví dụ: `anv@gmail.com`). 
  - Chọn ngày đặt lịch cách hôm nay **10 ngày** -> Đặt lịch thành công.
  - Chọn ngày đặt lịch cách hôm nay **11 ngày** -> Hệ thống từ chối và báo lỗi tối đa 10 ngày.
* **Test Case 3 (Hạng Gold):** Đăng nhập tài khoản hạng Gold (ví dụ: `btt@gmail.com`).
  - Chọn ngày đặt lịch cách hôm nay **12 ngày** -> Đặt lịch thành công.
  - Chọn ngày đặt lịch cách hôm nay **13 ngày** -> Hệ thống từ chối và báo lỗi tối đa 12 ngày.
* **Test Case 4 (Hạng Platinum):** Đăng nhập tài khoản hạng Platinum (ví dụ: `cvl@gmail.com`).
  - Chọn ngày đặt lịch cách hôm nay **14 ngày** -> Đặt lịch thành công.
  - Chọn ngày đặt lịch cách hôm nay **15 ngày** -> Hệ thống từ chối và báo lỗi tối đa 14 ngày.
* **Test Case 5 (Chặn ngày quá khứ):** Đặt lịch vào ngày hôm qua hoặc cũ hơn -> Báo lỗi không thể đặt lịch trong quá khứ.
* **Test Case 6 (Chống sập do lỗi DB):** Đổi tạm thời `booking_window_days` trong DB của hạng Member thành `-5` hoặc `0` -> Servlet phải kích hoạt fallback an toàn cho phép đặt trước tối đa 7 ngày mà không ném ra ngoại lệ.

---

## 13. Cách kiểm tra database trước khi code

Trước khi tiến hành sửa đổi mã nguồn Java, lập trình viên cần kiểm tra xem cơ sở dữ liệu đã cập nhật đúng cấu trúc hỗ trợ cấu hình động hay chưa bằng cách thực hiện truy vấn sau:

```sql
SELECT tier_id, tier_name, booking_window_days
FROM MembershipTier;
```

**Kết quả mong muốn hiển thị trên công cụ quản lý DB (SQL Server Management Studio):**

| tier_id | tier_name | booking_window_days |
|---------|-----------|---------------------|
| 1       | Member    | 7                   |
| 2       | Silver    | 10                  |
| 3       | Gold      | 12                  |
| 4       | Platinum  | 14                  |

*Chú ý:* Nếu câu lệnh trên báo lỗi không tìm thấy cột `booking_window_days` thì chứng tỏ cơ sở dữ liệu chưa được cập nhật. Cần drop database và chạy lại script SQL mới.

---

## 14. Checklist trước khi bắt đầu code

Lập trình viên phải hoàn thành kiểm tra các mục sau trước khi thực hiện viết code:
- [ ] Cơ sở dữ liệu cũ đã được xóa hoàn toàn (DROP DATABASE).
- [ ] Đã chạy lại script [SQLAutoWash.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/SQLAutoWash.sql) để tạo cấu trúc bảng mới có cột `booking_window_days`.
- [ ] Đã chạy script seed dữ liệu [InsertValueSQL.sql](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Database/InsertValueSQL.sql) thành công.
- [ ] Truy vấn thử bảng `MembershipTier` và xác nhận thấy đầy đủ các hạng thành viên có kèm số ngày đặt lịch tương ứng.
- [ ] Trạng thái thư mục làm việc Git sạch sẽ (đã commit phần SQL hoặc diff git chỉ hiển thị các thay đổi trong file SQL).
- [ ] Hiểu rõ phạm vi của issue FR-06b, cam kết không can thiệp đến các phần nghiệp vụ khác như phân chia độ ưu tiên của hàng đợi (Priority Queue) hay hàng chờ VIP.

---

## 15. Kết luận

Việc hiện thực hóa tính năng **FR-06b Booking Window** theo hướng động là bước đi đúng đắn nhằm nâng cao tính linh hoạt của phần mềm. 

Ở bước tiếp theo, lập trình viên chỉ cần tập trung chỉnh sửa đúng 3 tệp tin: [Customer.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dto/Customer.java) (khai báo thuộc tính), [CustomerDAO.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/dao/CustomerDAO.java) (cập nhật câu query SQL JOIN) và [CreateBookingServlet.java](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/AutoWashPro-Website/src/java/controller/CreateBookingServlet.java) (thay thế switch-case bằng biến động).
