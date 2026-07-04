# Software Requirements Specification (SRS)
# AutoWashPro Assessment — Advance Booking & Loyalty Program

## Thông tin tài liệu

| Thuộc tính | Giá trị |
|---|---|
| Tên tài liệu | Software Requirements Specification (SRS) |
| Tên hệ thống | AutoWashPro / Luxe Wash |
| Phạm vi | PRJ301 Assessment — Advance Booking & Loyalty Program |
| Phiên bản | v0.2.0 |
| Ngày tạo | 2026-07-04 |
| Sửa đổi gần nhất | 2026-07-04 |
| Ngôn ngữ | Tiếng Việt |
| Trạng thái | Draft dùng để code và review |
| Người soạn | Ngô Gia Long — SE190732 |

## Lịch sử phiên bản

| Phiên bản | Ngày | Người/nguồn cập nhật | Mô tả thay đổi |
|---|---|---|---|
| v0.1.0 | 2026-07-04 | Phân rã nghiệp vụ Assessment | Xác định scope Loyalty Engine, Admin Controls, Reward, Voucher, Promotion, Reports |
| v0.1.1 | 2026-07-04 | Rà soát database | Chuẩn hóa database còn 15 bảng chính, loại bỏ AI/LPR/Payment/Feedback/QueueLog khỏi scope chính |
| v0.1.2 | 2026-07-04 | Phân rã UI/UX Admin | Chốt Admin UI gồm 6 trang JSP chính và component dùng chung |
| v0.2.0 | 2026-07-04 | Chuẩn hóa SRS | Viết lại theo kiểu tài liệu giải thích thuần SRS, không trình bày theo GitHub Issue |

---

## 1. Giới thiệu

### 1.1 Mục đích tài liệu

Tài liệu này mô tả chi tiết các yêu cầu phần mềm cho phần **Assessment** của dự án **AutoWashPro / Luxe Wash**. Hệ thống là một web application quản lý đặt lịch rửa xe kết hợp chương trình khách hàng thân thiết. Tài liệu tập trung vào các nghiệp vụ cần hoàn thiện để app có thể demo thành công theo yêu cầu môn PRJ301.

Mục tiêu của tài liệu không phải là hướng dẫn code từng class, từng servlet hoặc từng câu SQL. Tài liệu giải thích hệ thống phải làm được gì, vì sao cần làm, dữ liệu nào phải có, giao diện cần hiển thị gì và khi kiểm thử thì kết quả đúng phải ra sao. Thành viên trong nhóm có thể đọc tài liệu này để hiểu app, sau đó triển khai code theo khả năng của mình.

Tài liệu cũng được viết đủ chi tiết để các công cụ/agent nội bộ có thể đọc SRS và tự phân rã thành GitHub Issues, Pull Requests hoặc checklist kiểm thử. Tuy nhiên, bản thân tài liệu này không trình bày theo dạng danh sách issue.

### 1.2 Phạm vi hệ thống

Phần Assessment hiện tại tập trung vào các nhóm chức năng chính sau:

- Chương trình khách hàng thân thiết (**Loyalty Engine**).
- Theo dõi điểm, hạng, chi tiêu và số lượt rửa xe.
- Cộng điểm khi booking hoàn tất.
- Xét lại hạng thành viên dựa trên dữ liệu 12 tháng gần nhất.
- Điểm hết hạn sau một khoảng thời gian cấu hình được, mặc định theo đề là 12 tháng.
- Đổi điểm thành voucher/reward.
- Sử dụng voucher trong booking sau.
- Admin cấu hình tier, reward, loyalty settings, promotion và xem reports.
- Admin UI riêng gồm 6 trang JSP chính.
- Phân quyền cơ bản giữa Admin và Customer.
- Guest ở mức tối thiểu: người chưa đăng nhập có thể vào Login/Register để đăng ký thành Customer.

Hệ thống chạy theo mô hình Java Servlet/JSP MVC2, sử dụng SQL Server làm cơ sở dữ liệu. Các JSP chỉ chịu trách nhiệm hiển thị; dữ liệu nghiệp vụ phải được lấy từ database thông qua Servlet/DAO hoặc tầng xử lý tương đương.

### 1.3 Đối tượng sử dụng tài liệu

- **Sinh viên trong nhóm** dùng để hiểu app phải hoàn thành những chức năng nào.
- **Người code backend/frontend** dùng để biết màn hình nào cần dữ liệu nào và rule nào không được vi phạm.
- **Người tạo issue/agent** dùng để phân rã tài liệu thành GitHub Issues.
- **Người review PR** dùng để kiểm tra code có bám đúng yêu cầu hay không.
- **Giảng viên/vấn đáp** dùng để kiểm tra sinh viên có hiểu nghiệp vụ, dữ liệu và luồng xử lý hay không.

### 1.4 Thuật ngữ và định nghĩa

| Thuật ngữ | Ý nghĩa |
|---|---|
| Customer | Khách hàng sử dụng dịch vụ rửa xe |
| Admin | Người quản trị hệ thống, đại diện chủ tiệm hoặc manager |
| Guest | Người chưa đăng nhập; hiện tại chỉ cần truy cập Login/Register |
| Booking | Lịch đặt rửa xe của Customer |
| Completed Booking | Booking đã hoàn tất dịch vụ, được phép ghi nhận điểm loyalty |
| Loyalty | Chương trình khách hàng thân thiết gồm điểm, hạng, reward và voucher |
| Tier | Hạng thành viên: Member, Silver, Gold, Platinum |
| Active data | Dữ liệu loyalty còn hiệu lực trong 12 tháng gần nhất, dùng để xét hạng và đổi điểm |
| Lifetime data | Dữ liệu tích lũy toàn bộ lịch sử, dùng cho report kinh doanh |
| Point Batch | Một đợt điểm được cộng từ một booking hoặc nghiệp vụ hợp lệ, có ngày hết hạn riêng |
| Loyalty Transaction | Lịch sử biến động điểm, ví dụ EARNED, REDEEMED, EXPIRED |
| Reward | Phần thưởng có thể đổi bằng điểm, ví dụ giảm giá, miễn phí dịch vụ, free wash |
| Redemption / Voucher | Voucher sinh ra sau khi Customer đổi điểm lấy reward |
| Promotion | Chương trình khuyến mãi do Admin tạo và gửi đến Customer phù hợp |
| DB-driven | Dữ liệu nghiệp vụ và dữ liệu hiển thị phải lấy từ database, không hardcode trong Java/JSP/Servlet |
| Hardcode | Ghi cố định giá trị nghiệp vụ trong code hoặc JSP thay vì lấy từ database |
| JSP | Trang giao diện hiển thị dữ liệu cho người dùng |
| Servlet/Controller | Thành phần xử lý request, lấy dữ liệu từ DAO/database rồi forward sang JSP |

### 1.5 Tài liệu tham khảo

- Đề bài PRJ301: **Smart Automated Car Wash Management System with Advance Booking & Loyalty Program**.
- Source code baseline hiện tại của nhóm: `prj301-car-wash-system`.
- Database canonical hiện tại: `schema.sql` và `sample-data.sql`.
- UI/UX Admin prototype hiện tại: `luxe-wash-admin-ui-ux.zip`.
- Quy ước nội bộ: tất cả business data và displayed values phải lấy từ database.

---

## 2. Mô tả tổng quan

### 2.1 Bối cảnh hệ thống

Một tiệm rửa xe muốn giữ chân khách hàng bằng chương trình thành viên. Khách hàng đặt lịch rửa xe, sử dụng dịch vụ, tích lũy điểm và được nâng hạng nếu chi tiêu hoặc số lượt rửa đạt điều kiện. Hạng càng cao thì khách càng có nhiều quyền lợi như nhân điểm, đặt lịch xa hơn hoặc được ưu tiên khi đặt chỗ.

Trong phần Assessment, trọng tâm không phải là xây dựng toàn bộ hệ sinh thái AI, mobile app hay nhận diện biển số tự động. Trọng tâm là chứng minh web app có thể quản lý được booking, loyalty, reward, promotion và report theo cách có dữ liệu thật trong database.

### 2.2 Mục tiêu hệ thống

Hệ thống cần đạt các mục tiêu sau:

- Customer có thể đăng nhập, xem thông tin cá nhân, đặt lịch, xem lịch sử, xem điểm và hạng hiện tại.
- Khi một booking hoàn tất, hệ thống tự động cộng điểm, cập nhật chi tiêu, số lượt rửa và xét lại hạng.
- Customer có thể đổi điểm còn hiệu lực thành voucher/reward.
- Customer có thể dùng voucher trong booking sau.
- Admin có thể cấu hình tier, reward, loyalty settings, promotion và xem báo cáo.
- Report phải phản ánh dữ liệu thật từ database, không phải số giả hardcode trong JSP.
- Toàn bộ rule quan trọng như point rate, point expiry, tier threshold, booking window, reward cost, promotion target phải được lấy từ database.

### 2.3 Kiểu ứng dụng

Ứng dụng là **Java Servlet/JSP web application**. Hệ thống sử dụng mô hình MVC2:

- Servlet/Controller nhận request.
- DAO hoặc tầng truy cập dữ liệu lấy dữ liệu từ SQL Server.
- Servlet đặt dữ liệu vào request/session attribute.
- JSP hiển thị dữ liệu.
- JSP không tự chứa logic nghiệp vụ phức tạp.

