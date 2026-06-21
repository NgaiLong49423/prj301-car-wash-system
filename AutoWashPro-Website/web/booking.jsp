<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.Vehicle"%>
<!DOCTYPE html>
<html class="dark" lang="vi">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Create Booking - Luxe Wash</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#adc6ff",
                        "on-primary": "#002e69",
                        "primary-container": "#4b8eff",
                        "secondary": "#e9c349",
                        "on-secondary": "#3c2f00",
                        "background": "#131314",
                        "on-background": "#e5e2e3",
                        "surface": "#131314",
                        "on-surface": "#e5e2e3",
                        "surface-variant": "#353436",
                        "on-surface-variant": "#c1c6d7",
                        "outline-variant": "#414755",
                        "surface-container": "#1f1f20",
                        "surface-container-high": "#2a2a2b",
                        "surface-container-low": "#1b1b1c",
                        "surface-bright": "#39393a",
                        "error-container": "#93000a",
                        "on-error-container": "#ffdad6",
                    },
                    fontFamily: {
                        "display": ["Montserrat", "sans-serif"],
                        "body": ["Inter", "sans-serif"]
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        .glass { background: rgba(31, 31, 32, 0.8); backdrop-filter: blur(12px); border: 1px solid rgba(255, 255, 255, 0.1); }
        .custom-scrollbar::-webkit-scrollbar { height: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #414755; border-radius: 10px; }
        input[type="date"] { color-scheme: dark; }
    </style>
</head>

<body class="bg-background text-on-background font-body">
    <nav class="sticky top-0 z-50 glass px-6 py-4 flex items-center justify-between border-b border-outline-variant">
        <div class="max-w-7xl mx-auto w-full flex items-center justify-between">
            <div class="flex items-center gap-12">
                <span class="text-primary font-display font-bold text-lg tracking-wider uppercase">LUXE WASH</span>
                <div class="hidden md:flex items-center gap-8">
                    <a class="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors" href="MainController?action=Home">
                        <span class="material-symbols-outlined text-[20px]">home</span><span class="text-sm font-medium">Home</span>
                    </a>
                    <a class="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors" href="MainController?action=Profile">
                        <span class="material-symbols-outlined text-[20px]">person</span><span class="text-sm font-medium">Profile</span>
                    </a>
                    <a class="flex items-center gap-2 text-primary" href="CreateBookingServlet">
                        <span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">local_car_wash</span><span class="text-sm font-bold">Book Wash</span>
                    </a>
                    <a class="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors" href="MainController?action=Rewards">
                        <span class="material-symbols-outlined text-[20px]">military_tech</span><span class="text-sm font-medium">Membership</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-2xl mx-auto mt-6 px-5 relative z-10">
        <% String error = (String) request.getAttribute("error"); if (error != null) { %>
            <div class="bg-error-container/20 border border-error-container text-on-error-container px-4 py-3 rounded-lg text-center font-bold flex items-center justify-center gap-2">
                <span class="material-symbols-outlined">error</span><%= error %>
            </div>
        <% } %>
        <% String success = (String) request.getAttribute("success"); if (success != null) { %>
            <div class="bg-green-900/30 border border-green-500/50 text-green-300 px-4 py-3 rounded-lg text-center font-bold flex items-center justify-center gap-2">
                <span class="material-symbols-outlined">check_circle</span><%= success %>
            </div>
        <% } %>
    </div>

    <form action="CreateBookingServlet" method="POST" class="max-w-2xl mx-auto p-5 space-y-8 relative z-10">
        
        <section class="space-y-4">
            <div class="flex items-center justify-between">
                <h2 class="text-2xl font-bold font-display">1. Chọn xe của bạn</h2>
            </div>
            <div class="flex gap-4 overflow-x-auto pb-2 custom-scrollbar">
                <%-- Sử dụng Java thuần (Scriptlet) --%>
                <%
                    List<Vehicle> listVehicles = (List<Vehicle>) request.getAttribute("listVehicles");
                    if (listVehicles == null) {
                        listVehicles = (List<Vehicle>) request.getAttribute("VEHICLE_LIST");
                    }
                    String selectedVehicleId = (String) request.getAttribute("selectedVehicleId");
                    if (selectedVehicleId == null) {
                        selectedVehicleId = request.getParameter("vehicleId");
                    }
                    if (listVehicles != null && !listVehicles.isEmpty()) {
                        for (Vehicle v : listVehicles) {
                            String isChecked = (selectedVehicleId != null && selectedVehicleId.equals(String.valueOf(v.getVehicleId()))) ? "checked" : "";
                %>
                    <label class="shrink-0 w-64 p-4 rounded-xl border border-outline-variant bg-surface-container hover:border-primary transition-all cursor-pointer has-[:checked]:border-2 has-[:checked]:border-primary has-[:checked]:bg-primary/10 relative">
                        <input type="radio" name="vehicleId" value="<%= v.getVehicleId() %>" class="hidden peer" required <%= isChecked %> />
                        <div class="absolute top-3 right-3 text-primary opacity-0 peer-checked:opacity-100 transition-opacity">
                            <span class="material-symbols-outlined" style='font-variation-settings: "FILL" 1;'>check_circle</span>
                        </div>
                        <div class="text-label-bold text-on-surface-variant mb-1 peer-checked:text-primary">Xe của bạn</div>
                        <div class="font-bold text-lg font-display text-on-surface"><%= v.getBrand() %> <%= v.getModel() %></div>
                        <div class="text-on-surface-variant text-sm">Biển số: <%= v.getLicensePlate() %></div>
                    </label>
                <%
                        }
                    } else {
                %>
                    <div class="w-full p-4 rounded-xl border border-outline-variant bg-surface-container text-on-surface-variant">
                        Bạn chưa có xe nào. Vui lòng vào Profile để thêm xe trước khi đặt lịch.
                    </div>
                <%
                    }
                %>
            </div>
        </section>

        <section class="space-y-4">
            <h2 class="text-2xl font-bold font-display">2. Chọn gói dịch vụ</h2>
            <div class="grid grid-cols-1 gap-3">
                <label class="relative flex items-center p-4 rounded-xl border border-outline-variant bg-surface-container-low cursor-pointer hover:bg-surface-container transition-colors has-[:checked]:border-primary has-[:checked]:bg-primary/5">
                    <input type="radio" name="serviceId" value="1" class="hidden peer" required />
                    <div class="flex-1">
                        <div class="flex justify-between items-center mb-1">
                            <span class="font-bold font-display text-lg">Rửa xe cơ bản</span>
                            <span class="text-primary font-bold">100.000đ</span>
                        </div>
                        <p class="text-sm text-on-surface-variant">Rửa ngoài, hút bụi thảm, lau kính cơ bản. (30 phút)</p>
                    </div>
                    <div class="ml-4 opacity-0 peer-checked:opacity-100 text-primary transition-opacity">
                        <span class="material-symbols-outlined" style='font-variation-settings: "FILL" 1;'>task_alt</span>
                    </div>
                </label>
                
                <label class="relative flex items-center p-4 rounded-xl border border-outline-variant bg-surface-container-low cursor-pointer hover:bg-surface-container transition-colors has-[:checked]:border-primary has-[:checked]:bg-primary/5">
                    <input type="radio" name="serviceId" value="2" class="hidden peer" required />
                    <div class="flex-1">
                        <div class="flex justify-between items-center mb-1">
                            <div class="flex items-center gap-2">
                                <span class="font-bold font-display text-lg">Phủ Ceramic</span>
                                <span class="bg-secondary text-on-secondary text-[10px] px-2 py-0.5 rounded-full font-bold uppercase">Cao cấp</span>
                            </div>
                            <span class="text-primary font-bold">1.500.000đ</span>
                        </div>
                        <p class="text-sm text-on-surface-variant">Phủ lớp bảo vệ sơn xe toàn diện, chống nước và bụi bẩn. (120 phút)</p>
                    </div>
                    <div class="ml-4 opacity-0 peer-checked:opacity-100 text-primary transition-opacity">
                        <span class="material-symbols-outlined" style='font-variation-settings: "FILL" 1;'>task_alt</span>
                    </div>
                </label>
            </div>
        </section>

        <section class="space-y-4">
            <h2 class="text-2xl font-bold font-display">3. Thời gian đặt lịch</h2>
            
            <div class="bg-surface-container-low p-4 rounded-xl border border-outline-variant">
                <label class="block text-sm font-semibold text-on-surface-variant mb-2">Ngày bạn muốn đến:</label>
                <input type="date" name="bookingDate" required class="w-full bg-surface-container-high border border-outline-variant text-on-surface rounded-lg focus:ring-primary focus:border-primary block p-3 outline-none transition-colors" />
            </div>

            <div class="pt-2">
                <h3 class="text-sm font-semibold text-on-surface-variant mb-3">Chọn ca phục vụ:</h3>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <label class="cursor-pointer">
                        <input type="radio" name="bookingTime" value="08:00" class="peer hidden" required>
                        <div class="p-4 rounded-xl border border-outline-variant bg-surface-container-high hover:bg-surface-bright transition-colors text-center peer-checked:bg-primary peer-checked:text-on-primary peer-checked:border-primary peer-checked:shadow-lg peer-checked:shadow-primary/20">
                            <div class="text-2xl mb-2">☀️</div>
                            <div class="font-bold text-lg">Buổi Sáng</div>
                            <div class="text-sm opacity-80 mt-1">[ 08:00 - 12:00 ]</div>
                        </div>
                    </label>

                    <label class="cursor-pointer">
                        <input type="radio" name="bookingTime" value="13:00" class="peer hidden" required>
                        <div class="p-4 rounded-xl border border-outline-variant bg-surface-container-high hover:bg-surface-bright transition-colors text-center peer-checked:bg-primary peer-checked:text-on-primary peer-checked:border-primary peer-checked:shadow-lg peer-checked:shadow-primary/20">
                            <div class="text-2xl mb-2">🌤️</div>
                            <div class="font-bold text-lg">Buổi Chiều</div>
                            <div class="text-sm opacity-80 mt-1">[ 13:00 - 17:00 ]</div>
                        </div>
                    </label>

                    <label class="cursor-pointer">
                        <input type="radio" name="bookingTime" value="18:00" class="peer hidden" required>
                        <div class="p-4 rounded-xl border border-outline-variant bg-surface-container-high hover:bg-surface-bright transition-colors text-center peer-checked:bg-primary peer-checked:text-on-primary peer-checked:border-primary peer-checked:shadow-lg peer-checked:shadow-primary/20">
                            <div class="text-2xl mb-2">🌙</div>
                            <div class="font-bold text-lg">Buổi Tối</div>
                            <div class="text-sm opacity-80 mt-1">[ 18:00 - 21:00 ]</div>
                        </div>
                    </label>
                </div>
            </div>
        </section>

        <div class="pt-6">
            <button type="submit" class="w-full flex items-center justify-center gap-2 bg-primary text-on-primary py-4 rounded-xl font-bold font-display shadow-xl shadow-primary/30 hover:scale-[1.02] active:scale-[0.98] transition-all uppercase tracking-wider">
                <span class="material-symbols-outlined">event_available</span>
                Xác nhận đặt lịch
            </button>
        </div>
    </form>

    <div class="fixed top-1/4 -right-24 w-64 h-64 bg-primary/10 rounded-full blur-[120px] pointer-events-none"></div>
    <div class="fixed bottom-1/4 -left-24 w-64 h-64 bg-secondary/10 rounded-full blur-[120px] pointer-events-none"></div>
</body>

</html>
