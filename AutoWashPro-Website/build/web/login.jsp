<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html class="dark" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Đăng nhập - Luxe Wash</title>
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
                    "secondary-fixed-dim": "#e9c349",
                    "surface-container": "#1f1f20",
                    "outline": "#8b90a0",
                    "on-tertiary-container": "#282a2a",
                    "on-error-container": "#ffdad6",
                    "tertiary-fixed": "#e3e2e2",
                    "surface-container-high": "#2a2a2b",
                    "surface-container-low": "#1b1b1c",
                    "secondary-fixed": "#ffe088",
                    "surface-dim": "#131314",
                    "primary-container": "#4b8eff",
                    "secondary": "#e9c349",
                    "on-surface": "#e5e2e3",
                    "on-primary-fixed": "#001a41",
                    "on-primary-fixed-variant": "#004493",
                    "on-primary-container": "#00285c",
                    "on-primary": "#002e69",
                    "on-tertiary-fixed-variant": "#464747",
                    "surface-tint": "#adc6ff",
                    "on-secondary": "#3c2f00",
                    "error": "#ffb4ab",
                    "surface": "#131314",
                    "on-secondary-container": "#342800",
                    "error-container": "#93000a",
                    "inverse-on-surface": "#303031",
                    "primary": "#adc6ff",
                    "on-surface-variant": "#c1c6d7",
                    "surface-variant": "#353436",
                    "surface-container-highest": "#353436",
                    "on-secondary-fixed": "#241a00",
                    "on-tertiary-fixed": "#1a1c1c",
                    "secondary-container": "#af8d11",
                    "primary-fixed-dim": "#adc6ff",
                    "on-secondary-fixed-variant": "#574500",
                    "tertiary-fixed-dim": "#c6c6c6",
                    "surface-bright": "#39393a",
                    "outline-variant": "#414755",
                    "on-background": "#e5e2e3",
                    "tertiary-container": "#909191",
                    "inverse-primary": "#005bc1",
                    "background": "#131314",
                    "tertiary": "#c6c6c6",
                    "surface-container-lowest": "#0e0e0f",
                    "on-tertiary": "#2f3131",
                    "on-error": "#690005",
                    "inverse-surface": "#e5e2e3",
                    "primary-fixed": "#d8e2ff"
            },
            "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
            },
            "spacing": {
                    "md": "16px",
                    "lg": "24px",
                    "xs": "4px",
                    "sm": "8px",
                    "container-margin": "20px",
                    "unit": "4px",
                    "gutter": "16px",
                    "xl": "32px"
            },
            "fontFamily": {
                    "body-sm": [
                            "Inter"
                    ],
                    "display-lg": [
                            "Montserrat"
                    ],
                    "body-lg": [
                            "Inter"
                    ],
                    "headline-lg-mobile": [
                            "Montserrat"
                    ],
                    "headline-lg": [
                            "Montserrat"
                    ],
                    "title-md": [
                            "Montserrat"
                    ],
                    "label-bold": [
                            "Inter"
                    ]
            },
            "fontSize": {
                    "body-sm": [
                            "14px",
                            {
                                    "lineHeight": "20px",
                                    "fontWeight": "400"
                            }
                    ],
                    "display-lg": [
                            "40px",
                            {
                                    "lineHeight": "48px",
                                    "letterSpacing": "-0.02em",
                                    "fontWeight": "700"
                            }
                    ],
                    "body-lg": [
                            "16px",
                            {
                                    "lineHeight": "24px",
                                    "fontWeight": "400"
                            }
                    ],
                    "headline-lg-mobile": [
                            "24px",
                            {
                                    "lineHeight": "32px",
                                    "fontWeight": "700"
                            }
                    ],
                    "headline-lg": [
                            "32px",
                            {
                                    "lineHeight": "40px",
                                    "fontWeight": "700"
                            }
                    ],
                    "title-md": [
                            "20px",
                            {
                                    "lineHeight": "28px",
                                    "fontWeight": "600"
                            }
                    ],
                    "label-bold": [
                            "12px",
                            {
                                    "lineHeight": "16px",
                                    "letterSpacing": "0.05em",
                                    "fontWeight": "600"
                            }
                    ]
            }
        },
        },
      }
    </script>
<style>
        .glass-panel {
            background: rgba(30, 30, 31, 0.8);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .input-glow:focus {
            box-shadow: 0 0 15px rgba(173, 198, 255, 0.3);
            border-color: rgba(173, 198, 255, 0.8);
        }
        .btn-glow {
            box-shadow: 0 0 15px rgba(173, 198, 255, 0.4);
        }
    </style>
</head>
<body class="bg-background text-on-surface font-body-lg min-h-screen flex items-center justify-center relative overflow-hidden">
<!-- Background Image -->
<div class="absolute inset-0 z-0">
<img alt="" class="w-full h-full object-cover opacity-60" src="https://lh3.googleusercontent.com/aida/ADBb0uh3tJilapulWTjkRUY-1nnAQqZM98BSWfgbzfbgTk5EH_CGIoJeItVyLP1nccqG5pNFY0As39JVa8OZJsAzg4f5LyLvy8rKmyck8-mjjNAPjKMkxx1fVu6jiOsW9baD3EU9-Hv-BwDWKox2JP2q7qdKCm6x6LWoh96t8SCLrt_zxMdWR7VA-q7V6pQbbIHk36a8O_v3K67KOzSqHqYc6fUcmjfU2oY9MOgp4Q5o4Ur3_8iVevGD8k5kuqwp"/>
<div class="absolute inset-0 bg-gradient-to-t from-background via-background/80 to-transparent"></div>
<div class="absolute inset-0 bg-gradient-to-r from-background via-transparent to-transparent"></div>
</div>
<!-- Login Container -->
<div class="relative z-10 w-full max-w-md px-container-margin md:px-0">
<!-- Branding -->
<div class="text-center mb-xl">
<h1 class="font-display-lg text-headline-lg-mobile md:text-headline-lg text-primary tracking-tighter">LUXE WASH</h1>
<p class="font-body-sm text-body-sm text-on-surface-variant mt-sm uppercase tracking-widest">Detailing Studio</p>
</div>
<!-- Glassmorphism Card -->
<div class="glass-panel rounded-xl p-lg md:p-xl shadow-2xl">
<h2 class="font-title-md text-title-md text-on-surface mb-lg">Đăng nhập</h2>
<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
<div class="mb-lg rounded-lg border border-red-500 bg-red-500/10 p-md text-red-500">
    <%= error %>
</div>
<%
    }