### 2.4 Nhóm người dùng

Hệ thống có 3 nhóm người dùng ở mức nghiệp vụ:

1. **Guest**: Người chưa đăng nhập. Trong scope chính hiện tại, Guest chỉ cần truy cập Login/Register để đăng ký tài khoản Customer. Các trang public nâng cao sẽ để sau.
2. **Customer**: Khách hàng đã đăng nhập. Customer có thể đặt lịch, xem điểm, xem hạng, đổi reward, xem voucher, xem promotion cá nhân và xem lịch sử của chính mình.
3. **Admin**: Người quản trị. Admin có thể quản lý cấu hình loyalty, tier, reward, promotion và xem báo cáo hệ thống.

### 2.5 Actor và quyền theo vai trò

| Chức năng / Hành vi | Guest | Customer | Admin |
|---|:---:|:---:|:---:|
| Truy cập Login/Register | Có | Có | Có |
| Đăng ký tài khoản Customer | Có | Không cần | Không cần |
| Xem dashboard cá nhân | Không | Có | Không |
| Đặt booking | Không | Có | Có thể xem/quản lý nếu module Admin hỗ trợ |
| Xem booking history cá nhân | Không | Có | Có thể xem report |
| Xem loyalty points/tier | Không | Có | Có thể xem report |
| Đổi reward bằng điểm | Không | Có | Không |
| Xem voucher cá nhân | Không | Có | Có thể xem report |
| Xem promotion cá nhân | Không | Có | Có thể xem report/delivery |
| Quản lý tier | Không | Không | Có |
| Quản lý reward | Không | Không | Có |
| Quản lý loyalty settings | Không | Không | Có |
| Quản lý promotion | Không | Không | Có |
| Xem report | Không | Không | Có |

### 2.6 Danh sách Use Case tổng quan

| Mã UC | Tên Use Case | Actor chính |
|---|---|---|
| UC-AS-01 | Đăng ký tài khoản Customer | Guest |
| UC-AS-02 | Đăng nhập/đăng xuất | Customer, Admin |
| UC-AS-03 | Xem thông tin loyalty cá nhân | Customer |
| UC-AS-04 | Đặt booking | Customer |
| UC-AS-05 | Hoàn tất booking và cộng điểm | Hệ thống/Admin workflow |
| UC-AS-06 | Xem lịch sử điểm và booking | Customer |
| UC-AS-07 | Đổi điểm lấy voucher | Customer |
| UC-AS-08 | Dùng voucher khi booking | Customer |
| UC-AS-09 | Admin quản lý tier | Admin |
| UC-AS-10 | Admin quản lý reward | Admin |
| UC-AS-11 | Admin quản lý loyalty settings | Admin |
| UC-AS-12 | Admin tạo và gửi promotion | Admin |
| UC-AS-13 | Customer xem promotion được gửi | Customer |
| UC-AS-14 | Admin xem reports | Admin |
| UC-AS-15 | Chạy demo Assessment end-to-end | Customer, Admin |

### 2.7 Giả định và ràng buộc

- Hệ thống dùng SQL Server, không dùng file text cho phần Assessment web app.
- Nhóm chỉ duy trì 2 file database chính: `schema.sql` và `sample-data.sql`.
- Các bảng không thuộc scope chính như AIRecommendation, LPRLog, Payment, Feedback, BookingQueueLog không được đưa vào luồng Assessment hiện tại.
- Customer JSP hiện tại đã có nền, không bắt buộc làm lại Guest public UI trong scope chính.
- Admin UI dùng 6 JSP chính đã được chốt.
- Mật khẩu trong sample data có thể tạm đơn giản để demo, nhưng tài liệu vẫn ghi nhận yêu cầu bảo mật ở mức triển khai thực tế.
- Các giá trị business như số ngày hết hạn điểm, tỷ lệ điểm, điều kiện tier, reward cost và promotion target phải đến từ database.

### 2.8 Chức năng nằm trong phạm vi

- Đăng ký/đăng nhập cơ bản.
- Role-based access giữa Admin và Customer.
- Customer loyalty dashboard.
- Booking completed earns loyalty points.
- Active 12-month loyalty data và lifetime data.
- Tier review theo active spend hoặc active visits.
- Point expiry theo từng batch.
- Reward catalog từ database.
- Redeem points thành voucher.
- Apply voucher to booking.
- Admin dashboard, tier management, reward management, loyalty settings, promotion management, report dashboard.
- Promotion gửi theo target ALL hoặc TIER.
- Reports: Customer Loyalty, Booking & Revenue, Reward Redemption, Promotion Delivery.
- Seed data đủ để demo end-to-end.

### 2.9 Chức năng ngoài phạm vi chính hiện tại

Các phần sau không thuộc scope chính của Assessment hiện tại và chỉ nên để Future/Backlog nếu còn thời gian:

- Guest public marketing pages đầy đủ.
- AI recommendation hoặc AI personalization.
- LPR automation / nhận diện biển số tự động.
- Payment gateway thực tế.
- Feedback module.
- Mobile app.
- Email/SMS promotion.
- Admin audit log nâng cao.
- Dashboard biểu đồ phức tạp.

---

## 3. Quy tắc nghiệp vụ

### 3.1 Quy tắc dữ liệu phải lấy từ database

Tất cả dữ liệu nghiệp vụ và dữ liệu hiển thị có ý nghĩa kinh doanh phải lấy từ database. Không được hardcode trong Java, JSP, Servlet hoặc JavaScript.

Các dữ liệu bắt buộc phải DB-driven gồm:

- Tên hạng thành viên.
- Điều kiện lên hạng.
- Số ngày booking window theo hạng.
- Point rate và point multiplier.
- Quyền lợi hạng thành viên.
- Số tháng hết hạn điểm.
- Danh sách dịch vụ.
- Giá dịch vụ.
- Danh sách reward.
- Required points của reward.
- Reward type và reward value.
- Voucher validity days.
- Promotion title, value, target và status.
- Report numbers.
- Status hiển thị nếu có mapping label.

JSP có thể dùng dữ liệu mẫu trong giai đoạn UI prototype, nhưng khi đưa vào code thật thì phải thay bằng dữ liệu từ request attribute do Servlet cung cấp.

### 3.2 Quy tắc phân quyền

Hệ thống chỉ cần 2 role chính trong scope code hiện tại:

- `CUSTOMER`
- `ADMIN`

Guest không cần role trong database. Guest là trạng thái chưa đăng nhập.

Các URL hoặc màn hình bắt đầu bằng `/admin/*` chỉ được truy cập bởi user có role `ADMIN`. Customer hoặc người chưa đăng nhập không được vào Admin page. Nếu chưa đăng nhập thì chuyển về Login. Nếu đã đăng nhập nhưng không phải Admin thì hiển thị lỗi quyền hoặc chuyển về trang phù hợp.

### 3.3 Quy tắc Guest

Guest trong scope hiện tại chỉ cần truy cập Login/Register. Guest public pages mở rộng để sau.

Guest không được:

- Đặt booking.
- Xem điểm.
- Xem hạng.
- Đổi reward.
- Xem voucher.
- Xem promotion cá nhân.
- Xem booking history.
- Vào Admin UI.

Guest có thể đăng ký tài khoản để trở thành Customer.

### 3.4 Quy tắc booking status

Booking phải dùng status chuẩn:

| Status | Ý nghĩa |
|---|---|
| `PENDING` | Booking mới tạo/chờ xác nhận |
| `CONFIRMED` | Booking đã được xác nhận |
| `COMPLETED` | Booking đã hoàn tất dịch vụ |
| `CANCELLED` | Booking đã bị hủy |

Chỉ booking có trạng thái `COMPLETED` mới được tạo loyalty points. Booking `PENDING`, `CONFIRMED` hoặc `CANCELLED` không được cộng điểm.

### 3.5 Quy tắc giá trị booking

Mỗi booking cần lưu rõ:

- `original_amount`: tổng tiền trước khi giảm.
- `discount_amount`: tổng số tiền được giảm bởi voucher/reward/promotion nếu có.
- `final_amount`: số tiền cuối cùng sau giảm.

Điểm loyalty khi booking completed phải tính theo `final_amount`, không tính theo `original_amount`.

### 3.6 Quy tắc cộng điểm khi booking completed

Khi một booking chuyển sang `COMPLETED`, hệ thống phải kiểm tra booking đó đã được cộng loyalty hay chưa.

Nếu booking đã được cộng loyalty trước đó thì không cộng lại. Nếu chưa cộng, hệ thống tính điểm dựa trên `final_amount`, point rate và point multiplier từ database. Sau đó hệ thống ghi nhận điểm, tạo lịch sử điểm và cập nhật dữ liệu loyalty của Customer.

Mỗi booking chỉ được phát sinh transaction `EARNED` tối đa một lần.

### 3.7 Quy tắc active data và lifetime data

Hệ thống phải tách hai nhóm dữ liệu loyalty:

1. **Lifetime data** dùng cho báo cáo tổng thể:
   - `lifetime_spent_money`
   - `lifetime_visit_count`

2. **Active 12-month data** dùng cho điểm hiện tại, quyền lợi và xét hạng:
   - `active_points`
   - `active_spent_money_12m`
   - `active_visit_count_12m`
   - `tier_id`

