# GI-04 — Tier Review and Active 12-Month Loyalty Data

## Goal
**FR-AS-11 (Tier review theo active spend hoặc active visits):**
Hệ thống xét lại hạng thành viên dựa trên `active_spent_money_12m` hoặc `active_visit_count_12m`.
Đề yêu cầu auto upgrade/downgrade; nhóm đã chọn cơ chế event-based thay vì monthly review cứng.

## Scope
**FR-AS-11:**
1. Hệ thống refresh active loyalty data.
2. Lấy danh sách tier active từ database.
3. Sắp tier từ cao xuống thấp.
4. Gán tier cao nhất mà Customer đạt điều kiện.

## Out of Scope
Các chức năng không nằm trong danh sách FR-AS trên.

## Acceptance Criteria
**FR-AS-11:**

Customer được nâng/hạ hạng theo dữ liệu active hiện tại.

## Technical Notes
Tuân thủ thiết kế DB và các Rule từ Document/SRS.md.

## Suggested files likely affected
TBD - Cần xác định cụ thể trong lúc implementation.

## FR Traceability
Các functional requirements được gộp trong issue này:
- FR-AS-11

## Old GitHub issue mapping if any
#42, #58

## Suggested labels
✨ Feature, ⚙️ Backend, 🗄️ Database, 🧪 Testing

## Size / Story Points
- **Size:** M
- **Story Points:** 5

## Dependencies
GI-03

## Demo verification steps
1. Setup môi trường và test account.
2. Thực hiện các luồng công việc theo Acceptance Criteria.
3. Đảm bảo UI/UX mượt mà, Database ghi nhận log chính xác.
