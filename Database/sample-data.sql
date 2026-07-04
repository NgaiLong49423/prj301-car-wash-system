/*
  AutoWashPro_DB - Sample data for PRJ301 Assessment
  Purpose: Run after schema.sql.
  This file contains demo-ready data for booking, loyalty earning, tier review,
  redemption/voucher usage, promotions, and admin reports.
*/

USE AutoWashPro_DB;
GO

/* =========================
   1. Config and tiers
   ========================= */
INSERT INTO LoyaltyConfig (config_key, config_value, description) VALUES
('POINT_EXPIRY_MONTHS', '12', N'Số tháng điểm loyalty còn hiệu lực'),
('DEFAULT_VOUCHER_VALID_DAYS', '90', N'Số ngày voucher mặc định còn hiệu lực sau khi đổi'),
('LOYALTY_PUBLIC_DESCRIPTION', N'Khách hàng tích điểm sau mỗi booking hoàn thành và dùng điểm để đổi ưu đãi.', N'Nội dung giới thiệu loyalty cho guest/customer');
GO

INSERT INTO MembershipTier (
    tier_name, tier_order, min_points, discount_percent, min_spent_money, min_visit_count,
    point_rate, point_multiplier, booking_window_days, priority_score, reserved_slot_eligible, benefits, is_active
) VALUES
('Member', 1, 0, 0.00, 0, 0, 1000, 1.00, 7, 10, 0, N'1 điểm cho mỗi 1.000 VND thực trả.', 1),
('Silver', 2, 2000, 0.00, 2000000, 5, 1000, 1.10, 10, 20, 0, N'+10% điểm, ưu tiên slot hơn Member.', 1),
('Gold', 3, 6000, 0.00, 6000000, 15, 1000, 1.20, 12, 30, 1, N'+20% điểm, quyền lợi nâng cấp dịch vụ theo cấu hình.', 1),
('Platinum', 4, 15000, 0.00, 15000000, 30, 1000, 1.30, 14, 40, 1, N'+30% điểm, quyền lợi VIP và free wash theo cấu hình.', 1);
GO

/* =========================
   2. Accounts / customers
   Passwords are plain text only for school demo compatibility.
   ========================= */
INSERT INTO Customer (
    full_name, phone, email, [password], role_name, tier_id,
    lifetime_spent_money, lifetime_visit_count,
    active_points, active_spent_money_12m, active_visit_count_12m,
    total_spent_money, total_points
) VALUES
(N'AutoWash Admin', '0900000000', 'admin@autowash.vn', '123456', 'ADMIN', 1, 0, 0, 0, 0, 0, 0, 0),
(N'Ngô Gia Long', '0987654321', 'long@gmail.com', '123456', 'CUSTOMER', 1, 800000, 2, 500, 800000, 2, 800000, 500),
(N'Nguyễn An Vương', '0912345678', 'vuong@gmail.com', '123456', 'CUSTOMER', 2, 2400000, 1, 2640, 2400000, 1, 2400000, 2640),
(N'Trần Công Danh', '0922334455', 'danh@gmail.com', '123456', 'CUSTOMER', 3, 7070000, 3, 7984, 7070000, 3, 7070000, 7984),
(N'Nguyễn Nhật Anh', '0933445566', 'anh@gmail.com', '123456', 'CUSTOMER', 4, 15500000, 1, 20150, 15500000, 1, 15500000, 20150),
(N'Hoàng Thu Hằng', '0944556677', 'hang@gmail.com', '123456', 'CUSTOMER', 1, 4500000, 2, 1500, 1500000, 1, 1500000, 1500);
GO

/* =========================
   3. Vehicles and services
   ========================= */
INSERT INTO Vehicle (customer_id, license_plate, brand, model, color) VALUES
(2, '61B1-123.45', 'Honda', 'Civic', N'Trắng'),
(3, '29A1-234.56', 'Toyota', 'Camry', N'Bạc'),
(4, '36A1-456.78', 'Mazda', 'CX-5', N'Đỏ'),
(5, '92C1-567.89', 'BMW', '320i', N'Đen'),
(6, '79A1-678.90', 'Kia', 'Cerato', N'Trắng');
GO

INSERT INTO Service (service_name, price, duration, is_wash_service, is_active) VALUES
(N'Rửa xe cơ bản', 100000, 30, 1, 1),
(N'Gói Premium Combo', 800000, 150, 1, 1),
(N'Vệ sinh nội thất', 200000, 45, 0, 1),
(N'Đánh bóng ngoại thất', 300000, 90, 0, 1),
(N'Phủ Ceramic', 1500000, 120, 0, 1),
(N'Phủ sáp bảo vệ', 250000, 60, 0, 1),
(N'Gói Gold Full Care', 5300000, 240, 1, 1),
(N'Gói Platinum Detailing', 15500000, 360, 1, 1),
(N'Gói Silver Care', 2400000, 180, 1, 1),
(N'Gói Quick Care', 500000, 60, 1, 1);
GO

