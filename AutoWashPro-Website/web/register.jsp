<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="mylib.AppKeys"%>
<!DOCTYPE html>
<html class="dark" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Luxe Wash - Đăng ký tài khoản</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&amp;family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            "colors": {
                    "surface-container-lowest": "#0e0e0f",
                    "on-background": "#e5e2e3",
                    "secondary-container": "#af8d11",
                    "on-secondary-container": "#342800",
                    "on-error": "#690005",
                    "surface-container-low": "#1b1b1c",
                    "tertiary-container": "#909191",
                    "on-secondary-fixed-variant": "#574500",
                    "inverse-on-surface": "#303031",
                    "secondary-fixed": "#ffe088",
                    "on-secondary": "#3c2f00",
                    "surface": "#131314",
                    "background": "#131314",
                    "on-primary-fixed-variant": "#004493",
                    "inverse-surface": "#e5e2e3",
                    "on-tertiary": "#2f3131",
                    "error": "#ffb4ab",
                    "error-container": "#93000a",
                    "on-surface-variant": "#c1c6d7",
                    "surface-container": "#1f1f20",
                    "on-primary-fixed": "#001a41",
                    "on-primary": "#002e69",
                    "surface-bright": "#39393a",
                    "on-tertiary-container": "#282a2a",
                    "primary": "#adc6ff",
                    "primary-fixed": "#d8e2ff",
                    "primary-container": "#4b8eff",
                    "tertiary-fixed": "#e3e2e2",
                    "on-tertiary-fixed": "#1a1c1c",
                    "inverse-primary": "#005bc1",
                    "on-secondary-fixed": "#241a00",
                    "surface-tint": "#adc6ff",
                    "secondary": "#e9c349",
                    "surface-container-highest": "#353436",
                    "primary-fixed-dim": "#adc6ff",
                    "on-primary-container": "#00285c",
                    "tertiary": "#c6c6c6",
                    "on-tertiary-fixed-variant": "#464747",
                    "on-error-container": "#ffdad6",
                    "tertiary-fixed-dim": "#c6c6c6",
                    "outline-variant": "#414755",
                    "outline": "#8b90a0",
                    "surface-variant": "#353436",
                    "secondary-fixed-dim": "#e9c349",
                    "on-surface": "#e5e2e3",
                    "surface-container-high": "#2a2a2b",
                    "surface-dim": "#131314"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "xs": "4px",
                    "container-margin": "20px",
                    "md": "16px",
                    "xl": "32px",
                    "sm": "8px",
                    "lg": "24px",
                    "unit": "4px",
                    "gutter": "16px"
            },
            "fontFamily": {
                    "label-bold": ["Inter"],
                    "body-sm": ["Inter"],
                    "body-lg": ["Inter"],
                    "title-md": ["Montserrat"],
                    "display-lg": ["Montserrat"],
                    "headline-lg-mobile": ["Montserrat"],
                    "headline-lg": ["Montserrat"]
            },
            "fontSize": {
                    "label-bold": ["12px", {"lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600"}],
                    "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                    "body-lg": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                    "title-md": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                    "display-lg": ["40px", {"lineHeight": "48px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                    "headline-lg-mobile": ["24px", {"lineHeight": "32px", "fontWeight": "700"}],
                    "headline-lg": ["32px", {"lineHeight": "40px", "fontWeight": "700"}]
            }
          },
        },
      }
    </script>
<style>
.glass-card {
    background: rgba(30, 30, 31, 0.8);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.1)
    }
.glow-primary {
    box-shadow: 0 0 15px rgba(173, 198, 255, 0.3)
    }