%>
<form action="login" method="post" class="space-y-lg">
<!-- Email Field -->
<div>
<label class="block font-label-bold text-label-bold text-on-surface-variant mb-sm uppercase" for="email">Email</label>
<div class="relative">
<span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline-variant" data-icon="mail">mail</span>
<input class="w-full bg-surface-dim border border-outline-variant rounded-lg py-md pl-[48px] pr-md text-on-surface font-body-lg focus:outline-none input-glow transition-all duration-300 placeholder-outline-variant" id="email" name="email" placeholder="nhapemail@example.com" type="email" required="required"/>
</div>
</div>
<!-- Password Field -->
<div>
<div class="flex justify-between items-center mb-sm">
<label class="block font-label-bold text-label-bold text-on-surface-variant uppercase" for="password">Mật khẩu</label>
<a class="font-body-sm text-body-sm text-primary hover:text-primary-fixed-dim transition-colors" href="#">Quên mật khẩu?</a>
</div>
<div class="relative">
<span class="material-symbols-outlined absolute left-md top-1/2 -translate-y-1/2 text-outline-variant" data-icon="lock">lock</span>
<input class="w-full bg-surface-dim border border-outline-variant rounded-lg py-md pl-[48px] pr-md text-on-surface font-body-lg focus:outline-none input-glow transition-all duration-300 placeholder-outline-variant" id="password" name="password" placeholder="••••••••" type="password" required="required"/>
<button class="absolute right-md top-1/2 -translate-y-1/2 text-outline-variant hover:text-on-surface transition-colors" type="button">
<span class="material-symbols-outlined" data-icon="visibility">visibility</span>
</button>
</div>
</div>
<!-- Primary Action -->
<button class="w-full bg-primary text-on-primary font-title-md text-title-md py-md rounded-lg flex items-center justify-center gap-sm hover:bg-primary-fixed-dim transition-colors duration-300 btn-glow active:scale-95" type="submit">
                    Đăng nhập
                    <span class="material-symbols-outlined" data-icon="arrow_forward">arrow_forward</span>
</button>
</form>
<div class="my-lg flex items-center">
<div class="flex-grow border-t border-outline-variant/50"></div>
<span class="px-md font-body-sm text-body-sm text-on-surface-variant">hoặc tiếp tục với</span>
<div class="flex-grow border-t border-outline-variant/50"></div>
</div>
<!-- Social Logins -->
<div class="grid grid-cols-2 gap-md">
<button class="flex items-center justify-center gap-sm bg-surface border border-outline-variant rounded-lg py-md hover:bg-surface-variant transition-colors duration-200" type="button">
<img alt="Google" class="w-5 h-5" data-alt="A clean, minimalist vector rendering of the Google G logo, isolated on a transparent background." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDxPluC19PXHYDcFyVvNTKbfKgxWUAAkXDkTf7BfsJtjcaDIqHDprwCwg5IrhNpTGrk3dEzI5lTxCpqHEflvGpQV66w7iGXI3AXNaJJGRqzsAVaw9VnKd_84Lh_EA4Fr5MOrxvhfAe1KBq3Ssei6YkMpxXxN0dda8ClX4alcxp_AHYANUrh-7eMEKn1ey7hibhgb12rHZzAdOfl2cojAZ49_FeDyWMUb29l7clMvQDeOW2fgiNj4eGmHiQ2OrsFz63iqToDkDuWIRYt"/>
<span class="font-body-sm text-body-sm">Google</span>
</button>
<button class="flex items-center justify-center gap-sm bg-surface border border-outline-variant rounded-lg py-md hover:bg-surface-variant transition-colors duration-200" type="button">
<span class="material-symbols-outlined" data-icon="apple">ios</span>
<span class="font-body-sm text-body-sm">Apple</span>
</button>
</div>
</div>
<!-- Sign Up Prompt -->
<div class="mt-lg text-center">
<p class="font-body-sm text-body-sm text-on-surface-variant">
                Người mới tại Luxe Wash? 
                <a class="text-secondary font-bold hover:text-secondary-fixed-dim transition-colors ml-xs" href="#">Tham gia Elite Pass</a>
</p>
<p class="mt-sm font-body-sm text-body-sm text-on-surface-variant">
                Quay lại <a class="text-primary hover:text-primary-fixed-dim" href="home.jsp">trang chủ</a>.
</p>
</div>
</div>
</body></html>