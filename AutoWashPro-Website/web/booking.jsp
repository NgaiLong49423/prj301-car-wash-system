<%@page contentType="text/html" pageEncoding="UTF-8"%>
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