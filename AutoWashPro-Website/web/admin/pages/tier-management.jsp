<% request.setAttribute("pageTitle", "Tier Management"); request.setAttribute("activePage", "tiers"); %>
<%@ include file="../components/admin-head.jspf" %>
<%@ include file="../components/admin-shell-start.jspf" %>

<%@ page import="java.util.*" %>
<div class="grid gap-6 xl:grid-cols-[1.6fr_.9fr]">
    <div class="lw-card p-6">
        <div class="mb-5 flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
            <div><p class="lw-label">Membership</p><h2 class="font-display text-xl font-bold text-white">Tier Rules</h2><p class="mt-1 text-sm text-text-muted">All business rules must come from database, not JSP hardcode.</p></div>
            <button class="lw-btn-gold" type="button"><span class="material-symbols-outlined">add</span> New Tier</button>
        </div>
        <div class="overflow-x-auto">
            <table class="lw-table w-full min-w-[980px] text-left text-sm">
                <thead><tr><th class="py-3">Tier</th><th>Min Spend</th><th>Min Visits</th><th>Multiplier</th><th>Booking Window</th><th>Priority</th><th>Benefits</th><th>Status</th><th>Action</th></tr></thead>
                <tbody><% List<Map<String,Object>> tiers=(List<Map<String,Object>>)request.getAttribute("tiers"); if(tiers!=null)for(Map<String,Object> t:tiers){ %><tr><td class="py-4 font-bold text-white"><%=t.get("tier_name")%></td><td><%=t.get("min_spent_money")%></td><td><%=t.get("min_visit_count")%></td><td><%=t.get("point_multiplier")%>x</td><td><%=t.get("booking_window_days")%> days</td><td><%=t.get("priority_score")%></td><td><%=t.get("benefits")%></td><td><%=Boolean.TRUE.equals(t.get("is_active"))?"ACTIVE":"INACTIVE"%></td><td><%=t.get("tier_id")%></td></tr><%}%></tbody>
            </table>
        </div>
    </div>

    <div class="lw-card p-6">
        <p class="lw-label">Add / Edit</p>
        <h2 class="font-display text-xl font-bold text-white">Tier Form</h2>
        <form class="mt-5 space-y-4" action="${pageContext.request.contextPath}/admin/tiers/save" method="post">
            <div><label class="lw-label">Tier ID</label><input class="lw-input mt-2" name="tierId" type="number" required /></div>
            <div><label class="lw-label">Tier Name</label><input class="lw-input mt-2" name="tierName" placeholder="Gold" /></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Min Points</label><input class="lw-input mt-2" name="minPoints" min="0" required type="number" /></div><div><label class="lw-label">Discount %</label><input class="lw-input mt-2" name="discountPercent" min="0" max="100" required /></div></div>
            <div class="grid grid-cols-2 gap-3"><div><label class="lw-label">Priority Score</label><input class="lw-input mt-2" name="priorityScore" min="0" required type="number" /></div><div><label class="lw-label">Status</label><select class="lw-select mt-2" name="isActive"><option value="true">ACTIVE</option><option value="false">INACTIVE</option></select></div></div>
            <div><label class="lw-label">Benefits</label><textarea class="lw-textarea mt-2" name="benefits" rows="3" placeholder="Free upgrade monthly"></textarea></div>
            <div class="flex gap-3"><button class="lw-btn-primary flex-1" type="submit">Save Tier</button><button class="lw-btn-ghost" type="reset">Clear</button></div>
        </form>
    </div>
</div>

<%@ include file="../components/admin-shell-end.jspf" %>
