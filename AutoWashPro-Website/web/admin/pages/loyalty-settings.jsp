<% request.setAttribute("pageTitle", "Loyalty Settings"); request.setAttribute("activePage", "settings"); %>
<%@ include file="../components/admin-head.jspf" %>
<%@ include file="../components/admin-shell-start.jspf" %>

<!-- UI MOCK ONLY: Replace values with ${loyaltyConfig} from AdminLoyaltySettingsServlet. -->
<div class="grid gap-6 xl:grid-cols-[1fr_.8fr]">
    <div class="lw-card p-6">
        <p class="lw-label">Global Configuration</p>
        <h2 class="font-display text-xl font-bold text-white">Loyalty Program Settings</h2>
        <p class="mt-2 text-sm text-text-muted">These values control earning, expiry, and voucher validity. Final implementation must load and save them from database.</p>
        <form class="mt-6 grid gap-5 md:grid-cols-2" action="${pageContext.request.contextPath}/admin/loyalty-settings/save" method="post">
            <div class="lw-panel p-5">
                <div class="mb-4 grid h-11 w-11 place-items-center rounded-xl bg-gold/10 text-gold"><span class="material-symbols-outlined">hourglass_top</span></div>
                <label class="lw-label">Point Expiry Months</label>
                <input class="lw-input mt-2" name="pointExpiryMonths" type="number" value="12" />
                <p class="mt-2 text-sm text-text-muted">Mock value only. Do not hardcode in Java.</p>
            </div>
            <div class="lw-panel p-5">
                <div class="mb-4 grid h-11 w-11 place-items-center rounded-xl bg-blue/10 text-blue"><span class="material-symbols-outlined">paid</span></div>
                <label class="lw-label">Point Rate Amount</label>
                <input class="lw-input mt-2" name="pointRateAmount" type="number" value="1000" />
                <p class="mt-2 text-sm text-text-muted">Example: 1 point per 1,000 VND before multiplier.</p>
            </div>
            <div class="lw-panel p-5">
                <div class="mb-4 grid h-11 w-11 place-items-center rounded-xl bg-gold/10 text-gold"><span class="material-symbols-outlined">confirmation_number</span></div>
                <label class="lw-label">Default Voucher Valid Days</label>
                <input class="lw-input mt-2" name="defaultVoucherValidDays" type="number" value="30" />
                <p class="mt-2 text-sm text-text-muted">Default validity when reward does not override it.</p>
            </div>
            <div class="lw-panel p-5">
                <div class="mb-4 grid h-11 w-11 place-items-center rounded-xl bg-success/10 text-success"><span class="material-symbols-outlined">toggle_on</span></div>
                <label class="lw-label">Loyalty Status</label>
                <select class="lw-select mt-2" name="loyaltyStatus"><option>ACTIVE</option><option>INACTIVE</option></select>
                <p class="mt-2 text-sm text-text-muted">Controls whether earning/redeeming is available.</p>
            </div>
            <div class="md:col-span-2 flex flex-col gap-3 sm:flex-row"><button class="lw-btn-primary" type="submit">Save Settings</button><button class="lw-btn-ghost" type="reset">Reset Form</button></div>
        </form>
    </div>
    <div class="lw-card p-6">
        <p class="lw-label">Impact Summary</p>
        <h2 class="font-display text-xl font-bold text-white">What This Changes</h2>
        <div class="mt-5 space-y-4">
            <div class="lw-panel p-4"><p class="font-bold text-white">Point Expiry</p><p class="mt-1 text-sm text-text-muted">Affects LoyaltyPointBatch.expires_at and active point refresh.</p></div>
            <div class="lw-panel p-4"><p class="font-bold text-white">Point Rate</p><p class="mt-1 text-sm text-text-muted">Affects earned points when booking becomes COMPLETED.</p></div>
            <div class="lw-panel p-4"><p class="font-bold text-white">Voucher Validity</p><p class="mt-1 text-sm text-text-muted">Affects redemption/voucher expiry date.</p></div>
        </div>
    </div>
</div>

<%@ include file="../components/admin-shell-end.jspf" %>
