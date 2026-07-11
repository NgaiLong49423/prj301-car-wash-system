/*
  AutoWashPro_DB - Unified schema for PRJ301 Assessment
  Purpose: One schema file only. Run this first, then run sample-data.sql.
  Engine: Microsoft SQL Server
*/

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'AutoWashPro_DB')
BEGIN
    ALTER DATABASE AutoWashPro_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AutoWashPro_DB;
END
GO

CREATE DATABASE AutoWashPro_DB;
GO

USE AutoWashPro_DB;
GO

/* =========================
   1. Loyalty configuration
   ========================= */
CREATE TABLE LoyaltyConfig (
    config_id INT IDENTITY(1,1) PRIMARY KEY,
    config_key VARCHAR(100) NOT NULL UNIQUE,
    config_value NVARCHAR(255) NOT NULL,
    description NVARCHAR(500) NULL,
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
    ,updated_by INT NULL
);
GO

CREATE TABLE MembershipTier (
    tier_id INT IDENTITY(1,1) PRIMARY KEY,
    tier_name VARCHAR(50) NOT NULL UNIQUE,
    tier_order INT NOT NULL,

    -- Legacy compatibility with old rewards/profile pages.
    min_points INT NOT NULL DEFAULT 0,
    discount_percent DECIMAL(5,2) NOT NULL DEFAULT 0,

    -- Assessment loyalty rules. These values must be loaded from DB, not hardcoded.
    min_spent_money DECIMAL(18,2) NOT NULL DEFAULT 0,
    min_visit_count INT NOT NULL DEFAULT 0,
    point_rate INT NOT NULL DEFAULT 1000,
    point_multiplier DECIMAL(6,2) NOT NULL DEFAULT 1.00,

    -- Booking and tier benefits.
    booking_window_days INT NOT NULL DEFAULT 7,
    priority_score INT NOT NULL DEFAULT 10,
    reserved_slot_eligible BIT NOT NULL DEFAULT 0,
    benefits NVARCHAR(MAX) NULL,
    is_active BIT NOT NULL DEFAULT 1,

    CONSTRAINT CK_MembershipTier_NonNegative CHECK (
        tier_order >= 0 AND min_points >= 0 AND min_spent_money >= 0
        AND min_visit_count >= 0 AND point_rate > 0 AND point_multiplier > 0
        AND booking_window_days > 0 AND priority_score >= 0
    )
);
GO

/* =========================
   2. Accounts / Customers
   ========================= */
CREATE TABLE Customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    [password] NVARCHAR(255) NOT NULL,
    avatar_url NVARCHAR(500) NULL,
    role_name VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    join_date DATETIME NOT NULL DEFAULT GETDATE(),
    is_active BIT NOT NULL DEFAULT 1,

    -- Lifetime data for business reports.
    lifetime_spent_money DECIMAL(18,2) NOT NULL DEFAULT 0,
    lifetime_visit_count INT NOT NULL DEFAULT 0,

    -- Active loyalty data for current tier/reward decisions.
    active_points INT NOT NULL DEFAULT 0,
    active_spent_money_12m DECIMAL(18,2) NOT NULL DEFAULT 0,
    active_visit_count_12m INT NOT NULL DEFAULT 0,

    -- Legacy compatibility columns used by current app pages.
    total_spent_money DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_points INT NOT NULL DEFAULT 0,

    tier_id INT NOT NULL,

    CONSTRAINT FK_Customer_Tier FOREIGN KEY (tier_id) REFERENCES MembershipTier(tier_id),
    CONSTRAINT CK_Customer_Role CHECK (role_name IN ('ADMIN', 'CUSTOMER')),
    CONSTRAINT CK_Customer_LoyaltyNonNegative CHECK (
        lifetime_spent_money >= 0 AND lifetime_visit_count >= 0
        AND active_points >= 0 AND active_spent_money_12m >= 0
        AND active_visit_count_12m >= 0 AND total_spent_money >= 0 AND total_points >= 0
    )
);
GO

