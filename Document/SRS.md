# SRS.md — AutoWashPro Assessment

**Project:** Smart Automated Car Wash Management System with Advance Booking & Loyalty Program  
**Vietnamese name:** Hệ thống quản lý rửa xe ô tô tự động thông minh với đặt lịch trước và chương trình khách hàng thân thiết  
**Document version:** v0.1.0  
**Status:** Assessment baseline / dùng để code và phân rã GitHub Issues  
**Primary stack:** Java Servlet/JSP MVC2, SQL Server, Tomcat, HTML/CSS/JS  
**Main rule:** Mọi business data và displayed values phải lấy từ database, không hardcode trong Java/JSP/Servlet.

---

## 1. Mục tiêu tài liệu

Tài liệu này mô tả rõ app AutoWashPro cần làm được gì trong phần PRJ301 Assessment để các thành viên trong nhóm có thể code theo cùng một chuẩn.

SRS này không nhằm mô tả kiến trúc enterprise phức tạp. Mục tiêu chính là:

1. Làm app chạy được, demo được, dễ giải thích khi vấn đáp.
2. Bao phủ đúng các yêu cầu Assessment: booking theo hạng, loyalty engine, reward redemption, point expiry, admin controls, promotion và report.
3. Giữ dữ liệu nghiệp vụ trong database, tránh hardcode ở Java/JSP/Servlet.
4. Làm tài liệu nguồn để skill agent phân rã thành GitHub Issues sau này.
5. Làm chuẩn để review Pull Request: PR phải khớp Issue + SRS + database.

---

## 2. Phạm vi Assessment

### 2.1 In Scope — bắt buộc làm trong Assessment

Các phần sau thuộc scope chính:

- Customer login/logout/register cơ bản.
- Customer profile có thông tin tài khoản, xe, hạng, điểm.
- Booking và booking history.
- Tier-based booking window.
- Priority booking theo hạng thành viên.
- Loyalty Engine:
  - track points;
  - track tier;
  - track spend;
  - track visits;
  - cộng điểm khi booking `COMPLETED`;
  - xét lại hạng;
  - điểm hết hạn sau thời gian cấu hình, mặc định sample là 12 tháng;
  - redeem points thành voucher/reward.
- Reward catalog lấy từ database.
- Voucher usage trong booking sau.
- Promotion inbox cho customer.
- Admin Controls:
  - tier management;
  - reward management;
  - loyalty settings;
  - promotion management;
  - reports;
  - admin dashboard.
- Role-based access: `ADMIN` và `CUSTOMER`.
- Seed data đủ để demo.

### 2.2 Out of Scope — không làm trong scope chính hiện tại

Các phần sau không thuộc scope chính hiện tại, không nên kéo vào PR Assessment nếu chưa được quyết định lại:

- AI Recommendation / AI tư vấn.
- LPR Log / License Plate Recognition automation.
- Payment module riêng.
- Feedback module.
- BookingQueueLog phụ.
- Mobile app riêng.
- Guest public marketing pages đầy đủ.
- Email/SMS promotion.
- Audit log lịch sử admin sửa cấu hình.

Ghi chú: đề có nhắc AI/LPR/mobile ở mức đề xuất rộng, nhưng bản Assessment hiện tại ưu tiên web app chạy ổn với Loyalty/Admin/Booking.

---

## 3. Actor và quyền truy cập

### ACT-AS-01 — Guest

Guest là người chưa đăng nhập.

Guest trong scope hiện tại chỉ cần:

- Truy cập `login.jsp`.
- Truy cập `register.jsp`.
- Đăng ký tài khoản để trở thành Customer.

Guest không được:

- đặt booking;
- xem loyalty dashboard;
- đổi reward;
- xem voucher;
- xem promotion cá nhân;
- xem booking history;
- truy cập Admin UI.

Guest public pages mở rộng như public service catalog, public loyalty information page, landing page marketing được đưa vào Future/Backlog.

### ACT-AS-02 — Customer

Customer là người dùng đã đăng nhập với `role_name = CUSTOMER`.

Customer được:

- quản lý profile cơ bản;
- quản lý xe;
- đặt booking;
- xem booking history;
- xem hạng, điểm, lịch sử điểm;
- xem reward catalog;
- redeem điểm thành voucher;
- dùng voucher trong booking;
- xem promotion được gửi tới mình.

Customer không được:

- vào `/admin/*`;
- sửa tier/reward/config/promotion/report;
- xem dữ liệu report toàn hệ thống.

### ACT-AS-03 — Admin

Admin là người dùng đã đăng nhập với `role_name = ADMIN`.

Admin được:

- vào `/admin/*`;
- xem dashboard tổng quan;
- cấu hình tier;
- cấu hình reward;
- cấu hình loyalty settings;
- tạo/sửa/gửi promotion;
- xem reports.

Admin không nên dùng các chức năng customer cá nhân như redeem reward cho chính mình trong scope chính, trừ khi app cũ đang cho phép và không ảnh hưởng demo.

---

## 4. Nguyên tắc bắt buộc về dữ liệu

### BR-AS-GLOBAL-01 — Không hardcode business data

Các dữ liệu sau phải lấy từ database, không hardcode trong Java/JSP/Servlet:

- tier name;
- tier rule;
- min spent;
- min visit;
- point rate;
- point multiplier;
- booking window days;
- priority score;
- tier benefits;
- reward list;
- required points;
- reward type;
- reward value;
- service price;
- promotion title/type/value/target/status;
- report values;
- loyalty config như point expiry months;
- dashboard KPI;
- customer point/tier/spend/visit values.

JSP có thể có mock data tạm khi preview UI, nhưng code final phải dùng Servlet/DAO lấy từ database.

### BR-AS-GLOBAL-02 — Database canonical files

Repository nên chỉ giữ 2 file database chính:

- `schema.sql`: tạo database/schema.
- `sample-data.sql`: seed dữ liệu demo.

Không tạo nhiều file SQL rời rạc gây lệch database.

