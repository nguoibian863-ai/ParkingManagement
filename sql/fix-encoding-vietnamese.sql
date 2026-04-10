-- Sửa lỗi hiển thị tiếng Việt (T?ng -> Tầng): đổi cột sang NVARCHAR và cập nhật dữ liệu
-- Chạy trên database parking_management ĐÃ TỒN TẠI (không drop DB)

USE parking_management;
GO

-- Đổi kiểu cột ParkingLot (nếu đang là VARCHAR)
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.ParkingLot') AND name = 'lotName')
BEGIN
    ALTER TABLE ParkingLot ALTER COLUMN lotName NVARCHAR(100) NOT NULL;
    ALTER TABLE ParkingLot ALTER COLUMN address NVARCHAR(255) NULL;
    ALTER TABLE ParkingLot ALTER COLUMN note NVARCHAR(255) NULL;
END
GO

-- Cập nhật lại tên bãi có dấu
UPDATE ParkingLot SET lotName = N'Parking Tầng 2', note = N'Bãi tầng 2' WHERE lotId = 'LOT02';
UPDATE ParkingLot SET note = N'Bãi tầng 1' WHERE lotId = 'LOT01';
GO

-- Users.fullName (nếu cần)
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Users') AND name = 'fullName')
    ALTER TABLE Users ALTER COLUMN fullName NVARCHAR(100) NOT NULL;
GO

PRINT 'Da cap nhat encoding. Khoi dong lai ung dung va F5 trang de xem.';
GO
