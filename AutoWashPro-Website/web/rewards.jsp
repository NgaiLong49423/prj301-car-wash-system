<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.RewardDTO" %>
<html>
<head>
    <title>Theo Dõi Điểm & Phần Thưởng</title>
    <style>
        /* CSS nội bộ viết ngắn gọn để UI nhìn sạch sẽ, thực dụng */
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { border-collapse: collapse; width: 100%; max-width: 800px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn-redeem { padding: 6px 12px; background: #28a745; color: white; text-decoration: none; border-radius: 4px; }
        .disabled { color: gray; }
    </style>
</head>
<body>

    <% 
        // Ép kiểu (Casting) dữ liệu lấy từ Request về đúng chuẩn ban đầu
        int userPoints = (Integer) request.getAttribute("USER_POINTS"); 
    %>
    <h2>Điểm hiện tại của bạn: <span style="color: blue;"><%= userPoints %></span> điểm</h2>

    <h3>Danh sách các phần thưởng có thể đổi:</h3>
    <table>
        <tr>
            <th>Tên Phần Thưởng</th>
            <th>Điểm Yêu Cầu</th>
            <th>Mô Tả</th>
            <th>Thao Tác</th>
        </tr>
        
        <%
            // Lấy danh sách phần thưởng từ Request
            List<RewardDTO> rewardList = (List<RewardDTO>) request.getAttribute("REWARD_LIST");
            
            if (rewardList != null) {
                // Chạy vòng lặp for để in từng dòng <tr> (Table Row) ra HTML
                for (RewardDTO reward : rewardList) {
        %>
            <tr>
                <td><%= reward.getRewardName() %></td>
                <td><%= reward.getPointsRequired() %></td>
                <td><%= reward.getDescription() %></td>
                <td>
                    <% 
                        // Logic thực dụng: Điểm thực tế >= Điểm yêu cầu thì mới hiện nút Đổi thưởng
                        if (userPoints >= reward.getPointsRequired()) { 
                    %>
                        <a href="redeem?rewardId=<%= reward.getRewardId() %>" class="btn-redeem">Đổi Thưởng</a>
                    <% 
                        } else { 
                    %>
                        <span class="disabled">Chưa đủ điểm</span>
                    <% 
                        } 
                    %>
                </td>
            </tr>
        <%
                }
            }
        %>
    </table>

</body>
</html>