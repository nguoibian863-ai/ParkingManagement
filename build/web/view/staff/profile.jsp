<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    if (session.getAttribute("account") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    model.User acc = (model.User) session.getAttribute("account");
    if (!"STAFF".equalsIgnoreCase(acc.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Th&#244;ng tin c&#225; nh&#226;n - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/staff/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/staff/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Th&#244;ng tin c&#225; nh&#226;n</h2>
            <div class="pm-info-grid" style="max-width:520px;">
                <div class="pm-info-row"><span class="pm-info-label">M&#227; t&#224;i kho&#7843;n</span><span class="pm-info-value"><%= acc.getUserId() %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">T&#234;n &#273;&#259;ng nh&#7853;p</span><span class="pm-info-value"><%= acc.getUsername() != null ? acc.getUsername() : "-" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">H&#7885; v&#224; t&#234;n</span><span class="pm-info-value"><%= acc.getFullname() != null ? acc.getFullname() : "-" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">Vai tr&#242;</span><span class="pm-info-value"><%= acc.getRole() != null ? acc.getRole() : "-" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">Tr&#7841;ng th&#225;i</span><span class="pm-info-value"><%= acc.isStatus() ? "Ho&#7841;t &#273;&#7897;ng" : "Kh&#243;a" %></span></div>
                <% if (acc.getCreateAt() != null) { %>
                <div class="pm-info-row"><span class="pm-info-label">Ng&#224;y t&#7841;o</span><span class="pm-info-value"><%= sdf.format(acc.getCreateAt()) %></span></div>
                <% } %>
            </div>
            <p style="margin-top:20px;"><a href="<%= ctx %>/staff" class="pm-btn pm-btn-outline" style="width:auto;display:inline-block;padding:10px 20px;">&#8592; V&#7873; trang Staff</a></p>
        </main>
    </div>
</body>
</html>
