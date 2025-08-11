-- Bảng tài khoản người dùng
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Admin', 'NhanVien')),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Bảng lịch sử đăng nhập / đăng xuất
CREATE TABLE LoginLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    LoginTime DATETIME DEFAULT GETDATE(),
    LogoutTime DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
ALTER TABLE LoginLogs
ADD Username VARCHAR(50) NULL;
UPDATE LoginLogs
SET Username = u.Username
FROM LoginLogs l
JOIN Users u ON l.UserID = u.UserID;


CREATE TABLE BanAn (
    BanID INT PRIMARY KEY IDENTITY(1,1),
    SoBan INT NOT NULL,
    TrangThai NVARCHAR(20) DEFAULT N'Trống' -- Trống, Đang phục vụ, Đã đặt
);
CREATE TABLE MonAn (
    MonAnID INT PRIMARY KEY IDENTITY(1,1),
    TenMon NVARCHAR(100) NOT NULL,
    Gia DECIMAL(18,2) NOT NULL,
    MoTa NVARCHAR(200),
    TrangThai NVARCHAR(20) DEFAULT N'Còn bán', -- Ẩn / Ngưng bán
    CreatedAt DATETIME DEFAULT GETDATE()
);
ALTER TABLE MonAn
ADD HinhAnh NVARCHAR(255)
-- Đơn hàng
CREATE TABLE DonHang (
    DonHangID INT PRIMARY KEY IDENTITY(1,1),
    BanID INT NOT NULL,
    UserID INT NOT NULL, -- Nhân viên tạo đơn
    TongTien DECIMAL(18,2) NOT NULL,
    NgayDat DATETIME DEFAULT GETDATE(),
    GhiChu NVARCHAR(200),
    FOREIGN KEY (BanID) REFERENCES BanAn(BanID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Chi tiết đơn hàng
CREATE TABLE ChiTietDonHang (
    ChiTietID INT PRIMARY KEY IDENTITY(1,1),
    DonHangID INT NOT NULL,
    MonAnID INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (DonHangID) REFERENCES DonHang(DonHangID),
    FOREIGN KEY (MonAnID) REFERENCES MonAn(MonAnID)
);
CREATE TABLE ThanhToan (
    ThanhToanID INT PRIMARY KEY IDENTITY(1,1),
    DonHangID INT NOT NULL,
    SoTienThanhToan DECIMAL(18,2) NOT NULL,
    PhuongThuc NVARCHAR(50) NOT NULL CHECK (PhuongThuc IN (N'Tiền mặt', N'Chuyển khoản', N'Thẻ', N'QR')),
    ThoiGianThanhToan DATETIME DEFAULT GETDATE(),
    TienKhachTra DECIMAL(18,2),
    TienThua DECIMAL(18,2),
    FOREIGN KEY (DonHangID) REFERENCES DonHang(DonHangID)
);
CREATE TABLE DiemTichLuy (
    DiemID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    SoDiem INT NOT NULL DEFAULT 0,
    NgayCapNhat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
-- Bảng khách hàng thân thiết
CREATE TABLE KhachHang (
    KhachHangID INT PRIMARY KEY IDENTITY(1,1),
    TenKhach NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15),
    NgayDangKy DATETIME DEFAULT GETDATE(),
    TongDiem INT DEFAULT 0
);
CREATE TABLE DoanhThu (
    DoanhThuID INT PRIMARY KEY IDENTITY(1,1),
    Ngay DATE NOT NULL UNIQUE,
    TongDoanhThu DECIMAL(18,2) NOT NULL DEFAULT 0,
    SoDonHang INT NOT NULL DEFAULT 0
);
CREATE TABLE DatBan (
    ID INT PRIMARY KEY IDENTITY(1,1),
    BanID INT,
    TenKhachHang NVARCHAR(100),
    SoDienThoai NVARCHAR(20),
    ThoiGianDat DATETIME,
    TrangThai NVARCHAR(20), -- Đã đặt, Đã đến, Hủy
    FOREIGN KEY (BanID) REFERENCES BanAn(BanID)
);

-- Thêm tài khoản
INSERT INTO Users (Username, Password, FullName, Phone, Role) VALUES
('ad', '224761', N'Quản trị viên', '0901234567', 'Admin'),
('nv', '1111', N'Nguyễn Văn Nhân', '0911111111', 'NhanVien');

ALTER TABLE DonHang
ADD KhachHangID INT NULL;

ALTER TABLE DonHang
ADD CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY (KhachHangID) REFERENCES KhachHang(KhachHangID);
