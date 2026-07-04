<% request.setAttribute("pageTitle", "Promotion Management"); request.setAttribute("activePage", "promotions"); %>
<%@ include file="../components/admin-head.jspf" %>
<%@ include file="../components/admin-shell-start.jspf" %>

<!-- UI MOCK ONLY: Replace static promotion rows with ${promotions}; tier options with ${tiers}. -->
<div class="grid gap-6 xl:grid-cols-[1.55fr_.95fr]">
    <div class="lw-card p-6">
        <div class="mb-5 flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
            <div><p class="lw-label">Campaigns</p><h2 class="font-display text-xl font-bold text-white">Targeted Promotions</h2><p class="mt-1 text-sm text-text-muted">Admin creates promotions and sends them to selected customers.</p></div>
            <button class="lw-btn-gold" type="button"><span class="material-symbols-outlined">campaign</span> New Promotion</button>
        </div>
        <div class="overflow-x-auto">
            <table class="lw-table w-full min-w-[1000px] text-left text-sm">
                <thead><tr><th class="py-3">Title</th><th>Type</th><th>Value</th><th>Target</th><th>Tier</th><th>Start</th><th>End</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                <tr><td class="py-4 font-bold text-white">Gold Weekend Care</td><td>PERCENT_DISCOUNT</td><td>20%</td><td>TIER</td><td><span class="lw-badge lw-badge-warn">Gold</span></td><td>2026-07-01</td><td>2026-07-15</td><td><span class="lw-badge lw-badge-active">ACTIVE</span></td><td class="space-x-3"><button class="text-blue font-bold">Edit</button><button class="text-gold font-bold">Send</button></td></tr>
                <tr><td class="py-4 font-bold text-white">All Member Wash Day</td><td>FIXED_DISCOUNT</td><td>50,000</td><td>ALL</td><td>All</td><td>2026-07-05</td><td>2026-07-20</td><td><span class="lw-badge lw-badge-warn">DRAFT</span></td><td class="space-x-3"><button class="text-blue font-bold">Edit</button><button class="text-gold font-bold">Send</button></td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="lw-card p-6">
        <p class="lw-label">Add / Edit</p>
        <h2 class="font-display text-xl font-bold text-white">Promotion Form</h2>
        <form class="mt-5 space-y-4" action="${pageContext.request.contextPath}/admin/promotions/save" method="post">
            <input type="hidden" name="promotionId" value="" />
            <div><label class="lw-label">Title</label><input class="lw-input mt-2" name="title" placeholder="Gold Weekend Care" /></div>
            <div><label class="lw-label">Description</label><textarea class="lw-textarea mt-2" name="description" rows="3" placeholder="Special promotion for targeted members"></textarea></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Type</label><select class="lw-select mt-2" name="promotionType"><option>FIXED_DISCOUNT</option><option>PERCENT_DISCOUNT</option><option>FREE_SERVICE</option></select></div><div><label class="lw-label">Value</label><input class="lw-input mt-2" name="promotionValue" placeholder="20" /></div></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Target Type</label><select class="lw-select mt-2" name="targetType"><option>ALL</option><option>TIER</option></select></div><div><label class="lw-label">Target Tier</label><select class="lw-select mt-2" name="targetTierId"><option value="">All</option><option>Member</option><option>Silver</option><option>Gold</option><option>Platinum</option></select></div></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Start Date</label><input class="lw-input mt-2" name="startDate" type="date" /></div><div><label class="lw-label">End Date</label><input class="lw-input mt-2" name="endDate" type="date" /></div></div>
            <div><label class="lw-label">Status</label><select class="lw-select mt-2" name="status"><option>DRAFT</option><option>ACTIVE</option><option>INACTIVE</option><option>EXPIRED</option></select></div>
            <div class="flex gap-3"><button class="lw-btn-primary flex-1" type="submit">Save Promotion</button><button class="lw-btn-ghost" type="reset">Clear</button></div>
        </form>
        <form class="mt-3" action="${pageContext.request.contextPath}/admin/promotions/send" method="post"><button class="lw-btn-gold w-full" type="submit"><span class="material-symbols-outlined">send</span> Send Selected Promotion</button></form>
    </div>
</div>

<%@ include file="../components/admin-shell-end.jspf" %>
