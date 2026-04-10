<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ParkingSlot"%>
<%@page import="model.Pricing"%>
<%@page import="dal.ParkingLotDao"%>
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
    List<ParkingSlot> emptySlots = (List<ParkingSlot>) request.getAttribute("emptySlots");
    if (emptySlots == null) emptySlots = java.util.Collections.emptyList();
    List<Pricing> pricingList = (List<Pricing>) request.getAttribute("pricingList");
    if (pricingList == null) pricingList = java.util.Collections.emptyList();
    ParkingLotDao lotDao = (ParkingLotDao) request.getAttribute("lotDao");
    String err = request.getParameter("err");
    String ok = request.getParameter("ok");
    String checkInErrorDetail = (String) session.getAttribute("checkInErrorDetail");
    if (checkInErrorDetail != null) session.removeAttribute("checkInErrorDetail");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>T&#7841;o v&#233; g&#7917;i xe - Staff</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="pm-dashboard-layout">
    <jsp:include page="/view/staff/_head.jsp"/>
    <div class="pm-dash-body">
        <jsp:include page="/view/staff/_side.jsp"/>
        <main class="pm-dash-main">
            <h2 class="pm-dash-content-title">T&#7841;o v&#233; g&#7917;i xe (Check-in)</h2>
            <% if ("1".equals(ok)) { %>
            <p class="pm-success" style="margin-bottom:16px;">&#272;&#227; t&#7841;o v&#233; th&#224;nh c&#244;ng.</p>
            <% } %>
            <% if ("missing".equals(err)) { %><p class="pm-error">Vui l&#242;ng nh&#7853;p &#273;&#7847;y &#273;&#7911; th&#244;ng tin.</p><% } %>
            <% if ("plate".equals(err)) { %><p class="pm-error">Xe n&#224;y &#273;ang &#273;&#432;&#7907;c g&#7917;i trong b&#227;i (tr&#249;ng bi&#7875;n s&#7889;).</p><% } %>
            <% if ("slot".equals(err)) { %><p class="pm-error">V&#7883; tr&#237; &#273;&#7895; kh&#244;ng h&#7907;p l&#7879; ho&#7863;c &#273;&#227; c&#243; xe.</p><% } %>
            <% if ("pricing".equals(err)) { %><p class="pm-error">Lo&#7841;i xe kh&#244;ng c&#243; trong b&#7843;ng gi&#225;.</p><% } %>
            <% if ("db".equals(err)) { %>
            <p class="pm-error">L&#7895;i h&#7879; th&#7889;ng khi l&#432u v&#233;. Vui l&#242;ng th&#7917; l&#7841;i.</p>
            <% if (checkInErrorDetail != null && !checkInErrorDetail.isEmpty()) { %>
            <p class="pm-error" style="font-size:0.9rem;word-break:break-all;margin-top:8px;">Chi ti&#7871;t: <%= checkInErrorDetail %></p>
            <% } %>
            <% } %>
            <% if (pricingList.isEmpty()) { %>
            <p class="pm-error">Ch&#432;a c&#243; b&#7843;ng gi&#225; (lo&#7841;i xe). Admin c&#7847;n th&#234;m m&#7909;c trong <b>Qu&#7843;n l&#253; gi&#225;</b>.</p>
            <% } %>
            <div class="pm-dash-table-wrap" style="max-width:520px;">
                <form action="<%= ctx %>/staff/ticket?action=checkin" method="post" class="pm-form" style="padding:24px;">
                    <div class="pm-form-group">
                        <label>Bi&#7875;n s&#7889; xe</label>
                        <input type="text" name="vehiclePlate" placeholder="VD: 30A-12345" required value="<%= request.getParameter("vehiclePlate") != null ? request.getParameter("vehiclePlate") : "" %>">
                    </div>
                    <div class="pm-form-group">
                        <label>Lo&#7841;i xe</label>
                        <select name="vehicleType" required>
                            <option value="">-- Ch&#7885;n lo&#7841;i xe --</option>
                            <% for (Pricing p : pricingList) { %>
                            <option value="<%= p.getVehicleType() %>"><%= p.getVehicleType() %></option>
                            <% } %>
                        </select>
                        <% if (pricingList.isEmpty()) { %><span style="color:var(--pm-text-muted);font-size:0.85rem;">Kh&#244;ng c&#243; l&#7921;a ch&#7885;n. Li&#234;n h&#7879; Admin.</span><% } %>
                    </div>
                    <div class="pm-form-group">
                        <label>V&#7883; tr&#237; &#273;&#7895;</label>
                        <select name="slotId" required>
                            <option value="">-- Ch&#7885;n v&#7883; tr&#237; tr&#7889;ng --</option>
                            <% for (ParkingSlot s : emptySlots) {
                                String lotName = (lotDao != null && s.getLotId() != null) ? (lotDao.getById(s.getLotId()) != null ? lotDao.getById(s.getLotId()).getLotName() : s.getLotId()) : s.getLotId();
                            %>
                            <option value="<%= s.getSlotId() %>"><%= lotName %> - <%= s.getSlotCode() %></option>
                            <% } %>
                        </select>
                    </div>
                    <button type="submit" class="pm-btn pm-btn-primary" style="width:100%;">T&#7841;o v&#233;</button>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
