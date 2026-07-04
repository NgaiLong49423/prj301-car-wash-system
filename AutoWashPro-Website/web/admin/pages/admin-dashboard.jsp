<% request.setAttribute("pageTitle", "Admin Dashboard"); request.setAttribute("activePage", "dashboard"); %>
<%@ include file="../components/admin-head.jspf" %>
<%@ include file="../components/admin-shell-start.jspf" %>

<!-- UI MOCK ONLY: Replace all hardcoded values below with request attributes from AdminDashboardServlet. -->
<div class="grid gap-4 md:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-6">
    <div class="lw-card p-5"><p class="lw-label">Total Customers</p><div class="mt-3 flex items-end justify-between"><p class="font-display text-3xl font-extrabold text-white">1,248</p><span class="material-symbols-outlined text-gold">groups</span></div></div>
    <div class="lw-card p-5"><p class="lw-label">Completed Bookings</p><div class="mt-3 flex items-end justify-between"><p class="font-display text-3xl font-extrabold text-white">8,420</p><span class="material-symbols-outlined text-success">task_alt</span></div></div>
    <div class="lw-card p-5"><p class="lw-label">Total Revenue</p><div class="mt-3 flex items-end justify-between"><p class="font-display text-3xl font-extrabold text-white">2.45B</p><span class="material-symbols-outlined text-blue">payments</span></div></div>
    <div class="lw-card p-5"><p class="lw-label">Points Issued</p><div class="mt-3 flex items-end justify-between"><p class="font-display text-3xl font-extrabold text-white">428K</p><span class="material-symbols-outlined text-gold">stars</span></div></div>
    <div class="lw-card p-5"><p class="lw-label">Rewards Redeemed</p><div class="mt-3 flex items-end justify-between"><p class="font-display text-3xl font-extrabold text-white">623</p><span class="material-symbols-outlined text-warning">redeem</span></div></div>
    <div class="lw-card p-5"><p class="lw-label">Active Promotions</p><div class="mt-3 flex items-end justify-between"><p class="font-display text-3xl font-extrabold text-white">6</p><span class="material-symbols-outlined text-blue">campaign</span></div></div>
</div>

<div class="grid gap-6 xl:grid-cols-3">
    <div class="lw-card p-6 xl:col-span-2">
        <div class="mb-5 flex items-center justify-between">
            <div><p class="lw-label">Operations</p><h2 class="font-display text-xl font-bold text-white">Recent Completed Bookings</h2></div>
            <a href="${pageContext.request.contextPath}/admin/reports" class="lw-btn-ghost text-sm">View Reports</a>
        </div>
        <div class="overflow-x-auto">
            <table class="lw-table w-full min-w-[720px] text-left text-sm">
                <thead><tr><th class="py-3">Booking</th><th>Customer</th><th>Tier</th><th>Date</th><th>Final Amount</th><th>Status</th></tr></thead>
                <tbody>
                <tr><td class="py-4 font-bold">#BK-1024</td><td>Ngô Gia Long</td><td><span class="lw-badge lw-badge-warn">Gold</span></td><td>2026-07-04</td><td>350,000 VND</td><td><span class="lw-badge lw-badge-active">COMPLETED</span></td></tr>
                <tr><td class="py-4 font-bold">#BK-1023</td><td>Nguyễn Nhật Anh</td><td><span class="lw-badge lw-badge-muted">Silver</span></td><td>2026-07-04</td><td>280,000 VND</td><td><span class="lw-badge lw-badge-active">COMPLETED</span></td></tr>
                <tr><td class="py-4 font-bold">#BK-1022</td><td>Võ Trần Công Danh</td><td><span class="lw-badge lw-badge-warn">Platinum</span></td><td>2026-07-03</td><td>0 VND</td><td><span class="lw-badge lw-badge-active">COMPLETED</span></td></tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="lw-card p-6">
        <p class="lw-label">Quick Actions</p>
        <h2 class="font-display text-xl font-bold text-white">Admin Shortcuts</h2>
        <div class="mt-5 space-y-3">
            <a class="lw-panel flex items-center gap-3 p-4 hover:border-gold/50" href="${pageContext.request.contextPath}/admin/tiers"><span class="material-symbols-outlined text-gold">workspace_premium</span><div><p class="font-bold text-white">Manage Tiers</p><p class="text-sm text-text-muted">Rules, multiplier, booking window</p></div></a>
            <a class="lw-panel flex items-center gap-3 p-4 hover:border-gold/50" href="${pageContext.request.contextPath}/admin/rewards"><span class="material-symbols-outlined text-gold">redeem</span><div><p class="font-bold text-white">Manage Rewards</p><p class="text-sm text-text-muted">Catalog and redemption cost</p></div></a>
            <a class="lw-panel flex items-center gap-3 p-4 hover:border-gold/50" href="${pageContext.request.contextPath}/admin/promotions"><span class="material-symbols-outlined text-gold">campaign</span><div><p class="font-bold text-white">Create Promotion</p><p class="text-sm text-text-muted">Target all or selected tier</p></div></a>
        </div>
    </div>
</div>

<div class="lw-card p-6">
    <div class="mb-5"><p class="lw-label">Loyalty</p><h2 class="font-display text-xl font-bold text-white">Recent Reward Redemptions</h2></div>
    <div class="overflow-x-auto">
        <table class="lw-table w-full min-w-[760px] text-left text-sm">
            <thead><tr><th class="py-3">Redemption</th><th>Customer</th><th>Reward</th><th>Points Used</th><th>Voucher Status</th><th>Redeemed At</th></tr></thead>
            <tbody>
            <tr><td class="py-4 font-bold">#RD-3001</td><td>Ngô Gia Long</td><td>Free Wax</td><td class="text-gold font-bold">300</td><td><span class="lw-badge lw-badge-active">AVAILABLE</span></td><td>2026-07-04</td></tr>
            <tr><td class="py-4 font-bold">#RD-3000</td><td>Nguyễn An Vương</td><td>10% Discount</td><td class="text-gold font-bold">500</td><td><span class="lw-badge lw-badge-muted">USED</span></td><td>2026-07-02</td></tr>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="../components/admin-shell-end.jspf" %>
