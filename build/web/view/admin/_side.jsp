<div class="pm-dash-sidebar-overlay" id="pm-sidebar-overlay" aria-hidden="true"></div>
<aside class="pm-dash-sidebar" id="pm-dash-sidebar">
    <div class="pm-sb-brand">
        <div class="pm-sb-logo">P</div>
        <div>
            <div class="pm-sb-name">PARKWARE</div>
            <div class="pm-sb-sub">Admin panel</div>
        </div>
    </div>
    <ul class="pm-dash-nav">
        <li><a href="${pageContext.request.contextPath}/admin"><span class="pm-dash-nav-icon">&#9638;</span> Dashboard</a></li>

        <li class="pm-nav-group pm-open" id="pm-group-parking">
            <button type="button" class="pm-nav-group-title" aria-expanded="true">
                <span aria-hidden="true">&#128205;</span>
                Parking
                <span class="pm-caret" aria-hidden="true">&#9662;</span>
            </button>
            <div class="pm-nav-group-items">
                <a href="${pageContext.request.contextPath}/admin/lot"><span class="pm-dash-nav-icon">&#128719;</span> Parking Areas</a>
                <a href="${pageContext.request.contextPath}/admin/slot"><span class="pm-dash-nav-icon">&#128193;</span> Parking Slots</a>
                <a href="${pageContext.request.contextPath}/admin/ticket"><span class="pm-dash-nav-icon">&#127915;</span> Tickets</a>
            </div>
        </li>

        <li class="pm-nav-group pm-open" id="pm-group-management">
            <button type="button" class="pm-nav-group-title" aria-expanded="true">
                <span aria-hidden="true">&#9881;</span>
                Management
                <span class="pm-caret" aria-hidden="true">&#9662;</span>
            </button>
            <div class="pm-nav-group-items">
                <a href="${pageContext.request.contextPath}/admin/user"><span class="pm-dash-nav-icon">&#128100;</span> Users</a>
                <a href="${pageContext.request.contextPath}/admin/pricing"><span class="pm-dash-nav-icon">&#128176;</span> Pricing</a>
                <a href="${pageContext.request.contextPath}/admin/report"><span class="pm-dash-nav-icon">&#128202;</span> Reports</a>
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
    function closeSidebar() { document.body.classList.remove('pm-sidebar-open'); }
    function isMobile() { return window.matchMedia && window.matchMedia('(max-width: 768px)').matches; }
    if (btn) btn.addEventListener('click', function(){
        if (isMobile()) {
            document.body.classList.toggle('pm-sidebar-open');
        } else {
            document.body.classList.toggle('pm-sidebar-collapsed');
        }
    });
    if (overlay) overlay.addEventListener('click', closeSidebar);

    function bindGroup(id){
        var grp = document.getElementById(id);
        if (!grp) return;
        var tg = grp.querySelector('.pm-nav-group-title');
        if (!tg) return;
        tg.addEventListener('click', function(){
            grp.classList.toggle('pm-open');
            var open = grp.classList.contains('pm-open');
            tg.setAttribute('aria-expanded', open ? 'true' : 'false');
        });
    }
    bindGroup('pm-group-parking');
    bindGroup('pm-group-management');

    // Active link highlighting
    var links = sidebar.querySelectorAll('a');
    links.forEach(function(a){ a.classList.remove('pm-dash-nav-active'); });
    var path = window.location.pathname;
    var rel = (ctx && path.indexOf(ctx) === 0) ? path.substring(ctx.length) : path;
    var active = sidebar.querySelector('a[href="' + ctx + rel + '"]');
    if (active) {
        active.classList.add('pm-dash-nav-active');
        var g1 = document.getElementById('pm-group-parking');
        var g2 = document.getElementById('pm-group-management');
        if (g1 && g1.contains(active)) g1.classList.add('pm-open');
        if (g2 && g2.contains(active)) g2.classList.add('pm-open');
    } else if (rel === '/admin') {
        var dash = sidebar.querySelector('a[href="' + ctx + '/admin"]');
        if (dash) dash.classList.add('pm-dash-nav-active');
    }
})();
</script>
