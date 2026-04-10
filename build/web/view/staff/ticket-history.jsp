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
    String ctx = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>L&#7883;ch s&#7917; v&#233; - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/staff/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/staff/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">L&#7883;ch s&#7917; v&#233; do m&#236;nh t&#7841;o</h2>
            <div class="pm-dash-table-wrap">
                <table class="pm-dash-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>M&#227; v&#233;</th>
                            <th>Bi&#7875;n s&#7889;</th>
                            <th>V&#224;o b&#227;i</th>
                            <th>Ra b&#227;i</th>
                            <th>Ph&#237; (VN&#272;)</th>
                            <th>Tr&#7841;ng th&#225;i</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < ticketList.size(); i++) {
                            ParkingTicket t = ticketList.get(i);
                        %>
                        <tr>
                            <td><%= i + 1 %></td>
                            <td><%= t.getTicketId() %></td>
                            <td><%= t.getVehiclePlate() %></td>
                            <td><%= t.getCheckInTime() != null ? sdf.format(t.getCheckInTime()) : "" %></td>
                            <td><%= t.getCheckOutTime() != null ? sdf.format(t.getCheckOutTime()) : "-" %></td>
                            <td><%= t.getTotalFee() != null ? t.getTotalFee() : "-" %></td>
                            <td><%= "PARKING".equals(t.getStatus()) ? "&#272;ang g&#7917;i" : "FINISHED".equals(t.getStatus()) ? "&#272;&#227; k&#7871;t th&#250;c" : "CANCELLED".equals(t.getStatus()) ? "&#272;&#227; h&#7917;y" : t.getStatus() %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% if (ticketList.isEmpty()) { %>
            <p class="pm-muted" style="margin-top:16px;">Ch&#432;a c&#243; v&#233; n&#224;o.</p>
            <% } %>
        </main>
    </div>
</body>
</html>
