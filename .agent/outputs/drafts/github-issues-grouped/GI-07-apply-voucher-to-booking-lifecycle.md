# GI-07 — Apply Voucher to Booking and Voucher Lifecycle

## Goal
**FR-AS-15 (Apply voucher to booking):**
Customer có thể chọn voucher `AVAILABLE` của mình để áp dụng vào booking.
Redemption không chỉ là trừ điểm, mà phải tạo được lợi ích thực tế trong booking sau.

**FR-AS-16 (Voucher lifecycle management):**
Hệ thống quản lý trạng thái voucher từ lúc tạo đến lúc dùng hoặc hết hạn.

## Scope
TBD

## Out of Scope
Các chức năng không nằm trong danh sách FR-AS trên.

## Acceptance Criteria
**FR-AS-15:**

Booking lưu voucher đã áp dụng, discount amount và final amount được tính đúng.

**FR-AS-16:**

Voucher không bị dùng lại, không dùng được khi expired/cancelled, và chuyển `USED` khi booking liên quan completed.

## Technical Notes
Tuân thủ thiết kế DB và các Rule từ Document/SRS.md.

## Suggested files likely affected
TBD - Cần xác định cụ thể trong lúc implementation.

## FR Traceability
Các functional requirements được gộp trong issue này:
- FR-AS-15, FR-AS-16

## Old GitHub issue mapping if any
Mới

## Suggested labels
✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database, 🧪 Testing

## Size / Story Points
- **Size:** M
- **Story Points:** 8

## Dependencies
GI-06

## Demo verification steps
1. Setup môi trường và test account.
2. Thực hiện các luồng công việc theo Acceptance Criteria.
3. Đảm bảo UI/UX mượt mà, Database ghi nhận log chính xác.
