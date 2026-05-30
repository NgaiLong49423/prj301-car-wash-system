<%@page import="java.util.ArrayList"%>
<%@page import="dto.Vehicle"%>
<%@page import="dto.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Luxe Wash - Hồ Sơ Khách Hàng</title>
    <style>
        /* CSS reset & Google Fonts */
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        
        body {
            background-color: #121212; 
            color: #ffffff;
            padding-bottom: 50px;
        }

        /* --- THANH ĐIỀU HƯỚNG (NAVBAR) --- */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 50px;
            border-bottom: 1px solid #2a2a2a;
        }
        .navbar .logo { font-size: 24px; font-weight: 700; color: #a5b4fc; }
        .navbar .logo span { color: #ffffff; }
        .nav-links a { color: #a0a0a0; text-decoration: none; margin: 0 20px; font-size: 14px; }
        .nav-links a.active { color: #ffffff; border-bottom: 2px solid #a5b4fc; padding-bottom: 5px; }
        .nav-actions .btn-book { background-color: #a5b4fc; color: #121212; padding: 10px 20px; border-radius: 5px; text-decoration: none; font-weight: 600; font-size: 14px; }

        /* --- BỐ CỤC CHÍNH (LAYOUT) --- */
        .container {
            display: flex;
            gap: 30px;
            max-width: 1100px;
            margin: 40px auto 0;
        }

        /* --- CỘT TRÁI: THÔNG TIN CÁ NHÂN --- */
        .sidebar { width: 320px; }
        .profile-card {
            background-color: #1a1a1c;
            border: 1px solid #2a2a2a;
            border-radius: 12px;
            padding: 30px 20px;
            text-align: center;
        }
        .avatar-wrap {
            width: 100px; height: 100px;
            border-radius: 50%;
            border: 2px solid #d4af37; 
            margin: 0 auto 15px;
            padding: 3px;
        }
        .avatar { width: 100%; height: 100%; background-color: #333; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 40px; }
        .profile-card h2 { font-size: 20px; font-weight: 600; margin-bottom: 5px; }
        .profile-card p.phone { color: #a0a0a0; font-size: 14px; margin-bottom: 15px; }
        .tier-badge {
            display: inline-block;
            border: 1px solid #d4af37; color: #d4af37;
            padding: 4px 12px; border-radius: 20px;
            font-size: 12px; font-weight: 600; margin-bottom: 25px;
            text-transform: uppercase;
        }
        .points-box { text-align: left; border-top: 1px solid #2a2a2a; padding-top: 20px; }
        .points-box span { color: #a0a0a0; font-size: 12px; text-transform: uppercase; }
        .points-box h3 { font-size: 28px; margin: 5px 0 10px; color: #d4af37; }
        
        /* --- CỘT PHẢI: DANH SÁCH XE & CÀI ĐẶT --- */
        .main-content { flex: 1; }
        
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .section-header h3 { font-size: 18px; display: flex; align-items: center; gap: 10px; }
        .btn-add-car { color: #a5b4fc; text-decoration: none; font-size: 14px; }

        .cars-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 40px; }
        .car-card {
            background-color: #1a1a1c; border: 1px solid #2a2a2a;
            border-radius: 12px; overflow: hidden;
        }
        .car-img {
            height: 140px; background-color: #222;
            background-image: url('https://images.unsplash.com/photo-1614200179396-2bdb77ebf81b?auto=format&fit=crop&w=600&q=80');
            background-size: cover; background-position: center; position: relative;
        }
        .car-plate {
            position: absolute; bottom: 10px; left: 15px;
            background: rgba(0,0,0,0.7); padding: 4px 10px;
            border-radius: 4px; font-size: 14px; font-weight: 600; border: 1px solid #444;
        }
        .car-info { padding: 15px; }
        .car-info h4 { font-size: 16px; margin-bottom: 8px; }
        .car-meta { display: flex; gap: 15px; color: #a0a0a0; font-size: 12px; margin-bottom: 15px; }
        .btn-book-car {
            display: block; width: 100%; padding: 10px 0;
            background-color: transparent; border: 1px solid #444; color: #fff;
            border-radius: 6px; cursor: pointer; text-align: center; text-decoration: none; font-size: 13px;
        }
        .btn-book-car:hover { background-color: #333; }

        /* --- DANH SÁCH CÀI ĐẶT --- */
        .settings-list { background-color: #1a1a1c; border: 1px solid #2a2a2a; border-radius: 12px; }
        .settings-item {
            display: flex; justify-content: space-between; padding: 20px;
            border-bottom: 1px solid #2a2a2a; color: #fff; text-decoration: none; font-size: 15px;
        }
        .settings-item:last-child { border-bottom: none; }
        .settings-item.logout { color: #fc8181; } 
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo">Luxe <span>Wash</span></div>
        <div class="nav-links">
            <a href="#">Home</a>
            <a href="#">Services</a>
            <a href="#">Locations</a>
            <a href="#" class="active">Membership</a>
        </div>
        <div class="nav-actions">
            <a href="#" class="btn-book">Book Now</a>
        </div>
    </nav>

    <div class="container">
        <div class="sidebar">
            <div class="profile-card">
                <div class="avatar-wrap">
                    <div class="avatar">👤</div>
                </div>
                <h2>${USER_PROFILE.fullName != null ? USER_PROFILE.fullName : 'Chưa cập nhật tên'}</h2>
                <p class="phone">${USER_PROFILE.phone != null ? USER_PROFILE.phone : 'Chưa có SĐT'}</p>
                
                <div class="tier-badge">⭐ ${USER_PROFILE.tierName}</div>
                
                <div class="points-box">
                    <span>SỐ ĐIỂM TÍCH LŨY</span>
                    <h3>${USER_PROFILE.totalPoints} pts</h3>
                </div>
            </div>
        </div>

        <div class="main-content">
            
            <div class="section-header">
                <h3>🚘 Xe của tôi</h3>
                <a href="#" class="btn-add-car">+ Thêm xe mới</a>
            </div>

            <div class="cars-grid">
                <%-- VÒNG LẶP JAVA IN DANH SÁCH XE (Bỏ ngày tháng theo DB của Leader) --%>
                <%
                    ArrayList<Vehicle> cars = (ArrayList<Vehicle>) request.getAttribute("LIST_CARS");
                    if (cars != null && !cars.isEmpty()) {
                        for (Vehicle car : cars) {
                %>
                <div class="car-card">
                    <div class="car-img">
                        <div class="car-plate"><%= car.getLicensePlate() %></div>
                    </div>
                    <div class="car-info">
                        <h4><%= car.getBrand() %> <%= car.getModel() %></h4>
                        <div class="car-meta">
                            <span>🎨 <%= car.getColor() %></span>
                        </div>
                        <a href="#" class="btn-book-car">Đặt lịch rửa xe này</a>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                    <p style="color: #a0a0a0; grid-column: span 2;">Bạn chưa có phương tiện nào trong Garage.</p>
                <%
                    }
                %>
            </div>

            <div class="section-header">
                <h3>Cài đặt tài khoản</h3>
            </div>
            <div class="settings-list">
                <a href="#" class="settings-item"><span>👤 Thông tin cá nhân</span> <span>></span></a>
                <a href="#" class="settings-item"><span>🕒 Lịch sử dịch vụ</span> <span>></span></a>
                <a href="LogoutServlet" class="settings-item logout"><span>🚪 Đăng xuất</span></a>
            </div>

        </div>
    </div>

</body>
</html>