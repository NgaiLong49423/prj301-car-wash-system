-- =============================================
-- 1. TẠO DATABASE (Tự động xóa DB cũ nếu đã tồn tại để reset data)
-- =============================================
USE master;
GO

IF DB_ID('AutoWash_Project') IS NOT NULL
BEGIN
    -- Ngắt toàn bộ kết nối đang dùng DB này để ép xóa
    ALTER DATABASE AutoWash_Project SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AutoWash_Project;
END
GO

CREATE DATABASE AutoWash_Project;
GO

USE AutoWash_Project;
GO

-- =============================================
-- 2. TẠO CÁC BẢNG (TABLES) - Theo thứ tự chuẩn để không lỗi Khóa ngoại
-- =============================================

-- Bảng Hạng thành viên
CREATE TABLE Tier (
    TierID INT PRIMARY KEY,
    TierName NVARCHAR(50) NOT NULL,
    RequiredWashes INT NOT NULL,
    RequiredSpend DECIMAL(18,2) NOT NULL,
    PointMultiplier FLOAT NOT NULL
);

-- Bảng Tài khoản đăng nhập
CREATE TABLE Account (
    AccountID INT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Role VARCHAR(20) NOT NULL -- 'Admin' hoặc 'Customer'
);

-- Bảng Khách hàng (Liên kết với Account và Tier)
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID),
    FullName NVARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    LicensePlate VARCHAR(20) UNIQUE NOT NULL,
    TotalWashes INT DEFAULT 0,
    TotalSpend DECIMAL(18,2) DEFAULT 0,
    TierID INT FOREIGN KEY REFERENCES Tier(TierID)
);

-- Bảng Phần thưởng cấu hình sẵn
CREATE TABLE Reward_Promotion (
    RewardID INT PRIMARY KEY,
    RewardName NVARCHAR(100) NOT NULL,
    PointsCost INT NOT NULL
);

-- Bảng Đặt lịch rửa xe
CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    BookingDate DATETIME NOT NULL,
    ScheduledTime DATETIME NOT NULL,
    Status VARCHAR(20) NOT NULL -- 'Pending', 'Confirmed', 'Completed', 'Cancelled'
);

-- Bảng Lịch sử rửa xe (Ghi nhận thực tế)
CREATE TABLE Wash_History (
    WashID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    WashDate DATETIME NOT NULL,
    Amount DECIMAL(18,2) NOT NULL
);

-- Bảng Giao dịch điểm số (Cộng/Trừ điểm)
CREATE TABLE Point_Transaction (
    TransactionID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    PointsAdded INT NOT NULL, -- Số âm nếu là đổi điểm (Redeem)
    TransactionDate DATETIME NOT NULL,
    ExpiryDate DATETIME NOT NULL
);

-- =============================================
-- 3. INSERT DỮ LIỆU MẪU (MOCK DATA)
-- =============================================

INSERT INTO Tier (TierID, TierName, RequiredWashes, RequiredSpend, PointMultiplier)
VALUES 
(1, 'Member', 1, 0, 1.0),
(2, 'Silver', 5, 2000000, 1.1),
(3, 'Gold', 15, 6000000, 1.2),
(4, 'Platinum', 30, 15000000, 1.3);

INSERT INTO Account (AccountID, Username, Password, Role)
VALUES 
(1, 'admin', '123', 'Admin'),
(2, 'khachhang1', '123', 'Customer'),
(3, 'khachhang2', '123', 'Customer');

INSERT INTO Customer (CustomerID, AccountID, FullName, Phone, LicensePlate, TotalWashes, TotalSpend, TierID)
VALUES 
(1, 2, N'Nguyễn Văn A', '0901234567', '61B1-12345', 2, 500000, 1),
(2, 3, N'Trần Thị B', '0987654321', '59X1-98765', 16, 6500000, 3);

INSERT INTO Reward_Promotion (RewardID, RewardName, PointsCost)
VALUES 
(1, N'Đánh bóng miễn phí', 300),
(2, N'Rửa xe tiêu chuẩn', 500),
(3, N'Mã giảm giá 10%', 150);

INSERT INTO Booking (BookingID, CustomerID, BookingDate, ScheduledTime, Status)
VALUES 
(1, 1, GETDATE(), DATEADD(day, 2, GETDATE()), 'Pending'),
(2, 2, GETDATE(), DATEADD(day, 1, GETDATE()), 'Confirmed');

INSERT INTO Wash_History (WashID, CustomerID, WashDate, Amount)
VALUES 
(1, 1, '2026-05-01 09:00:00', 250000),
(2, 1, '2026-05-10 14:30:00', 250000),
(3, 2, '2026-05-12 10:00:00', 500000);

INSERT INTO Point_Transaction (TransactionID, CustomerID, PointsAdded, TransactionDate, ExpiryDate)
VALUES 
(1, 1, 250, '2026-05-01', DATEADD(year, 1, '2026-05-01')),
(2, 2, 600, '2025-06-01', DATEADD(year, 1, '2025-06-01'));

PRINT N'✅ Khởi tạo Database AutoWash_PRJ301 và chèn dữ liệu mẫu thành công!';