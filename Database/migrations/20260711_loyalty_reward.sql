USE AutoWashPro_DB;
GO
/* Non-destructive compatibility upgrade for the original PRJ301 schema. */
IF OBJECT_ID('LoyaltyConfig','U') IS NULL
CREATE TABLE LoyaltyConfig(config_id INT IDENTITY PRIMARY KEY,config_key VARCHAR(100) NOT NULL UNIQUE,config_value NVARCHAR(255) NOT NULL,description NVARCHAR(500) NULL,updated_at DATETIME NOT NULL DEFAULT GETDATE(),updated_by INT NULL);
GO
IF COL_LENGTH('Customer','role_name') IS NULL ALTER TABLE Customer ADD role_name VARCHAR(20) NOT NULL CONSTRAINT DF_Customer_Role DEFAULT 'CUSTOMER';
IF COL_LENGTH('Customer','is_active') IS NULL ALTER TABLE Customer ADD is_active BIT NOT NULL CONSTRAINT DF_Customer_Active DEFAULT 1;
IF COL_LENGTH('Customer','active_points') IS NULL ALTER TABLE Customer ADD active_points INT NOT NULL CONSTRAINT DF_Customer_ActivePoints DEFAULT 0;
IF COL_LENGTH('Customer','lifetime_spent_money') IS NULL ALTER TABLE Customer ADD lifetime_spent_money DECIMAL(18,2) NOT NULL CONSTRAINT DF_Customer_LifetimeSpent DEFAULT 0;
IF COL_LENGTH('Customer','lifetime_visit_count') IS NULL ALTER TABLE Customer ADD lifetime_visit_count INT NOT NULL CONSTRAINT DF_Customer_LifetimeVisits DEFAULT 0;
IF COL_LENGTH('Customer','active_spent_money_12m') IS NULL ALTER TABLE Customer ADD active_spent_money_12m DECIMAL(18,2) NOT NULL CONSTRAINT DF_Customer_ActiveSpent DEFAULT 0;
IF COL_LENGTH('Customer','active_visit_count_12m') IS NULL ALTER TABLE Customer ADD active_visit_count_12m INT NOT NULL CONSTRAINT DF_Customer_ActiveVisits DEFAULT 0;
GO
UPDATE Customer SET active_points=ISNULL(total_points,0),lifetime_spent_money=ISNULL(total_spent_money,0) WHERE active_points=0 AND ISNULL(total_points,0)>0;
GO
IF COL_LENGTH('MembershipTier','tier_order') IS NULL ALTER TABLE MembershipTier ADD tier_order INT NOT NULL CONSTRAINT DF_Tier_Order DEFAULT 0;
IF COL_LENGTH('MembershipTier','min_spent_money') IS NULL ALTER TABLE MembershipTier ADD min_spent_money DECIMAL(18,2) NOT NULL CONSTRAINT DF_Tier_MinSpent DEFAULT 0;
IF COL_LENGTH('MembershipTier','min_visit_count') IS NULL ALTER TABLE MembershipTier ADD min_visit_count INT NOT NULL CONSTRAINT DF_Tier_MinVisits DEFAULT 0;
IF COL_LENGTH('MembershipTier','point_rate') IS NULL ALTER TABLE MembershipTier ADD point_rate INT NOT NULL CONSTRAINT DF_Tier_PointRate DEFAULT 1000;
IF COL_LENGTH('MembershipTier','point_multiplier') IS NULL ALTER TABLE MembershipTier ADD point_multiplier DECIMAL(6,2) NOT NULL CONSTRAINT DF_Tier_Multiplier DEFAULT 1;
IF COL_LENGTH('MembershipTier','booking_window_days') IS NULL ALTER TABLE MembershipTier ADD booking_window_days INT NOT NULL CONSTRAINT DF_Tier_BookingDays DEFAULT 7;
IF COL_LENGTH('MembershipTier','priority_score') IS NULL ALTER TABLE MembershipTier ADD priority_score INT NOT NULL CONSTRAINT DF_Tier_Priority DEFAULT 10;
IF COL_LENGTH('MembershipTier','reserved_slot_eligible') IS NULL ALTER TABLE MembershipTier ADD reserved_slot_eligible BIT NOT NULL CONSTRAINT DF_Tier_Reserved DEFAULT 0;
IF COL_LENGTH('MembershipTier','is_active') IS NULL ALTER TABLE MembershipTier ADD is_active BIT NOT NULL CONSTRAINT DF_Tier_Active DEFAULT 1;
GO
IF COL_LENGTH('Reward','reward_type') IS NULL ALTER TABLE Reward ADD reward_type VARCHAR(30) NOT NULL CONSTRAINT DF_Reward_Type DEFAULT 'FIXED_DISCOUNT';
IF COL_LENGTH('Reward','reward_value') IS NULL ALTER TABLE Reward ADD reward_value DECIMAL(18,2) NOT NULL CONSTRAINT DF_Reward_Value DEFAULT 0;
IF COL_LENGTH('Reward','target_service_id') IS NULL ALTER TABLE Reward ADD target_service_id INT NULL;
IF COL_LENGTH('Reward','valid_days') IS NULL ALTER TABLE Reward ADD valid_days INT NOT NULL CONSTRAINT DF_Reward_Days DEFAULT 30;
IF COL_LENGTH('Reward','is_active') IS NULL ALTER TABLE Reward ADD is_active BIT NOT NULL CONSTRAINT DF_Reward_Active DEFAULT 1;
IF COL_LENGTH('Reward','created_at') IS NULL ALTER TABLE Reward ADD created_at DATETIME NOT NULL CONSTRAINT DF_Reward_Created DEFAULT GETDATE();
GO
IF COL_LENGTH('Booking','original_amount') IS NULL ALTER TABLE Booking ADD original_amount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Booking_Original DEFAULT 0;
IF COL_LENGTH('Booking','discount_amount') IS NULL ALTER TABLE Booking ADD discount_amount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Booking_Discount DEFAULT 0;
IF COL_LENGTH('Booking','final_amount') IS NULL ALTER TABLE Booking ADD final_amount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Booking_Final DEFAULT 0;
IF COL_LENGTH('Booking','applied_redemption_id') IS NULL ALTER TABLE Booking ADD applied_redemption_id INT NULL;
IF COL_LENGTH('Booking','loyalty_points_awarded') IS NULL ALTER TABLE Booking ADD loyalty_points_awarded BIT NOT NULL CONSTRAINT DF_Booking_Awarded DEFAULT 0;
IF COL_LENGTH('Booking','loyalty_awarded_at') IS NULL ALTER TABLE Booking ADD loyalty_awarded_at DATETIME NULL;
GO
UPDATE Booking SET original_amount=ISNULL(total_price,0),final_amount=ISNULL(total_price,0) WHERE original_amount=0 AND ISNULL(total_price,0)>0;
GO
IF COL_LENGTH('Redemption','points_used') IS NULL ALTER TABLE Redemption ADD points_used INT NOT NULL CONSTRAINT DF_Redemption_Points DEFAULT 0;
IF COL_LENGTH('Redemption','valid_from') IS NULL ALTER TABLE Redemption ADD valid_from DATETIME NOT NULL CONSTRAINT DF_Redemption_From DEFAULT GETDATE();
IF COL_LENGTH('Redemption','valid_until') IS NULL ALTER TABLE Redemption ADD valid_until DATETIME NULL;
IF COL_LENGTH('Redemption','applied_booking_id') IS NULL ALTER TABLE Redemption ADD applied_booking_id INT NULL;
IF COL_LENGTH('Redemption','used_at') IS NULL ALTER TABLE Redemption ADD used_at DATETIME NULL;
IF COL_LENGTH('Redemption','cancelled_reason') IS NULL ALTER TABLE Redemption ADD cancelled_reason NVARCHAR(255) NULL;
GO
UPDATE Redemption SET valid_until=DATEADD(day,30,ISNULL(redeem_date,GETDATE())) WHERE valid_until IS NULL;
ALTER TABLE Redemption ALTER COLUMN valid_until DATETIME NOT NULL;
GO
IF OBJECT_ID('LoyaltyPointBatch','U') IS NULL
CREATE TABLE LoyaltyPointBatch(point_batch_id INT IDENTITY PRIMARY KEY,customer_id INT NOT NULL,source_booking_id INT NULL,earned_points INT NOT NULL,remaining_points INT NOT NULL,earned_at DATETIME NOT NULL DEFAULT GETDATE(),expires_at DATETIME NOT NULL,status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',CONSTRAINT FK_LPB_Customer FOREIGN KEY(customer_id) REFERENCES Customer(customer_id),CONSTRAINT FK_LPB_Booking FOREIGN KEY(source_booking_id) REFERENCES Booking(booking_id));
GO
IF COL_LENGTH('LoyaltyTransaction','redemption_id') IS NULL ALTER TABLE LoyaltyTransaction ADD redemption_id INT NULL;
IF COL_LENGTH('LoyaltyTransaction','point_batch_id') IS NULL ALTER TABLE LoyaltyTransaction ADD point_batch_id INT NULL;
IF COL_LENGTH('LoyaltyTransaction','description') IS NULL ALTER TABLE LoyaltyTransaction ADD description NVARCHAR(255) NULL;
GO
/* Preserve legacy balances by creating one active batch per customer. */
INSERT LoyaltyPointBatch(customer_id,earned_points,remaining_points,earned_at,expires_at,status)
SELECT c.customer_id,ISNULL(c.total_points,0),ISNULL(c.total_points,0),ISNULL(c.join_date,GETDATE()),DATEADD(month,12,GETDATE()),'ACTIVE'
FROM Customer c WHERE ISNULL(c.total_points,0)>0 AND NOT EXISTS(SELECT 1 FROM LoyaltyPointBatch b WHERE b.customer_id=c.customer_id);
GO
IF COL_LENGTH('Redemption','voucher_code') IS NULL ALTER TABLE Redemption ADD voucher_code VARCHAR(32) NULL;
IF COL_LENGTH('Redemption','reward_name_snapshot') IS NULL ALTER TABLE Redemption ADD reward_name_snapshot NVARCHAR(100) NULL;
IF COL_LENGTH('Redemption','reward_type_snapshot') IS NULL ALTER TABLE Redemption ADD reward_type_snapshot VARCHAR(30) NULL;
IF COL_LENGTH('Redemption','reward_value_snapshot') IS NULL ALTER TABLE Redemption ADD reward_value_snapshot DECIMAL(18,2) NULL;
IF COL_LENGTH('Redemption','maximum_discount_snapshot') IS NULL ALTER TABLE Redemption ADD maximum_discount_snapshot DECIMAL(18,2) NULL;
IF COL_LENGTH('Redemption','request_token') IS NULL ALTER TABLE Redemption ADD request_token VARCHAR(64) NULL;
IF COL_LENGTH('Reward','maximum_discount') IS NULL ALTER TABLE Reward ADD maximum_discount DECIMAL(18,2) NULL;
IF COL_LENGTH('LoyaltyConfig','updated_by') IS NULL ALTER TABLE LoyaltyConfig ADD updated_by INT NULL;
GO
UPDATE Redemption SET voucher_code='LEGACY-'+CONVERT(VARCHAR(20),redemption_id),reward_name_snapshot=r.reward_name,reward_type_snapshot=r.reward_type,reward_value_snapshot=r.reward_value FROM Redemption d JOIN Reward r ON d.reward_id=r.reward_id WHERE d.voucher_code IS NULL;
ALTER TABLE Redemption ALTER COLUMN voucher_code VARCHAR(32) NOT NULL;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='UX_Redemption_VoucherCode') CREATE UNIQUE INDEX UX_Redemption_VoucherCode ON Redemption(voucher_code);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='UX_Redemption_RequestToken') CREATE UNIQUE INDEX UX_Redemption_RequestToken ON Redemption(customer_id,request_token) WHERE request_token IS NOT NULL;
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_PointBatch_Refresh') CREATE INDEX IX_PointBatch_Refresh ON LoyaltyPointBatch(customer_id,status,expires_at) INCLUDE(remaining_points);
IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='UX_LoyaltyTransaction_ExpiredBatch') CREATE UNIQUE INDEX UX_LoyaltyTransaction_ExpiredBatch ON LoyaltyTransaction(point_batch_id,transaction_type) WHERE transaction_type='EXPIRED' AND point_batch_id IS NOT NULL;
IF NOT EXISTS(SELECT 1 FROM LoyaltyConfig WHERE config_key='POINT_EXPIRY_MONTHS') INSERT LoyaltyConfig(config_key,config_value,description) VALUES('POINT_EXPIRY_MONTHS','12','Point batch lifetime in months');
IF NOT EXISTS(SELECT 1 FROM LoyaltyConfig WHERE config_key='POINT_CONVERSION_RATE') INSERT LoyaltyConfig(config_key,config_value,description) VALUES('POINT_CONVERSION_RATE','1000','VND required for one base point');
IF NOT EXISTS(SELECT 1 FROM LoyaltyConfig WHERE config_key='DEFAULT_VOUCHER_VALIDITY_DAYS') INSERT LoyaltyConfig(config_key,config_value,description) VALUES('DEFAULT_VOUCHER_VALIDITY_DAYS','30','Fallback voucher validity');
GO
