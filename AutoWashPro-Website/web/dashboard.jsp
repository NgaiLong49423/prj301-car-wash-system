<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="mylib.AppKeys"%>


<!DOCTYPE html>

<html class="dark" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Luxe Wash - Trang chủ</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&amp;family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "surface-variant": "#353436",
                        "surface": "#131314",
                        "inverse-on-surface": "#303031",
                        "on-surface": "#e5e2e3",
                        "surface-bright": "#39393a",
                        "on-error": "#690005",
                        "on-tertiary-fixed": "#1a1c1c",
                        "surface-dim": "#131314",
                        "secondary-fixed-dim": "#e9c349",
                        "secondary": "#e9c349",
                        "primary-container": "#4b8eff",
                        "on-tertiary-container": "#282a2a",
                        "on-secondary-fixed-variant": "#574500",
                        "on-secondary-fixed": "#241a00",
                        "tertiary-fixed-dim": "#c6c6c6",
                        "surface-tint": "#adc6ff",
                        "on-primary-fixed-variant": "#004493",
                        "on-primary-container": "#00285c",
                        "secondary-container": "#af8d11",
                        "primary": "#adc6ff",
                        "on-primary-fixed": "#001a41",
                        "primary-fixed-dim": "#adc6ff",
                        "outline": "#8b90a0",
                        "primary-fixed": "#d8e2ff",
                        "on-error-container": "#ffdad6",
                        "tertiary": "#c6c6c6",
                        "inverse-primary": "#005bc1",
                        "secondary-fixed": "#ffe088",
                        "error": "#ffb4ab",
                        "outline-variant": "#414755",
                        "inverse-surface": "#e5e2e3",
                        "tertiary-container": "#909191",
                        "error-container": "#93000a",
                        "surface-container-highest": "#353436",
                        "surface-container-lowest": "#0e0e0f",
                        "on-secondary-container": "#342800",
                        "on-surface-variant": "#c1c6d7",
                        "on-primary": "#002e69",
                        "surface-container-low": "#1b1b1c",
                        "background": "#131314",
                        "surface-container-high": "#2a2a2b",
                        "on-background": "#e5e2e3",
                        "on-secondary": "#3c2f00",
                        "surface-container": "#1f1f20",
                        "on-tertiary-fixed-variant": "#464747",
                        "tertiary-fixed": "#e3e2e2",
                        "on-tertiary": "#2f3131"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "xs": "4px",
                        "sm": "8px",
                        "md": "16px",
                        "xl": "32px",
                        "unit": "4px",
                        "container-margin": "20px",
                        "lg": "24px",
                        "gutter": "16px"
                    },
                    "fontFamily": {
                        "headline-lg": ["Montserrat"],
                        "label-bold": ["Inter"],
                        "display-lg": ["Montserrat"],
                        "body-lg": ["Inter"],
                        "title-md": ["Montserrat"],
                        "body-sm": ["Inter"],
                        "headline-lg-mobile": ["Montserrat"]
                    },
                    "fontSize": {
                        "headline-lg": ["32px", { "lineHeight": "40px", "fontWeight": "700" }],
                        "label-bold": ["12px", { "lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600" }],
                        "display-lg": ["40px", { "lineHeight": "48px", "letterSpacing": "-0.02em", "fontWeight": "700" }],
                        "body-lg": ["16px", { "lineHeight": "24px", "fontWeight": "400" }],
                        "title-md": ["20px", { "lineHeight": "28px", "fontWeight": "600" }],
                        "body-sm": ["14px", { "lineHeight": "20px", "fontWeight": "400" }],
                        "headline-lg-mobile": ["24px", { "lineHeight": "32px", "fontWeight": "700" }]
                    }
                }
            }
        }
    </script>
