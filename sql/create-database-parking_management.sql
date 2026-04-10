USE master;
GO

IF DB_ID('parking_management') IS NOT NULL
BEGIN
    ALTER DATABASE parking_management SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE parking_management;
END
GO

CREATE DATABASE parking_management;
GO

USE parking_management;
GO

/* ============================================================
   PHẦN 1: BẢNG ParkingLot (Bãi xe) — tạo trước vì Users có FK tới đây
============================================================ */
CREATE TABLE ParkingLot (
    lotId      VARCHAR(20)  NOT NULL,
    lotName    VARCHAR(100) NOT NULL,
    address    VARCHAR(255) NULL,
    note       VARCHAR(255) NULL,
    status     BIT          NOT NULL DEFAULT 1,
    createdAt  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_ParkingLot PRIMARY KEY (lotId)
);
GO

/* ============================================================
   PHẦN 2: BẢNG Users (Tài khoản hệ thống)
============================================================ */
CREATE TABLE Users (
    userId        VARCHAR(20)  NOT NULL,
    username      VARCHAR(50)  NOT NULL,
    passwordHash  VARCHAR(255) NOT NULL,
    fullName      VARCHAR(100) NOT NULL,
    role          VARCHAR(10)  NOT NULL,  -- ADMIN / STAFF
    status        BIT          NOT NULL DEFAULT 1,
    createdAt     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lotId         VARCHAR(10)  NULL,      -- Bãi làm việc (chỉ Staff); Admin = NULL
    CONSTRAINT PK_Users PRIMARY KEY (userId),
    CONSTRAINT UQ_Users_username UNIQUE (username),
    CONSTRAINT CK_Users_role CHECK (role IN ('ADMIN', 'STAFF')),
    CONSTRAINT FK_Users_Lot FOREIGN KEY (lotId) REFERENCES ParkingLot(lotId)
);
GO

