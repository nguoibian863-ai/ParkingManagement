<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    model.User acc = (model.User) session.getAttribute("account");
    if (!"ADMIN".equalsIgnoreCase(acc.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    int revenueToday = request.getAttribute("revenueToday") != null ? (Integer) request.getAttribute("revenueToday") : 0;
    int revenueMonth = request.getAttribute("revenueMonth") != null ? (Integer) request.getAttribute("revenueMonth") : 0;
    int countParking = request.getAttribute("countParking") != null ? (Integer) request.getAttribute("countParking") : 0;
    int countEmptySlots = request.getAttribute("countEmptySlots") != null ? (Integer) request.getAttribute("countEmptySlots") : 0;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>B&#225;o c&#225;o - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">B&#225;o c&#225;o &amp; Th&#7889;ng k&#234;</h2>
            <div class="pm-stat-cards">
                <div class="pm-stat-card" style="background:linear-gradient(135deg,#0c4a6e,#0e7490);">
                    <div class="pm-stat-card-label">Doanh thu h&#244;m nay</div>
                    <div class="pm-stat-card-value"><%= revenueToday %> VN&#272;</div>
                </div>
                <div class="pm-stat-card" style="background:linear-gradient(135deg,#047857,#059669);">
                    <div class="pm-stat-card-label">Doanh thu th&#225;ng n&#224;y</div>
                    <div class="pm-stat-card-value"><%= revenueMonth %> VN&#272;</div>
                </div>
                <div class="pm-stat-card" style="background:linear-gradient(135deg,#b45309,#d97706);">
                    <div class="pm-stat-card-label">S&#7889; xe &#273;ang g&#7917;i</div>
                    <div class="pm-stat-card-value"><%= countParking %></div>
                </div>
                <div class="pm-stat-card" style="background:linear-gradient(135deg,#4f46e5,#6366f1);">
                    <div class="pm-stat-card-label">S&#7889; v&#7883; tr&#237; c&#242;n tr&#7889;ng</div>
                    <div class="pm-stat-card-value"><%= countEmptySlots %></div>
                </div>
            </div>
            
        </main>
    </div>
</body>
</html>
