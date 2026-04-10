<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    String err = request.getParameter("err");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tr&#7843; xe - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/staff/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/staff/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Tr&#7843; xe (Check-out)</h2>
            <% if ("missing".equals(err)) { %><p class="pm-error">Vui l&#242;ng nh&#7853;p bi&#7875;n s&#7889; xe.</p><% } %>
            <% if ("notfound".equals(err)) { %><p class="pm-error">Kh&#244;ng t&#236;m th&#7845;y v&#233; g&#7917;i xe v&#7899;i bi&#7875;n s&#7889; n&#224;y.</p><% } %>
            <% if ("pricing".equals(err)) { %><p class="pm-error">L&#7895;i b&#7843;ng gi&#225;. Li&#234;n h&#7879; admin.</p><% } %>
            <% if ("db".equals(err)) { %><p class="pm-error">L&#7895;i h&#7879; th&#7889;ng. Th&#7917; l&#7841;i sau.</p><% } %>
            <div class="pm-dash-table-wrap" style="max-width:420px;">
                <form action="<%= ctx %>/staff/ticket?action=checkout" method="post" class="pm-form" style="padding:24px;">
                    <div class="pm-form-group">
                        <label>Bi&#7875;n s&#7889; xe</label>
                        <input type="text" name="vehiclePlate" placeholder="VD: 30A-12345" required>
                    </div>
                    <button type="submit" class="pm-btn pm-btn-primary" style="width:100%;">T&#236;m v&#233; v&#224; t&#237;nh ti&#7873;n</button>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
