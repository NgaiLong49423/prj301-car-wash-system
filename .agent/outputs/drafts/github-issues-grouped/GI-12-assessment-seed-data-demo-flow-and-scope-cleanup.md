# GI-12 — Assessment Seed Data, Demo Flow and Scope Cleanup

## Description
Chuẩn bị dữ liệu mẫu (sample data), dọn dẹp các module nằm ngoài scope đánh giá và thiết lập luồng Demo hoàn chỉnh.

## Goal
Dự án sạch sẽ, chạy luột và có đủ dữ liệu (quá khứ) để demo tính năng expiry/tier review ngay lập tức.

## FR Cover
FR-AS-24, FR-AS-25, FR-AS-29, FR-AS-30

## Metadata
- **Type:** QA
- **Size:** M
- **Story Points:** 5
- **Priority:** High
- **Suggested Labels:** 📚 Documentation, 🧪 Testing, ⚙️ Backend, 🗄️ Database
- **Old Issue Mapping:** Mới

## Completion Checklist
- [ ] Hoàn thành logic theo thiết kế.

## Acceptance Criteria
**FR-AS-24:**

Chạy database sample xong có thể demo ngay.

**FR-AS-29:**

Khi sửa dữ liệu trong database hoặc Admin UI, màn hình Customer/Admin phản ánh thay đổi.

**FR-AS-30:**

App Assessment không phụ thuộc vào các bảng hoặc màn hình ngoài scope này.

---

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #87`, `Fixes #87`, hoặc `Related to #87`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- PR xóa hoặc phá dữ liệu seed cần cho demo Assessment. Gắn module ngoài scope làm phình to dự án.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
