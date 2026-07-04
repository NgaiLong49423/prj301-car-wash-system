# GI-02 — Customer Dashboard, Loyalty Overview and History

## Description
Trang tổng quan cho Khách hàng sau khi đăng nhập. Hiển thị thông tin hồ sơ, điểm loyalty hiện tại, hạng thành viên, lịch sử booking và điểm, cùng danh mục phần thưởng có thể đổi.

## Goal
Khách hàng theo dõi được toàn bộ thông tin loyalty và lịch sử hoạt động của mình một cách trực quan.

## FR Cover
FR-AS-03, FR-AS-04, FR-AS-05, FR-AS-06, FR-AS-13

## Metadata
- **Type:** Feature
- **Size:** L
- **Story Points:** 8
- **Priority:** Medium
- **Suggested Labels:** ✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database
- **Old Issue Mapping:** Mới

## Completion Checklist
- [ ] Customer mở trang rewards/loyalty.
- [ ] Hệ thống refresh active points nếu cần.
- [ ] Hệ thống lấy tier hiện tại từ Customer và MembershipTier.
- [ ] Hệ thống lấy reward active từ database.
- [ ] JSP hiển thị điểm, hạng và danh sách reward.
- [ ] Customer mở booking/washing history.
- [ ] Hệ thống lọc booking theo `customer_id` của session.
- [ ] Hệ thống hiển thị booking cùng trạng thái, ngày, dịch vụ và số tiền.

## Acceptance Criteria
**FR-AS-03:**

Customer thấy dữ liệu của chính mình, không thấy dữ liệu người khác.

**FR-AS-04:**
Không hardcode tier thresholds hoặc reward required points trong JSP.
Customer thấy điểm và hạng đúng theo database.

**FR-AS-05:**

Customer chỉ thấy booking của mình.

**FR-AS-06:**

Reward list lấy từ database và thay đổi theo cấu hình Admin.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #84`, `Fixes #84`, hoặc `Related to #84`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Dữ liệu hiển thị sai (ví dụ điểm loyalty bị sai lệch). Trang bị crash khi không có lịch sử booking.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
