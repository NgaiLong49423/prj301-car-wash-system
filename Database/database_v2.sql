/* PROJECT: Vehicle Service Management System - AutoWash Pro
   ENGINE: Microsoft SQL Server
   VERSION: Database V2 (Updated for FR-09 & FR-10a)
   INSTRUCTION: Chỉ cần chạy file này, toàn bộ Database, Bảng, Ràng buộc, Index và Dữ liệu mẫu (Seed) sẽ được cấu hình tự động.
*/

-- 1. Xóa Database cũ nếu tồn tại, sau đó tạo Database mới
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'AutoWashPro_DB')
BEGIN
    ALTER DATABASE AutoWashPro_DB SET MULTI_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AutoWashPro_DB;
END
GO

CREATE DATABASE AutoWashPro_DB;
GO

USE AutoWashPro_DB;
GO

-- 2. Tạo bảng MembershipTier (Hạng thành viên)
CREATE TABLE MembershipTier (
    tier_id INT PRIMARY KEY IDENTITY(1,1),
    tier_name VARCHAR(50) NOT NULL,
    min_points INT DEFAULT 0,
    discount_percent DECIMAL(5,2),
    benefits NVARCHAR(MAX),
    priority_score INT DEFAULT 10,
    booking_window_days INT NOT NULL DEFAULT 7,
    reserved_slot_eligible BIT DEFAULT 0
);

-- 3. Tạo bảng Customer (Khách hàng)
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    [password] NVARCHAR(255),
    avatar_url NVARCHAR(500),
    join_date DATETIME DEFAULT GETDATE(),
    total_spent_money DECIMAL(18,2) DEFAULT 0,  -- Tiền đã chi tiêu (dùng cho FR-10a tích lũy)
    total_points INT DEFAULT 0,  -- Điểm khả dụng hiện tại (dùng để hiển thị/đổi quà)
    tier_id INT,
    CONSTRAINT FK_Customer_Tier FOREIGN KEY (tier_id) REFERENCES MembershipTier(tier_id)
);

-- 4. Tạo bảng Vehicle (Phương tiện)
CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    brand NVARCHAR(50),
    model NVARCHAR(50),
    color NVARCHAR(30),
    CONSTRAINT FK_Vehicle_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- 5. Tạo bảng Service (Dịch vụ)
CREATE TABLE Service (
    service_id INT PRIMARY KEY IDENTITY(1,1),
    service_name NVARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    duration INT -- tính bằng phút
);

-- 6. Tạo bảng Booking (Đặt lịch)
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    vehicle_id INT,
    booking_date DATE,
    booking_time TIME,
    status NVARCHAR(50),
    total_price DECIMAL(18,2),
    requested_at DATETIME DEFAULT GETDATE(),
    priority_score INT DEFAULT 10,
    queue_position INT NULL,
    estimated_start_time TIME NULL,
    cancel_reason NVARCHAR(255) NULL,
    CONSTRAINT FK_Booking_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_Booking_Vehicle FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

CREATE TABLE BookingSlot (
    slot_id INT PRIMARY KEY IDENTITY(1,1),
    slot_date DATE NOT NULL,
    slot_time TIME NOT NULL,
    max_capacity INT NOT NULL DEFAULT 3,
    reserved_vip_capacity INT DEFAULT 1,
    current_confirmed INT DEFAULT 0,
    CONSTRAINT UQ_BookingSlot UNIQUE (slot_date, slot_time)
);

