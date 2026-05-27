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

<html class="light" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>AquaSmart - Trang chủ Rửa xe Thông minh</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-surface-variant": "#414755",
                        "on-primary-fixed-variant": "#004493",
                        "surface-dim": "#cfdaf2",
                        "on-secondary-fixed-variant": "#005141",
                        "surface-container-highest": "#d8e3fb",
                        "secondary-fixed-dim": "#41deba",
                        "on-secondary-container": "#00725d",
                        "surface-container-lowest": "#ffffff",
                        "secondary-container": "#65fbd6",
                        "surface": "#f9f9ff",
                        "on-tertiary-fixed-variant": "#444749",
                        "outline": "#717786",
                        "primary-fixed": "#d8e2ff",
                        "surface-container": "#e7eeff",
                        "on-tertiary-container": "#fbfdff",
                        "on-error": "#ffffff",
                        "tertiary": "#595c5e",
                        "tertiary-fixed-dim": "#c4c7c9",
                        "primary-container": "#0070eb",
                        "inverse-surface": "#263143",
                        "outline-variant": "#c1c6d7",
                        "primary": "#0058bc",
                        "on-primary-container": "#fefcff",
                        "surface-container-high": "#dee8ff",
                        "on-secondary-fixed": "#002019",
                        "secondary-fixed": "#65fbd6",
                        "surface-variant": "#d8e3fb",
                        "on-tertiary-fixed": "#191c1e",
                        "secondary": "#006b57",
                        "surface-tint": "#005bc1",
                        "error-container": "#ffdad6",
                        "primary-fixed-dim": "#adc6ff",
                        "on-secondary": "#ffffff",
                        "surface-bright": "#f9f9ff",
                        "on-background": "#111c2d",
                        "inverse-primary": "#adc6ff",
                        "tertiary-fixed": "#e0e3e5",
                        "on-surface": "#111c2d",
                        "on-error-container": "#93000a",
                        "background": "#f9f9ff",
                        "surface-container-low": "#f0f3ff",
                        "on-tertiary": "#ffffff",
                        "inverse-on-surface": "#ecf1ff",
                        "error": "#ba1a1a",
                        "on-primary": "#ffffff",
                        "tertiary-container": "#727577",
                        "on-primary-fixed": "#001a41"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "container-max": "1280px",
                        "base": "8px",
                        "margin-desktop": "40px",
                        "margin-mobile": "16px",
                        "gutter": "24px"
                    },
                    "fontFamily": {
                        "body-lg": ["Inter"],
                        "body-md": ["Inter"],
                        "label-md": ["Inter"],
                        "headline-lg-mobile": ["Inter"],
                        "headline-md": ["Inter"],
                        "headline-xl": ["Inter"],
                        "headline-lg": ["Inter"],
                        "label-sm": ["Inter"]
                    },
                    "fontSize": {
                        "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "label-md": ["14px", {"lineHeight": "20px", "letterSpacing": "0.01em", "fontWeight": "600"}],
                        "headline-lg-mobile": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                        "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                        "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                        "label-sm": ["12px", {"lineHeight": "16px", "letterSpacing": "0.02em", "fontWeight": "500"}]
                    }
                }
            }
        }
    </script>
<style>
        body { font-family: 'Inter', sans-serif; }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .card-shadow { box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.05); }
        .card-hover:hover { box-shadow: 0px 10px 25px rgba(0, 0, 0, 0.08); transform: translateY(-2px); }
        .glass-effect { backdrop-filter: blur(8px); background: rgba(255, 255, 255, 0.8); }
    </style>
