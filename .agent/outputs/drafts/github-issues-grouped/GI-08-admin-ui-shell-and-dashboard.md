# GI-08 — Admin UI Shell and Dashboard

## Description
Khung giao diện chính (Shell) dành cho Admin, chứa thanh điều hướng và màn hình thống kê nhanh (tổng doanh thu, tổng user mới).

## Goal
Cung cấp không gian làm việc an toàn và thống nhất cho Admin.

## FR Cover
FR-AS-17, FR-AS-26

## Metadata
- **Type:** Admin
- **Size:** M
- **Story Points:** 5
- **Priority:** Medium
- **Suggested Labels:** ✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend
- **Old Issue Mapping:** Mới

## Completion Checklist
- [ ] Hoàn thành logic theo thiết kế.

## Acceptance Criteria
**FR-AS-17:**

Admin dashboard hiển thị số liệu từ database.

**FR-AS-26:**

Admin UI đồng bộ giao diện, không trộn vào Customer JSP.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #86`, `Fixes #86`, hoặc `Related to #86`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Trang Admin vỡ layout hoặc truy cập được từ Customer.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
