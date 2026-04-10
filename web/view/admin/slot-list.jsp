<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ParkingSlot"%>
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
    List<ParkingSlot> slotList = (List<ParkingSlot>) request.getAttribute("slotList");
    if (slotList == null) slotList = java.util.Collections.emptyList();
    ParkingLotDao lotDao = (ParkingLotDao) request.getAttribute("lotDao");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Qu&#7843;n l&#253; v&#7883; tr&#237; &#273;&#7895; - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Danh s&#225;ch v&#7883; tr&#237; &#273;&#7895; xe</h2>
            <p><a href="<%= ctx %>/admin/slot?action=add" class="pm-btn pm-btn-primary" style="width:auto;display:inline-block;padding:10px 20px;">+ Th&#234;m v&#7883; tr&#237;</a></p>
            <div class="pm-dash-table-wrap">
                <table class="pm-dash-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>M&#227; slot</th>
                            <th>B&#227;i xe</th>
                            <th>M&#227; &#244;</th>
                            <th>Tr&#7841;ng th&#225;i</th>
                            <th>Thao t&#225;c</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < slotList.size(); i++) {
                            ParkingSlot s = slotList.get(i);
                            String lotName = (lotDao != null && s.getLotId() != null) ? (lotDao.getById(s.getLotId()) != null ? lotDao.getById(s.getLotId()).getLotName() : s.getLotId()) : s.getLotId();
                        %>
                        <tr>
                            <td><%= i + 1 %></td>
                            <td><%= s.getSlotId() %></td>
                            <td><%= lotName %></td>
                            <td><%= s.getSlotCode() %></td>
                            <td><%= "EMPTY".equals(s.getStatus()) ? "Tr&#7889;ng" : "OCCUPIED".equals(s.getStatus()) ? "&#272;&#227; c&#243; xe" : "DISABLED".equals(s.getStatus()) ? "B&#7843;o tr&#236;" : s.getStatus() %></td>
                            <td>
                                <a href="<%= ctx %>/admin/slot?action=edit&id=<%= s.getSlotId() %>">S&#7917;a</a>
                                <a href="<%= ctx %>/admin/slot?action=delete&id=<%= s.getSlotId() %>" onclick="return confirm('X&#243;a v&#7883; tr&#237; n&#224;y?');" style="color:var(--pm-danger);">X&#243;a</a>
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