</head>
<body class="bg-background text-on-surface">
<!-- Top Navigation Bar -->
<header class="fixed top-0 w-full z-50 bg-surface dark:bg-on-background border-b border-outline-variant dark:border-on-surface-variant shadow-sm">
<div class="flex justify-between items-center h-16 px-margin-desktop w-full max-w-container-max mx-auto">
<div class="flex items-center gap-8">
<span class="font-headline-md text-headline-md text-primary dark:text-primary-fixed-dim font-bold">AquaSmart</span>
<nav class="hidden md:flex gap-6 items-center">
<a class="font-label-md text-label-md text-primary dark:text-primary-fixed-dim border-b-2 border-primary pb-1" href="#">Dashboard</a>
<a class="font-label-md text-label-md text-on-surface-variant dark:text-surface-variant hover:text-primary transition-colors" href="#">Dịch vụ</a>
<a class="font-label-md text-label-md text-on-surface-variant dark:text-surface-variant hover:text-primary transition-colors" href="#">Lịch sử</a>
<a class="font-label-md text-label-md text-on-surface-variant dark:text-surface-variant hover:text-primary transition-colors" href="#">Ưu đãi</a>
</nav>
</div>
<div class="flex items-center gap-4">
<button class="material-symbols-outlined text-on-surface-variant cursor-pointer active:opacity-80 transition-opacity">notifications</button>
<button class="material-symbols-outlined text-on-surface-variant cursor-pointer active:opacity-80 transition-opacity">settings</button>
<img alt="User profile" class="w-10 h-10 rounded-full border-2 border-primary-container object-cover" data-alt="A professional headshot of a friendly Vietnamese male professional in a modern office setting. The lighting is soft and high-key, creating a bright and clean aesthetic. The background is slightly blurred with minimalist architectural details and a hint of vibrant blue, matching a corporate and refreshing brand identity. The subject is smiling confidently at the camera." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDYuN2n3bR_9DHoIWczhzXoigdLsG--o5WAyrg5u2MQ34MkQT6aNt3r9jCxHmc0ojf2ojJ9RQsJSQ1k7wXo4TS9GLth4u7tMcVNe8KmraBj3m-FSGJr-bqZQBX2IDVFMkxM0JahPTd0K_58kZWM3MDcSkKqmOzw3yT_gz_KaGVXZEqQo5DSG62BU1GtsPoogfHGUIlGDV8pXfNV4ioKlOnzLY_k2CqK1r2Cwjzjsn_EVLzrxWY5xaxfw6pcsEJ8lAEnmyJyrkoHDflq"/>
</div>
</div>
</header>
<!-- Side Navigation Bar (Desktop) -->
<aside class="fixed left-0 top-16 h-[calc(100vh-64px)] w-64 bg-surface dark:bg-on-background border-r border-outline-variant dark:border-on-surface-variant py-6 hidden md:flex flex-col gap-2">
<div class="px-6 mb-6">
<p class="font-label-sm text-label-sm text-outline uppercase tracking-widest">Menu Chính</p>
</div>
<a class="text-primary dark:text-primary-fixed-dim border-l-4 border-primary bg-primary-container/10 dark:bg-primary-container/20 font-bold font-label-md text-label-md flex items-center px-6 py-3 gap-3" href="#">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">dashboard</span> Home
        </a>
<a class="text-on-surface-variant dark:text-surface-variant flex items-center px-6 py-3 gap-3 hover:bg-surface-container transition-all font-label-md text-label-md" href="#">
<span class="material-symbols-outlined">history</span> Booking History
        </a>
<a class="text-on-surface-variant dark:text-surface-variant flex items-center px-6 py-3 gap-3 hover:bg-surface-container transition-all font-label-md text-label-md" href="#">
<span class="material-symbols-outlined">local_car_wash</span> Services
        </a>
<a class="text-on-surface-variant dark:text-surface-variant flex items-center px-6 py-3 gap-3 hover:bg-surface-container transition-all font-label-md text-label-md" href="#">
<span class="material-symbols-outlined">sell</span> Promotions
        </a>
<a class="text-on-surface-variant dark:text-surface-variant flex items-center px-6 py-3 gap-3 hover:bg-surface-container transition-all font-label-md text-label-md" href="#">
<span class="material-symbols-outlined">support_agent</span> Support
        </a>
<div class="mt-auto px-6">
<button class="w-full py-3 bg-primary text-on-primary rounded-xl font-label-md text-label-md shadow-md active:translate-x-1 transition-transform duration-200">
                New Booking
            </button>