### BR-AS-GLOBAL-03 — Status phải chuẩn hóa

Không dùng status lung tung như `Done`, `Finish`, `Completed`, `complete`, `success` lẫn nhau. Stored values phải dùng chuẩn trong mục 8.

### BR-AS-GLOBAL-04 — Role check bắt buộc

Mọi route `/admin/*` phải kiểm tra:

1. User đã đăng nhập chưa.
2. User có `role_name = ADMIN` không.

Nếu chưa đăng nhập: chuyển về login.  
Nếu là Customer: chặn truy cập hoặc chuyển về trang không có quyền.

---

## 5. Database Data Contract

Database canonical hiện tại gồm các bảng chính sau:

1. `LoyaltyConfig`
2. `MembershipTier`
3. `Customer`
4. `Vehicle`
5. `Service`
6. `Booking`
7. `BookingService`
8. `BookingSlot`
9. `BookingPriorityAllocation`
10. `Reward`
11. `Redemption`
12. `LoyaltyPointBatch`
13. `LoyaltyTransaction`
14. `Promotion`
15. `CustomerPromotion`

### DC-AS-01 — LoyaltyConfig

Mục đích: lưu cấu hình chung của loyalty program.

Dữ liệu quan trọng:

- `config_key`
- `config_value`
- `description`
- `updated_at`

Ví dụ config:

- `point_expiry_months`
- `default_point_rate_amount`
- `default_voucher_valid_days`
- `loyalty_status`

Rule:

- Thời hạn hết hạn điểm phải lấy từ `LoyaltyConfig`, không hardcode số 12 trong code.
- Admin Loyalty Settings dùng bảng này.

### DC-AS-02 — MembershipTier

Mục đích: lưu hạng thành viên và rule của từng hạng.

Dữ liệu quan trọng:

- `tier_id`
- `tier_name`
- `tier_order`
- `min_spent_money`
- `min_visit_count`
- `point_rate`
- `point_multiplier`
- `booking_window_days`
- `priority_score`
- `reserved_slot_eligible`
- `benefits`
- `is_active`

Rule:

- Tier rule phải lấy từ database.
- Tier xét theo `active_spent_money_12m` hoặc `active_visit_count_12m`.
- `active_points` không dùng để xét hạng.
- Nếu nhiều tier cùng đạt điều kiện, chọn tier cao nhất theo `tier_order`.

### DC-AS-03 — Customer

Mục đích: lưu tài khoản, vai trò và loyalty summary của customer.

Dữ liệu quan trọng:

- `customer_id`
- `full_name`
- `phone`
- `email`
- `password`
- `role_name`
- `tier_id`
- `lifetime_spent_money`
- `lifetime_visit_count`
- `active_points`
- `active_spent_money_12m`
- `active_visit_count_12m`
- `total_spent_money`
- `total_points`

Rule:

- `role_name` chỉ được là `ADMIN` hoặc `CUSTOMER`.
- `lifetime_*` dùng cho report dài hạn.
- `active_*_12m` dùng cho loyalty hiện tại và tier review.
- `total_spent_money` và `total_points` chỉ giữ để tương thích app cũ, final logic nên ưu tiên active/lifetime fields.
- Password hiện có thể dùng plain text cho demo trường học, nhưng trong môi trường thật phải hash.

### DC-AS-04 — Vehicle

Mục đích: lưu xe của customer.

Dữ liệu quan trọng:

- `vehicle_id`
- `customer_id`
- `license_plate`
- `brand`
- `model`
- `color`

Rule:

- Mỗi xe thuộc một customer.
- Booking phải gắn với xe hợp lệ của customer.

### DC-AS-05 — Service

Mục đích: lưu dịch vụ rửa/chăm sóc xe.

Dữ liệu quan trọng:

- `service_id`
- `service_name`
- `price`
- `duration`
- `is_wash_service`
- `is_active`

Rule:

- Giá dịch vụ phải lấy từ DB.
- Reward type `FREE_SERVICE` hoặc `FREE_WASH` cần dùng dữ liệu service.
- Service inactive không nên cho customer chọn trong booking mới.

### DC-AS-06 — Booking

Mục đích: lưu booking của customer.

Dữ liệu quan trọng:

- `booking_id`
- `customer_id`
- `vehicle_id`
- `booking_date`
- `booking_time`
- `status`
- `original_amount`
- `discount_amount`
- `final_amount`
- `total_price`
- `applied_redemption_id`
- `loyalty_points_awarded`
- `loyalty_awarded_at`
- `priority_score`
- `cancel_reason`

Rule:

- `status` chỉ được là `PENDING`, `CONFIRMED`, `COMPLETED`, `CANCELLED`.
- Chỉ `COMPLETED` mới phát sinh điểm loyalty.
- `final_amount` là số tiền sau voucher/discount và là nền tính điểm.
- `loyalty_points_awarded = 1` nghĩa là booking đã được cộng điểm, không cộng lại.
- `total_price` giữ để tương thích code cũ và nên mirror `final_amount`.

### DC-AS-07 — BookingService

Mục đích: nối Booking với Service.

Dữ liệu quan trọng:

- `booking_id`
- `service_id`
- `quantity`
- `price`

Rule:

- Một booking có thể có nhiều service.
- Tổng `original_amount` nên được tính từ BookingService.

### DC-AS-08 — BookingSlot

Mục đích: lưu slot đặt lịch.

Dữ liệu quan trọng:

- `slot_date`
- `slot_time`
- `max_capacity`
- `reserved_vip_capacity`
- `current_confirmed`

Rule:

- Slot dùng để kiểm soát sức chứa.
- Priority booking có thể dùng capacity/reserved slot theo tier.

### DC-AS-09 — BookingPriorityAllocation

Mục đích: lưu kết quả phân bổ priority booking theo buổi/hạng.

Dữ liệu quan trọng:

- `booking_id`
- `booking_date`
- `shift_name`
- `slot_type`
- `slot_order`
- `tier_name`
- `priority_rank`

Rule:

