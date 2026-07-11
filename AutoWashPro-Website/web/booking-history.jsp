<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.BookingDTO"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html class="dark" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Luxe Wash - Lịch Sử Đặt Lịch</title>
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
                        "primary": "#a8c7fa"
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-surface text-on-surface font-['Inter'] antialiased p-6 md:p-12">
    <div class="max-w-6xl mx-auto">
        
        <div class="mb-6">
            <a href="<%= request.getContextPath() %>/MainController?action=Dashboard" 
               class="inline-flex items-center gap-2 text-zinc-400 hover:text-primary transition-colors group font-medium text-sm bg-zinc-900/50 hover:bg-zinc-800/50 border border-zinc-800 px-4 py-2 rounded-xl backdrop-blur-sm">
                <span class="material-symbols-outlined text-xl group-hover:-translate-x-1 transition-transform">arrow_back</span>
                Quay về Trang chủ
            </a>
        </div>

        <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-8">
            <div>
                <h1 class="text-2xl md:text-3xl font-bold font-['Montserrat'] text-primary flex items-center gap-2">
                    <span class="material-symbols-outlined text-3xl">history</span> Lịch Sử Đặt Lịch
                </h1>
                <p class="text-sm text-on-surface-variant mt-1">Quản lý trạng thái các lượt đặt lịch dịch vụ của bạn</p>
            </div>
            <a href="<%= request.getContextPath() %>/MainController?action=WashingHistory" class="inline-flex items-center gap-2 bg-emerald-600 hover:bg-emerald-700 text-white font-semibold text-sm px-5 py-2.5 rounded-xl transition-all shadow-lg active:scale-95">
                <span class="material-symbols-outlined text-lg">local_car_wash</span> Xem Lịch Sử Rửa Xe
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
                            <th class="p-4 text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-zinc-800 text-sm text-on-surface-variant">
                        <%
                            List<BookingDTO> list = (List<BookingDTO>) request.getAttribute("BOOKING_HISTORY");
                            if (list != null && !list.isEmpty()) {
                                for (BookingDTO booking : list) {
                                    String status = booking.getStatus();
                                    String statusColor = "text-amber-400 bg-amber-400/10 border-amber-400/20";
                                    if("cancel".equalsIgnoreCase(status)) statusColor = "text-rose-400 bg-rose-400/10 border-rose-400/20";
                                    if("Completed".equalsIgnoreCase(status)) statusColor = "text-emerald-400 bg-emerald-400/10 border-emerald-400/20";
                        %>
                        <tr class="hover:bg-zinc-900/50 transition-colors">
                            <td class="p-4 text-center font-mono font-bold text-primary">#<%= booking.getBookingId() %></td>
                            <td class="p-4 font-medium text-on-surface"><%= booking.getBookingDate() %></td>
                            <td class="p-4"><%= booking.getBookingTime() %></td>
                            <td class="p-4 text-center">
                                <span class="bg-zinc-800 text-zinc-300 text-xs px-2.5 py-1 rounded-md border border-zinc-700">ID: <%= booking.getVehicleId() %></span>
                            </td>
                            <td class="p-4 text-center">
                                <span class="inline-block text-xs font-bold px-3 py-1 rounded-full border text-uppercase <%= statusColor %>">
                                    <%= status %>
                                </span>
                            </td>
                            <td class="p-4 text-center">
                                <% if ("pending".equalsIgnoreCase(status)) { %>
                                    <div class="flex items-center justify-center gap-2">
                                        <a href="<%= request.getContextPath() %>/MainController?action=BookingHistory&subAction=cancel&bookingId=<%= booking.getBookingId() %>" 
                                           class="inline-flex items-center gap-1 bg-rose-500/10 hover:bg-rose-500 text-rose-400 hover:text-white border border-rose-500/20 text-xs font-semibold px-3 py-1.5 rounded-lg transition-all"
                                           onclick="return confirm('Bạn có chắc chắn muốn hủy lịch này không?')">
                                            <span class="material-symbols-outlined text-sm">close</span> Cancel
                                        </a>
                                        <a href="<%= request.getContextPath() %>/MainController?action=BookingHistory&subAction=checkin&bookingId=<%= booking.getBookingId() %>" 
                                           class="inline-flex items-center gap-1 bg-emerald-500/10 hover:bg-emerald-500 text-emerald-400 hover:text-white border border-emerald-500/20 text-xs font-semibold px-3 py-1.5 rounded-lg transition-all"
                                           onclick="return confirm('Xác nhận phương tiện này đã đến làm dịch vụ?')">
                                            <span class="material-symbols-outlined text-sm">done</span> Check-in
                                        </a>
                                    </div>
                                <% } else { %>
                                    <span class="text-zinc-600 italic text-xs">No Action</span>
                                <% } %>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="6" class="p-8 text-center text-zinc-500 italic">Không tìm thấy dữ liệu lịch sử đặt lịch nào.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="mt-6 rounded-2xl border border-white/10 bg-white/5 p-5">
            <h3 class="mb-3 font-bold text-white">Apply loyalty voucher</h3>
            <form method="post" action="<%= request.getContextPath() %>/booking/apply-voucher" class="flex flex-wrap gap-3">
                <input name="bookingId" type="number" min="1" required placeholder="Booking ID" class="rounded-lg bg-zinc-900 p-3 text-white" />
                <input name="voucherCode" required placeholder="Voucher code" class="rounded-lg bg-zinc-900 p-3 text-white" />
                <button type="submit" class="rounded-lg bg-blue-600 px-5 py-3 font-bold text-white">Apply voucher</button>
            </form>
        </div>
    </div>
</body>
</html>