</div>
</aside>
<!-- Main Content Area -->
<main class="md:ml-64 pt-24 pb-12 px-6 md:px-margin-desktop min-h-screen">
<div class="max-w-container-max mx-auto space-y-10">
<!-- Section 1: Header Welcome -->
<section class="flex flex-col md:flex-row md:items-end justify-between gap-6">
<div class="space-y-2">
<h1 class="font-headline-lg text-headline-lg text-on-background">Chào mừng trở lại, <%= c.getUsername() %></h1>
<p class="font-body-md text-body-md text-on-surface-variant">Hôm nay là một ngày tuyệt vời để làm sạch "xế yêu" của bạn!</p>
</div>
<div class="flex gap-4">
<div class="bg-surface-container-high px-6 py-4 rounded-xl border border-outline-variant flex items-center gap-4">
<div class="w-10 h-10 rounded-full bg-primary-container flex items-center justify-center text-on-primary-container">
<span class="material-symbols-outlined">calendar_today</span>
</div>
<div>
<p class="font-label-sm text-label-sm text-on-surface-variant">Tổng đơn hàng</p>
<p class="font-label-md text-label-md text-on-surface font-bold">24 Lần</p>
</div>
</div>
<div class="bg-surface-container-high px-6 py-4 rounded-xl border border-outline-variant flex items-center gap-4">
<div class="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center text-on-secondary-container">
<span class="material-symbols-outlined">stars</span>
</div>
<div>
<p class="font-label-sm text-label-sm text-on-surface-variant">Điểm tích lũy</p>
<p class="font-label-md text-label-md text-on-surface font-bold">1,250 Pts</p>
</div>
</div>
</div>
</section>
<!-- Section 2: Active Status Card (Bento Style Layout) -->
<section class="grid grid-cols-1 lg:grid-cols-3 gap-gutter">
<div class="lg:col-span-2 relative overflow-hidden bg-primary p-8 rounded-[24px] text-on-primary flex flex-col justify-between min-h-[300px] shadow-lg">
<!-- Background Visual Decor -->
<div class="absolute -right-20 -top-20 w-80 h-80 bg-white/10 rounded-full blur-3xl"></div>
<div class="absolute right-10 bottom-10 opacity-20">
<span class="material-symbols-outlined text-[160px]" style="font-variation-settings: 'FILL' 1;">local_car_wash</span>
</div>
<div class="relative z-10">
<span class="px-3 py-1 bg-white/20 rounded-full font-label-sm text-label-sm backdrop-blur-md mb-4 inline-block">Trạng thái hiện tại</span>
<h2 class="font-headline-lg text-headline-lg mb-2">Xe của bạn đang ở giai đoạn: Sấy khô</h2>
<p class="font-body-md text-body-md text-primary-fixed">Ước tính hoàn thành sau: 5 phút</p>
</div>
<div class="relative z-10 space-y-4">
<div class="flex justify-between font-label-md text-label-md">
<span>Tiến độ tổng thể</span>
<span>80%</span>
</div>
<div class="h-2 w-full bg-white/20 rounded-full overflow-hidden">
<div class="h-full bg-white transition-all duration-1000 ease-out" id="progress-bar" style="width: 80%;"></div>
</div>
<div class="flex gap-2">
<span class="w-2 h-2 rounded-full bg-white"></span>
<span class="w-2 h-2 rounded-full bg-white"></span>
<span class="w-2 h-2 rounded-full bg-white"></span>
<span class="w-2 h-2 rounded-full bg-white/40"></span>
</div>
</div>
</div>
<div class="bg-surface-container-lowest p-8 rounded-[24px] border border-outline-variant card-shadow flex flex-col justify-center items-center text-center space-y-4">
<div class="w-20 h-20 bg-secondary-container rounded-full flex items-center justify-center mb-2">
<span class="material-symbols-outlined text-secondary text-[40px]">qr_code_2</span>
</div>
<h3 class="font-headline-md text-headline-md text-on-surface">Mã Nhận Xe</h3>
<p class="font-body-md text-body-md text-on-surface-variant px-4">Sử dụng mã này tại trạm khi xe hoàn tất để nhận xe nhanh chóng.</p>
<button class="mt-4 font-label-md text-label-md text-primary border border-primary px-6 py-2 rounded-xl hover:bg-primary-container/10 transition-colors">
                        Xem chi tiết mã
                    </button>
