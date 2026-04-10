<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    String lookupPlate = (String) request.getAttribute("lookupPlate");
    Integer lookupFee = (Integer) request.getAttribute("lookupFee");
    Integer lookupHours = (Integer) request.getAttribute("lookupHours");
    java.util.Date lookupCheckIn = (java.util.Date) request.getAttribute("lookupCheckIn");
    String lookupTicketId = (String) request.getAttribute("lookupTicketId");
    String lookupError = (String) request.getAttribute("lookupError");
    String ctx = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang ch&#7911; - Car Parking Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-page-home">
    <header class="pm-topbar pm-topbar-home">
        <h1 class="pm-topbar-logo"><a href="${pageContext.request.contextPath}/home">Online Car Parking System</a></h1>
        <nav class="pm-topbar-nav">
            <a href="${pageContext.request.contextPath}/home">HOME</a>
            <a href="${pageContext.request.contextPath}/login">LOGIN</a>
        </nav>
    </header>

    <section class="pm-hero-banner">
        <div class="pm-hero-banner-overlay"></div>
        <div class="pm-hero-banner-content">
            <h2 class="pm-hero-banner-title">
                <span class="pm-hero-title-line1">Car Parking Management</span>
                <span class="pm-hero-title-line2">System</span>
            </h2>
            <a href="#tra-cuu" class="pm-hero-scroll" aria-label="Xem th&#234;m">
                <span class="pm-hero-scroll-icon">&darr;</span>
            </a>
        </div>
    </section>

    <section id="tra-cuu" class="pm-home-lookup">
        <div class="pm-home-lookup-card">
            <h2 class="pm-home-lookup-title">Tra c&#7891;u ph&#237; g&#7917;i xe</h2>
            <p class="pm-home-lookup-desc">Nh&#7853;p bi&#7875;n s&#7889; xe &#273;&#7875; xem ph&#237; (xe &#273;ang g&#7917;i trong b&#227;i).</p>
            <form action="<%= ctx %>/home" method="post" class="pm-home-lookup-form">
                <input type="text" name="plate" placeholder="VD: 30A-12345" value="<%= lookupPlate != null ? lookupPlate : "" %>" required maxlength="20">
                <button type="submit" class="pm-btn pm-btn-primary" style="margin-top:0;width:auto;padding:12px 24px;">Xem ph&#237;</button>
            </form>
            <% if (lookupError != null) { %>
            <p class="pm-home-lookup-err"><%= lookupError %></p>
            <% } %>
            <% if (lookupFee != null && lookupPlate != null) { %>
            <div class="pm-home-lookup-result">
                <p class="pm-home-lookup-label">Bi&#7875;n s&#7889;</p>
                <p class="pm-home-lookup-value"><%= lookupPlate %></p>
                <% if (lookupTicketId != null) { %>
                <p class="pm-home-lookup-label">M&#227; v&#233;</p>
                <p class="pm-home-lookup-value"><%= lookupTicketId %></p>
                <% } %>
                <% if (lookupCheckIn != null) { %>
                <p class="pm-home-lookup-label">V&#224;o b&#227;i</p>
                <p class="pm-home-lookup-value"><%= sdf.format(lookupCheckIn) %></p>
                <% } %>
                <% if (lookupHours != null) { %>
                <p class="pm-home-lookup-label">S&#7889; gi&#7901;</p>
                <p class="pm-home-lookup-value"><%= lookupHours %> gi&#7901;</p>
                <% } %>
                <p class="pm-home-lookup-label">T&#7893;ng ph&#237; (&#432;&#7899;c t&#237;nh)</p>
                <p class="pm-home-lookup-fee"><%= lookupFee %> VN&#272;</p>
            </div>
            <% } %>
        </div>
    </section>

    <section id="packages" class="pm-packages">
        <h2 class="pm-packages-title">PACKAGES</h2>
        <div class="pm-packages-image-wrap">
            <div class="pm-packages-image-placeholder"></div>
            <img src="${pageContext.request.contextPath}/images/packages-parking.jpg" alt="Parking packages" class="pm-packages-image" onerror="this.style.display='none'">
        </div>
    </section>
</body>
</html>
