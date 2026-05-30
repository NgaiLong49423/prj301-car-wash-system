<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng Ký Thành Viên - AutoWash Pro</title>
    <style>
        /* Mấy cái CSS này mình viết để căn chỉnh bố cục cho form nằm ngay ngắn ở giữa màn hình nhìn cho đẹp */
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .register-box { background: #ffffff; padding: 35px; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); width: 100%; max-width: 420px; box-sizing: border-box; }
        .register-box h2 { margin-bottom: 20px; color: #1a1a1a; text-align: center; font-size: 24px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; color: #444; font-weight: 600; font-size: 14px; }
        .form-group input { width: 100%; padding: 10px 12px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; box-sizing: border-box; transition: border-color 0.2s; }
        .form-group input:focus { border-color: #007bff; outline: none; }
        .btn-submit { width: 100%; padding: 12px; background-color: #007bff; border: none; color: white; font-size: 16px; font-weight: bold; border-radius: 5px; cursor: pointer; margin-top: 10px; }
        .btn-submit:hover { background-color: #0056b3; }
        .alert-danger { background-color: #f8d7da; color: #721c24; padding: 12px; border-radius: 5px; margin-bottom: 20px; font-size: 14px; border: 1px solid #f5c6cb; }
        .redirect-link { text-align: center; margin-top: 20px; font-size: 14px; color: #555; }
        .redirect-link a { color: #007bff; text-decoration: none; font-weight: 600; }
        .redirect-link a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="register-box">
    <h2>Tạo Tài Khoản Mới</h2>
    
    <% 
        // Viết đoạn mã nhỏ này để hứng thông báo lỗi từ Servlet gửi ra (nếu có lỗi xảy ra)
        String msgError = (String) request.getAttribute("error");
        if (msgError != null) {
    %>
        <div class="alert-danger"><%= msgError %></div>
    <% 
        } 
    %>

    <form action="${pageContext.request.contextPath}/register" method="POST">
        <div class="form-group">
            <label for="fullName">Họ và Tên</label>
            <input type="text" id="fullName" name="fullName" value="${fullName != null ? fullName : ''}" required placeholder="Nhập họ và tên đầy đủ">
        </div>
        
        <div class="form-group">
            <label for="email">Địa chỉ Email</label>
            <input type="email" id="email" name="email" value="${email != null ? email : ''}" required placeholder="example@gmail.com">
        </div>

        <div class="form-group">
            <label for="phone">Số Điện Thoại</label>
            <input type="tel" id="phone" name="phone" pattern="[0-9]{9,11}" value="${phone != null ? phone : ''}" required placeholder="Ví dụ: 0912345678">
        </div>

        <div class="form-group">
            <label for="password">Mật Khẩu</label>
            <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu">
        </div>

        <div class="form-group">
            <label for="confirmPassword">Xác Nhận Mật Khẩu</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Nhập lại mật khẩu phía trên">
        </div>

        <button type="submit" class="btn-submit">Đăng Ký</button>
    </form>

    <div class="redirect-link">
        Đã là thành viên? <a href="${pageContext.request.contextPath}/coming-soon.jsp">Đăng nhập tại đây</a>
    </div>
</div>

</body>
</html>