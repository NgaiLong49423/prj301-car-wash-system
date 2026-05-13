# PRJ301 - Hệ Thống Quản Lý Rửa Xe Ô Tô Tự Động Thông Minh

## 📋 Về Dự Án

**Tên dự án (Tiếng Anh):** Smart Automated Car Wash Management System with Advance Booking & Loyalty Program  
**Tên dự án (Tiếng Việt):** Hệ thống quản lý rửa xe ô tô tự động thông minh với đặt lịch trước và chương trình khách hàng thân thiết  
**Mã môn học:** PRJ301

### 📌 Mô Tả Dự Án

AutoWash Pro là một giải pháp quản lý rửa xe hiệp chế tích hợp công nghệ AI, CRM và hệ thống đặt lịch nâng cao. 

**Bối Cảnh:**
- Với hơn 4.5 triệu xe ô tô tại Việt Nam và mức tăng trưởng nhu cầu rửa xe 25% YoY, việc giữ chân khách hàng là chìa khóa
- Khách hàng trung thành chi tiêu 67% nhiều hơn và quay lại 3 lần thường xuyên hơn
- Các hệ thống hiện tại thiếu: chương trình phần thưởng cá nhân hóa, lợi ích theo cấp bậc, theo dõi điểm kỹ thuật số

**Giải Pháp:**
- Đặt lịch trước ưu tiên theo cấp bậc
- Tương tác và cá nhân hóa do AI hỗ trợ
- Nhận dạng xe tự động (LPR - License Plate Recognition)
- Chương trình khách hàng thân thiết nhiều cấp bậc
- Dự kiến tăng tỷ lệ quay lại 45%, giá trị vòng đời tăng 60%

## 🎯 Đối Tượng Người Dùng

- **Khách hàng:** Chủ xe muốn đặt lịch tiện lợi và nhận phần thưởng
- **Admin/Quản lý:** Chủ kinh doanh phân tích hiệu suất và cấu hình các chương trình khuyến mãi

## 👥 Thành Viên Nhóm 6

| STT | MSSV | Họ và Tên |
|-----|------|----------|
| 1 | SE190095 | Nguyễn Anh Kiệt |
| 2 | SE190732 | Ngô Gia Long |
| 3 | SE190081 | Phạm Hoàng Phúc |
| 4 | SE193061 | Nguyễn Minh Trí |

---

## 💳 Chương Trình Khách Hàng Thân Thiết (Loyalty Program)

### Các Cấp Bậc Thành Viên

| Cấp Bậc | Điều Kiện | Lợi Ích |
|---------|----------|--------|
| **Member** | Đăng ký + 1 lần rửa | 1 điểm = 1,000 VND chi tiêu |
| **Silver** | 5 lần rửa hoặc 2M VND | +10% điểm, ưu tiên lịch |
| **Gold** | 15 lần rửa hoặc 6M VND | +20% điểm, nâng cấp miễn phí hàng tháng |
| **Platinum** | 30 lần rửa hoặc 15M VND | +30% điểm, rửa miễn phí hàng tháng |

### Quy Tắc Hoạt Động
- Tự động nâng cấp/hạ cấp (kiểm tra hàng tháng)
- Đổi điểm → giảm giá, rửa miễn phí (VD: 300 điểm → miễn phí làm sạch)
- Điểm hết hạn sau 12 tháng

---

## ✅ Yêu Cầu Chức Năng (Functional Requirements)

### 1. Loyalty Engine (Assignment)
- Theo dõi điểm, cấp bậc, chi tiêu, số lần ghé thăm
- Tự động nâng/hạ cấp hàng tháng
- Đổi điểm lấy ưu đãi, rửa xe miễn phí
- Điểm hết hạn sau 12 tháng

### 2. Hồ Sơ Khách Hàng (Workshop 1)
- Đăng nhập/đăng xuất + liên kết với biển số xe
- Xem: cấp bậc, số điểm, phần thưởng tiếp theo

### 3. Đặt Lịch & Lịch Sử Rửa (Workshop 2)
- **Cửa sổ đặt lịch theo cấp bậc:**
  - Member: 7 ngày
  - Silver: 10 ngày
  - Gold: 12 ngày
  - Platinum: 14 ngày
- Hàng chờ ưu tiên: Cấp bậc cao = truy cập sớm hơn

### 4. Điều Khiển Admin (Assignment)
- Cấu hình quy tắc cấp bậc, tỷ lệ điểm
- Chạy khuyến mãi có mục tiêu: "Gửi cho Silver+ only"
- Báo cáo (số lượng khách hàng, ...)

---

## ⚡ Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

| Mã | Yêu Cầu | Tiêu Chí |
|----|---------|---------| 
| NFR-01 | Response Time | Phản hồi ≤ 5 giây cho 95% yêu cầu |
| NFR-02 | Booking Processing | Giao dịch đặt lịch ≤ 5 giây, bao gồm tính toán loyalty |
| NFR-03 | Concurrent Users | Hỗ trợ ≥ 500 người dùng cùng lúc |
| NFR-04 | LPR Processing | Nhận dạng biển số ≤ 10 giây |
| NFR-05 | System Availability | Uptime 99.5% (không tính bảo trì) |
| NFR-06 | Data Backup | Sao lưu hàng ngày, RTO ≤ 2 giờ |

---

## 📦 Sản Phẩm Dự Kiến

- 🌐 **Web App cho Admin:** Quản lý hệ thống, cấu hình, báo cáo
- 📱 **Mobile App cho Khách Hàng:** Đặt lịch, xem điểm, quản lý thông tin cá nhân

---

## 🎬 Quy Trình Demo

