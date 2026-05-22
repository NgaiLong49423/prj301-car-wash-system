<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ Sơ Khách Hàng - AutoWash Pro</title>
    <style>
        /* Một chút CSS cho giao diện đẹp và giống Dashboard */
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            background-color: #f4f7f6; 
            display: flex; 
            justify-content: center; 
            padding-top: 50px; 
        }
        .profile-card { 
            background: white; 
            padding: 30px; 
            border-radius: 15px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1); 
            text-align: center; 
            width: 350px; 
        }
        .tier-badge { 
            display: inline-block; 
            padding: 10px 20px; 
            border-radius: 25px; 
            font-weight: bold; 
            margin: 15px 0;
            background-color: #ffd700; /* Màu vàng Gold mặc định */
            color: #333;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .info-group { 
            text-align: left; 
            margin-top: 20px; 
            border-top: 2px solid #eee; 
            padding-top: 20px; 
        }
        .info-group p { 
            margin: 12px 0; 
            color: #555; 
            font-size: 16px;
        }
        .info-group strong { 
            color: #222; 
        }
        .points {
            color: #e74c3c; 
            font-size: 1.3em; 
            font-weight: bold;
        }
    </style>
</head>
<body>

    <div class="profile-card">
        <h2>Xin chào, ${USER_PROFILE.fullName}!</h2>

        <div class="tier-badge">
            HẠNG: ${USER_PROFILE.tierName}
        </div>
        
        <div class="info-group">
            <p><strong>📞 Số điện thoại:</strong> ${USER_PROFILE.phone}</p>
            <p><strong>🚗 Biển số xe:</strong> ${USER_PROFILE.licensePlate}</p>
            <p><strong>⭐ Điểm tích lũy:</strong> <span class="points">${USER_PROFILE.totalPoints}</span> điểm</p>
        </div>
    </div>

</body>
</html>