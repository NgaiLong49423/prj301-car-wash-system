<%@page import="java.math.BigDecimal"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="dto.User"%>
<%@page import="mylib.AppKeys"%>
<%@page import="dto.Vehicle"%>
<%@page import="dto.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User account = (User) session.getAttribute(AppKeys.SESSION_ACCOUNT);
    if (account == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Customer profile = (Customer) request.getAttribute("USER_PROFILE");
    List<Vehicle> cars = (List<Vehicle>) request.getAttribute("LIST_CARS");
    if (cars == null) {
        cars = new ArrayList<Vehicle>();
    }
        String requestPhone = (String) request.getAttribute("USER_PHONE");

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    String fullName = profile != null && profile.getFullName() != null && !profile.getFullName().trim().isEmpty()
            ? profile.getFullName()
            : (account.getFullName() != null && !account.getFullName().trim().isEmpty() ? account.getFullName() : "Chưa cập nhật tên");
        String phone = requestPhone != null && !requestPhone.trim().isEmpty()
            ? requestPhone
            : (profile != null && profile.getPhone() != null && !profile.getPhone().trim().isEmpty()
                ? profile.getPhone()
                : (account.getPhone() != null && !account.getPhone().trim().isEmpty() ? account.getPhone() : "Chưa có SĐT"));
    String email = profile != null && profile.getEmail() != null && !profile.getEmail().trim().isEmpty()
            ? profile.getEmail()
            : (account.getEmail() != null ? account.getEmail() : "Chưa có email");
    String tierName = profile != null && profile.getTierName() != null && !profile.getTierName().trim().isEmpty()
            ? profile.getTierName()
            : "Thành viên mới";
    String joinDate = profile != null && profile.getJoinDate() != null ? dateFormat.format(profile.getJoinDate()) : "Chưa có";
    int totalPoints = profile != null ? profile.getTotalPoints() : account.getTotalPoints();
    BigDecimal totalSpentMoney = account.getTotalSpentMoney() != null ? account.getTotalSpentMoney() : BigDecimal.ZERO;
    String spentDisplay = String.format("%,.0f", totalSpentMoney.doubleValue());
    String avatarInitial = fullName != null && !fullName.trim().isEmpty() ? fullName.substring(0, 1).toUpperCase() : "L";
    int totalCars = cars.size();
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
    <header class="sticky top-0 z-40 border-b border-white/10 glass-panel">
        <div class="max-w-7xl mx-auto px-5 py-4 flex items-center justify-between">
            <a href="<%= request.getContextPath() %>/dashboard.jsp" class="font-display text-2xl font-bold text-primary tracking-tight">Luxe Wash</a>
            <nav class="hidden md:flex items-center gap-6 text-sm text-on-surface-variant">
                <a href="<%= request.getContextPath() %>/dashboard.jsp" class="hover:text-primary transition-colors" href="<%= request.getContextPath() %>/dashboard.jsp">Home</a>
                <a href="<%= request.getContextPath() %>/ProfileServlet" class="text-primary border-b border-primary pb-1">Profile</a>
                <a href="#vehicles" class="hover:text-primary transition-colors">Book Wash</a>
                <a href="rewards" class="hover:text-primary transition-colors">Membership</a>
                <a href="LogoutServlet" class="text-error hover:text-red-200 transition-colors">Đăng xuất</a>
            </nav>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-5 py-8 md:py-10 grid grid-cols-1 lg:grid-cols-12 gap-6 lg:gap-8">
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
                <a href="#" class="inline-flex items-center gap-2 text-sm font-semibold text-primary hover:text-white transition-colors">
                    <span class="material-symbols-outlined text-[18px]">add</span>
                    Thêm xe mới
                </a>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <%
                    if (cars != null && !cars.isEmpty()) {
                        for (Vehicle car : cars) {
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
                            <button class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-surface/70 backdrop-blur-md border border-white/10 text-xs font-semibold text-on-surface hover:bg-surface-bright transition-colors">
                                <span class="material-symbols-outlined text-[14px]">edit</span>
                                Sửa thông tin
                            </button>
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
                                <span class="material-symbols-outlined text-[16px] text-secondary">palette</span>
                                <%= color %>
                            </span>
                        </div>
                        <div class="mt-5 flex gap-3">
                            <a href="#" class="flex-1 inline-flex items-center justify-center px-4 py-3 rounded-2xl border border-outline-variant text-sm font-semibold text-on-surface hover:bg-surface-bright transition-colors">Đặt lịch rửa xe này</a>
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
                    <a href="#" class="flex items-center justify-between px-5 py-4 hover:bg-surface-bright transition-colors group">
                        <div class="flex items-center gap-3 text-on-surface">
                            <span class="material-symbols-outlined text-on-surface-variant group-hover:text-primary transition-colors">person</span>
                            <span class="font-medium">Thông tin cá nhân</span>
                        </div>
                        <span class="material-symbols-outlined text-on-surface-variant group-hover:text-primary transition-colors">chevron_right</span>
                    </a>
                    <a href="#" class="flex items-center justify-between px-5 py-4 hover:bg-surface-bright transition-colors group">
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