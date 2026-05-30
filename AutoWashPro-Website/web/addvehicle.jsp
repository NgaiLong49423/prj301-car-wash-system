<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="dto.User" %>
<%@ page import="mylib.AppKeys" %>
<%
  User account = (User) session.getAttribute(AppKeys.SESSION_ACCOUNT);
  if (account == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
%>
<!DOCTYPE html><html class="dark" lang="vi"><head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>Register New Car - LUXE WASH</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&amp;family=Inter:wght@400;600&amp;display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "surface-tint": "#adc6ff",
                    "primary": "#adc6ff",
                    "on-secondary": "#3c2f00",
                    "on-primary": "#002e69",
                    "secondary": "#e9c349",
                    "on-tertiary-fixed-variant": "#464747",
                    "on-primary-fixed": "#001a41",
                    "inverse-surface": "#e5e2e3",
                    "background": "#131314",
                    "tertiary-fixed": "#e3e2e2",
                    "tertiary-container": "#909191",
                    "surface": "#131314",
                    "surface-container-high": "#2a2a2b",
                    "on-secondary-fixed-variant": "#574500",
                    "surface-container-lowest": "#0e0e0f",
                    "secondary-fixed-dim": "#e9c349",
                    "on-tertiary-container": "#282a2a",
                    "inverse-on-surface": "#303031",
                    "surface-bright": "#39393a",
                    "secondary-fixed": "#ffe088",
                    "on-tertiary": "#2f3131",
                    "on-background": "#e5e2e3",
                    "primary-fixed-dim": "#adc6ff",
                    "surface-container-low": "#1b1b1c",
                    "primary-fixed": "#d8e2ff",
                    "outline-variant": "#414755",
                    "on-primary-fixed-variant": "#004493",
                    "on-error-container": "#ffdad6",
                    "surface-dim": "#131314",
                    "on-secondary-fixed": "#241a00",
                    "on-primary-container": "#00285c",
                    "error": "#ffb4ab",
                    "tertiary": "#c6c6c6",
                    "surface-container-highest": "#353436",
                    "on-secondary-container": "#342800",
                    "error-container": "#93000a",
                    "surface-variant": "#353436",
                    "surface-container": "#1f1f20",
                    "inverse-primary": "#005bc1",
                    "tertiary-fixed-dim": "#c6c6c6",
                    "on-surface": "#e5e2e3",
                    "on-error": "#690005",
                    "secondary-container": "#af8d11",
                    "outline": "#8b90a0",
                    "on-surface-variant": "#c1c6d7",
                    "primary-container": "#4b8eff",
                    "on-tertiary-fixed": "#1a1c1c"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "container-margin": "20px",
                    "xs": "4px",
                    "lg": "24px",
                    "unit": "4px",
                    "xl": "32px",
                    "gutter": "16px",
                    "md": "16px",
                    "sm": "8px"
            },
            "fontFamily": {
                    "body-lg": ["Inter"],
                    "label-bold": ["Inter"],
                    "headline-lg-mobile": ["Montserrat"],
                    "headline-lg": ["Montserrat"],
                    "title-md": ["Montserrat"],
                    "display-lg": ["Montserrat"],
                    "body-sm": ["Inter"]
            },
            "fontSize": {
                    "body-lg": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "label-bold": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                    "headline-lg-mobile": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                    "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "700"}],
                    "title-md": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                    "display-lg": ["40px", {"lineHeight": "48px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}]
            }
          },
        },
      }
    </script>