<style>
        .glass-panel {
            background: rgba(30, 30, 31, 0.6);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .text-glow-primary {
            text-shadow: 0 0 15px rgba(173, 198, 255, 0.5);
        }
        .box-glow-primary {
            box-shadow: 0 0 15px rgba(173, 198, 255, 0.3);
        }
    </style>
</head>
<body class="bg-background text-on-background font-body-lg antialiased min-h-screen flex flex-col">
    <!-- TopAppBar (Web) -->
    <header class="hidden md:flex fixed top-0 w-full z-50 bg-surface/80 backdrop-blur-xl border-b border-white/10 shadow-sm justify-between items-center px-container-margin h-16 max-w-7xl mx-auto left-0 right-0">
        <div class="font-display-lg text-display-lg font-bold text-primary">
            LUXE WASH
        </div>
        <nav class="flex gap-lg">
            <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="<%= request.getContextPath() %>/MainController?action=Home">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;" >home</span>
                Home
            </a>
                <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="<%= request.getContextPath() %>/MainController?action=Profile">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;">person</span>
                Profile
            </a>
                <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="CreateBookingServlet">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;">local_car_wash</span>
                    Book Wash
                </a>
            <a class="text-primary font-bold font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="<%= request.getContextPath() %>/MainController?action=Rewards">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">military_tech</span>
                Membership
            </a>
            <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-xs" href="<%= request.getContextPath() %>/MainController?action=Logout">
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

<main class="flex-grow pt-24 md:pt-32">
<!-- Hero Section -->
<section class="relative w-full h-[70vh] min-h-[600px] flex items-center justify-center overflow-hidden px-container-margin">
<div class="absolute inset-0 z-0">
<img alt="Hero Car" class="w-full h-full object-cover object-center opacity-70" src="https://lh3.googleusercontent.com/aida/AP1WRLskjNQKW3Tu-bs0XSsEYNDDN8qiMN4AJ1u9ZwviXUBcxG4d1eWYUrRJ3xjG39WALy4x08izP6r1nNRHzGbugx0w4JdbUZKHs8MHh8ZPWk__2BdqzQFPILpwHYshNkiL74dKYzNBEE0Ug8045lbOtgd-k26OnUp3lqTXr73ETP0k1rrf9NTULQUaWJwezZoYTld7hQNDVvFYnwqwX_eAE8vyPB3uQ4lSzZqVfWtCHtQvDK8goAwp8QZTLaYp=s1600"/>
<div class="absolute inset-0 bg-gradient-to-b from-background/40 via-background/60 to-background"></div>
</div>
<div class="relative z-10 max-w-7xl mx-auto w-full flex flex-col md:flex-row items-center justify-between gap-xl">
<div class="max-w-2xl">
<h1 class="font-display-lg text-display-lg md:text-[56px] md:leading-[64px] font-bold text-on-background mb-md text-glow-primary tracking-tight">
                        Chăm sóc xe sang,<br/>Trải nghiệm đẳng cấp.
                    </h1>
<p class="font-body-lg text-body-lg text-on-surface-variant mb-xl max-w-lg">
                        Hệ thống detailing chuyên nghiệp dành riêng cho những kiệt tác cơ khí. Độ bóng hoàn hảo, bảo vệ tối đa, dịch vụ chuẩn mực.
                    </p>
<div class="flex flex-wrap gap-md">
<a href="<%= request.getContextPath() %>/MainController?action=Booking" class="bg-primary text-on-primary font-label-bold text-label-bold px-8 py-4 rounded-lg flex items-center gap-2 hover:bg-primary-container transition-all box-glow-primary">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">calendar_today</span>
                            Đặt lịch ngay
                        </a>
<a class="glass-panel text-on-surface font-label-bold text-label-bold px-8 py-4 rounded-lg hover:bg-surface-bright transition-all border border-outline-variant inline-flex items-center justify-center" href="<%= request.getContextPath() %>/MainController?action=Rewards">
                            Tìm hiểu về Membership
</a>
</div>
</div>
<!-- Floating Stats Card -->
<div class="hidden lg:block glass-panel p-lg rounded-xl max-w-xs self-end mb-xl animate-[pulse_4s_ease-in-out_infinite]">
<div class="flex items-center gap-sm mb-sm text-secondary">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">verified</span>
<span class="font-label-bold text-label-bold uppercase">Chứng nhận chuyên gia</span>
</div>
<div class="font-title-md text-title-md text-on-surface mb-xs">
                        Hơn 5000+ xe sang
                    </div>
<div class="font-body-sm text-body-sm text-on-surface-variant">
                        Đã được chăm sóc bởi đội ngũ Luxe Wash trong năm qua.
                    </div>
</div>
</div>
</section>
<%
    String chatSupportFeature = (String) request.getAttribute(AppKeys.REQ_CHAT_SUPPORT_FEATURE);
    String chatSupportResponse = (String) request.getAttribute(AppKeys.REQ_CHAT_SUPPORT_RESPONSE);
    Boolean chatSupportHasCookie = (Boolean) request.getAttribute(AppKeys.REQ_CHAT_SUPPORT_HAS_COOKIE);
    String chatSupportError = (String) request.getAttribute(AppKeys.REQ_CHAT_SUPPORT_ERROR);
    boolean chatPanelOpen = (Boolean.TRUE.equals(chatSupportHasCookie) && chatSupportResponse != null)
            || (chatSupportError != null && !chatSupportError.trim().isEmpty());
%>
<!-- Services Section -->
<section class="py-24 px-container-margin max-w-7xl mx-auto">
<div class="text-center mb-16">
<h2 class="font-headline-lg text-headline-lg md:text-headline-lg text-on-background mb-xs">Dịch vụ nổi bật</h2>
<p class="font-body-lg text-body-lg text-on-surface-variant">Giải pháp chăm sóc toàn diện cho xế cưng của bạn.</p>
</div>
<div class="grid grid-cols-1 md:grid-cols-3 gap-lg">
<!-- Service Card 1 -->
<div class="glass-panel p-lg rounded-xl hover:border-primary/50 transition-all group flex flex-col h-full">
<div class="w-12 h-12 bg-surface-container-high rounded-full flex items-center justify-center mb-md text-primary group-hover:bg-primary/10 transition-colors">
<span class="material-symbols-outlined text-2xl">local_car_wash</span>
</div>
<h3 class="font-title-md text-title-md text-on-surface mb-sm">Rửa xe cao cấp</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant mb-lg flex-grow">Quy trình rửa xe chi tiết với các hóa chất chuyên dụng, an toàn tuyệt đối cho bề mặt sơn và các chi tiết kim loại.</p>
<a class="inline-flex items-center gap-xs font-label-bold text-label-bold text-primary hover:text-primary-container transition-colors mt-auto" href="<%= request.getContextPath() %>/MainController?action=Booking">
                        Chi tiết <span class="material-symbols-outlined text-sm">arrow_forward</span>
</a>
</div>
<!-- Service Card 2 -->
<div class="glass-panel p-lg rounded-xl border-primary/30 hover:border-primary/50 transition-all group relative overflow-hidden flex flex-col h-full">
<div class="absolute top-0 right-0 bg-primary text-on-primary font-label-bold text-[10px] px-2 py-1 rounded-bl-lg uppercase tracking-wider">Phổ biến nhất</div>
<div class="w-12 h-12 bg-surface-container-high rounded-full flex items-center justify-center mb-md text-primary group-hover:bg-primary/10 transition-colors relative z-10">
<span class="material-symbols-outlined text-2xl">layers</span>
</div>
<h3 class="font-title-md text-title-md text-on-surface mb-sm relative z-10">Phủ Ceramic</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant mb-lg relative z-10 flex-grow">Tạo lớp khiên bảo vệ sơn xe khỏi các tác nhân môi trường, tăng độ bóng sâu và khả năng chống bám nước vượt trội.</p>
<a class="inline-flex items-center gap-xs font-label-bold text-label-bold text-primary hover:text-primary-container transition-colors relative z-10 mt-auto" href="<%= request.getContextPath() %>/MainController?action=Booking">
                        Chi tiết <span class="material-symbols-outlined text-sm">arrow_forward</span>
</a>
<!-- Subtle background glow -->
<div class="absolute -bottom-10 -right-10 w-32 h-32 bg-primary/10 blur-3xl rounded-full z-0"></div>
</div>
<!-- Service Card 3 -->
<div class="glass-panel p-lg rounded-xl hover:border-primary/50 transition-all group flex flex-col h-full">
<div class="w-12 h-12 bg-surface-container-high rounded-full flex items-center justify-center mb-md text-primary group-hover:bg-primary/10 transition-colors">
<span class="material-symbols-outlined text-2xl">airline_seat_recline_extra</span>
</div>
<h3 class="font-title-md text-title-md text-on-surface mb-sm">Vệ sinh nội thất</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant mb-lg flex-grow">Phục hồi và làm sạch sâu các chi tiết da, nỉ, nhựa trong xe. Khử mùi và diệt khuẩn bằng công nghệ hơi nước nóng.</p>
<a class="inline-flex items-center gap-xs font-label-bold text-label-bold text-primary hover:text-primary-container transition-colors mt-auto" href="<%= request.getContextPath() %>/MainController?action=ComingSoon">
                        Chi tiết <span class="material-symbols-outlined text-sm">arrow_forward</span>
</a>
</div>
</div>
</section>
<!-- Elite Pass & Partners Section (Bento Grid) -->
<section class="py-24 px-container-margin max-w-7xl mx-auto border-t border-outline-variant/30">
<div class="grid grid-cols-1 lg:grid-cols-12 gap-lg auto-rows-[minmax(180px,auto)]">
<!-- Elite Pass Teaser -->
<div class="lg:col-span-8 lg:row-span-2 glass-panel rounded-xl p-lg relative overflow-hidden flex flex-col justify-center">
<div class="absolute inset-0 bg-gradient-to-br from-surface-variant/80 to-surface-container z-0"></div>
<div class="absolute top-0 right-0 w-64 h-64 bg-secondary/10 blur-3xl rounded-full translate-x-1/3 -translate-y-1/3"></div>
<div class="relative z-10">
<div class="flex items-center gap-2 mb-md">
<span class="material-symbols-outlined text-secondary" style="font-variation-settings: 'FILL' 1;">workspace_premium</span>
<span class="font-label-bold text-label-bold text-secondary uppercase tracking-widest">Hội viên đặc quyền</span>
</div>
<h2 class="font-headline-lg text-headline-lg text-on-background mb-sm">Elite Pass Membership</h2>
<p class="font-body-lg text-body-lg text-on-surface-variant max-w-xl mb-lg">
                            Nâng tầm trải nghiệm với thẻ hội viên Elite Pass. Tích lũy điểm thưởng, nhận ưu đãi độc quyền, dịch vụ đưa đón xe tận nơi và phòng chờ VIP sang trọng.
                        </p>
<div class="flex flex-wrap gap-4 mb-lg">
<div class="bg-surface/50 border border-outline-variant rounded-lg px-4 py-2 flex items-center gap-2">
<span class="material-symbols-outlined text-primary text-sm">check_circle</span>
<span class="font-body-sm text-body-sm text-on-surface">Hoàn tiền lên đến 15%</span>
</div>
<div class="bg-surface/50 border border-outline-variant rounded-lg px-4 py-2 flex items-center gap-2">
<span class="material-symbols-outlined text-primary text-sm">check_circle</span>
<span class="font-body-sm text-body-sm text-on-surface">Ưu tiên đặt lịch</span>
</div>
</div>
<button class="bg-secondary text-on-secondary font-label-bold text-label-bold px-6 py-3 rounded-lg hover:bg-secondary-container transition-colors inline-flex items-center gap-2">
                            Khám phá ngay <span class="material-symbols-outlined text-sm">arrow_forward</span>
</button>
</div>
</div>
<!-- App Promo -->
<div class="lg:col-span-4 lg:row-span-1 glass-panel rounded-xl p-lg flex flex-col justify-center border-l-4 border-primary">
<h3 class="font-title-md text-title-md text-on-surface mb-2">Tải ứng dụng Luxe Wash</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant mb-4">Quản lý lịch hẹn, theo dõi điểm thưởng và nhận thông báo bảo dưỡng dễ dàng.</p>
<div class="flex gap-2">
<button class="bg-surface-container border border-outline-variant rounded px-3 py-1.5 flex items-center gap-2 hover:bg-surface-bright transition-colors">
<span class="material-symbols-outlined text-sm">ios</span>
<span class="font-label-bold text-[10px] uppercase">App Store</span>
</button>
<button class="bg-surface-container border border-outline-variant rounded px-3 py-1.5 flex items-center gap-2 hover:bg-surface-bright transition-colors">
<span class="material-symbols-outlined text-sm">shop</span>
<span class="font-label-bold text-[10px] uppercase">Google Play</span>
</button>
</div>
</div>
<!-- Partners -->
<div class="lg:col-span-4 lg:row-span-1 glass-panel rounded-xl p-lg flex flex-col justify-center items-center text-center">
<h3 class="font-title-md text-title-md text-on-surface mb-2">Đối tác uy tín</h3>
<p class="font-body-sm text-body-sm text-on-surface-variant mb-4">Sử dụng các sản phẩm hóa chất cao cấp nhất thế giới.</p>
<div class="flex flex-wrap justify-center gap-4 opacity-70">
<!-- Placeholder for partner logos -->
<div class="font-display-lg text-xl font-bold tracking-widest uppercase">Gyeon</div>
<div class="font-display-lg text-xl font-bold tracking-widest uppercase">Rupes</div>
<div class="font-display-lg text-xl font-bold tracking-widest uppercase">CarPro</div>
</div>
</div>
</div>
</section>
</main>
<!-- BottomNavBar (Mobile only) -->
<nav class="md:hidden fixed bottom-0 left-0 w-full z-50 flex justify-around items-center px-4 py-3 bg-surface/90 dark:bg-surface/90 backdrop-blur-xl border-t border-white/5 shadow-[0px_-4px_20px_rgba(0,0,0,0.5)] rounded-t-xl">
<a class="flex flex-col items-center justify-center text-secondary dark:text-secondary bg-surface-variant/50 rounded-xl px-4 py-1 Active: scale-90 transition-transform font-label-bold text-label-bold hover:text-primary dark:hover:text-primary" href="<%= request.getContextPath() %>/MainController?action=Home">
<span class="material-symbols-outlined mb-1" style="font-variation-settings: 'FILL' 1;">home</span>
            Home
        </a>
<a class="flex flex-col items-center justify-center text-on-surface-variant dark:text-on-surface-variant hover:text-primary dark:hover:text-primary font-label-bold text-label-bold" href="<%= request.getContextPath() %>/MainController?action=Booking">
<span class="material-symbols-outlined mb-1">calendar_month</span>
            Booking
        </a>
<a class="flex flex-col items-center justify-center text-on-surface-variant dark:text-on-surface-variant hover:text-primary dark:hover:text-primary font-label-bold text-label-bold" href="<%= request.getContextPath() %>/MainController?action=Rewards">
<span class="material-symbols-outlined mb-1">star</span>
            Rewards
        </a>
<a class="flex flex-col items-center justify-center text-on-surface-variant dark:text-on-surface-variant hover:text-primary dark:hover:text-primary font-label-bold text-label-bold" href="<%= request.getContextPath() %>/MainController?action=Profile">
<span class="material-symbols-outlined mb-1">person</span>
            Profile
        </a>
</nav>
<!-- Footer -->
<footer class="bg-surface-container-lowest dark:bg-surface-container-lowest border-t border-outline-variant w-full py-xl px-container-margin flex flex-col md:flex-row justify-between items-center gap-md pb-24 md:pb-xl mt-auto">
<div class="font-title-md text-title-md text-on-surface">
            Luxe Wash
        </div>
<div class="flex flex-wrap justify-center gap-md font-body-sm text-body-sm">
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="<%= request.getContextPath() %>/MainController?action=ComingSoon">Privacy Policy</a>
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="<%= request.getContextPath() %>/MainController?action=ComingSoon">Terms of Service</a>
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="<%= request.getContextPath() %>/MainController?action=ComingSoon">Contact Support</a>
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="<%= request.getContextPath() %>/MainController?action=ComingSoon">Careers</a>
</div>
<div class="font-body-sm text-body-sm text-primary dark:text-primary">
            © 2024 Luxe Wash Detailing. All rights reserved.
        </div>
</footer>

<!-- Support Chat Widget -->
<div class="fixed bottom-24 right-5 md:bottom-6 md:right-6 z-50">
    <button id="chatToggleBtn" type="button" class="flex items-center gap-2 rounded-full bg-primary text-on-primary px-4 py-3 shadow-2xl shadow-black/30 hover:bg-primary-container transition-colors active:scale-95">
        <span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">chat</span>
        <span class="font-label-bold text-label-bold">Hỗ trợ</span>
    </button>

    <div id="chatPanel" class="<%= chatPanelOpen ? "" : "hidden" %> mt-3 w-[360px] max-w-[calc(100vw-2rem)] overflow-hidden rounded-3xl border border-white/10 bg-surface/95 backdrop-blur-xl shadow-2xl shadow-black/40">
        <div class="flex items-center justify-between border-b border-white/10 px-4 py-3 bg-surface-container/80">
            <div>
                <div class="font-title-md text-title-md text-on-surface">Chat hỗ trợ khách hàng</div>
                <div class="text-xs text-on-surface-variant">Gửi đề xuất tính năng để hệ thống lưu bằng cookie 7 ngày</div>
            </div>
            <button id="chatCloseBtn" type="button" class="text-on-surface-variant hover:text-on-surface transition-colors">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <div class="px-4 py-4 bg-gradient-to-b from-surface to-surface-container-low space-y-3">
            <div class="space-y-3 max-h-72 overflow-y-auto pr-1">
                <div class="flex justify-start">
                    <div class="max-w-[88%] rounded-2xl rounded-tl-md bg-surface-container-high px-3 py-2 text-sm text-on-surface leading-6 shadow-sm">
                        Luxe Wash Detailing Studio hiện đang được hoàn thiện liên tục để nâng cao trải nghiệm. Hãy giúp chúng tôi xây dựng ứng dụng tốt hơn bằng cách đề xuất tính năng bạn mong muốn theo cú pháp: <strong>[Tính năng đề xuất]</strong>. Hệ thống sẽ tự động lưu lại để xử lý.
                    </div>
                </div>
                <% if (Boolean.TRUE.equals(chatSupportHasCookie) && chatSupportFeature != null && chatSupportResponse != null) { %>
                <div class="flex justify-end">
                    <div class="max-w-[88%] rounded-2xl rounded-tr-md bg-primary text-on-primary px-3 py-2 text-sm leading-6 shadow-sm">
                        <%= chatSupportFeature %>
                    </div>
                </div>
                <div class="flex justify-start">
                    <div class="max-w-[88%] rounded-2xl rounded-tl-md bg-surface-container-high px-3 py-2 text-sm text-on-surface leading-6 shadow-sm">
                        <%= chatSupportResponse %>
                    </div>
                </div>
                <% } %>
                <% if (chatSupportError != null && !chatSupportError.trim().isEmpty()) { %>
                <div class="flex justify-start">
                    <div class="max-w-[88%] rounded-2xl rounded-tl-md bg-error-container/30 border border-error/30 px-3 py-2 text-sm text-on-surface leading-6 shadow-sm">
                        <%= chatSupportError %>
                    </div>
                </div>
                <% } %>
            </div>
            <div class="rounded-2xl border border-white/10 bg-surface-container-high px-4 py-3 text-sm text-on-surface leading-6">
                Gợi ý: ví dụ <strong>[Đặt lịch rửa xe bằng giờ]</strong> hoặc <strong>[Theo dõi trạng thái xe]</strong>.
            </div>
            <form action="<%= request.getContextPath() %>/MainController" method="post" class="space-y-3">
                <input type="hidden" name="action" value="SupportChat"/>
                <textarea name="supportFeature" rows="3" class="w-full resize-none rounded-2xl border border-outline-variant bg-surface-container-low px-3 py-2 text-sm text-on-surface placeholder:text-on-surface-variant focus:border-primary focus:outline-none" placeholder="[Tính năng đề xuất]" required="required"><%= chatSupportFeature != null ? chatSupportFeature : "" %></textarea>
                <div class="flex items-center justify-between gap-2">
                    <div class="text-[11px] text-on-surface-variant">Cookie chatCookie sẽ lưu tối đa 7 ngày trên trình duyệt khách.</div>
                    <button type="submit" class="inline-flex items-center gap-2 rounded-xl bg-secondary px-4 py-2 text-sm font-semibold text-on-secondary hover:bg-secondary-container transition-colors active:scale-95">
                        Gửi yêu cầu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
(function () {
    var toggleBtn = document.getElementById('chatToggleBtn');
    var closeBtn = document.getElementById('chatCloseBtn');
    var panel = document.getElementById('chatPanel');

    toggleBtn.addEventListener('click', function () {
        panel.classList.toggle('hidden');
    });

    closeBtn.addEventListener('click', function () {
        panel.classList.add('hidden');
    });
})();
</script>
</body></html>