Customer có thể từng chi tiêu rất nhiều trong lịch sử, nhưng hạng hiện tại phải dựa trên dữ liệu còn hiệu lực trong khoảng thời gian loyalty hiện hành.

### 3.8 Quy tắc xét hạng thành viên

Hệ thống có 4 hạng thành viên:

- Member
- Silver
- Gold
- Platinum

Tier review dùng `active_spent_money_12m` hoặc `active_visit_count_12m`, không dùng `active_points`. Customer được gán hạng cao nhất mà họ đạt điều kiện.

Ví dụ: nếu Customer đạt điều kiện Gold theo số tiền hoặc số lượt rửa thì hệ thống phải gán Gold, không dừng ở Silver.

Điều kiện tier phải lấy từ bảng `MembershipTier`, không hardcode trong code.

### 3.9 Quy tắc point expiry

Điểm loyalty hết hạn theo từng đợt điểm (**Point Batch**). Mỗi batch có:

- số điểm được cộng ban đầu;
- số điểm còn lại;
- ngày được cộng;
- ngày hết hạn;
- trạng thái.

Điểm hết hạn không được dùng để redeem reward. Khi một batch hết hạn, chỉ phần `remaining_points` còn lại của batch đó bị hết hạn. Nếu batch đã dùng hết trước đó thì không còn gì để expire.

Số tháng hết hạn điểm phải lấy từ `LoyaltyConfig`, không hardcode.

### 3.10 Quy tắc redeem reward

Customer chỉ được redeem reward bằng điểm còn hiệu lực. Trước khi redeem, hệ thống phải refresh điểm active để loại bỏ điểm đã hết hạn.

Khi redeem thành công:

- Hệ thống trừ điểm theo FIFO: dùng điểm cũ còn hiệu lực trước.
- Hệ thống tạo `Redemption` với status `AVAILABLE`.
- Hệ thống tạo transaction `REDEEMED` để ghi nhận điểm đã dùng.
- Customer có thể xem voucher trong danh sách voucher cá nhân.

Reward phải lấy từ database. JSP không được hardcode danh sách reward.

### 3.11 Quy tắc voucher lifecycle

Voucher/Redemption dùng status chuẩn:

| Status | Ý nghĩa |
|---|---|
| `AVAILABLE` | Có thể dùng |
| `USED` | Đã dùng cho booking |
| `EXPIRED` | Đã hết hạn |
| `CANCELLED` | Bị hủy |

Chỉ voucher `AVAILABLE` của chính Customer mới được dùng trong booking. Mỗi booking chỉ được dùng tối đa một voucher. Mỗi voucher chỉ được gắn với tối đa một booking.

Khi booking có voucher được completed, voucher chuyển sang `USED`. Nếu booking bị cancel trước completion, voucher có thể được trả về `AVAILABLE` nếu chưa dùng thật.

### 3.12 Quy tắc reward type

Reward phải hỗ trợ các loại sau:

| Reward Type | Ý nghĩa |
|---|---|
| `FIXED_DISCOUNT` | Giảm một số tiền cố định |
| `PERCENT_DISCOUNT` | Giảm theo phần trăm |
| `FREE_SERVICE` | Miễn phí một dịch vụ cụ thể |
| `FREE_WASH` | Miễn phí gói rửa xe chính |

Giá trị reward và dịch vụ mục tiêu phải lấy từ database.

### 3.13 Quy tắc promotion

Admin có thể tạo promotion và gửi đến Customer theo target.

Promotion có `target_type`:

- `ALL`: gửi cho tất cả Customer.
- `TIER`: gửi cho Customer thuộc một tier cụ thể.

Nếu `target_type = ALL`, `target_tier_id` phải rỗng. Nếu `target_type = TIER`, `target_tier_id` phải có giá trị hợp lệ.

Promotion không gửi qua email/SMS trong scope hiện tại. Promotion được gửi bằng cách tạo bản ghi trong `CustomerPromotion`, đóng vai trò inbox promotion trong web app.

### 3.14 Quy tắc promotion status

Promotion dùng status chuẩn:

| Status | Ý nghĩa |
|---|---|
| `DRAFT` | Chưa kích hoạt |
| `ACTIVE` | Đang hoạt động |
| `EXPIRED` | Đã hết hạn |
| `INACTIVE` | Bị tắt thủ công |

Customer chỉ thấy promotion phù hợp, còn hiệu lực và đã được gửi cho họ.

### 3.15 Quy tắc report

Report phải lấy dữ liệu từ database, không hardcode số liệu trong JSP.

Hệ thống cần có các nhóm report:

- Customer Loyalty Report.
- Booking & Revenue Report.
- Reward Redemption Report.
- Promotion Delivery Report.

Revenue report chỉ nên tính từ booking `COMPLETED`, không tính booking `PENDING`, `CONFIRMED` hoặc `CANCELLED`.

### 3.16 Quy tắc Admin UI

Admin UI phải tách riêng khỏi Customer UI. Không nhét toàn bộ Admin UI vào Customer JSP bằng `if role == ADMIN`.

Admin module gồm 6 JSP chính:

- `admin-dashboard.jsp`
- `tier-management.jsp`
- `reward-management.jsp`
- `loyalty-settings.jsp`
- `promotion-management.jsp`
- `report-dashboard.jsp`

Có thể dùng JSP fragments chung:

- `admin-head.jspf`
- `admin-shell-start.jspf`
- `admin-shell-end.jspf`

Các fragment chỉ phục vụ layout, không được chứa dữ liệu nghiệp vụ hardcode.

---

## 4. Mô hình dữ liệu ở mức nghiệp vụ

### 4.1 Danh sách bảng chính

Database Assessment hiện tại dùng 15 bảng chính:

| Bảng | Vai trò nghiệp vụ |
|---|---|
| `LoyaltyConfig` | Lưu cấu hình chung của loyalty |
| `MembershipTier` | Lưu hạng thành viên và rule của từng hạng |
| `Customer` | Lưu tài khoản, role và dữ liệu loyalty tổng hợp |
| `Vehicle` | Lưu xe của Customer |
| `Service` | Lưu dịch vụ rửa xe |
| `Booking` | Lưu lịch đặt rửa xe |
| `BookingService` | Lưu các dịch vụ trong một booking |
| `BookingSlot` | Lưu slot đặt lịch theo ngày/giờ |
| `BookingPriorityAllocation` | Lưu phân bổ ưu tiên booking theo tier/shift |
| `Reward` | Lưu danh mục reward đổi bằng điểm |
| `Redemption` | Lưu voucher sinh ra khi Customer redeem reward |
| `LoyaltyPointBatch` | Lưu từng đợt điểm được cộng và ngày hết hạn |
| `LoyaltyTransaction` | Lưu lịch sử biến động điểm |
| `Promotion` | Lưu chương trình khuyến mãi |
| `CustomerPromotion` | Lưu promotion đã gửi đến từng Customer |

### 4.2 LoyaltyConfig

`LoyaltyConfig` lưu các cấu hình chung của chương trình loyalty. Ví dụ cấu hình số tháng hết hạn điểm hoặc thời hạn mặc định của voucher. Bảng này tồn tại để tránh hardcode rule trong code.

Dữ liệu quan trọng:

- `point_expiry_months`
- `point_rate_amount`
- `default_voucher_valid_days`
- `loyalty_status`

### 4.3 MembershipTier

`MembershipTier` lưu rule của từng hạng thành viên.

Dữ liệu quan trọng:

- `tier_name`
- `tier_order`
- `min_spent_money`
- `min_visit_count`
- `point_rate`
- `point_multiplier`
- `booking_window_days`
- `priority_score`
- `benefits`
- `is_active`

Tất cả trang Customer và Admin khi hiển thị tier đều phải lấy từ bảng này.

### 4.4 Customer

`Customer` lưu thông tin tài khoản và dữ liệu loyalty tổng hợp của khách hàng.

Dữ liệu quan trọng:

- thông tin cá nhân: tên, phone, email;
- role: ADMIN hoặc CUSTOMER;
- lifetime data;
- active 12-month data;
- tier hiện tại.

Customer chỉ được xem dữ liệu của chính mình, trừ Admin report.

### 4.5 Vehicle

`Vehicle` lưu xe của Customer. Booking phải gắn với một xe hợp lệ của Customer.

Dữ liệu quan trọng:

- `license_plate`
- `brand`
- `model`
- `color`
- `customer_id`

### 4.6 Service

`Service` lưu các dịch vụ rửa xe. Booking và reward loại `FREE_SERVICE` hoặc `FREE_WASH` cần dùng dữ liệu từ bảng này.

Dữ liệu quan trọng:

- `service_name`
- `price`
- `duration`
- `is_wash_service`
- `is_active`

### 4.7 Booking và BookingService

`Booking` lưu thông tin lịch đặt. `BookingService` lưu các dịch vụ được chọn trong booking.

Booking là nguồn chính để phát sinh doanh thu, lượt rửa và điểm loyalty. Chỉ booking `COMPLETED` mới được tính vào loyalty.

Dữ liệu quan trọng:

- `status`
- `original_amount`
- `discount_amount`
- `final_amount`
- `applied_redemption_id`
- `loyalty_points_awarded`
- `loyalty_awarded_at`

### 4.8 BookingSlot và BookingPriorityAllocation

Hai bảng này phục vụ đặt lịch theo slot và ưu tiên theo hạng. Phần này hỗ trợ yêu cầu đặt lịch trước và ưu tiên khách hạng cao.