CREATE TABLE BookingQueueLog (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT NOT NULL,
    old_status NVARCHAR(50),
    new_status NVARCHAR(50),
    reason NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_BookingQueueLog_Booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- 7. Tạo bảng BookingService (Bảng trung gian Dịch vụ trong Booking)
CREATE TABLE BookingService (
    booking_id INT,
    service_id INT,
    quantity INT DEFAULT 1,
    price DECIMAL(18,2),
    PRIMARY KEY (booking_id, service_id),
    CONSTRAINT FK_BS_Booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    CONSTRAINT FK_BS_Service FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

-- 8. Tạo bảng Reward (Phần thưởng)
CREATE TABLE Reward (
    reward_id INT PRIMARY KEY IDENTITY(1,1),
    reward_name NVARCHAR(100),
    required_points INT,
    description NVARCHAR(MAX)
);

-- 9. Tạo bảng Redemption (Đổi thưởng)
CREATE TABLE Redemption (
    redemption_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    reward_id INT,
    redeem_date DATETIME DEFAULT GETDATE(),
    status NVARCHAR(50),
    CONSTRAINT FK_Redemption_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_Redemption_Reward FOREIGN KEY (reward_id) REFERENCES Reward(reward_id)
);

-- 10. Tạo bảng Promotion (Khuyến mãi)
CREATE TABLE Promotion (
    promotion_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(200),
    discount_percent DECIMAL(5,2),
    start_date DATE,
    end_date DATE,
    target_tier NVARCHAR(50)
);

-- 11. Tạo bảng AIRecommendation (Gợi ý AI)
CREATE TABLE AIRecommendation (
    recommendation_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    promotion_id INT,
    recommendation_reason NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_AI_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_AI_Promotion FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id)
);

-- 12. Tạo bảng LoyaltyTransaction (Giao dịch tích điểm)
CREATE TABLE LoyaltyTransaction (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    booking_id INT,
    points INT,
    transaction_type VARCHAR(50), -- E.g., 'Earned', 'Spent'
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_LT_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_LT_Booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- 13. Tạo bảng LPRLog (Lịch sử nhận diện biển số)
CREATE TABLE LPRLog (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    vehicle_id INT,
    detected_plate VARCHAR(20),
    checkin_time DATETIME DEFAULT GETDATE(),
    confidence_score DECIMAL(5,4),
    CONSTRAINT FK_LPR_Vehicle FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

-- 14. Tạo bảng Feedback (Đánh giá)
CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    booking_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_FB_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_FB_Booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- 15. Tạo bảng Payment (Thanh toán)
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT,
    amount DECIMAL(18,2),
    payment_method NVARCHAR(50),
    payment_status NVARCHAR(50),
    transaction_code VARCHAR(100),
    paid_at DATETIME,
    CONSTRAINT FK_Payment_Booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

-- 16. Tạo bảng BookingPriorityAllocation (Tương thích với Workshop 2 và HiddenPriorityBookingDAO)
CREATE TABLE BookingPriorityAllocation (
    allocation_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT NOT NULL,
    booking_date DATE NOT NULL,
    shift_name VARCHAR(20) NOT NULL,
    slot_type VARCHAR(20) NOT NULL,
    slot_order INT NULL,
    tier_name VARCHAR(20) NOT NULL,
    priority_rank INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_BookingPriorityAllocation_Booking
        FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    CONSTRAINT CK_BookingPriorityAllocation_Shift
        CHECK (shift_name IN ('MORNING', 'AFTERNOON')),
    CONSTRAINT CK_BookingPriorityAllocation_Type
        CHECK (slot_type IN ('MAIN', 'BACKUP', 'WAITING'))
);
GO

-- 17. Các Unique Index cho hệ thống Booking hàng đợi ẩn
CREATE UNIQUE INDEX UX_BookingPriorityAllocation_Booking
ON BookingPriorityAllocation(booking_id);

CREATE UNIQUE INDEX UX_BookingPriorityAllocation_AssignedSlot
ON BookingPriorityAllocation(booking_date, shift_name, slot_type, slot_order)
WHERE slot_type IN ('MAIN', 'BACKUP');

CREATE INDEX IX_BookingPriorityAllocation_Waiting
ON BookingPriorityAllocation(booking_date, shift_name, slot_type, priority_rank DESC, created_at ASC);
GO


/* ============================================================================
   CÁC CẬP NHẬT MỚI CHO LOYALTY ENGINE (FR-09 & FR-10a)
   ============================================================================ */

-- 18. Ràng buộc Unique trên cột booking_id của LoyaltyTransaction cho giao dịch 'Earned'
-- Chỉ cho phép cộng điểm một lần cho một booking, nhưng cho phép nhiều giao dịch 'Spent' có booking_id = NULL
CREATE UNIQUE INDEX UX_LoyaltyTransaction_Booking_Earned
ON LoyaltyTransaction(booking_id)
WHERE booking_id IS NOT NULL AND transaction_type = 'Earned';
GO


/* ============================================================================
   CHÈN DỮ LIỆU SEED MẪU (Bảo toàn đầy đủ các chức năng cũ)
   ============================================================================ */

-- 1. Insert MembershipTier (Bám sát 100% logic đề bài)
-- Quy đổi: 1 point = 1,000 VND. Vậy: 2M VND = 2000 points, 6M VND = 6000 points, 15M VND = 15000 points.
INSERT INTO MembershipTier (tier_name, min_points, discount_percent, benefits, priority_score, booking_window_days, reserved_slot_eligible) VALUES
('Member', 0, 0.00, '1 point = 1,000 VND spent', 10, 7, 0),
('Silver', 2000, 0.00, '+10% points, priority slot', 20, 10, 0),
('Gold', 6000, 0.00, '+20% points, free upgrade monthly', 30, 12, 1),
('Platinum', 15000, 0.00, '+30% points, free wash monthly', 40, 14, 1);

-- 2. Insert Customer (Tạo nhiều khách hàng ở các hạng khác nhau để test giao diện)
INSERT INTO Customer (full_name, phone, email, [password], total_spent_money, total_points, tier_id) VALUES
('Ngo Gia A', '0987654321', 'ang@gmail.com', '123456', 800000.00, 600, 1),      -- Member (800K spent = 800 points)
('Nguyen Van A', '0912345678', 'anv@gmail.com', '123456', 2500000.00, 1200, 2),      -- Silver (2.5M spent)
('Tran Thi B', '0922334455', 'btt@gmail.com', '123456', 7000000.00, 4000, 3),        -- Gold (7M spent)
('Le Van C', '0933445566', 'cvl@gmail.com', '123456', 16000000.00, 1000, 4),         -- Platinum (16M spent)
('Pham Minh D', '0944556677', 'dpham@gmail.com', '123456', 1500000.00, 1500, 1),     -- Member (1.5M spent)
('Hoang Thu E', '0955667788', 'ethu@gmail.com', '123456', 3200000.00, 3200, 2),      -- Silver (3.2M spent)
('Vu Anh F', '0966778899', 'fvu@gmail.com', '123456', 8500000.00, 8500, 3),          -- Gold (8.5M spent)
('Dang Hoa G', '0977889900', 'ghoa@gmail.com', '123456', 18000000.00, 18000, 4);      -- Platinum (18M spent)

-- 3. Insert Reward (Đúng theo ví dụ trong file requirement của đề)
INSERT INTO Reward (reward_name, required_points, description) VALUES
(N'Free Waxing (Phủ sáp miễn phí)', 300, N'Nhận ngay 1 lần phủ sáp bảo vệ sơn ngoài'),
(N'10% Discount (Giảm giá 10%)', 500, N'Giảm 10% cho hóa đơn dịch vụ tiếp theo'),
(N'Free Basic Wash (Rửa xe cơ bản)', 1000, N'Miễn phí 1 lần rửa xe cơ bản'),
(N'Interior Detailing (Vệ sinh nội thất)', 2000, N'Gói vệ sinh nội thất chuyên sâu cao cấp');

-- 4. Insert Service & Booking (Cần data nền để tạo giao dịch)
INSERT INTO Service (service_name, price, duration) VALUES
(N'Rửa xe cơ bản', 100000.00, 30),
(N'Phủ Ceramic', 1500000.00, 120),
(N'Vệ sinh nội thất', 200000.00, 45),
(N'Đánh bóng ngoài', 300000.00, 90),
(N'Dịch vụ Combo Premium', 800000.00, 150),
(N'Phủ sáp bảo vệ', 250000.00, 60);

-- Tạo phương tiện
INSERT INTO Vehicle (customer_id, license_plate, brand, model, color) VALUES
(1, '61B1-123.45', 'Honda', 'Civic', N'Trắng'),
(2, '29A1-234.56', 'Toyota', 'Vios', N'Bạc'),
(2, '29A1-345.67', 'Toyota', 'Camry', N'Đỏ'),
(3, '36A1-456.78', 'Honda', 'City', N'Xanh'),
(4, '92C1-567.89', 'BMW', '320i', N'Đen'),
(5, '79A1-678.90', 'Kia', 'Cerato', N'Trắng'),
(6, '30B1-789.01', 'Hyundai', 'i10', N'Vàng'),
(7, '51C1-890.12', 'Mazda', 'CX5', N'Bạc'),
(8, '76A1-901.23', 'Lexus', 'RX', N'Đen');

-- Tạo booking với các trạng thái khác nhau
INSERT INTO Booking (customer_id, vehicle_id, booking_date, booking_time, status, total_price) VALUES
(1, 1, '2026-05-20', '10:00:00', 'Completed', 100000.00),
(1, 2, '2026-05-21', '14:00:00', 'Completed', 250000.00),
(2, 3, '2026-05-22', '09:00:00', 'Completed', 800000.00),
(2, 4, '2026-05-23', '11:00:00', 'Pending', 1500000.00),
(3, 5, '2026-05-24', '15:00:00', 'Completed', 300000.00),
(3, 5, '2026-05-25', '10:30:00', 'Completed', 200000.00),
(4, 6, '2026-05-26', '13:00:00', 'Completed', 1500000.00),
(5, 7, '2026-05-26', '16:00:00', 'Pending', 100000.00),
(6, 8, '2026-05-27', '09:30:00', 'Confirmed', 200000.00),
(7, 9, '2026-05-27', '14:00:00', 'Completed', 800000.00);

-- Thêm dịch vụ vào booking
INSERT INTO BookingService (booking_id, service_id, quantity, price) VALUES
(1, 1, 1, 100000.00),
(2, 6, 1, 250000.00),
(3, 5, 1, 800000.00),
(4, 2, 1, 1500000.00),
(5, 4, 1, 300000.00),
(6, 3, 1, 200000.00),
(7, 2, 1, 1500000.00),
(8, 1, 1, 100000.00),
(9, 3, 1, 200000.00),
(10, 5, 1, 800000.00);

-- 5. Insert LoyaltyTransaction (Cốt lõi cho hàm tích điểm)
INSERT INTO LoyaltyTransaction (customer_id, booking_id, points, transaction_type) VALUES
(1, 1, 500, 'Earned'),     -- Booking 1
(1, 2, 100, 'Earned'),     -- Booking 2
(1, NULL, 300, 'Spent'),   -- Đổi thưởng
(2, 3, 2000, 'Earned'),    -- Booking 3
(2, 4, 500, 'Earned'),     -- Booking 4
(3, 5, 1500, 'Earned'),    -- Booking 5
(3, 6, 800, 'Earned'),     -- Booking 6
(3, NULL, 300, 'Spent'),   -- Đổi thưởng
(4, 7, 5000, 'Earned'),    -- Booking 7
(5, 8, 400, 'Earned'),     -- Booking 8
(6, 9, 800, 'Earned'),     -- Booking 9
(7, 10, 3000, 'Earned');   -- Booking 10

-- 6. Insert Redemption (Ghi lại các lần đổi thưởng)
INSERT INTO Redemption (customer_id, reward_id, redeem_date, status) VALUES
(1, 1, '2026-05-22', 'Completed'),
(3, 2, '2026-05-25', 'Completed'),
(3, 3, '2026-05-26', 'Completed'),
(4, 4, '2026-05-26', 'Completed'),
(2, 1, '2026-05-27', 'Pending');

-- 7. Insert Payment (Thanh toán)
INSERT INTO Payment (booking_id, amount, payment_method, payment_status, transaction_code, paid_at) VALUES
(1, 100000.00, 'Credit Card', 'Completed', 'TXN001', '2026-05-20 10:30:00'),
(2, 250000.00, 'Cash', 'Completed', 'TXN002', '2026-05-21 14:30:00'),
(3, 800000.00, 'Credit Card', 'Completed', 'TXN003', '2026-05-22 09:45:00'),
(4, 1500000.00, 'Bank Transfer', 'Pending', 'TXN004', NULL),
(5, 300000.00, 'Credit Card', 'Completed', 'TXN005', '2026-05-24 15:30:00'),
(6, 200000.00, 'Cash', 'Completed', 'TXN006', '2026-05-25 10:45:00'),
(7, 1500000.00, 'Credit Card', 'Completed', 'TXN007', '2026-05-26 13:30:00'),
(8, 100000.00, 'Cash', 'Pending', 'TXN008', NULL),
(9, 200000.00, 'Credit Card', 'Completed', 'TXN009', '2026-05-27 09:45:00'),
(10, 800000.00, 'Bank Transfer', 'Completed', 'TXN010', '2026-05-27 14:30:00');

-- 8. Insert Feedback (Đánh giá từ khách hàng)
INSERT INTO Feedback (customer_id, booking_id, rating, comment, created_at) VALUES
(1, 1, 5, N'Dịch vụ tuyệt vời, nhân viên lịch sự và chuyên nghiệp', '2026-05-20 11:00:00'),
(1, 2, 5, N'Phủ sáp rất tốt, xe bóng như mới', '2026-05-21 15:00:00'),
(2, 3, 4, N'Tốt nhưng tốn thời gian hơn dự kiến', '2026-05-22 10:15:00'),
(3, 5, 5, N'Đánh bóng tuyệt đỉnh, xe sáng như gương', '2026-05-24 16:00:00'),
(3, 6, 4, N'Vệ sinh nội thất khá sạch sẽ', '2026-05-25 11:15:00'),
(4, 7, 5, N'Dịch vụ cao cấp xứng đáng với giá tiền', '2026-05-26 13:45:00'),
(6, 9, 3, N'Chất lượng bình thường, có thể cải thiện hơn', '2026-05-27 10:15:00'),
(7, 10, 5, N'Rất hài lòng, sẽ quay lại', '2026-05-27 14:45:00');

-- 9. Insert Promotion (Bắt buộc phải có trước AIRecommendation vì AIRecommendation dùng promotion_id làm khóa ngoại)
INSERT INTO Promotion (title, discount_percent, start_date, end_date, target_tier) VALUES
(N'Khuyến mãi rửa xe mùa hè', 20.00, '2026-05-01', '2026-06-30', N'Member'),
(N'Ưu đãi lên hạng Silver', 15.00, '2026-05-01', '2026-07-31', N'Silver'),
(N'Ưu đãi chăm sóc xe Gold/Platinum', 30.00, '2026-05-01', '2026-08-31', N'Gold');

-- 10. Insert AI Recommendation (Gợi ý AI dựa trên hành vi)
INSERT INTO AIRecommendation (customer_id, promotion_id, recommendation_reason, created_at) VALUES
(1, 1, N'Gợi ý rửa xe vào mùa hè, được giảm 20%', GETDATE()),
(2, 2, N'Khách hạng Silver sắp lên Gold, cố gắng thêm 3500 điểm nữa', GETDATE()),
(3, 3, N'Khách hạng Gold, được ưu tiên giảm 30% các dịch vụ cao cấp', GETDATE()),
(4, 3, N'VIP Platinum, nhận gợi ý dịch vụ cao cấp mới', GETDATE()),
(5, 1, N'Khách Member mới, cơ hội lên Silver với 1200 điểm nữa', GETDATE()),
(6, 2, N'Gợi ý dịch vụ vệ sinh nội thất theo mùa', GETDATE());

-- 11. Insert LPR Log (Ghi nhận lịch sử phát hiện biển số)
INSERT INTO LPRLog (vehicle_id, detected_plate, checkin_time, confidence_score) VALUES
(1, '61B1-123.45', '2026-05-20 09:55:00', 0.9999),
(1, '61B1-123.45', '2026-05-21 13:55:00', 0.9998),
(2, '61B1-789.01', '2026-05-21 13:55:00', 0.9997),
(3, '29A1-234.56', '2026-05-22 08:55:00', 0.9995),
(4, '29A1-345.67', '2026-05-23 10:55:00', 0.9999),
(5, '36A1-456.78', '2026-05-24 14:55:00', 0.9998),
(5, '36A1-456.78', '2026-05-25 10:20:00', 0.9997),
(6, '92C1-567.89', '2026-05-26 12:55:00', 0.9999),
(7, '79A1-678.90', '2026-05-26 15:55:00', 0.9996),
(8, '30B1-789.01', '2026-05-27 09:20:00', 0.9998),
(9, '51C1-890.12', '2026-05-27 13:55:00', 0.9999);
GO

PRINT 'Database setup hoàn tất! ✅ Phiên bản Database V2 đã sẵn sàng cho FR-09 và FR-10a.';