1. Khách tạo tài khoản để trở thành khách hàng
2. Khách hàng đặt lịch với tư cách thành viên Gold → nhận lịch ưu tiên
3. Khách hàng xem điểm, phần thưởng của mình
4. Admin thiết lập chương trình khuyến mãi và xem báo cáo hệ thống

---

## 🛠️ Công Nghệ Sử Dụng

**Frontend:**
- HTML5, CSS3, JavaScript

**Backend:**
- **Java Servlet & JSP** (Pure)
- **IDE:** NetBeans
- **Java Version:** JDK 8
- **Server:** Apache Tomcat 9

**Database:**
- **SQL Server** (Quản lý dữ liệu khách hàng, điểm, cấp bậc, lịch sử rửa)

**Công Nghệ Bổ Sung:**
- License Plate Recognition (LPR) - Nhận dạng tự động biển số xe
- AI Personalization - Cá nhân hóa trải nghiệm khách hàng
- CRM Technology - Quản lý mối quan hệ khách hàng

---

## 📋 Yêu Cầu Hệ Thống

- **Java Development Kit (JDK):** Version 8 trở lên
- **NetBeans:** Version 8.0 hoặc cao hơn
- **Apache Tomcat:** Version 9
- **SQL Server:** 2016 trở lên
- **Trình duyệt:** Chrome, Firefox, Edge (phiên bản mới nhất)

---

## 🚀 Cách Chạy Dự Án

### Thiết Lập Ban Đầu

1. **Cấu hình Database:**
   - Mở SQL Server Management Studio
   - Chạy các script trong `src/resources/database/` để tạo database và tables
   - Cấu hình connection string trong code

2. **Cấu hình Tomcat:**
   - Tải Apache Tomcat 9
   - Cấu hình trong NetBeans: **Tools** → **Servers** → **Add Server** → **Apache Tomcat 9**

3. **Build & Run:**

### Trong NetBeans:
1. Mở NetBeans
2. **File** → **Open Project** → Chọn thư mục dự án `PRJ301`
3. Chọn **Run Project** hoặc nhấn `F6`
4. Ứng dụng sẽ mở tại `http://localhost:8080/PRJ301` (hoặc port được cấu hình)

### Từ Command Line:
```bash
# Biên dịch
javac -d build/classes src/java/**/*.java

# Build WAR file
jar cvf PRJ301.war -C build/classes .

# Deploy lên Tomcat
cp PRJ301.war $TOMCAT_HOME/webapps/
```

---

## 📁 Cấu Trúc Dự Án

```
PRJ301/
├── src/
│   ├── java/
│   │   ├── servlets/              # Servlet xử lý request
│   │   ├── models/                # Model/Entity classes
│   │   ├── daos/                  # Database Access Objects
│   │   ├── utils/                 # Utility classes
│   │   └── filters/               # Authentication filters
│   └── resources/
│       └── database/              # SQL scripts
├── web/
│   ├── index.jsp                  # Trang chủ
│   ├── admin/                     # Pages cho Admin
│   │   ├── dashboard.jsp
│   │   ├── loyalty-config.jsp
│   │   └── reports.jsp
│   ├── customer/                  # Pages cho Customer
│   │   ├── profile.jsp
│   │   ├── booking.jsp
│   │   └── rewards.jsp
│   ├── css/                       # Stylesheet
│   ├── js/                        # JavaScript files
│   ├── images/                    # Hình ảnh
│   └── WEB-INF/
│       └── web.xml                # Deployment descriptor
├── build/
├── dist/
├── .gitignore
└── README.md
```

---

## 📝 Ghi Chú & Quy Tắc Phát Triển

- **Commit thường xuyên** với message rõ ràng, mô tả công việc hoàn thành
- **Không commit** các file trong `/build/`, `/dist/`, `/target/`, `/nbproject/private/`
- **Naming Convention:**
  - Java: `camelCase` (VD: `getLoyaltyPoints()`)
  - CSS/JS: `kebab-case` (VD: `customer-profile.css`)
  - Classes: `PascalCase` (VD: `CustomerService`)

---

## 📚 Tài Liệu & Quy Trình Phát Triển

### SDLC (Software Development Life Cycle)
- ✅ **SRS (Software Requirements Specification)** - Yêu cầu hệ thống
- ✅ **Design** - Thiết kế hệ thống & database
- ✅ **Code** - Phát triển code
- ✅ **Testing** - Kiểm thử chức năng
- ✅ **Deployment** - Triển khai lên server

### Tài Liệu Cần Chuẩn Bị
- Tài liệu phân tích yêu cầu (SRS)
- Sơ đồ thiết kế hệ thống
- Database schema & ERD
- Test cases & kết quả testing
- Hướng dẫn sử dụng cho Admin & Customer

---

## 🧪 Testing

- Mỗi thành viên kiểm thử module của mình
- Test cases phải được tài liệu hóa
- Báo cáo bug và fix kịp thời

---

## 📞 Liên Hệ & Deadline

- Nộp bài theo deadline trên LMS
- Vấn đáp với giáo viên (viva) theo lịch hẹn
- Nếu có câu hỏi, vui lòng liên hệ các thành viên trong nhóm hoặc giáo viên hướng dẫn

---

## ⚠️ Lưu Ý Quan Trọng

- **Tất cả thành viên phải hiểu rõ toàn bộ dự án** - Có thể cần giải thích cho viva committee
- Mỗi nhóm nên có nhiều thành viên tham gia, nhưng có một thành viên chịu trách nhiệm chính mỗi module
- Chuẩn bị kỹ lưỡng tài liệu tham khảo để giải thích cho viva

---

**Ngày tạo:** May 2026  
**Lớp:** PRJ301  
**Tên Dự Án:** AutoWash Pro - Smart Automated Car Wash Management System