Nếu nhóm chưa đủ thời gian làm logic rất phức tạp, vẫn phải giữ dữ liệu đủ rõ để demo được booking theo tier và không phá phần loyalty.

### 4.9 Reward

`Reward` lưu danh mục phần thưởng đổi bằng điểm. Customer không được thấy reward inactive.

Dữ liệu quan trọng:

- `reward_name`
- `required_points`
- `reward_type`
- `reward_value`
- `target_service_id`
- `valid_days`
- `is_active`

### 4.10 Redemption

`Redemption` là voucher cụ thể của Customer sau khi đổi điểm. Reward là mẫu quà; Redemption là voucher đã đổi ra thuộc về một Customer.

Dữ liệu quan trọng:

- `customer_id`
- `reward_id`
- `points_used`
- `valid_until`
- `status`
- `applied_booking_id`
- `used_at`

### 4.11 LoyaltyPointBatch

`LoyaltyPointBatch` dùng để xử lý điểm hết hạn và FIFO khi redeem. Mỗi lần booking completed tạo điểm thì tạo batch mới.

Dữ liệu quan trọng:

- `earned_points`
- `remaining_points`
- `earned_at`
- `expires_at`
- `status`

### 4.12 LoyaltyTransaction

`LoyaltyTransaction` lưu lịch sử biến động điểm. Customer có thể xem lịch sử điểm, Admin có thể dùng cho report.

Transaction types:

- `EARNED`
- `REDEEMED`
- `EXPIRED`
- `ADJUSTED`

### 4.13 Promotion và CustomerPromotion

`Promotion` lưu chương trình khuyến mãi do Admin tạo. `CustomerPromotion` lưu promotion đã gửi đến Customer nào.

Promotion chỉ thật sự đến với Customer khi có bản ghi trong `CustomerPromotion`.

---

## 5. Yêu cầu chức năng

### 5.1 Danh sách Functional Requirement

| Mã FR | Tên yêu cầu |
|---|---|
| FR-AS-01 | Đăng ký và đăng nhập cơ bản |
| FR-AS-02 | Phân quyền Admin/Customer |
| FR-AS-03 | Customer xem dashboard cá nhân |
| FR-AS-04 | Customer xem loyalty points, tier và next reward |
| FR-AS-05 | Customer xem booking history |
| FR-AS-06 | Customer xem reward catalog từ database |
| FR-AS-07 | Booking completed earns loyalty points |
| FR-AS-08 | Chống cộng điểm trùng cho cùng booking |
| FR-AS-09 | Tính điểm theo final amount |
| FR-AS-10 | Cập nhật lifetime data và active 12-month data |
| FR-AS-11 | Tier review theo active spend hoặc active visits |
| FR-AS-12 | Point expiry theo từng batch |
| FR-AS-13 | Customer xem point history |
| FR-AS-14 | Redeem points into voucher |
| FR-AS-15 | Apply voucher to booking |
| FR-AS-16 | Voucher lifecycle management |
| FR-AS-17 | Admin Dashboard |
| FR-AS-18 | Admin Tier Management |
| FR-AS-19 | Admin Reward Management |
| FR-AS-20 | Admin Loyalty Settings |
| FR-AS-21 | Admin Promotion Management |
| FR-AS-22 | Admin Report Dashboard |
| FR-AS-23 | Customer xem promotion cá nhân |
| FR-AS-24 | Seed data cho demo Assessment |
| FR-AS-25 | End-to-end Assessment demo flow |
| FR-AS-26 | Admin UI 6 JSP tách riêng |
| FR-AS-27 | Guest registration access tối thiểu |
| FR-AS-28 | Chuẩn hóa status hệ thống |
| FR-AS-29 | Database-driven display values |
| FR-AS-30 | Loại bỏ hoặc không dùng module ngoài scope |

### 5.2 FR-AS-01 — Đăng ký và đăng nhập cơ bản

**Mô tả:** Hệ thống cho phép người dùng đăng ký tài khoản Customer, đăng nhập và đăng xuất.

**Lý do cần có:** Customer phải có tài khoản để hệ thống gắn booking, điểm, voucher và promotion cá nhân. Admin cần đăng nhập để vào khu vực quản trị.

**Luồng xử lý chính:**

1. Guest truy cập trang Register.
2. Guest nhập thông tin cần thiết để tạo tài khoản Customer.
3. Hệ thống lưu Customer mới vào database với role `CUSTOMER`.
4. User đăng nhập bằng thông tin tài khoản.
5. Hệ thống kiểm tra email/password và role.
6. Nếu là Customer, chuyển vào khu vực Customer.
7. Nếu là Admin, chuyển vào Admin Dashboard.

**Điều kiện/ràng buộc:** Email không được trùng. Role phải là `CUSTOMER` hoặc `ADMIN`. Người chưa đăng nhập không được vào trang cần quyền.

**Kết quả mong đợi:** Người dùng đăng ký, đăng nhập và được chuyển đúng khu vực theo role.

### 5.3 FR-AS-02 — Phân quyền Admin/Customer

**Mô tả:** Hệ thống phân biệt quyền truy cập giữa Admin và Customer.

**Lý do cần có:** Admin có quyền cấu hình hệ thống và xem report, Customer chỉ được thao tác với dữ liệu của chính mình.

**Luồng xử lý chính:**

1. User đăng nhập.
2. Hệ thống lưu thông tin user và role trong session.
3. Khi user truy cập một URL, hệ thống kiểm tra đã đăng nhập chưa.
4. Nếu URL là `/admin/*`, hệ thống kiểm tra role có phải `ADMIN` không.
5. Nếu không đủ quyền, hệ thống chặn truy cập.

**Kết quả mong đợi:** Customer không vào được Admin pages. Người chưa đăng nhập bị chuyển về Login.

### 5.4 FR-AS-03 — Customer xem dashboard cá nhân

**Mô tả:** Customer xem được trang tổng quan cá nhân gồm thông tin tài khoản, tier, điểm, voucher và booking gần đây nếu UI hiện tại hỗ trợ.

**Lý do cần có:** Customer cần biết trạng thái loyalty hiện tại để hiểu quyền lợi của mình.

**Dữ liệu cần hiển thị:**

- Full name.
- Current tier.
- Active points.
- Active spend/visits nếu có.
- Booking gần đây.
- Voucher đang available.
- Promotion cá nhân nếu có.

**Kết quả mong đợi:** Customer thấy dữ liệu của chính mình, không thấy dữ liệu người khác.

### 5.5 FR-AS-04 — Customer xem loyalty points, tier và next reward

**Mô tả:** Customer xem được điểm hiện tại, hạng thành viên hiện tại và reward có thể đổi hoặc reward tiếp theo.

**Lý do cần có:** Đây là yêu cầu trực tiếp của Loyalty Program và Customer Profile.

**Luồng xử lý chính:**

1. Customer mở trang rewards/loyalty.
2. Hệ thống refresh active points nếu cần.
3. Hệ thống lấy tier hiện tại từ Customer và MembershipTier.
4. Hệ thống lấy reward active từ database.
5. JSP hiển thị điểm, hạng và danh sách reward.

**Điều kiện/ràng buộc:** Không hardcode tier thresholds hoặc reward required points trong JSP.

**Kết quả mong đợi:** Customer thấy điểm và hạng đúng theo database.

### 5.6 FR-AS-05 — Customer xem booking history

**Mô tả:** Customer xem được lịch sử booking của chính mình.

**Lý do cần có:** Customer cần theo dõi các lần sử dụng dịch vụ, booking completed và booking đã hủy.

**Luồng xử lý chính:**

1. Customer mở booking/washing history.
2. Hệ thống lọc booking theo `customer_id` của session.
3. Hệ thống hiển thị booking cùng trạng thái, ngày, dịch vụ và số tiền.

**Kết quả mong đợi:** Customer chỉ thấy booking của mình.

### 5.7 FR-AS-06 — Customer xem reward catalog từ database

**Mô tả:** Customer xem được danh sách reward active có thể đổi bằng điểm.

**Lý do cần có:** Reward redemption là một phần chính của Assessment.

**Dữ liệu cần hiển thị:**

- Reward name.
- Required points.
- Reward type.
- Reward value hoặc mô tả quyền lợi.
- Valid days.
- Trạng thái có đủ điểm hay chưa.

**Kết quả mong đợi:** Reward list lấy từ database và thay đổi theo cấu hình Admin.

### 5.8 FR-AS-07 — Booking completed earns loyalty points

**Mô tả:** Khi booking chuyển sang `COMPLETED`, hệ thống tự động cộng điểm loyalty cho Customer.

**Lý do cần có:** Đây là điểm bắt đầu của toàn bộ Loyalty Engine: track points, spend và visits.

**Luồng xử lý chính:**

1. Booking được chuyển sang `COMPLETED`.
2. Hệ thống kiểm tra booking đã được cộng điểm chưa.
3. Nếu chưa, hệ thống tính điểm dựa trên `final_amount` và rule từ tier/config.
4. Hệ thống tạo point batch.
5. Hệ thống tạo loyalty transaction `EARNED`.
6. Hệ thống cập nhật Customer loyalty summary.
7. Hệ thống xét lại tier.
8. Hệ thống đánh dấu booking đã được cộng điểm.

**Kết quả mong đợi:** Booking completed làm tăng điểm, spend, visits và có lịch sử điểm tương ứng.

