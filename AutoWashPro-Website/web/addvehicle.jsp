<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html><html class="dark" lang="vi" style=""><head>
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
<style>.swal2-popup.swal2-toast{box-sizing:border-box;grid-column:1/4 !important;grid-row:1/4 !important;grid-template-columns:min-content auto min-content;padding:1em;overflow-y:hidden;background:#fff;box-shadow:0 0 1px rgba(0,0,0,.075),0 1px 2px rgba(0,0,0,.075),1px 2px 4px rgba(0,0,0,.075),1px 3px 8px rgba(0,0,0,.075),2px 4px 16px rgba(0,0,0,.075);pointer-events:all}.swal2-popup.swal2-toast>*{grid-column:2}.swal2-popup.swal2-toast .swal2-title{margin:.5em 1em;padding:0;font-size:1em;text-align:initial}.swal2-popup.swal2-toast .swal2-loading{justify-content:center}.swal2-popup.swal2-toast .swal2-input{height:2em;margin:.5em;font-size:1em}.swal2-popup.swal2-toast .swal2-validation-message{font-size:1em}.swal2-popup.swal2-toast .swal2-footer{margin:.5em 0 0;padding:.5em 0 0;font-size:.8em}.swal2-popup.swal2-toast .swal2-close{grid-column:3/3;grid-row:1/99;align-self:center;width:.8em;height:.8em;margin:0;font-size:2em}.swal2-popup.swal2-toast .swal2-html-container{margin:.5em 1em;padding:0;overflow:initial;font-size:1em;text-align:initial}.swal2-popup.swal2-toast .swal2-html-container:empty{padding:0}.swal2-popup.swal2-toast .swal2-loader{grid-column:1;grid-row:1/99;align-self:center;width:2em;height:2em;margin:.25em}.swal2-popup.swal2-toast .swal2-icon{grid-column:1;grid-row:1/99;align-self:center;width:2em;min-width:2em;height:2em;margin:0 .5em 0 0}.swal2-popup.swal2-toast .swal2-icon .swal2-icon-content{display:flex;align-items:center;font-size:1.8em;font-weight:bold}.swal2-popup.swal2-toast .swal2-icon.swal2-success .swal2-success-ring{width:2em;height:2em}.swal2-popup.swal2-toast .swal2-icon.swal2-error [class^=swal2-x-mark-line]{top:.875em;width:1.375em}.swal2-popup.swal2-toast .swal2-icon.swal2-error [class^=swal2-x-mark-line][class$=left]{left:.3125em}.swal2-popup.swal2-toast .swal2-icon.swal2-error [class^=swal2-x-mark-line][class$=right]{right:.3125em}.swal2-popup.swal2-toast .swal2-actions{justify-content:flex-start;height:auto;margin:0;margin-top:.5em;padding:0 .5em}.swal2-popup.swal2-toast .swal2-styled{margin:.25em .5em;padding:.4em .6em;font-size:1em}.swal2-popup.swal2-toast .swal2-success{border-color:#a5dc86}.swal2-popup.swal2-toast .swal2-success [class^=swal2-success-circular-line]{position:absolute;width:1.6em;height:3em;border-radius:50%}.swal2-popup.swal2-toast .swal2-success [class^=swal2-success-circular-line][class$=left]{top:-0.8em;left:-0.5em;transform:rotate(-45deg);transform-origin:2em 2em;border-radius:4em 0 0 4em}.swal2-popup.swal2-toast .swal2-success [class^=swal2-success-circular-line][class$=right]{top:-0.25em;left:.9375em;transform-origin:0 1.5em;border-radius:0 4em 4em 0}.swal2-popup.swal2-toast .swal2-success .swal2-success-ring{width:2em;height:2em}.swal2-popup.swal2-toast .swal2-success .swal2-success-fix{top:0;left:.4375em;width:.4375em;height:2.6875em}.swal2-popup.swal2-toast .swal2-success [class^=swal2-success-line]{height:.3125em}.swal2-popup.swal2-toast .swal2-success [class^=swal2-success-line][class$=tip]{top:1.125em;left:.1875em;width:.75em}.swal2-popup.swal2-toast .swal2-success [class^=swal2-success-line][class$=long]{top:.9375em;right:.1875em;width:1.375em}.swal2-popup.swal2-toast .swal2-success.swal2-icon-show .swal2-success-line-tip{animation:swal2-toast-animate-success-line-tip .75s}.swal2-popup.swal2-toast .swal2-success.swal2-icon-show .swal2-success-line-long{animation:swal2-toast-animate-success-line-long .75s}.swal2-popup.swal2-toast.swal2-show{animation:swal2-toast-show .5s}.swal2-popup.swal2-toast.swal2-hide{animation:swal2-toast-hide .1s forwards}div:where(.swal2-container){display:grid;position:fixed;z-index:1060;inset:0;box-sizing:border-box;grid-template-areas:"top-start     top            top-end" "center-start  center         center-end" "bottom-start  bottom-center  bottom-end";grid-template-rows:minmax(min-content, auto) minmax(min-content, auto) minmax(min-content, auto);height:100%;padding:.625em;overflow-x:hidden;transition:background-color .1s;-webkit-overflow-scrolling:touch}div:where(.swal2-container).swal2-backdrop-show,div:where(.swal2-container).swal2-noanimation{background:rgba(0,0,0,.4)}div:where(.swal2-container).swal2-backdrop-hide{background:rgba(0,0,0,0) !important}div:where(.swal2-container).swal2-top-start,div:where(.swal2-container).swal2-center-start,div:where(.swal2-container).swal2-bottom-start{grid-template-columns:minmax(0, 1fr) auto auto}div:where(.swal2-container).swal2-top,div:where(.swal2-container).swal2-center,div:where(.swal2-container).swal2-bottom{grid-template-columns:auto minmax(0, 1fr) auto}div:where(.swal2-container).swal2-top-end,div:where(.swal2-container).swal2-center-end,div:where(.swal2-container).swal2-bottom-end{grid-template-columns:auto auto minmax(0, 1fr)}div:where(.swal2-container).swal2-top-start>.swal2-popup{align-self:start}div:where(.swal2-container).swal2-top>.swal2-popup{grid-column:2;place-self:start center}div:where(.swal2-container).swal2-top-end>.swal2-popup,div:where(.swal2-container).swal2-top-right>.swal2-popup{grid-column:3;place-self:start end}div:where(.swal2-container).swal2-center-start>.swal2-popup,div:where(.swal2-container).swal2-center-left>.swal2-popup{grid-row:2;align-self:center}div:where(.swal2-container).swal2-center>.swal2-popup{grid-column:2;grid-row:2;place-self:center center}div:where(.swal2-container).swal2-center-end>.swal2-popup,div:where(.swal2-container).swal2-center-right>.swal2-popup{grid-column:3;grid-row:2;place-self:center end}div:where(.swal2-container).swal2-bottom-start>.swal2-popup,div:where(.swal2-container).swal2-bottom-left>.swal2-popup{grid-column:1;grid-row:3;align-self:end}div:where(.swal2-container).swal2-bottom>.swal2-popup{grid-column:2;grid-row:3;place-self:end center}div:where(.swal2-container).swal2-bottom-end>.swal2-popup,div:where(.swal2-container).swal2-bottom-right>.swal2-popup{grid-column:3;grid-row:3;place-self:end end}div:where(.swal2-container).swal2-grow-row>.swal2-popup,div:where(.swal2-container).swal2-grow-fullscreen>.swal2-popup{grid-column:1/4;width:100%}div:where(.swal2-container).swal2-grow-column>.swal2-popup,div:where(.swal2-container).swal2-grow-fullscreen>.swal2-popup{grid-row:1/4;align-self:stretch}div:where(.swal2-container).swal2-no-transition{transition:none !important}div:where(.swal2-container) div:where(.swal2-popup){display:none;position:relative;box-sizing:border-box;grid-template-columns:minmax(0, 100%);width:32em;max-width:100%;padding:0 0 1.25em;border:none;border-radius:5px;background:#fff;color:#545454;font-family:inherit;font-size:1rem}div:where(.swal2-container) div:where(.swal2-popup):focus{outline:none}div:where(.swal2-container) div:where(.swal2-popup).swal2-loading{overflow-y:hidden}div:where(.swal2-container) h2:where(.swal2-title){position:relative;max-width:100%;margin:0;padding:.8em 1em 0;color:inherit;font-size:1.875em;font-weight:600;text-align:center;text-transform:none;word-wrap:break-word}div:where(.swal2-container) div:where(.swal2-actions){display:flex;z-index:1;box-sizing:border-box;flex-wrap:wrap;align-items:center;justify-content:center;width:auto;margin:1.25em auto 0;padding:0}div:where(.swal2-container) div:where(.swal2-actions):not(.swal2-loading) .swal2-styled[disabled]{opacity:.4}div:where(.swal2-container) div:where(.swal2-actions):not(.swal2-loading) .swal2-styled:hover{background-image:linear-gradient(rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.1))}div:where(.swal2-container) div:where(.swal2-actions):not(.swal2-loading) .swal2-styled:active{background-image:linear-gradient(rgba(0, 0, 0, 0.2), rgba(0, 0, 0, 0.2))}div:where(.swal2-container) div:where(.swal2-loader){display:none;align-items:center;justify-content:center;width:2.2em;height:2.2em;margin:0 1.875em;animation:swal2-rotate-loading 1.5s linear 0s infinite normal;border-width:.25em;border-style:solid;border-radius:100%;border-color:#2778c4 rgba(0,0,0,0) #2778c4 rgba(0,0,0,0)}div:where(.swal2-container) button:where(.swal2-styled){margin:.3125em;padding:.625em 1.1em;transition:box-shadow .1s;box-shadow:0 0 0 3px rgba(0,0,0,0);font-weight:500}div:where(.swal2-container) button:where(.swal2-styled):not([disabled]){cursor:pointer}div:where(.swal2-container) button:where(.swal2-styled).swal2-confirm{border:0;border-radius:.25em;background:initial;background-color:#7066e0;color:#fff;font-size:1em}div:where(.swal2-container) button:where(.swal2-styled).swal2-confirm:focus{box-shadow:0 0 0 3px rgba(112,102,224,.5)}div:where(.swal2-container) button:where(.swal2-styled).swal2-deny{border:0;border-radius:.25em;background:initial;background-color:#dc3741;color:#fff;font-size:1em}div:where(.swal2-container) button:where(.swal2-styled).swal2-deny:focus{box-shadow:0 0 0 3px rgba(220,55,65,.5)}div:where(.swal2-container) button:where(.swal2-styled).swal2-cancel{border:0;border-radius:.25em;background:initial;background-color:#6e7881;color:#fff;font-size:1em}div:where(.swal2-container) button:where(.swal2-styled).swal2-cancel:focus{box-shadow:0 0 0 3px rgba(110,120,129,.5)}div:where(.swal2-container) button:where(.swal2-styled).swal2-default-outline:focus{box-shadow:0 0 0 3px rgba(100,150,200,.5)}div:where(.swal2-container) button:where(.swal2-styled):focus{outline:none}div:where(.swal2-container) button:where(.swal2-styled)::-moz-focus-inner{border:0}div:where(.swal2-container) div:where(.swal2-footer){margin:1em 0 0;padding:1em 1em 0;border-top:1px solid #eee;color:inherit;font-size:1em;text-align:center}div:where(.swal2-container) .swal2-timer-progress-bar-container{position:absolute;right:0;bottom:0;left:0;grid-column:auto !important;overflow:hidden;border-bottom-right-radius:5px;border-bottom-left-radius:5px}div:where(.swal2-container) div:where(.swal2-timer-progress-bar){width:100%;height:.25em;background:rgba(0,0,0,.2)}div:where(.swal2-container) img:where(.swal2-image){max-width:100%;margin:2em auto 1em}div:where(.swal2-container) button:where(.swal2-close){z-index:2;align-items:center;justify-content:center;width:1.2em;height:1.2em;margin-top:0;margin-right:0;margin-bottom:-1.2em;padding:0;overflow:hidden;transition:color .1s,box-shadow .1s;border:none;border-radius:5px;background:rgba(0,0,0,0);color:#ccc;font-family:monospace;font-size:2.5em;cursor:pointer;justify-self:end}div:where(.swal2-container) button:where(.swal2-close):hover{transform:none;background:rgba(0,0,0,0);color:#f27474}div:where(.swal2-container) button:where(.swal2-close):focus{outline:none;box-shadow:inset 0 0 0 3px rgba(100,150,200,.5)}div:where(.swal2-container) button:where(.swal2-close)::-moz-focus-inner{border:0}div:where(.swal2-container) .swal2-html-container{z-index:1;justify-content:center;margin:1em 1.6em .3em;padding:0;overflow:auto;color:inherit;font-size:1.125em;font-weight:normal;line-height:normal;text-align:center;word-wrap:break-word;word-break:break-word}div:where(.swal2-container) input:where(.swal2-input),div:where(.swal2-container) input:where(.swal2-file),div:where(.swal2-container) textarea:where(.swal2-textarea),div:where(.swal2-container) select:where(.swal2-select),div:where(.swal2-container) div:where(.swal2-radio),div:where(.swal2-container) label:where(.swal2-checkbox){margin:1em 2em 3px}div:where(.swal2-container) input:where(.swal2-input),div:where(.swal2-container) input:where(.swal2-file),div:where(.swal2-container) textarea:where(.swal2-textarea){box-sizing:border-box;width:auto;transition:border-color .1s,box-shadow .1s;border:1px solid #d9d9d9;border-radius:.1875em;background:rgba(0,0,0,0);box-shadow:inset 0 1px 1px rgba(0,0,0,.06),0 0 0 3px rgba(0,0,0,0);color:inherit;font-size:1.125em}div:where(.swal2-container) input:where(.swal2-input).swal2-inputerror,div:where(.swal2-container) input:where(.swal2-file).swal2-inputerror,div:where(.swal2-container) textarea:where(.swal2-textarea).swal2-inputerror{border-color:#f27474 !important;box-shadow:0 0 2px #f27474 !important}div:where(.swal2-container) input:where(.swal2-input):focus,div:where(.swal2-container) input:where(.swal2-file):focus,div:where(.swal2-container) textarea:where(.swal2-textarea):focus{border:1px solid #b4dbed;outline:none;box-shadow:inset 0 1px 1px rgba(0,0,0,.06),0 0 0 3px rgba(100,150,200,.5)}div:where(.swal2-container) input:where(.swal2-input)::placeholder,div:where(.swal2-container) input:where(.swal2-file)::placeholder,div:where(.swal2-container) textarea:where(.swal2-textarea)::placeholder{color:#ccc}div:where(.swal2-container) .swal2-range{margin:1em 2em 3px;background:#fff}div:where(.swal2-container) .swal2-range input{width:80%}div:where(.swal2-container) .swal2-range output{width:20%;color:inherit;font-weight:600;text-align:center}div:where(.swal2-container) .swal2-range input,div:where(.swal2-container) .swal2-range output{height:2.625em;padding:0;font-size:1.125em;line-height:2.625em}div:where(.swal2-container) .swal2-input{height:2.625em;padding:0 .75em}div:where(.swal2-container) .swal2-file{width:75%;margin-right:auto;margin-left:auto;background:rgba(0,0,0,0);font-size:1.125em}div:where(.swal2-container) .swal2-textarea{height:6.75em;padding:.75em}div:where(.swal2-container) .swal2-select{min-width:50%;max-width:100%;padding:.375em .625em;background:rgba(0,0,0,0);color:inherit;font-size:1.125em}div:where(.swal2-container) .swal2-radio,div:where(.swal2-container) .swal2-checkbox{align-items:center;justify-content:center;background:#fff;color:inherit}div:where(.swal2-container) .swal2-radio label,div:where(.swal2-container) .swal2-checkbox label{margin:0 .6em;font-size:1.125em}div:where(.swal2-container) .swal2-radio input,div:where(.swal2-container) .swal2-checkbox input{flex-shrink:0;margin:0 .4em}div:where(.swal2-container) label:where(.swal2-input-label){display:flex;justify-content:center;margin:1em auto 0}div:where(.swal2-container) div:where(.swal2-validation-message){align-items:center;justify-content:center;margin:1em 0 0;padding:.625em;overflow:hidden;background:#f0f0f0;color:#666;font-size:1em;font-weight:300}div:where(.swal2-container) div:where(.swal2-validation-message)::before{content:"!";display:inline-block;width:1.5em;min-width:1.5em;height:1.5em;margin:0 .625em;border-radius:50%;background-color:#f27474;color:#fff;font-weight:600;line-height:1.5em;text-align:center}div:where(.swal2-container) .swal2-progress-steps{flex-wrap:wrap;align-items:center;max-width:100%;margin:1.25em auto;padding:0;background:rgba(0,0,0,0);font-weight:600}div:where(.swal2-container) .swal2-progress-steps li{display:inline-block;position:relative}div:where(.swal2-container) .swal2-progress-steps .swal2-progress-step{z-index:20;flex-shrink:0;width:2em;height:2em;border-radius:2em;background:#2778c4;color:#fff;line-height:2em;text-align:center}div:where(.swal2-container) .swal2-progress-steps .swal2-progress-step.swal2-active-progress-step{background:#2778c4}div:where(.swal2-container) .swal2-progress-steps .swal2-progress-step.swal2-active-progress-step~.swal2-progress-step{background:#add8e6;color:#fff}div:where(.swal2-container) .swal2-progress-steps .swal2-progress-step.swal2-active-progress-step~.swal2-progress-step-line{background:#add8e6}div:where(.swal2-container) .swal2-progress-steps .swal2-progress-step-line{z-index:10;flex-shrink:0;width:2.5em;height:.4em;margin:0 -1px;background:#2778c4}div:where(.swal2-icon){position:relative;box-sizing:content-box;justify-content:center;width:5em;height:5em;margin:2.5em auto .6em;border:0.25em solid rgba(0,0,0,0);border-radius:50%;border-color:#000;font-family:inherit;line-height:5em;cursor:default;user-select:none}div:where(.swal2-icon) .swal2-icon-content{display:flex;align-items:center;font-size:3.75em}div:where(.swal2-icon).swal2-error{border-color:#f27474;color:#f27474}div:where(.swal2-icon).swal2-error .swal2-x-mark{position:relative;flex-grow:1}div:where(.swal2-icon).swal2-error [class^=swal2-x-mark-line]{display:block;position:absolute;top:2.3125em;width:2.9375em;height:.3125em;border-radius:.125em;background-color:#f27474}div:where(.swal2-icon).swal2-error [class^=swal2-x-mark-line][class$=left]{left:1.0625em;transform:rotate(45deg)}div:where(.swal2-icon).swal2-error [class^=swal2-x-mark-line][class$=right]{right:1em;transform:rotate(-45deg)}div:where(.swal2-icon).swal2-error.swal2-icon-show{animation:swal2-animate-error-icon .5s}div:where(.swal2-icon).swal2-error.swal2-icon-show .swal2-x-mark{animation:swal2-animate-error-x-mark .5s}div:where(.swal2-icon).swal2-warning{border-color:#facea8;color:#f8bb86}div:where(.swal2-icon).swal2-warning.swal2-icon-show{animation:swal2-animate-error-icon .5s}div:where(.swal2-icon).swal2-warning.swal2-icon-show .swal2-icon-content{animation:swal2-animate-i-mark .5s}div:where(.swal2-icon).swal2-info{border-color:#9de0f6;color:#3fc3ee}div:where(.swal2-icon).swal2-info.swal2-icon-show{animation:swal2-animate-error-icon .5s}div:where(.swal2-icon).swal2-info.swal2-icon-show .swal2-icon-content{animation:swal2-animate-i-mark .8s}div:where(.swal2-icon).swal2-question{border-color:#c9dae1;color:#87adbd}div:where(.swal2-icon).swal2-question.swal2-icon-show{animation:swal2-animate-error-icon .5s}div:where(.swal2-icon).swal2-question.swal2-icon-show .swal2-icon-content{animation:swal2-animate-question-mark .8s}div:where(.swal2-icon).swal2-success{border-color:#a5dc86;color:#a5dc86}div:where(.swal2-icon).swal2-success [class^=swal2-success-circular-line]{position:absolute;width:3.75em;height:7.5em;border-radius:50%}div:where(.swal2-icon).swal2-success [class^=swal2-success-circular-line][class$=left]{top:-0.4375em;left:-2.0635em;transform:rotate(-45deg);transform-origin:3.75em 3.75em;border-radius:7.5em 0 0 7.5em}div:where(.swal2-icon).swal2-success [class^=swal2-success-circular-line][class$=right]{top:-0.6875em;left:1.875em;transform:rotate(-45deg);transform-origin:0 3.75em;border-radius:0 7.5em 7.5em 0}div:where(.swal2-icon).swal2-success .swal2-success-ring{position:absolute;z-index:2;top:-0.25em;left:-0.25em;box-sizing:content-box;width:100%;height:100%;border:.25em solid rgba(165,220,134,.3);border-radius:50%}div:where(.swal2-icon).swal2-success .swal2-success-fix{position:absolute;z-index:1;top:.5em;left:1.625em;width:.4375em;height:5.625em;transform:rotate(-45deg)}div:where(.swal2-icon).swal2-success [class^=swal2-success-line]{display:block;position:absolute;z-index:2;height:.3125em;border-radius:.125em;background-color:#a5dc86}div:where(.swal2-icon).swal2-success [class^=swal2-success-line][class$=tip]{top:2.875em;left:.8125em;width:1.5625em;transform:rotate(45deg)}div:where(.swal2-icon).swal2-success [class^=swal2-success-line][class$=long]{top:2.375em;right:.5em;width:2.9375em;transform:rotate(-45deg)}div:where(.swal2-icon).swal2-success.swal2-icon-show .swal2-success-line-tip{animation:swal2-animate-success-line-tip .75s}div:where(.swal2-icon).swal2-success.swal2-icon-show .swal2-success-line-long{animation:swal2-animate-success-line-long .75s}div:where(.swal2-icon).swal2-success.swal2-icon-show .swal2-success-circular-line-right{animation:swal2-rotate-success-circular-line 4.25s ease-in}[class^=swal2]{-webkit-tap-highlight-color:rgba(0,0,0,0)}.swal2-show{animation:swal2-show .3s}.swal2-hide{animation:swal2-hide .15s forwards}.swal2-noanimation{transition:none}.swal2-scrollbar-measure{position:absolute;top:-9999px;width:50px;height:50px;overflow:scroll}.swal2-rtl .swal2-close{margin-right:initial;margin-left:0}.swal2-rtl .swal2-timer-progress-bar{right:0;left:auto}@keyframes swal2-toast-show{0%{transform:translateY(-0.625em) rotateZ(2deg)}33%{transform:translateY(0) rotateZ(-2deg)}66%{transform:translateY(0.3125em) rotateZ(2deg)}100%{transform:translateY(0) rotateZ(0deg)}}@keyframes swal2-toast-hide{100%{transform:rotateZ(1deg);opacity:0}}@keyframes swal2-toast-animate-success-line-tip{0%{top:.5625em;left:.0625em;width:0}54%{top:.125em;left:.125em;width:0}70%{top:.625em;left:-0.25em;width:1.625em}84%{top:1.0625em;left:.75em;width:.5em}100%{top:1.125em;left:.1875em;width:.75em}}@keyframes swal2-toast-animate-success-line-long{0%{top:1.625em;right:1.375em;width:0}65%{top:1.25em;right:.9375em;width:0}84%{top:.9375em;right:0;width:1.125em}100%{top:.9375em;right:.1875em;width:1.375em}}@keyframes swal2-show{0%{transform:scale(0.7)}45%{transform:scale(1.05)}80%{transform:scale(0.95)}100%{transform:scale(1)}}@keyframes swal2-hide{0%{transform:scale(1);opacity:1}100%{transform:scale(0.5);opacity:0}}@keyframes swal2-animate-success-line-tip{0%{top:1.1875em;left:.0625em;width:0}54%{top:1.0625em;left:.125em;width:0}70%{top:2.1875em;left:-0.375em;width:3.125em}84%{top:3em;left:1.3125em;width:1.0625em}100%{top:2.8125em;left:.8125em;width:1.5625em}}@keyframes swal2-animate-success-line-long{0%{top:3.375em;right:2.875em;width:0}65%{top:3.375em;right:2.875em;width:0}84%{top:2.1875em;right:0;width:3.4375em}100%{top:2.375em;right:.5em;width:2.9375em}}@keyframes swal2-rotate-success-circular-line{0%{transform:rotate(-45deg)}5%{transform:rotate(-45deg)}12%{transform:rotate(-405deg)}100%{transform:rotate(-405deg)}}@keyframes swal2-animate-error-x-mark{0%{margin-top:1.625em;transform:scale(0.4);opacity:0}50%{margin-top:1.625em;transform:scale(0.4);opacity:0}80%{margin-top:-0.375em;transform:scale(1.15)}100%{margin-top:0;transform:scale(1);opacity:1}}@keyframes swal2-animate-error-icon{0%{transform:rotateX(100deg);opacity:0}100%{transform:rotateX(0deg);opacity:1}}@keyframes swal2-rotate-loading{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}@keyframes swal2-animate-question-mark{0%{transform:rotateY(-360deg)}100%{transform:rotateY(0)}}@keyframes swal2-animate-i-mark{0%{transform:rotateZ(45deg);opacity:0}25%{transform:rotateZ(-25deg);opacity:.4}50%{transform:rotateZ(15deg);opacity:.8}75%{transform:rotateZ(-5deg);opacity:1}100%{transform:rotateX(0);opacity:1}}body.swal2-shown:not(.swal2-no-backdrop):not(.swal2-toast-shown){overflow:hidden}body.swal2-height-auto{height:auto !important}body.swal2-no-backdrop .swal2-container{background-color:rgba(0,0,0,0) !important;pointer-events:none}body.swal2-no-backdrop .swal2-container .swal2-popup{pointer-events:all}body.swal2-no-backdrop .swal2-container .swal2-modal{box-shadow:0 0 10px rgba(0,0,0,.4)}@media print{body.swal2-shown:not(.swal2-no-backdrop):not(.swal2-toast-shown){overflow-y:scroll !important}body.swal2-shown:not(.swal2-no-backdrop):not(.swal2-toast-shown)>[aria-hidden=true]{display:none}body.swal2-shown:not(.swal2-no-backdrop):not(.swal2-toast-shown) .swal2-container{position:static !important}}body.swal2-toast-shown .swal2-container{box-sizing:border-box;width:360px;max-width:100%;background-color:rgba(0,0,0,0);pointer-events:none}body.swal2-toast-shown .swal2-container.swal2-top{inset:0 auto auto 50%;transform:translateX(-50%)}body.swal2-toast-shown .swal2-container.swal2-top-end,body.swal2-toast-shown .swal2-container.swal2-top-right{inset:0 0 auto auto}body.swal2-toast-shown .swal2-container.swal2-top-start,body.swal2-toast-shown .swal2-container.swal2-top-left{inset:0 auto auto 0}body.swal2-toast-shown .swal2-container.swal2-center-start,body.swal2-toast-shown .swal2-container.swal2-center-left{inset:50% auto auto 0;transform:translateY(-50%)}body.swal2-toast-shown .swal2-container.swal2-center{inset:50% auto auto 50%;transform:translate(-50%, -50%)}body.swal2-toast-shown .swal2-container.swal2-center-end,body.swal2-toast-shown .swal2-container.swal2-center-right{inset:50% 0 auto auto;transform:translateY(-50%)}body.swal2-toast-shown .swal2-container.swal2-bottom-start,body.swal2-toast-shown .swal2-container.swal2-bottom-left{inset:auto auto 0 0}body.swal2-toast-shown .swal2-container.swal2-bottom{inset:auto auto 0 50%;transform:translateX(-50%)}body.swal2-toast-shown .swal2-container.swal2-bottom-end,body.swal2-toast-shown .swal2-container.swal2-bottom-right{inset:auto 0 0 auto}</style><style type="text/css">.__react_component_tooltip {
  border-radius: 3px;
  display: inline-block;
  font-size: 13px;
  left: -999em;
  opacity: 0;
  padding: 8px 21px;
  position: fixed;
  pointer-events: none;
  transition: opacity 0.3s ease-out;
  top: -999em;
  visibility: hidden;
  z-index: 999;
}
.__react_component_tooltip.allow_hover, .__react_component_tooltip.allow_click {
  pointer-events: auto;
}
.__react_component_tooltip:before, .__react_component_tooltip:after {
  content: "";
  width: 0;
  height: 0;
  position: absolute;
}
.__react_component_tooltip.show {
  opacity: 0.9;
  margin-top: 0px;
  margin-left: 0px;
  visibility: visible;
}
.__react_component_tooltip.type-dark {
  color: #fff;
  background-color: #222;
}
.__react_component_tooltip.type-dark.place-top:after {
  border-top-color: #222;
  border-top-style: solid;
  border-top-width: 6px;
}
.__react_component_tooltip.type-dark.place-bottom:after {
  border-bottom-color: #222;
  border-bottom-style: solid;
  border-bottom-width: 6px;
}
.__react_component_tooltip.type-dark.place-left:after {
  border-left-color: #222;
  border-left-style: solid;
  border-left-width: 6px;
}
.__react_component_tooltip.type-dark.place-right:after {
  border-right-color: #222;
  border-right-style: solid;
  border-right-width: 6px;
}
.__react_component_tooltip.type-dark.border {
  border: 1px solid #fff;
}
.__react_component_tooltip.type-dark.border.place-top:before {
  border-top: 8px solid #fff;
}
.__react_component_tooltip.type-dark.border.place-bottom:before {
  border-bottom: 8px solid #fff;
}
.__react_component_tooltip.type-dark.border.place-left:before {
  border-left: 8px solid #fff;
}
.__react_component_tooltip.type-dark.border.place-right:before {
  border-right: 8px solid #fff;
}
.__react_component_tooltip.type-success {
  color: #fff;
  background-color: #8DC572;
}
.__react_component_tooltip.type-success.place-top:after {
  border-top-color: #8DC572;
  border-top-style: solid;
  border-top-width: 6px;
}
.__react_component_tooltip.type-success.place-bottom:after {
  border-bottom-color: #8DC572;
  border-bottom-style: solid;
  border-bottom-width: 6px;
}
.__react_component_tooltip.type-success.place-left:after {
  border-left-color: #8DC572;
  border-left-style: solid;
  border-left-width: 6px;
}
.__react_component_tooltip.type-success.place-right:after {
  border-right-color: #8DC572;
  border-right-style: solid;
  border-right-width: 6px;
}
.__react_component_tooltip.type-success.border {
  border: 1px solid #fff;
}
.__react_component_tooltip.type-success.border.place-top:before {
  border-top: 8px solid #fff;
}
.__react_component_tooltip.type-success.border.place-bottom:before {
  border-bottom: 8px solid #fff;
}
.__react_component_tooltip.type-success.border.place-left:before {
  border-left: 8px solid #fff;
}
.__react_component_tooltip.type-success.border.place-right:before {
  border-right: 8px solid #fff;
}
.__react_component_tooltip.type-warning {
  color: #fff;
  background-color: #F0AD4E;
}
.__react_component_tooltip.type-warning.place-top:after {
  border-top-color: #F0AD4E;
  border-top-style: solid;
  border-top-width: 6px;
}
.__react_component_tooltip.type-warning.place-bottom:after {
  border-bottom-color: #F0AD4E;
  border-bottom-style: solid;
  border-bottom-width: 6px;
}
.__react_component_tooltip.type-warning.place-left:after {
  border-left-color: #F0AD4E;
  border-left-style: solid;
  border-left-width: 6px;
}
.__react_component_tooltip.type-warning.place-right:after {
  border-right-color: #F0AD4E;
  border-right-style: solid;
  border-right-width: 6px;
}
.__react_component_tooltip.type-warning.border {
  border: 1px solid #fff;
}
.__react_component_tooltip.type-warning.border.place-top:before {
  border-top: 8px solid #fff;
}
.__react_component_tooltip.type-warning.border.place-bottom:before {
  border-bottom: 8px solid #fff;
}
.__react_component_tooltip.type-warning.border.place-left:before {
  border-left: 8px solid #fff;
}
.__react_component_tooltip.type-warning.border.place-right:before {
  border-right: 8px solid #fff;
}
.__react_component_tooltip.type-error {
  color: #fff;
  background-color: #BE6464;
}
.__react_component_tooltip.type-error.place-top:after {
  border-top-color: #BE6464;
  border-top-style: solid;
  border-top-width: 6px;
}
.__react_component_tooltip.type-error.place-bottom:after {
  border-bottom-color: #BE6464;
  border-bottom-style: solid;
  border-bottom-width: 6px;
}
.__react_component_tooltip.type-error.place-left:after {
  border-left-color: #BE6464;
  border-left-style: solid;
  border-left-width: 6px;
}
.__react_component_tooltip.type-error.place-right:after {
  border-right-color: #BE6464;
  border-right-style: solid;
  border-right-width: 6px;
}
.__react_component_tooltip.type-error.border {
  border: 1px solid #fff;
}
.__react_component_tooltip.type-error.border.place-top:before {
  border-top: 8px solid #fff;
}
.__react_component_tooltip.type-error.border.place-bottom:before {
  border-bottom: 8px solid #fff;
}
.__react_component_tooltip.type-error.border.place-left:before {
  border-left: 8px solid #fff;
}
.__react_component_tooltip.type-error.border.place-right:before {
  border-right: 8px solid #fff;
}
.__react_component_tooltip.type-info {
  color: #fff;
  background-color: #337AB7;
}
.__react_component_tooltip.type-info.place-top:after {
  border-top-color: #337AB7;
  border-top-style: solid;
  border-top-width: 6px;
}
.__react_component_tooltip.type-info.place-bottom:after {
  border-bottom-color: #337AB7;
  border-bottom-style: solid;
  border-bottom-width: 6px;
}
.__react_component_tooltip.type-info.place-left:after {
  border-left-color: #337AB7;
  border-left-style: solid;
  border-left-width: 6px;
}
.__react_component_tooltip.type-info.place-right:after {
  border-right-color: #337AB7;
  border-right-style: solid;
  border-right-width: 6px;
}
.__react_component_tooltip.type-info.border {
  border: 1px solid #fff;
}
.__react_component_tooltip.type-info.border.place-top:before {
  border-top: 8px solid #fff;
}
.__react_component_tooltip.type-info.border.place-bottom:before {
  border-bottom: 8px solid #fff;
}
.__react_component_tooltip.type-info.border.place-left:before {
  border-left: 8px solid #fff;
}
.__react_component_tooltip.type-info.border.place-right:before {
  border-right: 8px solid #fff;
}
.__react_component_tooltip.type-light {
  color: #222;
  background-color: #fff;
}
.__react_component_tooltip.type-light.place-top:after {
  border-top-color: #fff;
  border-top-style: solid;
  border-top-width: 6px;
}
.__react_component_tooltip.type-light.place-bottom:after {
  border-bottom-color: #fff;
  border-bottom-style: solid;
  border-bottom-width: 6px;
}
.__react_component_tooltip.type-light.place-left:after {
  border-left-color: #fff;
  border-left-style: solid;
  border-left-width: 6px;
}
.__react_component_tooltip.type-light.place-right:after {
  border-right-color: #fff;
  border-right-style: solid;
  border-right-width: 6px;
}
.__react_component_tooltip.type-light.border {
  border: 1px solid #222;
}
.__react_component_tooltip.type-light.border.place-top:before {
  border-top: 8px solid #222;
}
.__react_component_tooltip.type-light.border.place-bottom:before {
  border-bottom: 8px solid #222;
}
.__react_component_tooltip.type-light.border.place-left:before {
  border-left: 8px solid #222;
}
.__react_component_tooltip.type-light.border.place-right:before {
  border-right: 8px solid #222;
}
.__react_component_tooltip.place-top {
  margin-top: -10px;
}
.__react_component_tooltip.place-top:before {
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  bottom: -8px;
  left: 50%;
  margin-left: -10px;
}
.__react_component_tooltip.place-top:after {
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  bottom: -6px;
  left: 50%;
  margin-left: -8px;
}
.__react_component_tooltip.place-bottom {
  margin-top: 10px;
}
.__react_component_tooltip.place-bottom:before {
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  top: -8px;
  left: 50%;
  margin-left: -10px;
}
.__react_component_tooltip.place-bottom:after {
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  top: -6px;
  left: 50%;
  margin-left: -8px;
}
.__react_component_tooltip.place-left {
  margin-left: -10px;
}
.__react_component_tooltip.place-left:before {
  border-top: 6px solid transparent;
  border-bottom: 6px solid transparent;
  right: -8px;
  top: 50%;
  margin-top: -5px;
}
.__react_component_tooltip.place-left:after {
  border-top: 5px solid transparent;
  border-bottom: 5px solid transparent;
  right: -6px;
  top: 50%;
  margin-top: -4px;
}
.__react_component_tooltip.place-right {
  margin-left: 10px;
}
.__react_component_tooltip.place-right:before {
  border-top: 6px solid transparent;
  border-bottom: 6px solid transparent;
  left: -8px;
  top: 50%;
  margin-top: -5px;
}
.__react_component_tooltip.place-right:after {
  border-top: 5px solid transparent;
  border-bottom: 5px solid transparent;
  left: -6px;
  top: 50%;
  margin-top: -4px;
}
.__react_component_tooltip .multi-line {
  display: block;
  padding: 2px 0px;
  text-align: center;
}</style><style id="spin-keyframes">
  @keyframes spin {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }
