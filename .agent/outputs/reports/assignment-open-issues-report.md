# BÁO CÁO CÁC ISSUES ĐANG MỞ TRONG HAI MILESTONES ASSIGNMENT
**Dự án:** AutoWashCar (PRJ301 - Hệ thống quản lý tiệm rửa xe và khách hàng thân thiết)  
**Tác giả:** Antigravity (AI Coding Assistant)  
**Ngày lập báo cáo:** 22/06/2026  

---

## 1. Tổng quan hai Milestones Assignment

Hiện tại, hệ thống ghi nhận hai Milestone cốt lõi phục vụ cho yêu cầu bài tập lớn (Assignment) vẫn đang được mở (Open):

1. **Milestone 7: Assignment - Loyalty Engine**
   - **Mô tả:** Giai đoạn phát triển nhân tố cốt lõi của đồ án (Loyalty Program). Bao gồm: Thuật toán tự động tích điểm dựa trên chi tiêu thực tế, theo dõi tổng chi tiêu và số lượt rửa xe, tự động nâng/hạ hạng thành viên hàng tháng, đổi điểm thưởng tích lũy lấy ưu đãi và cơ chế trừ điểm hết hạn sau 12 tháng.
   - **Số lượng issue đang mở:** 5 issues.
2. **Milestone 8: Assignment - Admin Controls**
   - **Mô tả:** Giai đoạn phát triển các công cụ quản trị dành cho Admin. Bao gồm: Cấu hình luật phân hạng và tỷ lệ điểm thưởng, CRUD chương trình khuyến mãi, gửi khuyến mãi nhắm mục tiêu theo hạng thành viên, gợi ý khuyến mãi cá nhân hóa bằng AI và hiển thị các báo cáo thống kê doanh thu, khách hàng.
   - **Số lượng issue đang mở:** 4 issues.

Dưới đây là mô tả chi tiết nội dung, mục tiêu, phạm vi công việc và kết quả mong đợi của từng issue cụ thể trong hai milestone này.

---

## 2. Chi tiết các Issues thuộc Milestone 7: Loyalty Engine

Milestone này tập trung vào các logic nghiệp vụ nghiệp vụ cốt lõi ở Backend để quản lý điểm, hạng và cơ chế khách hàng thân thiết.

### Issue #41: FR-09 Point Accumulation: Hệ thống tích lũy điểm tự động và theo dõi chi tiêu
* **Độ ưu tiên:** 🔴 Cao (priority-high)
* **Kích thước công việc:** M (size-M) | **Ước lượng thời gian (Story Points):** 3
* **Nhãn (Labels):** `✨ Feature`, `⚙️ Backend`, `🗄️ Database`
* **Mô tả chi tiết:**
  * **Mục tiêu:** Tự động tích lũy điểm thưởng cho khách hàng sau khi hoàn thành hóa đơn dịch vụ, đồng thời cập nhật tổng chi tiêu (Spending) và số lượt rửa xe (Visits) để phục vụ cho việc phân hạng.
  * **Căn cứ yêu cầu:** 
    * Tài liệu [SRS.md](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Document/SRS.md) (Chức năng `FR-09 Point Accumulation`, `FR-09A Spending Tracking`, `FR-09B Visit Tracking`)
    * Yêu cầu từ giáo viên giảng dạy (Loyalty Engine - Track points, tier, spend, visits)
  * **Phạm vi công việc:**
    1. Viết logic tích điểm tự động dựa trên chi tiêu thực tế (Tỷ lệ cơ bản: 1 điểm = 1.000 VNĐ).
    2. Áp dụng hệ số cộng điểm thưởng theo hạng thành viên hiện tại của khách hàng:
       * **Silver:** Nhận thêm `+10%` điểm thưởng.
       * **Gold:** Nhận thêm `+20%` điểm thưởng.
       * **Platinum:** Nhận thêm `+30%` điểm thưởng.
    3. Cập nhật đồng thời tổng chi tiêu (`Spending`) và số lượt rửa thành công (`Visits`) trong bảng `LoyaltyAccount`.
  * **Kết quả mong đợi:** Điểm số, chi tiêu tích lũy và số lượt rửa xe được cập nhật chính xác ngay sau khi thanh toán hóa đơn thành công. Dữ liệu được ghi nhận đồng bộ ở các bảng `Customer`, `LoyaltyAccount` và `Transaction`.