/* =========================
   4. Rewards catalogue
   ========================= */
INSERT INTO Reward (reward_name, required_points, description, reward_type, reward_value, target_service_id, valid_days, is_active) VALUES
(N'Free Wax - Phủ sáp miễn phí', 300, N'Đổi điểm lấy một lần phủ sáp bảo vệ miễn phí.', 'FREE_SERVICE', 0, 6, 90, 1),
(N'Giảm giá 10%', 500, N'Giảm 10% cho booking tiếp theo.', 'PERCENT_DISCOUNT', 10, NULL, 90, 1),
(N'Giảm 50.000 VND', 200, N'Giảm trực tiếp 50.000 VND cho booking tiếp theo.', 'FIXED_DISCOUNT', 50000, NULL, 60, 1),
(N'Free Basic Wash - Rửa xe cơ bản miễn phí', 1000, N'Miễn phí phần dịch vụ rửa xe cơ bản.', 'FREE_WASH', 0, 1, 90, 1);
GO

/* =========================
   5. Bookings and booking services
   Status values follow SRS standard: PENDING, CONFIRMED, COMPLETED, CANCELLED.
   total_price mirrors final_amount for old code compatibility.
   ========================= */
INSERT INTO Booking (
    customer_id, vehicle_id, booking_date, booking_time, status,
    total_price, original_amount, discount_amount, final_amount,
    loyalty_points_awarded, loyalty_awarded_at, priority_score
) VALUES
(2, 1, '2026-06-01', '08:00:00', 'COMPLETED', 300000, 300000, 0, 300000, 1, '2026-06-01 09:00:00', 10),
(2, 1, '2026-06-10', '14:00:00', 'COMPLETED', 500000, 500000, 0, 500000, 1, '2026-06-10 15:00:00', 10),
(3, 2, '2026-06-15', '09:00:00', 'COMPLETED', 2400000, 2400000, 0, 2400000, 1, '2026-06-15 11:00:00', 20),
(4, 3, '2026-06-16', '10:00:00', 'COMPLETED', 1500000, 1500000, 0, 1500000, 1, '2026-06-16 12:00:00', 30),
(4, 3, '2026-06-18', '13:00:00', 'COMPLETED', 5300000, 5300000, 0, 5300000, 1, '2026-06-18 16:00:00', 30),
(5, 4, '2026-06-20', '08:30:00', 'COMPLETED', 15500000, 15500000, 0, 15500000, 1, '2026-06-20 14:00:00', 40),
(6, 5, '2025-03-01', '09:30:00', 'COMPLETED', 3000000, 3000000, 0, 3000000, 1, '2025-03-01 11:00:00', 10),
(6, 5, '2026-06-22', '15:00:00', 'COMPLETED', 1500000, 1500000, 0, 1500000, 1, '2026-06-22 17:00:00', 10),
(3, 2, '2026-07-10', '10:00:00', 'PENDING', 800000, 800000, 0, 800000, 0, NULL, 20),
(4, 3, '2026-06-25', '09:00:00', 'COMPLETED', 270000, 300000, 30000, 270000, 1, '2026-06-25 10:00:00', 30),
(5, 4, '2026-07-12', '18:00:00', 'CONFIRMED', 800000, 800000, 0, 800000, 0, NULL, 40),
(2, 1, '2026-07-13', '19:00:00', 'CANCELLED', 100000, 100000, 0, 100000, 0, NULL, 10);
GO

INSERT INTO BookingService (booking_id, service_id, quantity, price) VALUES
(1, 1, 1, 100000),
(1, 3, 1, 200000),
(2, 10, 1, 500000),
(3, 9, 1, 2400000),
(4, 5, 1, 1500000),
(5, 7, 1, 5300000),
(6, 8, 1, 15500000),
(7, 5, 2, 1500000),
(8, 5, 1, 1500000),
(9, 2, 1, 800000),
(10, 4, 1, 300000),
(11, 2, 1, 800000),
(12, 1, 1, 100000);
GO

INSERT INTO BookingSlot (slot_date, slot_time, max_capacity, reserved_vip_capacity, current_confirmed) VALUES
('2026-07-10', '10:00:00', 3, 1, 0),
('2026-07-12', '18:00:00', 3, 1, 1),
('2026-07-13', '19:00:00', 3, 1, 0);
GO

