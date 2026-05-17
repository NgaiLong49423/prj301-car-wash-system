<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Theo Dõi Điểm & Phần Thưởng</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
        .container { max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .points-box { text-align: center; background: #e8f5e9; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .points-box h3 { margin: 0; color: #2e7d32; font-size: 32px; }
        .reward-item { border: 1px solid #ddd; padding: 15px; margin-bottom: 15px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center; }
        .reward-info h4 { margin: 0 0 5px 0; color: #333; }
        .reward-info p { margin: 0; color: #666; font-size: 14px; }
        .btn-redeem { background-color: #1976d2; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-redeem:hover { background-color: #1565c0; }
        .btn-disabled { background-color: #e0e0e0; color: #9e9e9e; padding: 10px 20px; border: none; border-radius: 5px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Trang Thưởng & Điểm Tích Lũy</h2>
        
        <% 
            // Nhận dữ liệu từ Backend ném qua
            Integer points = (Integer) request.getAttribute("currentPoints");
            List<Map<String, Object>> rewards = (List<Map<String, Object>>) request.getAttribute("rewardsList");
            
            // Xử lý chống Null (Tránh lỗi sập trang)
            if (points == null) points = 0;
        %>

        <div class="points-box">
            <p>Số dư điểm hiện tại của bạn</p>
            <h3><%= points %> Điểm</h3>
        </div>

        <h3>Quà tặng có thể đổi:</h3>
        
        <% 
            if (rewards != null) {
                // Vòng lặp For để in HTML danh sách quà
                for (Map<String, Object> reward : rewards) {
                    int cost = (Integer) reward.get("cost");
                    String name = (String) reward.get("name");
        %>
                    <div class="reward-item">
                        <div class="reward-info">
                            <h4><%= name %></h4>
                            <p>Cần: <%= cost %> điểm</p>
                        </div>
                        <div>
                            <%-- Logic hiển thị nút: Đủ điểm thì sáng nút, thiếu điểm thì mờ nút --%>
                            <% if (points >= cost) { %>
                                <button class="btn-redeem">Đổi Thưởng</button>
                            <% } else { %>
                                <button class="btn-disabled" disabled>Chưa đủ điểm</button>
                            <% } %>
                        </div>
                    </div>
        <% 
                }
            } 
        %>
    </div>
</body>
</html>