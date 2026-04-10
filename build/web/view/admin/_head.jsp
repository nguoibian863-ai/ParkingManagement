<header class="pm-dash-header">
    <div class="pm-dash-header-left">
        <span class="pm-dash-header-icon" aria-hidden="true">&#128663;</span>
        <button type="button" class="pm-dash-header-menu-btn" id="pm-menu-toggle" aria-label="M&#7903; menu">&#9776;</button>
        <div class="pm-hd-breadcrumb" aria-label="Breadcrumb">
            <span class="pm-hd-bc-muted">Dashboard</span>
            <span class="pm-hd-bc-sep">&#8250;</span>
            <span class="pm-hd-bc-strong" id="pm-page-title">Admin</span>
        </div>
    </div>
    <div class="pm-hd-right">
        <div class="pm-hd-search" role="search">
            <span aria-hidden="true" style="color:#94a3b8;">&#128269;</span>
            <input type="search" placeholder="Search" aria-label="Search" id="pm-header-search">
        </div>
        <div class="pm-hd-user-wrap">
            <button type="button" class="pm-hd-pill" id="pm-user-menu-btn" aria-label="User menu" aria-expanded="false" style="cursor:pointer;">
                <span aria-hidden="true">&#128100;</span>
                <span>Menu</span>
            </button>
            <div class="pm-dash-header-dropdown" id="pm-user-dropdown" aria-hidden="true">
                <a href="${pageContext.request.contextPath}/profile">&#128100; Th&#244;ng tin c&#225; nh&#226;n</a>
                <a href="${pageContext.request.contextPath}/admin/user">&#128100; Qu&#7843;n l&#253; t&#224;i kho&#7843;n</a>
                <a href="${pageContext.request.contextPath}/admin/lot">&#128719; Qu&#7843;n l&#253; b&#227;i xe</a>
                <a href="${pageContext.request.contextPath}/admin/slot">&#128193; Qu&#7843;n l&#253; v&#7883; tr&#237; &#273;&#7895;</a>
                <a href="${pageContext.request.contextPath}/admin/pricing">&#128176; Qu&#7843;n l&#253; gi&#225;</a>
                <a href="${pageContext.request.contextPath}/admin/ticket">&#127915; Qu&#7843;n l&#253; v&#233; xe</a>
                <a href="${pageContext.request.contextPath}/admin/report">&#128202; B&#225;o c&#225;o</a>
                <a href="${pageContext.request.contextPath}/logout">&#128682; Logout</a>
            </div>
        </div>
    </div>
</header>
<script>
(function(){
    var userBtn = document.getElementById('pm-user-menu-btn');
    var dropdown = document.getElementById('pm-user-dropdown');
    if (!userBtn || !dropdown) return;
    function closeDropdown() {
        dropdown.classList.remove('pm-dropdown-open');
        dropdown.setAttribute('aria-hidden', 'true');
        userBtn.setAttribute('aria-expanded', 'false');
    }
    function toggleDropdown(e) {
        if (e) e.stopPropagation();
        var open = dropdown.classList.toggle('pm-dropdown-open');
        dropdown.setAttribute('aria-hidden', !open);
        userBtn.setAttribute('aria-expanded', open);
    }
    userBtn.addEventListener('click', toggleDropdown);
    document.addEventListener('click', closeDropdown);
    dropdown.addEventListener('click', function(e){ e.stopPropagation(); });

    var t = document.title || '';
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