INSERT INTO BookingPriorityAllocation (booking_id, booking_date, shift_name, slot_type, slot_order, tier_name, priority_rank) VALUES
(9, '2026-07-10', 'MORNING', 'WAITING', NULL, 'Silver', 20),
(11, '2026-07-12', 'EVENING', 'MAIN', 1, 'Platinum', 40);
GO

/* =========================
   6. Redemptions / vouchers and booking usage
   ========================= */
INSERT INTO Redemption (customer_id, reward_id, points_used, redeem_date, valid_from, valid_until, status, applied_booking_id, used_at) VALUES
(2, 1, 300, '2026-06-11 10:00:00', '2026-06-11 10:00:00', '2026-09-09 23:59:59', 'AVAILABLE', NULL, NULL),
(4, 2, 500, '2026-06-24 10:00:00', '2026-06-24 10:00:00', '2026-09-22 23:59:59', 'USED', 10, '2026-06-25 10:00:00'),
(5, 4, 1000, '2026-01-01 10:00:00', '2026-01-01 10:00:00', '2026-03-31 23:59:59', 'EXPIRED', NULL, NULL);
GO

UPDATE Booking SET applied_redemption_id = 2 WHERE booking_id = 10;
GO

/* =========================
   7. Loyalty point batches and transactions
   Points expire by batch. Redeem uses old active points first.
   ========================= */
INSERT INTO LoyaltyPointBatch (customer_id, source_booking_id, earned_points, remaining_points, earned_at, expires_at, status) VALUES
(2, 1, 300, 0, '2026-06-01 09:00:00', '2027-06-01 09:00:00', 'USED_UP'),
(2, 2, 500, 500, '2026-06-10 15:00:00', '2027-06-10 15:00:00', 'ACTIVE'),
(3, 3, 2640, 2640, '2026-06-15 11:00:00', '2027-06-15 11:00:00', 'ACTIVE'),
(4, 4, 1800, 1300, '2026-06-16 12:00:00', '2027-06-16 12:00:00', 'ACTIVE'),
(4, 5, 6360, 6360, '2026-06-18 16:00:00', '2027-06-18 16:00:00', 'ACTIVE'),
(4, 10, 324, 324, '2026-06-25 10:00:00', '2027-06-25 10:00:00', 'ACTIVE'),
(5, 6, 20150, 20150, '2026-06-20 14:00:00', '2027-06-20 14:00:00', 'ACTIVE'),
(6, 7, 3000, 0, '2025-03-01 11:00:00', '2026-03-01 11:00:00', 'EXPIRED'),
(6, 8, 1500, 1500, '2026-06-22 17:00:00', '2027-06-22 17:00:00', 'ACTIVE');
GO

INSERT INTO LoyaltyTransaction (customer_id, booking_id, redemption_id, point_batch_id, points, transaction_type, description, created_at) VALUES
(2, 1, NULL, 1, 300, 'EARNED', N'Cộng điểm từ booking COMPLETED #1', '2026-06-01 09:00:00'),
(2, 2, NULL, 2, 500, 'EARNED', N'Cộng điểm từ booking COMPLETED #2', '2026-06-10 15:00:00'),
(2, NULL, 1, 1, -300, 'REDEEMED', N'Đổi điểm lấy Free Wax', '2026-06-11 10:00:00'),
(3, 3, NULL, 3, 2640, 'EARNED', N'Cộng điểm theo hạng Silver', '2026-06-15 11:00:00'),
(4, 4, NULL, 4, 1800, 'EARNED', N'Cộng điểm theo hạng Gold', '2026-06-16 12:00:00'),
(4, 5, NULL, 5, 6360, 'EARNED', N'Cộng điểm theo hạng Gold', '2026-06-18 16:00:00'),
(4, NULL, 2, 4, -500, 'REDEEMED', N'Đổi điểm lấy voucher giảm 10%', '2026-06-24 10:00:00'),
(4, 10, NULL, 6, 324, 'EARNED', N'Cộng điểm theo final amount sau giảm giá', '2026-06-25 10:00:00'),
(5, 6, NULL, 7, 20150, 'EARNED', N'Cộng điểm theo hạng Platinum', '2026-06-20 14:00:00'),
(6, 7, NULL, 8, 3000, 'EARNED', N'Điểm cũ đã quá hạn', '2025-03-01 11:00:00'),
(6, NULL, NULL, 8, -3000, 'EXPIRED', N'Điểm batch #8 hết hạn sau 12 tháng', '2026-03-01 11:00:00'),
(6, 8, NULL, 9, 1500, 'EARNED', N'Cộng điểm từ booking mới trong 12 tháng', '2026-06-22 17:00:00');
GO

/* =========================
   8. Payments, feedback, LPR
   ========================= */