</style><style>
      .ejoy-sub-active{
        color: #1296ba !important;
      }
      
      .ejoy-sub-hovered{
        color: #1296ba !important;
      }
      .ejoy-sub-clzz{
        cursor: pointer;
        
        lineHeight: 1.2;
          font-size: 28px;
          color: #FFCC00; background: rgba(17, 17, 17, 0.7);
        
      }
      .ejoy-sub-clzz:hover{
        color: #1296ba !important;
      }
      .ej-trans-sub{
        position: absolute;
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999999;
        cursor: move;
      }
      .ej-trans-sub > span{
        color: #3CF9ED;
        font-size: 18px;
        text-align: center;
        padding: 0 16px;
        line-height: 1.5;
        background: rgba(32, 26, 25, 0.8);
        // text-shadow: 0px 1px 4px black;
        padding: 0 8px;
        
        lineHeight: 1.2;
        font-size: 16px;
        color: #0CB1C7; background: rgba(67, 65, 65, 0.7);
      
      }
      .ej-full-screen-video{
        position: absolute;
        width: 30px;
        height: 30px;
        top: 30px;
        right: 10px;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 99999999;
        cursor: pointer;
      }
      .ej-main-sub{
        position: absolute;
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 99999999;
        cursor: move;
        padding: 0 8px;
      }
      .ej-main-sub > span{
        color: white;
        font-size: 20px;
        line-height: 1.5;
        text-align: center;
        background: rgba(32, 26, 25, 0.8);
        padding: 2px 8px;
        
        lineHeight: 1.2;
          font-size: 28px;
          color: #FFCC00; background: rgba(17, 17, 17, 0.7);
        
      }

      .ej-main-sub .ejoy-sub-clzz{
        background: transparent !important
      }

      .tran-subtitle > span{
        cursor: pointer;
        padding-left: 10px;
        top: 2px;
        position: relative;
      }

      .tran-subtitle > span > span{
        position: absolute;
        top: -170%;
        background: rgba(0,0,0,0.5);
        font-size: 13px;
        line-height: 20px;
        padding: 2px 8px;
        color: white;
        display: none;
        border-radius: 4px;
        white-space: nowrap;
        left: -50%;
        font-weight: normal;
      }

      .viewPopupPro {
        z-index: 2147483647;
        cursor: auto;
        position: absolute;
        z-index: 2147483647;
        background: #111111;
        transition: opacity 1s;
        width: 172px;
        height: 66px;
        opacity: 1;
        border-radius: 6px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }

      .titlePopupPro {
        font-style: normal;
        font-weight: 400;
        font-size: 10px;
        line-height: 12px;
        color: #E5E5E5;
        text-shadow: 0px 3px 3px rgba(0, 0, 0, 0.25);
      }
  
      .viewGoPro {
        background: #FFCC00;
        border-radius: 72.6257px;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 8px;
        padding-left: 10px;
        cursor: pointer;
  
      }

      .viewGoPro svg {
        pointer-events: none;
      }
      
      .textGoPro {
        font-style: normal;
        font-weight: 600;
        font-size: 10px;
        line-height: 12px;
        pointer-events: none;
        text-align: center;
        color: #FFFFFF;
        padding: 4px 14px 4px 4px;
      }

      .viewPopupPro{
        top: auto !important;
        bottom: 15px !important;
      }

      .view-icon-copy-main-sub:hover > span,
      .view-icon-edit-sub:hover > span,
      .view-icon-exit-full-sub:hover > span,
      .view-icon-full-sub:hover > span,
      .iconCrownGoPro:hover > span,
      .view-icon-copy-tran-sub:hover > span {
        display: block;
      }

      .iconCrownGoPro{
        padding-left: 0px !important;
        padding-right: 8px !important;
      }
      .iconCrownGoPro svg{
        width: 17px;
        height: 17px;
      }
      .view-icon-full-sub, .view-icon-exit-full-sub {
        display: flex;
      }

      .view-icon-full-sub > svg, .view-icon-exit-full-sub > svg {
        pointer-events: none;
      }

      .tran-subtitle > span > svg{
        width: 16px;
        height: 16px;
        pointer-events: none;
        display: inline-flex !important;
        vertical-align: baseline !important;
      }
      
      .view-icon-copy-main-sub > svg{
        pointer-events: none;
        color: #FFCC00
      }

      .iconCrownGoPro{
        padding-left: 0 !important;
        padding-right: 8px !important;
      }
      .view-icon-copy-tran-sub > svg{
        pointer-events: none;
        color: #0CB1C7
      }
      </style></head>
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