---

### Issue #42: FR-10a Tier Management: Cơ chế tính toán nâng/hạ hạng thành viên
* **Độ ưu tiên:** 🔴 Cao (priority-high)
* **Kích thước công việc:** M (size-M) | **Ước lượng thời gian (Story Points):** 3
* **Nhãn (Labels):** `✨ Feature`, `⚙️ Backend`, `🗄️ Database`
* **Mô tả chi tiết:**
  * **Mục tiêu:** Xây dựng logic nghiệp vụ để tính toán nâng hoặc hạ hạng thành viên của khách hàng dựa trên chi tiêu tích lũy và số lượt rửa xe thực tế.
  * **Căn cứ yêu cầu:** 
    * Tài liệu [SRS.md](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Document/SRS.md) (Chức năng `FR-10 Tier Management`)
    * Quy tắc phân hạng thành viên (`BR-01 Membership Tier Rules`)
  * **Phạm vi công việc:**
    1. Xây dựng logic phân hạng thành viên theo quy định chi tiết:
       * **Member (Mặc định):** Đăng ký tài khoản thành công + hoàn thành tối thiểu 1 lượt rửa xe.
       * **Silver:** Số lượt rửa đạt tối thiểu 5 lần **HOẶC** tổng chi tiêu đạt 2.000.000 VNĐ.
       * **Gold:** Số lượt rửa đạt tối thiểu 15 lần **HOẶC** tổng chi tiêu đạt 6.000.000 VNĐ.
       * **Platinum:** Số lượt rửa đạt tối thiểu 30 lần **HOẶC** tổng chi tiêu đạt 15.000.000 VNĐ.
    2. Viết các câu lệnh SQL/DAO để cập nhật thông tin hạng trong bảng `LoyaltyAccount` khi đạt điều kiện.
  * **Kết quả mong đợi:** Thuật toán phân hạng hoạt động chính xác dựa trên dữ liệu chi tiêu và số lượt rửa thực tế của khách hàng. Sẵn sàng tích hợp với tiến trình cập nhật tự động định kỳ mỗi tháng.

---

### Issue #43: FR-11 Reward Redemption: Đổi điểm thưởng tích lũy lấy ưu đãi
* **Độ ưu tiên:** 🔴 Cao (priority-high)
* **Kích thước công việc:** M (size-M) | **Ước lượng thời gian (Story Points):** 3
* **Nhãn (Labels):** `✨ Feature`, `🎨 Frontend`, `⚙️ Backend`
* **Mô tả chi tiết:**
  * **Mục tiêu:** Cho phép khách hàng sử dụng số điểm tích lũy trong tài khoản của họ để đổi lấy các phần quà, mã giảm giá hoặc dịch vụ phụ trợ miễn phí.
  * **Căn cứ yêu cầu:**
    * Tài liệu [SRS.md](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Document/SRS.md) (Chức năng `FR-11 Reward Redemption` và `UC-04: Redeem Reward`)
    * Đề bài từ giáo viên (Redemption: Points -> discount, free wash)
  * **Phạm vi công việc:**
    1. Thiết kế giao diện hiển thị danh sách quà tặng, mã ưu đãi đổi thưởng có sẵn cho khách hàng.
    2. Xây dựng Servlet xử lý đổi điểm, kiểm tra số dư điểm của khách hàng xem có đủ điều kiện đổi quà hay không.
    3. Tiến hành trừ điểm tương ứng trong `LoyaltyAccount` và lưu lịch sử giao dịch đổi quà (bảng `PointTransaction`/`RedemptionHistory`).
  * **Kết quả mong đợi:** Khách hàng đổi điểm thành công và nhận được mã ưu đãi tương ứng (ví dụ: đổi 300 điểm nhận sáp wax miễn phí). Số dư điểm được cập nhật chính xác và an toàn, phòng ngừa lỗi trừ điểm âm.

