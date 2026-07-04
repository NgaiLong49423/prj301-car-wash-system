# GI-06 — Reward Redemption into Voucher

## Description
Chức năng cho phép Khách hàng dùng điểm active loyalty để đổi lấy Voucher (Mã giảm giá). Cần kiểm tra kỹ số dư điểm và trừ điểm hợp lệ.

## Goal
Khách hàng đổi điểm lấy voucher thành công và điểm bị trừ chính xác.

## FR Cover
FR-AS-14

## Metadata
- **Type:** Core
- **Size:** M
- **Story Points:** 5
- **Priority:** High
- **Suggested Labels:** ✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database
- **Old Issue Mapping:** #43

## Completion Checklist
- [ ] Customer chọn reward.
- [ ] Hệ thống kiểm tra reward active.
- [ ] Hệ thống refresh điểm active.
- [ ] Hệ thống kiểm tra Customer đủ điểm.
- [ ] Hệ thống trừ điểm theo FIFO.
- [ ] Hệ thống tạo Redemption status `AVAILABLE`.
- [ ] Hệ thống tạo LoyaltyTransaction `REDEEMED`.

## Acceptance Criteria
**FR-AS-14:**

Customer nhận voucher và active points giảm đúng.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #43`, `Fixes #43`, hoặc `Related to #43`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Redeem reward bằng điểm đã hết hạn. Đổi voucher thành công nhưng không bị trừ điểm.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
