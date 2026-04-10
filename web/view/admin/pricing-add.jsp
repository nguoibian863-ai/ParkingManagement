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
    String nextId = (String) request.getAttribute("nextId");
    if (nextId == null) nextId = "P001";
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Th&#234;m b&#7843;ng gi&#225; - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Th&#234;m b&#7843;ng gi&#225;</h2>
            <% if (error != null) { %><p class="pm-error" style="max-width:400px;"><%= error %></p><% } %>
            <div class="pm-dash-table-wrap" style="max-width:480px;">
                <form action="<%= ctx %>/admin/pricing?action=add" method="post" class="pm-form" style="padding:24px;">
                    <div class="pm-form-group">
                        <label>M&#227; b&#7843;ng gi&#225;</label>
                        <input type="text" name="pricingId" value="<%= nextId %>" required readonly style="background:#f1f5f9;">
                    </div>
                    <div class="pm-form-group">
                        <label>Lo&#7841;i xe</label>
                        <select name="vehicleType">
                            <option value="CAR">&#212; t&#244; (CAR)</option>
                        </select>
                    </div>
                    <div class="pm-form-group">
                        <label>Gi&#225;/gi&#7901; (VN&#272;)</label>
                        <input type="number" name="pricePerHour" min="0" value="10000" required>
                    </div>
                    <div class="pm-form-group">
                        <label>Qua &#273;&#234;m (VN&#272;)</label>
                        <input type="number" name="overnightFee" min="0" value="50000">
                    </div>
                    <div class="pm-form-group">
                        <label><input type="checkbox" name="active" value="1" checked> &#193;p d&#7909;ng</label>
                    </div>
                    <button type="submit" class="pm-btn pm-btn-primary">Th&#234;m</button>
                    <a href="<%= ctx %>/admin/pricing" class="pm-btn pm-btn-outline" style="display:inline-block;width:auto;margin-left:12px;">H&#7917;y</a>
                </form>
            </div>
            
        </main>
    </div>
</body>
</html>