---

### Issue #44: FR-12 Point Expiry: Quản lý điểm hết hạn sau 12 tháng
* **Độ ưu tiên:** 🟡 Trung bình (priority-medium)
* **Kích thước công việc:** M (size-M) | **Ước lượng thời gian (Story Points):** 3
* **Nhãn (Labels):** `✨ Feature`, `⚙️ Backend`
* **Mô tả chi tiết:**
  * **Mục tiêu:** Triển khai logic tự động hết hạn điểm thưởng sau 12 tháng kể từ thời điểm tích lũy theo đúng quy định nghiệp vụ của dự án.
  * **Căn cứ yêu cầu:**
    * Tài liệu [SRS.md](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Document/SRS.md) (Chức năng `FR-12 Point Expiry` và luật nghiệp vụ `BR-04 Point Expiration Rule`)
  * **Phạm vi công việc:**
    1. Thiết kế cơ cấu cơ sở dữ liệu (ví dụ: chi tiết giao dịch điểm `PointTransaction` có trường `created_date`) cho phép lưu trữ ngày tích lũy của từng lượng điểm số được cộng.
    2. Viết logic kiểm tra thời hạn sử dụng của từng đợt điểm tích lũy.
    3. Khấu trừ số điểm đã hết hạn (quá 12 tháng) khỏi số dư điểm khả dụng hiện tại của khách hàng.
  * **Kết quả mong đợi:** Điểm tích lũy quá hạn 12 tháng tự động bị loại bỏ chính xác mà không ảnh hưởng tới các điểm mới tích lũy khác.

---

### Issue #58: FR-10b Tier Auto-update: Thiết lập Scheduler tự động chạy quét hạng hàng tháng
* **Độ ưu tiên:** 🟡 Trung bình (priority-medium)
* **Kích thước công việc:** S (size-S) | **Ướg lượng thời gian (Story Points):** 2
* **Nhãn (Labels):** `✨ Feature`, `⚙️ Backend`
* **Mô tả chi tiết:**
  * **Mục tiêu:** Xây dựng cơ chế tự động kích hoạt tính toán và cập nhật hạng thành viên của toàn bộ khách hàng vào ngày đầu tiên của mỗi tháng.
  * **Căn cứ yêu cầu:**
    * Tài liệu [SRS.md](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Document/SRS.md) (Liên kết trực tiếp với chức năng `FR-10 Tier Management` và đề bài yêu cầu "Auto-upgrade/downgrade monthly review").
  * **Phạm vi công việc:**
    1. Tìm hiểu và triển khai bộ lập lịch (Scheduler) trong Java Web Application (sử dụng `ServletContextListener` kết hợp `ScheduledExecutorService` hoặc thư viện Quartz Scheduler).
    2. Thiết lập tiến trình chạy nền tự động kích hoạt vào lúc 00:00 ngày đầu tháng.
    3. Tiến trình nền sẽ gọi hàm tính toán phân hạng từ `FR-10a` để cập nhật trạng thái hạng của toàn bộ khách hàng.
    4. Lưu trữ lịch sử nâng/hạ hạng và ghi log hệ thống để phục vụ quản trị.
  * **Kết quả mong đợi:** Hạng thành viên của khách hàng được tự động cập nhật định kỳ hàng tháng mà không cần sự can thiệp thủ công từ Admin. Tiến trình chạy nền hoạt động an toàn, không làm rò rỉ bộ nhớ hoặc ảnh hưởng tới hiệu năng chung của hệ thống.

---

## 3. Chi tiết các Issues thuộc Milestone 8: Admin Controls

Milestone này tập trung vào giao diện quản trị, các chức năng tạo chiến dịch khuyến mãi nhắm mục tiêu và các báo cáo thống kê phục vụ việc ra quyết định của Admin.

