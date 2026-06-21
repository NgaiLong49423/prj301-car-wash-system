<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.BookingDTO"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html class="dark" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Luxe Wash - Lịch Sử Đã Rửa Xe</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "surface": "#131314",
                        "surface-container": "#1f1f20",
                        "surface-container-high": "#2a2a2c",
                        "on-surface": "#e5e2e3",
                        "on-surface-variant": "#c9c5c6",
                        "primary": "#6cdb9e"
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-surface text-on-surface font-['Inter'] antialiased p-6 md:p-12">
    <div class="max-w-6xl mx-auto">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-8">
            <div>
                <h1 class="text-2xl md:text-3xl font-bold font-['Montserrat'] text-primary flex items-center gap-2">
                    <span class="material-symbols-outlined text-3xl">task_alt</span> Lịch Sử Đã Rửa Xe
                </h1>
                <p class="text-sm text-on-surface-variant mt-1">Danh sách các lượt đặt lịch đã hoàn thành quy trình chăm sóc xe tại trung tâm</p>
            </div>
            <a href="UserBookingHistoryServlet?view=all" class="inline-flex items-center gap-2 bg-zinc-800 hover:bg-zinc-700 text-on-surface font-semibold text-sm px-5 py-2.5 rounded-xl transition-all border border-zinc-700 active:scale-95">
                <span class="material-symbols-outlined text-lg">arrow_back</span> Quay Lại Lịch Sử Đặt Lịch
            </a>
        </div>

        <div class="bg-surface-container rounded-2xl border border-zinc-800 overflow-hidden shadow-xl">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-surface-container-high border-b border-zinc-800 text-sm font-semibold text-on-surface">
                            <th class="p-4 text-center">ID</th>
                            <th class="p-4">Ngày đặt</th>
                            <th class="p-4">Giờ đặt</th>
                            <th class="p-4 text-center">Vehicle ID</th>
                            <th class="p-4 text-center">Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-zinc-800 text-sm text-on-surface-variant">
                        <%
                            List<BookingDTO> list = (List<BookingDTO>) request.getAttribute("WASHING_HISTORY");
                            if (list != null && !list.isEmpty()) {
                                for (BookingDTO booking : list) {
                        %>
                        <tr class="hover:bg-zinc-900/50 transition-colors">
                            <td class="p-4 text-center font-mono font-bold text-emerald-400">#<%= booking.getBookingId() %></td>
                            <td class="p-4 font-medium text-on-surface"><%= booking.getBookingDate() %></td>
                            <td class="p-4"><%= booking.getBookingTime() %></td>
                            <td class="p-4 text-center">
                                <span class="bg-zinc-800 text-zinc-300 text-xs px-2.5 py-1 rounded-md border border-zinc-700">ID: <%= booking.getVehicleId() %></span>
                            </td>
                            <td class="p-4 text-center">
                                <span class="inline-block text-xs font-bold px-3 py-1 rounded-full border text-uppercase text-emerald-400 bg-emerald-400/10 border-emerald-400/20">
                                    <%= booking.getStatus() %>
                                </span>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5" class="p-8 text-center text-zinc-500 italic">Chưa có phương tiện nào hoàn thành quy trình rửa xe.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>