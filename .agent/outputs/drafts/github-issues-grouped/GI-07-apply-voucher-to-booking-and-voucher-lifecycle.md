# GI-07 — Apply Voucher to Booking and Voucher Lifecycle

## Description
Luồng áp dụng Voucher vào Booking để tính tiền giảm giá, đồng thời quản lý vòng đời Voucher (khi nào thì USED, khi nào thì EXPIRED).

## Goal
Tính toán đúng số tiền giảm giá và khóa các Voucher đã sử dụng hoặc hết hạn.

## FR Cover
FR-AS-15, FR-AS-16

## Metadata
- **Type:** Core
- **Size:** M
- **Story Points:** 8
- **Priority:** High
- **Suggested Labels:** ✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database, 🧪 Testing
- **Old Issue Mapping:** Mới

## Completion Checklist
- [ ] Hoàn thành logic theo thiết kế.

## Acceptance Criteria
**FR-AS-15:**

Booking lưu voucher đã áp dụng, discount amount và final amount được tính đúng.

**FR-AS-16:**

Voucher không bị dùng lại, không dùng được khi expired/cancelled, và chuyển `USED` khi booking liên quan completed.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #85`, `Fixes #85`, hoặc `Related to #85`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Voucher USED, EXPIRED hoặc CANCELLED vẫn dùng lại được. Một voucher được dùng cho nhiều booking. Một booking áp dụng nhiều voucher trong scope hiện tại.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
