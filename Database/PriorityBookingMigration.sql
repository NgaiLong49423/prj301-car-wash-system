USE AutoWashPro_DB;
GO

IF COL_LENGTH('MembershipTier', 'priority_score') IS NULL
    ALTER TABLE MembershipTier ADD priority_score INT DEFAULT 10;
GO

IF COL_LENGTH('MembershipTier', 'advance_booking_days') IS NULL
    ALTER TABLE MembershipTier ADD advance_booking_days INT DEFAULT 3;
GO

IF COL_LENGTH('MembershipTier', 'reserved_slot_eligible') IS NULL
    ALTER TABLE MembershipTier ADD reserved_slot_eligible BIT DEFAULT 0;
GO

UPDATE MembershipTier
SET priority_score = CASE UPPER(tier_name)
        WHEN 'PLATINUM' THEN 40
        WHEN 'GOLD' THEN 30
        WHEN 'SILVER' THEN 20
        ELSE 10
    END,
    advance_booking_days = CASE UPPER(tier_name)
        WHEN 'PLATINUM' THEN 14
        WHEN 'GOLD' THEN 7
        WHEN 'SILVER' THEN 5
        ELSE 3
    END,
    reserved_slot_eligible = CASE WHEN UPPER(tier_name) IN ('GOLD', 'PLATINUM') THEN 1 ELSE 0 END;
GO

IF COL_LENGTH('Booking', 'requested_at') IS NULL
    ALTER TABLE Booking ADD requested_at DATETIME DEFAULT GETDATE();
GO

IF COL_LENGTH('Booking', 'priority_score') IS NULL
    ALTER TABLE Booking ADD priority_score INT DEFAULT 10;
GO

IF COL_LENGTH('Booking', 'queue_position') IS NULL
    ALTER TABLE Booking ADD queue_position INT NULL;
GO

IF COL_LENGTH('Booking', 'estimated_start_time') IS NULL
    ALTER TABLE Booking ADD estimated_start_time TIME NULL;
GO

IF COL_LENGTH('Booking', 'cancel_reason') IS NULL
    ALTER TABLE Booking ADD cancel_reason NVARCHAR(255) NULL;
GO

IF OBJECT_ID('BookingSlot', 'U') IS NULL
BEGIN
    CREATE TABLE BookingSlot (
        slot_id INT PRIMARY KEY IDENTITY(1,1),
        slot_date DATE NOT NULL,
        slot_time TIME NOT NULL,
        max_capacity INT NOT NULL DEFAULT 3,
        reserved_vip_capacity INT DEFAULT 1,
        current_confirmed INT DEFAULT 0,
        CONSTRAINT UQ_BookingSlot UNIQUE (slot_date, slot_time)
    );
END
GO

IF OBJECT_ID('BookingQueueLog', 'U') IS NULL
BEGIN
    CREATE TABLE BookingQueueLog (
        log_id INT PRIMARY KEY IDENTITY(1,1),
        booking_id INT NOT NULL,
        old_status NVARCHAR(50),
        new_status NVARCHAR(50),
        reason NVARCHAR(255),
        created_at DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_BookingQueueLog_Booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
    );
END
GO

INSERT INTO BookingSlot(slot_date, slot_time, max_capacity, reserved_vip_capacity, current_confirmed)
SELECT b.booking_date, b.booking_time, 3, 1,
       SUM(CASE WHEN UPPER(b.status) = 'CONFIRMED' THEN 1 ELSE 0 END)
FROM Booking b
WHERE NOT EXISTS (
    SELECT 1
    FROM BookingSlot bs
    WHERE bs.slot_date = b.booking_date AND bs.slot_time = b.booking_time
)
GROUP BY b.booking_date, b.booking_time;
GO
