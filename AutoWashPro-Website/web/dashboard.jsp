<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.User"%>

<%
    User c = (User) session.getAttribute("account");

    if(c == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>


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
<!-- TopAppBar -->
<header class="fixed top-0 w-full z-50 bg-surface/80 dark:bg-surface/80 backdrop-blur-md shadow-md border-b border-white/10 flex justify-between items-center px-container-margin py-md max-w-7xl mx-auto transition-all duration-300">
<div class="font-display-lg text-display-lg font-bold text-primary dark:text-primary tracking-tighter">
            Luxe Wash
        </div>
<nav class="hidden md:flex gap-lg items-center">
<a class="text-primary dark:text-primary border-b-2 border-primary pb-1 font-headline-lg text-headline-lg transition-colors duration-300" href="home.jsp">Home</a>
<a class="text-on-surface-variant dark:text-on-surface-variant hover:text-primary font-headline-lg text-headline-lg hover:bg-surface-bright dark:hover:bg-surface-bright transition-colors duration-300 rounded px-2 py-1" href="profile.jsp">Profile</a>
<a class="text-on-surface-variant dark:text-on-surface-variant hover:text-primary font-headline-lg text-headline-lg hover:bg-surface-bright dark:hover:bg-surface-bright transition-colors duration-300 rounded px-2 py-1" href="#">Book Wash</a>
<a class="text-on-surface-variant dark:text-on-surface-variant hover:text-primary font-headline-lg text-headline-lg hover:bg-surface-bright dark:hover:bg-surface-bright transition-colors duration-300 rounded px-2 py-1" href="rewards">Membership</a>
</nav>
<div class="hidden md:flex gap-md items-center">
<a href="logout" class="text-on-surface-variant hover:text-primary font-body-lg text-body-lg transition-colors duration-300 px-4 py-2 rounded-lg hover:bg-surface-bright">Logout</a>
<a href="login.jsp" class="bg-primary text-on-primary font-body-lg text-body-lg px-6 py-2 rounded-lg font-medium hover:bg-primary-container transition-colors duration-300 box-glow-primary scale-95 duration-200 active:opacity-80">Book Now</a>
</div>
<button class="md:hidden text-on-surface p-2">
<span class="material-symbols-outlined">menu</span>
</button>
</header>
<main class="flex-grow pt-24 md:pt-32">
<!-- Hero Section -->
<section class="relative w-full h-[70vh] min-h-[600px] flex items-center justify-center overflow-hidden px-container-margin">
<div class="absolute inset-0 z-0">
<img alt="Hero Car" class="w-full h-full object-cover object-center opacity-70" src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1600 900'%3E%3Cdefs%3E%3ClinearGradient id='g' x1='0' y1='0' x2='0' y2='1'%3E%3Cstop offset='0%25' stop-color='%230b1220'/%3E%3Cstop offset='55%25' stop-color='%2313171f'/%3E%3Cstop offset='100%25' stop-color='%23060810'/%3E%3C/linearGradient%3E%3CradialGradient id='r' cx='50%25' cy='45%25' r='60%25'%3E%3Cstop offset='0%25' stop-color='%23adc6ff' stop-opacity='0.18'/%3E%3Cstop offset='55%25' stop-color='%2313171f' stop-opacity='0.06'/%3E%3Cstop offset='100%25' stop-color='%23060810' stop-opacity='0'/%3E%3C/radialGradient%3E%3C/defs%3E%3Crect width='1600' height='900' fill='url(%23g)'/%3E%3Crect width='1600' height='900' fill='url(%23r)'/%3E%3Cpath d='M260 610 C340 530, 470 500, 620 500 H920 C1080 500, 1210 540, 1320 610 L1385 638 C1415 650, 1435 680, 1435 714 V742 H165 C165 694, 181 656, 215 638 Z' fill='%23171d28'/%3E%3Cpath d='M520 505 L605 430 C650 390, 705 372, 770 372 H980 C1050 372, 1115 395, 1160 440 L1230 510' fill='none' stroke='%23263242' stroke-width='28' stroke-linecap='round'/%3E%3Ccircle cx='520' cy='720' r='78' fill='%23050912'/%3E%3Ccircle cx='520' cy='720' r='44' fill='%231b2330'/%3E%3Ccircle cx='1188' cy='720' r='78' fill='%23050912'/%3E%3Ccircle cx='1188' cy='720' r='44' fill='%231b2330'/%3E%3Cpath d='M668 505 H1045' stroke='%23d8e2ff' stroke-opacity='0.18' stroke-width='10' stroke-linecap='round'/%3E%3Cpath d='M420 610 H1260' stroke='%238b90a0' stroke-opacity='0.18' stroke-width='6' stroke-linecap='round'/%3E%3Cpath d='M340 560 L420 520' stroke='%23adc6ff' stroke-opacity='0.25' stroke-width='10' stroke-linecap='round'/%3E%3Cpath d='M1240 520 L1340 560' stroke='%23e9c349' stroke-opacity='0.18' stroke-width='10' stroke-linecap='round'/%3E%3Cpath d='M760 300 C860 270, 980 270, 1080 300' stroke='%23e5e2e3' stroke-opacity='0.09' stroke-width='30' stroke-linecap='round'/%3E%3C/svg%3E"/>
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
<button class="bg-primary text-on-primary font-label-bold text-label-bold px-8 py-4 rounded-lg flex items-center gap-2 hover:bg-primary-container transition-all box-glow-primary">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">calendar_today</span>
                            Đặt lịch ngay
                        </button>
<a class="glass-panel text-on-surface font-label-bold text-label-bold px-8 py-4 rounded-lg hover:bg-surface-bright transition-all border border-outline-variant inline-flex items-center justify-center" href="rewards">
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
<a class="inline-flex items-center gap-xs font-label-bold text-label-bold text-primary hover:text-primary-container transition-colors mt-auto" href="#">
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
<a class="inline-flex items-center gap-xs font-label-bold text-label-bold text-primary hover:text-primary-container transition-colors relative z-10 mt-auto" href="#">
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
<a class="inline-flex items-center gap-xs font-label-bold text-label-bold text-primary hover:text-primary-container transition-colors mt-auto" href="#">
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
<a class="flex flex-col items-center justify-center text-secondary dark:text-secondary bg-surface-variant/50 rounded-xl px-4 py-1 Active: scale-90 transition-transform font-label-bold text-label-bold hover:text-primary dark:hover:text-primary" href="home.jsp">
<span class="material-symbols-outlined mb-1" style="font-variation-settings: 'FILL' 1;">home</span>
            Home
        </a>
<a class="flex flex-col items-center justify-center text-on-surface-variant dark:text-on-surface-variant hover:text-primary dark:hover:text-primary font-label-bold text-label-bold" href="#">
<span class="material-symbols-outlined mb-1">calendar_month</span>
            Booking
        </a>
<a class="flex flex-col items-center justify-center text-on-surface-variant dark:text-on-surface-variant hover:text-primary dark:hover:text-primary font-label-bold text-label-bold" href="#">
<span class="material-symbols-outlined mb-1">star</span>
            Rewards
        </a>
<a class="flex flex-col items-center justify-center text-on-surface-variant dark:text-on-surface-variant hover:text-primary dark:hover:text-primary font-label-bold text-label-bold" href="#">
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
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="#">Privacy Policy</a>
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="#">Terms of Service</a>
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="#">Contact Support</a>
<a class="text-on-surface-variant hover:text-secondary transition-colors" href="#">Careers</a>
</div>
<div class="font-body-sm text-body-sm text-primary dark:text-primary">
            © 2024 Luxe Wash Detailing. All rights reserved.
        </div>
</footer>
</body></html>