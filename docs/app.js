/* Card Collector card browser. Plain JavaScript, no libraries: it loads cards.json (made by
   dev/build_site.py from the deck files) and filters it in the browser. */
(function () {
  "use strict";

  var PAGE = 60;                       // cards drawn at a time while scrolling
  var FACETS = ["category", "collection", "regions", "skills", "location", "membership", "pack"];
  var FACET_NAMES = { category: "Category", collection: "Collection", regions: "Region", skills: "Skill",
                      location: "Location", membership: "Membership", pack: "Pack" };
  var MEMBERSHIP = { f2p: "Free to play", p2p: "Members" };
  var KINDS = [["", "All"], ["npc", "NPCs"], ["item", "Items"]];

  var data, cards, byId = {}, rarityIndex = {}, rarityById = {}, packName = {}, packIds = {};
  var state, results = [], shown = 0, openId = null;
  var $ = function (id) { return document.getElementById(id); };

  function words(text) {
    return String(text).split("_").map(function (w) { return w.charAt(0).toUpperCase() + w.slice(1); }).join(" ");
  }
  function label(facet, value) {
    if (facet === "membership") { return MEMBERSHIP[value] || value; }
    if (facet === "pack") { return packName[value] || value; }
    if (facet === "collection") { return value; }
    return words(value);
  }
  function el(tag, props, children) {
    var node = document.createElement(tag);
    Object.keys(props || {}).forEach(function (key) {
      if (key === "text") { node.textContent = props[key]; }
      else if (key === "class") { node.className = props[key]; }
      else if (key.indexOf("on") === 0) { node.addEventListener(key.slice(2), props[key]); }
      else { node.setAttribute(key, props[key]); }
    });
    (children || []).forEach(function (child) { if (child) { node.appendChild(child); } });
    return node;
  }

  /* ---------- state (kept in the address, so a filtered view can be linked) ---------- */

  function emptyState() {
    return { q: "", kind: "", rarity: [], category: "", collection: "", regions: "", skills: "", location: "",
             membership: "", pack: "", sort: "rarity-desc", art: false };
  }
  function readHash() {
    var s = emptyState(), params = new URLSearchParams(location.hash.slice(1));
    ["q", "kind", "category", "collection", "regions", "skills", "location", "membership", "pack", "sort"].forEach(function (k) {
      if (params.has(k)) { s[k] = params.get(k); }
    });
    if (params.get("rarity")) { s.rarity = params.get("rarity").split(",").filter(function (r) { return rarityIndex[r] !== undefined; }); }
    s.art = params.get("art") === "1";
    return s;
  }
  var hashTimer;
  function writeHash() {
    var params = new URLSearchParams(), def = emptyState();
    Object.keys(state).forEach(function (k) {
      var v = state[k];
      if (k === "rarity") { if (v.length) { params.set(k, v.join(",")); } }
      else if (k === "art") { if (v) { params.set(k, "1"); } }
      else if (v !== def[k]) { params.set(k, v); }
    });
    clearTimeout(hashTimer);
    hashTimer = setTimeout(function () {
      var text = params.toString();
      history.replaceState(null, "", text ? "#" + text : location.pathname + location.search);
    }, 150);
  }

  /* ---------- filtering ---------- */

  function matches(card, s, skip) {
    if (skip !== "kind" && s.kind && card.kind !== s.kind) { return false; }
    if (skip !== "rarity" && s.rarity.length && s.rarity.indexOf(card.rarity) < 0) { return false; }
    if (s.art && !card.img) { return false; }
    for (var i = 0; i < FACETS.length; i++) {
      var f = FACETS[i];
      if (f === skip || !s[f]) { continue; }
      if (!hasFacet(card, f, s[f])) { return false; }
    }
    if (s.q) {
      var hay = card._hay, parts = s.q.toLowerCase().split(/\s+/);
      for (var j = 0; j < parts.length; j++) { if (parts[j] && hay.indexOf(parts[j]) < 0) { return false; } }
    }
    return true;
  }
  function hasFacet(card, facet, value) {
    if (facet === "collection") { return card.collection === value; }
    if (facet === "pack") { return !!packIds[value] && packIds[value][card.id] === true; }
    return (card.tags[facet] || []).indexOf(value) >= 0;
  }

  function sorter(mode) {
    var rank = function (c) { return rarityIndex[c.rarity] || 0; };
    switch (mode) {
      case "rarity-asc": return function (a, b) { return rank(a) - rank(b) || a.order - b.order; };
      case "name": return function (a, b) { return a.name.localeCompare(b.name); };
      case "name-desc": return function (a, b) { return b.name.localeCompare(a.name); };
      case "deck": return function (a, b) { return a.order - b.order; };
      default: return function (a, b) { return rank(b) - rank(a) || a.order - b.order; };
    }
  }

  function apply() {
    results = cards.filter(function (c) { return matches(c, state); }).sort(sorter(state.sort));
    $("count").textContent = results.length === cards.length
      ? cards.length.toLocaleString() + " cards"
      : results.length.toLocaleString() + " of " + cards.length.toLocaleString() + " cards";
    renderControls();
    renderActive();
    renderGrid();
    if (!$("overview").hidden) { renderOverview(); }
    writeHash();
  }

  /* ---------- controls ---------- */

  function facetCounts(facet) {
    var counts = {};
    cards.forEach(function (c) {
      if (!matches(c, state, facet)) { return; }
      if (facet === "collection") { counts[c.collection] = (counts[c.collection] || 0) + 1; }
      else if (facet === "pack") {
        Object.keys(packIds).forEach(function (p) { if (packIds[p][c.id]) { counts[p] = (counts[p] || 0) + 1; } });
      } else { (c.tags[facet] || []).forEach(function (w) { counts[w] = (counts[w] || 0) + 1; }); }
    });
    return counts;
  }

  function fillSelect(facet) {
    var select = $(facet), counts = facetCounts(facet), current = state[facet];
    var values = Object.keys(counts);
    if (current && values.indexOf(current) < 0) { values.push(current); }
    if (facet === "pack") {
      values.sort(function (a, b) { return data.packs.findIndex(function (p) { return p.id === a; }) - data.packs.findIndex(function (p) { return p.id === b; }); });
    } else {
      values.sort(function (a, b) { return label(facet, a).localeCompare(label(facet, b)); });
    }
    select.textContent = "";
    select.appendChild(el("option", { value: "", text: "All" }));
    values.forEach(function (v) {
      select.appendChild(el("option", { value: v, text: label(facet, v) + " (" + (counts[v] || 0) + ")" }));
    });
    select.value = current;
    select.closest(".field").hidden = values.length === 0 && !current;
  }

  function renderControls() {
    $("q").value !== state.q && ($("q").value = state.q);
    var kind = $("kind");
    kind.textContent = "";
    var kindCounts = { "": 0, npc: 0, item: 0 };
    cards.forEach(function (c) { if (matches(c, state, "kind")) { kindCounts[""]++; kindCounts[c.kind]++; } });
    KINDS.forEach(function (k) {
      var b = el("button", { type: "button", "aria-pressed": String(state.kind === k[0]), text: k[1] + " " + kindCounts[k[0]].toLocaleString() });
      b.addEventListener("click", function () { state.kind = k[0]; apply(); });
      kind.appendChild(b);
    });
    var rarity = $("rarity");
    rarity.textContent = "";
    var rc = {};
    cards.forEach(function (c) { if (matches(c, state, "rarity")) { rc[c.rarity] = (rc[c.rarity] || 0) + 1; } });
    data.rarities.forEach(function (r) {
      var on = state.rarity.indexOf(r.id) >= 0;
      var chip = el("button", { type: "button", class: "chip", "aria-pressed": String(on), style: "--rc:" + r.colour }, []);
      chip.textContent = r.name;
      chip.appendChild(el("small", { text: String(rc[r.id] || 0) }));
      chip.addEventListener("click", function () {
        var at = state.rarity.indexOf(r.id);
        if (at >= 0) { state.rarity.splice(at, 1); } else { state.rarity.push(r.id); }
        apply();
      });
      rarity.appendChild(chip);
    });
    FACETS.forEach(fillSelect);
    $("sort").value = state.sort;
    $("art-only").checked = state.art;
  }

  function renderActive() {
    var box = $("active");
    box.textContent = "";
    var pills = [];
    if (state.q) { pills.push(["Search: " + state.q, function () { state.q = ""; }]); }
    if (state.kind) { pills.push([state.kind === "npc" ? "NPCs" : "Items", function () { state.kind = ""; }]); }
    state.rarity.forEach(function (r) { pills.push([rarityById[r].name, function () { state.rarity.splice(state.rarity.indexOf(r), 1); }]); });
    FACETS.forEach(function (f) {
      if (state[f]) { pills.push([FACET_NAMES[f] + ": " + label(f, state[f]), function () { state[f] = ""; }]); }
    });
    if (state.art) { pills.push(["With a picture", function () { state.art = false; }]); }
    pills.forEach(function (p) {
      var b = el("button", { type: "button", class: "tag-pill", "aria-label": "Remove filter " + p[0] }, []);
      b.textContent = p[0];
      b.appendChild(el("b", { text: "×" }));
      b.addEventListener("click", function () { p[1](); apply(); });
      box.appendChild(b);
    });
  }

  /* ---------- the cards ---------- */

  function cardNode(c) {
    var r = rarityById[c.rarity] || { name: c.rarity, colour: "#9aa0a6" };
    var art = el("div", { class: "c-art" }, []);
    if (c.img) {
      var img = el("img", { src: c.img, alt: "", loading: "lazy", decoding: "async" });
      img.addEventListener("error", function () { art.textContent = ""; art.appendChild(placeholder(c)); art.appendChild(el("span", { class: "c-kind", text: c.kind })); });
      art.appendChild(img);
    } else { art.appendChild(placeholder(c)); }
    art.appendChild(el("span", { class: "c-kind", text: c.kind }));
    var meta = el("div", { class: "c-meta" }, []);
    var main = (c.tags.category || []).filter(function (w) { return w !== "monster"; })[0];
    if (main) { meta.appendChild(el("span", { class: "mini", text: words(main) })); }
    if (c.tags.membership && c.tags.membership[0]) { meta.appendChild(el("span", { class: "mini", text: c.tags.membership[0] === "p2p" ? "Members" : "F2P" })); }
    var node = el("button", { type: "button", class: "card", role: "listitem", "data-id": c.id, style: "--rc:" + r.colour,
                              "aria-label": c.name + ", " + r.name + " " + c.kind }, [
      el("div", { class: "c-name", text: c.name }), art, el("div", { class: "c-rar", text: r.name }),
      el("div", { class: "c-desc", text: c.desc }), meta]);
    return node;
  }
  function placeholder(c) { return el("span", { class: "ph", text: c.name.replace(/^[^A-Za-z0-9]+/, "").charAt(0).toUpperCase() }); }

  function renderGrid() {
    var grid = $("grid");
    grid.textContent = "";
    shown = 0;
    $("empty").hidden = results.length > 0;
    drawMore();
  }
  function drawMore() {
    var grid = $("grid"), end = Math.min(results.length, shown + PAGE), frag = document.createDocumentFragment();
    for (; shown < end; shown++) { frag.appendChild(cardNode(results[shown])); }
    grid.appendChild(frag);
    watchMore();
  }
  var observer;
  function watchMore() {
    if (!("IntersectionObserver" in window)) { while (shown < results.length) { drawMore(); } return; }
    if (!observer) {
      observer = new IntersectionObserver(function (entries) {
        if (entries[0].isIntersecting && shown < results.length) { drawMore(); }
      }, { rootMargin: "800px" });
      observer.observe($("more"));
    } else { observer.unobserve($("more")); observer.observe($("more")); }
  }

  /* ---------- overview ---------- */

  function bars(title, rows, onPick) {
    var section = el("div", {}, [el("h2", { text: title })]);
    var top = rows.reduce(function (m, r) { return Math.max(m, r.n); }, 1);
    rows.forEach(function (r) {
      var b = el("button", { type: "button", class: "bar", style: r.colour ? "--rc:" + r.colour : "" }, [
        el("span", { class: "bar-name", text: r.name }),
        el("span", { class: "bar-track" }, [el("span", { class: "bar-fill", style: "width:" + Math.max(2, Math.round(100 * r.n / top)) + "%" })]),
        el("span", { class: "bar-num", text: String(r.n) })]);
      b.addEventListener("click", function () { onPick(r.key); });
      section.appendChild(b);
    });
    return section;
  }
  function tally(list, pick) {
    var counts = {};
    list.forEach(function (c) { pick(c).forEach(function (k) { counts[k] = (counts[k] || 0) + 1; }); });
    return Object.keys(counts).map(function (k) { return { key: k, n: counts[k] }; }).sort(function (a, b) { return b.n - a.n; });
  }
  function renderOverview() {
    var box = $("overview");
    box.textContent = "";
    var list = results;
    box.appendChild(bars("Rarity", data.rarities.map(function (r) {
      return { key: r.id, name: r.name, colour: r.colour, n: list.filter(function (c) { return c.rarity === r.id; }).length };
    }), function (k) { state.rarity = [k]; apply(); }));
    box.appendChild(bars("Collections", tally(list, function (c) { return [c.collection]; }).slice(0, 12).map(function (r) {
      return { key: r.key, name: r.key, n: r.n };
    }), function (k) { state.collection = k; apply(); }));
    box.appendChild(bars("Categories", tally(list, function (c) { return c.tags.category || []; }).slice(0, 12).map(function (r) {
      return { key: r.key, name: words(r.key), n: r.n };
    }), function (k) { state.category = k; apply(); }));
    box.appendChild(bars("Regions", tally(list, function (c) { return c.tags.regions || []; }).slice(0, 12).map(function (r) {
      return { key: r.key, name: words(r.key), n: r.n };
    }), function (k) { state.regions = k; apply(); }));
  }

  /* ---------- the detail view ---------- */

  function fact(term, content) {
    return [el("dt", { text: term }), el("dd", {}, content)];
  }
  function pill(facet, value) {
    var b = el("button", { type: "button", class: "pill", text: label(facet, value), title: "Show only " + label(facet, value) });
    b.addEventListener("click", function () { closeModal(); state[facet] = value; apply(); window.scrollTo({ top: 0 }); });
    return b;
  }
  function openCard(id) {
    var c = byId[id];
    if (!c) { return; }
    openId = id;
    var r = rarityById[c.rarity] || { name: c.rarity, colour: "#9aa0a6" };
    var body = $("m-body");
    body.textContent = "";
    var facts = el("dl", { class: "facts" }, []);
    var rows = [];
    rows.push(fact("Rarity", [el("span", { class: "pill", style: "border-color:" + r.colour, text: r.name })]));
    rows.push(fact("Type", [el("span", { text: c.kind === "item" ? "Item card" : "NPC card" })]));
    if (c.tags.membership) { rows.push(fact("Membership", c.tags.membership.map(function (w) { return pill("membership", w); }))); }
    FACETS.slice(0, 5).forEach(function (f) {
      if (f === "collection") { return; }
      if (c.tags[f] && c.tags[f].length) { rows.push(fact(FACET_NAMES[f], c.tags[f].map(function (w) { return pill(f, w); }))); }
    });
    var packs = Object.keys(packIds).filter(function (p) { return p !== "standard" && packIds[p][c.id]; });
    var inPacks = ["standard"].concat(packs).filter(function (p) { return packIds[p] && packIds[p][c.id]; });
    if (inPacks.length) { rows.push(fact("Packs", inPacks.map(function (p) { return pill("pack", p); }))); }
    rows.push(fact("Collection", [pill("collection", c.collection)]));
    rows.push(fact("Card id", [el("span", { class: "code", text: c.id })]));
    rows.push(fact("Deck file", [el("span", { class: "code", text: c.file })]));
    if (c.variants) { rows.push(fact("Pictures", [el("span", { text: c.variants + " different models" })])); }
    rows.forEach(function (pair) { pair.forEach(function (n) { facts.appendChild(n); }); });

    var wikiTitle = encodeURIComponent(c.name.replace(/ /g, "_")).replace(/%2F/g, "/");
    var links = el("div", { class: "links" }, [
      el("a", { href: "https://runescape.wiki/w/" + wikiTitle, rel: "noopener", target: "_blank", text: "RuneScape Wiki page" })]);
    if (c.imgPage) {
      links.appendChild(el("a", { href: "https://runescape.wiki/w/" + encodeURIComponent(c.imgPage.replace(/ /g, "_")).replace(/%3A/g, ":"),
                                  rel: "noopener", target: "_blank", text: "Picture credit (wiki file page)" }));
    }
    var big = cardNode(c);
    big.removeAttribute("role");
    big.tabIndex = -1;
    var detail = el("div", { class: "detail", style: "--rc:" + r.colour }, [
      big, el("div", {}, [el("h2", { id: "m-name", text: c.name }), el("p", { class: "sub", text: c.desc }), facts, links])]);
    body.appendChild(detail);
    var at = results.findIndex(function (x) { return x.id === id; });
    $("m-prev").disabled = at <= 0;
    $("m-next").disabled = at < 0 || at >= results.length - 1;
    $("modal").hidden = false;
    document.body.style.overflow = "hidden";
    $("m-close").focus();
    var params = new URLSearchParams(location.hash.slice(1));
    params.set("card", id);
    history.replaceState(null, "", "#" + params.toString());
  }
  function closeModal() {
    if ($("modal").hidden) { return; }
    $("modal").hidden = true;
    document.body.style.overflow = "";
    var back = openId && document.querySelector('.card[data-id="' + (window.CSS && CSS.escape ? CSS.escape(openId) : openId) + '"]');
    openId = null;
    writeHash();
    var params = new URLSearchParams(location.hash.slice(1));
    if (params.has("card")) { params.delete("card"); history.replaceState(null, "", params.toString() ? "#" + params : location.pathname); }
    if (back) { back.focus({ preventScroll: true }); }
  }
  function step(delta) {
    var at = results.findIndex(function (x) { return x.id === openId; });
    var next = results[at + delta];
    if (next) {
      while (shown <= at + delta + 1 && shown < results.length) { drawMore(); }
      openCard(next.id);
    }
  }

  /* ---------- start ---------- */

  function wire() {
    var typing;
    $("q").addEventListener("input", function () {
      clearTimeout(typing);
      typing = setTimeout(function () { state.q = $("q").value.trim(); apply(); }, 120);
    });
    FACETS.forEach(function (f) { $(f).addEventListener("change", function () { state[f] = $(f).value; apply(); }); });
    $("sort").addEventListener("change", function () { state.sort = $("sort").value; apply(); });
    $("art-only").addEventListener("change", function () { state.art = $("art-only").checked; apply(); });
    function reset() { state = emptyState(); apply(); }
    $("reset").addEventListener("click", reset);
    $("empty-reset").addEventListener("click", reset);
    $("overview-btn").addEventListener("click", function () {
      var box = $("overview"), open = box.hidden;
      box.hidden = !open;
      $("overview-btn").textContent = open ? "Hide overview" : "Show overview";
      $("overview-btn").setAttribute("aria-expanded", String(open));
      if (open) { renderOverview(); }
    });
    $("filters-toggle").addEventListener("click", function () {
      var open = !$("filters").classList.contains("open");
      $("filters").classList.toggle("open", open);
      $("filters-toggle").setAttribute("aria-expanded", String(open));
    });
    $("grid").addEventListener("click", function (e) {
      var card = e.target.closest(".card");
      if (card) { openCard(card.getAttribute("data-id")); }
    });
    $("m-close").addEventListener("click", closeModal);
    $("modal").addEventListener("click", function (e) { if (e.target === $("modal")) { closeModal(); } });
    $("m-prev").addEventListener("click", function () { step(-1); });
    $("m-next").addEventListener("click", function () { step(1); });
    document.addEventListener("keydown", function (e) {
      var typingNow = /^(INPUT|SELECT|TEXTAREA)$/.test((document.activeElement || {}).tagName || "");
      if (e.key === "Escape") { closeModal(); }
      else if (!$("modal").hidden && e.key === "ArrowLeft") { step(-1); }
      else if (!$("modal").hidden && e.key === "ArrowRight") { step(1); }
      else if (e.key === "/" && !typingNow && $("modal").hidden) { e.preventDefault(); $("q").focus(); }
    });
    window.addEventListener("hashchange", function () {
      // (a pasted or followed link with other filters: the page's own changes use replaceState, which does not fire this)
      var params = new URLSearchParams(location.hash.slice(1)), fresh = readHash();
      if (JSON.stringify(fresh) !== JSON.stringify(state)) { state = fresh; apply(); }
      if (params.has("card") && params.get("card") !== openId) { openCard(params.get("card")); }
      else if (!params.has("card") && openId) { closeModal(); }
    });
  }

  function start(json) {
    data = json;
    cards = data.cards;
    data.rarities.forEach(function (r, n) { rarityIndex[r.id] = n; rarityById[r.id] = r; });
    data.packs.forEach(function (p) {
      packName[p.id] = p.name;
      packIds[p.id] = {};
      p.cards.forEach(function (id) { packIds[p.id][id] = true; });
    });
    cards.forEach(function (c) {
      byId[c.id] = c;
      var tagText = Object.keys(c.tags).map(function (k) { return c.tags[k].map(function (w) { return w.replace(/_/g, " "); }).join(" "); }).join(" ");
      c._hay = (c.name + " " + c.desc + " " + c.kind + " " + c.rarity + " " + tagText + " " + c.collection + " " + c.id.replace(/_/g, " ")).toLowerCase();
    });
    state = readHash();
    wire();
    apply();
    var open = new URLSearchParams(location.hash.slice(1)).get("card");
    if (open) { openCard(open); }
  }

  fetch("cards.json").then(function (r) {
    if (!r.ok) { throw new Error(r.status); }
    return r.json();
  }).then(start).catch(function (err) {
    $("count").textContent = "Could not load cards.json (" + err.message + "). If you opened this file directly, serve the docs folder instead, e.g. python -m http.server in docs/.";
  });
})();