<style>
        body {
            background-color: #0F0F10;
            color: #e5e2e3;
            -webkit-font-smoothing: antialiased;
        }
        .glass-panel {
            background: rgba(30, 30, 31, 0.8);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .input-glow:focus {
            box-shadow: 0 0 15px rgba(173, 198, 255, 0.3);
            border-color: #adc6ff;
        }
    </style>
</head>
<body class="min-h-screen pb-24 md:pb-0">
<!-- Top App Bar -->
<header class="fixed top-0 w-full z-50 bg-surface/80 backdrop-blur-xl border-b border-white/10 shadow-sm">
<div class="flex justify-between items-center px-container-margin h-16 w-full max-w-7xl mx-auto">
<h1 class="font-display-lg text-display-lg font-bold text-primary dark:text-primary tracking-tight">LUXE WASH</h1>
<div class="flex items-center gap-4">
<button class="text-on-surface-variant hover:text-primary transition-colors active:scale-95 transition-transform">
<span class="material-symbols-outlined">notifications</span>
</button>
<button class="text-on-surface-variant hover:text-primary transition-colors active:scale-95 transition-transform">
<span class="material-symbols-outlined">settings</span>
</button>
<div class="w-8 h-8 rounded-full overflow-hidden border border-primary/20">
<img alt="Ngô Gia Long" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuB6i1fdzy0MJdcCzmmSZ2hJB16jts2npPqCzCIsNZHUBGg12IfZxNtmhuhTRFZYDaezASmqYBgkCW7Dj-3oaerxxdQS9-cmfiJBa6MK2qIQUVJm5II7WHSFuQNcykF5_6-W-krA-ZLTJtDQiXsu41asSunCQCPQzdfOUXB8MQCLi0397GfFp5YOaS981R0E7fIpWVc0frCFMGsvKpMPf1DsD6wxh4Y8ZCFlJwmkyX73Zq0QW0Va6dH6HSbk7vZbBDnc4aw35pwuI2Rb">
</div>
</div>
</div>
</header>
<main class="pt-24 px-container-margin max-w-7xl mx-auto">
<!-- Breadcrumb -->
<nav class="mb-8 flex items-center gap-2 text-on-surface-variant font-label-bold text-label-bold">
  <a class="hover:text-primary cursor-pointer transition-colors" href="<%= request.getContextPath() %>/ProfileServlet">Profile</a>
  <span class="material-symbols-outlined text-[14px]">chevron_right</span>
  <a class="hover:text-primary cursor-pointer transition-colors" href="<%= request.getContextPath() %>/ProfileServlet">My Garage</a>
  <span class="material-symbols-outlined text-[14px]">chevron_right</span>
  <%
    Boolean isEdit = request.getAttribute("isEdit") != null ? (Boolean) request.getAttribute("isEdit") : false;
    dto.Vehicle userVehicle = (dto.Vehicle) request.getAttribute("USER_VEHICLE");
    String licenseVal = request.getParameter("licensePlate") != null ? request.getParameter("licensePlate") : (userVehicle != null && userVehicle.getLicensePlate() != null ? userVehicle.getLicensePlate() : "");
    String brandVal = request.getParameter("brand") != null ? request.getParameter("brand") : (userVehicle != null && userVehicle.getBrand() != null ? userVehicle.getBrand() : "");
    String modelVal = request.getParameter("model") != null ? request.getParameter("model") : (userVehicle != null && userVehicle.getModel() != null ? userVehicle.getModel() : "");
    String colorVal = request.getParameter("color") != null ? request.getParameter("color") : (userVehicle != null && userVehicle.getColor() != null ? userVehicle.getColor() : "");
  %>
  <span class="text-primary"><%= isEdit ? "Sửa thông tin" : "Add New Car" %></span>
</nav>
<section class="max-w-2xl mx-auto mb-12">
<header class="mb-8 text-center">
<h2 class="font-headline-lg-mobile md:font-headline-lg text-headline-lg-mobile md:text-headline-lg text-on-surface mb-2"><%= isEdit ? "Sửa thông tin" : "Đăng ký xe mới" %></h2>
<p class="font-body-sm text-body-sm text-on-surface-variant"><%= isEdit ? "Cập nhật thông tin phương tiện của bạn." : "Thêm phương tiện của bạn vào Garage để nhận ưu đãi chăm sóc tốt nhất." %></p>
</header>
<!-- Registration Form -->
<div class="glass-panel rounded-xl p-6 md:p-8 shadow-2xl">
<form id="addVehicleForm" class="space-y-6" method="post" action="<%= request.getContextPath() %>/AddVehicleServlet">
  <% if (request.getAttribute("ERROR_MSG") != null) { %>
    <div class="text-red-400 bg-red-900/20 rounded-md p-3 font-medium">
      <%= request.getAttribute("ERROR_MSG") %>
    </div>
  <% } %>
<!-- Image Upload Area -->
<div class="group relative w-full aspect-[16/9] rounded-lg border-2 border-dashed border-outline-variant hover:border-primary transition-all cursor-pointer overflow-hidden flex flex-col items-center justify-center bg-surface-container-low">
<img class="absolute inset-0 w-full h-full object-cover opacity-0 transition-opacity" data-alt="A professional high-end automotive photography shot of a luxury sports car's hood, showcasing deep glossy reflections and metallic textures. The lighting is dramatic and clinical, set within a modern detailing studio with clean white walls and organized tools in the background. The aesthetic is premium, corporate modern, and technologically advanced." id="car-preview">
<div class="relative z-10 flex flex-col items-center pointer-events-none">
<div class="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center mb-3">
<span class="material-symbols-outlined text-primary text-3xl">add_a_photo</span>
</div>
<p class="font-label-bold text-label-bold text-on-surface">Tải ảnh xe lên</p>
<p class="font-body-sm text-body-sm text-on-surface-variant mt-1">PNG, JPG tối đa 5MB</p>
</div>
<input class="absolute inset-0 opacity-0 cursor-pointer" onchange="previewImage(this)" type="file">
</div>
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
<!-- License Plate -->
<div class="flex flex-col gap-2">
<label class="font-label-bold text-label-bold text-on-surface-variant">Biển số</label>
<input name="licensePlate" required value="<%= licenseVal %>" class="bg-surface-container border border-outline-variant rounded-lg p-3 font-body-lg text-body-lg text-on-surface outline-none input-glow transition-all" placeholder="30A-123.45" type="text">
</div>
<!-- Brand & Model -->
<div class="flex flex-col gap-2">
<label class="font-label-bold text-label-bold text-on-surface-variant">Hãng xe</label>
<input name="brand" required value="<%= brandVal %>" class="bg-surface-container border border-outline-variant rounded-lg p-3 font-body-lg text-body-lg text-on-surface outline-none input-glow transition-all" placeholder="Mercedes-Benz" type="text">
</div>
<!-- Color -->
<div class="flex flex-col gap-2">
<label class="font-label-bold text-label-bold text-on-surface-variant">Màu sắc</label>
<select name="color" required class="bg-surface-container border border-outline-variant rounded-lg p-3 font-body-lg text-body-lg text-on-surface outline-none input-glow transition-all appearance-none cursor-pointer">
  <option disabled="" value="">Chọn màu sắc</option>
  <option <%= "Đen".equals(colorVal) ? "selected" : "" %>>Đen</option>
  <option <%= "Trắng".equals(colorVal) ? "selected" : "" %>>Trắng</option>
  <option <%= "Xám Metallic".equals(colorVal) ? "selected" : "" %>>Xám Metallic</option>
  <option <%= "Xanh Dương".equals(colorVal) ? "selected" : "" %>>Xanh Dương</option>
  <option <%= "Đỏ".equals(colorVal) ? "selected" : "" %>>Đỏ</option>
</select>
</div>
<!-- Year -->
<div class="flex flex-col gap-2">
<label class="font-label-bold text-label-bold text-on-surface-variant">Model xe</label>
<input name="model" required value="<%= modelVal %>" class="bg-surface-container border border-outline-variant rounded-lg p-3 font-body-lg text-body-lg text-on-surface outline-none input-glow transition-all" placeholder="C300" type="text">
</div>
</div>
<!-- Action Buttons -->
<div class="flex flex-col md:flex-row gap-4 pt-4">
<% if (isEdit) { %>
  <input type="hidden" name="vehicleId" value="<%= userVehicle != null ? userVehicle.getVehicleId() : request.getParameter("vehicleId") %>" />
  <button class="flex-1 bg-primary text-on-primary font-title-md text-title-md py-4 rounded-lg hover:brightness-110 active:scale-95 transition-all shadow-lg shadow-primary/20" type="submit">
    Cập nhật thông tin
  </button>
<% } else { %>
  <button class="flex-1 bg-primary text-on-primary font-title-md text-title-md py-4 rounded-lg hover:brightness-110 active:scale-95 transition-all shadow-lg shadow-primary/20" type="submit">
    Confirm &amp; Add to Garage
  </button>
<% } %>
<button class="flex-1 bg-transparent border border-outline text-on-surface font-title-md text-title-md py-4 rounded-lg hover:bg-surface-variant active:scale-95 transition-all" type="button">
                            Cancel
                        </button>
</div>
</form>
</div>
</section>
<!-- Service Info (The Context) -->
<section class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-24">
<div class="glass-panel p-6 rounded-xl flex items-start gap-4">
<span class="material-symbols-outlined text-secondary" style="font-variation-settings: 'FILL' 1;">military_tech</span>
<div>
<h4 class="font-title-md text-title-md text-secondary">Tích điểm Rewards</h4>
<p class="font-body-sm text-body-sm text-on-surface-variant mt-1">Nhận ngay 100 điểm khi đăng ký xe mới thành công.</p>
</div>
</div>
<div class="glass-panel p-6 rounded-xl flex items-start gap-4">
<span class="material-symbols-outlined text-primary" style="font-variation-settings: 'FILL' 1;">calendar_today</span>
<div>
<h4 class="font-title-md text-title-md text-primary">Đặt lịch nhanh</h4>
<p class="font-body-sm text-body-sm text-on-surface-variant mt-1">Tự động điền thông tin khi đặt dịch vụ rửa xe cao cấp.</p>
</div>
</div>
<div class="glass-panel p-6 rounded-xl flex items-start gap-4">
<span class="material-symbols-outlined text-outline" style="font-variation-settings: 'FILL' 1;">history</span>
<div>
<h4 class="font-title-md text-title-md text-outline">Lịch sử chăm sóc</h4>
<p class="font-body-sm text-body-sm text-on-surface-variant mt-1">Theo dõi quá trình detailing riêng biệt cho từng xe.</p>
</div>
</div>
</section>
<script>
document.getElementById('addVehicleForm').addEventListener('submit', function(e){
  var form = e.target;
  // license format validation (client-side)
  var licenseEl = form.elements['licensePlate'];
  if (licenseEl) {
    var licVal = (licenseEl.value || '').trim().toUpperCase();
    var p1 = /^\d{2,3}[A-Z]-\d{3}\.\d{2}$/; // 30A-123.45
    var p2 = /^[0-9A-Za-z.\-\s]{4,12}$/; // fallback permissive
    if (licVal.length > 0 && !(p1.test(licVal) || p2.test(licVal))) {
      e.preventDefault();
      var msg = 'Biển số không hợp lệ. Ví dụ hợp lệ: 30A-123.45';
      var b = document.createElement('div');
      b.textContent = msg;
      b.style.position = 'fixed'; b.style.top = '72px'; b.style.left = '50%'; b.style.transform = 'translateX(-50%)';
      b.style.background = '#b91c1c'; b.style.color = '#fff'; b.style.padding = '10px 16px'; b.style.borderRadius = '6px';
      b.style.zIndex = 9999; document.body.appendChild(b);
      setTimeout(function(){ b.remove(); }, 4000);
      return;
    }
  }
  var required = ['licensePlate','brand','model','color'];
  var missing = [];
  required.forEach(function(name){
    var el = form.elements[name];
    if (!el) return;
    var val = el.value || '';
    if (val.trim() === '') missing.push(name);
  });
  if (missing.length > 0) {
    e.preventDefault();
    var msg = 'Vui lòng điền đầy đủ các trường: ' + missing.join(', ');
    // show temporary alert banner
    var b = document.createElement('div');
    b.textContent = msg;
    b.style.position = 'fixed'; b.style.top = '72px'; b.style.left = '50%'; b.style.transform = 'translateX(-50%)';
    b.style.background = '#b91c1c'; b.style.color = '#fff'; b.style.padding = '10px 16px'; b.style.borderRadius = '6px';
    b.style.zIndex = 9999; document.body.appendChild(b);
    setTimeout(function(){ b.remove(); }, 4000);
  }
});
</script>
</main>
<!-- Bottom Navigation (Mobile Only) -->
<nav class="md:hidden fixed bottom-0 left-0 w-full z-50 flex justify-around items-center px-4 py-3 pb-safe bg-surface-container/80 backdrop-blur-2xl border-t border-white/5 shadow-2xl rounded-t-xl">
<div class="flex flex-col items-center justify-center text-on-surface-variant p-2 hover:bg-surface-container-high transition-all active:scale-90">
<span class="material-symbols-outlined">home</span>
<span class="font-label-bold text-label-bold">Home</span>
</div>
<div class="flex flex-col items-center justify-center bg-primary-container text-on-primary-container rounded-xl p-2 min-w-[64px] active:scale-90">
<span class="material-symbols-outlined">person</span>
<span class="font-label-bold text-label-bold">Profile</span>
</div>
<div class="flex flex-col items-center justify-center text-on-surface-variant p-2 hover:bg-surface-container-high transition-all active:scale-90">
<span class="material-symbols-outlined">local_car_wash</span>
<span class="font-label-bold text-label-bold">Book Wash</span>
</div>
<div class="flex flex-col items-center justify-center text-on-surface-variant p-2 hover:bg-surface-container-high transition-all active:scale-90">
<span class="material-symbols-outlined">military_tech</span>
<span class="font-label-bold text-label-bold">Rewards</span>
</div>
<div class="flex flex-col items-center justify-center text-on-surface-variant p-2 hover:bg-surface-container-high transition-all active:scale-90">
<span class="material-symbols-outlined">logout</span>
<span class="font-label-bold text-label-bold">Logout</span>
</div>
</nav>
<script>
        function previewImage(input) {
            const preview = document.getElementById('car-preview');
            const placeholder = preview.nextElementSibling;
            
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.classList.remove('opacity-0');
                    placeholder.classList.add('hidden');
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // Form submission micro-interaction: show spinner but allow normal submit
        document.querySelector('form').addEventListener('submit', (e) => {
          const btn = e.target.querySelector('button[type="submit"]');
          if (!btn) return;
          btn.__originalText = btn.__originalText || btn.innerText;
          btn.innerHTML = '<span class="material-symbols-outlined animate-spin">progress_activity</span>';
          btn.disabled = true;
          // allow the form to submit normally so the server can persist the vehicle
        });
    </script>


</body><div id="eJOY__extension_ai_adv_root" class="eJOY__extension_ai_adv_root_class"><div class="wrapperAiAssEjoy "><div class="containerSumEjoyIcon "><div class="viewIconEjoy gl-tooltip-ejoy gl-tooltip-ejoy-left" tooltip-data="eJOY AI Assistant"><div class="viewIconEjoyItem"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="26" viewBox="0 0 24 26" fill="none"><mask id="mask0_427_34" maskUnits="userSpaceOnUse" x="16" y="3" width="8" height="8" style="mask-type: luminance;"><path d="M24 3H16V11H24V3Z" fill="white"></path></mask><g mask="url(#mask0_427_34)"><path d="M23.8012 7.00309L21.0136 8.01539L20.0012 10.8031L18.9889 8.01539L16.2012 7.00309L18.9889 5.9908L20.0012 3.20309L21.0136 5.9908L23.8012 7.00309Z" fill="url(#paint0_linear_427_34)"></path></g><mask id="mask1_427_34" maskUnits="userSpaceOnUse" x="0" y="10" width="6" height="6" style="mask-type: luminance;"><path d="M6 10H0V16H6V10Z" fill="white"></path></mask><g mask="url(#mask1_427_34)"><path d="M5.8494 13.0023L3.7587 13.7616L2.9994 15.8523L2.2402 13.7616L0.149399 13.0023L2.2402 12.2431L2.9994 10.1523L3.7587 12.2431L5.8494 13.0023Z" fill="url(#paint1_linear_427_34)"></path></g><mask id="mask2_427_34" maskUnits="userSpaceOnUse" x="16" y="20" width="4" height="4" style="mask-type: luminance;"><path d="M20 20H16V24H20V20Z" fill="white"></path></mask><g mask="url(#mask2_427_34)"><path d="M19.8996 22.0016L18.5058 22.5077L17.9996 23.9016L17.4934 22.5077L16.0996 22.0016L17.4934 21.4954L17.9996 20.1016L18.5058 21.4954L19.8996 22.0016Z" fill="url(#paint2_linear_427_34)"></path></g><g filter="url(#filter0_d_427_34)"><path fill-rule="evenodd" clip-rule="evenodd" d="M11.8671 20.3327C14.8098 20.2537 16.4674 18.0538 16.368 15.5257C15.9553 11.8147 11.5502 10.6201 13.3135 5.666C9.7712 8.7188 7.228 12.6272 7.3363 15.408C7.3847 18.1053 8.9455 20.3327 11.8671 20.3327ZM14.5512 16.5696C15.0045 16.5696 15.3306 16.2001 15.3719 15.7489C15.4799 15.431 15.3719 13.9738 14.2947 13.0395C14.4695 14.2529 13.6329 15.261 13.7305 15.7489C13.7305 16.2022 14.0979 16.5696 14.5512 16.5696Z" fill="#1DA1F2"></path></g><defs><filter id="filter0_d_427_34" x="2.47583" y="0.80886" width="18.7535" height="24.381" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB"><feFlood flood-opacity="0" result="BackgroundImageFix"></feFlood><feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"></feColorMatrix><feOffset></feOffset><feGaussianBlur stdDeviation="2.42857"></feGaussianBlur><feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.12 0"></feColorMatrix><feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_427_34"></feBlend><feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_427_34" result="shape"></feBlend></filter><linearGradient id="paint0_linear_427_34" x1="20.0012" y1="3.20309" x2="20.0012" y2="10.8031" gradientUnits="userSpaceOnUse"><stop stop-color="#1DA1F2"></stop><stop offset="1" stop-color="#6CD2FF"></stop></linearGradient><linearGradient id="paint1_linear_427_34" x1="2.9994" y1="10.1523" x2="2.9994" y2="15.8523" gradientUnits="userSpaceOnUse"><stop stop-color="#1DA1F2"></stop><stop offset="1" stop-color="#6CD2FF"></stop></linearGradient><linearGradient id="paint2_linear_427_34" x1="17.9996" y1="20.1016" x2="17.9996" y2="23.9016" gradientUnits="userSpaceOnUse"><stop stop-color="#1DA1F2"></stop><stop offset="1" stop-color="#6CD2FF"></stop></linearGradient></defs></svg></div><div class="moveIconEjoyAi"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M5.45139 0.667969C4.64931 0.667969 4 1.31727 4 2.11936C4 2.92144 4.64931 3.57075 5.45139 3.57075C6.25347 3.57075 6.90278 2.92144 6.90278 2.11936C6.90278 1.31727 6.25347 0.667969 5.45139 0.667969ZM4 8.00868C4 7.2066 4.64931 6.55729 5.45139 6.55729C6.25347 6.55729 6.90278 7.2066 6.90278 8.00868C6.90278 8.81076 6.25347 9.46007 5.45139 9.46007C4.64931 9.46007 4 8.81076 4 8.00868ZM4 13.8837C4 13.0816 4.64931 12.4323 5.45139 12.4323C6.25347 12.4323 6.90278 13.0816 6.90278 13.8837C6.90278 14.6858 6.25347 15.3351 5.45139 15.3351C4.64931 15.3351 4 14.6858 4 13.8837Z" fill="#666666"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M10.7854 0.667969C9.98329 0.667969 9.33398 1.31727 9.33398 2.11936C9.33398 2.92144 9.98329 3.57075 10.7854 3.57075C11.5875 3.57075 12.2368 2.92144 12.2368 2.11936C12.2368 1.31727 11.5875 0.667969 10.7854 0.667969ZM9.33398 8.00868C9.33398 7.2066 9.98329 6.55729 10.7854 6.55729C11.5875 6.55729 12.2368 7.2066 12.2368 8.00868C12.2368 8.81076 11.5875 9.46007 10.7854 9.46007C9.98329 9.46007 9.33398 8.81076 9.33398 8.00868ZM9.33398 13.8837C9.33398 13.0816 9.98329 12.4323 10.7854 12.4323C11.5875 12.4323 12.2368 13.0816 12.2368 13.8837C12.2368 14.6858 11.5875 15.3351 10.7854 15.3351C9.98329 15.3351 9.33398 14.6858 9.33398 13.8837Z" fill="#666666"></path></svg></div></div><div class="viewCloseIconEjoy"><svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none"><circle cx="6" cy="6" r="6" fill="black" fill-opacity="0.25"></circle><path fill-rule="evenodd" clip-rule="evenodd" d="M8.71289 3.58672C8.87135 3.74518 8.87135 4.00209 8.71289 4.16054L6.72363 6.14981L8.71289 8.13907C8.87135 8.29752 8.87135 8.55444 8.71289 8.71289C8.55444 8.87135 8.29752 8.87135 8.13907 8.71289L6.14981 6.72363L4.16054 8.71289C4.00209 8.87135 3.74518 8.87135 3.58672 8.71289C3.42826 8.55443 3.42826 8.29752 3.58672 8.13907L5.57598 6.14981L3.58672 4.16054C3.42826 4.00209 3.42826 3.74518 3.58672 3.58672C3.74518 3.42826 4.00209 3.42826 4.16054 3.58672L6.14981 5.57598L8.13907 3.58672C8.29752 3.42826 8.55444 3.42826 8.71289 3.58672Z" fill="white"></path></svg></div></div><div class="eJOY__container eJOY__container_scroll  "><div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; padding-left: 12px;"><div><div style="border-radius: 3px; padding: 4px 8px; color: rgb(255, 255, 255); font-size: 12px; font-style: normal; font-weight: 400; line-height: 12px; background: rgba(29, 161, 242, 0.65);" class="">Beta</div></div><div style="display: flex; justify-content: center; padding-right: 12px; flex-direction: column;"><span style="color: rgb(140, 140, 140); font-size: 10px; font-style: normal; font-weight: 600; line-height: 12px; padding-bottom: 1px;" class="">0 / 3000</span><span style="color: rgb(140, 140, 140); font-size: 8px; font-style: normal; font-weight: 400; line-height: 10px;" class="">used queries</span></div></div></div></div></div><div id="eJOY__extension_root" class="eJOY__extension_root_class" style="all: unset;"></div></html>