- `shift_name`: `MORNING`, `AFTERNOON`, `EVENING`.
- `slot_type`: `MAIN`, `BACKUP`, `WAITING`.
- Higher tier có priority rank cao hơn.

### DC-AS-10 — Reward

Mục đích: lưu danh mục reward có thể đổi bằng điểm.

Dữ liệu quan trọng:

- `reward_id`
- `reward_name`
- `required_points`
- `description`
- `reward_type`
- `reward_value`
- `target_service_id`
- `valid_days`
- `is_active`

Rule:

- Reward type chỉ gồm: `FIXED_DISCOUNT`, `PERCENT_DISCOUNT`, `FREE_SERVICE`, `FREE_WASH`.
- Reward active mới được hiển thị cho customer redeem.
- `required_points` lấy từ DB.

### DC-AS-11 — Redemption

Mục đích: lưu voucher mà customer đã đổi từ điểm.

Dữ liệu quan trọng:

- `redemption_id`
- `customer_id`
- `reward_id`
- `points_used`
- `redeem_date`
- `valid_from`
- `valid_until`
- `status`
- `applied_booking_id`
- `used_at`

Rule:

- Redemption status: `AVAILABLE`, `USED`, `EXPIRED`, `CANCELLED`.
- Customer chỉ dùng voucher của chính mình.
- Mỗi voucher chỉ được gắn với tối đa một booking.
- Voucher `USED`, `EXPIRED`, `CANCELLED` không được dùng lại.

### DC-AS-12 — LoyaltyPointBatch

Mục đích: lưu từng đợt điểm được cộng để xử lý expiry và FIFO redeem.

Dữ liệu quan trọng:

- `point_batch_id`
- `customer_id`
- `source_booking_id`
- `earned_points`
- `remaining_points`
- `earned_at`
- `expires_at`
- `status`

Rule:

- Mỗi booking completed tạo tối đa một earned point batch.
- `remaining_points` giảm khi redeem.
- Khi hết hạn, chỉ phần `remaining_points` còn lại mới bị expire.
- Status: `ACTIVE`, `USED_UP`, `EXPIRED`.

### DC-AS-13 — LoyaltyTransaction

Mục đích: lưu lịch sử biến động điểm.

Dữ liệu quan trọng:

- `transaction_id`
- `customer_id`
- `booking_id`
- `redemption_id`
- `point_batch_id`
- `points`
- `transaction_type`
- `description`
- `created_at`

Rule:

- Transaction type: `EARNED`, `REDEEMED`, `EXPIRED`, `ADJUSTED`.
- `EARNED` là số dương.
- `REDEEMED` và `EXPIRED` là số âm.
- Cùng một booking không được có nhiều transaction `EARNED`.

### DC-AS-14 — Promotion

Mục đích: lưu promotion do Admin tạo.

Dữ liệu quan trọng:

- `promotion_id`
- `title`
- `description`
- `promotion_type`
- `promotion_value`
- `target_type`
- `target_tier_id`
- `start_date`
- `end_date`
- `status`
- `is_active`

Rule:

- Promotion type: `FIXED_DISCOUNT`, `PERCENT_DISCOUNT`, `FREE_SERVICE`, `FREE_WASH`.
- Target type: `ALL` hoặc `TIER`.
- Nếu `target_type = ALL`, `target_tier_id` phải null.
- Nếu `target_type = TIER`, `target_tier_id` phải có giá trị.
- Promotion status: `DRAFT`, `ACTIVE`, `EXPIRED`, `INACTIVE`.

### DC-AS-15 — CustomerPromotion

Mục đích: lưu promotion đã gửi vào inbox của từng customer.

Dữ liệu quan trọng:

- `customer_promotion_id`
- `promotion_id`
- `customer_id`
- `delivery_status`
- `sent_at`
- `viewed_at`
- `used_at`

Rule:

- Delivery status: `SENT`, `VIEWED`, `USED`.
- Một promotion không được gửi trùng cho cùng một customer.

---

## 6. Functional Requirements

### FR-AS-01 — Authentication and Role-based Access

Hệ thống phải hỗ trợ đăng nhập, đăng xuất và phân quyền theo role.

Business Rules:

- `role_name = CUSTOMER` được vào Customer pages.
- `role_name = ADMIN` được vào Admin pages.
- Guest chỉ được vào Login/Register trong scope hiện tại.
- Customer không được truy cập `/admin/*`.
- Admin routes phải kiểm tra role ở backend, không chỉ ẩn link ở JSP.

Acceptance Criteria:

- Guest vào `/admin/dashboard` bị chặn.
- Customer vào `/admin/dashboard` bị chặn.
- Admin vào được `/admin/dashboard`.
- Đăng xuất xong không thể back lại trang Admin/Customer private.

---

### FR-AS-02 — Customer Profile and Vehicle

Customer phải xem và cập nhật được thông tin profile/vehicle cơ bản theo chức năng app hiện tại.

Business Rules:

- Customer chỉ xem/sửa thông tin của chính mình.
- Vehicle phải gắn với customer hiện tại.
- License plate không được trùng.
- Tier/points hiển thị trong profile phải lấy từ DB.

Acceptance Criteria:

- Customer đăng nhập thấy profile của mình.
- Customer thấy xe đã liên kết.
- Customer không thấy/sửa xe của customer khác.

---

### FR-AS-03 — Customer Booking

Customer phải đặt được lịch rửa/chăm sóc xe theo service, vehicle, date/time hợp lệ.

Business Rules:

- Customer phải đăng nhập trước khi booking.
- Dịch vụ hiển thị trong booking phải lấy từ `Service`.
- Giá booking phải tính từ service database.
- Booking phải lưu `original_amount`, `discount_amount`, `final_amount`.
- Booking mới mặc định là `PENDING` hoặc theo flow cũ của app nếu đã có.
- Booking date phải tuân thủ booking window theo tier.

Acceptance Criteria:

- Customer tạo booking thành công với service từ DB.
- Booking lưu vào database.
- Booking không hardcode service price.
- Booking hiển thị trong booking history.

