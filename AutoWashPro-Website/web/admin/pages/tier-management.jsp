<% request.setAttribute("pageTitle", "Tier Management"); request.setAttribute("activePage", "tiers"); %>
<%@ include file="../components/admin-head.jspf" %>
<%@ include file="../components/admin-shell-start.jspf" %>

<!-- UI MOCK ONLY: Replace static tier rows with ${tiers} from AdminTierServlet. -->
<div class="grid gap-6 xl:grid-cols-[1.6fr_.9fr]">
    <div class="lw-card p-6">
        <div class="mb-5 flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
            <div><p class="lw-label">Membership</p><h2 class="font-display text-xl font-bold text-white">Tier Rules</h2><p class="mt-1 text-sm text-text-muted">All business rules must come from database, not JSP hardcode.</p></div>
            <button class="lw-btn-gold" type="button"><span class="material-symbols-outlined">add</span> New Tier</button>
        </div>
        <div class="overflow-x-auto">
            <table class="lw-table w-full min-w-[980px] text-left text-sm">
                <thead><tr><th class="py-3">Tier</th><th>Min Spend</th><th>Min Visits</th><th>Multiplier</th><th>Booking Window</th><th>Priority</th><th>Benefits</th><th>Status</th><th>Action</th></tr></thead>
                <tbody>
                <tr><td class="py-4 font-bold text-white">Member</td><td>0</td><td>1</td><td>1.00x</td><td>7 days</td><td>10</td><td>Base point earning</td><td><span class="lw-badge lw-badge-active">ACTIVE</span></td><td><button class="text-blue font-bold">Edit</button></td></tr>
                <tr><td class="py-4 font-bold text-white">Silver</td><td>2,000,000</td><td>5</td><td>1.10x</td><td>10 days</td><td>20</td><td>Priority slot</td><td><span class="lw-badge lw-badge-active">ACTIVE</span></td><td><button class="text-blue font-bold">Edit</button></td></tr>
                <tr><td class="py-4 font-bold text-gold">Gold</td><td>6,000,000</td><td>15</td><td>1.20x</td><td>12 days</td><td>30</td><td>Free upgrade monthly</td><td><span class="lw-badge lw-badge-active">ACTIVE</span></td><td><button class="text-blue font-bold">Edit</button></td></tr>
                <tr><td class="py-4 font-bold text-gold-soft">Platinum</td><td>15,000,000</td><td>30</td><td>1.30x</td><td>14 days</td><td>40</td><td>Free wash monthly</td><td><span class="lw-badge lw-badge-active">ACTIVE</span></td><td><button class="text-blue font-bold">Edit</button></td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="lw-card p-6">
        <p class="lw-label">Add / Edit</p>
        <h2 class="font-display text-xl font-bold text-white">Tier Form</h2>
        <form class="mt-5 space-y-4" action="${pageContext.request.contextPath}/admin/tiers/save" method="post">
            <input type="hidden" name="tierId" value="" />
            <div><label class="lw-label">Tier Name</label><input class="lw-input mt-2" name="tierName" placeholder="Gold" /></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Min Spend</label><input class="lw-input mt-2" name="minSpentMoney" type="number" placeholder="6000000" /></div><div><label class="lw-label">Min Visits</label><input class="lw-input mt-2" name="minVisitCount" type="number" placeholder="15" /></div></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Multiplier</label><input class="lw-input mt-2" name="pointMultiplier" placeholder="1.20" /></div><div><label class="lw-label">Booking Days</label><input class="lw-input mt-2" name="bookingWindowDays" type="number" placeholder="12" /></div></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Priority Score</label><input class="lw-input mt-2" name="priorityScore" type="number" placeholder="30" /></div><div><label class="lw-label">Status</label><select class="lw-select mt-2" name="status"><option>ACTIVE</option><option>INACTIVE</option></select></div></div>
            <div><label class="lw-label">Benefits</label><textarea class="lw-textarea mt-2" name="benefits" rows="3" placeholder="Free upgrade monthly"></textarea></div>
            <div class="flex gap-3"><button class="lw-btn-primary flex-1" type="submit">Save Tier</button><button class="lw-btn-ghost" type="reset">Clear</button></div>
        </form>
    </div>
</div>

<%@ include file="../components/admin-shell-end.jspf" %>
