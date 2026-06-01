<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="mylib.AppKeys"%>
<%@page import="dto.Vehicle"%>
<%@page import="dto.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Customer profile = (Customer) request.getAttribute(AppKeys.REQ_USER_PROFILE);
    List<Vehicle> cars = (List<Vehicle>) request.getAttribute(AppKeys.REQ_LIST_CARS);
    if (cars == null) {
        cars = new ArrayList<Vehicle>();
    }
    String fullName = (String) request.getAttribute(AppKeys.REQ_PROFILE_FULL_NAME);
    String phone = (String) request.getAttribute(AppKeys.REQ_PROFILE_PHONE);
    String email = (String) request.getAttribute(AppKeys.REQ_PROFILE_EMAIL);
    String tierName = (String) request.getAttribute(AppKeys.REQ_PROFILE_TIER_NAME);
    String joinDate = (String) request.getAttribute(AppKeys.REQ_PROFILE_JOIN_DATE);
    Integer totalPointsObj = (Integer) request.getAttribute(AppKeys.REQ_PROFILE_TOTAL_POINTS);
    int totalPoints = totalPointsObj != null ? totalPointsObj : 0;
    BigDecimal totalSpentMoney = (BigDecimal) request.getAttribute(AppKeys.REQ_PROFILE_TOTAL_SPENT_MONEY);
    if (totalSpentMoney == null) {
        totalSpentMoney = BigDecimal.ZERO;
    }
    String spentDisplay = String.format("%,.0f", totalSpentMoney.doubleValue());
    String avatarInitial = (String) request.getAttribute(AppKeys.REQ_PROFILE_AVATAR_INITIAL);
    if (avatarInitial == null || avatarInitial.trim().isEmpty()) {
        avatarInitial = fullName != null && !fullName.trim().isEmpty() ? fullName.substring(0, 1).toUpperCase() : "L";
    }
    Integer totalCarsObj = (Integer) request.getAttribute(AppKeys.REQ_PROFILE_TOTAL_CARS);
    int totalCars = totalCarsObj != null ? totalCarsObj : cars.size();