---

### FR-AS-04 — Tier-based Booking Window and Priority

Hệ thống phải hỗ trợ booking window và priority theo hạng thành viên.

Business Rules:

- `booking_window_days` lấy từ `MembershipTier`.
- Member/Silver/Gold/Platinum có thể có số ngày đặt trước khác nhau theo DB.
- Higher tier có priority cao hơn theo `priority_score` hoặc `tier_order`.
- Không dùng cột/tên cũ như `advance_booking_days` nếu schema chuẩn dùng `booking_window_days`.

Acceptance Criteria:

- Customer tier cao đặt được xa hơn nếu DB cấu hình như vậy.
- Customer vượt quá booking window bị chặn hoặc không chọn được ngày.
- Gold/Platinum được ưu tiên hơn khi cùng slot/buổi.

---

### FR-AS-05 — Booking Status Management

Hệ thống phải dùng status chuẩn cho booking.

Business Rules:

- Booking status chỉ gồm: `PENDING`, `CONFIRMED`, `COMPLETED`, `CANCELLED`.
- Chỉ booking `COMPLETED` được tính loyalty.
- Booking `CANCELLED` không được cộng điểm.
- Booking `PENDING`/`CONFIRMED` chưa được cộng điểm.

Acceptance Criteria:

- Booking completed có thể kích hoạt loyalty earning.
- Booking cancelled không tạo loyalty transaction.
- Status hiển thị tiếng Việt trên UI được phép, nhưng stored value phải chuẩn.

---

### FR-AS-06 — Booking Completed Earns Loyalty Points

Khi booking chuyển sang `COMPLETED`, hệ thống phải cộng điểm loyalty cho customer.

Business Rules:

- Mỗi booking chỉ được cộng điểm một lần.
- Kiểm tra `loyalty_points_awarded` và transaction `EARNED` trước khi cộng.
- Điểm tính theo `final_amount`, không theo `original_amount`.
- `point_rate` và `point_multiplier` lấy từ `MembershipTier`.
- Sau khi cộng điểm, tạo `LoyaltyPointBatch`.
- Sau khi cộng điểm, tạo `LoyaltyTransaction` type `EARNED`.
- Sau khi cộng điểm, cập nhật `Customer.active_points`, `active_spent_money_12m`, `active_visit_count_12m`, `lifetime_spent_money`, `lifetime_visit_count`.
- Sau khi cộng điểm thành công, set `Booking.loyalty_points_awarded = 1` và `loyalty_awarded_at`.

Acceptance Criteria:

- Completed booking cộng điểm đúng.
- Cùng booking completed lại lần nữa không cộng trùng.
- Điểm hiển thị trên Customer loyalty page.
- Có dòng lịch sử điểm `EARNED`.

---

### FR-AS-07 — Customer Loyalty Dashboard

Customer phải xem được loyalty dashboard.

Dashboard nên hiển thị:

- current tier;
- active points;
- active 12-month spend;
- active 12-month visits;
- lifetime spend;
- lifetime visits;
- next reward hoặc reward có thể đổi;
- point history;
- tier benefit.

Business Rules:

- Dữ liệu lấy từ `Customer`, `MembershipTier`, `LoyaltyTransaction`, `Reward`.
- Không hardcode điểm/hạng/benefit ở JSP.
- Customer chỉ xem loyalty data của chính mình.

Acceptance Criteria:

- Customer thấy đúng điểm/hạng từ DB.
- Sau booking completed, dashboard cập nhật điểm.
- Point history hiển thị EARNED/REDEEMED/EXPIRED.

---

### FR-AS-08 — Tier Review

Hệ thống phải tự xét lại hạng customer khi loyalty data thay đổi.

Business Rules:

- Tier review dựa trên `active_spent_money_12m` hoặc `active_visit_count_12m`.
- Không xét tier bằng `active_points`.
- Chọn tier cao nhất mà customer đạt điều kiện.
- Rule lấy từ `MembershipTier`.
- Khi active data giảm do expiry/refresh, customer có thể bị downgrade.

Acceptance Criteria:

- Customer đủ spend/visit được nâng hạng.
- Customer không đủ điều kiện sau refresh có thể bị hạ hạng.
- Tier hiển thị trên UI khớp DB.

---

### FR-AS-09 — Point Expiry

Hệ thống phải hỗ trợ điểm hết hạn theo từng batch.

Business Rules:

- Điểm được cộng từ booking tạo `LoyaltyPointBatch`.
- Mỗi batch có `earned_at`, `expires_at`, `earned_points`, `remaining_points`.
- Expiry duration lấy từ `LoyaltyConfig`, mặc định sample data là 12 tháng.
- Điểm hết hạn không được redeem.
- Khi batch hết hạn, chỉ expire phần `remaining_points` còn lại.
- Khi expire, tạo `LoyaltyTransaction` type `EXPIRED` với points âm.
- Customer `active_points` phải giảm tương ứng.

Acceptance Criteria:

- Batch quá hạn không còn được tính vào active points.
- Customer thấy lịch sử điểm hết hạn.
- Reward redemption không dùng điểm expired.

---

### FR-AS-10 — Reward Catalog

Customer phải xem được reward catalog từ database.

Business Rules:

- Reward active mới hiển thị cho customer.
- Reward phải lấy từ `Reward`, không hardcode trong JSP.
- Reward type gồm `FIXED_DISCOUNT`, `PERCENT_DISCOUNT`, `FREE_SERVICE`, `FREE_WASH`.
- UI nên cho biết customer có đủ điểm để redeem reward không.

Acceptance Criteria:

- Reward list hiển thị từ DB.
- Admin thay đổi reward thì customer page phản ánh thay đổi.
- Inactive reward không hiển thị hoặc không redeem được.

---

### FR-AS-11 — Redeem Points Into Voucher

Customer phải đổi được điểm active thành voucher/reward redemption.

Business Rules:

