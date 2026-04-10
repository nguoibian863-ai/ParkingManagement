<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ParkingTicket"%>
<%@page import="model.User"%>
<%@page import="java.text.SimpleDateFormat"%>
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
    List<ParkingTicket> ticketList = (List<ParkingTicket>) request.getAttribute("ticketList");
    if (ticketList == null) ticketList = java.util.Collections.emptyList();
    List<User> staffList = (List<User>) request.getAttribute("staffList");
    if (staffList == null) staffList = java.util.Collections.emptyList();
    String ctx = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Qu&#7843;n l&#253; v&#233; xe - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Danh s&#225;ch v&#233; xe</h2>
            <form method="get" action="<%= ctx %>/admin/ticket" style="margin-bottom:16px;display:flex;gap:8px;flex-wrap:wrap;align-items:center;">
                <input type="text" name="plate" placeholder="Bi&#7875;n s&#7889;" style="padding:8px;">
                <input type="date" name="dateFrom" placeholder="T&#7915; ng&#224;y">
                <input type="date" name="dateTo" placeholder="&#272;&#7871;n ng&#224;y">
                <select name="staffId">
                    <option value="">-- Staff --</option>
                    <% for (User u : staffList) { %>
                    <option value="<%= u.getUserId() %>"><%= u.getFullname() %> (<%= u.getUserId() %>)</option>
                    <% } %>
                </select>
                <button type="submit" class="pm-btn pm-btn-primary" style="width:auto;padding:8px 16px;">T&#236;m</button>
            </form>
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
                            <th>Thao t&#225;c</th>
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
                            <td><a href="<%= ctx %>/admin/ticket?action=detail&id=<%= t.getTicketId() %>">Chi ti&#7871;t</a></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
        </main>
    </div>
</body>
</html>
