<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.ParkingTicket"%>
<%@page import="dal.ParkingLotDao"%>
<%@page import="dal.PricingDao"%>
<%@page import="model.ParkingLot"%>
<%@page import="model.Pricing"%>
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
    ParkingTicket ticket = (ParkingTicket) request.getAttribute("ticket");
    ParkingLotDao lotDao = (ParkingLotDao) request.getAttribute("lotDao");
    PricingDao pricingDao = (PricingDao) request.getAttribute("pricingDao");
    if (ticket == null) {
        response.sendRedirect(request.getContextPath() + "/staff/ticket?action=checkout");
        return;
    }
    String ctx = request.getContextPath();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    ParkingLot lot = lotDao != null && ticket.getLotId() != null ? lotDao.getById(ticket.getLotId()) : null;
    Pricing pricing = pricingDao != null && ticket.getPricingId() != null ? pricingDao.getById(ticket.getPricingId()) : null;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>H&#243;a &#273;&#417;n - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/staff/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/staff/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">H&#243;a &#273;&#417;n thanh to&#225;n</h2>
            <div class="pm-invoice-wrap">
                <div class="pm-invoice-title">Car Parking Management System</div>
                <div class="pm-invoice-sub">H&#243;a &#273;&#417;n tr&#7843; xe</div>
                <div class="pm-invoice-body">
                    <div class="pm-invoice-row"><span class="pm-invoice-label">M&#227; v&#233;</span><span class="pm-invoice-value"><%= ticket.getTicketId() %></span></div>
                    <div class="pm-invoice-row"><span class="pm-invoice-label">Bi&#7875;n s&#7889;</span><span class="pm-invoice-value"><%= ticket.getVehiclePlate() %></span></div>
                    <div class="pm-invoice-row"><span class="pm-invoice-label">V&#7883; tr&#237;</span><span class="pm-invoice-value"><%= lot != null ? lot.getLotName() : ticket.getLotId() %> - <%= ticket.getSlotId() %></span></div>
                    <div class="pm-invoice-row"><span class="pm-invoice-label">V&#224;o b&#227;i</span><span class="pm-invoice-value"><%= ticket.getCheckInTime() != null ? sdf.format(ticket.getCheckInTime()) : "" %></span></div>
                    <div class="pm-invoice-row"><span class="pm-invoice-label">Ra b&#227;i</span><span class="pm-invoice-value"><%= ticket.getCheckOutTime() != null ? sdf.format(ticket.getCheckOutTime()) : "" %></span></div>
                    <div class="pm-invoice-row"><span class="pm-invoice-label">S&#7889; gi&#7901;</span><span class="pm-invoice-value"><%= ticket.getTotalHours() != null ? ticket.getTotalHours() : 0 %> gi&#7901;</span></div>
                    <div class="pm-invoice-row pm-invoice-total"><span class="pm-invoice-label">T&#7893;ng ph&#237;</span><span class="pm-invoice-value"><%= ticket.getTotalFee() != null ? ticket.getTotalFee() : 0 %> VN&#272;</span></div>
                </div>
                <div class="pm-invoice-footer">C&#7843;m &#417;n qu&#253; kh&#225;ch!</div>
            </div>
            <p style="margin-top:14px;">
                <button type="button" class="pm-btn pm-btn-outline pm-print-hide" style="width:auto;display:inline-block;padding:10px 20px;" onclick="window.print()">In h&#243;a &#273;&#417;n</button>
            </p>
            <p style="margin-top:20px;">
                <a href="<%= ctx %>/staff/ticket?action=checkout" class="pm-btn pm-btn-primary" style="display:inline-block;padding:10px 20px;">Tr&#7843; xe ti&#7871;p</a>
                <a href="<%= ctx %>/staff/ticket?action=checkin" class="pm-btn pm-btn-outline" style="display:inline-block;padding:10px 20px;margin-left:8px;">T&#7841;o v&#233; m&#7899;i</a>
            </p>
        </main>
    </div>
</body>
</html>
