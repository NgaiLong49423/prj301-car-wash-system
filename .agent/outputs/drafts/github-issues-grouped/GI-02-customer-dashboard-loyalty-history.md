# GI-02 — Customer Dashboard, Loyalty Overview and History

## Goal
**FR-AS-03 (Customer xem dashboard cá nhân):**
Customer xem được trang tổng quan cá nhân gồm thông tin tài khoản, tier, điểm, voucher và booking gần đây nếu UI hiện tại hỗ trợ.
Customer cần biết trạng thái loyalty hiện tại để hiểu quyền lợi của mình.

**FR-AS-04 (Customer xem loyalty points, tier và next reward):**
Customer xem được điểm hiện tại, hạng thành viên hiện tại và reward có thể đổi hoặc reward tiếp theo.
Đây là yêu cầu trực tiếp của Loyalty Program và Customer Profile.

**FR-AS-05 (Customer xem booking history):**
Customer xem được lịch sử booking của chính mình.
Customer cần theo dõi các lần sử dụng dịch vụ, booking completed và booking đã hủy.

**FR-AS-06 (Customer xem reward catalog từ database):**
Customer xem được danh sách reward active có thể đổi bằng điểm.
Reward redemption là một phần chính của Assessment.

**FR-AS-13 (Customer xem point history):**
Customer có thể xem lịch sử biến động điểm gồm điểm cộng, điểm đã dùng và điểm hết hạn.
Customer cần hiểu vì sao điểm của mình tăng/giảm.

## Scope
**FR-AS-03:**
- Full name.
- Current tier.
- Active points.
- Active spend/visits nếu có.
- Booking gần đây.
- Voucher đang available.
- Promotion cá nhân nếu có.

**FR-AS-04:**
1. Customer mở trang rewards/loyalty.
2. Hệ thống refresh active points nếu cần.
3. Hệ thống lấy tier hiện tại từ Customer và MembershipTier.
4. Hệ thống lấy reward active từ database.
5. JSP hiển thị điểm, hạng và danh sách reward.

**FR-AS-05:**
1. Customer mở booking/washing history.
2. Hệ thống lọc booking theo `customer_id` của session.
3. Hệ thống hiển thị booking cùng trạng thái, ngày, dịch vụ và số tiền.

**FR-AS-06:**
- Reward name.
- Required points.
- Reward type.
- Reward value hoặc mô tả quyền lợi.
- Valid days.
- Trạng thái có đủ điểm hay chưa.

**FR-AS-13:**
- Transaction type.
- Points.
- Booking/reward liên quan nếu có.
- Thời gian tạo.
- Mô tả.

## Out of Scope
Các chức năng không nằm trong danh sách FR-AS trên.

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

## Technical Notes
Tuân thủ thiết kế DB và các Rule từ Document/SRS.md.

## Suggested files likely affected
TBD - Cần xác định cụ thể trong lúc implementation.

## FR Traceability
Các functional requirements được gộp trong issue này:
- FR-AS-03, FR-AS-04, FR-AS-05, FR-AS-06, FR-AS-13

## Old GitHub issue mapping if any
Mới

## Suggested labels
✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database, 👤 Customer

## Size / Story Points
- **Size:** L
- **Story Points:** 8

## Dependencies
GI-01

## Demo verification steps
1. Setup môi trường và test account.
2. Thực hiện các luồng công việc theo Acceptance Criteria.
3. Đảm bảo UI/UX mượt mà, Database ghi nhận log chính xác.