### Issue #45: FR-13 Promotion Management: Quản lý chương trình khuyến mãi (Admin)
* **Độ ưu tiên:** 🟡 Trung bình (priority-medium)
* **Kích thước công việc:** M (size-M) | **Ước lượng thời gian (Story Points):** 3
* **Nhãn (Labels):** `✨ Feature`, `🎨 Frontend`, `⚙️ Backend`, `🗄️ Database`
* **Mô tả chi tiết:**
  * **Mục tiêu:** Cung cấp các công cụ cho phép Admin quản lý toàn diện các chương trình khuyến mãi, phục vụ việc chạy chiến dịch ưu đãi tại cửa hàng.
  * **Căn cứ yêu cầu:**
    * Tài liệu [SRS.md](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Document/SRS.md) (Chức năng `FR-13 Promotion Management` và `UC-05: Manage Promotion`)
    * Đề bài yêu cầu (Admin Controls - Configure tier rules, point rates)
  * **Phạm vi công việc:**
    1. Thiết kế trang quản trị khuyến mãi trực quan dành cho Admin (hiển thị danh sách, form điền thông tin).
    2. Viết `PromotionServlet` điều hướng yêu cầu CRUD khuyến mãi.
    3. Thực hiện lưu trữ, sửa đổi và xóa các chương trình khuyến mãi trong cơ sở dữ liệu (bảng `Promotion`).
  * **Kết quả mong đợi:** Giao diện quản trị khuyến mãi hoạt động tốt, hỗ trợ đầy đủ các thao tác Thêm, Sửa, Xóa và Xem danh sách khuyến mãi. Dữ liệu khuyến mãi được đồng bộ và lưu trữ chính xác dưới cơ sở dữ liệu.

---

### Issue #46: FR-14a Targeted Promotions: Gửi khuyến mãi nhắm mục tiêu theo hạng thành viên
* **Độ ưu tiên:** 🟡 Trung bình (priority-medium)
* **Kích thước công việc:** M (size-M) | **Ước lượng thời gian (Story Points):** 5
* **Nhãn (Labels):** `✨ Feature`, `🎨 Frontend`, `⚙️ Backend`
* **Mô tả chi tiết:**
  * **Mục tiêu:** Cho phép Admin gửi các chiến dịch khuyến mãi hoặc mã giảm giá nhắm mục tiêu cụ thể tới các phân khúc khách hàng theo hạng thành viên (Silver, Gold, Platinum).
  * **Căn cứ yêu cầu:**
    * Tài liệu [SRS.md](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Document/SRS.md) (Chức năng `FR-14a Targeted Promotions` và yêu cầu đề bài "Run targeted promos: Send to Silver+ only").
  * **Phạm vi công việc:**
    1. Tạo bộ lọc khách hàng trên giao diện khuyến mãi của Admin dựa trên hạng thành viên.
    2. Xây dựng API gửi tin khuyến mãi/mã giảm giá cho tệp khách hàng được lọc.
    3. Viết truy vấn SQL lọc danh sách khách hàng theo điều kiện hạng được Admin lựa chọn.
  * **Kết quả mong đợi:** Admin gửi khuyến mãi thành công tới đúng đối tượng khách hàng mục tiêu theo hạng. Khách hàng thuộc hạng được chọn nhận được khuyến mãi trong hòm thư/mã giảm giá cá nhân.

---

### Issue #47: FR-15 Customer Reports: Báo cáo thống kê khách hàng dành cho Admin
* **Độ ưu tiên:** 🟡 Trung bình (priority-medium)
* **Kích thước công việc:** M (size-M) | **Ước lượng thời gian (Story Points):** 3
* **Nhãn (Labels):** `✨ Feature`, `🎨 Frontend`, `⚙️ Backend`
* **Mô tả chi tiết:**
  * **Mục tiêu:** Cung cấp cho Admin một bảng điều khiển (Dashboard) trực quan báo cáo về lượng khách hàng đăng ký mới, khách hàng đang hoạt động và phân bổ tỷ lệ hạng thành viên.
  * **Căn cứ yêu cầu:**
    * Tài liệu [SRS.md](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Document/SRS.md) (Chức năng `FR-15 Customer Reports`)
    * Đề bài yêu cầu (Admin Controls - Reports)
  * **Phạm vi công việc:**
    1. Thiết kế giao diện hiển thị biểu đồ/báo cáo lượng khách hàng dành cho Admin trên Dashboard.
    2. Viết các truy vấn SQL tổng hợp số liệu khách hàng đăng ký theo thời gian và phân bổ theo hạng thành viên.
    3. Viết `CustomerReportServlet` xử lý dữ liệu và đẩy lên giao diện JSP.
  * **Kết quả mong đợi:** Báo cáo số liệu khách hàng chi tiết, trực quan trên Dashboard của Admin. Dữ liệu hiển thị chính xác theo thời gian thực hoặc theo chu kỳ báo cáo tùy chọn.

