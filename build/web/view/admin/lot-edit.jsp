<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.ParkingLot"%>
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
    ParkingLot lot = (ParkingLot) request.getAttribute("lot");
    if (lot == null) {
        response.sendRedirect(request.getContextPath() + "/admin/lot");
        return;
    }
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S&#7917;a b&#227;i xe - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">S&#7917;a b&#227;i xe</h2>
            <% if (error != null) { %><p class="pm-error" style="max-width:400px;"><%= error %></p><% } %>
            <div class="pm-dash-table-wrap" style="max-width:520px;">
                <form action="<%= ctx %>/admin/lot?action=edit" method="post" class="pm-form" style="padding:24px;">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="lotId" value="<%= lot.getLotId() %>">
                    <div class="pm-form-group">
                        <label>M&#227; b&#227;i</label>
                        <input type="text" value="<%= lot.getLotId() %>" readonly style="background:#f1f5f9;">
                    </div>
                    <div class="pm-form-group">
                        <label>T&#234;n b&#227;i</label>
                        <input type="text" name="lotName" value="<%= lot.getLotName() != null ? lot.getLotName() : "" %>" required>
                    </div>
                    <div class="pm-form-group">
                        <label>&#272;&#7883;a ch&#7881;</label>
                        <input type="text" name="address" value="<%= lot.getAddress() != null ? lot.getAddress() : "" %>">
                    </div>
                    <div class="pm-form-group">
                        <label>Ghi ch&#250;</label>
                        <input type="text" name="note" value="<%= lot.getNote() != null ? lot.getNote() : "" %>">
                    </div>
                    <div class="pm-form-group">
                        <label><input type="checkbox" name="status" value="1" <%= lot.isStatus() ? "checked" : "" %>> Ho&#7841;t &#273;&#7897;ng</label>
                    </div>
                    <button type="submit" class="pm-btn pm-btn-primary">C&#7853;p nh&#7853;t</button>
                    <a href="<%= ctx %>/admin/lot" class="pm-btn pm-btn-outline" style="display:inline-block;width:auto;margin-left:12px;">H&#7917;y</a>
                </form>
            </div>
            
        </main>
    </div>
</body>
</html>
