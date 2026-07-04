<% request.setAttribute("pageTitle", "Reward Management"); request.setAttribute("activePage", "rewards"); %>
<%@ include file="../components/admin-head.jspf" %>
<%@ include file="../components/admin-shell-start.jspf" %>

<!-- UI MOCK ONLY: Replace static reward rows with ${rewards}; target service options with ${services}. -->
<div class="grid gap-6 xl:grid-cols-[1.55fr_.95fr]">
    <div class="lw-card p-6">
        <div class="mb-5 flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
            <div><p class="lw-label">Rewards Catalog</p><h2 class="font-display text-xl font-bold text-white">Database-Driven Rewards</h2><p class="mt-1 text-sm text-text-muted">Reward cost, type, value, and validity are admin-configured.</p></div>
            <button class="lw-btn-gold" type="button"><span class="material-symbols-outlined">add</span> New Reward</button>
        </div>
        <div class="overflow-x-auto">
            <table class="lw-table w-full min-w-[960px] text-left text-sm">
                <thead><tr><th class="py-3">Reward</th><th>Required Points</th><th>Type</th><th>Value</th><th>Target Service</th><th>Valid Days</th><th>Status</th><th>Action</th></tr></thead>
                <tbody>
                <tr><td class="py-4 font-bold text-white">Free Wax</td><td class="text-gold font-bold">300</td><td>FREE_SERVICE</td><td>1 service</td><td>Wax</td><td>30</td><td><span class="lw-badge lw-badge-active">ACTIVE</span></td><td><button class="text-blue font-bold">Edit</button></td></tr>
                <tr><td class="py-4 font-bold text-white">10% Discount</td><td class="text-gold font-bold">500</td><td>PERCENT_DISCOUNT</td><td>10%</td><td>All</td><td>30</td><td><span class="lw-badge lw-badge-active">ACTIVE</span></td><td><button class="text-blue font-bold">Edit</button></td></tr>
                <tr><td class="py-4 font-bold text-white">Free Basic Wash</td><td class="text-gold font-bold">1000</td><td>FREE_WASH</td><td>100%</td><td>Basic Wash</td><td>45</td><td><span class="lw-badge lw-badge-active">ACTIVE</span></td><td><button class="text-blue font-bold">Edit</button></td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="lw-card p-6">
        <p class="lw-label">Add / Edit</p>
        <h2 class="font-display text-xl font-bold text-white">Reward Form</h2>
        <form class="mt-5 space-y-4" action="${pageContext.request.contextPath}/admin/rewards/save" method="post">
            <input type="hidden" name="rewardId" value="" />
            <div><label class="lw-label">Reward Name</label><input class="lw-input mt-2" name="rewardName" placeholder="Free Wax" /></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Required Points</label><input class="lw-input mt-2" name="requiredPoints" type="number" placeholder="300" /></div><div><label class="lw-label">Valid Days</label><input class="lw-input mt-2" name="validDays" type="number" placeholder="30" /></div></div>
            <div><label class="lw-label">Reward Type</label><select class="lw-select mt-2" name="rewardType"><option>FIXED_DISCOUNT</option><option>PERCENT_DISCOUNT</option><option>FREE_SERVICE</option><option>FREE_WASH</option></select></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Reward Value</label><input class="lw-input mt-2" name="rewardValue" placeholder="10" /></div><div><label class="lw-label">Target Service</label><select class="lw-select mt-2" name="targetServiceId"><option value="">All / None</option><option>Wax</option><option>Basic Wash</option></select></div></div>
            <div><label class="lw-label">Status</label><select class="lw-select mt-2" name="isActive"><option value="true">ACTIVE</option><option value="false">INACTIVE</option></select></div>
            <div class="flex gap-3"><button class="lw-btn-primary flex-1" type="submit">Save Reward</button><button class="lw-btn-ghost" type="reset">Clear</button></div>
        </form>
    </div>
</div>

<%@ include file="../components/admin-shell-end.jspf" %>
