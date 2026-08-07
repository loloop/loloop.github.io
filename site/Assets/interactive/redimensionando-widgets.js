// Interactive widgets for the "Resizing iOS Apps" article.
// Vanilla JS, no dependencies. Widgets are mounted into
// <div class="rz-widget" data-widget="..." data-lang="en|br"></div>
(function () {
  "use strict";

  var STRINGS = {
    en: {
      dragCorner: "Drag the corner to resize the window",
      dragHandle: "Drag the handle to resize",
      horizontal: "horizontal",
      vertical: "vertical",
      share: "Share",
      favorite: "Favorite",
      save: "Save",
      remove: "Delete",
      vtfLabels: "HStack with labels",
      vtfIcons: "HStack, icons only",
      vtfMenu: "Menu",
      vtfPicked: "ViewThatFits picked:",
      width: "width",
      oneCol: "one column",
      twoCol: "two columns",
      threeCol: "three columns",
      layout: "layout",
      now: "Now",
      hourly: "Hourly",
      tenDay: "10-Day",
      air: "Air Quality",
      wind: "Wind",
      uv: "UV Index",
      good: "Good",
      moderate: "Moderate",
      fluid: "fluid resizing",
      discrete: "discrete resizing",
      releaseToApply: "release to apply the new size",
      mirroring: "iPhone Mirroring",
      sameInterface: "The interface does not change. The traits do."
    },
    br: {
      dragCorner: "Arraste o canto para redimensionar a janela",
      dragHandle: "Arraste a alça para redimensionar",
      horizontal: "horizontal",
      vertical: "vertical",
      share: "Compartilhar",
      favorite: "Favoritar",
      save: "Salvar",
      remove: "Apagar",
      vtfLabels: "HStack com textos",
      vtfIcons: "HStack, só ícones",
      vtfMenu: "Menu",
      vtfPicked: "O ViewThatFits escolheu:",
      width: "largura",
      oneCol: "uma coluna",
      twoCol: "duas colunas",
      threeCol: "três colunas",
      layout: "layout",
      now: "Agora",
      hourly: "Por hora",
      tenDay: "10 dias",
      air: "Qualidade do ar",
      wind: "Vento",
      uv: "Índice UV",
      good: "Boa",
      moderate: "Moderado",
      fluid: "redimensionamento fluido",
      discrete: "redimensionamento discreto",
      releaseToApply: "solte para aplicar o novo tamanho",
      mirroring: "Espelhamento de iPhone",
      sameInterface: "A interface não muda. Os traits sim."
    }
  };

  var CSS = "" +
    // width:100% matters: the article is a flex column, so a plain div would
    // shrink-to-fit its content instead of filling the text column.
    ".rz-widget{margin:24px auto;width:100%;max-width:600px;border-radius:12px;padding:16px;" +
    "background:#fafafa;font-family:Rubik,-apple-system,sans-serif;" +
    "-webkit-user-select:none;user-select:none}" +
    ".rz-widget,.rz-widget *{box-sizing:border-box}" +
    ".rz-hint{font-size:12px;color:#555;text-align:center;margin:0 0 12px}" +
    // The site styles svg path/circle fills globally; win back our stroked icons.
    ".rz-widget svg path{fill:none}" +
    ".rz-widget svg circle{fill:none}" +
    ".rz-widget svg .rz-dot{fill:currentColor;stroke:none}" +
    ".rz-stage{position:relative;border:1.5px solid rgba(0,0,0,.15);border-radius:10px;" +
    "overflow:hidden;background:rgba(0,0,0,.03)}" +
    ".rz-win{position:relative;background:#fff;border:1.5px solid rgba(0,0,0,.2);" +
    "border-radius:8px;box-shadow:0 4px 14px rgba(0,0,0,.12)}" +
    ".rz-handle{position:absolute;touch-action:none;cursor:ew-resize;z-index:5}" +
    ".rz-handle-r{top:0;right:-14px;width:28px;height:100%;display:flex;align-items:center;justify-content:center}" +
    ".rz-handle-r::after{content:'';width:5px;height:34px;border-radius:3px;background:#EA3991}" +
    ".rz-handle-corner{right:-14px;bottom:-14px;width:32px;height:32px;cursor:nwse-resize;" +
    "display:flex;align-items:center;justify-content:center}" +
    ".rz-handle-corner::after{content:'';width:14px;height:14px;border-radius:50%;background:#EA3991}" +
    ".rz-badge{display:inline-block;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;" +
    "font-size:11px;padding:3px 8px;border-radius:20px;color:#fff;white-space:nowrap}" +
    ".rz-badge-compact{background:#E86C00}" +
    ".rz-badge-regular{background:#1E88C7}" +
    ".rz-threshold{position:absolute;border:0;pointer-events:none}" +
    ".rz-threshold-v{top:0;bottom:0;border-left:1.5px dashed rgba(0,0,0,.22)}" +
    ".rz-threshold-h{left:0;right:0;border-top:1.5px dashed rgba(0,0,0,.22)}" +
    ".rz-readout{margin-top:10px;text-align:center;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;" +
    "font-size:12px;color:#555;min-height:1.4em}" +
    /* ViewThatFits */
    ".rz-vtf-bar{display:flex;align-items:center;justify-content:center;gap:12px;padding:12px;min-height:58px}" +
    ".rz-btn{display:inline-flex;align-items:center;gap:6px;padding:7px 12px;border-radius:20px;" +
    "border:0;background:rgba(0,0,0,.06);color:#EA3991;font-size:13px;font-family:inherit;" +
    "cursor:pointer;white-space:nowrap}" +
    ".rz-btn svg{width:17px;height:17px;flex:none}" +
    ".rz-btn-icon{padding:8px}" +
    ".rz-vtf-steps{display:flex;gap:6px;justify-content:center;margin-top:12px;flex-wrap:wrap}" +
    ".rz-step{font-size:11px;padding:3px 10px;border-radius:20px;background:rgba(0,0,0,.06);color:#555;" +
    "transition:background .2s,color .2s}" +
    ".rz-step-active{background:#EA3991;color:#fff}" +
    ".rz-menu{position:absolute;top:52px;left:50%;transform:translateX(-50%);min-width:180px;" +
    "background:#fff;border:1px solid rgba(0,0,0,.12);border-radius:12px;" +
    "box-shadow:0 8px 24px rgba(0,0,0,.18);padding:4px;z-index:20}" +
    ".rz-menu-item{display:flex;align-items:center;justify-content:space-between;gap:16px;width:100%;" +
    "padding:8px 12px;border:0;background:none;font-size:13px;font-family:inherit;color:#222;" +
    "cursor:pointer;border-radius:8px;text-align:left}" +
    ".rz-menu-item:hover{background:rgba(0,0,0,.06)}" +
    ".rz-menu-item svg{width:16px;height:16px}" +
    /* Breakpoints / weather */
    ".rz-ruler{position:relative;height:22px;margin:0 0 6px}" +
    ".rz-ruler-track{position:absolute;left:0;right:0;top:10px;height:2px;background:rgba(0,0,0,.12)}" +
    ".rz-ruler-mark{position:absolute;top:4px;width:2px;height:14px;background:rgba(0,0,0,.3)}" +
    ".rz-ruler-label{position:absolute;top:-8px;transform:translateX(-50%);font-size:9px;color:#555;" +
    "font-family:ui-monospace,Menlo,monospace}" +
    ".rz-ruler-cursor{position:absolute;top:2px;width:2px;height:18px;background:#EA3991}" +
    ".rz-weather{padding:10px;display:grid;gap:8px}" +
    ".rz-weather-1{grid-template-columns:1fr}" +
    ".rz-weather-2{grid-template-columns:1fr 1fr}" +
    ".rz-weather-3{grid-template-columns:1fr 1fr 1fr}" +
    ".rz-card{background:rgba(0,0,0,.05);border-radius:10px;padding:10px;min-width:0;overflow:hidden}" +
    ".rz-card h5{margin:0 0 4px;font-size:9px;text-transform:uppercase;letter-spacing:.06em;color:#555;font-weight:500}" +
    ".rz-card .rz-big{font-size:20px;font-weight:300;color:#222;white-space:nowrap}" +
    ".rz-card .rz-small{font-size:11px;color:#555;white-space:nowrap}" +
    ".rz-hero{background:linear-gradient(140deg,#4aa3df,#1e5f8e);color:#fff}" +
    ".rz-hero h5,.rz-hero .rz-big,.rz-hero .rz-small{color:#fff}" +
    ".rz-hero .rz-big{font-size:32px}" +
    ".rz-weather-2 .rz-hero{grid-column:span 2}" +
    ".rz-weather-3 .rz-hero{grid-row:span 2}" +
    ".rz-hours{display:flex;gap:10px;overflow:hidden}" +
    ".rz-hour{text-align:center;font-size:10px;color:#555;flex:none}" +
    ".rz-hour b{display:block;font-size:12px;color:#222;font-weight:500}" +
    /* Discrete resizing */
    ".rz-toggle-row{display:flex;align-items:center;justify-content:center;gap:8px;margin:0 0 12px;" +
    "font-family:ui-monospace,Menlo,monospace;font-size:12px;color:#222}" +
    ".rz-switch{position:relative;width:44px;height:26px;border-radius:13px;border:0;cursor:pointer;" +
    "background:rgba(0,0,0,.2);transition:background .2s;flex:none}" +
    ".rz-switch::after{content:'';position:absolute;top:2px;left:2px;width:22px;height:22px;border-radius:50%;" +
    "background:#fff;box-shadow:0 1px 3px rgba(0,0,0,.3);transition:left .2s}" +
    ".rz-switch-on{background:#34C759}" +
    ".rz-switch-on::after{left:20px}" +
    ".rz-ghost{position:absolute;top:0;bottom:0;border:2px dashed #EA3991;border-radius:8px;" +
    "pointer-events:none;display:none;z-index:4}" +
    ".rz-apps{display:flex;flex-wrap:wrap;gap:12px;padding:14px;justify-content:flex-start;overflow:hidden}" +
    ".rz-app{width:44px;text-align:center;font-size:8px;color:#555;flex:none}" +
    ".rz-app i{display:block;width:40px;height:40px;margin:0 auto 3px;border-radius:10px}" +
    /* Traits */
    ".rz-seg{display:flex;gap:0;margin:0 auto 14px;max-width:340px;background:rgba(0,0,0,.07);" +
    "border-radius:9px;padding:2px}" +
    ".rz-seg button{flex:1;border:0;background:none;padding:6px 8px;font-size:12px;font-family:inherit;" +
    "border-radius:7px;cursor:pointer;color:#222;white-space:nowrap}" +
    ".rz-seg .rz-seg-active{background:#fff;box-shadow:0 1px 3px rgba(0,0,0,.15)}" +
    ".rz-game{border-radius:10px;overflow:hidden;background:#101014;color:#fff;max-width:420px;margin:0 auto}" +
    ".rz-game-top{display:flex;align-items:center;gap:8px;padding:10px 14px;font-size:12px;" +
    "background:rgba(255,255,255,.06)}" +
    ".rz-game-body{display:flex;align-items:center;gap:14px;padding:16px 14px}" +
    ".rz-game-art{width:64px;height:64px;border-radius:14px;flex:none;" +
    "background:linear-gradient(135deg,#EA3991,#7b2ff7)}" +
    ".rz-game-body h4{margin:0 0 2px;font-size:15px;font-weight:500;color:#fff}" +
    ".rz-game-body p{margin:0;font-size:11px;color:rgba(255,255,255,.55)}" +
    ".rz-play{margin-left:auto;border:0;border-radius:20px;padding:6px 18px;background:#fff;color:#101014;" +
    "font-size:12px;font-weight:600;cursor:default}" +
    ".rz-traits{max-width:420px;margin:12px auto 0;font-family:ui-monospace,Menlo,monospace;font-size:12px}" +
    ".rz-trait-row{display:flex;justify-content:space-between;padding:6px 4px;" +
    "border-bottom:1px solid rgba(0,0,0,.08);color:#555}" +
    ".rz-trait-row b{font-weight:600;color:#EA3991;transition:opacity .15s}" +
    ".rz-trait-fade b{opacity:0}" +
    "@media (prefers-color-scheme:dark){" +
    ".rz-widget{background:#1F1F24}" +
    ".rz-hint,.rz-readout{color:#aaa}" +
    ".rz-stage{border-color:rgba(255,255,255,.18);background:rgba(255,255,255,.04)}" +
    ".rz-win{background:#2a2a31;border-color:rgba(255,255,255,.25);box-shadow:0 4px 14px rgba(0,0,0,.5)}" +
    ".rz-threshold-v{border-left-color:rgba(255,255,255,.25)}" +
    ".rz-threshold-h{border-top-color:rgba(255,255,255,.25)}" +
    ".rz-btn{background:rgba(255,255,255,.1);color:#ff6ab3}" +
    ".rz-step{background:rgba(255,255,255,.1);color:#aaa}" +
    ".rz-step-active{background:#EA3991;color:#fff}" +
    ".rz-menu{background:#2a2a31;border-color:rgba(255,255,255,.15)}" +
    ".rz-menu-item{color:#fff}" +
    ".rz-menu-item:hover{background:rgba(255,255,255,.1)}" +
    ".rz-ruler-track{background:rgba(255,255,255,.15)}" +
    ".rz-ruler-mark{background:rgba(255,255,255,.35)}" +
    ".rz-ruler-label{color:#aaa}" +
    ".rz-card{background:rgba(255,255,255,.07)}" +
    ".rz-card h5,.rz-card .rz-small,.rz-hour{color:#aaa}" +
    ".rz-card .rz-big,.rz-hour b{color:#fff}" +
    ".rz-toggle-row{color:#fff}" +
    ".rz-switch{background:rgba(255,255,255,.25)}" +
    ".rz-switch-on{background:#34C759}" +
    ".rz-seg{background:rgba(255,255,255,.1)}" +
    ".rz-seg button{color:#fff}" +
    ".rz-seg .rz-seg-active{background:#4a4a52}" +
    ".rz-trait-row{border-bottom-color:rgba(255,255,255,.12);color:#aaa}" +
    ".rz-app{color:#aaa}" +
    "}";

  function svgIcon(name) {
    var paths = {
      share: '<path d="M12 15V3.5M8 7l4-4 4 4M6.5 11H5v9.5h14V11h-1.5"/>',
      heart: '<path d="M12 20S4.8 15.4 3.2 11C1.9 7.6 4.3 4.5 7.3 4.5c2 0 3.6 1.3 4.7 3 1.1-1.7 2.7-3 4.7-3 3 0 5.4 3.1 4.1 6.5C19.2 15.4 12 20 12 20z"/>',
      bookmark: '<path d="M7 3.5h10V20l-5-3.8L7 20z"/>',
      trash: '<path d="M4.5 7h15M9.5 7V4.5h5V7M6.5 7l1 13.5h9l1-13.5M10 11v6M14 11v6"/>',
      ellipsis: '<circle cx="12" cy="12" r="9"/><circle class="rz-dot" cx="7.5" cy="12" r="1.2"/><circle class="rz-dot" cx="12" cy="12" r="1.2"/><circle class="rz-dot" cx="16.5" cy="12" r="1.2"/>'
    };
    return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" ' +
      'stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + paths[name] + "</svg>";
  }

  function el(tag, className, html) {
    var e = document.createElement(tag);
    if (className) e.className = className;
    if (html !== undefined) e.innerHTML = html;
    return e;
  }

  // Generic pointer-drag helper. cb receives (dx, dy, phase) where phase is
  // "move" or "end"; deltas are relative to the drag start.
  function draggable(handle, cb) {
    handle.addEventListener("pointerdown", function (ev) {
      ev.preventDefault();
      handle.setPointerCapture(ev.pointerId);
      var sx = ev.clientX, sy = ev.clientY;
      function move(e) { cb(e.clientX - sx, e.clientY - sy, "move"); }
      function up(e) {
        cb(e.clientX - sx, e.clientY - sy, "end");
        handle.removeEventListener("pointermove", move);
        handle.removeEventListener("pointerup", up);
        handle.removeEventListener("pointercancel", up);
      }
      handle.addEventListener("pointermove", move);
      handle.addEventListener("pointerup", up);
      handle.addEventListener("pointercancel", up);
    });
  }

  function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }

  // ---------------------------------------------------------------- widgets

  function sizeClassesWidget(root, t) {
    root.appendChild(el("p", "rz-hint", t.dragCorner));
    var stage = el("div", "rz-stage");
    stage.style.aspectRatio = "10/7";
    var thrV = el("div", "rz-threshold rz-threshold-v");
    var thrH = el("div", "rz-threshold rz-threshold-h");
    var win = el("div", "rz-win");
    win.style.position = "absolute";
    win.style.left = "8px";
    win.style.top = "8px";
    var badges = el("div", "", "");
    badges.style.cssText = "display:flex;flex-direction:column;gap:6px;align-items:flex-start;padding:10px";
    var hBadge = el("span", "rz-badge");
    var vBadge = el("span", "rz-badge");
    badges.appendChild(hBadge);
    badges.appendChild(vBadge);
    win.appendChild(badges);
    var handle = el("div", "rz-handle rz-handle-corner");
    handle.style.touchAction = "none";
    win.appendChild(handle);
    stage.appendChild(thrV);
    stage.appendChild(thrH);
    stage.appendChild(win);
    root.appendChild(stage);
    var readout = el("div", "rz-readout");
    root.appendChild(readout);

    var H_RATIO = 0.6, V_RATIO = 0.55;
    thrV.style.left = (H_RATIO * 100) + "%";
    thrH.style.top = (V_RATIO * 100) + "%";

    var w = 0, h = 0;
    function stageSize() { return { w: stage.clientWidth - 16, h: stage.clientHeight - 16 }; }
    function apply() {
      var s = stageSize();
      w = clamp(w, 110, s.w);
      h = clamp(h, 78, s.h);
      win.style.width = w + "px";
      win.style.height = h + "px";
      var hClass = (w + 8) < stage.clientWidth * H_RATIO ? "compact" : "regular";
      var vClass = (h + 8) < stage.clientHeight * V_RATIO ? "compact" : "regular";
      hBadge.textContent = t.horizontal + ": ." + hClass;
      hBadge.className = "rz-badge rz-badge-" + hClass;
      vBadge.textContent = t.vertical + ": ." + vClass;
      vBadge.className = "rz-badge rz-badge-" + vClass;
      readout.textContent = Math.round(w) + " × " + Math.round(h) + " pt";
    }
    function reset() {
      var s = stageSize();
      w = s.w; h = s.h;
      apply();
    }
    var startW, startH, dragged = false;
    draggable(handle, function (dx, dy, phase) {
      w = startW + dx; h = startH + dy;
      apply();
    });
    handle.addEventListener("pointerdown", function () {
      startW = w; startH = h; dragged = true;
    });
    // The article layout can settle after DOMContentLoaded; track the stage size
    // instead of trusting the dimensions at init time.
    new ResizeObserver(function () {
      if (dragged) apply(); else reset();
    }).observe(stage);
  }

  function viewThatFitsWidget(root, t) {
    root.appendChild(el("p", "rz-hint", t.dragHandle));
    var stage = el("div", "rz-stage");
    stage.style.padding = "14px 20px";
    var win = el("div", "rz-win");
    win.style.margin = "0 auto";
    var bar = el("div", "rz-vtf-bar");
    win.appendChild(bar);
    var handle = el("div", "rz-handle rz-handle-r");
    win.appendChild(handle);
    stage.appendChild(win);
    root.appendChild(stage);

    var actions = [
      { icon: "share", label: t.share },
      { icon: "heart", label: t.favorite },
      { icon: "bookmark", label: t.save },
      { icon: "trash", label: t.remove }
    ];

    function makeBar(withLabels) {
      var frag = document.createDocumentFragment();
      actions.forEach(function (a) {
        var b = el("button", "rz-btn" + (withLabels ? "" : " rz-btn-icon"),
          svgIcon(a.icon) + (withLabels ? "<span>" + a.label + "</span>" : ""));
        b.type = "button";
        frag.appendChild(b);
      });
      return frag;
    }

    var menuOpen = false;
    function makeMenuButton() {
      var b = el("button", "rz-btn rz-btn-icon", svgIcon("ellipsis"));
      b.type = "button";
      b.addEventListener("click", function (ev) {
        ev.stopPropagation();
        menuOpen = !menuOpen;
        renderMenu();
      });
      return b;
    }
    var menuEl = null;
    function renderMenu() {
      if (menuEl) { menuEl.remove(); menuEl = null; }
      if (!menuOpen) return;
      menuEl = el("div", "rz-menu");
      actions.forEach(function (a) {
        var item = el("button", "rz-menu-item",
          "<span>" + a.label + "</span>" + svgIcon(a.icon));
        item.type = "button";
        item.addEventListener("click", function () { menuOpen = false; renderMenu(); });
        menuEl.appendChild(item);
      });
      win.appendChild(menuEl);
    }
    document.addEventListener("click", function () {
      if (menuOpen) { menuOpen = false; renderMenu(); }
    });

    var steps = el("div", "rz-vtf-steps");
    var stepNames = [t.vtfLabels, t.vtfIcons, t.vtfMenu];
    var stepEls = stepNames.map(function (n) {
      var s = el("span", "rz-step", n);
      steps.appendChild(s);
      return s;
    });
    root.appendChild(steps);
    var readout = el("div", "rz-readout");
    root.appendChild(readout);

    // Measure the natural width of each variant once, off-screen.
    var naturalWidths = [];
    function measure() {
      var probe = el("div", "rz-vtf-bar");
      probe.style.cssText += "position:absolute;visibility:hidden;width:max-content";
      stage.appendChild(probe);
      naturalWidths = [0, 1, 2].map(function (i) {
        probe.innerHTML = "";
        if (i === 0) probe.appendChild(makeBar(true));
        else if (i === 1) probe.appendChild(makeBar(false));
        else probe.appendChild(makeMenuButton());
        return probe.getBoundingClientRect().width;
      });
      probe.remove();
    }

    var current = -1, w = 0;
    function apply() {
      var maxW = stage.clientWidth - 40;
      w = clamp(w, 64, maxW);
      win.style.width = w + "px";
      var pick = 2;
      for (var i = 0; i < naturalWidths.length; i++) {
        if (naturalWidths[i] <= w) { pick = i; break; }
      }
      if (pick !== current) {
        current = pick;
        menuOpen = false; renderMenu();
        bar.innerHTML = "";
        if (pick === 0) bar.appendChild(makeBar(true));
        else if (pick === 1) bar.appendChild(makeBar(false));
        else bar.appendChild(makeMenuButton());
        stepEls.forEach(function (s, i) {
          s.className = "rz-step" + (i === pick ? " rz-step-active" : "");
        });
      }
      readout.textContent = t.vtfPicked + " " + stepNames[current];
    }
    var startW, dragged = false;
    handle.addEventListener("pointerdown", function () { startW = w; dragged = true; });
    draggable(handle, function (dx) { w = startW + dx; apply(); });
    new ResizeObserver(function () {
      if (!naturalWidths.length) measure();
      if (!dragged) w = stage.clientWidth - 40;
      apply();
    }).observe(stage);
  }

  function breakpointsWidget(root, t) {
    root.appendChild(el("p", "rz-hint", t.dragHandle));
    var BP1 = 340, BP2 = 480;
    var ruler = el("div", "rz-ruler");
    ruler.appendChild(el("div", "rz-ruler-track"));
    var cursor = el("div", "rz-ruler-cursor");
    ruler.appendChild(cursor);
    root.appendChild(ruler);

    var stage = el("div", "rz-stage");
    stage.style.padding = "14px 20px 14px 14px";
    var win = el("div", "rz-win");
    var grid = el("div", "rz-weather rz-weather-3");
    win.appendChild(grid);
    var handle = el("div", "rz-handle rz-handle-r");
    win.appendChild(handle);
    stage.appendChild(win);
    root.appendChild(stage);
    var readout = el("div", "rz-readout");
    root.appendChild(readout);

    var hours = ["14h 23°", "15h 24°", "16h 24°", "17h 22°", "18h 20°", "19h 18°", "20h 17°"];
    var hoursHtml = hours.map(function (h) {
      var p = h.split(" ");
      return '<div class="rz-hour">' + p[0] + "<b>" + p[1] + "</b></div>";
    }).join("");

    grid.innerHTML =
      '<div class="rz-card rz-hero"><h5>' + t.now + '</h5><div class="rz-big">23°</div>' +
      '<div class="rz-small">São Paulo</div></div>' +
      '<div class="rz-card" style="grid-column:span 2"><h5>' + t.hourly + '</h5>' +
      '<div class="rz-hours">' + hoursHtml + "</div></div>" +
      '<div class="rz-card"><h5>' + t.air + '</h5><div class="rz-big">42</div>' +
      '<div class="rz-small">' + t.good + "</div></div>" +
      '<div class="rz-card"><h5>' + t.wind + '</h5><div class="rz-big">12<span style="font-size:12px"> km/h</span></div></div>' +
      '<div class="rz-card"><h5>' + t.uv + '</h5><div class="rz-big">6</div>' +
      '<div class="rz-small">' + t.moderate + "</div></div>";

    var hourlyCard = grid.children[1];

    var markEls = [];
    function setMarks() {
      markEls.forEach(function (m) { m.remove(); });
      markEls = [];
      var max = stage.clientWidth - 34;
      [BP1, BP2].forEach(function (bp) {
        if (bp > max) return;
        var pct = (bp / max) * 100;
        var m = el("div", "rz-ruler-mark");
        m.style.left = pct + "%";
        ruler.appendChild(m);
        var l = el("div", "rz-ruler-label", bp + "pt");
        l.style.left = pct + "%";
        ruler.appendChild(l);
        markEls.push(m, l);
      });
    }

    var w = 0;
    function apply() {
      var max = stage.clientWidth - 34;
      w = clamp(w, 190, max);
      win.style.width = w + "px";
      cursor.style.left = ((w / max) * 100) + "%";
      var mode, label;
      if (w < BP1) { mode = "rz-weather-1"; label = t.oneCol; }
      else if (w < BP2) { mode = "rz-weather-2"; label = t.twoCol; }
      else { mode = "rz-weather-3"; label = t.threeCol; }
      grid.className = "rz-weather " + mode;
      hourlyCard.style.gridColumn = mode === "rz-weather-1" ? "auto" : "span 2";
      readout.textContent = t.width + ": " + Math.round(w) + " pt — " + t.layout + ": " + label;
    }
    var startW, dragged = false;
    handle.addEventListener("pointerdown", function () { startW = w; dragged = true; });
    draggable(handle, function (dx) { w = startW + dx; apply(); });
    new ResizeObserver(function () {
      setMarks();
      if (!dragged) w = stage.clientWidth - 34;
      apply();
    }).observe(stage);
  }

  function fullscreenWidget(root, t) {
    var toggleRow = el("div", "rz-toggle-row");
    var sw = el("button", "rz-switch");
    sw.type = "button";
    sw.setAttribute("aria-label", "UIRequiresFullscreen");
    toggleRow.appendChild(el("span", "", "UIRequiresFullscreen"));
    toggleRow.appendChild(sw);
    root.appendChild(toggleRow);

    var stage = el("div", "rz-stage");
    stage.style.padding = "14px 20px 14px 14px";
    var win = el("div", "rz-win");
    var apps = el("div", "rz-apps");
    var colors = ["#EA3991", "#1E88C7", "#34C759", "#E86C00", "#7b2ff7", "#00b8a9",
      "#f8b400", "#d72323", "#3d5af1", "#22a39f", "#c06c84", "#6c5b7b"];
    colors.forEach(function (c, i) {
      apps.appendChild(el("div", "rz-app", '<i style="background:' + c + '"></i>App ' + (i + 1)));
    });
    win.appendChild(apps);
    var ghost = el("div", "rz-ghost");
    var handle = el("div", "rz-handle rz-handle-r");
    win.appendChild(handle);
    stage.appendChild(win);
    stage.appendChild(ghost);
    root.appendChild(stage);
    var readout = el("div", "rz-readout");
    root.appendChild(readout);

    var discrete = false;
    var STEPS = [220, 320, 420, 520, 620];
    function snap(v, max) {
      var best = STEPS[0];
      STEPS.forEach(function (s) {
        if (s <= max && Math.abs(s - v) < Math.abs(best - v)) best = s;
      });
      return Math.min(best, max);
    }
    var w = 0;
    function maxW() { return stage.clientWidth - 34; }
    function apply() {
      w = clamp(w, 190, maxW());
      win.style.width = w + "px";
      readout.textContent = (discrete ? t.discrete : t.fluid) +
        " — " + Math.round(w) + " pt";
    }
    sw.addEventListener("click", function () {
      discrete = !discrete;
      sw.className = "rz-switch" + (discrete ? " rz-switch-on" : "");
      if (discrete) { w = snap(w, maxW()); }
      apply();
    });
    var startW, dragged = false;
    handle.addEventListener("pointerdown", function () { startW = w; dragged = true; });
    draggable(handle, function (dx, dy, phase) {
      var target = clamp(startW + dx, 190, maxW());
      if (!discrete) {
        w = target;
        apply();
        return;
      }
      if (phase === "move") {
        ghost.style.display = "block";
        ghost.style.left = win.offsetLeft + "px";
        ghost.style.width = target + "px";
        readout.textContent = t.discrete + " — " + t.releaseToApply;
      } else {
        ghost.style.display = "none";
        w = snap(target, maxW());
        apply();
      }
    });
    new ResizeObserver(function () {
      if (!dragged) w = discrete ? snap(maxW(), maxW()) : maxW();
      apply();
    }).observe(stage);
  }

  function traitsWidget(root, t) {
    var seg = el("div", "rz-seg");
    var modes = [
      { name: "iPadOS", idiom: ".pad", orientation: ".landscape" },
      { name: t.mirroring, idiom: ".phone", orientation: ".portrait" }
    ];
    var traits = el("div", "rz-traits");
    var rows = {};
    ["userInterfaceIdiom", "interfaceOrientation", "windowSize"].forEach(function (k) {
      var row = el("div", "rz-trait-row",
        "<span>" + (k === "windowSize" ? "window size" : k) + "</span><b></b>");
      rows[k] = row.querySelector("b");
      traits.appendChild(row);
    });

    var game = el("div", "rz-game",
      '<div class="rz-game-top">' + svgIcon("ellipsis") .replace("<svg ", '<svg style="width:14px;height:14px" ') +
      "<span>Apple Games</span></div>" +
      '<div class="rz-game-body"><div class="rz-game-art"></div>' +
      "<div><h4>AmarganA</h4><p>PhD Games</p></div>" +
      '<button class="rz-play" type="button">▶</button></div>');

    var active = 0;
    var btns = modes.map(function (m, i) {
      var b = el("button", i === 0 ? "rz-seg-active" : "", m.name);
      b.type = "button";
      b.addEventListener("click", function () { setMode(i); });
      seg.appendChild(b);
      return b;
    });
    function setMode(i) {
      active = i;
      btns.forEach(function (b, j) { b.className = j === i ? "rz-seg-active" : ""; });
      traits.classList.add("rz-trait-fade");
      setTimeout(function () {
        rows.userInterfaceIdiom.textContent = modes[i].idiom;
        rows.interfaceOrientation.textContent = modes[i].orientation;
        rows.windowSize.textContent = "740 × 420 pt";
        traits.classList.remove("rz-trait-fade");
      }, 150);
    }
    root.appendChild(seg);
    root.appendChild(game);
    root.appendChild(traits);
    root.appendChild(el("p", "rz-hint", t.sameInterface)).style.marginTop = "12px";
    rows.userInterfaceIdiom.textContent = modes[0].idiom;
    rows.interfaceOrientation.textContent = modes[0].orientation;
    rows.windowSize.textContent = "740 × 420 pt";
  }

  var WIDGETS = {
    "size-classes": sizeClassesWidget,
    "view-that-fits": viewThatFitsWidget,
    "breakpoints": breakpointsWidget,
    "fullscreen": fullscreenWidget,
    "traits": traitsWidget
  };

  function init() {
    var style = document.createElement("style");
    style.textContent = CSS;
    document.head.appendChild(style);
    var nodes = document.querySelectorAll(".rz-widget[data-widget]");
    Array.prototype.forEach.call(nodes, function (node) {
      var kind = node.getAttribute("data-widget");
      var lang = node.getAttribute("data-lang") === "br" ? "br" : "en";
      var build = WIDGETS[kind];
      if (!build) return;
      node.innerHTML = "";
      build(node, STRINGS[lang]);
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
