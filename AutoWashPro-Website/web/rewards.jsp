<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.RewardDTO" %>
<%@ page import="mylib.AppKeys" %>
<!DOCTYPE html>
<html class="dark" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>LUXE WASH - Rewards</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Montserrat:wght@600;700&display=swap" rel="stylesheet"/>
    <link href="css/rewards.css" rel="stylesheet"/>
    
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "surface-container": "#1f1f20",
                        "primary-container": "#4b8eff",
                        "on-secondary-fixed-variant": "#574500",
                        "on-primary-fixed": "#001a41",
                        "surface-container-high": "#2a2a2b",
                        "on-tertiary": "#2f3131",
                        "primary-fixed": "#d8e2ff",
                        "outline-variant": "#414755",
                        "on-secondary-container": "#342800",
                        "secondary": "#e9c349",
                        "surface-container-low": "#1b1b1c",
                        "on-primary-fixed-variant": "#004493",
                        "on-tertiary-container": "#282a2a",
                        "surface-container-lowest": "#0e0e0f",
                        "secondary-fixed": "#ffe088",
                        "tertiary": "#c6c6c6",
                        "secondary-container": "#af8d11",
                        "on-error": "#690005",
                        "surface-container-highest": "#353436",
                        "surface": "#131314",
                        "inverse-primary": "#005bc1",
                        "surface-variant": "#353436",
                        "on-primary-container": "#00285c",
                        "surface-dim": "#131314",
                        "secondary-fixed-dim": "#e9c349",
                        "error": "#ffb4ab",
                        "inverse-on-surface": "#303031",
                        "tertiary-fixed-dim": "#c6c6c6",
                        "on-surface-variant": "#c1c6d7",
                        "surface-tint": "#adc6ff",
                        "on-error-container": "#ffdad6",
                        "inverse-surface": "#e5e2e3",
                        "tertiary-fixed": "#e3e2e2",
                        "on-tertiary-fixed": "#1a1c1c",
                        "on-surface": "#e5e2e3",
                        "on-primary": "#002e69",
                        "outline": "#8b90a0",
                        "primary-fixed-dim": "#adc6ff",
                        "surface-bright": "#39393a",
                        "primary": "#adc6ff",
                        "error-container": "#93000a",
                        "on-background": "#e5e2e3",
                        "tertiary-container": "#909191",
                        "on-secondary-fixed": "#241a00",
                        "on-secondary": "#3c2f00",
                        "on-tertiary-fixed-variant": "#464747",
                        "background": "#131314"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "container-margin": "20px",
                        "unit": "4px",
                        "md": "16px",
                        "xl": "32px",
                        "sm": "8px",
                        "xs": "4px",
                        "lg": "24px",
                        "gutter": "16px"
                    },
                    "fontFamily": {
                        "display-lg": ["Montserrat"],
                        "headline-lg": ["Montserrat"],
                        "body-lg": ["Inter"],
                        "label-bold": ["Inter"],
                        "headline-lg-mobile": ["Montserrat"],
                        "body-sm": ["Inter"],
                        "title-md": ["Montserrat"]
                    },
                    "fontSize": {
                        "display-lg": ["40px", { "lineHeight": "48px", "letterSpacing": "-0.02em", "fontWeight": "700" }],
                        "headline-lg": ["32px", { "lineHeight": "40px", "fontWeight": "700" }],
                        "body-lg": ["16px", { "lineHeight": "24px", "fontWeight": "400" }],
                        "label-bold": ["12px", { "lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600" }],
                        "headline-lg-mobile": ["24px", { "lineHeight": "32px", "fontWeight": "700" }],
                        "body-sm": ["14px", { "lineHeight": "20px", "fontWeight": "400" }],
                        "title-md": ["20px", { "lineHeight": "28px", "fontWeight": "600" }]
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-background text-on-background antialiased pb-24 md:pb-0 pt-16 md:pt-20">

    <%
        String errorMessage = (String) request.getAttribute(AppKeys.REQ_ERROR);
        if (errorMessage == null) {
            errorMessage = "";
        }
        String userName = (String) request.getAttribute(AppKeys.REQ_USER_DISPLAY_NAME);
        if (userName == null || userName.trim().isEmpty()) {
            userName = "Guest";
        }
        Long totalSpentMoneyObj = (Long) request.getAttribute(AppKeys.REQ_TOTAL_SPENT_MONEY);
        long totalSpentMoney = totalSpentMoneyObj != null ? totalSpentMoneyObj : 0L;
        Integer userPointsObj = (Integer) request.getAttribute(AppKeys.REQ_USER_POINTS);
        int userPoints = userPointsObj != null ? userPointsObj : 0;
        String memberTier = (String) request.getAttribute(AppKeys.REQ_MEMBER_TIER);
        if (memberTier == null) memberTier = "MEMBER";
        String tierBenefit = (String) request.getAttribute(AppKeys.REQ_TIER_BENEFIT);
        if (tierBenefit == null) tierBenefit = "";
        List<RewardDTO> rewardList = (List<RewardDTO>) request.getAttribute(AppKeys.REQ_REWARD_LIST);
        java.util.Map<Integer, String> rewardIcons = (java.util.Map<Integer, String>) request.getAttribute(AppKeys.REQ_REWARD_ICONS);
        if (rewardIcons == null) {
            rewardIcons = new java.util.HashMap<>();
        }
        String nextRewardName = (String) request.getAttribute(AppKeys.REQ_NEXT_REWARD_NAME);
        if (nextRewardName == null) nextRewardName = "";
        Long nextRewardPointsObj = (Long) request.getAttribute(AppKeys.REQ_NEXT_REWARD_POINTS);
        long nextRewardPoints = nextRewardPointsObj != null ? nextRewardPointsObj : 0L;
        Double progressPercentObj = (Double) request.getAttribute(AppKeys.REQ_PROGRESS_PERCENT);
        double progressPercent = progressPercentObj != null ? progressPercentObj : 0.0;
        Long pointsNeededObj = (Long) request.getAttribute(AppKeys.REQ_POINTS_NEEDED);
        long pointsNeeded = pointsNeededObj != null ? pointsNeededObj : 0L;
        String nextTierName = (String) request.getAttribute(AppKeys.REQ_NEXT_TIER_NAME);
        if (nextTierName == null) nextTierName = "MEMBER";
        Long nextTierPointsObj = (Long) request.getAttribute(AppKeys.REQ_NEXT_TIER_POINTS);
        long nextTierPoints = nextTierPointsObj != null ? nextTierPointsObj : 0L;
        Double tierProgressPercentObj = (Double) request.getAttribute(AppKeys.REQ_TIER_PROGRESS_PERCENT);
        double tierProgressPercent = tierProgressPercentObj != null ? tierProgressPercentObj : 0.0;
        Long moneyToNextTierObj = (Long) request.getAttribute(AppKeys.REQ_MONEY_TO_NEXT_TIER);
        long moneyToNextTier = moneyToNextTierObj != null ? moneyToNextTierObj : 0L;
        String displayPath = request.getContextPath();
    %>

    <!-- TopAppBar (Web) -->
    <header class="hidden md:flex fixed top-0 w-full z-50 bg-surface/80 backdrop-blur-xl border-b border-white/10 shadow-sm justify-between items-center px-container-margin h-16 max-w-7xl mx-auto left-0 right-0">
        <div class="font-display-lg text-display-lg font-bold text-primary">
            LUXE WASH
        </div>
        <nav class="flex gap-lg">
            <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="<%= displayPath %>/MainController?action=Home">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;" >home</span>
                Home
            </a>
                <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="<%= displayPath %>/MainController?action=Profile">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;">person</span>
                Profile
            </a>
            <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="<%= displayPath %>/MainController?action=Booking">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;">local_car_wash</span>
                Book Wash
            </a>
            <a class="text-primary font-bold font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="<%= displayPath %>/MainController?action=Rewards">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">military_tech</span>
                Membership
            </a>
            <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="<%= displayPath %>/MainController?action=Logout">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;">logout</span>
                Logout
            </a>
        </nav>
        <div class="flex gap-md items-center text-primary">
            <span class="material-symbols-outlined cursor-pointer hover:text-primary-fixed transition-colors">notifications</span>
            <span class="material-symbols-outlined cursor-pointer hover:text-primary-fixed transition-colors">settings</span>
        </div>
    </header>

    <!-- Mobile Top Brand (Simple) -->
    <div class="md:hidden fixed top-0 w-full z-50 bg-surface/80 backdrop-blur-xl flex items-center justify-center h-16 border-b border-white/10">
        <div class="font-title-md text-title-md font-bold text-primary">
            LUXE WASH
        </div>
    </div>

    <!-- Main Content Canvas -->
    <main class="max-w-7xl mx-auto px-container-margin grid grid-cols-4 md:grid-cols-12 gap-gutter mt-lg">
        
        <!-- ERROR DISPLAY SECTION -->
        <% if (!errorMessage.isEmpty()) { %>
            <section class="col-span-4 md:col-span-12 mb-lg">
                <div class="glass-card rounded-xl p-lg bg-error-container border-2 border-error">
                    <h2 class="font-headline-lg text-headline-lg text-error mb-md">⚠️ LỖI HỆ THỐNG</h2>
                    <div class="font-body-sm text-body-sm text-on-error-container bg-on-error/5 p-md rounded-lg overflow-auto max-h-64 whitespace-pre-wrap">
                        <%= errorMessage %>
                    </div>
                </div>
            </section>
        <% } %>
        
        <!-- Welcome & Status Area -->
        <section class="col-span-4 md:col-span-12 mb-lg">
            <% try { %>
            <div class="glass-card rounded-xl p-md md:p-lg flex flex-col md:flex-row justify-between items-start md:items-center gap-md">
                <div>
                    <h1 class="font-headline-lg-mobile text-headline-lg-mobile md:font-headline-lg md:text-headline-lg text-on-surface flex items-center gap-sm">
                        🔥 XIN CHÀO: <%= (userName != null ? userName : "Guest") %>
                    </h1>
                    <p class="font-body-sm text-body-sm text-on-surface-variant mt-xs">
                        HẠNG HIỆN TẠI: <span class="gold-text-gradient font-label-bold text-label-bold">[ <%= memberTier %> ]</span>
                        <span class="opacity-80"><%= tierBenefit %></span>
                    </p>
                    <!-- Debug: Show loaded data -->
                    <p class="font-body-sm text-body-sm text-on-surface-variant mt-xs opacity-50">
                        💰 <%= totalSpentMoney %> | ⭐ <%= userPoints %>
                    </p>
                </div>
                <div class="w-16 h-16 rounded-full overflow-hidden border-2 border-secondary p-xs bg-surface-container">
                    <img alt="User profile picture" class="w-full h-full object-cover rounded-full" src="https://lh3.googleusercontent.com/aida-public/AB6AXuATZB1c_9OAskD2clGf02K2huddsMmKlmZfYHjr_HCxdthtCAC5E_DfvISNy6wkI8hR-Rt907KNdZ0SWnJU6XKFwwebZuOiVkFEscW-963skn6BVZhZ4JpS2NsjnxB7Sut3LzzM8fXSsyvKX80LDSLKFdWMWkEFTAdxjcrxTv_E7wsHeBjpvqX9h1PqoYY0I3MkYND3kIEK5jKV1q5vuv-dF1F-3jmZGARKHgMANQ2QLwpvIwIxgkxThW19zjBR_OtclcMqfkviny8F"/>
                </div>
            </div>
            <% } catch (Exception e) { %>
                <div class="glass-card rounded-xl p-lg bg-error-container border-2 border-error">
                    <h3 class="font-headline-lg text-error mb-md">❌ Lỗi Welcome Section</h3>
                    <div class="font-body-sm text-on-error-container bg-on-error/5 p-md rounded whitespace-pre-wrap"><%= e.getMessage() %></div>
                    <div class="font-body-sm text-on-error-container/70 mt-md"><%= e.getClass().getName() %></div>
                </div>
            <% } %>
        </section>

        <!-- Points Balance Block -->
        <section class="col-span-4 md:col-span-12 flex flex-col gap-md mb-md">
            <% try { %>
            <div class="glass-card rounded-xl p-lg relative overflow-hidden h-full flex flex-col justify-center">
                <!-- Decorative background elements -->
                <div class="absolute top-0 right-0 w-32 h-32 bg-primary/10 rounded-full blur-3xl -mr-16 -mt-16 pointer-events-none"></div>
                <div class="absolute bottom-0 left-0 w-24 h-24 bg-secondary/10 rounded-full blur-2xl -ml-12 -mb-12 pointer-events-none"></div>
                
                <!-- 💰 TIỀN CHI TIÊU -->
                <h2 class="font-title-md text-title-md text-on-surface mb-lg">📊 Thống kê tài khoản</h2>
                
                <div class="grid grid-cols-2 gap-md mb-lg">
                    <!-- Tiền chi tiêu -->
                    <div class="bg-gradient-to-br from-secondary/20 to-secondary/10 border border-secondary/30 rounded-lg p-md">
                        <p class="font-body-sm text-body-sm text-on-surface-variant mb-xs">Tiền đã chi tiêu</p>
                        <div class="font-headline-lg text-headline-lg text-secondary">
                            <%= String.format("%,d", totalSpentMoney) %> <span class="font-label-bold text-label-bold">VND</span>
                        </div>
                    </div>
                    
                    <!-- Điểm quy từ tiền -->
                    <div class="bg-gradient-to-br from-primary/20 to-primary/10 border border-primary/30 rounded-lg p-md">
                        <p class="font-body-sm text-body-sm text-on-surface-variant mb-xs">Điểm tích lũy</p>
                        <div class="font-headline-lg text-headline-lg text-primary">
                            <%= userPoints %> <span class="font-label-bold text-label-bold">Pts</span>
                        </div>
                    </div>
                </div>
                
                <!-- Info message -->
                <div class="font-body-sm text-body-sm text-on-surface-variant p-sm bg-surface-container/50 rounded-lg border border-white/5 inline-block self-start">
                    ℹ️ Quy đổi: 1,000 VND = 1 Điểm. Lên hạng dựa trên tiền chi tiêu.
                </div>
                
                <!-- Progress Bar for TIER UPGRADE -->
                <div class="mt-lg w-full max-w-2xl">
                    <% if (nextTierName != null && !nextTierName.equals("MAX")) { %>
                        <div class="flex justify-between items-end mb-xs">
                            <span class="font-label-bold text-label-bold text-on-surface">📈 Lên hạng: <%= nextTierName %></span>
                            <span class="font-label-bold text-label-bold text-secondary"><%= String.format("%,d", nextRewardPoints) %> VND</span>
                        </div>
                        <div class="w-full h-2 bg-surface-container-high rounded-full overflow-hidden">
                            <%
                                int widthPercent = Math.min((int)progressPercent, 100);
                            %>
                            <div class="h-full rounded-full transition-all duration-1000 ease-out bg-gradient-to-r from-secondary to-primary" style="width: <%= widthPercent %>%;"></div>
                        </div>
                        <p class="font-body-sm text-body-sm text-on-surface-variant mt-xs text-right">
                            Còn thiếu <%= String.format("%,d", moneyToNextTier) %> VND (~<%= (long)(moneyToNextTier / 1000) %> Pts)
                        </p>
                    <% } else { %>
                        <p class="font-label-bold text-label-bold text-secondary">✓ Bạn đã đạt cấp thành viên cao nhất!</p>
                    <% } %>
                </div>
            </div>
            <% } catch (Exception e) { %>
                <div class="glass-card rounded-xl p-lg bg-error-container border-2 border-error">
                    <h3 class="font-headline-lg text-error mb-md">❌ Lỗi Points Balance Section</h3>
                    <div class="font-body-sm text-on-error-container bg-on-error/5 p-md rounded whitespace-pre-wrap"><%= e.getMessage() %></div>
                    <div class="font-body-sm text-on-error-container/70 mt-md"><%= e.getClass().getName() %></div>
                </div>
            <% } %>
        </section>

        <!-- Membership Tiers Section -->
        <section class="col-span-4 md:col-span-12 mb-lg flex flex-col gap-md">
            <h3 class="font-title-md text-title-md text-on-surface flex items-center gap-sm">
                <span class="material-symbols-outlined text-secondary">workspace_premium</span>
                Hệ thống hạng thành viên
            </h3>
            <% try { %>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-md">
                <!-- Member Tier -->
                <div class="glass-card rounded-xl p-md flex flex-col justify-start border-t-4 border-outline-variant hover:bg-surface-container-high transition-all <% if ("MEMBER".equals(memberTier)) { %>bg-surface-container-high glow-gold scale-105 z-10<% } %>">
                    <div class="flex items-center gap-sm mb-md <% if ("MEMBER".equals(memberTier)) { %>justify-between<% } %>">
                        <div class="bg-surface-container-high p-sm rounded-full text-on-surface-variant">
                            <span class="material-symbols-outlined">badge</span>
                        </div>
                        <h4 class="font-title-md text-title-md text-on-surface">Member</h4>
                        <% if ("MEMBER".equals(memberTier)) { %>
                            <span class="bg-secondary/20 text-secondary font-label-bold text-[10px] px-2 py-1 rounded-full uppercase">Hạng của bạn</span>
                        <% } %>
                    </div>
                    <div class="font-body-sm text-body-sm text-on-surface-variant space-y-xs">
                        <p><strong>Điều kiện:</strong> 0 VND</p>
                        <p><strong>Điểm thưởng:</strong> 1 Pts = 1,000 VND</p>
                    </div>
                </div>

                <!-- Silver Tier -->
                <div class="glass-card rounded-xl p-md flex flex-col justify-start border-t-4 border-[#C0C0C0] hover:bg-surface-container-high transition-all <% if ("SILVER".equals(memberTier)) { %>bg-surface-container-high glow-gold scale-105 z-10<% } %>">
                    <div class="flex items-center gap-sm mb-md <% if ("SILVER".equals(memberTier)) { %>justify-between<% } %>">
                        <div class="bg-[#C0C0C0]/20 p-sm rounded-full text-[#C0C0C0]">
                            <span class="material-symbols-outlined">military_tech</span>
                        </div>
                        <h4 class="font-title-md text-title-md text-[#C0C0C0]">Silver</h4>
                        <% if ("SILVER".equals(memberTier)) { %>
                            <span class="bg-secondary/20 text-secondary font-label-bold text-[10px] px-2 py-1 rounded-full uppercase">Hạng của bạn</span>
                        <% } %>
                    </div>
                    <div class="font-body-sm text-body-sm text-on-surface-variant space-y-xs">
                        <p><strong>Điều kiện:</strong> Tiêu từ 2M VND</p>
                        <p><strong>Ưu đãi:</strong> +10% điểm, ưu tiên chọn slot</p>
                    </div>
                </div>

                <!-- Gold Tier -->
                <div class="glass-card rounded-xl p-md flex flex-col justify-start border-t-4 border-secondary hover:bg-surface-container-high transition-all <% if ("GOLD".equals(memberTier)) { %>bg-surface-container-high glow-gold scale-105 z-10<% } %>">
                    <div class="flex items-center gap-sm mb-md <% if ("GOLD".equals(memberTier)) { %>justify-between<% } %>">
                        <div class="bg-secondary/20 p-sm rounded-full text-secondary">
                            <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">stars</span>
                        </div>
                        <h4 class="font-title-md text-title-md text-secondary gold-text-gradient">Gold</h4>
                        <% if ("GOLD".equals(memberTier)) { %>
                            <span class="bg-secondary/20 text-secondary font-label-bold text-[10px] px-2 py-1 rounded-full uppercase">Hạng của bạn</span>
                        <% } %>
                    </div>
                    <div class="font-body-sm text-body-sm text-on-surface space-y-xs">
                        <p><strong>Điều kiện:</strong> Tiêu từ 6M VND</p>
                        <p><strong>Ưu đãi:</strong> +20% điểm, miễn phí nâng cấp dịch vụ hàng tháng</p>
                    </div>
                </div>

                <!-- Platinum Tier -->
                <div class="glass-card rounded-xl p-md flex flex-col justify-start border-t-4 border-primary hover:bg-surface-container-high transition-all <% if ("PLATINUM".equals(memberTier)) { %>bg-surface-container-high glow-gold scale-105 z-10<% } %>">
                    <div class="flex items-center gap-sm mb-md <% if ("PLATINUM".equals(memberTier)) { %>justify-between<% } %>">
                        <div class="bg-primary/20 p-sm rounded-full text-primary">
                            <span class="material-symbols-outlined">diamond</span>
                        </div>
                        <h4 class="font-title-md text-title-md text-primary">Platinum</h4>
                        <% if ("PLATINUM".equals(memberTier)) { %>
                            <span class="bg-secondary/20 text-secondary font-label-bold text-[10px] px-2 py-1 rounded-full uppercase">Hạng của bạn</span>
                        <% } %>
                    </div>
                    <div class="font-body-sm text-body-sm text-on-surface-variant space-y-xs">
                        <p><strong>Điều kiện:</strong> Tiêu từ 15M VND</p>
                        <p><strong>Ưu đãi:</strong> +30% điểm, miễn phí 1 lần rửa hàng tháng</p>
                    </div>
                </div>
            </div>
            <% } catch (Exception e) { %>
                <div class="glass-card rounded-xl p-lg bg-error-container border-2 border-error">
                    <h3 class="font-headline-lg text-error mb-md">❌ Lỗi Membership Tiers Section</h3>
                    <div class="font-body-sm text-on-error-container bg-on-error/5 p-md rounded whitespace-pre-wrap"><%= e.getMessage() %></div>
                    <div class="font-body-sm text-on-error-container/70 mt-md"><%= e.getClass().getName() %></div>
                </div>
            <% } %>
        </section>

        <!-- Reward Redemption Grid -->
        <section class="col-span-4 md:col-span-12 flex flex-col gap-md">
            <h3 class="font-title-md text-title-md text-on-surface flex items-center gap-sm">
                <span class="material-symbols-outlined text-primary">redeem</span>
                Danh sách phần thưởng
            </h3>
            <% try { %>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-md">
                <%
                    if (rewardList != null && !rewardList.isEmpty()) {
                        int rewardIndex = 0;
                        for (Object __r_obj : rewardList) {
                            if (!(__r_obj instanceof RewardDTO)) {
                                // Unexpected type in list — log to server and skip
                                System.err.println("Unexpected REWARD_LIST element type: " + (__r_obj == null ? "null" : __r_obj.getClass().getName()));
                                rewardIndex++;
                                continue;
                            }
                            RewardDTO reward = (RewardDTO) __r_obj;
                            boolean canRedeem = userPoints >= reward.getPointsRequired();
                            String icon = rewardIcons.get(rewardIndex) != null ? rewardIcons.get(rewardIndex) : "payments";
                %>
                    <div class="glass-card rounded-xl p-md flex flex-col justify-between border-l-4 border-l-primary <% if (!canRedeem) { %>opacity-60<% } %> hover:bg-surface-container-high transition-colors">
                        <div class="flex justify-between items-start mb-md">
                            <div class="<% if (canRedeem) { %>bg-primary/20 text-primary<% } else { %>bg-surface-container text-on-surface-variant<% } %> p-sm rounded-lg">
                                <span class="material-symbols-outlined">
                                    <%= icon %>
                                </span>
                            </div>
                            <span class="<% if (canRedeem) { %>bg-primary-container text-on-primary-container<% } else { %>bg-surface-variant text-on-surface-variant<% } %> font-label-bold text-label-bold px-2 py-1 rounded-full"><%= reward.getPointsRequired() %> Pts</span>
                        </div>
                        <div>
                            <h4 class="font-body-lg text-body-lg text-on-surface mb-xs"><%= reward.getRewardName() %></h4>
                            <% if (reward.getDescription() != null && !reward.getDescription().isEmpty()) { %>
                                <p class="font-body-sm text-body-sm text-on-surface-variant mb-md"><%= reward.getDescription() %></p>
                            <% } %>
                            <button <% if (!canRedeem) { %>disabled<% } %> class="mt-sm w-full <% if (canRedeem) { %>bg-primary hover:bg-primary-fixed text-on-primary<% } else { %>bg-surface-container border border-outline-variant text-on-surface-variant cursor-not-allowed flex items-center justify-center gap-xs<% } %> font-label-bold text-label-bold py-2 rounded-lg transition-colors active:scale-95">
                                <% if (canRedeem) { %>
                                    ĐỔI QUÀ
                                <% } else { %>
                                    <span class="material-symbols-outlined text-[16px]">lock</span> KHÓA
                                <% } %>
                            </button>
                        </div>
                    </div>
                <%
                            rewardIndex++;
                        }
                    } else {
                %>
                    <div class="col-span-4 glass-card rounded-xl p-lg text-center">
                        <p class="font-body-lg text-body-lg text-on-surface-variant">Không tìm thấy phần thưởng nào từ hệ thống.</p>
                    </div>
                <%
                    }
                %>
            </div>
            <% } catch (Exception e) { %>
                <div class="glass-card rounded-xl p-lg bg-error-container border-2 border-error">
                    <h3 class="font-headline-lg text-error mb-md">❌ Lỗi Reward Redemption Grid</h3>
                    <div class="font-body-sm text-on-error-container bg-on-error/5 p-md rounded whitespace-pre-wrap"><%= e.getMessage() %></div>
                    <div class="font-body-sm text-on-error-container/70 mt-md"><%= e.getClass().getName() %></div>
                </div>
            <% } %>
        </section>

    </main>

    <!-- BottomNavBar (Mobile) -->
    <nav class="md:hidden fixed bottom-0 left-0 w-full z-50 flex justify-around items-center px-4 py-3 pb-safe bg-surface-container/80 backdrop-blur-2xl border-t border-white/5 shadow-2xl rounded-t-xl">
        <a class="flex flex-col items-center justify-center text-on-surface-variant p-2 hover:bg-surface-container-high transition-all active:scale-90 duration-200 rounded-xl" href="<%= request.getContextPath() %>/MainController?action=Home">
            <span class="material-symbols-outlined mb-1" style="font-variation-settings: 'FILL' 0;">home</span>
            <span class="font-label-bold text-[10px]">Home</span>
        </a>
        <a class="flex flex-col items-center justify-center text-on-surface-variant p-2 hover:bg-surface-container-high transition-all active:scale-90 duration-200 rounded-xl" href="<%= request.getContextPath() %>/MainController?action=Profile">
            <span class="material-symbols-outlined mb-1" style="font-variation-settings: 'FILL' 0;">person</span>
            <span class="font-label-bold text-[10px]">Profile</span>
        </a>
        <a class="flex flex-col items-center justify-center text-on-surface-variant p-2 hover:bg-surface-container-high transition-all active:scale-90 duration-200 rounded-xl" href="<%= request.getContextPath() %>/MainController?action=Booking">
            <span class="material-symbols-outlined mb-1" style="font-variation-settings: 'FILL' 0;">local_car_wash</span>
            <span class="font-label-bold text-[10px]">Book Wash</span>
        </a>
        <a class="flex flex-col items-center justify-center bg-primary-container text-on-primary-container rounded-xl p-2 min-w-[64px] active:scale-90 transition-all duration-200" href="<%= request.getContextPath() %>/MainController?action=Rewards">
            <span class="material-symbols-outlined mb-1" style="font-variation-settings: 'FILL' 1;">military_tech</span>
            <span class="font-label-bold text-[10px]">Rewards</span>
        </a>
        <a class="flex flex-col items-center justify-center text-on-surface-variant p-2 hover:bg-surface-container-high transition-all active:scale-90 duration-200 rounded-xl" href="<%= request.getContextPath() %>/MainController?action=Logout">
            <span class="material-symbols-outlined mb-1" style="font-variation-settings: 'FILL' 0;">logout</span>
            <span class="font-label-bold text-[10px]">Logout</span>
        </a>
    </nav>

</body>
</html>