- Customer phải đăng nhập.
- Customer chỉ redeem reward active.
- Trước khi redeem, hệ thống phải refresh/kiểm tra active points.
- Customer phải có đủ active points.
- Redeem dùng điểm cũ trước theo FIFO.
- Tạo `Redemption` status `AVAILABLE`.
- Tạo `LoyaltyTransaction` type `REDEEMED` với points âm.
- Giảm `LoyaltyPointBatch.remaining_points` theo batch được dùng.
- Giảm `Customer.active_points`.

Acceptance Criteria:

- Customer đủ điểm redeem thành công.
- Voucher mới có status `AVAILABLE`.
- Active points giảm đúng.
- Customer không đủ điểm thì redeem thất bại.
- Có lịch sử điểm `REDEEMED`.

---

### FR-AS-12 — Apply Voucher To Booking

Customer phải dùng được voucher `AVAILABLE` trong booking.

Business Rules:

- Customer chỉ dùng voucher của chính mình.
- Chỉ voucher `AVAILABLE` được dùng.
- Một booking chỉ dùng tối đa một voucher.
- Một voucher chỉ gắn với tối đa một booking.
- Booking lưu `applied_redemption_id`.
- Redemption lưu `applied_booking_id` khi được dùng.
- Nếu booking completed, voucher chuyển `USED`.
- Nếu booking cancelled trước completed, voucher có thể trả về `AVAILABLE` theo policy của app.

Acceptance Criteria:

- Customer chọn voucher khi booking.
- Booking `discount_amount` và `final_amount` phản ánh voucher.
- Voucher không dùng lại được sau khi `USED`.
- Customer khác không dùng được voucher của người khác.

---

### FR-AS-13 — Reward Effect On Booking Amount

Hệ thống phải áp dụng reward/voucher đúng theo reward type.

Business Rules:

- `FIXED_DISCOUNT`: trừ số tiền cố định theo `reward_value`.
- `PERCENT_DISCOUNT`: trừ phần trăm theo `reward_value`.
- `FREE_SERVICE`: miễn phí service cụ thể theo `target_service_id`.
- `FREE_WASH`: miễn phí phần wash service chính theo `is_wash_service` hoặc target service config.
- `discount_amount` không được lớn hơn `original_amount`.
- `final_amount = original_amount - discount_amount`.
- Loyalty point sau completed tính theo `final_amount`.

Acceptance Criteria:

- Voucher fixed discount trừ đúng tiền.
- Voucher percent discount trừ đúng phần trăm.
- Voucher free service/free wash không làm final_amount âm.
- Điểm earned sau completed dựa trên final_amount.

---

### FR-AS-14 — Customer Vouchers Page

Customer phải xem được voucher của mình.

Business Rules:

- Hiển thị các voucher status `AVAILABLE`, `USED`, `EXPIRED`, `CANCELLED`.
- Customer chỉ xem voucher của chính mình.
- Voucher expired không được chọn khi booking.

Acceptance Criteria:

- Voucher mới sau redeem xuất hiện trong My Vouchers.
- Voucher used/expired hiển thị đúng status.

---

### FR-AS-15 — Promotion Delivery and Customer Inbox

Customer phải xem được promotion được gửi tới mình.

Business Rules:

- Admin tạo promotion trong `Promotion`.
- Khi send promotion, hệ thống tạo record trong `CustomerPromotion` cho customer phù hợp.
- `target_type = ALL`: gửi cho tất cả customer active.
- `target_type = TIER`: gửi cho customer có tier tương ứng.
- Customer chỉ xem promotion đã gửi cho mình.
- Promotion expired/inactive không nên hiển thị như ưu đãi có thể dùng.

Acceptance Criteria:

- Admin send promotion cho tier Gold thì Gold customer thấy.
- Customer không thuộc target tier không thấy promotion đó.
- Promotion ALL gửi cho mọi customer active.

---

### FR-AS-16 — Admin UI Shell

Admin module phải có UI riêng, không trộn vào Customer JSP bằng if/else role.

Admin UI chính gồm 6 JSP:

1. `admin-dashboard.jsp`
2. `tier-management.jsp`
3. `reward-management.jsp`
4. `loyalty-settings.jsp`
5. `promotion-management.jsp`
6. `report-dashboard.jsp`

Các component dùng chung:

- `admin-head.jspf`
- `admin-shell-start.jspf`
- `admin-shell-end.jspf`

Business Rules:

- Admin UI dùng style dark/premium đồng bộ với app hiện tại.
- Sidebar phải chuyển được giữa 6 trang.
- Mọi dữ liệu final phải lấy từ DB.
- Hardcode mock data chỉ được dùng ở prototype, không dùng ở bản final.

Acceptance Criteria:

- Admin mở được 6 trang.
- Sidebar không lỗi link.
- UI không vỡ layout.
- Customer không vào được Admin UI.

---

### FR-AS-17 — Admin Dashboard

Admin dashboard phải hiển thị tổng quan hệ thống.

Dữ liệu cần hiển thị:

- Total Customers.
- Completed Bookings.
- Total Revenue.
- Total Loyalty Points Issued.
- Rewards Redeemed.
- Active Promotions.
- Recent Completed Bookings.
- Recent Reward Redemptions.

Business Rules:

- KPI lấy từ DB.
- Revenue chỉ nên tính booking `COMPLETED`.
- Dashboard không hardcode số liệu.

Acceptance Criteria:

- Admin thấy KPI từ database.
- Booking completed mới tính vào revenue.
- Recent lists lấy từ dữ liệu thật.

---

### FR-AS-18 — Admin Tier Management

Admin phải quản lý được membership tiers.

Fields cần quản lý:

- tier name;
- tier order;
- min spent money;
- min visit count;
- point rate;
- point multiplier;
- booking window days;
- priority score;
- benefits;
- status/active.

Business Rules:

- Tier rule lấy/lưu trong `MembershipTier`.
- Không hardcode Member/Silver/Gold/Platinum trong JSP/Servlet.
- Sửa tier rule ảnh hưởng đến booking window, point earning, tier review.

