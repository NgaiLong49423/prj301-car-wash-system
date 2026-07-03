/* PROJECT: Vehicle Service Management System - AutoWash Pro
   ENGINE: Microsoft SQL Server
   VERSION: Database V2 (Merged Schema)
   INSTRUCTION: Chạy file này để cài đặt toàn bộ cấu trúc bảng, khóa ngoại và index.
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
    discount_percent DECIMAL(5,2) DEFAULT 0.00, -- Tỷ lệ phần trăm cộng thêm điểm thưởng (Ví dụ: 10.00 cho 10%)
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
    total_spent_money DECIMAL(18,2) DEFAULT 0,  -- Tổng chi tiêu trọn đời
    total_points INT DEFAULT 0,  -- Điểm tích lũy khả dụng hiện có
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

-- 16. Tạo bảng BookingPriorityAllocation (Hàng đợi ẩn của Workshop 2)
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

-- 17. Các Unique Index cho hàng đợi ẩn (Workshop 2)
CREATE UNIQUE INDEX UX_BookingPriorityAllocation_Booking
ON BookingPriorityAllocation(booking_id);

CREATE UNIQUE INDEX UX_BookingPriorityAllocation_AssignedSlot
ON BookingPriorityAllocation(booking_date, shift_name, slot_type, slot_order)
WHERE slot_type IN ('MAIN', 'BACKUP');

CREATE INDEX IX_BookingPriorityAllocation_Waiting
ON BookingPriorityAllocation(booking_date, shift_name, slot_type, priority_rank DESC, created_at ASC);
GO

-- 18. Index chống cộng điểm trùng cho cùng 1 booking (FR-09)
CREATE UNIQUE INDEX UX_LoyaltyTransaction_Booking_Earned
ON LoyaltyTransaction(booking_id)
WHERE booking_id IS NOT NULL AND transaction_type = 'Earned';
GO