### 5.9 FR-AS-08 — Chống cộng điểm trùng cho cùng booking

**Mô tả:** Mỗi booking chỉ được cộng điểm một lần.

**Lý do cần có:** Nếu user hoặc admin bấm completed/retry nhiều lần, điểm không được cộng lặp.

**Điều kiện/ràng buộc:** Booking phải có dấu hiệu đã award loyalty, ví dụ `loyalty_points_awarded` và transaction unique cho `EARNED` theo booking.

**Kết quả mong đợi:** Cùng một booking completed nhiều lần hoặc gọi lại logic không làm tăng điểm lần hai.

### 5.10 FR-AS-09 — Tính điểm theo final amount

**Mô tả:** Điểm loyalty được tính theo số tiền cuối cùng Customer thật sự trả sau giảm giá.

**Lý do cần có:** Nếu voucher làm giảm giá, Customer không nên được cộng điểm theo giá gốc.

**Kết quả mong đợi:** Điểm earned dùng `final_amount`, không dùng `original_amount`.

### 5.11 FR-AS-10 — Cập nhật lifetime data và active 12-month data

**Mô tả:** Khi booking completed hoặc loyalty data thay đổi, hệ thống cập nhật cả lifetime data và active data.

**Lý do cần có:** Lifetime data phục vụ báo cáo tổng thể; active data phục vụ tier/reward hiện tại.

**Kết quả mong đợi:** Customer summary phản ánh đúng dữ liệu sau thao tác loyalty.

### 5.12 FR-AS-11 — Tier review theo active spend hoặc active visits

**Mô tả:** Hệ thống xét lại hạng thành viên dựa trên `active_spent_money_12m` hoặc `active_visit_count_12m`.

**Lý do cần có:** Đề yêu cầu auto upgrade/downgrade; nhóm đã chọn cơ chế event-based thay vì monthly review cứng.

**Luồng xử lý chính:**

1. Hệ thống refresh active loyalty data.
2. Lấy danh sách tier active từ database.
3. Sắp tier từ cao xuống thấp.
4. Gán tier cao nhất mà Customer đạt điều kiện.

**Kết quả mong đợi:** Customer được nâng/hạ hạng theo dữ liệu active hiện tại.

### 5.13 FR-AS-12 — Point expiry theo từng batch

**Mô tả:** Hệ thống quản lý điểm hết hạn theo từng batch điểm.

**Lý do cần có:** Đề yêu cầu points expire after 12 months. Cách theo batch giúp biết điểm nào hết hạn và còn bao nhiêu điểm.

**Kết quả mong đợi:** Điểm expired bị loại khỏi active points và không redeem được.

### 5.14 FR-AS-13 — Customer xem point history

**Mô tả:** Customer có thể xem lịch sử biến động điểm gồm điểm cộng, điểm đã dùng và điểm hết hạn.

**Lý do cần có:** Customer cần hiểu vì sao điểm của mình tăng/giảm.

**Dữ liệu cần hiển thị:**

- Transaction type.
- Points.
- Booking/reward liên quan nếu có.
- Thời gian tạo.
- Mô tả.

### 5.15 FR-AS-14 — Redeem points into voucher

**Mô tả:** Customer đổi điểm active thành voucher tương ứng với reward.

**Luồng xử lý chính:**

1. Customer chọn reward.
2. Hệ thống kiểm tra reward active.
3. Hệ thống refresh điểm active.
4. Hệ thống kiểm tra Customer đủ điểm.
5. Hệ thống trừ điểm theo FIFO.
6. Hệ thống tạo Redemption status `AVAILABLE`.
7. Hệ thống tạo LoyaltyTransaction `REDEEMED`.

**Kết quả mong đợi:** Customer nhận voucher và active points giảm đúng.

### 5.16 FR-AS-15 — Apply voucher to booking

**Mô tả:** Customer có thể chọn voucher `AVAILABLE` của mình để áp dụng vào booking.

**Lý do cần có:** Redemption không chỉ là trừ điểm, mà phải tạo được lợi ích thực tế trong booking sau.

**Kết quả mong đợi:** Booking lưu voucher đã áp dụng, discount amount và final amount được tính đúng.

### 5.17 FR-AS-16 — Voucher lifecycle management

**Mô tả:** Hệ thống quản lý trạng thái voucher từ lúc tạo đến lúc dùng hoặc hết hạn.

**Kết quả mong đợi:** Voucher không bị dùng lại, không dùng được khi expired/cancelled, và chuyển `USED` khi booking liên quan completed.

### 5.18 FR-AS-17 — Admin Dashboard

**Mô tả:** Admin có trang dashboard tổng quan.

**Dữ liệu hiển thị:**

- Tổng số Customer.
- Số booking completed.
- Tổng doanh thu.
- Tổng điểm đã phát sinh.
- Số reward đã redeem.
- Số promotion active.
- Recent completed bookings.
- Recent redemptions.

**Kết quả mong đợi:** Admin dashboard hiển thị số liệu từ database.

### 5.19 FR-AS-18 — Admin Tier Management

**Mô tả:** Admin xem và chỉnh cấu hình tier.

**Dữ liệu quản lý:**

- Tier name.
- Min spent money.
- Min visit count.
- Point multiplier.
- Booking window days.
- Priority score.
- Benefits.
- Status.

**Kết quả mong đợi:** Sau khi Admin sửa tier, Customer và booking logic dùng dữ liệu mới từ database.

### 5.20 FR-AS-19 — Admin Reward Management

**Mô tả:** Admin quản lý reward catalog.

**Dữ liệu quản lý:**

- Reward name.
- Required points.
- Reward type.
- Reward value.
- Target service.
- Valid days.
- Active/inactive.

**Kết quả mong đợi:** Customer reward catalog phản ánh dữ liệu Admin cấu hình.

### 5.21 FR-AS-20 — Admin Loyalty Settings

**Mô tả:** Admin quản lý cấu hình loyalty chung.

**Dữ liệu quản lý:**

- Point expiry months.
- Point rate amount.
- Default voucher valid days.
- Loyalty status.

**Kết quả mong đợi:** Hệ thống không hardcode số tháng hết hạn điểm; cấu hình từ database được dùng khi tạo point batch.

### 5.22 FR-AS-21 — Admin Promotion Management

**Mô tả:** Admin tạo, sửa và gửi promotion.

**Luồng xử lý chính:**

1. Admin tạo promotion.
2. Chọn target type ALL hoặc TIER.
3. Nếu TIER, chọn tier từ database.
4. Lưu promotion.
5. Khi bấm send, hệ thống tạo CustomerPromotion cho Customer phù hợp.

**Kết quả mong đợi:** Customer thuộc target thấy promotion trong trang cá nhân.

### 5.23 FR-AS-22 — Admin Report Dashboard

**Mô tả:** Admin xem tất cả report trong một trang `report-dashboard.jsp`.

**Report cần có:**

1. Customer Loyalty Report.
2. Booking & Revenue Report.
3. Reward Redemption Report.
4. Promotion Delivery Report.

**Bộ lọc cơ bản:**

- dateFrom.
- dateTo.
- tier.
- status.

**Kết quả mong đợi:** Report hiển thị dữ liệu thật từ database.

### 5.24 FR-AS-23 — Customer xem promotion cá nhân

**Mô tả:** Customer xem promotion đã được gửi cho mình.

**Kết quả mong đợi:** Customer chỉ thấy promotion phù hợp với bản ghi CustomerPromotion của mình.

### 5.25 FR-AS-24 — Seed data cho demo Assessment

**Mô tả:** Hệ thống cần dữ liệu mẫu đủ để demo toàn bộ luồng Assessment.

**Dữ liệu mẫu cần có:**

- Ít nhất 1 Admin.
- Nhiều Customer ở các tier khác nhau.
- Dịch vụ rửa xe.
- Tier rules.
- Loyalty config.
- Reward catalog.
- Booking completed.
- Point batch và transaction.
- Voucher available/used/expired.
- Promotion active.
- CustomerPromotion records.

**Kết quả mong đợi:** Chạy database sample xong có thể demo ngay.

### 5.26 FR-AS-25 — End-to-end Assessment demo flow

**Mô tả:** Hệ thống phải hỗ trợ demo hoàn chỉnh.

**Luồng demo mong đợi:**

1. Guest vào Register hoặc dùng tài khoản Customer mẫu.
2. Customer đăng nhập.
3. Customer đặt booking.
4. Booking chuyển sang `COMPLETED`.
5. Hệ thống cộng điểm và xét hạng.
6. Customer xem points/tier/history.
7. Customer redeem reward thành voucher.
8. Customer dùng voucher trong booking sau.
9. Admin đăng nhập.
10. Admin chỉnh tier/reward/settings.
11. Admin tạo và gửi promotion.
12. Customer đúng target thấy promotion.
13. Admin xem reports.

### 5.27 FR-AS-26 — Admin UI 6 JSP tách riêng

**Mô tả:** Admin UI phải gồm 6 trang chính tách riêng và dùng component chung.

**Danh sách JSP:**

- `admin-dashboard.jsp`
- `tier-management.jsp`
- `reward-management.jsp`
- `loyalty-settings.jsp`
- `promotion-management.jsp`
- `report-dashboard.jsp`

**Kết quả mong đợi:** Admin UI đồng bộ giao diện, không trộn vào Customer JSP.

