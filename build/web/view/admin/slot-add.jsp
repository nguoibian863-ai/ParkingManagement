<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
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
    String nextId = (String) request.getAttribute("nextId");
    if (nextId == null) nextId = "S001";
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
    <title>Th&#234;m v&#7883; tr&#237; &#273;&#7895; - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Th&#234;m v&#7883; tr&#237; &#273;&#7895; xe</h2>
            <% if (error != null) { %><p class="pm-error" style="max-width:400px;"><%= error %></p><% } %>
            <div class="pm-dash-table-wrap" style="max-width:480px;">
                <form action="<%= ctx %>/admin/slot?action=add" method="post" class="pm-form" style="padding:24px;">
                    <div class="pm-form-group">
                        <label>M&#227; slot</label>
                        <input type="text" name="slotId" value="<%= nextId %>" required readonly style="background:#f1f5f9;">
                    </div>
                    <div class="pm-form-group">
                        <label>B&#227;i xe</label>
                        <select name="lotId" required>
                            <% for (ParkingLot lot : lotList) { %>
                            <option value="<%= lot.getLotId() %>"><%= lot.getLotName() %> (<%= lot.getLotId() %>)</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="pm-form-group">
                        <label>M&#227; &#244; (slotCode)</label>
                        <input type="text" name="slotCode" required placeholder="VD: A1">
                    </div>
                    <div class="pm-form-group">
                        <label>Tr&#7841;ng th&#225;i</label>
                        <select name="status">
                            <option value="EMPTY">Tr&#7889;ng</option>
                            <option value="OCCUPIED">&#272;&#227; c&#243; xe</option>
                            <option value="DISABLED">B&#7843;o tr&#236;</option>
                        </select>
                    </div>
                    <div class="pm-form-group">
                        <label>Ghi ch&#250;</label>
                        <input type="text" name="note" placeholder="Ghi ch&#250;">
                    </div>
                    <button type="submit" class="pm-btn pm-btn-primary">Th&#234;m</button>
                    <a href="<%= ctx %>/admin/slot" class="pm-btn pm-btn-outline" style="display:inline-block;width:auto;margin-left:12px;">H&#7917;y</a>
                </form>
            </div>
           
        </main>
    </div>
</body>
</html>
