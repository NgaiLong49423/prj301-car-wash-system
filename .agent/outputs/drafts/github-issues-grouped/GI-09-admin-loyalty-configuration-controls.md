# GI-09 — Admin Loyalty Configuration Controls

## Description
Quản lý các thông số cốt lõi: quy định hạng thành viên, danh sách phần thưởng, và tỷ lệ quy đổi điểm. Admin có thể thay đổi các thông số này.

## Goal
Admin có toàn quyền kiểm soát các quy định loyalty mà không cần sửa code (hoặc sửa ở database config).

## FR Cover
FR-AS-18, FR-AS-19, FR-AS-20

## Metadata
- **Type:** Admin
- **Size:** L
- **Story Points:** 8
- **Priority:** High
- **Suggested Labels:** ✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database
- **Old Issue Mapping:** #45

## Completion Checklist
- [ ] Hoàn thành logic theo thiết kế.

## Acceptance Criteria
**FR-AS-18:**

Sau khi Admin sửa tier, Customer và booking logic dùng dữ liệu mới từ database.

**FR-AS-19:**

Customer reward catalog phản ánh dữ liệu Admin cấu hình.

**FR-AS-20:**

Hệ thống không hardcode số tháng hết hạn điểm; cấu hình từ database được dùng khi tạo point batch.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #45`, `Fixes #45`, hoặc `Related to #45`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Config được thay đổi nhưng hệ thống vẫn tính theo logic hardcode cũ.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
