<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="dto.BookingDTO"%>
<%@page import="dto.MembershipTierDTO"%>
<%@page import="dto.ServiceDTO"%>
<%@page import="dto.Vehicle"%>
<%@page import="mylib.AppKeys"%>
<%
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("VEHICLE_LIST");
    List<ServiceDTO> services = (List<ServiceDTO>) request.getAttribute("SERVICE_LIST");
    List<BookingDTO> recentBookings = (List<BookingDTO>) request.getAttribute("RECENT_BOOKINGS");
    MembershipTierDTO tier = (MembershipTierDTO) request.getAttribute("MEMBER_TIER_DETAIL");
    String error = (String) request.getAttribute(AppKeys.REQ_ERROR);
    NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    String tierName = tier != null && tier.getTierName() != null ? tier.getTierName() : "Member";
    int priorityScore = tier != null ? tier.getPriorityScore() : 10;
%>
<body class="min-h-screen bg-[#111315] text-slate-100">
    <header class="border-b border-white/10 bg-[#171a1d]">
        <div class="mx-auto flex max-w-6xl items-center justify-between px-5 py-4">
            <a href="<%= request.getContextPath() %>/MainController?action=Dashboard" class="text-xl font-bold text-blue-200">LUXE WASH</a>
            <nav class="flex items-center gap-4 text-sm text-slate-300">
                <a class="hover:text-white" href="<%= request.getContextPath() %>/MainController?action=Dashboard">Home</a>
                <a class="text-blue-200" href="<%= request.getContextPath() %>/MainController?action=Booking">Booking</a>
                <a class="hover:text-white" href="<%= request.getContextPath() %>/MainController?action=Rewards">Membership</a>
                <a class="hover:text-white" href="<%= request.getContextPath() %>/MainController?action=Logout">Logout</a>
            </nav>
        </div>
    </header>

    <main class="mx-auto grid max-w-6xl gap-6 px-5 py-8 lg:grid-cols-[1.3fr_0.7fr]">
        <section class="rounded-lg border border-white/10 bg-[#1a1d21] p-6">
            <div class="mb-6 flex flex-wrap items-start justify-between gap-4">
                <div>
                    <p class="text-sm uppercase tracking-wide text-blue-200">Priority Booking</p>
                    <h1 class="mt-1 text-3xl font-bold">Đặt lịch rửa xe ưu tiên</h1>
                    <p class="mt-2 text-sm text-slate-400">Hệ thống tự xếp lịch theo hạng thành viên và thời gian đặt.</p>
                </div>
                <div class="rounded-lg border border-blue-300/30 bg-blue-300/10 px-4 py-3">
                    <div class="text-xs uppercase text-blue-200">Hạng hiện tại</div>
                    <div class="mt-1 text-xl font-bold"><%= tierName %></div>
                    <div class="text-sm text-slate-300">Priority score: <%= priorityScore %></div>
                </div>
            </div>

            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="mb-5 rounded-lg border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-100">
                    <%= error %>
                </div>
            <% } %>

            <% if (vehicles == null || vehicles.isEmpty()) { %>
                <div class="rounded-lg border border-yellow-300/30 bg-yellow-300/10 p-4 text-yellow-100">
                    Bạn cần thêm xe trước khi đặt lịch.
                    <a class="font-semibold underline" href="<%= request.getContextPath() %>/MainController?action=AddVehiclePage">Thêm xe ngay</a>
                </div>
            <% } else { %>
                <form class="space-y-5" action="<%= request.getContextPath() %>/booking" method="post">
                    <div>
                        <label class="mb-2 block text-sm font-semibold text-slate-200">Chọn xe</label>
                        <select name="vehicleId" required class="w-full rounded-lg border-white/10 bg-[#111315] text-slate-100">
                            <% for (Vehicle vehicle : vehicles) { %>
                                <option value="<%= vehicle.getVehicleId() %>">
                                    <%= vehicle.getLicensePlate() %> - <%= vehicle.getBrand() %> <%= vehicle.getModel() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label class="mb-2 block text-sm font-semibold text-slate-200">Chọn dịch vụ</label>
                        <div class="grid gap-3 md:grid-cols-2">
                            <% if (services != null) {
                                for (ServiceDTO service : services) { %>
                                <label class="flex cursor-pointer items-start gap-3 rounded-lg border border-white/10 bg-[#111315] p-4 hover:border-blue-300/50">
                                    <input class="mt-1 rounded border-white/20 bg-[#171a1d]" type="checkbox" name="serviceIds" value="<%= service.getServiceId() %>">
                                    <span>
                                        <span class="block font-semibold"><%= service.getServiceName() %></span>
                                        <span class="block text-sm text-slate-400"><%= service.getDuration() %> phút · <%= money.format(service.getPrice()) %></span>
                                    </span>
                                </label>
                            <% } } %>
                        </div>
                    </div>

                    <div class="grid gap-4 md:grid-cols-2">
                        <div>
                            <label class="mb-2 block text-sm font-semibold text-slate-200">Ngày đặt</label>
                            <input type="date" name="bookingDate" min="<%= LocalDate.now() %>" required class="w-full rounded-lg border-white/10 bg-[#111315] text-slate-100">
                        </div>
                        <div>
                            <label class="mb-2 block text-sm font-semibold text-slate-200">Khung giờ</label>
                            <select name="bookingTime" required class="w-full rounded-lg border-white/10 bg-[#111315] text-slate-100">
                                <option value="08:00">08:00</option>
                                <option value="08:30">08:30</option>
                                <option value="09:00">09:00</option>
                                <option value="09:30">09:30</option>
                                <option value="10:00">10:00</option>
                                <option value="10:30">10:30</option>
                                <option value="13:30">13:30</option>
                                <option value="14:00">14:00</option>
                                <option value="14:30">14:30</option>
                                <option value="15:00">15:00</option>
                                <option value="15:30">15:30</option>
                                <option value="16:00">16:00</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="inline-flex items-center gap-2 rounded-lg bg-blue-200 px-5 py-3 font-bold text-slate-950 hover:bg-blue-100">
                        <span class="material-symbols-outlined">calendar_add_on</span>
                        Đặt lịch ưu tiên
                    </button>
                </form>
            <% } %>
        </section>

        <aside class="space-y-6">
            <section class="rounded-lg border border-white/10 bg-[#1a1d21] p-5">
                <h2 class="text-lg font-bold">Cách hệ thống ưu tiên</h2>
                <div class="mt-4 space-y-3 text-sm text-slate-300">
                    <div class="flex gap-3"><span class="material-symbols-outlined text-blue-200">workspace_premium</span> Hạng cao có điểm ưu tiên cao hơn.</div>
                    <div class="flex gap-3"><span class="material-symbols-outlined text-blue-200">schedule</span> Cùng hạng thì ai đặt trước được xếp trước.</div>
                    <div class="flex gap-3"><span class="material-symbols-outlined text-blue-200">verified</span> Platinum chỉ ưu tiên hàng chờ, không đẩy lịch đã xác nhận.</div>
                </div>
            </section>

            <section class="rounded-lg border border-white/10 bg-[#1a1d21] p-5">
                <h2 class="text-lg font-bold">Lịch gần đây</h2>
                <div class="mt-4 space-y-3">
                    <% if (recentBookings == null || recentBookings.isEmpty()) { %>
                        <p class="text-sm text-slate-400">Bạn chưa có lịch đặt nào.</p>
                    <% } else {
                        for (BookingDTO booking : recentBookings) { %>
                            <div class="rounded-lg border border-white/10 bg-[#111315] p-3 text-sm">
                                <div class="flex items-center justify-between gap-3">
                                    <span class="font-semibold"><%= booking.getBookingDate() %> · <%= booking.getBookingTime() %></span>
                                    <span class="rounded-full bg-blue-300/10 px-2 py-1 text-xs text-blue-100"><%= booking.getStatus() %></span>
                                </div>
                                <div class="mt-1 text-slate-400">Xe: <%= booking.getVehiclePlate() %></div>
                                <% if (booking.getQueuePosition() != null) { %>
                                    <div class="mt-1 text-yellow-100">Vị trí chờ: #<%= booking.getQueuePosition() %></div>
                                <% } %>
                            </div>
                    <% } } %>
                </div>
            </section>
        </aside>
    </main>
</body>
</html>
<!DOCTYPE html>
<html class="dark" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Create Booking - Luxe Wash</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <script>
        // Hệ màu chuẩn Luxe Wash của dự án
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        background: "#131314",
                        surface: "#1f1f20",
                        "on-surface": "#e5e2e3",
                        "on-surface-variant": "#c1c6d7",
                        primary: "#adc6ff",
                        "on-primary": "#002e69",
                        "primary-container": "#4b8eff",
                        "error-container": "#93000a",
                        "on-error-container": "#ffdad6",
                        "outline-variant": "#414755",
                    },
                    fontFamily: {
                        "display-lg": ["Montserrat"],
                        "label-bold": ["Inter"],
                        "body-lg": ["Inter"]
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
        /* Style cho input và select ở Dark mode */
        input[type="date"], input[type="time"], select {
            color-scheme: dark;
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-lg antialiased min-h-screen flex items-center justify-center p-4">

    <div class="glass-panel w-full max-w-lg rounded-2xl p-8 shadow-2xl relative overflow-hidden">
        <div class="absolute top-0 right-0 w-64 h-64 bg-primary/10 blur-3xl rounded-full translate-x-1/3 -translate-y-1/3 pointer-events-none"></div>

        <div class="text-center mb-8 relative z-10">
            <h1 class="font-display-lg text-3xl font-bold text-primary mb-2 flex items-center justify-center gap-2">
                <span class="material-symbols-outlined text-4xl">calendar_month</span>
                ĐẶT LỊCH RỬA XE
            </h1>
            <p class="text-on-surface-variant text-sm">Trải nghiệm chăm sóc xe đẳng cấp</p>
        </div>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="bg-error-container/20 border border-error-container text-on-error-container px-4 py-3 rounded-lg mb-6 text-center font-label-bold flex items-center justify-center gap-2 relative z-10">
                <span class="material-symbols-outlined">error</span>
                <%= error %>
            </div>
        <%  } %>

        <%
            String success = (String) request.getAttribute("success");
            if (success != null) {
        %>
            <div class="bg-green-900/30 border border-green-500/50 text-green-300 px-4 py-3 rounded-lg mb-6 text-center font-label-bold flex items-center justify-center gap-2 relative z-10">
                <span class="material-symbols-outlined">check_circle</span>
                <%= success %>
            </div>
        <%  } %>

        <form action="CreateBookingServlet" method="POST" class="space-y-6 relative z-10">
            
            <div>
                <label class="block text-sm font-label-bold text-on-surface-variant mb-2" for="vehicle">1. Chọn xe của bạn:</label>
                <div class="relative">
                    <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant">directions_car</span>
                    <select id="vehicle" name="vehicleId" required class="w-full bg-surface border border-outline-variant text-on-surface rounded-lg focus:ring-primary focus:border-primary block pl-10 p-3 outline-none transition-colors appearance-none">
                        <option value="">-- Vui lòng chọn xe --</option>
                        <option value="1">61B1-123.45 (Honda SH)</option>
                        <option value="2">29A1-234.56 (Toyota Vios)</option>
                    </select>
                </div>
            </div>

            <div>
                <label class="block text-sm font-label-bold text-on-surface-variant mb-2" for="service">2. Chọn dịch vụ:</label>
                <div class="relative">
                    <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant">local_car_wash</span>
                    <select id="service" name="serviceId" required class="w-full bg-surface border border-outline-variant text-on-surface rounded-lg focus:ring-primary focus:border-primary block pl-10 p-3 outline-none transition-colors appearance-none">
                        <option value="">-- Vui lòng chọn dịch vụ --</option>
                        <option value="1">Rửa xe cơ bản - 100.000đ</option>
                        <option value="2">Phủ Ceramic - 1.500.000đ</option>
                    </select>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-label-bold text-on-surface-variant mb-2" for="bookingDate">3. Chọn ngày đến:</label>
                    <input type="date" id="bookingDate" name="bookingDate" required class="w-full bg-surface border border-outline-variant text-on-surface rounded-lg focus:ring-primary focus:border-primary block p-3 outline-none transition-colors">
                </div>

                <div>
                    <label class="block text-sm font-label-bold text-on-surface-variant mb-2" for="bookingTime">4. Chọn khung giờ:</label>
                    <input type="time" id="bookingTime" name="bookingTime" required class="w-full bg-surface border border-outline-variant text-on-surface rounded-lg focus:ring-primary focus:border-primary block p-3 outline-none transition-colors">
                </div>
            </div>

            <button type="submit" class="w-full bg-primary text-on-primary font-bold py-4 rounded-lg hover:bg-primary-container transition-all flex items-center justify-center gap-2 mt-4 shadow-lg shadow-primary/20">
                <span class="material-symbols-outlined">task_alt</span>
                XÁC NHẬN ĐẶT LỊCH
            </button>
        </form>
        
        <div class="mt-6 text-center relative z-10">
            <a href="javascript:history.back()" class="text-on-surface-variant hover:text-primary transition-colors text-sm font-label-bold flex items-center justify-center gap-1 inline-flex">
                <span class="material-symbols-outlined text-sm">arrow_back</span>
                Quay lại
            </a>
        </div>
    </div>

</body>
</html>
