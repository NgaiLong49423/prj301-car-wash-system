# GI-05 — Point Batch Expiry and Active Points Refresh

## Goal
**FR-AS-12 (Point expiry theo từng batch):**
Hệ thống quản lý điểm hết hạn theo từng batch điểm.
Đề yêu cầu points expire after 12 months. Cách theo batch giúp biết điểm nào hết hạn và còn bao nhiêu điểm.

## Scope
TBD

## Out of Scope
Các chức năng không nằm trong danh sách FR-AS trên.

## Acceptance Criteria
**FR-AS-12:**

Điểm expired bị loại khỏi active points và không redeem được.

## Technical Notes
IMPORTANT: Do NOT require Quartz, Spring Task, SQL Agent Job, or a nightly scheduler. In this PRJ301 Servlet/JSP scope, expiry should be event-based: refresh when Customer opens loyalty dashboard, before redeeming reward, when booking completed earns points, and when Admin reports need active data.

## Suggested files likely affected
TBD - Cần xác định cụ thể trong lúc implementation.

## FR Traceability
Các functional requirements được gộp trong issue này:
- FR-AS-12

## Old GitHub issue mapping if any
#44

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
