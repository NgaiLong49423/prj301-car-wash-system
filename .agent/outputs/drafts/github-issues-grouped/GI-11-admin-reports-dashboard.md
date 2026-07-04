# GI-11 — Admin Reports Dashboard

## Description
Hệ thống báo cáo gồm báo cáo doanh thu, booking và thống kê khách hàng (số liệu loyalty).

## Goal
Hiển thị số liệu chính xác để ban quản lý đưa ra quyết định kinh doanh.

## FR Cover
FR-AS-22

## Metadata
- **Type:** Admin
- **Size:** M
- **Story Points:** 8
- **Priority:** Medium
- **Suggested Labels:** ✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database
- **Old Issue Mapping:** #47, #48

## Completion Checklist
- [ ] Hoàn thành logic theo thiết kế.

## Acceptance Criteria
**FR-AS-22:**

Report hiển thị dữ liệu thật từ database.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #47`, `Fixes #47`, hoặc `Related to #47`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Report dùng số fake/static làm kết quả chính.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
