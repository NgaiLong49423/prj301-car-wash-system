<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.User"%>

<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
</head>

<body>

<%

    User user = (User) session.getAttribute("account");

    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

%>

<h1>
    Welcome ${sessionScope.account.username}
</h1>

<a href="logout">
    Logout
</a>

</body>
</html>