Acceptance Criteria:

- Admin xem được tier từ DB.
- Admin sửa tier rule và lưu thành công.
- Customer page/booking logic dùng rule mới sau khi lưu.

---

### FR-AS-19 — Admin Reward Management

Admin phải quản lý được reward catalog.

Fields cần quản lý:

- reward name;
- required points;
- description;
- reward type;
- reward value;
- target service;
- valid days;
- active/inactive.

Business Rules:

- Reward lưu trong `Reward`.
- Target service list lấy từ `Service`.
- Inactive reward không redeem được.

Acceptance Criteria:

- Admin xem reward từ DB.
- Admin thêm/sửa reward.
- Customer reward catalog cập nhật theo DB.

---

### FR-AS-20 — Admin Loyalty Settings

Admin phải quản lý được cấu hình loyalty chung.

Settings tối thiểu:

- point expiry months;
- default point rate amount;
- default voucher validity days;
- loyalty program status.

Business Rules:

- Settings lưu trong `LoyaltyConfig`.
- Không hardcode số 12 tháng trong Java/JSP.
- Point expiry dùng config từ DB.

Acceptance Criteria:

- Admin xem config từ DB.
- Admin sửa config và lưu thành công.
- Logic expiry dùng config mới.

---

### FR-AS-21 — Admin Promotion Management

Admin phải tạo, sửa, kích hoạt và gửi promotion.

Fields cần quản lý:

- title;
- description;
- promotion type;
- promotion value;
- target type;
- target tier;
- start date;
- end date;
- status.

Business Rules:

- `target_type = ALL` hoặc `TIER`.
- Nếu target tier, tier list lấy từ DB.
- Send promotion tạo `CustomerPromotion`.
- Không gửi trùng promotion cho cùng customer.

Acceptance Criteria:

- Admin tạo promotion thành công.
- Admin gửi promotion theo tier thành công.
- Customer đúng tier thấy promotion.
- Customer sai tier không thấy promotion.

---

### FR-AS-22 — Admin Reports

Admin report page phải gộp 4 report trong một trang `report-dashboard.jsp`.

Reports gồm:

1. Customer Loyalty Report.
2. Booking & Revenue Report.
3. Reward Redemption Report.
4. Promotion Delivery Report.

Filters cơ bản:

- date from;
- date to;
- tier;
- status.

Business Rules:

- Report lấy từ database.
- Revenue report tính từ booking completed.
- Customer loyalty report lấy active/lifetime data.
- Reward redemption report lấy từ Redemption/LoyaltyTransaction.
- Promotion delivery report lấy từ Promotion/CustomerPromotion.

Acceptance Criteria:

- Admin xem được 4 report trên cùng trang.
- Filter hoạt động ở mức cơ bản.
- Không hardcode số liệu report.

---

### FR-AS-23 — Assessment Demo Flow

Hệ thống phải hỗ trợ demo flow đầy đủ cho Assessment.

Demo flow chính:

1. Guest vào Login/Register.
2. Guest đăng ký thành Customer hoặc dùng Customer sample data.
3. Customer đăng nhập.
4. Customer đặt booking.
5. Booking chuyển sang `COMPLETED`.
6. Hệ thống cộng điểm, cập nhật spend/visits và xét hạng.
7. Customer xem điểm, hạng và lịch sử điểm.
8. Customer redeem điểm thành voucher.
9. Customer dùng voucher trong booking sau.
10. Voucher chuyển `USED` khi booking liên quan completed.
11. Admin đăng nhập.
12. Admin cấu hình tier/reward/loyalty settings.
13. Admin tạo promotion theo tier.
14. Customer đúng tier thấy promotion.
15. Admin xem reports.

Acceptance Criteria:

- Demo chạy được từ đầu đến cuối bằng sample data hoặc dữ liệu tạo mới.
- Không cần AI/LPR/payment/feedback để hoàn thành demo.
- Mọi số liệu quan trọng lấy từ DB.

---

## 7. UI/UX Contract

### UI-AS-01 — Customer UI

Customer UI hiện tại đã có nền, không ưu tiên đập đi làm lại.

Các trang customer hiện có/cần giữ ổn định:

- `dashboard.jsp`
- `profile.jsp`
- `rewards.jsp`
- `washing-history.jsp`
- `booking.jsp`
- `booking-history.jsp`
- `booking-result.jsp`
- `advice.jsp` nếu app cũ còn dùng, nhưng không thuộc Assessment chính.

Rule:

- Không sửa Customer JSP lớn nếu không cần.
- Chỉ sửa khi cần kết nối DB-driven loyalty/reward/voucher/booking.
- Không trộn Admin UI vào Customer JSP.

### UI-AS-02 — Admin UI

Admin UI nằm trong khu vực riêng.

Cấu trúc prototype hiện tại có thể dùng:

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

Preview trực tiếp UI/UX có thể mở:

```text
/admin/pages/admin-dashboard.jsp
/admin/pages/tier-management.jsp
/admin/pages/reward-management.jsp
/admin/pages/loyalty-settings.jsp
/admin/pages/promotion-management.jsp
/admin/pages/report-dashboard.jsp
```

Final route khi code thật nên là:

```text
GET /admin/dashboard
GET /admin/tiers
GET /admin/rewards
GET /admin/loyalty-settings
GET /admin/promotions
GET /admin/reports
```

Save/action routes dự kiến:

```text
POST /admin/tiers/save
POST /admin/rewards/save
POST /admin/loyalty-settings/save
POST /admin/promotions/save
POST /admin/promotions/send
```

Rule:

- Preview direct JSP được phép trong giai đoạn UI/UX.
- Final implementation phải đi qua Servlet/Controller để role check và load DB data.
- CSS nên gọi bằng `${pageContext.request.contextPath}/admin/css/admin.css`.

### UI-AS-03 — Admin Components

`admin-head.jspf`:

- chứa meta, font, icon, CSS.

`admin-shell-start.jspf`:

- chứa layout mở đầu, sidebar, topbar.

