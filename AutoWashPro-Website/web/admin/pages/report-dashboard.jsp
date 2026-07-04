<% request.setAttribute("pageTitle", "Report Dashboard"); request.setAttribute("activePage", "reports"); %>
<%@ include file="../components/admin-head.jspf" %>
<%@ include file="../components/admin-shell-start.jspf" %>

<!-- UI MOCK ONLY: Replace static reports with request attributes from AdminReportServlet. -->
<div class="lw-card p-6">
    <div class="flex flex-col gap-5 lg:flex-row lg:items-end lg:justify-between">
        <div><p class="lw-label">Analytics</p><h2 class="font-display text-xl font-bold text-white">Combined Admin Reports</h2><p class="mt-1 text-sm text-text-muted">One page contains loyalty, booking revenue, reward redemption, and promotion delivery reports.</p></div>
        <form class="grid gap-3 sm:grid-cols-2 lg:grid-cols-4" action="${pageContext.request.contextPath}/admin/reports" method="get">
            <input class="lw-input" name="dateFrom" type="date" />
            <input class="lw-input" name="dateTo" type="date" />
            <select class="lw-select" name="tierId"><option>All Tiers</option><option>Member</option><option>Silver</option><option>Gold</option><option>Platinum</option></select>
            <button class="lw-btn-primary" type="submit">Apply Filter</button>
        </form>
    </div>
</div>

<div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
    <div class="lw-card p-5"><p class="lw-label">Revenue</p><p class="mt-3 font-display text-3xl font-extrabold text-white">820M</p><p class="mt-1 text-sm text-text-muted">Completed bookings only</p></div>
    <div class="lw-card p-5"><p class="lw-label">Active Points</p><p class="mt-3 font-display text-3xl font-extrabold text-white">142K</p><p class="mt-1 text-sm text-text-muted">Currently usable points</p></div>
    <div class="lw-card p-5"><p class="lw-label">Vouchers Used</p><p class="mt-3 font-display text-3xl font-extrabold text-white">94</p><p class="mt-1 text-sm text-text-muted">Reward redemption flow</p></div>
    <div class="lw-card p-5"><p class="lw-label">Promotions Sent</p><p class="mt-3 font-display text-3xl font-extrabold text-white">1,039</p><p class="mt-1 text-sm text-text-muted">Customer promotion inbox</p></div>
</div>

<div class="grid gap-6">
    <section class="lw-card p-6">
        <div class="mb-5"><p class="lw-label">Report 1</p><h3 class="font-display text-lg font-bold text-white">Customer Loyalty Report</h3></div>
        <div class="overflow-x-auto"><table class="lw-table w-full min-w-[980px] text-left text-sm"><thead><tr><th class="py-3">Customer</th><th>Tier</th><th>Active Points</th><th>Active 12M Spend</th><th>Active 12M Visits</th><th>Lifetime Spend</th><th>Lifetime Visits</th></tr></thead><tbody><tr><td class="py-4 font-bold">Ngô Gia Long</td><td><span class="lw-badge lw-badge-warn">Gold</span></td><td>350</td><td>6,200,000</td><td>16</td><td>9,800,000</td><td>24</td></tr><tr><td class="py-4 font-bold">Nguyễn Nhật Anh</td><td><span class="lw-badge lw-badge-muted">Silver</span></td><td>1,250</td><td>2,400,000</td><td>7</td><td>3,500,000</td><td>10</td></tr></tbody></table></div>
    </section>

    <section class="lw-card p-6">
        <div class="mb-5"><p class="lw-label">Report 2</p><h3 class="font-display text-lg font-bold text-white">Booking & Revenue Report</h3></div>
        <div class="overflow-x-auto"><table class="lw-table w-full min-w-[980px] text-left text-sm"><thead><tr><th class="py-3">Booking</th><th>Customer</th><th>Tier</th><th>Date</th><th>Status</th><th>Original</th><th>Discount</th><th>Final</th></tr></thead><tbody><tr><td class="py-4 font-bold">#BK-1024</td><td>Ngô Gia Long</td><td>Gold</td><td>2026-07-04</td><td><span class="lw-badge lw-badge-active">COMPLETED</span></td><td>400,000</td><td>50,000</td><td>350,000</td></tr><tr><td class="py-4 font-bold">#BK-1022</td><td>Võ Trần Công Danh</td><td>Platinum</td><td>2026-07-03</td><td><span class="lw-badge lw-badge-active">COMPLETED</span></td><td>300,000</td><td>300,000</td><td>0</td></tr></tbody></table></div>
    </section>

    <section class="lw-card p-6">
        <div class="mb-5"><p class="lw-label">Report 3</p><h3 class="font-display text-lg font-bold text-white">Reward Redemption Report</h3></div>
        <div class="overflow-x-auto"><table class="lw-table w-full min-w-[900px] text-left text-sm"><thead><tr><th class="py-3">Redemption</th><th>Customer</th><th>Reward</th><th>Points Used</th><th>Voucher Status</th><th>Redeemed At</th><th>Used Booking</th></tr></thead><tbody><tr><td class="py-4 font-bold">#RD-3001</td><td>Ngô Gia Long</td><td>Free Wax</td><td class="text-gold font-bold">300</td><td><span class="lw-badge lw-badge-active">AVAILABLE</span></td><td>2026-07-04</td><td>-</td></tr><tr><td class="py-4 font-bold">#RD-2999</td><td>Nguyễn An Vương</td><td>Free Wash</td><td class="text-gold font-bold">1000</td><td><span class="lw-badge lw-badge-muted">USED</span></td><td>2026-07-01</td><td>#BK-1022</td></tr></tbody></table></div>
    </section>

    <section class="lw-card p-6">
        <div class="mb-5"><p class="lw-label">Report 4</p><h3 class="font-display text-lg font-bold text-white">Promotion Delivery Report</h3></div>
        <div class="overflow-x-auto"><table class="lw-table w-full min-w-[900px] text-left text-sm"><thead><tr><th class="py-3">Promotion</th><th>Target Type</th><th>Target Tier</th><th>Sent Customers</th><th>Viewed</th><th>Used</th><th>Status</th></tr></thead><tbody><tr><td class="py-4 font-bold">Gold Weekend Care</td><td>TIER</td><td>Gold</td><td>120</td><td>48</td><td>11</td><td><span class="lw-badge lw-badge-active">ACTIVE</span></td></tr><tr><td class="py-4 font-bold">All Member Wash Day</td><td>ALL</td><td>All</td><td>920</td><td>310</td><td>62</td><td><span class="lw-badge lw-badge-warn">DRAFT</span></td></tr></tbody></table></div>
    </section>
</div>

<%@ include file="../components/admin-shell-end.jspf" %>
