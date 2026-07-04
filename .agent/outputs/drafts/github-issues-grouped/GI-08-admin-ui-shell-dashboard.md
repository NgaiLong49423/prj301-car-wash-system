# GI-08 — Admin UI Shell and Dashboard

## Goal
**FR-AS-17 (Admin Dashboard):**
Admin có trang dashboard tổng quan.

**Dữ liệu hiển thị:**

- Tổng số Customer.
- Số booking completed.
- Tổng doanh thu.
- Tổng điểm đã phát sinh.
- Số reward đã redeem.
- Số promotion active.
- Recent completed bookings.
- Recent redemptions.

**FR-AS-26 (Admin UI 6 JSP tách riêng):**
Admin UI phải gồm 6 trang chính tách riêng và dùng component chung.

**Danh sách JSP:**

- `admin-dashboard.jsp`
- `tier-management.jsp`
- `reward-management.jsp`
- `loyalty-settings.jsp`
- `promotion-management.jsp`
- `report-dashboard.jsp`

## Scope
TBD

## Out of Scope
Các chức năng không nằm trong danh sách FR-AS trên.

## Acceptance Criteria
**FR-AS-17:**

Admin dashboard hiển thị số liệu từ database.

**FR-AS-26:**

Admin UI đồng bộ giao diện, không trộn vào Customer JSP.

## Technical Notes
Tuân thủ thiết kế DB và các Rule từ Document/SRS.md.

## Suggested files likely affected
TBD - Cần xác định cụ thể trong lúc implementation.

## FR Traceability
Các functional requirements được gộp trong issue này:
- FR-AS-17, FR-AS-26

## Old GitHub issue mapping if any
Mới

## Suggested labels
✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend

## Size / Story Points
- **Size:** M
- **Story Points:** 5

## Dependencies
GI-01

## Demo verification steps
1. Setup môi trường và test account.
2. Thực hiện các luồng công việc theo Acceptance Criteria.
3. Đảm bảo UI/UX mượt mà, Database ghi nhận log chính xác.