/* ============================================================
   PHẦN 3: BẢNG ParkingSlot (Ô đỗ xe)
============================================================ */
CREATE TABLE ParkingSlot (
    slotId     VARCHAR(20)  NOT NULL,
    lotId      VARCHAR(20)  NOT NULL,
    slotCode   VARCHAR(20)  NOT NULL,
    status     VARCHAR(10)  NOT NULL DEFAULT 'EMPTY',
    note       VARCHAR(255) NULL,
    createdAt  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_ParkingSlot PRIMARY KEY (slotId),
    CONSTRAINT FK_ParkingSlot_Lot FOREIGN KEY (lotId)
        REFERENCES ParkingLot(lotId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT UQ_ParkingSlot_lot_slot UNIQUE (lotId, slotCode),
    CONSTRAINT CK_ParkingSlot_status CHECK (status IN ('EMPTY','OCCUPIED','DISABLED'))
);
GO

/* ============================================================
   PHẦN 4: BẢNG Pricing (Bảng giá gửi xe)
============================================================ */
CREATE TABLE Pricing (
    pricingId     VARCHAR(20) NOT NULL,
    vehicleType   VARCHAR(10) NOT NULL DEFAULT 'CAR',
    pricePerHour  INT         NOT NULL,
    overnightFee  INT         NOT NULL,
    active        BIT         NOT NULL DEFAULT 1,
    createdAt     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Pricing PRIMARY KEY (pricingId),
    CONSTRAINT CK_Pricing_vehicle CHECK (vehicleType IN ('CAR')),
    CONSTRAINT CK_Pricing_price CHECK (pricePerHour >= 0 AND overnightFee >= 0)
);
GO

/* ============================================================
   PHẦN 5: BẢNG ParkingTicket (Vé gửi xe / Lượt gửi xe)
============================================================ */
CREATE TABLE ParkingTicket (
    ticketId         VARCHAR(20)  NOT NULL,
    lotId            VARCHAR(20)  NOT NULL,
    slotId           VARCHAR(20)  NULL,
    vehiclePlate     VARCHAR(20)  NOT NULL,
    checkInTime      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    checkOutTime     DATETIME     NULL,
    staffCheckInId   VARCHAR(20)  NOT NULL,
    staffCheckOutId  VARCHAR(20)  NULL,
    pricingId        VARCHAR(20)  NOT NULL,
    totalHours       INT          NULL,
    isOvernight      BIT          NULL,
    totalFee         INT          NULL,
    status           VARCHAR(10)  NOT NULL DEFAULT 'PARKING',
    note             VARCHAR(255) NULL,
    CONSTRAINT PK_ParkingTicket PRIMARY KEY (ticketId),
    CONSTRAINT FK_Ticket_Lot FOREIGN KEY (lotId)
        REFERENCES ParkingLot(lotId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT FK_Ticket_Slot FOREIGN KEY (slotId)
        REFERENCES ParkingSlot(slotId)
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT FK_Ticket_Pricing FOREIGN KEY (pricingId)
        REFERENCES Pricing(pricingId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT FK_Ticket_StaffIn FOREIGN KEY (staffCheckInId)
        REFERENCES Users(userId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT FK_Ticket_StaffOut FOREIGN KEY (staffCheckOutId)
        REFERENCES Users(userId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT CK_Ticket_status CHECK (status IN ('PARKING','FINISHED','CANCELLED')),
    CONSTRAINT CK_Ticket_hours CHECK (totalHours IS NULL OR totalHours >= 0),
    CONSTRAINT CK_Ticket_fee CHECK (totalFee IS NULL OR totalFee >= 0)
);
GO

/* ============================================================
   PHẦN 6: INDEX
============================================================ */
CREATE INDEX IDX_Ticket_vehiclePlate ON ParkingTicket(vehiclePlate);
CREATE INDEX IDX_Ticket_status ON ParkingTicket(status);
CREATE INDEX IDX_Ticket_lot_status ON ParkingTicket(lotId, status);
CREATE INDEX IDX_Ticket_checkInTime ON ParkingTicket(checkInTime);
CREATE INDEX IDX_Ticket_checkOutTime ON ParkingTicket(checkOutTime);
CREATE INDEX IDX_Slot_lot_status ON ParkingSlot(lotId, status);
GO

/* ============================================================
   PHẦN 7: TRIGGER tự cập nhật trạng thái ô đỗ
============================================================ */
IF OBJECT_ID('TRG_Ticket_Insert_OccupySlot', 'TR') IS NOT NULL
    DROP TRIGGER TRG_Ticket_Insert_OccupySlot;
GO
IF OBJECT_ID('TRG_Ticket_Finish_FreeSlot', 'TR') IS NOT NULL
    DROP TRIGGER TRG_Ticket_Finish_FreeSlot;
GO

CREATE TRIGGER TRG_Ticket_Insert_OccupySlot
ON ParkingTicket
AFTER INSERT
AS
BEGIN
    UPDATE ps
    SET ps.status = 'OCCUPIED'
    FROM ParkingSlot ps
    INNER JOIN inserted i ON ps.slotId = i.slotId
    WHERE i.status = 'PARKING' AND i.slotId IS NOT NULL;
END;
GO

CREATE TRIGGER TRG_Ticket_Finish_FreeSlot
ON ParkingTicket
AFTER UPDATE
AS
BEGIN
    UPDATE ps
    SET ps.status = 'EMPTY'
    FROM ParkingSlot ps
    INNER JOIN inserted i ON ps.slotId = i.slotId
    INNER JOIN deleted d ON d.ticketId = i.ticketId
    WHERE d.status = 'PARKING' AND i.status = 'FINISHED' AND i.slotId IS NOT NULL;
END;
GO

/* ============================================================
   PHẦN 8: INSERT SAMPLE DATA
   Lưu ý: Users phải tạo SAU ParkingLot (vì FK Users.lotId -> ParkingLot)
============================================================ */

-- 1. PARKING LOT
INSERT INTO ParkingLot (lotId, lotName, address, note)
VALUES
('LOT01', 'Central Parking', '123 Main Street', 'Main city parking lot');
GO

-- 2. USERS (admin lotId=NULL; staff gán LOT01). Lưu ý: mật khẩu '123' nên đổi thành hash thật khi đăng nhập (app dùng PBKDF2).
INSERT INTO Users (userId, username, passwordHash, fullName, role, lotId)
VALUES
('U001', 'admin', '123', 'System Administrator', 'ADMIN', NULL),
('U002', 'staff1', '123', 'Nguyen Van A', 'STAFF', 'LOT01'),
('U003', 'staff2', '123', 'Tran Thi B', 'STAFF', 'LOT01');
GO

-- 3. PARKING SLOT
INSERT INTO ParkingSlot (slotId, lotId, slotCode)
VALUES
('S001', 'LOT01', 'A1'),
('S002', 'LOT01', 'A2'),
('S003', 'LOT01', 'A3'),
('S004', 'LOT01', 'A4'),
('S005', 'LOT01', 'A5');
GO

-- 4. PRICING
INSERT INTO Pricing (pricingId, vehicleType, pricePerHour, overnightFee)
VALUES
('P001', 'CAR', 10000, 50000);
GO

-- 5. SAMPLE PARKING TICKET (Đang gửi xe)
INSERT INTO ParkingTicket (
    ticketId,
    lotId,
    slotId,
    vehiclePlate,
    staffCheckInId,
    pricingId
)
VALUES
('T001', 'LOT01', 'S001', '51A-12345', 'U002', 'P001');
GO
