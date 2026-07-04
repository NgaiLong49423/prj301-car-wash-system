# GI-04 — Tier Review and Active 12-Month Loyalty Data

## Description
Định kỳ hoặc theo sự kiện, hệ thống quét dữ liệu chi tiêu (active spend) và số lần đến (active visits) trong 12 tháng qua để xét lên hạng, giữ hạng hoặc giáng hạng thành viên.

## Goal
Tự động xét lại hạng thành viên một cách chính xác dựa trên dữ liệu hoạt động 12 tháng gần nhất.

## FR Cover
FR-AS-11

## Metadata
- **Type:** Core
- **Size:** M
- **Story Points:** 5
- **Priority:** High
- **Suggested Labels:** ✨ Feature, ⚙️ Backend, 🗄️ Database, 🧪 Testing
- **Old Issue Mapping:** #42, #58

## Completion Checklist
- [ ] Hệ thống refresh active loyalty data.
- [ ] Lấy danh sách tier active từ database.
- [ ] Sắp tier từ cao xuống thấp.
- [ ] Gán tier cao nhất mà Customer đạt điều kiện.

## Acceptance Criteria
**FR-AS-11:**

Customer được nâng/hạ hạng theo dữ liệu active hiện tại.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #42`, `Fixes #42`, hoặc `Related to #42`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Khách hàng đủ điều kiện nhưng không được lên hạng. Tính toán 12-month data bị sai lệch.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
