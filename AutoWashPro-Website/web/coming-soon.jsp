<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html class="dark" lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>LUXE WASH - Coming Soon</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Montserrat:wght@600;700&display=swap" rel="stylesheet"/>
</head>
<body class="bg-gradient-to-br from-gray-900 via-[#131314] to-black text-white antialiased min-h-screen flex items-center justify-center p-4">

    <%
        String featureName = (String) request.getAttribute("featureName");
        String featureIcon = (String) request.getAttribute("featureIcon");
        
        if (featureName == null) {
            featureName = "Tính Năng";
            featureIcon = "construction";
        }
    %>

    <!-- Main Container -->
    <div class="max-w-md w-full text-center">
        
        <!-- Icon Animation -->
        <div class="mb-8 flex justify-center">
            <div class="relative w-24 h-24 flex items-center justify-center">
                <!-- Animated background circle -->
                <div class="absolute inset-0 rounded-full bg-gradient-to-r from-[#adc6ff] to-[#e9c349] opacity-20 blur-lg animate-pulse"></div>
                <!-- Icon -->
                <div class="relative text-6xl">
                    <span class="material-symbols-outlined animate-bounce" style="font-size: 60px; color: #adc6ff;">
                        <%= featureIcon %>
                    </span>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="backdrop-blur-xl bg-white/5 border border-white/10 rounded-2xl p-8 shadow-2xl">
            
            <h1 class="text-4xl font-bold mb-3 font-['Montserrat']">
                Sắp Ra Mắt
            </h1>
            
            <p class="text-gray-300 text-lg mb-2">
                <%= featureName %>
            </p>
            
            <div class="my-6 h-1 w-16 bg-gradient-to-r from-[#adc6ff] to-[#e9c349] rounded-full mx-auto"></div>
            
            <p class="text-gray-400 text-base leading-relaxed mb-8">
                🚀 Tính năng này đang được phát triển với những cải tiến tuyệt vời!
            </p>

            <!-- Loading Animation -->
            <div class="mb-8">
                <div class="flex justify-center gap-2">
                    <div class="w-2 h-2 bg-[#adc6ff] rounded-full animate-bounce" style="animation-delay: 0s;"></div>
                    <div class="w-2 h-2 bg-[#e9c349] rounded-full animate-bounce" style="animation-delay: 0.2s;"></div>
                    <div class="w-2 h-2 bg-[#adc6ff] rounded-full animate-bounce" style="animation-delay: 0.4s;"></div>
                </div>
            </div>

            <!-- Info Message -->
            <div class="bg-blue-500/10 border border-blue-500/30 rounded-lg p-4 mb-8 text-left">
                <p class="text-sm text-blue-300">
                    💡 <strong>Mẹo:</strong> Hãy quay lại Rewards để xem chương trình khách hàng thân thiết của bạn.
                </p>
            </div>

            <!-- Back Button -->
            <a href="<%= request.getContextPath() %>/MainController?action=Rewards" class="inline-block w-full bg-gradient-to-r from-[#adc6ff] to-[#4b8eff] hover:from-[#d8e2ff] hover:to-[#7aa3ff] text-white font-bold py-3 px-6 rounded-lg transition-all duration-300 active:scale-95">
                ← Quay Lại Rewards
            </a>
        </div>

        <!-- Footer Message -->
        <p class="text-gray-500 text-sm mt-8">
            Cảm ơn bạn đã tin tưởng LUXE WASH ❤️
        </p>

    </div>

</body>
</html>
