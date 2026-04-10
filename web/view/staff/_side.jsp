<%@page import="model.User"%>
<%@page import="dal.ParkingLotDao"%>
<%
    String assignedLotName = null;
    if (session != null) {
        User staffAcc = (User) session.getAttribute("account");
        if (staffAcc != null && "STAFF".equalsIgnoreCase(staffAcc.getRole()) && staffAcc.getLotId() != null) {
            model.ParkingLot lot = new ParkingLotDao().getById(staffAcc.getLotId());
            if (lot != null) assignedLotName = lot.getLotName();
        }
    }
%>
<div class="pm-dash-sidebar-overlay" id="pm-sidebar-overlay" aria-hidden="true"></div>
<aside class="pm-dash-sidebar" id="pm-dash-sidebar">
    <div class="pm-sb-brand">
        <div class="pm-sb-logo">P</div>
        <div>
            <div class="pm-sb-name">PARKWARE</div>
            <div class="pm-sb-sub">Staff panel</div>
            <% if (assignedLotName != null) { %>
            <div class="pm-sb-lot">B&#227;i: <%= assignedLotName %></div>
            <% } %>
        </div>
    </div>
    <ul class="pm-dash-nav">
        <li><a href="${pageContext.request.contextPath}/staff"><span class="pm-dash-nav-icon">&#9638;</span> Dashboard</a></li>

        <li class="pm-nav-group pm-open" id="pm-group-parking">
            <button type="button" class="pm-nav-group-title" aria-expanded="true">
                <span aria-hidden="true">&#128205;</span>
                Parking
                <span class="pm-caret" aria-hidden="true">&#9662;</span>
            </button>
            <div class="pm-nav-group-items">
                <a data-action="checkin" href="${pageContext.request.contextPath}/staff/ticket?action=checkin"><span class="pm-dash-nav-icon">&#128663;</span> Check-in</a>
                <a data-action="checkout" href="${pageContext.request.contextPath}/staff/ticket?action=checkout"><span class="pm-dash-nav-icon">&#128666;</span> Check-out</a>
                <a data-action="list" href="${pageContext.request.contextPath}/staff/ticket?action=list"><span class="pm-dash-nav-icon">&#128203;</span> Xe &#273;ang g&#7917;i</a>
                <a data-action="history" href="${pageContext.request.contextPath}/staff/ticket?action=history"><span class="pm-dash-nav-icon">&#127915;</span> L&#7883;ch s&#7917; v&#233;</a>
            </div>
        </li>

        <li><a href="${pageContext.request.contextPath}/profile"><span class="pm-dash-nav-icon">&#128100;</span> Th&#244;ng tin c&#225; nh&#226;n</a></li>
        <li><a href="${pageContext.request.contextPath}/logout"><span class="pm-dash-nav-icon">&#128682;</span> Logout</a></li>
    </ul>
</aside>
<script>
(function(){
    var sidebar = document.getElementById('pm-dash-sidebar');
    var overlay = document.getElementById('pm-sidebar-overlay');
    var btn = document.querySelector('.pm-dash-header-menu-btn');
    if (!sidebar) return;
    var ctx = '${pageContext.request.contextPath}';
    function isMobile() { return window.matchMedia && window.matchMedia('(max-width: 768px)').matches; }
    if (btn) btn.addEventListener('click', function(){
        if (isMobile()) {
            document.body.classList.toggle('pm-sidebar-open');
        } else {
            document.body.classList.toggle('pm-sidebar-collapsed');
        }
    });
    if (overlay) overlay.addEventListener('click', function(){ document.body.classList.remove('pm-sidebar-open'); });

    var grp = document.getElementById('pm-group-parking');
    if (grp) {
        var tg = grp.querySelector('.pm-nav-group-title');
        if (tg) tg.addEventListener('click', function(){
            grp.classList.toggle('pm-open');
            var open = grp.classList.contains('pm-open');
            tg.setAttribute('aria-expanded', open ? 'true' : 'false');
        });
    }

    // Active link highlighting
    var links = sidebar.querySelectorAll('a');
    links.forEach(function(a){ a.classList.remove('pm-dash-nav-active'); });
    var path = window.location.pathname;
    var search = window.location.search || '';
    var rel = (ctx && path.indexOf(ctx) === 0) ? path.substring(ctx.length) : path;
    if (rel === '/staff') {
        var dash = sidebar.querySelector('a[href="' + ctx + '/staff"]');
        if (dash) dash.classList.add('pm-dash-nav-active');
        return;
    }
    if (rel === '/staff/ticket') {
        var m = /(?:\\?|&)action=([^&]+)/.exec(search);
        var act = m ? decodeURIComponent(m[1]) : '';
        var a2 = sidebar.querySelector('a[data-action="' + act + '"]');
        if (a2) {
            a2.classList.add('pm-dash-nav-active');
            var g = document.getElementById('pm-group-parking');
            if (g && !g.classList.contains('pm-open')) g.classList.add('pm-open');
        }
        return;
    }
    if (rel === '/profile') {
        var p = sidebar.querySelector('a[href="' + ctx + '/profile"]');
        if (p) p.classList.add('pm-dash-nav-active');
    }
})();
</script>
