<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Pricing"%>
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
    List<Pricing> list = (List<Pricing>) request.getAttribute("pricingList");
    if (list == null) list = java.util.Collections.emptyList();
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Qu&#7843;n l&#253; gi&#225; - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">B&#7843;ng gi&#225; g&#7917;i xe</h2>
            <p><a href="<%= ctx %>/admin/pricing?action=add" class="pm-btn pm-btn-primary" style="width:auto;display:inline-block;padding:10px 20px;">+ Th&#234;m b&#7843;ng gi&#225;</a></p>
            <div class="pm-dash-table-wrap">
                <table class="pm-dash-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>M&#227;</th>
                            <th>Lo&#7841;i xe</th>
                            <th>Gi&#225;/gi&#7901; (VN&#272;)</th>
                            <th>Qua &#273;&#234;m (VN&#272;)</th>
                            <th>&#193;p d&#7909;ng</th>
                            <th>Thao t&#225;c</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < list.size(); i++) {
                            Pricing p = list.get(i);
                        %>
                        <tr>
                            <td><%= i + 1 %></td>
                            <td><%= p.getPricingId() %></td>
                            <td><%= p.getVehicleType() %></td>
                            <td><%= p.getPricePerHour() %></td>
                            <td><%= p.getOvernightFee() %></td>
                            <td><%= p.isActive() ? "C&#243;" : "Kh&#244;ng" %></td>
                            <td>
                                <a href="<%= ctx %>/admin/pricing?action=edit&id=<%= p.getPricingId() %>">S&#7917;a</a>
                                <a href="<%= ctx %>/admin/pricing?action=delete&id=<%= p.getPricingId() %>" onclick="return confirm('X&#243;a b&#7843;ng gi&#225; n&#224;y?');" style="color:var(--pm-danger);">X&#243;a</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
        </main>
    </div>
</body>
</html>
