-- Dữ liệu test cho parking_management
-- Chạy file này TRÊN DATABASE ĐÃ TẠO (đã chạy create-database-parking_management-fixed.sql)
-- Nếu chạy lần đầu sau khi tạo DB: một số INSERT có thể báo lỗi trùng (đã có sẵn trong script chính). Bỏ qua hoặc chạy từ dòng chưa có.

USE parking_management;
GO

-- Bãi 2 (nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM ParkingLot WHERE lotId = 'LOT02')
INSERT INTO ParkingLot (lotId, lotName, address, note)
VALUES ('LOT02', N'Parking Tầng 2', N'123 Main Street', N'Bãi tầng 2');
GO

-- Staff tại bãi 2 (nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM Users WHERE userId = 'U004')
INSERT INTO Users (userId, username, passwordHash, fullName, role, lotId)
VALUES ('U004', 'staff3', '123', N'Le Van C', 'STAFF', 'LOT02');
GO

-- Ô đỗ bãi 2 (nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM ParkingSlot WHERE slotId = 'S006')
INSERT INTO ParkingSlot (slotId, lotId, slotCode)
VALUES
('S006', 'LOT02', 'B1'),
('S007', 'LOT02', 'B2'),
('S008', 'LOT02', 'B3'),
('S009', 'LOT02', 'B4'),
('S010', 'LOT02', 'B5');
GO

-- Bảng giá thứ 2 (nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM Pricing WHERE pricingId = 'P002')
INSERT INTO Pricing (pricingId, vehicleType, pricePerHour, overnightFee)
VALUES ('P002', 'CAR', 15000, 60000);
GO

-- Vé đã thanh toán (test báo cáo) — chỉ thêm nếu chưa có T002, T003
IF NOT EXISTS (SELECT 1 FROM ParkingTicket WHERE ticketId = 'T002')
INSERT INTO ParkingTicket (ticketId, lotId, slotId, vehiclePlate, checkInTime, checkOutTime, staffCheckInId, staffCheckOutId, pricingId, totalHours, isOvernight, totalFee, status)
VALUES ('T002', 'LOT01', 'S002', '30B-67890', DATEADD(hour, -2, GETDATE()), GETDATE(), 'U002', 'U002', 'P001', 2, 0, 20000, 'FINISHED');
GO
IF NOT EXISTS (SELECT 1 FROM ParkingTicket WHERE ticketId = 'T003')
INSERT INTO ParkingTicket (ticketId, lotId, slotId, vehiclePlate, checkInTime, checkOutTime, staffCheckInId, staffCheckOutId, pricingId, totalHours, isOvernight, totalFee, status)
VALUES ('T003', 'LOT02', 'S006', '59A-11111', DATEADD(day, -1, GETDATE()), DATEADD(day, -1, GETDATE()), 'U004', 'U004', 'P001', 3, 1, 80000, 'FINISHED');
GO
UPDATE ParkingSlot SET status = 'EMPTY' WHERE slotId IN ('S002', 'S006');
GO

PRINT 'Da them du lieu test.';
SELECT 'Users' AS tbl, COUNT(*) AS cnt FROM Users
UNION ALL SELECT 'ParkingLot', COUNT(*) FROM ParkingLot
UNION ALL SELECT 'ParkingSlot', COUNT(*) FROM ParkingSlot
UNION ALL SELECT 'Pricing', COUNT(*) FROM Pricing
UNION ALL SELECT 'ParkingTicket', COUNT(*) FROM ParkingTicket;
GO
