<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.ParkingTicket"%>
<%@page import="dal.UserDao"%>
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
    ParkingTicket ticket = (ParkingTicket) request.getAttribute("ticket");
    UserDao userDao = (UserDao) request.getAttribute("userDao");
    if (ticket == null) {
        response.sendRedirect(request.getContextPath() + "/admin/ticket");
        return;
    }
    String ctx = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi ti&#7871;t v&#233; - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/admin/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/admin/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">Chi ti&#7871;t v&#233; <%= ticket.getTicketId() %></h2>
            <div class="pm-info-grid" style="max-width:560px;">
                <div class="pm-info-row"><span class="pm-info-label">M&#227; v&#233;</span><span class="pm-info-value"><%= ticket.getTicketId() %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">Bi&#7875;n s&#7889;</span><span class="pm-info-value"><%= ticket.getVehiclePlate() %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">B&#227;i / Slot</span><span class="pm-info-value"><%= ticket.getLotId() %> / <%= ticket.getSlotId() != null ? ticket.getSlotId() : "-" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">V&#224;o b&#227;i</span><span class="pm-info-value"><%= ticket.getCheckInTime() != null ? sdf.format(ticket.getCheckInTime()) : "" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">Ra b&#227;i</span><span class="pm-info-value"><%= ticket.getCheckOutTime() != null ? sdf.format(ticket.getCheckOutTime()) : "-" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">Staff v&#224;o</span><span class="pm-info-value"><%= userDao != null && ticket.getStaffCheckInId() != null ? (userDao.getById(ticket.getStaffCheckInId()) != null ? userDao.getById(ticket.getStaffCheckInId()).getFullname() + " (" + ticket.getStaffCheckInId() + ")" : ticket.getStaffCheckInId()) : "" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">Staff ra</span><span class="pm-info-value"><%= ticket.getStaffCheckOutId() != null ? ticket.getStaffCheckOutId() : "-" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">S&#7889; gi&#7901;</span><span class="pm-info-value"><%= ticket.getTotalHours() != null ? ticket.getTotalHours() : "-" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">Qua &#273;&#234;m</span><span class="pm-info-value"><%= ticket.getIsOvernight() != null && ticket.getIsOvernight() ? "C&#243;" : "Kh&#244;ng" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">T&#7893;ng ph&#237; (VN&#272;)</span><span class="pm-info-value"><%= ticket.getTotalFee() != null ? ticket.getTotalFee() : "-" %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">Tr&#7841;ng th&#225;i</span><span class="pm-info-value"><%= ticket.getStatus() %></span></div>
                <div class="pm-info-row"><span class="pm-info-label">Ghi ch&#250;</span><span class="pm-info-value"><%= ticket.getNote() != null ? ticket.getNote() : "" %></span></div>
            </div>
            <p style="margin-top:16px;"><a href="<%= ctx %>/admin/ticket" class="pm-btn pm-btn-outline" style="width:auto;display:inline-block;padding:10px 20px;">&#8592; Danh s&#225;ch v&#233;</a></p>
            
        </main>
    </div>
</body>
</html>
