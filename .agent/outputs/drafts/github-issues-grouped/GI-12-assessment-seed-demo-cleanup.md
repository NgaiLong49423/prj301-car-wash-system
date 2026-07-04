# GI-12 — Assessment Seed Data, Demo Flow and Scope Cleanup

## Goal
**FR-AS-24 (Seed data cho demo Assessment):**
Hệ thống cần dữ liệu mẫu đủ để demo toàn bộ luồng Assessment.

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

**FR-AS-25 (End-to-end Assessment demo flow):**
Hệ thống phải hỗ trợ demo hoàn chỉnh.

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

**FR-AS-29 (Database-driven display values):**
Các giá trị hiển thị quan trọng phải lấy từ database.

**FR-AS-30 (Loại bỏ hoặc không dùng module ngoài scope):**
Các module AI recommendation, LPR log, payment, feedback và queue log không thuộc scope chính hiện tại.

## Scope
TBD

## Out of Scope
Các chức năng không nằm trong danh sách FR-AS trên.

## Acceptance Criteria
**FR-AS-24:**

Chạy database sample xong có thể demo ngay.

**FR-AS-29:**

Khi sửa dữ liệu trong database hoặc Admin UI, màn hình Customer/Admin phản ánh thay đổi.

**FR-AS-30:**

App Assessment không phụ thuộc vào các bảng hoặc màn hình ngoài scope này.

---

## Technical Notes
Note: FR-AS-29 Database-driven display values should be treated as a cross-cutting checklist applied to all issues, not only as a standalone feature. FR-AS-30 should be treated as cleanup/scope control.

## Suggested files likely affected
TBD - Cần xác định cụ thể trong lúc implementation.

## FR Traceability
Các functional requirements được gộp trong issue này:
- FR-AS-24, FR-AS-25, FR-AS-29, FR-AS-30

## Old GitHub issue mapping if any
Mới

## Suggested labels
📚 Documentation, 🧪 Testing, ⚙️ Backend, 🗄️ Database

## Size / Story Points
- **Size:** M
- **Story Points:** 5

## Dependencies
GI-01 -> GI-11

## Demo verification steps
1. Setup môi trường và test account.
2. Thực hiện các luồng công việc theo Acceptance Criteria.
3. Đảm bảo UI/UX mượt mà, Database ghi nhận log chính xác.