.bg-studio {
    background-image: linear-gradient(to bottom, rgba(15, 15, 16, 0.6), rgba(15, 15, 16, 0.9)), url(https://lh3.googleusercontent.com/aida-public/AB6AXuDo6rpuI2hayhgIgH-ESgQhwOkBEfO9v_Z3rmToNc9xJ_bdDF-dKvyeLARbPvJC7KGzmoLcoza_blVvcC0t6n3PUM8MEyzLWpOO1d-PkejJ6BFbo_1dsrAcl65CjwwDawIVh8YfaIKX4c2NdQTVursuzAqrn_lPmYj9JumdavmMEHtKmcQOY6DPSVcTZIsN6UaXCOGe9ep3W8xYt-D_aZWBOUXnj9VZ9bfMxXb5E2PEKkNKFbnHrQkvkjj0FqydmeE66B4ejt38QdPH);
    background-size: cover;
    background-position: center
    }
.material-symbols-outlined {
    font-variation-settings: "FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24
    }</style>
</head>
<body class="bg-background text-on-background font-body-lg min-h-screen selection:bg-primary selection:text-on-primary">
<!-- TopAppBar -->
<header class="fixed top-0 w-full z-50 bg-surface/80 backdrop-blur-xl dark:bg-surface/80 border-b border-white/10 shadow-md flex justify-between items-center px-container-margin py-md">
<h1 class="font-display-lg text-headline-lg-mobile tracking-tight text-primary dark:text-primary">LUXE WASH</h1>
<div class="flex items-center gap-md">
<button class="active:scale-95 duration-200 text-on-surface-variant hover:text-primary transition-colors" type="button">
<span class="material-symbols-outlined">history</span>
</button>
<button class="active:scale-95 duration-200 text-on-surface-variant hover:text-primary transition-colors" type="button">
<span class="material-symbols-outlined">notifications</span>
</button>
</div>
</header>
<!-- Main Content -->
<main class="relative min-h-screen pt-24 pb-12 flex items-center justify-center bg-studio px-container-margin" data-alt="A cinematic, high-end automotive detailing studio at night. The environment is dark with dramatic electric blue and warm yellow light strips recessed in the ceiling and walls, reflecting off polished concrete floors. In the blurred background, a luxury deep blue supercar is being meticulously detailed by a professional team using high-pressure steam and foam. The atmosphere is sophisticated, modern, and technologically advanced, emphasizing a premium corporate luxury aesthetic.">
<div class="w-full max-w-md animate-in fade-in slide-in-from-bottom-4 duration-700">
<!-- Signup Card -->
<div class="glass-card rounded-xl p-lg md:p-xl shadow-2xl relative overflow-hidden">
<!-- Decorative Accent -->
<div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary via-secondary to-primary/50"></div>
<div class="text-center mb-lg">
<h2 class="font-headline-lg-mobile text-headline-lg-mobile mb-xs text-on-surface">Đăng ký tài khoản</h2>
<p class="text-on-surface-variant font-body-sm">Tham gia cộng đồng chăm sóc xe chuyên nghiệp</p>
</div>
<%
    /* ========== SECTION 1: Khởi tạo dữ liệu từ request ==========
       Mục đích: Lấy các giá trị lỗi và dữ liệu form cũ từ request scope (nếu có) 
       để re-populate form khi validation thất bại hoặc server trả về lỗi.
       
       Input: request.getAttribute() từ tầng controller (RegisterServlet)
       Output: các variable String để JSP render
       Fallback: nếu attribute không tồn tại thì = null (JSP tự xử lý)
    */
    String msgError = (String) request.getAttribute(AppKeys.REQ_ERROR);
    String fullNameValue = (String) request.getAttribute(AppKeys.REQ_FULL_NAME);
    String emailValue = (String) request.getAttribute(AppKeys.REQ_EMAIL);
    String phoneValue = (String) request.getAttribute(AppKeys.REQ_PHONE);
    String contextPath = request.getContextPath();
%>
<!-- ========== SECTION 2: Hiển thị thông báo lỗi ==========
     Nếu server trả về msgError (validation fail hoặc email/phone đã tồn tại)
     thì render alert box đỏ. Nếu msgError = null thì bỏ qua section này. -->
<% if (msgError != null) { %>
<div class="mb-lg rounded-lg border border-red-500 bg-red-500/10 p-md text-red-500 text-body-sm">
    <%= msgError %>
</div>
<% } %>
<!-- ========== SECTION 3: Form đăng ký chính ==========
     Input: lấy dữ liệu từ 5 field (fullName, email, phone, password, confirmPassword)
     Action: POST đến MainController với action=Register
     Output: gửi thông tin đến server để tạo tài khoản mới -->
<form action="<%= contextPath %>/MainController" method="post" class="space-y-md">
<input type="hidden" name="action" value="Register"/>
<!-- FIELD 1: Họ và tên
     - Input: required, text, pattern: bất kỳ ký tự nào (tên tiếng Việt/Anh)
     - Fallback: nếu form submit lỗi thì re-populate với fullNameValue từ request
     - Icon: người dùng (person) từ Material Symbols
 -->
<div class="space-y-xs">
<label class="font-label-bold text-label-bold text-outline ml-1" for="fullName">Họ và tên</label>
<div class="relative group">
<span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline group-focus-within:text-primary transition-colors">person</span>
<input class="w-full bg-surface-container-low border border-outline-variant rounded-lg py-md pl-12 pr-md text-on-surface placeholder:text-outline/50 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all" id="fullName" name="fullName" value="<%= fullNameValue != null ? fullNameValue : "" %>" placeholder="Nguyễn Văn A" type="text" required="required"/>
</div>
</div>
<!-- FIELD 2: Email
     - Input: required, type="email" (HTML5 validation)
     - Fallback: re-populate với emailValue nếu form submit trước đó
     - Icon: mail từ Material Symbols
     - Lưu ý: Server sẽ kiểm tra email chưa tồn tại trong DB
 -->
<div class="space-y-xs">
<label class="font-label-bold text-label-bold text-outline ml-1" for="email">Email</label>
<div class="relative group">
<span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline group-focus-within:text-primary transition-colors">mail</span>
<input class="w-full bg-surface-container-low border border-outline-variant rounded-lg py-md pl-12 pr-md text-on-surface placeholder:text-outline/50 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all" id="email" name="email" value="<%= emailValue != null ? emailValue : "" %>" placeholder="example@luxewash.com" type="email" required="required"/>
</div>
</div>
<!-- FIELD 3: Số điện thoại
     - Input: required, type="tel", pattern="[0-9]{9,11}" (HTML5 validation: 9-11 chữ số)
     - Fallback: re-populate với phoneValue nếu form submit trước đó
     - Icon: call từ Material Symbols
     - Lưu ý: Server sẽ kiểm tra số điện thoại chưa tồn tại trong DB
 -->
<div class="space-y-xs">
<label class="font-label-bold text-label-bold text-outline ml-1" for="phone">Số điện thoại</label>
<div class="relative group">
<span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline group-focus-within:text-primary transition-colors">call</span>
<input class="w-full bg-surface-container-low border border-outline-variant rounded-lg py-md pl-12 pr-md text-on-surface placeholder:text-outline/50 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all" id="phone" name="phone" value="<%= phoneValue != null ? phoneValue : "" %>" placeholder="0901 234 567" type="tel" pattern="[0-9]{9,11}" required="required"/>
</div>
</div>
<!-- FIELD 4: Mật khẩu
     - Input: required, type="password" (ẩn ký tự nhập)
     - Validation: Server sẽ check mật khẩu phải >= 8 ký tự, chứa chữ hoa/thường/số/ký tự đặc biệt
     - Icon: lock từ Material Symbols
     - Lưu ý: giá trị password KHÔNG được lưu lại vào form (vì lý do bảo mật)
 -->
<div class="space-y-xs">
<label class="font-label-bold text-label-bold text-outline ml-1" for="password">Mật khẩu</label>
<div class="relative group">
<span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline group-focus-within:text-primary transition-colors">lock</span>
<input class="w-full bg-surface-container-low border border-outline-variant rounded-lg py-md pl-12 pr-md text-on-surface placeholder:text-outline/50 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all" id="password" name="password" placeholder="••••••••" type="password" required="required"/>
</div>
</div>
<!-- FIELD 5: Xác nhận mật khẩu
     - Input: required, type="password"
     - Validation: Server sẽ check password === confirmPassword
     - Icon: lock từ Material Symbols
     - Lưu ý: giá trị confirmPassword KHÔNG được lưu lại vào form (vì lý do bảo mật)
 -->
<div class="space-y-xs">
<label class="font-label-bold text-label-bold text-outline ml-1" for="confirmPassword">Nhập lại mật khẩu</label>
<div class="relative group transition-all">
<span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline group-focus-within:text-primary transition-colors">lock</span>
<input class="w-full bg-surface-container-low border border-outline-variant rounded-lg py-md pl-12 pr-md text-on-surface placeholder:text-outline/50 focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all" id="confirmPassword" name="confirmPassword" placeholder="••••••••" type="password" required="required"/>
</div>
</div>
<!-- Nút submit chính: gửi form tới server để validate và tạo tài khoản -->
<button class="w-full bg-primary-container text-on-primary-container font-title-md text-title-md py-md rounded-lg glow-primary hover:bg-primary-container/90 active:scale-95 transition-all duration-300 mt-lg" type="submit">
                        Đăng ký ngay
                    </button>
</form>
<!-- Đường phân chia giữa form và phương thức đăng ký xã hội -->
<div class="flex items-center my-xl gap-md">
<div class="h-[1px] flex-1 bg-outline-variant"></div>
<span class="text-label-bold font-label-bold text-outline">HOẶC</span>
<div class="h-[1px] flex-1 bg-outline-variant"></div>
</div>
<!-- Phương thức đăng ký xã hội (Google, Apple)
     Lưu ý: Các nút này hiện chỉ là UI placeholder, backend chưa integrate OAuth.
     Input: người dùng click vào nút Google hoặc Apple
     Output: (chưa implement) sẽ redirect sang Google/Apple login flow -->
<div class="grid grid-cols-2 gap-md">
<button class="flex items-center justify-center gap-sm bg-surface-container-high border border-outline-variant hover:border-outline py-md rounded-lg active:scale-95 transition-all duration-200" type="button">
<svg class="w-5 h-5" viewbox="0 0 24 24">
<path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"></path>
<path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"></path>
<path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"></path>
<path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"></path>
</svg>
<span class="font-label-bold text-label-bold">Google</span>
</button>
<button class="flex items-center justify-center gap-sm bg-surface-container-high border border-outline-variant hover:border-outline py-md rounded-lg active:scale-95 transition-all duration-200" type="button">
<svg class="w-5 h-5" viewbox="0 0 24 24">
<path d="M17.05 20.28c-.96.95-2.04 1.43-3.23 1.43-1.2 0-2.18-.45-2.93-1.34-.76.9-1.74 1.34-2.93 1.34-1.18 0-2.26-.48-3.23-1.43-1.84-1.84-2.76-4.32-2.76-7.44 0-3.04.91-5.46 2.74-7.25 1.45-1.42 3.14-2.14 5.08-2.14.95 0 1.95.23 3.01.69.75.32 1.34.69 1.77.69.43 0 1.02-.37 1.77-.69 1.06-.46 2.06-.69 3.01-.69 1.94 0 3.63.72 5.08 2.14 1.07 1.05 1.81 2.29 2.22 3.73-3.04 1.25-4.56 3.48-4.56 6.69 0 2.2.82 3.97 2.45 5.31-.69 1.86-1.74 3.34-3.23 4.43zm-4.73-16.71c0-1.13.43-2.18 1.29-3.15 1.05-1.18 2.23-1.77 3.54-1.77 0 1.1-.42 2.1-1.25 3-.98 1.1-2.16 1.65-3.54 1.65l-.04.27z" fill="currentColor"></path>
</svg>
<span class="font-label-bold text-label-bold">Apple</span>
</button>
</div>
<!-- Footer link: chuyển hướng tới trang login nếu người dùng đã có tài khoản -->
<div class="mt-xl text-center">
<p class="text-body-sm font-body-sm text-on-surface-variant">
                        Đã có tài khoản? 
                        <a class="text-secondary font-bold hover:underline ml-xs transition-all" href="<%= contextPath %>/MainController?action=Login">Đăng nhập</a>
</p>
</div>
</div>
</div>
</main>
</body></html>