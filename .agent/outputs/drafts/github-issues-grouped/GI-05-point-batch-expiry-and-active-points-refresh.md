# GI-05 — Point Batch Expiry and Active Points Refresh

## Description
Kiểm tra và trừ các điểm loyalty đã quá hạn 12 tháng. Hệ thống thiết kế theo hướng event-based (chạy tính toán khi mở trang hoặc trước khi dùng điểm) thay vì dùng background scheduler.

## Goal
Khách hàng bị trừ điểm hết hạn tự động, số điểm active luôn là số đã trừ hết hạn.

## FR Cover
FR-AS-12

## Metadata
- **Type:** Core
- **Size:** M
- **Story Points:** 5
- **Priority:** High
- **Suggested Labels:** ✨ Feature, ⚙️ Backend, 🗄️ Database, 🧪 Testing
- **Old Issue Mapping:** #44

## Completion Checklist
- [ ] Hoàn thành logic theo thiết kế.

## Acceptance Criteria
**FR-AS-12:**

Điểm expired bị loại khỏi active points và không redeem được.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #44`, `Fixes #44`, hoặc `Related to #44`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Điểm quá hạn không bị trừ, dẫn đến việc dùng điểm hết hạn để redeem reward.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
