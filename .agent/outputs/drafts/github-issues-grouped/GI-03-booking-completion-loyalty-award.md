# GI-03 — Booking Completion Loyalty Award

## Description
Xử lý logic quan trọng nhất: Khi Booking chuyển trạng thái COMPLETED, hệ thống sẽ tính toán và cộng điểm loyalty tự động dựa trên số tiền thực trả (final amount), đồng thời cập nhật Lifetime và 12-Month active data.

## Goal
Tính và cộng đúng điểm loyalty khi hoàn thành dịch vụ, chống cộng trùng lặp.

## FR Cover
FR-AS-07, FR-AS-08, FR-AS-09, FR-AS-10, FR-AS-28

## Metadata
- **Type:** Core
- **Size:** L
- **Story Points:** 13
- **Priority:** High
- **Suggested Labels:** ✨ Feature, ⚙️ Backend, 🗄️ Database
- **Old Issue Mapping:** #41

## Completion Checklist
- [ ] Booking được chuyển sang `COMPLETED`.
- [ ] Hệ thống kiểm tra booking đã được cộng điểm chưa.
- [ ] Nếu chưa, hệ thống tính điểm dựa trên `final_amount` và rule từ tier/config.
- [ ] Hệ thống tạo point batch.
- [ ] Hệ thống tạo loyalty transaction `EARNED`.
- [ ] Hệ thống cập nhật Customer loyalty summary.
- [ ] Hệ thống xét lại tier.
- [ ] Hệ thống đánh dấu booking đã được cộng điểm.

## Acceptance Criteria
**FR-AS-07:**

Booking completed làm tăng điểm, spend, visits và có lịch sử điểm tương ứng.

**FR-AS-08:**
Booking phải có dấu hiệu đã award loyalty, ví dụ `loyalty_points_awarded` và transaction unique cho `EARNED` theo booking.
Cùng một booking completed nhiều lần hoặc gọi lại logic không làm tăng điểm lần hai.

**FR-AS-09:**

Điểm earned dùng `final_amount`, không dùng `original_amount`.

**FR-AS-10:**

Customer summary phản ánh đúng dữ liệu sau thao tác loyalty.

**FR-AS-28:**

Không dùng lẫn lộn `Done`, `Finish`, `Completed`, `complete` trong database/code.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #41`, `Fixes #41`, hoặc `Related to #41`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Booking PENDING, CONFIRMED, CANCELLED vẫn được cộng điểm. Booking COMPLETED bị cộng điểm nhiều hơn một lần. Tính điểm theo original_amount thay vì final_amount.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