### 5.28 FR-AS-27 — Guest registration access tối thiểu

**Mô tả:** Guest chỉ cần vào được Login/Register để đăng ký thành Customer.

**Kết quả mong đợi:** Không cần làm public guest UI nâng cao trong scope chính, nhưng demo vẫn có thể nói Guest register to become Customer.

### 5.29 FR-AS-28 — Chuẩn hóa status hệ thống

**Mô tả:** Các thực thể chính phải dùng status chuẩn đã định nghĩa.

**Kết quả mong đợi:** Không dùng lẫn lộn `Done`, `Finish`, `Completed`, `complete` trong database/code.

### 5.30 FR-AS-29 — Database-driven display values

**Mô tả:** Các giá trị hiển thị quan trọng phải lấy từ database.

**Kết quả mong đợi:** Khi sửa dữ liệu trong database hoặc Admin UI, màn hình Customer/Admin phản ánh thay đổi.

### 5.31 FR-AS-30 — Loại bỏ hoặc không dùng module ngoài scope

**Mô tả:** Các module AI recommendation, LPR log, payment, feedback và queue log không thuộc scope chính hiện tại.

**Kết quả mong đợi:** App Assessment không phụ thuộc vào các bảng hoặc màn hình ngoài scope này.

---

## 6. Giao diện người dùng

### 6.1 Nguyên tắc UI chung

UI hiện tại của nhóm theo phong cách Luxe Wash: dark mode, màu vàng/gold, glass cards, cảm giác premium. Admin UI mới phải đồng bộ với phong cách này để app nhìn thống nhất.

UI prototype có thể có mock data, nhưng khi code thật thì dữ liệu phải đến từ database.

### 6.2 Admin UI structure

Cấu trúc thư mục gợi ý:

```text
web/
  admin/
    components/
      admin-head.jspf
      admin-shell-start.jspf
      admin-shell-end.jspf
    pages/
      admin-dashboard.jsp
      tier-management.jsp
      reward-management.jsp
      loyalty-settings.jsp
      promotion-management.jsp
      report-dashboard.jsp
    css/
      admin.css
```

Nếu app gọi trực tiếp để preview UI thì có thể mở:

```text
/admin/pages/admin-dashboard.jsp
```

Khi code thật, nên đi qua Servlet route như:

```text
/admin/dashboard
/admin/tiers
/admin/rewards
/admin/loyalty-settings
/admin/promotions
/admin/reports
```

### 6.3 admin-dashboard.jsp

Trang này hiển thị tổng quan hệ thống cho Admin. Các card số liệu phải lấy từ database.

Dữ liệu cần có:

- `totalCustomers`
- `completedBookings`
- `totalRevenue`
- `totalPointsIssued`
- `redeemedRewards`
- `activePromotions`
- `recentBookings`
- `recentRedemptions`

### 6.4 tier-management.jsp

Trang này hiển thị và chỉnh sửa tier. Không hardcode Member/Silver/Gold/Platinum trong bảng final.

Dữ liệu cần có:

- `tiers`

Form fields:

- `tierId`
- `tierName`
- `minSpentMoney`
- `minVisitCount`
- `pointMultiplier`
- `bookingWindowDays`
- `priorityScore`
- `benefits`
- `status`

### 6.5 reward-management.jsp

Trang này hiển thị và chỉnh sửa reward catalog.

Dữ liệu cần có:

- `rewards`
- `services`

Form fields:

- `rewardId`
- `rewardName`
- `requiredPoints`
- `rewardType`
- `rewardValue`
- `targetServiceId`
- `validDays`
- `isActive`

### 6.6 loyalty-settings.jsp

Trang này hiển thị và chỉnh loyalty config.

Dữ liệu cần có:

- `loyaltyConfig`

Form fields:

- `pointExpiryMonths`
- `pointRateAmount`
- `defaultVoucherValidDays`
- `loyaltyStatus`

### 6.7 promotion-management.jsp

Trang này quản lý promotion.

Dữ liệu cần có:

- `promotions`
- `tiers`

Form fields:

- `promotionId`
- `title`
- `description`
- `promotionType`
- `promotionValue`
- `targetType`
- `targetTierId`
- `startDate`
- `endDate`
- `status`

### 6.8 report-dashboard.jsp

Trang này gộp tất cả report vào một màn hình.

Dữ liệu cần có:

- `customerLoyaltyReport`
- `bookingRevenueReport`
- `rewardRedemptionReport`
- `promotionDeliveryReport`
- `tiers`
- filter values nếu có.

---

## 7. Chi tiết Use Case

### 7.1 UC-AS-01 — Đăng ký tài khoản Customer

**Actor chính:** Guest

**Mục tiêu:** Người chưa có tài khoản có thể đăng ký thành Customer để sử dụng booking và loyalty.

**Tiền điều kiện:** Guest chưa đăng nhập.

**Hậu điều kiện:** Tài khoản Customer được tạo trong database.

**Luồng chính:**

1. Guest mở trang Register.
2. Guest nhập thông tin tài khoản.
3. Hệ thống validate email, password và dữ liệu bắt buộc.
4. Hệ thống tạo Customer mới với role `CUSTOMER`.
5. Hệ thống chuyển Guest sang Login hoặc đăng nhập tùy thiết kế hiện tại.

**Luồng ngoại lệ:**

- Email đã tồn tại: hệ thống báo lỗi.
- Dữ liệu thiếu: hệ thống báo lỗi.

**Quy tắc liên quan:** FR-AS-01, FR-AS-27.

### 7.2 UC-AS-02 — Customer xem loyalty dashboard

**Actor chính:** Customer

**Mục tiêu:** Customer xem điểm, hạng, reward và thông tin loyalty hiện tại.

**Tiền điều kiện:** Customer đã đăng nhập.

**Luồng chính:**

1. Customer mở trang loyalty/rewards.
2. Hệ thống lấy Customer từ session.
3. Hệ thống refresh điểm active nếu cần.
4. Hệ thống lấy tier, points, reward catalog và point history.
5. JSP hiển thị dữ liệu.

**Hậu điều kiện:** Customer hiểu được điểm, hạng và reward có thể đổi.

### 7.3 UC-AS-03 — Booking completed earns points

**Actor chính:** Hệ thống/Admin workflow

**Mục tiêu:** Sau khi dịch vụ hoàn tất, Customer được cộng điểm và cập nhật hạng.

**Tiền điều kiện:** Booking tồn tại và chuyển sang `COMPLETED`.

**Luồng chính:**

1. Booking chuyển sang `COMPLETED`.
2. Hệ thống kiểm tra booking chưa award loyalty.
3. Hệ thống tính điểm dựa trên `final_amount`.
4. Hệ thống tạo point batch và transaction earned.
5. Hệ thống cập nhật Customer summary.
6. Hệ thống xét lại tier.

**Luồng ngoại lệ:**

- Booking đã award loyalty: không cộng lại.
- Booking không phải `COMPLETED`: không cộng điểm.

### 7.4 UC-AS-04 — Customer redeem reward

**Actor chính:** Customer

**Mục tiêu:** Customer dùng điểm active để đổi voucher.

**Tiền điều kiện:** Customer đã đăng nhập, reward active, Customer đủ điểm.

**Luồng chính:**

1. Customer chọn reward.
2. Hệ thống kiểm tra reward active.
3. Hệ thống refresh active points.
4. Hệ thống trừ điểm theo FIFO.
5. Hệ thống tạo Redemption `AVAILABLE`.
6. Hệ thống tạo transaction `REDEEMED`.
7. Hệ thống hiển thị voucher mới cho Customer.

### 7.5 UC-AS-05 — Customer dùng voucher trong booking

**Actor chính:** Customer

**Mục tiêu:** Customer áp dụng voucher vào booking để nhận ưu đãi.

**Tiền điều kiện:** Customer có voucher `AVAILABLE`.

**Luồng chính:**

1. Customer tạo hoặc chỉnh booking.
2. Hệ thống hiển thị voucher available của Customer.
3. Customer chọn voucher.
4. Hệ thống tính discount theo reward type.
5. Booking lưu `applied_redemption_id`, `discount_amount`, `final_amount`.
6. Khi booking completed, voucher chuyển `USED`.

### 7.6 UC-AS-06 — Admin quản lý tier

**Actor chính:** Admin

**Mục tiêu:** Admin chỉnh rule hạng thành viên.

**Luồng chính:**

1. Admin mở `/admin/tiers`.
2. Hệ thống lấy danh sách tier từ database.
3. Admin sửa rule.
4. Hệ thống validate dữ liệu.
5. Hệ thống lưu vào `MembershipTier`.
6. Trang reload và hiển thị dữ liệu mới.

### 7.7 UC-AS-07 — Admin quản lý reward

**Actor chính:** Admin

**Mục tiêu:** Admin chỉnh reward catalog.

**Luồng chính:**

1. Admin mở `/admin/rewards`.
2. Hệ thống lấy reward và service list.
3. Admin thêm/sửa reward.
4. Hệ thống validate reward type và required points.
5. Hệ thống lưu vào database.

### 7.8 UC-AS-08 — Admin chỉnh loyalty settings

**Actor chính:** Admin

**Mục tiêu:** Admin chỉnh cấu hình loyalty chung.

**Luồng chính:**