%>
<!DOCTYPE html>
<html class="dark" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxe Wash - Hồ Sơ Khách Hàng</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;family=Montserrat:wght@600;700&amp;display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        surface: '#131314',
                        'surface-variant': '#353436',
                        'surface-bright': '#39393a',
                        'surface-container': '#1f1f20',
                        'surface-container-low': '#1b1b1c',
                        'surface-container-lowest': '#0e0e0f',
                        'surface-container-high': '#2a2a2b',
                        primary: '#adc6ff',
                        'primary-container': '#4b8eff',
                        secondary: '#e9c349',
                        'secondary-container': '#af8d11',
                        'on-surface': '#e5e2e3',
                        'on-surface-variant': '#c1c6d7',
                        'on-primary': '#002e69',
                        error: '#ffb4ab',
                        outline: '#8b90a0',
                        'outline-variant': '#414755'
                    },
                    fontFamily: {
                        display: ['Montserrat', 'sans-serif'],
                        body: ['Inter', 'sans-serif']
                    },
                    boxShadow: {
                        glow: '0 0 30px rgba(173, 198, 255, 0.18)'
                    }
                }
            }
        };
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .material-symbols-outlined.filled {
            font-variation-settings: 'FILL' 1;
        }
        body {
            font-family: 'Inter', sans-serif;
            background:
                radial-gradient(circle at top, rgba(173, 198, 255, 0.12), transparent 32%),
                linear-gradient(180deg, #111214 0%, #0e0e0f 100%);
        }
        .glass-panel {
            background: rgba(20, 20, 21, 0.68);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
    </style>
</head>
<body class="bg-surface-container-lowest text-on-surface antialiased min-h-screen">
    <!-- TopAppBar (Web) -->
    <header class="hidden md:flex fixed top-0 w-full z-50 bg-surface/80 backdrop-blur-xl border-b border-white/10 shadow-sm justify-between items-center px-container-margin h-16 max-w-7xl mx-auto left-0 right-0">
        <div class="font-display-lg text-display-lg font-bold text-primary">
            LUXE WASH
        </div>
        <nav class="flex gap-6">
            <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-2 px-2" href="<%= request.getContextPath() %>/home">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;" >home</span>
                Home
            </a>
                <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-2 px-2" href="<%= request.getContextPath() %>/ProfileServlet">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;">person</span>
                Profile
            </a>
            <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-2 px-2" href="<%= request.getContextPath() %>/booking">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;">local_car_wash</span>
                Book Wash
            </a>
            <a class="text-primary font-bold font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-2 px-2" href="<%= request.getContextPath() %>/rewards">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">military_tech</span>
                Membership
            </a>
            <a class="text-on-surface-variant font-label-bold text-label-bold hover:text-primary transition-colors flex items-center gap-2 px-2" href="<%= request.getContextPath() %>/logout">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 0;">logout</span>
                Logout
            </a>
        </nav>
        <div class="flex gap-4 items-center text-primary">
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

    <main class="max-w-7xl mx-auto px-5 py-8 md:py-10 mt-16 grid grid-cols-1 lg:grid-cols-12 gap-6 lg:gap-8">
        <section class="lg:col-span-4 flex flex-col gap-6">
            <div class="glass-panel rounded-3xl p-6 md:p-8 relative overflow-hidden shadow-glow">
                <div class="absolute inset-0 bg-gradient-to-br from-secondary/10 via-transparent to-primary/10 pointer-events-none"></div>
                <div class="relative z-10 text-center">
                    <div class="w-24 h-24 mx-auto rounded-full p-1 bg-gradient-to-b from-secondary to-surface-container-high shadow-lg mb-4">
                        <div class="w-full h-full rounded-full flex items-center justify-center bg-surface text-secondary font-display text-3xl font-bold border border-white/10">
                            <%= avatarInitial %>
                        </div>
                    </div>
                    <h1 class="font-display text-2xl md:text-3xl font-bold text-on-surface mb-1"><%= fullName %></h1>
                    <p class="text-sm text-on-surface-variant mb-4"><%= phone %></p>
                    <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full border border-secondary/30 bg-surface-container text-secondary text-xs font-semibold tracking-[0.2em] uppercase mb-6">
                        <span class="material-symbols-outlined text-[16px] filled">workspace_premium</span>
                        <%= tierName %>
                    </div>

                    <div class="grid grid-cols-2 gap-3 text-left">
                        <div class="rounded-2xl border border-white/10 bg-surface-container p-4">
                            <div class="text-[11px] uppercase tracking-[0.18em] text-on-surface-variant mb-2">Điểm tích lũy</div>
                            <div class="text-2xl font-bold text-primary"><%= totalPoints %></div>
                        </div>
                        <div class="rounded-2xl border border-white/10 bg-surface-container p-4">
                            <div class="text-[11px] uppercase tracking-[0.18em] text-on-surface-variant mb-2">Ngày tham gia</div>
                            <div class="text-base font-semibold text-on-surface"><%= joinDate %></div>
                        </div>
                    </div>

                    <button class="mt-6 w-full inline-flex items-center justify-center gap-2 px-4 py-3 rounded-2xl bg-surface/80 border border-white/10 text-sm font-semibold text-on-surface hover:bg-surface-bright transition-colors">
                        <span class="material-symbols-outlined text-[18px]">edit</span>
                        Sửa hồ sơ
                    </button>
                </div>
            </div>

            <div class="grid grid-cols-2 gap-4">
                <div class="glass-panel rounded-2xl p-4 border border-white/10">
                    <div class="flex items-center gap-2 text-on-surface-variant mb-2">
                        <span class="material-symbols-outlined text-[18px]">account_balance_wallet</span>
                        <span class="text-[11px] uppercase tracking-[0.18em]">Tổng chi tiêu</span>
                    </div>
                    <div class="text-2xl font-bold text-on-surface"><%= spentDisplay %></div>
                    <div class="text-sm text-on-surface-variant">VND</div>
                </div>
                <div class="glass-panel rounded-2xl p-4 border border-white/10">
                    <div class="flex items-center gap-2 text-on-surface-variant mb-2">
                        <span class="material-symbols-outlined text-[18px]">directions_car</span>
                        <span class="text-[11px] uppercase tracking-[0.18em]">Xe trong garage</span>
                    </div>
                    <div class="text-2xl font-bold text-on-surface"><%= totalCars %></div>
                    <div class="text-sm text-on-surface-variant">phương tiện</div>
                </div>
            </div>
        </section>

        <section class="lg:col-span-8 flex flex-col gap-8">
            <div id="vehicles" class="flex items-center justify-between border-b border-outline-variant/30 pb-3">
                <h2 class="flex items-center gap-2 font-display text-xl md:text-2xl font-bold text-on-surface">
                    <span class="material-symbols-outlined text-primary">directions_car</span>
                    Xe của tôi
                </h2>
                <a href="<%= request.getContextPath() %>/addvehicle.jsp" class="inline-flex items-center gap-2 text-sm font-semibold text-primary hover:text-white transition-colors">
                    <span class="material-symbols-outlined text-[18px]">add</span>
                    Thêm xe mới
                </a>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <%
                    if (!cars.isEmpty()) {
                        for (Vehicle car : cars) {
                            String vehicleId = String.valueOf(car.getVehicleId());
                            String plate = car.getLicensePlate() != null ? car.getLicensePlate() : "Chưa có biển số";
                            String brand = car.getBrand() != null ? car.getBrand() : "Xe";
                            String model = car.getModel() != null ? car.getModel() : "đang cập nhật";
                            String color = car.getColor() != null ? car.getColor() : "Chưa rõ";
                %>
                <article class="glass-panel rounded-3xl overflow-hidden border border-white/10 hover:border-primary/30 transition-all duration-300">
                    <div class="h-44 relative bg-gradient-to-br from-surface-container-high via-surface to-surface-container-low">
                        <img alt="<%= brand %> <%= model %>" class="w-full h-full object-cover opacity-90" src="https://images.unsplash.com/photo-1614200179396-2bdb77ebf81b?auto=format&fit=crop&w=1200&q=80">
                        <div class="absolute inset-0 bg-gradient-to-t from-surface via-transparent to-transparent"></div>
                        <div class="absolute top-3 right-3">
                            <a href="<%= request.getContextPath() %>/EditVehicleServlet?vehicleId=<%= vehicleId %>" class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-surface/70 backdrop-blur-md border border-white/10 text-xs font-semibold text-on-surface hover:bg-surface-bright transition-colors">
                                <span class="material-symbols-outlined text-[14px]">edit</span>
                                Sửa thông tin
                            </a>
                        </div>
                        <div class="absolute bottom-4 left-4">
                            <div class="px-3 py-2 rounded-xl bg-surface/80 border border-white/10 text-sm font-bold tracking-[0.18em] text-on-surface shadow-lg">
                                <%= plate %>
                            </div>
                        </div>
                    </div>
                    <div class="p-5">
                        <h3 class="font-display text-lg font-bold text-on-surface"><%= brand %> <%= model %></h3>
                        <div class="flex flex-wrap gap-4 mt-3 text-sm text-on-surface-variant">
                            <span class="inline-flex items-center gap-2">
                                <span class="material-symbols-outlined text-[16px] text-primary">badge</span>
                                Mã xe: <%= vehicleId %>
                            </span>
                            <span class="inline-flex items-center gap-2">
                                <span class="material-symbols-outlined text-[16px] text-secondary">palette</span>
                                <%= color %>
                            </span>
                        </div>
                        <div class="mt-5 flex gap-3">
                            <a href="<%= request.getContextPath() %>/booking" class="flex-1 inline-flex items-center justify-center px-4 py-3 rounded-2xl border border-outline-variant text-sm font-semibold text-on-surface hover:bg-surface-bright transition-colors">Đặt lịch rửa xe này</a>
                        </div>
                    </div>
                </article>
                <%
                        }
                    } else {
                %>
                <div class="md:col-span-2 glass-panel rounded-2xl border border-white/10 p-6 text-center text-on-surface-variant">
                    Bạn chưa có phương tiện nào trong Garage.
                </div>
                <%
                    }
                %>
            </div>

            <section class="glass-panel rounded-3xl overflow-hidden border border-white/10">
                <div class="px-5 py-4 border-b border-outline-variant/30">
                    <h2 class="font-display text-xl font-bold text-on-surface">Thông tin hồ sơ</h2>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 p-5">
                    <div class="rounded-2xl bg-surface-container p-4 border border-white/10">
                        <div class="text-[11px] uppercase tracking-[0.18em] text-on-surface-variant mb-2">Họ và tên</div>
                        <div class="text-base font-semibold text-on-surface"><%= fullName %></div>
                    </div>
                    <div class="rounded-2xl bg-surface-container p-4 border border-white/10">
                        <div class="text-[11px] uppercase tracking-[0.18em] text-on-surface-variant mb-2">Email</div>
                        <div class="text-base font-semibold text-on-surface break-all"><%= email %></div>
                    </div>
                    <div class="rounded-2xl bg-surface-container p-4 border border-white/10">
                        <div class="text-[11px] uppercase tracking-[0.18em] text-on-surface-variant mb-2">Số điện thoại</div>
                        <div class="text-base font-semibold text-on-surface"><%= phone %></div>
                    </div>
                    <div class="rounded-2xl bg-surface-container p-4 border border-white/10">
                        <div class="text-[11px] uppercase tracking-[0.18em] text-on-surface-variant mb-2">Hạng thành viên</div>
                        <div class="text-base font-semibold text-secondary"><%= tierName %></div>
                    </div>
                </div>
            </section>

            <section class="glass-panel rounded-3xl overflow-hidden border border-white/10">
                <div class="px-5 py-4 border-b border-outline-variant/30">
                    <h2 class="font-display text-xl font-bold text-on-surface">Cài đặt tài khoản</h2>
                </div>
                <div class="divide-y divide-white/10">
                    <a href="<%= request.getContextPath() %>/coming-soon" class="flex items-center justify-between px-5 py-4 hover:bg-surface-bright transition-colors group">
                        <div class="flex items-center gap-3 text-on-surface">
                            <span class="material-symbols-outlined text-on-surface-variant group-hover:text-primary transition-colors">person</span>
                            <span class="font-medium">Thông tin cá nhân</span>
                        </div>
                        <span class="material-symbols-outlined text-on-surface-variant group-hover:text-primary transition-colors">chevron_right</span>
                    </a>
                    <a href="<%= request.getContextPath() %>/coming-soon" class="flex items-center justify-between px-5 py-4 hover:bg-surface-bright transition-colors group">
                        <div class="flex items-center gap-3 text-on-surface">
                            <span class="material-symbols-outlined text-on-surface-variant group-hover:text-primary transition-colors">history</span>
                            <span class="font-medium">Lịch sử dịch vụ</span>
                        </div>
                        <span class="material-symbols-outlined text-on-surface-variant group-hover:text-primary transition-colors">chevron_right</span>
                    </a>
                    
                </div>
            </section>
        </section>
    </main>
</body>
</html>