INSERT INTO Payment (booking_id, amount, payment_method, payment_status, transaction_code, paid_at) VALUES
(1, 300000, N'Cash', 'COMPLETED', 'PAY001', '2026-06-01 09:05:00'),
(2, 500000, N'Credit Card', 'COMPLETED', 'PAY002', '2026-06-10 15:05:00'),
(3, 2400000, N'Bank Transfer', 'COMPLETED', 'PAY003', '2026-06-15 11:05:00'),
(4, 1500000, N'Credit Card', 'COMPLETED', 'PAY004', '2026-06-16 12:05:00'),
(5, 5300000, N'Bank Transfer', 'COMPLETED', 'PAY005', '2026-06-18 16:05:00'),
(6, 15500000, N'Bank Transfer', 'COMPLETED', 'PAY006', '2026-06-20 14:05:00'),
(7, 3000000, N'Cash', 'COMPLETED', 'PAY007', '2025-03-01 11:05:00'),
(8, 1500000, N'Credit Card', 'COMPLETED', 'PAY008', '2026-06-22 17:05:00'),
(9, 0, N'Cash', 'PENDING', 'PAY009', NULL),
(10, 270000, N'Cash', 'COMPLETED', 'PAY010', '2026-06-25 10:05:00'),
(11, 0, N'Cash', 'PENDING', 'PAY011', NULL);
GO

INSERT INTO Feedback (customer_id, booking_id, rating, comment, created_at) VALUES
(2, 1, 5, N'Dịch vụ nhanh và sạch.', '2026-06-01 10:00:00'),
(3, 3, 4, N'Gói Silver Care ổn, nhân viên tư vấn rõ.', '2026-06-15 12:00:00'),
(4, 5, 5, N'Gói Gold Full Care rất tốt.', '2026-06-18 17:00:00'),
(5, 6, 5, N'Dịch vụ Platinum xứng đáng.', '2026-06-20 15:00:00');
GO

INSERT INTO LPRLog (vehicle_id, detected_plate, checkin_time, confidence_score) VALUES
(1, '61B1-123.45', '2026-06-01 07:55:00', 0.9999),
(2, '29A1-234.56', '2026-06-15 08:55:00', 0.9997),
(3, '36A1-456.78', '2026-06-18 12:55:00', 0.9996),
(4, '92C1-567.89', '2026-06-20 08:25:00', 0.9998),
(5, '79A1-678.90', '2026-06-22 14:55:00', 0.9995);
GO

/* =========================
   9. Promotions and targeted delivery inbox
   ========================= */
INSERT INTO Promotion (
    title, description, promotion_type, promotion_value, discount_percent,
    target_tier_id, target_tier, start_date, end_date, status, is_active
) VALUES
(N'Silver Summer 10% Off', N'Ưu đãi 10% cho khách Silver trong mùa hè.', 'PERCENT_DISCOUNT', 10, 10, 2, N'Silver', '2026-07-01', '2026-08-31', 'ACTIVE', 1),
(N'Gold Free Wax Weekend', N'Khách Gold nhận ưu đãi phủ sáp miễn phí cuối tuần.', 'FREE_SERVICE', 0, 0, 3, N'Gold', '2026-07-01', '2026-07-31', 'ACTIVE', 1),
(N'Platinum VIP Wash', N'Ưu đãi rửa xe VIP cho khách Platinum.', 'FREE_WASH', 0, 0, 4, N'Platinum', '2026-07-01', '2026-09-30', 'ACTIVE', 1),
(N'Old Member Campaign', N'Khuyến mãi cũ đã hết hạn.', 'PERCENT_DISCOUNT', 15, 15, 1, N'Member', '2026-01-01', '2026-02-01', 'EXPIRED', 0);
GO

INSERT INTO CustomerPromotion (promotion_id, customer_id, delivery_status, sent_at, viewed_at) VALUES
(1, 3, 'SENT', '2026-07-01 08:00:00', NULL),
(2, 4, 'VIEWED', '2026-07-01 08:05:00', '2026-07-01 09:00:00'),
(3, 5, 'SENT', '2026-07-01 08:10:00', NULL),
(4, 2, 'SENT', '2026-01-01 08:00:00', NULL),
(4, 6, 'SENT', '2026-01-01 08:00:00', NULL);
GO

INSERT INTO AIRecommendation (customer_id, promotion_id, recommendation_reason, created_at) VALUES
(3, 1, N'Khách Silver phù hợp với ưu đãi mùa hè.', '2026-07-01 08:30:00'),
(4, 2, N'Khách Gold có lịch sử dùng dịch vụ chăm sóc ngoại thất.', '2026-07-01 08:35:00'),
(5, 3, N'Khách Platinum phù hợp ưu đãi VIP.', '2026-07-01 08:40:00');
GO

PRINT 'sample-data.sql completed: demo data inserted.';
GO
