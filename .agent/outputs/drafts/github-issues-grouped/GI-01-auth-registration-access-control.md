# GI-01 — Auth, Registration and Access Control

## Goal
**FR-AS-01 (Đăng ký và đăng nhập cơ bản):**
Hệ thống cho phép người dùng đăng ký tài khoản Customer, đăng nhập và đăng xuất.
Customer phải có tài khoản để hệ thống gắn booking, điểm, voucher và promotion cá nhân. Admin cần đăng nhập để vào khu vực quản trị.

**FR-AS-02 (Phân quyền Admin/Customer):**
Hệ thống phân biệt quyền truy cập giữa Admin và Customer.
Admin có quyền cấu hình hệ thống và xem report, Customer chỉ được thao tác với dữ liệu của chính mình.

**FR-AS-27 (Guest registration access tối thiểu):**
Guest chỉ cần vào được Login/Register để đăng ký thành Customer.

## Scope
**FR-AS-01:**
1. Guest truy cập trang Register.
2. Guest nhập thông tin cần thiết để tạo tài khoản Customer.
3. Hệ thống lưu Customer mới vào database với role `CUSTOMER`.
4. User đăng nhập bằng thông tin tài khoản.
5. Hệ thống kiểm tra email/password và role.
6. Nếu là Customer, chuyển vào khu vực Customer.
7. Nếu là Admin, chuyển vào Admin Dashboard.

**FR-AS-02:**
1. User đăng nhập.
2. Hệ thống lưu thông tin user và role trong session.
3. Khi user truy cập một URL, hệ thống kiểm tra đã đăng nhập chưa.
4. Nếu URL là `/admin/*`, hệ thống kiểm tra role có phải `ADMIN` không.
5. Nếu không đủ quyền, hệ thống chặn truy cập.

## Out of Scope
Các chức năng không nằm trong danh sách FR-AS trên.

## Acceptance Criteria
**FR-AS-01:**
Email không được trùng. Role phải là `CUSTOMER` hoặc `ADMIN`. Người chưa đăng nhập không được vào trang cần quyền.
Người dùng đăng ký, đăng nhập và được chuyển đúng khu vực theo role.

**FR-AS-02:**

Customer không vào được Admin pages. Người chưa đăng nhập bị chuyển về Login.

**FR-AS-27:**

Không cần làm public guest UI nâng cao trong scope chính, nhưng demo vẫn có thể nói Guest register to become Customer.

## Technical Notes
Tuân thủ thiết kế DB và các Rule từ Document/SRS.md.

## Suggested files likely affected
TBD - Cần xác định cụ thể trong lúc implementation.

## FR Traceability
Các functional requirements được gộp trong issue này:
- FR-AS-01, FR-AS-02, FR-AS-27

## Old GitHub issue mapping if any
Mới

## Suggested labels
✨ Feature, 🎨 Frontend, ⚙️ Backend

## Size / Story Points
- **Size:** M
- **Story Points:** 5

## Dependencies
None

## Demo verification steps
1. Setup môi trường và test account.
2. Thực hiện các luồng công việc theo Acceptance Criteria.
3. Đảm bảo UI/UX mượt mà, Database ghi nhận log chính xác.