1. Admin mở `/admin/loyalty-settings`.
2. Hệ thống lấy config từ database.
3. Admin sửa point expiry months hoặc cấu hình liên quan.
4. Hệ thống lưu lại.

### 7.9 UC-AS-09 — Admin tạo và gửi promotion

**Actor chính:** Admin

**Mục tiêu:** Admin gửi promotion đến đúng Customer.

**Luồng chính:**

1. Admin mở `/admin/promotions`.
2. Admin tạo promotion.
3. Admin chọn target ALL hoặc TIER.
4. Admin bấm Send.
5. Hệ thống tìm Customer phù hợp.
6. Hệ thống tạo CustomerPromotion records.

### 7.10 UC-AS-10 — Admin xem reports

**Actor chính:** Admin

**Mục tiêu:** Admin xem các báo cáo chính.

**Luồng chính:**

1. Admin mở `/admin/reports`.
2. Hệ thống lấy dữ liệu report từ database.
3. Admin dùng filter nếu cần.
4. JSP hiển thị các report section.

---

## 8. Yêu cầu phi chức năng

### 8.1 NFR-AS-01 — Response time

Hệ thống nên phản hồi thao tác người dùng trong vòng 5 giây đối với phần lớn request trong điều kiện demo bình thường.

### 8.2 NFR-AS-02 — Booking processing

Các thao tác booking có loyalty/reward calculation nên hoàn tất trong vòng 5 giây trong điều kiện demo.

### 8.3 NFR-AS-03 — Concurrent users

Đề bài gốc yêu cầu hỗ trợ 500 concurrent users. Trong scope sinh viên, hệ thống cần thiết kế truy vấn và code không quá tệ, tránh hardcode hoặc load dữ liệu sai cách khiến app dễ treo. Không bắt buộc benchmark enterprise-level nếu không có môi trường test.

### 8.4 NFR-AS-04 — Availability

Đề bài gốc nêu mục tiêu 99.5% uptime. Trong scope môn học, cần đảm bảo app chạy ổn định khi demo, không crash ở luồng chính.

### 8.5 NFR-AS-05 — Data backup

Đề bài gốc nêu daily backup. Trong scope hiện tại, cần có database script `schema.sql` và `sample-data.sql` để có thể tái tạo môi trường demo.

### 8.6 NFR-AS-06 — Security

Admin pages phải chặn Customer và Guest. Mật khẩu trong triển khai thật nên lưu dạng hash. Nếu sample data dùng plain text cho demo thì phải hiểu đó không phải chuẩn bảo mật production.

### 8.7 NFR-AS-07 — Maintainability

Admin UI không được trộn vào Customer JSP. Các module nên tách rõ theo chức năng để nhóm dễ sửa và review.

---

## 9. Kịch bản kiểm thử và demo

### 9.1 TS-AS-01 — Admin access control

**Mục tiêu:** Kiểm tra phân quyền Admin.

**Các bước:**

1. Chưa đăng nhập, truy cập `/admin/dashboard`.
2. Đăng nhập bằng Customer, truy cập `/admin/dashboard`.
3. Đăng nhập bằng Admin, truy cập `/admin/dashboard`.

**Kết quả mong đợi:**

- Guest bị chuyển về Login.
- Customer bị chặn.
- Admin vào được dashboard.

### 9.2 TS-AS-02 — Booking completed earns points

**Mục tiêu:** Kiểm tra cộng điểm khi booking completed.

**Các bước:**

1. Chọn Customer có booking chưa completed.
2. Chuyển booking sang `COMPLETED`.
3. Mở Customer loyalty page.
4. Kiểm tra point history.

**Kết quả mong đợi:**

- Customer tăng active points.
- Có transaction `EARNED`.
- Booking đánh dấu đã award loyalty.
- Gọi lại không cộng điểm lần hai.

### 9.3 TS-AS-03 — Tier review

**Mục tiêu:** Kiểm tra xét hạng.

**Các bước:**

1. Cấu hình tier trong database/Admin UI.
2. Tạo đủ booking completed để Customer đạt điều kiện tier cao hơn.
3. Trigger loyalty refresh.

**Kết quả mong đợi:** Customer được gán tier cao nhất đạt điều kiện.

### 9.4 TS-AS-04 — Redeem reward

**Mục tiêu:** Kiểm tra đổi điểm thành voucher.

**Các bước:**

1. Customer có đủ active points.
2. Customer chọn reward active.
3. Bấm redeem.
4. Mở my vouchers/Redemption list.

**Kết quả mong đợi:**

- Tạo Redemption `AVAILABLE`.
- Active points giảm.
- Có transaction `REDEEMED`.

### 9.5 TS-AS-05 — Apply voucher to booking

**Mục tiêu:** Kiểm tra dùng voucher.

**Các bước:**

1. Customer có voucher `AVAILABLE`.
2. Customer tạo booking và chọn voucher.
3. Kiểm tra discount/final amount.
4. Chuyển booking sang completed.

**Kết quả mong đợi:**

- Booking lưu voucher.
- Final amount giảm đúng.
- Voucher chuyển `USED` khi booking completed.

### 9.6 TS-AS-06 — Point expiry

**Mục tiêu:** Kiểm tra điểm hết hạn.

**Các bước:**

1. Seed Customer có point batch cũ quá hạn.
2. Trigger loyalty refresh.
3. Mở loyalty dashboard và point history.

**Kết quả mong đợi:**

- Điểm expired bị loại khỏi active points.
- Batch chuyển `EXPIRED` nếu còn remaining points.
- Có transaction `EXPIRED`.

### 9.7 TS-AS-07 — Admin tier management

**Mục tiêu:** Kiểm tra Admin sửa tier rule.

**Các bước:**

1. Admin mở `tier-management.jsp` qua route Admin.
2. Sửa booking window hoặc point multiplier.
3. Lưu.
4. Reload trang.

**Kết quả mong đợi:** Dữ liệu mới hiển thị từ database.

### 9.8 TS-AS-08 — Admin reward management

**Mục tiêu:** Kiểm tra Admin sửa reward.

**Các bước:**

1. Admin mở reward management.
2. Thêm hoặc sửa reward.
3. Customer mở reward catalog.

**Kết quả mong đợi:** Customer thấy reward được cấu hình từ database.

### 9.9 TS-AS-09 — Admin promotion delivery

**Mục tiêu:** Kiểm tra promotion theo tier.

**Các bước:**

1. Admin tạo promotion target Gold.
2. Admin bấm Send.
3. Customer Gold đăng nhập.
4. Customer không phải Gold đăng nhập.

**Kết quả mong đợi:** Gold thấy promotion; Customer không đúng tier không thấy promotion đó.

### 9.10 TS-AS-10 — Admin reports

**Mục tiêu:** Kiểm tra report lấy dữ liệu thật.

**Các bước:**

1. Có booking completed, redemption, promotion delivery trong database.
2. Admin mở report dashboard.
3. Dùng filter nếu có.

**Kết quả mong đợi:** Report hiển thị số liệu đúng theo dữ liệu database.

---

## 10. Luồng demo Assessment đề xuất

Luồng demo chính nên đi theo thứ tự sau để giảng viên dễ hiểu:

1. Mở app và đăng nhập Customer.
2. Customer xem tier/points hiện tại.
3. Customer tạo booking.
4. Admin hoặc workflow chuyển booking sang `COMPLETED`.
5. Customer quay lại loyalty page thấy điểm tăng và lịch sử điểm.
6. Customer redeem reward thành voucher.
7. Customer dùng voucher trong booking sau.
8. Admin đăng nhập.
9. Admin mở tier/reward/settings để chứng minh rule lấy từ database.
10. Admin tạo promotion theo tier và gửi.
11. Customer đúng tier xem promotion.
12. Admin mở report dashboard để xem số liệu tổng hợp.

Luồng này bao phủ các yêu cầu quan trọng nhất của Assessment: booking, loyalty, reward, voucher, promotion và report.

---

## 11. Definition of Done

Một chức năng được xem là hoàn thành khi thỏa các điều kiện sau:

- Chạy được trên app local.
- Không làm hỏng luồng Customer hiện có.
- Dữ liệu nghiệp vụ lấy từ database.
- Không hardcode tier/reward/promotion/report trong JSP/Servlet.
- Có kiểm tra role nếu là Admin page.
- Có thông báo lỗi hoặc thông báo thành công rõ ràng.
- Có thể demo bằng sample data.
- Tên status dùng đúng chuẩn.
- Không đưa module out-of-scope vào scope chính.

---

## 12. Future / Backlog

Các chức năng sau có thể làm sau khi scope chính đã ổn:

- Guest public home/service/loyalty information pages.
- Admin audit log.
- AI recommendation.
- LPR automation.
- Online payment.
- Feedback/rating.
- Email/SMS promotion.
- Mobile app.
- Advanced charts.

---

## 13. Kết luận

SRS này mô tả phiên bản Assessment của AutoWashPro theo hướng dễ hiểu, tập trung vào app chạy được và demo được. Các yêu cầu quan trọng nhất là Loyalty Engine, Reward/Voucher, Admin Controls, Promotion và Reports. Tất cả dữ liệu nghiệp vụ phải lấy từ database để tránh hardcode và giúp Admin có thể cấu hình hệ thống thật sự.

Tài liệu không thay thế cho code chi tiết, nhưng đủ để thành viên nhóm hiểu hệ thống cần làm gì, UI cần có màn hình nào, database cần lưu dữ liệu gì và khi test thì kết quả đúng phải ra sao.

