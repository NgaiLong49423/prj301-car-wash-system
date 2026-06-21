USE AutoWashPro_DB;
GO

/*
    Hidden Priority Booking
    Script nay chi them bang phu cho backend, khong thay doi giao dien nguoi dung.

    Booking.status se duoc backend cap nhat thanh:
    - CONFIRMED: nam trong 10 slot chinh cua ca
    - BACKUP_CONFIRMED: nam trong 3 slot backup cua ca
    - WAITING: vao danh sach cho
*/

IF OBJECT_ID('BookingPriorityAllocation', 'U') IS NULL
BEGIN
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
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_BookingPriorityAllocation_Booking')
BEGIN
    CREATE UNIQUE INDEX UX_BookingPriorityAllocation_Booking
    ON BookingPriorityAllocation(booking_id);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_BookingPriorityAllocation_AssignedSlot')
BEGIN
    CREATE UNIQUE INDEX UX_BookingPriorityAllocation_AssignedSlot
    ON BookingPriorityAllocation(booking_date, shift_name, slot_type, slot_order)
    WHERE slot_type IN ('MAIN', 'BACKUP');
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BookingPriorityAllocation_Waiting')
BEGIN
    CREATE INDEX IX_BookingPriorityAllocation_Waiting
    ON BookingPriorityAllocation(booking_date, shift_name, slot_type, priority_rank DESC, created_at ASC);
END
GO
