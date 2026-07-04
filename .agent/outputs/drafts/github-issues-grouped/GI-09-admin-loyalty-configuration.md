# GI-09 — Admin Loyalty Configuration Controls

## Goal
**FR-AS-18 (Admin Tier Management):**
Admin xem và chỉnh cấu hình tier.

**Dữ liệu quản lý:**

- Tier name.
- Min spent money.
- Min visit count.
- Point multiplier.
- Booking window days.
- Priority score.
- Benefits.
- Status.

**FR-AS-19 (Admin Reward Management):**
Admin quản lý reward catalog.

**Dữ liệu quản lý:**

- Reward name.
- Required points.
- Reward type.
- Reward value.
- Target service.
- Valid days.
- Active/inactive.

**FR-AS-20 (Admin Loyalty Settings):**
Admin quản lý cấu hình loyalty chung.

**Dữ liệu quản lý:**

- Point expiry months.
- Point rate amount.
- Default voucher valid days.
- Loyalty status.

## Scope
TBD

## Out of Scope
Các chức năng không nằm trong danh sách FR-AS trên.

## Acceptance Criteria
**FR-AS-18:**

Sau khi Admin sửa tier, Customer và booking logic dùng dữ liệu mới từ database.

**FR-AS-19:**

Customer reward catalog phản ánh dữ liệu Admin cấu hình.

**FR-AS-20:**

Hệ thống không hardcode số tháng hết hạn điểm; cấu hình từ database được dùng khi tạo point batch.

## Technical Notes
Tuân thủ thiết kế DB và các Rule từ Document/SRS.md.

## Suggested files likely affected
TBD - Cần xác định cụ thể trong lúc implementation.

## FR Traceability
Các functional requirements được gộp trong issue này:
- FR-AS-18, FR-AS-19, FR-AS-20

## Old GitHub issue mapping if any
#45

## Suggested labels
✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database

## Size / Story Points
- **Size:** L
- **Story Points:** 8

## Dependencies
GI-08

## Demo verification steps
1. Setup môi trường và test account.
2. Thực hiện các luồng công việc theo Acceptance Criteria.
3. Đảm bảo UI/UX mượt mà, Database ghi nhận log chính xác.