</div>
</section>
<!-- Section 3 & 4: Grid Layout for History and Quick Booking -->
<section class="grid grid-cols-1 lg:grid-cols-12 gap-gutter">
<!-- Quick Booking (Left side) -->
<div class="lg:col-span-7 space-y-6">
<div class="flex justify-between items-center">
<h2 class="font-headline-md text-headline-md text-on-background">Dịch vụ Nổi bật</h2>
<a class="font-label-md text-label-md text-primary flex items-center gap-1" href="#">Xem tất cả <span class="material-symbols-outlined text-[18px]">arrow_forward</span></a>
</div>
<div class="grid grid-cols-2 gap-4">
<div class="bg-white p-6 rounded-2xl border border-outline-variant card-hover transition-all cursor-pointer group">
<div class="w-12 h-12 rounded-xl bg-blue-50 text-primary flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
<span class="material-symbols-outlined">waves</span>
</div>
<h3 class="font-label-md text-label-md mb-1">Rửa Cơ Bản</h3>
<p class="text-on-surface-variant text-[13px] mb-4">Làm sạch ngoại thất tiêu chuẩn</p>
<div class="flex justify-between items-center">
<span class="font-bold text-primary">150.000đ</span>
<span class="material-symbols-outlined text-primary opacity-0 group-hover:opacity-100 transition-opacity">add_circle</span>
</div>
</div>
<div class="bg-white p-6 rounded-2xl border border-outline-variant card-hover transition-all cursor-pointer group">
<div class="w-12 h-12 rounded-xl bg-teal-50 text-secondary flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
<span class="material-symbols-outlined">auto_fix_high</span>
</div>
<h3 class="font-label-md text-label-md mb-1">Đánh Bóng Cao Cấp</h3>
<p class="text-on-surface-variant text-[13px] mb-4">Lớp phủ Ceramic bảo vệ sơn</p>
<div class="flex justify-between items-center">
<span class="font-bold text-primary">850.000đ</span>
<span class="material-symbols-outlined text-primary opacity-0 group-hover:opacity-100 transition-opacity">add_circle</span>
</div>
</div>
<div class="bg-white p-6 rounded-2xl border border-outline-variant card-hover transition-all cursor-pointer group">
<div class="w-12 h-12 rounded-xl bg-orange-50 text-orange-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
<span class="material-symbols-outlined">vacuum</span>
</div>
<h3 class="font-label-md text-label-md mb-1">Vệ Sinh Nội Thất</h3>
<p class="text-on-surface-variant text-[13px] mb-4">Hút bụi và diệt khuẩn 99%</p>
<div class="flex justify-between items-center">
<span class="font-bold text-primary">450.000đ</span>
<span class="material-symbols-outlined text-primary opacity-0 group-hover:opacity-100 transition-opacity">add_circle</span>
</div>
</div>
<div class="bg-white p-6 rounded-2xl border border-outline-variant card-hover transition-all cursor-pointer group">
<div class="w-12 h-12 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
<span class="material-symbols-outlined">toys</span>
</div>
<h3 class="font-label-md text-label-md mb-1">Rửa Động Cơ</h3>
<p class="text-on-surface-variant text-[13px] mb-4">Tẩy rửa khoang máy chuyên sâu</p>
<div class="flex justify-between items-center">
<span class="font-bold text-primary">600.000đ</span>
<span class="material-symbols-outlined text-primary opacity-0 group-hover:opacity-100 transition-opacity">add_circle</span>
</div>
</div>
</div>
</div>
<!-- Recent Booking History (Right side) -->
<div class="lg:col-span-5 space-y-6">
<div class="flex justify-between items-center">
<h2 class="font-headline-md text-headline-md text-on-background">Lịch sử Gần đây</h2>
</div>
<div class="space-y-4">
<!-- History Item 1 -->
<div class="flex items-center gap-4 bg-surface-container-low p-4 rounded-2xl border border-outline-variant hover:bg-surface-container transition-colors cursor-pointer">
<div class="w-12 h-12 bg-surface-container-highest rounded-xl flex items-center justify-center">
<span class="material-symbols-outlined text-primary">done_all</span>
</div>
<div class="flex-1">
<div class="flex justify-between">
<h4 class="font-label-md text-label-md text-on-surface">Rửa Cơ Bản</h4>
<span class="text-primary font-bold">150k</span>
</div>
<p class="text-[12px] text-on-surface-variant">15 Th05, 2024 • 09:30 AM</p>
</div>
<span class="px-2 py-1 rounded-full bg-secondary/10 text-secondary text-[10px] font-bold uppercase">Hoàn tất</span>
</div>
<!-- History Item 2 -->
<div class="flex items-center gap-4 bg-surface-container-low p-4 rounded-2xl border border-outline-variant hover:bg-surface-container transition-colors cursor-pointer">
<div class="w-12 h-12 bg-surface-container-highest rounded-xl flex items-center justify-center">
<span class="material-symbols-outlined text-primary">done_all</span>
</div>
<div class="flex-1">
<div class="flex justify-between">
<h4 class="font-label-md text-label-md text-on-surface">Premium Polish</h4>
<span class="text-primary font-bold">850k</span>
</div>
<p class="text-[12px] text-on-surface-variant">10 Th05, 2024 • 14:15 PM</p>
</div>
<span class="px-2 py-1 rounded-full bg-secondary/10 text-secondary text-[10px] font-bold uppercase">Hoàn tất</span>
</div>
<!-- History Item 3 -->
<div class="flex items-center gap-4 bg-surface-container-low p-4 rounded-2xl border border-outline-variant hover:bg-surface-container transition-colors cursor-pointer">
<div class="w-12 h-12 bg-surface-container-highest rounded-xl flex items-center justify-center">
<span class="material-symbols-outlined text-primary">done_all</span>
</div>
<div class="flex-1">
<div class="flex justify-between">
<h4 class="font-label-md text-label-md text-on-surface">Vệ Sinh Nội Thất</h4>
<span class="text-primary font-bold">450k</span>
</div>
<p class="text-[12px] text-on-surface-variant">01 Th05, 2024 • 10:00 AM</p>
</div>
<span class="px-2 py-1 rounded-full bg-secondary/10 text-secondary text-[10px] font-bold uppercase">Hoàn tất</span>
</div>
</div>
<!-- Reward Card -->
<div class="bg-on-background p-6 rounded-[24px] text-on-primary-container relative overflow-hidden mt-8">
<img alt="Background" class="absolute inset-0 w-full h-full object-cover opacity-20" data-alt="A macro shot of soap bubbles and water droplets on a glossy blue car surface. The lighting is bright and energetic, capturing the refreshing essence of a car wash. The image has a modern, clean commercial feel with high-contrast highlights and deep, rich blue tones, reinforcing the brand's premium identity." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAIz-V6nQqQFPSRTKp36Ase4OQl_VrSDsNwW_REslIXaOgkbswHeAmys2yPtJDSQe7Fiea1YGeJdXjzfkOvlr6Kslbs6bbX3jlS2F7cSSx7C_H6IRDAlaFnWwP_HRBGzZ3FJ5flN9Ri-3zT5uOhhAbjlMcbgdVeuHy3SMphsy_BrPnudHFLuO6DVT6n6xKPfFBJbEMfNSIGOh9xnDgfVQTLi8MLCyzxqYRjWKavrA-zQf96Y6z0nqnj0TBnMTW-uWBbl5EckMyd4sB8"/>
<div class="relative z-10">
<h4 class="font-headline-md text-headline-md mb-2">Thẻ Thành Viên Vàng</h4>
<p class="font-body-md text-body-md opacity-80 mb-4">Bạn chỉ còn 2 lần rửa nữa để nhận 1 lần miễn phí!</p>
<div class="flex items-center gap-2">
<div class="flex -space-x-2">
<div class="w-8 h-8 rounded-full bg-primary border-2 border-on-background flex items-center justify-center"><span class="material-symbols-outlined text-[14px]">check</span></div>
<div class="w-8 h-8 rounded-full bg-primary border-2 border-on-background flex items-center justify-center"><span class="material-symbols-outlined text-[14px]">check</span></div>
<div class="w-8 h-8 rounded-full bg-primary border-2 border-on-background flex items-center justify-center"><span class="material-symbols-outlined text-[14px]">check</span></div>
<div class="w-8 h-8 rounded-full bg-white/20 border-2 border-on-background flex items-center justify-center"><span class="material-symbols-outlined text-[14px] text-white/40">lock</span></div>
<div class="w-8 h-8 rounded-full bg-white/20 border-2 border-on-background flex items-center justify-center"><span class="material-symbols-outlined text-[14px] text-white/40">lock</span></div>
</div>
<span class="font-label-sm text-label-sm ml-4">3 / 5 Chặng đường</span>
</div>
</div>
</div>
</div>
</section>
</div>
</main>
<!-- Bottom Nav for Mobile -->
<nav class="md:hidden fixed bottom-0 w-full bg-surface border-t border-outline-variant flex justify-around items-center h-16 px-4 z-50">
<a class="flex flex-col items-center text-primary" href="#">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">dashboard</span>
<span class="text-[10px] font-bold">Home</span>
</a>
<a class="flex flex-col items-center text-on-surface-variant" href="#">
<span class="material-symbols-outlined">local_car_wash</span>
<span class="text-[10px]">Dịch vụ</span>
</a>
<div class="relative -top-6">
<button class="w-14 h-14 bg-primary text-on-primary rounded-full shadow-lg flex items-center justify-center">
<span class="material-symbols-outlined text-[32px]">add</span>
</button>
</div>
<a class="flex flex-col items-center text-on-surface-variant" href="#">
<span class="material-symbols-outlined">history</span>
<span class="text-[10px]">Lịch sử</span>
</a>
<a class="flex flex-col items-center text-on-surface-variant" href="#">
<span class="material-symbols-outlined">person</span>
<span class="text-[10px]">Cá nhân</span>
</a>
</nav>
<script>
        // Micro-interaction for the progress bar
        window.addEventListener('load', () => {
            const bar = document.getElementById('progress-bar');
            bar.style.width = '0%';
            setTimeout(() => {
                bar.style.width = '80%';
            }, 500);
        });

        // Simple hover effect logic for cards if needed for extra interactivity
        const cards = document.querySelectorAll('.card-hover');
        cards.forEach(card => {
            card.addEventListener('mouseenter', () => {
                // Potential JS logic for complex animations
            });
        });
    </script>
</body></html>