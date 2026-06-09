<!DOCTYPE html>

<html class="dark" lang="vi"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&amp;family=Inter:wght@400;500;600&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "secondary-fixed-dim": "#e9c349",
                        "on-background": "#e5e2e3",
                        "outline-variant": "#414755",
                        "error-container": "#93000a",
                        "inverse-on-surface": "#303031",
                        "secondary-container": "#af8d11",
                        "on-primary-fixed-variant": "#004493",
                        "surface-tint": "#adc6ff",
                        "inverse-surface": "#e5e2e3",
                        "surface-container-lowest": "#0e0e0f",
                        "on-secondary-container": "#342800",
                        "outline": "#8b90a0",
                        "on-secondary-fixed": "#241a00",
                        "on-surface-variant": "#c1c6d7",
                        "secondary-fixed": "#ffe088",
                        "tertiary-container": "#909191",
                        "on-primary-fixed": "#001a41",
                        "on-error": "#690005",
                        "surface-container-high": "#2a2a2b",
                        "surface": "#131314",
                        "secondary": "#e9c349",
                        "inverse-primary": "#005bc1",
                        "tertiary": "#c6c6c6",
                        "primary": "#adc6ff",
                        "tertiary-fixed": "#e3e2e2",
                        "surface-dim": "#131314",
                        "primary-fixed": "#d8e2ff",
                        "on-primary": "#002e69",
                        "surface-container": "#1f1f20",
                        "error": "#ffb4ab",
                        "on-tertiary-container": "#282a2a",
                        "on-secondary-fixed-variant": "#574500",
                        "on-error-container": "#ffdad6",
                        "background": "#131314",
                        "on-tertiary": "#2f3131",
                        "surface-container-low": "#1b1b1c",
                        "on-primary-container": "#00285c",
                        "tertiary-fixed-dim": "#c6c6c6",
                        "surface-bright": "#39393a",
                        "surface-container-highest": "#353436",
                        "surface-variant": "#353436",
                        "on-tertiary-fixed-variant": "#464747",
                        "primary-fixed-dim": "#adc6ff",
                        "on-secondary": "#3c2f00",
                        "primary-container": "#4b8eff",
                        "on-tertiary-fixed": "#1a1c1c",
                        "on-surface": "#e5e2e3"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                    "fontFamily": {
                        "display": ["Montserrat", "sans-serif"],
                        "body": ["Inter", "sans-serif"]
                    }
                }
            }
        }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .glass {
            background: rgba(31, 31, 32, 0.8);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .custom-scrollbar::-webkit-scrollbar {
            height: 4px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #414755;
            border-radius: 10px;
        }
        .step-active {
            color: #adc6ff;
            border-bottom: 2px solid #adc6ff;
        }
    </style>
</head>
<body class="bg-background text-on-background font-body">
<!-- Header Section (Minimal Back-to-Main) -->
<nav class="sticky top-0 z-50 glass px-6 py-4 flex items-center justify-between border-b border-outline-variant"><div class="max-w-7xl mx-auto w-full flex items-center justify-between">
<div class="flex items-center gap-12">
<span class="text-primary font-display font-bold text-lg tracking-wider uppercase">LUXE WASH</span>
<div class="hidden md:flex items-center gap-8">
<a class="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors" href="#">
<span class="material-symbols-outlined text-[20px]">home</span>
<span class="text-sm font-medium">Home</span>
</a>
<a class="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors" href="#">
<span class="material-symbols-outlined text-[20px]">person</span>
<span class="text-sm font-medium">Profile</span>
</a>
<a class="flex items-center gap-2 text-primary" href="#">
<span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">local_car_wash</span>
<span class="text-sm font-bold">Book Wash</span>
</a>
<a class="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors" href="#">
<span class="material-symbols-outlined text-[20px]">military_tech</span>
<span class="text-sm font-medium">Membership</span>
</a>
<a class="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors" href="#">
<span class="material-symbols-outlined text-[20px]">logout</span>
<span class="text-sm font-medium">Logout</span>
</a>
</div>
</div>
<div class="flex items-center gap-4">
<button class="p-2 text-on-surface-variant hover:text-on-surface transition-colors">
<span class="material-symbols-outlined">notifications</span>
</button>
<button class="p-2 text-on-surface-variant hover:text-on-surface transition-colors">
<span class="material-symbols-outlined">settings</span>
</button>
</div>
</div></nav>
<main class="max-w-2xl mx-auto p-5 space-y-8">
<!-- Step 1: Ch?n Xe -->
<section class="space-y-4">
<div class="flex items-center justify-between">
<h2 class="text-headline-lg-mobile font-display">1. Ch?n xe c?a b?n</h2>
<button class="text-primary text-sm font-semibold flex items-center gap-1">
<span class="material-symbols-outlined text-[18px]" data-icon="add_circle">add_circle</span>
                    Thêm xe m?i
                </button>
</div>
<div class="flex gap-4 overflow-x-auto pb-2 custom-scrollbar">
<!-- Vehicle Card Active -->
<div class="shrink-0 w-64 p-4 rounded-xl border-2 border-primary bg-primary/10 relative cursor-pointer">
<div class="absolute top-3 right-3 text-primary">
<span class="material-symbols-outlined" data-icon="check_circle" style='font-variation-settings: "FILL" 1;'>check_circle</span>
</div>
<div class="text-label-bold text-primary mb-1">M?c ??nh</div>
<div class="font-bold text-lg font-display">Toyota Vios</div>
<div class="text-on-surface-variant text-sm">Bi?n s?: 30A-123.45</div>
</div>
<!-- Vehicle Card Inactive -->
<div class="shrink-0 w-64 p-4 rounded-xl border border-outline-variant bg-surface-container hover:border-outline transition-all cursor-pointer">
<div class="text-label-bold text-on-surface-variant mb-1 opacity-0">.</div>
<div class="font-bold text-lg font-display">Mazda 3</div>
<div class="text-on-surface-variant text-sm">Bi?n s?: 51F-678.90</div>
</div>
</div>
</section>
<!-- Step 2: Ch?n Gói D?ch V? -->
<section class="space-y-4">
<h2 class="text-headline-lg-mobile font-display">2. Ch?n gói d?ch v?</h2>
<div class="grid grid-cols-1 gap-3">
<!-- Basic -->
<label class="relative flex items-center p-4 rounded-xl border border-outline-variant bg-surface-container-low cursor-pointer hover:bg-surface-container transition-colors has-[:checked]:border-primary has-[:checked]:bg-primary/5">
<input class="hidden peer" name="service" type="radio" value="basic"/>
<div class="flex-1">
<div class="flex justify-between items-center mb-1">
<span class="font-bold font-display text-lg">Gói Basic</span>
<span class="text-primary font-bold">150.000?</span>
</div>
<p class="text-sm text-on-surface-variant">R?a ngoài, hút b?i th?m, lau kính c? b?n. (30 phút)</p>
</div>
<div class="ml-4 opacity-0 peer-checked:opacity-100 text-primary">
<span class="material-symbols-outlined" data-icon="task_alt">task_alt</span>
</div>
</label>
<!-- Premium -->
<label class="relative flex items-center p-4 rounded-xl border border-primary bg-primary/5 cursor-pointer hover:bg-primary/10 transition-colors">
<input checked="" class="hidden peer" name="service" type="radio" value="premium"/>
<div class="flex-1">
<div class="flex justify-between items-center mb-1">
<div class="flex items-center gap-2">
<span class="font-bold font-display text-lg">Gói Premium</span>
<span class="bg-secondary text-on-secondary text-[10px] px-2 py-0.5 rounded-full font-bold uppercase">Ph? bi?n nh?t</span>
</div>
<span class="text-primary font-bold">350.000?</span>
</div>
<p class="text-sm text-on-surface-variant">V? sinh n?i th?t sâu, wax bóng s?n, d??ng l?p. (60 phút)</p>
</div>
<div class="ml-4 text-primary">
<span class="material-symbols-outlined" data-icon="task_alt" style='font-variation-settings: "FILL" 1;'>task_alt</span>
</div>
</label>
<!-- Elite -->
<label class="relative flex items-center p-4 rounded-xl border border-outline-variant bg-surface-container-low cursor-pointer hover:bg-surface-container transition-colors has-[:checked]:border-primary has-[:checked]:bg-primary/5">
<input class="hidden peer" name="service" type="radio" value="elite"/>
<div class="flex-1">
<div class="flex justify-between items-center mb-1">
<span class="font-bold font-display text-lg">Gói Elite</span>
<span class="text-primary font-bold">850.000?</span>
</div>
<p class="text-sm text-on-surface-variant">Ph? nano, v? sinh khoang máy, kh? mùi Ozone. (120 phút)</p>
</div>
<div class="ml-4 opacity-0 peer-checked:opacity-100 text-primary">
<span class="material-symbols-outlined" data-icon="task_alt">task_alt</span>
</div>
</label>
</div>
</section>
<!-- Step 3: Ch?n Th?i Gian -->
<section class="space-y-4">
<h2 class="text-headline-lg-mobile font-display">3. Th?i gian ??t l?ch</h2>
<!-- Date Picker -->
<div class="flex gap-2 overflow-x-auto pb-2 custom-scrollbar">
<div class="flex flex-col items-center min-w-[70px] py-3 rounded-xl border border-primary bg-primary/10 text-primary">
<span class="text-[10px] font-bold uppercase opacity-80">T2</span>
<span class="text-lg font-bold">12</span>
<span class="text-[10px]">Th 06</span>
</div>
<div class="flex flex-col items-center min-w-[70px] py-3 rounded-xl border border-outline-variant bg-surface-container hover:border-outline cursor-pointer transition-all">
<span class="text-[10px] font-bold uppercase opacity-60">T3</span>
<span class="text-lg font-bold">13</span>
<span class="text-[10px]">Th 06</span>
</div>
<div class="flex flex-col items-center min-w-[70px] py-3 rounded-xl border border-outline-variant bg-surface-container hover:border-outline cursor-pointer transition-all">
<span class="text-[10px] font-bold uppercase opacity-60">T4</span>
<span class="text-lg font-bold">14</span>
<span class="text-[10px]">Th 06</span>
</div>
<div class="flex flex-col items-center min-w-[70px] py-3 rounded-xl border border-outline-variant bg-surface-container hover:border-outline cursor-pointer transition-all">
<span class="text-[10px] font-bold uppercase opacity-60">T5</span>
<span class="text-lg font-bold">15</span>
<span class="text-[10px]">Th 06</span>
</div>
<div class="flex flex-col items-center min-w-[70px] py-3 rounded-xl border border-outline-variant bg-surface-container hover:border-outline cursor-pointer transition-all"><span class="text-[10px] font-bold uppercase opacity-60">T6</span><span class="text-lg font-bold">16</span><span class="text-[10px]">Th 06</span></div><div class="flex flex-col items-center min-w-[70px] py-3 rounded-xl border border-outline-variant bg-surface-container hover:border-outline cursor-pointer transition-all"><span class="text-[10px] font-bold uppercase opacity-60">T7</span><span class="text-lg font-bold">17</span><span class="text-[10px]">Th 06</span></div><div class="flex flex-col items-center min-w-[70px] py-3 rounded-xl border border-outline-variant bg-surface-container hover:border-outline cursor-pointer transition-all"><span class="text-[10px] font-bold uppercase opacity-60">CN</span><span class="text-lg font-bold">18</span><span class="text-[10px]">Th 06</span></div></div>
<!-- Time Slots -->
<div class="space-y-4"><div class="space-y-2"><h3 class="text-sm font-semibold text-on-surface-variant">Sáng</h3><div class="grid grid-cols-3 gap-2"><button class="py-3 rounded-lg border border-outline-variant bg-surface-container-high text-sm font-medium hover:bg-surface-bright transition-colors text-on-surface">08:00</button><button class="py-3 rounded-lg border text-sm font-bold bg-surface-container-high text-on-surface border-outline-variant">09:00</button><button class="py-3 rounded-lg border text-sm font-medium hover:bg-surface-bright transition-colors text-on-surface bg-primary text-on-primary border-primary shadow-lg shadow-primary/20">10:00</button><button class="py-3 rounded-lg border border-outline-variant bg-surface-container-low text-on-surface/30 text-sm cursor-not-allowed" disabled="">11:00</button></div></div><div class="space-y-2"><h3 class="text-sm font-semibold text-on-surface-variant">Chi?u</h3><div class="grid grid-cols-3 gap-2"><button class="py-3 rounded-lg border border-outline-variant bg-surface-container-high text-sm font-medium hover:bg-surface-bright transition-colors text-on-surface">14:00</button><button class="py-3 rounded-lg border border-outline-variant bg-surface-container-high text-sm font-medium hover:bg-surface-bright transition-colors text-on-surface">15:00</button><button class="py-3 rounded-lg border border-outline-variant bg-surface-container-high text-sm font-medium hover:bg-surface-bright transition-colors text-on-surface">16:00</button><button class="py-3 rounded-lg border border-outline-variant bg-surface-container-high text-sm font-medium hover:bg-surface-bright transition-colors text-on-surface">17:00</button></div></div></div>
</section><div class="pt-4">
<button class="w-full bg-primary text-on-primary py-4 rounded-xl font-bold font-display shadow-xl shadow-primary/30 hover:scale-[1.02] active:scale-[0.98] transition-all uppercase tracking-wider">
        Xác nh?n ??t l?ch
    </button>
</div>
<!-- Payment Method -->
</main>
<!-- Bottom Action Bar -->
<!-- Visual Polish: Atmospheric element -->
<div class="fixed top-1/4 -right-24 w-64 h-64 bg-primary/10 rounded-full blur-[120px] pointer-events-none"></div>
<div class="fixed bottom-1/4 -left-24 w-64 h-64 bg-secondary/10 rounded-full blur-[120px] pointer-events-none"></div>
<script>
        // Simple micro-interactions for time slots
        const timeButtons = document.querySelectorAll('button.py-3:not([disabled])');
        timeButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                timeButtons.forEach(b => {
                    b.classList.remove('bg-primary', 'text-on-primary', 'border-primary', 'shadow-lg', 'shadow-primary/20');
                    b.classList.add('bg-surface-container-high', 'text-on-surface', 'border-outline-variant');
                });
                btn.classList.add('bg-primary', 'text-on-primary', 'border-primary', 'shadow-lg', 'shadow-primary/20');
                btn.classList.remove('bg-surface-container-high', 'border-outline-variant');
            });
        });

        // Toggle service packs
        const serviceOptions = document.querySelectorAll('input[name="service"]');
        serviceOptions.forEach(radio => {
            radio.addEventListener('change', (e) => {
                // In a real app, this would update the total price in the footer
                const prices = { basic: "150.000?", premium: "350.000?", elite: "850.000?" };
                document.querySelector('footer .text-2xl').textContent = prices[e.target.value];
            });
        });
    </script>
</body></html>