## 14. Grouped Issue Checklist and Pull Request Review Standard

### 14.1 Mục đích

Phần này quy định cách phân rã yêu cầu trong SRS thành grouped GitHub Issues và cách review Pull Request trước khi merge.

Mục tiêu là giúp người code và agent review hiểu rõ mỗi issue cần hoàn thành những gì mà không cần đọc lại toàn bộ SRS.md mỗi lần. Tuy nhiên, SRS.md vẫn là nguồn chuẩn cuối cùng nếu có mâu thuẫn giữa issue và tài liệu yêu cầu.

### 14.2 Nguyên tắc phân rã issue

Hệ thống không tạo 30 issue riêng theo từng FR-AS. Thay vào đó, các FR-AS được gom thành 12 grouped issues để dễ quản lý và phù hợp với năng lực triển khai của nhóm.

Mỗi grouped issue phải ghi rõ:

* Group ID.
* Tên issue.
* Các FR-AS được cover.
* Goal.
* Completion Checklist.
* Acceptance Criteria.
* PR Merge Gate.
* Merge Blockers.

Không bắt buộc mỗi issue phải có data flow chi tiết. Người code có thể triển khai theo cấu trúc hiện tại của project, miễn là kết quả cuối đáp ứng checklist và không phá chức năng liên quan.

### 14.3 Danh sách grouped issues chuẩn

| Group ID | Tên grouped issue                                 | FR-AS cover                                      |
| -------- | ------------------------------------------------- | ------------------------------------------------ |
| GI-01    | Auth, Registration and Access Control             | FR-AS-01, FR-AS-02, FR-AS-27                     |
| GI-02    | Customer Dashboard, Loyalty Overview and History  | FR-AS-03, FR-AS-04, FR-AS-05, FR-AS-06, FR-AS-13 |
| GI-03    | Booking Completion Loyalty Award                  | FR-AS-07, FR-AS-08, FR-AS-09, FR-AS-10, FR-AS-28 |
| GI-04    | Tier Review and Active 12-Month Loyalty Data      | FR-AS-11                                         |
| GI-05    | Point Batch Expiry and Active Points Refresh      | FR-AS-12                                         |
| GI-06    | Reward Redemption into Voucher                    | FR-AS-14                                         |
| GI-07    | Apply Voucher to Booking and Voucher Lifecycle    | FR-AS-15, FR-AS-16                               |
| GI-08    | Admin UI Shell and Dashboard                      | FR-AS-17, FR-AS-26                               |
| GI-09    | Admin Loyalty Configuration Controls              | FR-AS-18, FR-AS-19, FR-AS-20                     |
| GI-10    | Promotion Management and Customer Promotion Inbox | FR-AS-21, FR-AS-23                               |
| GI-11    | Admin Reports Dashboard                           | FR-AS-22                                         |
| GI-12    | Assessment Seed Data, Demo Flow and Scope Cleanup | FR-AS-24, FR-AS-25, FR-AS-29, FR-AS-30           |

### 14.4 Grouped issue template

Mỗi grouped issue được tạo từ SRS phải dùng cấu trúc tối thiểu sau:

```markdown
# GI-XX — Issue Title

## Goal
Mô tả mục tiêu nghiệp vụ của issue.

## FR Cover
Liệt kê các FR-AS được cover.

## Completion Checklist
- [ ] Checklist 1.
- [ ] Checklist 2.
- [ ] Checklist 3.

## Acceptance Criteria
Mô tả kết quả có thể kiểm tra được sau khi hoàn thành issue.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR có liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 review theo quy định review của nhóm.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng được liệt kê trong phần này.
```

### 14.5 Chính sách hardcode

Hardcode được chia thành 2 loại:

1. Hardcode kỹ thuật ổn định.
2. Hardcode business/display values.

Hardcode kỹ thuật ổn định được phép dùng ở mức hợp lý. Ví dụ:

* `ADMIN`
* `CUSTOMER`
* `PENDING`
* `CONFIRMED`
* `COMPLETED`
* `CANCELLED`
* `AVAILABLE`
* `USED`
* `EXPIRED`
* `EARNED`
* `REDEEMED`

Hardcode business/display values nên tránh, nhưng không tự động chặn merge. Ví dụ:

* tier threshold;
* point rate;
* point multiplier;
* reward cost;
* voucher valid days;
* promotion target;
* service price;
* report numbers.

Nếu reviewer hoặc agent phát hiện hardcode business/display values, reviewer cần ghi nhận dưới dạng review comment hoặc warning.

Ví dụ review comment:

```text
Chỗ này đang hardcode business value. Nên cân nhắc chuyển sang lấy từ database hoặc config nếu có thời gian.
```

Hardcode chỉ trở thành merge blocker nếu gây ra một trong các lỗi sau:

* Làm sai Completion Checklist của issue.
* Làm Admin config không có tác dụng.
* Làm report hiển thị số fake/static thay vì dữ liệu thật.
* Làm logic loyalty/reward/voucher sai nghiệp vụ.
* Làm demo Assessment không phản ánh dữ liệu database.

### 14.6 Chính sách review Pull Request

Mỗi Pull Request cần có ít nhất 2 review trước khi merge:

1. Review tự động bằng agent automation do người phụ trách chính chạy.
2. Review thủ công từ thành viên liên quan nếu PR có thể ảnh hưởng đến chức năng người đó đang làm hoặc đã làm.

Nếu PR không ảnh hưởng chức năng của thành viên khác, reviewer thủ công có thể là bất kỳ thành viên nào được nhóm chỉ định.

Nếu PR ảnh hưởng trực tiếp chức năng của một thành viên cụ thể, cần gọi thành viên đó review thủ công trước khi merge. Ví dụ:

* PR sửa booking logic thì gọi người phụ trách booking review.
* PR sửa loyalty points thì gọi người phụ trách loyalty review.
* PR sửa Admin UI thì gọi người phụ trách Admin UI review.
* PR sửa report thì gọi người phụ trách report/database review.

### 14.7 PR Merge Gate chung

PR có thể được merge nếu đạt các điều kiện sau:

* [ ] Project build/run được ở môi trường local của nhóm.
* [ ] PR có liên kết hoặc mô tả rõ grouped issue đang làm.
* [ ] PR không làm mất chức năng chính đã có.
* [ ] PR hoàn thành checklist chính của grouped issue hoặc ghi rõ phần còn thiếu là follow-up.
* [ ] PR đã được agent automation review.
* [ ] PR đã được ít nhất 1 reviewer thủ công review.
* [ ] Nếu PR ảnh hưởng đến chức năng của thành viên khác, thành viên đó đã được gọi review.
* [ ] Không có merge blocker nghiêm trọng.

Không bắt buộc PR phải có screenshot, SQL query, log hoặc bằng chứng test chi tiết. Tuy nhiên, nếu có test thủ công, người tạo PR nên ghi ngắn gọn đã test gì trong PR description để reviewer dễ kiểm tra.

### 14.8 Merge blockers chung

PR không được merge nếu có một trong các lỗi sau:

* App không build hoặc không chạy được.
* Customer truy cập được Admin page.
* Guest truy cập được trang cần đăng nhập.
* Booking `PENDING`, `CONFIRMED` hoặc `CANCELLED` vẫn được cộng loyalty points.
* Booking `COMPLETED` bị cộng điểm nhiều hơn một lần.
* Điểm loyalty tính theo `original_amount` thay vì `final_amount`.
* Redeem reward bằng điểm đã hết hạn.
* Voucher `USED`, `EXPIRED` hoặc `CANCELLED` vẫn dùng lại được.
* Một voucher được dùng cho nhiều booking.
* Một booking áp dụng nhiều voucher trong scope hiện tại.
* Report dùng số fake/static làm kết quả chính.
* PR đưa AI, LPR, Payment, Feedback hoặc module ngoài scope vào luồng Assessment chính.
* PR xóa hoặc phá dữ liệu seed cần cho demo Assessment.
* PR sửa quá nhiều khu vực không liên quan và gây rủi ro cho chức năng của thành viên khác mà chưa có review thủ công phù hợp.

### 14.9 Quy tắc khi PR vượt scope issue

Nếu PR làm nhiều hơn scope của grouped issue, reviewer hoặc agent automation cần ghi nhận trong review.

PR vượt scope không tự động bị reject nếu:

* code vẫn build/run được;
* không phá chức năng hiện có;
* không vi phạm merge blocker;
* phần vượt scope có liên quan hợp lý đến issue đang làm.

Tuy nhiên, reviewer có quyền yêu cầu tách PR nếu phần vượt scope làm PR quá lớn, khó review hoặc ảnh hưởng trực tiếp đến chức năng của thành viên khác.

### 14.10 Trách nhiệm của agent automation review

Agent automation review có nhiệm vụ:

* Đọc grouped issue liên quan.
* Kiểm tra Completion Checklist.
* Kiểm tra Acceptance Criteria.
* Ghi nhận hardcode business/display values nếu thấy.
* Ghi nhận khu vực PR có thể ảnh hưởng đến thành viên khác.
* Đề xuất reviewer thủ công phù hợp nếu cần.
* Chỉ ra merge blockers nếu có.

Agent automation không được tự ý merge. Quyết định merge cuối cùng thuộc về nhóm sau khi đủ review.

