<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ParkingSlot"%>
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
        <title>Admin - Car Parking Management System</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body class="pm-dashboard-layout">
        <jsp:include page="/view/admin/_head.jsp"/>

        <div class="pm-dash-body">
            <jsp:include page="/view/admin/_side.jsp"/>

            <main class="pm-dash-main">
                <p class="pm-dash-welcome">Xin ch&#224;o, <strong><%= acc.getFullname() != null && !acc.getFullname().isEmpty() ? acc.getFullname() : acc.getUsername() %></strong>!</p>
                <h2 class="pm-dash-content-title">B&#7843;n &#273;&#7891; v&#7883; tr&#237; &#273;&#7895; xe</h2>
                <div class="pm-slot-map-wrap">
                    <div class="pm-slot-map">
                        <% for (ParkingSlot s : slotList) {
                            String status = s.getStatus() != null ? s.getStatus() : "EMPTY";
                            String statusClass = "EMPTY".equals(status) ? "pm-slot-free" : "OCCUPIED".equals(status) ? "pm-slot-occupied" : "pm-slot-disabled";
                            String statusLabel = "EMPTY".equals(status) ? "Tr&#7889;ng" : "OCCUPIED".equals(status) ? "&#272;&#227; c&#243; xe" : "B&#7843;o tr&#236;";
                        %>
                        <div class="pm-slot-cell <%= statusClass %>" title="<%= s.getSlotCode() %> - <%= statusLabel %>">
                            <span class="pm-slot-code"><%= s.getSlotCode() %></span>
                            <span class="pm-slot-status"><%= statusLabel %></span>
                        </div>
                        <% } %>
                        <% if (slotList.isEmpty()) { %>
                        <p class="pm-slot-map-empty">Ch&#432;a c&#243; v&#7883; tr&#237; &#273;&#7895; xe n&#224;o. <a href="<%= ctx %>/admin/slot?action=add">Th&#234;m v&#7883; tr&#237;</a></p>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>
