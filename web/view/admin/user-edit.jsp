<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.User"%>
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
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/admin/user");
        return;
    }
    List<ParkingLot> lotList = (List<ParkingLot>) request.getAttribute("lotList");
    if (lotList == null) lotList = java.util.Collections.emptyList();
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S&#7917;a t&#224;i kho&#7843;n - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">S&#7917;a t&#224;i kho&#7843;n</h2>
            <% if (error != null) { %><p class="pm-error" style="max-width:400px;"><%= error %></p><% } %>
            <div class="pm-dash-table-wrap" style="max-width:480px;">
                <form action="<%= ctx %>/admin/user?action=edit" method="post" class="pm-form" style="padding:24px;">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                    <div class="pm-form-group">
                        <label>User ID</label>
                        <input type="text" value="<%= user.getUserId() %>" readonly style="background:#f1f5f9;">
                    </div>
                    <div class="pm-form-group">
                        <label>Username</label>
                        <input type="text" name="username" value="<%= user.getUsername() != null ? user.getUsername() : "" %>" required>
                    </div>
                    <div class="pm-form-group">
                        <label>H&#7885; t&#234;n</label>
                        <input type="text" name="fullName" value="<%= user.getFullname() != null ? user.getFullname() : "" %>">
                    </div>
                    <div class="pm-form-group">
                        <label>Vai tr&#242;</label>
                        <select name="role">
                            <option value="STAFF" <%= "STAFF".equals(user.getRole()) ? "selected" : "" %>>Staff</option>
                            <option value="ADMIN" <%= "ADMIN".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                        </select>
                    </div>
                    <div class="pm-form-group">
                        <label>B&#227;i l&#224;m vi&#7879;c</label>
                        <select name="lotId">
                            <option value="">— Kh&#244;ng ch&#7885;n —</option>
                            <% for (ParkingLot lot : lotList) { %>
                            <option value="<%= lot.getLotId() %>" <%= (user.getLotId() != null && user.getLotId().equals(lot.getLotId())) ? "selected" : "" %>><%= lot.getLotName() %> (<%= lot.getLotId() %>)</option>
                            <% } %>
                        </select>
                        <small style="color:var(--pm-text-muted);">Ch&#7885;n b&#227;i cho nh&#226;n vi&#234;n (Staff).</small>
                    </div>
                    <div class="pm-form-group">
                        <label><input type="checkbox" name="status" value="1" <%= user.isStatus() ? "checked" : "" %>> Ho&#7841;t &#273;&#7897;ng</label>
                    </div>
                    <button type="submit" class="pm-btn pm-btn-primary">C&#7853;p nh&#7853;t</button>
                    <a href="<%= ctx %>/admin/user" class="pm-btn pm-btn-outline" style="display:inline-block;width:auto;margin-left:12px;">H&#7917;y</a>
                </form>
            </div>
            
        </main>
    </div>
</body>
</html>