`admin-shell-end.jspf`:

- đóng layout, script UI nhỏ nếu cần.

Rule:

- Component chỉ xử lý giao diện chung.
- Không đặt business calculation trong JSPF.

---

## 8. Status Standard

### ST-AS-01 — Booking Status

Stored values:

- `PENDING`
- `CONFIRMED`
- `COMPLETED`
- `CANCELLED`

Rule:

- Chỉ `COMPLETED` mới cộng điểm.

### ST-AS-02 — Redemption/Voucher Status

Stored values:

- `AVAILABLE`
- `USED`
- `EXPIRED`
- `CANCELLED`

Rule:

- Chỉ `AVAILABLE` mới được dùng trong booking.

### ST-AS-03 — Loyalty Point Batch Status

Stored values:

- `ACTIVE`
- `USED_UP`
- `EXPIRED`

Rule:

- Chỉ batch `ACTIVE` và chưa hết hạn mới dùng để redeem.

### ST-AS-04 — Loyalty Transaction Type

Stored values:

- `EARNED`
- `REDEEMED`
- `EXPIRED`
- `ADJUSTED`

Rule:

- `EARNED`: positive points.
- `REDEEMED`, `EXPIRED`: negative points.

### ST-AS-05 — Promotion Status

Stored values:

- `DRAFT`
- `ACTIVE`
- `EXPIRED`
- `INACTIVE`

Rule:

- Customer chỉ nên thấy promotion `ACTIVE` trong thời gian hợp lệ.

### ST-AS-06 — CustomerPromotion Delivery Status

Stored values:

- `SENT`
- `VIEWED`
- `USED`

---

## 9. Data Flow Summary

Phần này mô tả ở mức đủ để coder hiểu, không ép code theo một class cụ thể.

### DF-AS-01 — Booking Completed → Loyalty Earning

```text
Booking COMPLETED
→ kiểm tra chưa cộng điểm
→ lấy final_amount
→ lấy tier point_rate + point_multiplier từ DB
→ tính earned points
→ tạo LoyaltyPointBatch
→ tạo LoyaltyTransaction EARNED
→ cập nhật Customer active/lifetime data
→ xét lại tier
→ set Booking.loyalty_points_awarded = 1
```

### DF-AS-02 — Redeem Reward → Voucher

```text
Customer chọn reward
→ refresh active points/expired points
→ kiểm tra đủ điểm
→ trừ điểm theo FIFO từ LoyaltyPointBatch
→ tạo LoyaltyTransaction REDEEMED
→ tạo Redemption AVAILABLE
→ cập nhật Customer.active_points
```

### DF-AS-03 — Apply Voucher → Booking Amount

```text
Customer chọn AVAILABLE voucher
→ kiểm tra voucher thuộc customer
→ tính discount theo reward type
→ cập nhật Booking.applied_redemption_id
→ cập nhật Redemption.applied_booking_id
→ lưu original_amount, discount_amount, final_amount
```

### DF-AS-04 — Booking Completed With Voucher

```text
Booking có voucher chuyển COMPLETED
→ voucher chuyển USED
→ Redemption.used_at được set
→ loyalty points tính theo Booking.final_amount
```

### DF-AS-05 — Admin Send Promotion

```text
Admin tạo promotion
→ chọn target ALL hoặc TIER
→ bấm Send
→ hệ thống tìm customer phù hợp
→ tạo CustomerPromotion cho từng customer
→ customer thấy trong promotion inbox
```

---

## 10. Non-functional Requirements

### NFR-AS-01 — Response Time

95% thao tác người dùng nên phản hồi trong vòng 5 giây trong điều kiện demo/load bình thường.

### NFR-AS-02 — Booking Processing

Booking gồm tính loyalty/reward/voucher nên hoàn thành trong vòng 5 giây trong demo environment.

### NFR-AS-03 — Concurrent Users

Thiết kế nên hướng tới 500 concurrent users theo đề, nhưng bản PRJ301 có thể demo bằng dữ liệu nhỏ. Code không nên có truy vấn cực kỳ tệ hoặc loop DB vô hạn.

### NFR-AS-04 — Availability

Hệ thống hướng tới 99.5% uptime ngoài maintenance. Với scope môn học, cần app chạy ổn trên Tomcat local/demo.

### NFR-AS-05 — Backup

Database nên có backup hằng ngày trong môi trường thật. Với demo, cần giữ `schema.sql` và `sample-data.sql` để recreate DB nhanh.

### NFR-AS-06 — Security

- Role check ở backend.
- Không chỉ ẩn nút bằng CSS/JSP.
- Customer không được xem dữ liệu customer khác.
- Password nên hash trong môi trường thật.

### NFR-AS-07 — Maintainability

- Không hardcode business data.
- Không gom quá nhiều logic vào JSP.
- Servlet nhận request, DAO truy cập DB, JSP hiển thị.
- Admin JSP tách khỏi Customer JSP.

---

## 11. Test Scenarios

### TC-AS-01 — Admin Access Control

Steps:

1. Không đăng nhập, mở `/admin/dashboard`.
2. Đăng nhập Customer, mở `/admin/dashboard`.
3. Đăng nhập Admin, mở `/admin/dashboard`.

Expected:

- Guest bị chuyển login.
- Customer bị chặn.
- Admin vào được dashboard.

### TC-AS-02 — Booking Completed Earns Points

Steps:

1. Customer tạo booking.
2. Chuyển booking sang `COMPLETED`.
3. Mở loyalty dashboard.
4. Xem loyalty transaction.

Expected:

- Customer được cộng điểm.
- Có transaction `EARNED`.
- Booking có `loyalty_points_awarded = 1`.
- Completed lại không cộng trùng.

### TC-AS-03 — Cancelled Booking Does Not Earn Points

Steps:

1. Customer tạo booking.
2. Chuyển booking sang `CANCELLED`.
3. Xem điểm/lịch sử điểm.

Expected:

- Không cộng điểm.
- Không có transaction `EARNED`.

### TC-AS-04 — Redeem Points Into Voucher

