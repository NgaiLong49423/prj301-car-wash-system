<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.BookingResultDTO"%>
<%@page import="dto.MembershipTierDTO"%>
<%
    BookingResultDTO result = (BookingResultDTO) request.getAttribute("BOOKING_RESULT");
    MembershipTierDTO tier = (MembershipTierDTO) request.getAttribute("MEMBER_TIER_DETAIL");
    boolean success = result != null && result.isSuccess();
    String status = result != null ? result.getStatus() : "ERROR";
    String tierName = tier != null && tier.getTierName() != null ? tier.getTierName() : "Member";

    boolean confirmed = "CONFIRMED".equalsIgnoreCase(status);
    boolean backupConfirmed = "BACKUP_CONFIRMED".equalsIgnoreCase(status);
    boolean waiting = "WAITING".equalsIgnoreCase(status) || "WAITLIST".equalsIgnoreCase(status);
    boolean pending = "PENDING".equalsIgnoreCase(status);
    boolean accepted = success && (confirmed || backupConfirmed || waiting || pending);

    String title;
    if (confirmed) {
        title = "Lịch đã được xác nhận.";
    } else if (backupConfirmed) {
        title = "Lịch đã được xếp vào slot backup";
    } else if (waiting) {
        title = "Bạn đã vào danh sách chờ";
    } else if (pending && success) {
        title = "Đặt lịch thành công";
    } else {
        title = "Đặt lịch không thành công";
    }

    String icon = waiting ? "hourglass_top" : (accepted ? "event_available" : "error");
%>
<!DOCTYPE html>
<html class="dark" lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ket qua dat lich - Luxe Wash</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
</head>
<body class="min-h-screen bg-[#111315] text-slate-100">
    <main class="mx-auto flex min-h-screen max-w-3xl items-center px-5 py-10">
        <section class="w-full rounded-lg border border-white/10 bg-[#1a1d21] p-8 text-center">
            <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full <%= accepted ? "bg-blue-300/10 text-blue-100" : "bg-red-400/10 text-red-100" %>">
                <span class="material-symbols-outlined text-4xl"><%= icon %></span>
            </div>

            <p class="mt-5 text-sm uppercase tracking-wide text-blue-200">Booking</p>
            <h1 class="mt-2 text-3xl font-bold"><%= title %></h1>

            <p class="mx-auto mt-4 max-w-xl text-slate-300">
                <%= result != null ? result.getMessage() : "Hệ thống không nhận được kết quả đặt lịch." %>
            </p>

            <% if (result != null && result.getQueuePosition() != null) { %>
                <div class="mx-auto mt-6 max-w-sm rounded-lg border border-yellow-300/30 bg-yellow-300/10 px-4 py-3 text-yellow-100">
                    Vi tri hang cho cua ban: <strong>#<%= result.getQueuePosition() %></strong>
                </div>
            <% } %>

            <div class="mx-auto mt-6 max-w-sm rounded-lg border border-white/10 bg-[#111315] px-4 py-3 text-sm text-slate-300">
                Hang thanh vien: <strong class="text-blue-100"><%= tierName %></strong>
                <% if (tier != null) { %>
                    · Priority score: <strong class="text-blue-100"><%= tier.getPriorityScore() %></strong>
                <% } %>
            </div>

            <div class="mt-8 flex flex-wrap justify-center gap-3">
                <a class="rounded-lg bg-blue-200 px-5 py-3 font-bold text-slate-950 hover:bg-blue-100" href="<%= request.getContextPath() %>/MainController?action=Booking">Dat lich khac</a>
                <a class="rounded-lg border border-white/10 px-5 py-3 font-bold text-slate-100 hover:bg-white/5" href="<%= request.getContextPath() %>/MainController?action=Dashboard">Ve trang chu</a>
            </div>
        </section>
    </main>
</body>
</html>
