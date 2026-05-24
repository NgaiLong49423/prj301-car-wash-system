<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ Sơ Khách Hàng - AutoWash Pro</title>
    <style>
        /* Nhúng font chữ hiện đại từ Google */
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap');

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        
        body {
            /* Nền gradient xanh đại dương cao cấp */
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .profile-card {
            background: #ffffff;
            width: 420px;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            overflow: hidden;
            text-align: center;
            position: relative;
        }

        /* Phần ảnh bìa phía trên thẻ */
        .card-header {
            background: url('https://images.unsplash.com/photo-1601362840469-51e4d8d58785?auto=format&fit=crop&w=800&q=80') center/cover;
            height: 140px;
            position: relative;
        }
        
        .card-header::after {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.4); /* Làm tối ảnh bìa một chút */
        }

        /* Avatar khách hàng */
        .avatar {
            width: 100px;
            height: 100px;
            background: #fff;
            border-radius: 50%;
            border: 4px solid #fff;
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
            position: absolute;
            top: 90px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 10;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 45px;
        }

        .card-body {
            padding: 70px 30px 40px;
        }

        h2 { color: #2c3e50; font-size: 26px; font-weight: 700; margin-bottom: 5px; }

        /* Huy hiệu hạng thẻ lấp lánh */
        .tier-badge {
            display: inline-block;
            padding: 8px 30px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 15px;
            margin: 10px 0 25px;
            text-transform: uppercase;
            letter-spacing: 2px;
            /* Màu Gradient Vàng Ánh Kim */
            background: linear-gradient(45deg, #BF953F, #FCF6BA, #B38728, #FBF5B7, #AA771C);
            color: #000;
            box-shadow: 0 5px 15px rgba(191, 149, 63, 0.5);
        }

        /* Khung chứa thông tin */
        .info-group {
            text-align: left;
            background: #f4f7f6;
            padding: 25px;
            border-radius: 15px;
        }

        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #e1e8ed;
            padding-bottom: 15px;
        }

        .info-item:last-child { margin-bottom: 0; border-bottom: none; padding-bottom: 0; }

        .info-icon {
            font-size: 24px;
            margin-right: 18px;
            width: 30px;
            text-align: center;
        }

        .info-text span { 
            display: block; 
            font-size: 12px; 
            color: #7f8c8d; 
            text-transform: uppercase; 
            letter-spacing: 1px; 
        }

        .info-text strong { 
            color: #2c3e50; 
            font-size: 17px; 
            font-weight: 600; 
        }

        .points-highlight { 
            color: #e74c3c !important; 
            font-size: 20px !important; 
        }
        /* Nút Đăng xuất */
        .logout-btn {
            display: inline-block;
            margin-top: 25px;
            padding: 12px 35px;
            background-color: #e74c3c;
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.4);
        }

        .logout-btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(231, 76, 60, 0.6);
        }
    </style>
</head>
<body>

    <div class="profile-card">
        <div class="card-header"></div>
        <div class="avatar">👤</div>
        
        <div class="card-body">
            <h2>${USER_PROFILE.fullName}</h2>
            <div class="tier-badge">${USER_PROFILE.tierName}</div>
            
            <div class="info-group">
                <div class="info-item">
                    <div class="info-icon">📞</div>
                    <div class="info-text">
                        <span>Số điện thoại liên lạc</span>
                        <strong>${USER_PROFILE.phone}</strong>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">🚘</div>
                    <div class="info-text">
                        <span>Biển số xe đăng ký</span>
                        <strong>${USER_PROFILE.licensePlate}</strong>
                    </div>
                </div>
                
                <div class="info-item">
                    <div class="info-icon">⭐</div>
                    <div class="info-text">
                        <span>Điểm thưởng tích lũy</span>
                        <strong class="points-highlight">${USER_PROFILE.totalPoints} pts</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
                    <a href="LogoutServlet" class="logout-btn">Đăng xuất</a>

</body>
</html>