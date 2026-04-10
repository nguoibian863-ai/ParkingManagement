<%--
    Document   : login
    Parking Management - Login
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>&#272;&#259;ng nh&#7853;p - Parking Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-page-hero">
    <div class="pm-topbar">
        <h1 class="pm-topbar-logo"><a href="${pageContext.request.contextPath}/home">Online Car Parking System</a></h1>
        <nav class="pm-topbar-nav">
            <a href="${pageContext.request.contextPath}/home">HOME</a>
            <a href="${pageContext.request.contextPath}/login">LOGIN</a>
        </nav>
    </div>

    <div class="pm-hero-content">
        <h2 class="pm-hero-title">Car Parking Management System</h2>
        <p class="pm-hero-subtitle">H&#7879; th&#7889;ng qu&#7843;n l&#253; b&#227;i &#273;&#7895; xe</p>

        <main class="pm-hero-card has-strip">
            <div class="pm-strip"></div>
            <h2 class="pm-card-title">&#272;&#259;ng nh&#7853;p</h2>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="pm-form-group">
                    <label for="username">T&#234;n &#273;&#259;ng nh&#7853;p</label>
                    <input type="text" id="username" name="username" required placeholder="Nh&#7853;p username">
                </div>
                <div class="pm-form-group">
                    <label for="password">M&#7853;t kh&#7849;u</label>
                    <input type="password" id="password" name="password" required placeholder="Nh&#7853;p m&#7853;t kh&#7849;u">
                </div>
                <button type="submit" class="pm-btn pm-btn-primary">&#272;&#259;ng nh&#7853;p</button>
            </form>
            <% if (request.getAttribute("error") != null && !((String) request.getAttribute("error")).isEmpty()) { %>
                <div class="pm-error"><%= request.getAttribute("error") %></div>
            <% } %>
        </main>
    </div>
</body>
</html>
