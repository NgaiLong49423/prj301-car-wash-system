# GI-10 — Promotion Management and Customer Promotion Inbox

## Goal
**FR-AS-21 (Admin Promotion Management):**
Admin tạo, sửa và gửi promotion.

**FR-AS-23 (Customer xem promotion cá nhân):**
Customer xem promotion đã được gửi cho mình.

## Scope
**FR-AS-21:**
1. Admin tạo promotion.
2. Chọn target type ALL hoặc TIER.
3. Nếu TIER, chọn tier từ database.
4. Lưu promotion.
5. Khi bấm send, hệ thống tạo CustomerPromotion cho Customer phù hợp.

## Out of Scope
Các chức năng không nằm trong danh sách FR-AS trên.

## Acceptance Criteria
**FR-AS-21:**

Customer thuộc target thấy promotion trong trang cá nhân.

**FR-AS-23:**

Customer chỉ thấy promotion phù hợp với bản ghi CustomerPromotion của mình.

## Technical Notes
Tuân thủ thiết kế DB và các Rule từ Document/SRS.md.

## Suggested files likely affected
TBD - Cần xác định cụ thể trong lúc implementation.

## FR Traceability
Các functional requirements được gộp trong issue này:
- FR-AS-21, FR-AS-23

## Old GitHub issue mapping if any
#46

## Suggested labels
✨ Feature, 👑 Admin, 👤 Customer, 🎨 Frontend, ⚙️ Backend, 🗄️ Database

## Size / Story Points
- **Size:** M
- **Story Points:** 8

## Dependencies
GI-08

## Demo verification steps
1. Setup môi trường và test account.
2. Thực hiện các luồng công việc theo Acceptance Criteria.
3. Đảm bảo UI/UX mượt mà, Database ghi nhận log chính xác.