---

### Issue #48: FR-16 Revenue Reports: Báo cáo doanh thu và lịch đặt dành cho Admin
* **Độ ưu tiên:** 🟡 Trung bình (priority-medium)
* **Kích thước công việc:** M (size-M) | **Ước lượng thời gian (Story Points):** 3
* **Nhãn (Labels):** `✨ Feature`, `🎨 Frontend`, `⚙️ Backend`
* **Mô tả chi tiết:**
  * **Mục tiêu:** Cung cấp cho Admin báo cáo doanh thu tài chính từ dịch vụ rửa xe và các số liệu thống kê về tần suất, hiệu suất đặt lịch (Booking).
  * **Căn cứ yêu cầu:**
    * Tài liệu [SRS.md](file:///d:/Semester%204/PRJ301/prj301-car-wash-system/Document/SRS.md) (Chức năng `FR-16 Revenue Reports`)
    * Đề bài yêu cầu (Admin Controls - Reports)
  * **Phạm vi công việc:**
    1. Thiết kế giao diện hiển thị báo cáo tài chính doanh thu cho Admin (bảng biểu, biểu đồ).
    2. Viết các truy vấn SQL tổng hợp doanh thu từ hóa đơn thanh toán (`Transaction`) và số lượng đặt lịch (`Booking`).
    3. Viết `RevenueReportServlet` xử lý dữ liệu báo cáo và đẩy lên trang JSP.
  * **Kết quả mong đợi:** Dashboard Admin hiển thị chính xác doanh thu theo ngày, tháng, năm cũng như tỉ lệ lịch đặt thành công/bị hủy. Cung cấp cái nhìn trực quan và chính xác về hiệu suất kinh doanh của cửa hàng rửa xe.

---

## 4. Đánh giá mối tương quan và hướng đi tiếp theo

* **Loyalty Engine (Milestone 7)** đóng vai trò là "trái tim" về mặt logic dữ liệu của ứng dụng. Mọi tính năng liên quan đến tích lũy điểm (`FR-09`), nâng hạng (`FR-10a`), đổi thưởng (`FR-11`), hết hạn điểm (`FR-12`) và bộ quét tự động (`FR-10b`) cần phải được xây dựng nền tảng database vững chắc trước. Bảng `LoyaltyAccount` và bảng giao dịch điểm `PointTransaction` là các thực thể quan trọng nhất cần thiết kế.
* **Admin Controls (Milestone 8)** là lớp chức năng quản lý bên trên. Nó sử dụng dữ liệu từ Loyalty Engine để hiển thị báo cáo khách hàng (`FR-15`), báo cáo doanh thu (`FR-16`), quản lý khuyến mãi (`FR-13`) và thực hiện gửi khuyến mãi nhắm mục tiêu (`FR-14a`). 

**Khuyến nghị triển khai:**
1. Hoàn thành thiết kế DB cho Loyalty (Bảng `LoyaltyAccount`, `PointTransaction`, `Reward`, `RedemptionHistory`).
2. Implement Core Logic cho **Milestone 7** trước (`FR-09` -> `FR-10a` -> `FR-11` -> `FR-12` -> `FR-10b`).
3. Triển khai giao diện Admin và Servlet cho **Milestone 8** sau khi dữ liệu Loyalty đã sẵn sàng.