Steps:

1. Customer có đủ active points.
2. Mở reward catalog.
3. Redeem reward.
4. Mở My Vouchers và point history.

Expected:

- Tạo voucher `AVAILABLE`.
- Active points giảm.
- Có transaction `REDEEMED`.

### TC-AS-05 — Apply Voucher To Booking

Steps:

1. Customer có voucher `AVAILABLE`.
2. Tạo booking mới và chọn voucher.
3. Kiểm tra amount.
4. Completed booking.

Expected:

- Booking có discount.
- `final_amount` đúng.
- Voucher chuyển `USED` khi completed.
- Loyalty points tính theo `final_amount`.

### TC-AS-06 — Point Expiry

Steps:

1. Có point batch quá hạn còn remaining points.
2. Chạy refresh/kiểm tra loyalty.
3. Xem active points và point history.

Expected:

- Expired points không còn trong active points.
- Có transaction `EXPIRED`.
- Batch chuyển `EXPIRED` hoặc phần còn lại bị expire.

### TC-AS-07 — Admin Tier Management

Steps:

1. Admin mở Tier Management.
2. Sửa booking window hoặc multiplier.
3. Lưu.
4. Mở lại trang.

Expected:

- Dữ liệu được lưu DB.
- UI hiển thị dữ liệu mới.
- Logic booking/point dùng dữ liệu mới.

### TC-AS-08 — Admin Reward Management

Steps:

1. Admin tạo reward mới.
2. Customer mở reward catalog.

Expected:

- Reward mới xuất hiện nếu active.
- Customer redeem được nếu đủ điểm.

### TC-AS-09 — Admin Promotion Target Tier

Steps:

1. Admin tạo promotion target Gold.
2. Admin send promotion.
3. Gold customer đăng nhập xem promotion.
4. Silver customer đăng nhập xem promotion.

Expected:

- Gold customer thấy promotion.
- Silver customer không thấy promotion đó.

### TC-AS-10 — Admin Reports

Steps:

1. Có booking completed, redemption, promotion delivery.
2. Admin mở report dashboard.
3. Dùng filter date/tier/status.

Expected:

- Report hiển thị số liệu từ DB.
- Revenue tính từ booking completed.
- Reward report có redemption.
- Promotion report có delivery status.

### TC-AS-11 — End-to-End Demo

Steps:

1. Register hoặc login customer sample.
2. Booking dịch vụ.
3. Completed booking.
4. Xem points/tier.
5. Redeem reward.
6. Dùng voucher cho booking sau.
7. Admin tạo promotion.
8. Customer xem promotion.
9. Admin xem report.

Expected:

- Demo hoàn chỉnh không cần AI/LPR/payment/feedback.
- Dữ liệu thay đổi thấy rõ trên UI.

---

## 12. Implementation Notes For Team

### IMPL-AS-01 — Không code tất cả trong JSP

JSP chỉ hiển thị. Không đặt logic tính điểm, xét hạng, tính revenue phức tạp trong JSP.

### IMPL-AS-02 — Servlet/Controller nên làm gì

Servlet/Controller nên:

- kiểm tra login/role;
- đọc request params;
- gọi DAO/service;
- set request attributes;
- forward JSP hoặc redirect.

### IMPL-AS-03 — DAO nên làm gì

DAO nên:

- truy vấn database;
- insert/update/delete data;
- không chứa HTML;
- không hardcode business display values.

### IMPL-AS-04 — JSP nên làm gì

JSP nên:

- hiển thị dữ liệu từ request/session attributes;
- dùng JSTL/EL;
- không hardcode business rows như tier/reward/report.

### IMPL-AS-05 — Admin prototype hardcode

Admin UI/UX prototype có thể còn mock data để xem giao diện. Khi làm code thật, phải thay bằng dữ liệu từ DB.

---

## 13. PR Review Checklist

Khi review PR, kiểm tra:

- PR có đúng scope không?
- PR có đụng module ngoài scope không?
- Có hardcode business data trong Java/JSP/Servlet không?
- Có lấy dữ liệu từ DB không?
- Có kiểm tra role Admin/Customer không?
- Customer có bị xem dữ liệu người khác không?
- Booking completed có chống cộng điểm trùng không?
- Reward/voucher có status đúng không?
- Point expiry có dùng LoyaltyConfig không?
- Admin UI có dùng 6 JSP đã chốt không?
- Report có lấy số liệu từ DB không?
- Có cập nhật schema/sample data nếu cần không?
- Có test scenario rõ không?

---

## 14. Future / Backlog

Các phần có thể làm sau Assessment chính:

- Guest public home/service/loyalty marketing pages.
- AI recommendation.
- LPR automation.
- Payment module.
- Feedback/review module.
- Mobile app customer.
- Admin audit log.
- Email/SMS promotion.
- Password hashing nếu chưa làm trong bản demo.

---

## 15. Definition of Done

Một chức năng được xem là hoàn thành khi:

1. Chạy được trên local Tomcat.
2. Dữ liệu lưu và đọc từ SQL Server.
3. Không hardcode business data.
4. Đúng role access.
5. UI không vỡ.
6. Có dữ liệu sample để demo.
7. Pass acceptance criteria trong SRS.
8. Không phá flow đang chạy của Customer/Admin khác.
9. Có thể giải thích được khi vấn đáp.

---

## 16. Final Assessment Success Criteria

App đạt mục tiêu Assessment khi demo được các điểm sau:

- Customer có account, xe, booking.
- Customer có tier, points, spend, visits.
- Booking completed cộng điểm.
- Customer xem được điểm/reward.
- Customer redeem điểm thành voucher.
- Customer dùng voucher trong booking.
- Điểm có expiry theo batch.
- Admin cấu hình tier/reward/loyalty settings.
- Admin tạo promotion theo tier/all.
- Customer nhận promotion phù hợp.
- Admin xem report.
- Dữ liệu chính lấy từ database.
- Không cần AI/LPR/payment/feedback để pass Assessment chính.
