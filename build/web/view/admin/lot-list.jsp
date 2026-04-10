<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ParkingLot"%>
<%@page import="dal.ParkingLotDao"%>
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
    List<ParkingLot> lotList = (List<ParkingLot>) request.getAttribute("lotList");
    if (lotList == null) lotList = java.util.Collections.emptyList();
    ParkingLotDao lotDao = (ParkingLotDao) request.getAttribute("lotDao");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Qu&#7843;n l&#253; b&#227;i xe - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Danh s&#225;ch b&#227;i xe</h2>
            <p><a href="<%= ctx %>/admin/lot?action=add" class="pm-btn pm-btn-primary" style="width:auto;display:inline-block;padding:10px 20px;">+ Th&#234;m b&#227;i xe</a></p>
            <div class="pm-dash-table-wrap">
                <table class="pm-dash-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>M&#227; b&#227;i</th>
                            <th>T&#234;n b&#227;i</th>
                            <th>&#272;&#7883;a ch&#7881;</th>
                            <th>S&#7889; slot</th>
                            <th>Tr&#7841;ng th&#225;i</th>
                            <th>Thao t&#225;c</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < lotList.size(); i++) {
                            ParkingLot p = lotList.get(i);
                            int count = lotDao != null ? lotDao.countSlotsByLotId(p.getLotId()) : 0;
                        %>
                        <tr>
                            <td><%= i + 1 %></td>
                            <td><%= p.getLotId() %></td>
                            <td><%= p.getLotName() %></td>
                            <td><%= p.getAddress() != null ? p.getAddress() : "" %></td>
                            <td><%= count %></td>
                            <td><%= p.isStatus() ? "Ho&#7841;t &#273;&#7897;ng" : "T&#7855;t" %></td>
                            <td>
                                <a href="<%= ctx %>/admin/lot?action=edit&id=<%= p.getLotId() %>">S&#7917;a</a>
                                <a href="<%= ctx %>/admin/lot?action=delete&id=<%= p.getLotId() %>" onclick="return confirm('X&#243;a b&#227;i xe n&#224;y?');" style="color:var(--pm-danger);">X&#243;a</a>
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
