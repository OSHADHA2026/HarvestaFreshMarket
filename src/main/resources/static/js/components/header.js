// ===== Behaviour (same functions / endpoints as before; only the look changed) =====

function confirmLogout() {
    document.getElementById('logoutModal').classList.add('is-open');
}

function closeLogoutModal() {
    var m = document.getElementById('logoutModal');
    if (m) m.classList.remove('is-open');
}

window.addEventListener('click', function (event) {
    var modal = document.getElementById('logoutModal');
    if (modal && event.target === modal) closeLogoutModal();
});

document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') closeLogoutModal();
});

// Mobile menu
(function () {
    var links = document.querySelectorAll('.hv-links a[data-nav-path]');
    var nav = document.querySelector('.hv-links');
    if (nav && links.length) {
        var path = window.location.pathname.replace(/\/+$/, '') || '/';
        var contextPath = nav.getAttribute('data-context-path') || '';
        if (contextPath && (path === contextPath || path.indexOf(contextPath + '/') === 0)) {
            path = path.slice(contextPath.length) || '/';
        }
        if (path === '/index' || path === '/home') path = '/';

        Array.prototype.forEach.call(links, function (link) {
            var linkPath = link.getAttribute('data-nav-path');
            var active = linkPath === '/'
                ? path === '/'
                : path === linkPath || path.indexOf(linkPath + '/') === 0;
            link.classList.toggle('is-active', active);
            if (active) link.setAttribute('aria-current', 'page');
            else link.removeAttribute('aria-current');
        });
    }

    var burger = document.getElementById('hvBurger');
    var panel = document.getElementById('hvPanel');
    if (!burger || !panel) return;
    burger.addEventListener('click', function () {
        var open = panel.classList.toggle('is-open');
        burger.setAttribute('aria-expanded', open ? 'true' : 'false');
        burger.innerHTML = open ? '<i class="fa-solid fa-xmark"></i>' : '<i class="fa-solid fa-bars"></i>';
    });
})();

// Cart badge (skipped on admin pages, as before)
document.addEventListener('DOMContentLoaded', function () {
    if (!window.location.pathname.startsWith('/admin')) {
        updateCartCount();
    }
});

function updateCartCount() {
    fetch('/api/cart/count')
        .then(function (response) { return response.json(); })
        .then(function (data) {
            var el = document.getElementById('cartCount');
            if (el) el.textContent = data.count || 0;
        })
        .catch(function (error) {
            console.error('Error fetching cart count:', error);
        });
}

function addToCart(productId) {
    fetch('/api/cart/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ productId: productId, quantity: 1 })
    })
        .then(function (response) { return response.json(); })
        .then(function (data) {
            if (data.success) {
                showNotification('Added to your cart');
                updateCartCount();
            } else {
                showNotification(data.message, 'error');
            }
        })
        .catch(function () {
            showNotification('Could not add to cart', 'error');
        });
}

// Toast notification (icon is drawn with Font Awesome, no emoji)
function showNotification(message, type) {
    type = type || 'success';
    var toast = document.createElement('div');
    toast.className = 'hv-toast' + (type === 'error' ? ' is-error' : '');
    var icon = document.createElement('i');
    icon.className = type === 'error' ? 'fa-solid fa-triangle-exclamation' : 'fa-solid fa-check';
    var text = document.createElement('span');
    text.textContent = message || '';
    toast.appendChild(icon);
    toast.appendChild(text);
    document.body.appendChild(toast);

    setTimeout(function () { toast.classList.add('is-in'); }, 60);
    setTimeout(function () {
        toast.classList.remove('is-in');
        setTimeout(function () { if (toast.parentNode) toast.parentNode.removeChild(toast); }, 400);
    }, 3000);
}


// Theme toggle (light / dark). The initial theme is applied in partials/head-assets.jsp.
(function () {
    var root = document.documentElement;
    var btn = document.getElementById('hvThemeToggle');

    function isDark() { return root.getAttribute('data-theme') === 'dark'; }

    function paint() {
        if (!btn) return;
        var dark = isDark();
        btn.setAttribute('aria-pressed', dark ? 'true' : 'false');
        btn.setAttribute('aria-label', dark ? 'Switch to light mode' : 'Switch to dark mode');
        btn.title = dark ? 'Switch to light mode' : 'Switch to dark mode';
    }

    function setTheme(dark, remember) {
        if (dark) root.setAttribute('data-theme', 'dark'); else root.removeAttribute('data-theme');
        if (remember) { try { localStorage.setItem('hv-theme', dark ? 'dark' : 'light'); } catch (e) {} }
        paint();
    }

    if (btn) btn.addEventListener('click', function () { setTheme(!isDark(), true); });

    // follow the OS setting until the visitor makes an explicit choice
    if (window.matchMedia) {
        var mq = window.matchMedia('(prefers-color-scheme: dark)');
        var onChange = function (e) {
            var saved = null;
            try { saved = localStorage.getItem('hv-theme'); } catch (err) {}
            if (!saved) setTheme(e.matches, false);
        };
        if (mq.addEventListener) mq.addEventListener('change', onChange);
    }
    paint();
})();
