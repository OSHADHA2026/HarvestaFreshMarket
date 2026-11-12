/*
 * Currency switcher (USD <-> LKR), display only.
 *
 * Prices are stored, calculated and charged in USD by the backend. This script converts the dollar
 * amounts that appear on the page (server-rendered AND script-generated) to Sri Lankan rupees using the
 * current exchange rate, and converts them back when the visitor switches to USD.
 *
 *  - Live rate: fetched in the browser (open.er-api.com, then a jsDelivr currency feed) and cached for 6 hours.
 *  - If both services fail the last cached rate is used, otherwise FALLBACK_RATE (shown as "approximate").
 *  - The choice is remembered in localStorage ("hv-currency"); markup: partials/navbar.jsp (#hvCurrency).
 */
(function () {
    'use strict';

    var KEY = 'hv-currency';
    var FX_KEY = 'hv-fx';
    var TTL = 6 * 60 * 60 * 1000;
    var FALLBACK_RATE = 332.21;                         // LKR per 1 USD, used only if no live/cached rate is available
    var USD_PATTERN = /\$\s?(\d{1,3}(?:,\d{3})+|\d+)(\.\d+)?/g;

    var root = document.documentElement;
    var path = location.pathname || '';
    if (path.indexOf('/admin') === 0) {              // admin screens manage the real USD prices
        var adminBox = document.getElementById('hvCurrency');
        if (adminBox) adminBox.style.display = 'none';
        return;
    }

    var currency = 'USD';
    try { currency = localStorage.getItem(KEY) === 'LKR' ? 'LKR' : 'USD'; } catch (e) {}
    var rate = FALLBACK_RATE;
    var rateMeta = { live: false, ts: 0 };

    var tracked = new Set();                         // text nodes we converted: node -> {usd, shown}
    var meta = new WeakMap();
    var observer = null;
    var queued = false;

    /* ---------- formatting ---------- */
    function formatLKR(value) {
        return 'Rs. ' + value.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }
    function toLKR(text) {
        return text.replace(USD_PATTERN, function (m, whole, dec) {
            var usd = parseFloat(whole.replace(/,/g, '') + (dec || ''));
            return formatLKR(usd * rate);
        });
    }

    /* ---------- DOM conversion ---------- */
    function eligible(node) {
        var p = node.parentNode;
        if (!p) return false;
        var tag = p.nodeName;
        if (tag === 'SCRIPT' || tag === 'STYLE' || tag === 'TEXTAREA' || tag === 'NOSCRIPT' || tag === 'OPTION') return false;
        if (p.closest && p.closest('#hvCurrency')) return false;
        return true;
    }

    function convertNode(node) {
        var info = meta.get(node);
        if (info && node.nodeValue === info.shown) {          // already shows our conversion
            if (currency === 'USD') { node.nodeValue = info.usd; tracked.delete(node); meta.delete(node); }
            else { var again = toLKR(info.usd); if (again !== info.shown) { node.nodeValue = again; info.shown = again; } }
            return;
        }
        // text changed by the page (or never converted): look for dollar amounts
        if (info) { tracked.delete(node); meta.delete(node); }
        if (currency !== 'LKR') return;
        var value = node.nodeValue;
        USD_PATTERN.lastIndex = 0;
        if (!USD_PATTERN.test(value)) return;
        USD_PATTERN.lastIndex = 0;
        var shown = toLKR(value);
        node.nodeValue = shown;
        meta.set(node, { usd: value, shown: shown });
        tracked.add(node);
    }

    function walk(scope) {
        if (!scope) return;
        if (scope.nodeType === 3) { if (eligible(scope)) convertNode(scope); return; }
        if (scope.nodeType !== 1 && scope.nodeType !== 9) return;
        var w = document.createTreeWalker(scope, NodeFilter.SHOW_TEXT, null);
        var n, batch = [];
        while ((n = w.nextNode())) batch.push(n);
        for (var i = 0; i < batch.length; i++) if (eligible(batch[i])) convertNode(batch[i]);
    }

    function restoreAll() {
        tracked.forEach(function (node) {
            var info = meta.get(node);
            if (info && node.nodeValue === info.shown) node.nodeValue = info.usd;
        });
        tracked.clear();
    }

    function refreshAll() {
        pause();
        if (currency === 'USD') restoreAll();
        else {
            tracked.forEach(function (node) {                  // re-price already converted nodes with a new rate
                if (!node.isConnected) { tracked.delete(node); return; }
                convertNode(node);
            });
            walk(document.body);
        }
        updateUi();
        resume();
    }

    /* ---------- reacting to page updates (cart totals, wishlist, fetch-rendered cards, ...) ---------- */
    var pending = [];
    function onMutations(records) {
        if (currency !== 'LKR') return;
        for (var i = 0; i < records.length; i++) {
            var r = records[i];
            if (r.type === 'characterData') pending.push(r.target);
            else for (var j = 0; j < r.addedNodes.length; j++) pending.push(r.addedNodes[j]);
        }
        if (queued) return;
        queued = true;
        (window.requestAnimationFrame || setTimeout)(function () {
            queued = false;
            var items = pending; pending = [];
            pause();
            for (var k = 0; k < items.length; k++) if (items[k].isConnected !== false) walk(items[k]);
            addNote();
            resume();
        });
    }
    function resume() {
        if (!observer) observer = new MutationObserver(onMutations);
        observer.observe(document.body, { childList: true, subtree: true, characterData: true });
    }
    function pause() { if (observer) observer.disconnect(); }

    /* ---------- UI ---------- */
    function rateText() {
        var t = '1 USD = ' + formatLKR(rate);
        if (!rateMeta.live) return t + ' (approximate)';
        var d = new Date(rateMeta.ts);
        return t + ' (updated ' + d.toLocaleDateString() + ' ' + d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) + ')';
    }

    function addNote() {
        var note = document.getElementById('hvFxNote');
        var summary = document.querySelector('.order-summary');
        if (currency !== 'LKR' || !summary) { if (note && note.parentNode) note.parentNode.removeChild(note); return; }
        if (!note) {
            note = document.createElement('p');
            note.id = 'hvFxNote';
            note.className = 'hv-fx-note';
            summary.appendChild(note);
        }
        note.textContent = 'Shown in LKR at ' + rateText() + '. Your order is processed in USD.';
    }

    function updateUi() {
        root.setAttribute('data-currency', currency);
        var box = document.getElementById('hvCurrency');
        if (box) {
            var buttons = box.querySelectorAll('button[data-cur]');
            var currentCode = box.querySelector('[data-current-code]');
            var currentFlag = box.querySelector('[data-current-flag]');
            var trigger = document.getElementById('hvCurrencyTrigger');
            for (var i = 0; i < buttons.length; i++) {
                var on = buttons[i].getAttribute('data-cur') === currency;
                buttons[i].setAttribute('aria-checked', on ? 'true' : 'false');
                if (on && currentFlag) currentFlag.src = buttons[i].querySelector('img').src;
            }
            if (currentCode) currentCode.textContent = currency;
            if (trigger) {
                var name = currency === 'LKR' ? 'Sri Lankan rupee' : 'US dollar';
                trigger.setAttribute('aria-label', 'Currency: ' + name + '. Open currency menu');
                trigger.title = currency === 'LKR' ? rateText() : 'Show prices in Sri Lankan rupees';
            }
        }
        addNote();
    }

    function setCurrency(next) {
        currency = next === 'LKR' ? 'LKR' : 'USD';
        try { localStorage.setItem(KEY, currency); } catch (e) {}
        refreshAll();
    }

    /* ---------- exchange rate ---------- */
    function accept(value, live) {
        value = parseFloat(value);
        if (!(value > 50 && value < 2000)) return false;
        rate = value; rateMeta = { live: !!live, ts: Date.now() };
        if (live) { try { localStorage.setItem(FX_KEY, JSON.stringify({ rate: value, ts: rateMeta.ts })); } catch (e) {} }
        return true;
    }

    function loadRate() {
        var cached = null;
        try { cached = JSON.parse(localStorage.getItem(FX_KEY) || 'null'); } catch (e) {}
        if (cached && cached.rate > 50) { rate = cached.rate; rateMeta = { live: true, ts: cached.ts }; }
        if (cached && Date.now() - cached.ts < TTL) return;           // fresh enough
        if (!window.fetch) return;

        fetch('https://open.er-api.com/v6/latest/USD')
            .then(function (r) { return r.json(); })
            .then(function (d) { if (!d || !d.rates || !accept(d.rates.LKR, true)) throw new Error('bad rate'); })
            .catch(function () {
                return fetch('https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json')
                    .then(function (r) { return r.json(); })
                    .then(function (d) { if (!d || !d.usd || !accept(d.usd.lkr, true)) throw new Error('bad rate'); });
            })
            .then(function () { refreshAll(); })
            .catch(function () { /* keep cached / fallback rate */ });
    }

    /* ---------- start ---------- */
    function init() {
        var box = document.getElementById('hvCurrency');
        var trigger = document.getElementById('hvCurrencyTrigger');
        var menu = document.getElementById('hvCurrencyMenu');
        function closeMenu(returnFocus) {
            if (!menu || !trigger) return;
            menu.hidden = true;
            trigger.setAttribute('aria-expanded', 'false');
            if (returnFocus) trigger.focus();
        }
        if (box && trigger && menu) {
            box.addEventListener('click', function (e) {
                var option = e.target.closest ? e.target.closest('button[data-cur]') : null;
                if (option) {
                    setCurrency(option.getAttribute('data-cur'));
                    closeMenu(true);
                    return;
                }
                if (e.target.closest && e.target.closest('#hvCurrencyTrigger')) {
                    var open = menu.hidden;
                    menu.hidden = !open;
                    trigger.setAttribute('aria-expanded', open ? 'true' : 'false');
                    if (open) menu.querySelector('button[data-cur][aria-checked="true"]').focus();
                }
            });
            document.addEventListener('click', function (e) {
                if (!box.contains(e.target)) closeMenu(false);
            });
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape' && !menu.hidden) closeMenu(true);
            });
        }
        loadRate();      // reads the cached rate synchronously (and refreshes it in the background if stale)
        refreshAll();
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init); else init();
})();
