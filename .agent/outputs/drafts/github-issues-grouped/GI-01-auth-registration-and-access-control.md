# GI-01 — Auth, Registration and Access Control

## Description
Cung cấp tính năng đăng nhập, đăng ký cho Customer và xử lý phân quyền truy cập. Giới hạn Guest chỉ xem được tối thiểu.

## Goal
Người dùng có thể tạo tài khoản, đăng nhập thành công và bị chặn truy cập nếu không đúng role.

## FR Cover
FR-AS-01, FR-AS-02, FR-AS-27

## Metadata
- **Type:** Feature
- **Size:** M
- **Story Points:** 5
- **Priority:** High
- **Suggested Labels:** ✨ Feature, 🎨 Frontend, ⚙️ Backend
- **Old Issue Mapping:** Mới

## Completion Checklist
- [ ] Guest truy cập trang Register.
- [ ] Guest nhập thông tin cần thiết để tạo tài khoản Customer.
- [ ] Hệ thống lưu Customer mới vào database với role `CUSTOMER`.
- [ ] User đăng nhập bằng thông tin tài khoản.
- [ ] Hệ thống kiểm tra email/password và role.
- [ ] Nếu là Customer, chuyển vào khu vực Customer.
- [ ] Nếu là Admin, chuyển vào Admin Dashboard.
- [ ] User đăng nhập.
- [ ] Hệ thống lưu thông tin user và role trong session.
- [ ] Khi user truy cập một URL, hệ thống kiểm tra đã đăng nhập chưa.
- [ ] Nếu URL là `/admin/*`, hệ thống kiểm tra role có phải `ADMIN` không.
- [ ] Nếu không đủ quyền, hệ thống chặn truy cập.

## Acceptance Criteria
**FR-AS-01:**
Email không được trùng. Role phải là `CUSTOMER` hoặc `ADMIN`. Người chưa đăng nhập không được vào trang cần quyền.
Người dùng đăng ký, đăng nhập và được chuyển đúng khu vực theo role.

**FR-AS-02:**

Customer không vào được Admin pages. Người chưa đăng nhập bị chuyển về Login.

**FR-AS-27:**

Không cần làm public guest UI nâng cao trong scope chính, nhưng demo vẫn có thể nói Guest register to become Customer.

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #83`, `Fixes #83`, hoặc `Related to #83`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- Guest truy cập được trang cần đăng nhập. Customer truy cập được Admin page. Mã hóa mật khẩu (nếu có) bị lỗi.
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
