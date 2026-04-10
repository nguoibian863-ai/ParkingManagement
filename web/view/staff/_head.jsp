<%@page import="model.User"%>
<%@page import="dal.ParkingLotDao"%>
<%
    String staffLotName = null;
    if (session != null) {
        User acc = (User) session.getAttribute("account");
        if (acc != null && "STAFF".equalsIgnoreCase(acc.getRole()) && acc.getLotId() != null) {
            model.ParkingLot lot = new ParkingLotDao().getById(acc.getLotId());
            if (lot != null) staffLotName = lot.getLotName();
        }
    }
%>
<header class="pm-dash-header">
    <div class="pm-dash-header-left">
        <span class="pm-dash-header-icon" aria-hidden="true">&#128663;</span>
        <button type="button" class="pm-dash-header-menu-btn" id="pm-menu-toggle" aria-label="M&#7903; menu">&#9776;</button>
        <div class="pm-hd-breadcrumb" aria-label="Breadcrumb">
            <span class="pm-hd-bc-muted">Dashboard</span>
            <span class="pm-hd-bc-sep">&#8250;</span>
            <span class="pm-hd-bc-strong" id="pm-page-title">Staff</span>
        </div>
        <% if (staffLotName != null) { %>
        <span class="pm-hd-staff-lot" title="B&#227;i &#273;ang l&#224;m vi&#7879;c">&#128205; <%= staffLotName %></span>
        <% } %>
    </div>
    <div class="pm-hd-right">
        <div class="pm-hd-search" role="search">
            <span aria-hidden="true" style="color:#94a3b8;">&#128269;</span>
            <input type="search" placeholder="Search" aria-label="Search" id="pm-header-search">
        </div>
        <a class="pm-hd-pill" href="${pageContext.request.contextPath}/profile" aria-label="Profile">
            <span aria-hidden="true">&#128100;</span>
            <span>Profile</span>
        </a>
    </div>
</header>

<script>
(function(){
    var t = document.title || '';
    // Strip suffix like " - Staff" or " - Admin"
    var clean = t.split(' - ')[0];
    var el = document.getElementById('pm-page-title');
    if (el && clean) el.textContent = clean;

    // Header quick filter for current page table
    var search = document.getElementById('pm-header-search');
    var timer = null;
    function runFilter() {
        var q = (search && search.value ? search.value : '').trim().toLowerCase();
        var table = document.querySelector('.pm-dash-main .pm-dash-table');
        if (table) {
            var rows = table.querySelectorAll('tbody tr');
            rows.forEach(function(tr){
                var txt = (tr.textContent || '').toLowerCase();
                tr.style.display = (!q || txt.indexOf(q) !== -1) ? '' : 'none';
            });
            return;
        }
        // Fallback: slot map
        var cells = document.querySelectorAll('.pm-slot-map .pm-slot-cell');
        if (cells && cells.length) {
            cells.forEach(function(cell){
                var txt = (cell.textContent || '').toLowerCase();
                cell.style.display = (!q || txt.indexOf(q) !== -1) ? '' : 'none';
            });
        }
    }
    if (search) {
        search.addEventListener('input', function(){
            if (timer) window.clearTimeout(timer);
            timer = window.setTimeout(runFilter, 120);
        });
        search.addEventListener('keydown', function(e){
            if (e.key === 'Escape') { search.value = ''; runFilter(); }
        });
    }
})();
</script>