CREATE TABLE Vehicle (
    vehicle_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    brand NVARCHAR(50) NULL,
    model NVARCHAR(50) NULL,
    color NVARCHAR(30) NULL,
    CONSTRAINT FK_Vehicle_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
GO

/* =========================
   3. Services and Booking
   ========================= */
CREATE TABLE Service (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    service_name NVARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    duration INT NOT NULL,
    is_wash_service BIT NOT NULL DEFAULT 0,
    is_active BIT NOT NULL DEFAULT 1,
    CONSTRAINT CK_Service_NonNegative CHECK (price >= 0 AND duration > 0)
);
GO

CREATE TABLE Booking (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',

    -- Legacy total_price kept for current app compatibility. It should mirror final_amount.
    total_price DECIMAL(18,2) NOT NULL DEFAULT 0,
    original_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    final_amount DECIMAL(18,2) NOT NULL DEFAULT 0,

    applied_redemption_id INT NULL,
    loyalty_points_awarded BIT NOT NULL DEFAULT 0,
    loyalty_awarded_at DATETIME NULL,

    requested_at DATETIME NOT NULL DEFAULT GETDATE(),
    priority_score INT NOT NULL DEFAULT 10,
    queue_position INT NULL,
    estimated_start_time TIME NULL,
    cancel_reason NVARCHAR(255) NULL,

    CONSTRAINT FK_Booking_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_Booking_Vehicle FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    CONSTRAINT CK_Booking_Status CHECK (status IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT CK_Booking_Amounts CHECK (
        total_price >= 0 AND original_amount >= 0 AND discount_amount >= 0
        AND final_amount >= 0 AND discount_amount <= original_amount
    )
);
GO

CREATE TABLE BookingService (
    booking_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (booking_id, service_id),
    CONSTRAINT FK_BookingService_Booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    CONSTRAINT FK_BookingService_Service FOREIGN KEY (service_id) REFERENCES Service(service_id),
    CONSTRAINT CK_BookingService_NonNegative CHECK (quantity > 0 AND price >= 0)
);
GO

CREATE TABLE BookingSlot (
    slot_id INT IDENTITY(1,1) PRIMARY KEY,
    slot_date DATE NOT NULL,
    slot_time TIME NOT NULL,
    max_capacity INT NOT NULL DEFAULT 3,
    reserved_vip_capacity INT NOT NULL DEFAULT 1,
    current_confirmed INT NOT NULL DEFAULT 0,
    CONSTRAINT UQ_BookingSlot UNIQUE (slot_date, slot_time),
    CONSTRAINT CK_BookingSlot_Capacity CHECK (max_capacity > 0 AND reserved_vip_capacity >= 0 AND current_confirmed >= 0)
);
GO

CREATE TABLE BookingPriorityAllocation (
    allocation_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL UNIQUE,
    booking_date DATE NOT NULL,
    shift_name VARCHAR(20) NOT NULL,
    slot_type VARCHAR(20) NOT NULL,
    slot_order INT NULL,
    tier_name VARCHAR(20) NOT NULL,
    priority_rank INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_BookingPriorityAllocation_Booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    CONSTRAINT CK_BookingPriorityAllocation_Shift CHECK (shift_name IN ('MORNING', 'AFTERNOON', 'EVENING')),
    CONSTRAINT CK_BookingPriorityAllocation_Type CHECK (slot_type IN ('MAIN', 'BACKUP', 'WAITING'))
);
GO

CREATE UNIQUE INDEX UX_BookingPriorityAllocation_AssignedSlot
ON BookingPriorityAllocation(booking_date, shift_name, slot_type, slot_order)
WHERE slot_type IN ('MAIN', 'BACKUP');
GO

CREATE INDEX IX_BookingPriorityAllocation_Waiting
ON BookingPriorityAllocation(booking_date, shift_name, slot_type, priority_rank DESC, created_at ASC);
GO

/* =========================
   4. Rewards, redemptions, loyalty points
   ========================= */
CREATE TABLE Reward (
    reward_id INT IDENTITY(1,1) PRIMARY KEY,
    reward_name NVARCHAR(100) NOT NULL,
    required_points INT NOT NULL,
    description NVARCHAR(MAX) NULL,
    reward_type VARCHAR(30) NOT NULL,
    reward_value DECIMAL(18,2) NOT NULL DEFAULT 0,
    maximum_discount DECIMAL(18,2) NULL,
    target_service_id INT NULL,
    valid_days INT NOT NULL DEFAULT 90,
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Reward_TargetService FOREIGN KEY (target_service_id) REFERENCES Service(service_id),
    CONSTRAINT CK_Reward_Type CHECK (reward_type IN ('FIXED_DISCOUNT', 'PERCENT_DISCOUNT', 'FREE_SERVICE', 'FREE_WASH')),
    CONSTRAINT CK_Reward_NonNegative CHECK (required_points >= 0 AND reward_value >= 0 AND valid_days > 0)
);
GO

CREATE TABLE Redemption (
    redemption_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    reward_id INT NOT NULL,
    points_used INT NOT NULL,
    redeem_date DATETIME NOT NULL DEFAULT GETDATE(),
    valid_from DATETIME NOT NULL DEFAULT GETDATE(),
    valid_until DATETIME NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE',
    applied_booking_id INT NULL,
    used_at DATETIME NULL,
    cancelled_reason NVARCHAR(255) NULL,
    voucher_code VARCHAR(32) NOT NULL,
    reward_name_snapshot NVARCHAR(100) NULL,
    reward_type_snapshot VARCHAR(30) NULL,
    reward_value_snapshot DECIMAL(18,2) NULL,
    maximum_discount_snapshot DECIMAL(18,2) NULL,
    request_token VARCHAR(64) NULL,
    CONSTRAINT FK_Redemption_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_Redemption_Reward FOREIGN KEY (reward_id) REFERENCES Reward(reward_id),
    CONSTRAINT FK_Redemption_AppliedBooking FOREIGN KEY (applied_booking_id) REFERENCES Booking(booking_id),
    CONSTRAINT CK_Redemption_Status CHECK (status IN ('AVAILABLE', 'USED', 'EXPIRED', 'CANCELLED')),
    CONSTRAINT CK_Redemption_Points CHECK (points_used >= 0)
);
GO

ALTER TABLE Booking
ADD CONSTRAINT FK_Booking_AppliedRedemption FOREIGN KEY (applied_redemption_id) REFERENCES Redemption(redemption_id);
GO

-- Ensure one voucher/redemption can be attached to at most one booking.
CREATE UNIQUE INDEX UX_Booking_AppliedRedemption_NotNull
ON Booking(applied_redemption_id)
WHERE applied_redemption_id IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_Redemption_AppliedBooking_NotNull
ON Redemption(applied_booking_id)
WHERE applied_booking_id IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_Redemption_VoucherCode ON Redemption(voucher_code);
GO
CREATE UNIQUE INDEX UX_Redemption_RequestToken ON Redemption(customer_id, request_token) WHERE request_token IS NOT NULL;
GO

-- Each EARNED point batch tracks the remaining points and expiry date for FIFO redemption.
CREATE TABLE LoyaltyPointBatch (
    point_batch_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    source_booking_id INT NULL,
    earned_points INT NOT NULL,
    remaining_points INT NOT NULL,
    earned_at DATETIME NOT NULL DEFAULT GETDATE(),
    expires_at DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT FK_LoyaltyPointBatch_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_LoyaltyPointBatch_Booking FOREIGN KEY (source_booking_id) REFERENCES Booking(booking_id),
    CONSTRAINT CK_LoyaltyPointBatch_Status CHECK (status IN ('ACTIVE', 'USED_UP', 'EXPIRED')),
    CONSTRAINT CK_LoyaltyPointBatch_Points CHECK (earned_points >= 0 AND remaining_points >= 0 AND remaining_points <= earned_points)
);
GO

CREATE TABLE LoyaltyTransaction (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    booking_id INT NULL,
    redemption_id INT NULL,
    point_batch_id INT NULL,
    points INT NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    description NVARCHAR(255) NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_LoyaltyTransaction_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT FK_LoyaltyTransaction_Booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    CONSTRAINT FK_LoyaltyTransaction_Redemption FOREIGN KEY (redemption_id) REFERENCES Redemption(redemption_id),
    CONSTRAINT FK_LoyaltyTransaction_PointBatch FOREIGN KEY (point_batch_id) REFERENCES LoyaltyPointBatch(point_batch_id),
    CONSTRAINT CK_LoyaltyTransaction_Type CHECK (transaction_type IN ('EARNED', 'REDEEMED', 'EXPIRED', 'ADJUSTED'))
);
GO

CREATE UNIQUE INDEX UX_LoyaltyTransaction_EarnedBooking
ON LoyaltyTransaction(booking_id, transaction_type)
WHERE transaction_type = 'EARNED' AND booking_id IS NOT NULL;
GO
CREATE UNIQUE INDEX UX_LoyaltyTransaction_ExpiredBatch ON LoyaltyTransaction(point_batch_id, transaction_type) WHERE transaction_type = 'EXPIRED' AND point_batch_id IS NOT NULL;
GO
CREATE INDEX IX_PointBatch_Refresh ON LoyaltyPointBatch(customer_id, status, expires_at) INCLUDE (remaining_points);
GO

/* =========================
   5. Promotions and targeted delivery data
   ========================= */
CREATE TABLE Promotion (
    promotion_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX) NULL,
    promotion_type VARCHAR(30) NOT NULL DEFAULT 'PERCENT_DISCOUNT',
    promotion_value DECIMAL(18,2) NOT NULL DEFAULT 0,

    -- Target rule: ALL = all customers; TIER = customers in one membership tier.
    target_type VARCHAR(20) NOT NULL DEFAULT 'TIER',

    -- Legacy compatibility with old promotion pages.
    discount_percent DECIMAL(5,2) NOT NULL DEFAULT 0,
    target_tier NVARCHAR(50) NULL,

    target_tier_id INT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    is_active BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Promotion_TargetTier FOREIGN KEY (target_tier_id) REFERENCES MembershipTier(tier_id),
    CONSTRAINT CK_Promotion_Status CHECK (status IN ('DRAFT', 'ACTIVE', 'EXPIRED', 'INACTIVE')),
    CONSTRAINT CK_Promotion_Type CHECK (promotion_type IN ('FIXED_DISCOUNT', 'PERCENT_DISCOUNT', 'FREE_SERVICE', 'FREE_WASH')),
    CONSTRAINT CK_Promotion_TargetType CHECK (target_type IN ('ALL', 'TIER')),
    CONSTRAINT CK_Promotion_TargetRule CHECK (
        (target_type = 'ALL' AND target_tier_id IS NULL)
        OR (target_type = 'TIER' AND target_tier_id IS NOT NULL)
    ),
    CONSTRAINT CK_Promotion_Date CHECK (end_date >= start_date)
);
GO

CREATE INDEX IX_Promotion_Target
ON Promotion(target_type, target_tier_id, status, start_date, end_date);
GO

CREATE TABLE CustomerPromotion (
    customer_promotion_id INT IDENTITY(1,1) PRIMARY KEY,
    promotion_id INT NOT NULL,
    customer_id INT NOT NULL,
    delivery_status VARCHAR(20) NOT NULL DEFAULT 'SENT',
    sent_at DATETIME NOT NULL DEFAULT GETDATE(),
    viewed_at DATETIME NULL,
    used_at DATETIME NULL,
    CONSTRAINT FK_CustomerPromotion_Promotion FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id),
    CONSTRAINT FK_CustomerPromotion_Customer FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT UQ_CustomerPromotion UNIQUE (promotion_id, customer_id),
    CONSTRAINT CK_CustomerPromotion_Status CHECK (delivery_status IN ('SENT', 'VIEWED', 'USED'))
);
GO

PRINT 'schema.sql completed: AutoWashPro_DB has been recreated.';
GO
