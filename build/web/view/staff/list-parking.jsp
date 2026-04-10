<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ParkingTicket"%>
<%@page import="dal.ParkingLotDao"%>
<%@page import="java.text.SimpleDateFormat"%>
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
    List<ParkingTicket> ticketList = (List<ParkingTicket>) request.getAttribute("ticketList");
    if (ticketList == null) ticketList = java.util.Collections.emptyList();
    ParkingLotDao lotDao = (ParkingLotDao) request.getAttribute("lotDao");
    String plate = request.getParameter("plate");
    String ctx = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xe &#273;ang g&#7917;i - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/staff/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/staff/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Danh s&#225;ch xe &#273;ang g&#7917;i</h2>
            <form method="get" action="<%= ctx %>/staff/ticket" style="margin-bottom:16px;display:flex;gap:8px;flex-wrap:wrap;align-items:center;">
                <input type="hidden" name="action" value="list">
                <input type="text" name="plate" placeholder="T&#236;m theo bi&#7875;n s&#7889;" value="<%= plate != null ? plate : "" %>" style="padding:8px 12px;">
                <button type="submit" class="pm-btn pm-btn-primary" style="width:auto;padding:8px 16px;">T&#236;m</button>
            </form>
            <div class="pm-dash-table-wrap">
                <table class="pm-dash-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>M&#227; v&#233;</th>
                            <th>Bi&#7875;n s&#7889;</th>
                            <th>B&#227;i / Slot</th>
                            <th>V&#224;o b&#227;i</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < ticketList.size(); i++) {
                            ParkingTicket t = ticketList.get(i);
                            String lotName = (lotDao != null && t.getLotId() != null) ? (lotDao.getById(t.getLotId()) != null ? lotDao.getById(t.getLotId()).getLotName() : t.getLotId()) : t.getLotId();
                        %>
                        <tr>
                            <td><%= i + 1 %></td>
                            <td><%= t.getTicketId() %></td>
                            <td><%= t.getVehiclePlate() %></td>
                            <td><%= lotName %> / <%= t.getSlotId() != null ? t.getSlotId() : "-" %></td>
                            <td><%= t.getCheckInTime() != null ? sdf.format(t.getCheckInTime()) : "" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% if (ticketList.isEmpty()) { %>
            <p class="pm-muted" style="margin-top:16px;">Ch&#432;a c&#243; xe n&#224;o &#273;ang g&#7917;i.</p>
            <% } %>
        </main>
    </div>
</body>
</html>
