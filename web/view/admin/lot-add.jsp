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
    if (nextId == null) nextId = "LOT01";
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Th&#234;m b&#227;i xe - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Th&#234;m b&#227;i xe</h2>
            <% if (error != null) { %><p class="pm-error" style="max-width:400px;"><%= error %></p><% } %>
            <div class="pm-dash-table-wrap" style="max-width:520px;">
                <form action="<%= ctx %>/admin/lot?action=add" method="post" class="pm-form" style="padding:24px;">
                    <div class="pm-form-group">
                        <label>M&#227; b&#227;i</label>
                        <input type="text" name="lotId" value="<%= nextId %>" required readonly style="background:#f1f5f9;">
                    </div>
                    <div class="pm-form-group">
                        <label>T&#234;n b&#227;i</label>
                        <input type="text" name="lotName" required placeholder="T&#234;n b&#227;i xe">
                    </div>
                    <div class="pm-form-group">
                        <label>&#272;&#7883;a ch&#7881;</label>
                        <input type="text" name="address" placeholder="&#272;&#7883;a ch&#7881;">
                    </div>
                    <div class="pm-form-group">
                        <label>Ghi ch&#250;</label>
                        <input type="text" name="note" placeholder="Ghi ch&#250;">
                    </div>
                    <div class="pm-form-group">
                        <label><input type="checkbox" name="status" value="1" checked> Ho&#7841;t &#273;&#7897;ng</label>
                    </div>
                    <button type="submit" class="pm-btn pm-btn-primary">Th&#234;m</button>
                    <a href="<%= ctx %>/admin/lot" class="pm-btn pm-btn-outline" style="display:inline-block;width:auto;margin-left:12px;">H&#7917;y</a>
                </form>
            </div>
            
        </main>
    </div>
</body>
</html>
