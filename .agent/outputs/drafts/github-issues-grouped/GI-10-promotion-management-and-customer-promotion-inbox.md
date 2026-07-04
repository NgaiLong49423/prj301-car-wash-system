# GI-10 — Promotion Management and Customer Promotion Inbox

## Description
Admin có thể soạn và gửi khuyến mãi nhắm mục tiêu theo Hạng. Khách hàng có hộp thư (Inbox) để xem khuyến mãi cá nhân.

## Goal
Đưa thông điệp marketing chính xác đến nhóm khách hàng mục tiêu.

## FR Cover
FR-AS-21, FR-AS-23

## Metadata
- **Type:** Feature
- **Size:** M
- **Story Points:** 8
- **Priority:** Medium
- **Suggested Labels:** ✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database
- **Old Issue Mapping:** #46

## Completion Checklist
- [ ] Admin tạo promotion.
- [ ] Chọn target type ALL hoặc TIER.
- [ ] Nếu TIER, chọn tier từ database.
- [ ] Lưu promotion.
- [ ] Khi bấm send, hệ thống tạo CustomerPromotion cho Customer phù hợp.

## Acceptance Criteria
**FR-AS-21:**

Customer thuộc target thấy promotion trong trang cá nhân.

**FR-AS-23:**

Customer chỉ thấy promotion phù hợp với bản ghi CustomerPromotion của mình.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #46`, `Fixes #46`, hoặc `Related to #46`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Khuyến mãi gửi nhầm đối tượng hoặc không hiển thị trong hộp thư khách hàng.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
