// Count-up for the stats band (display only)
document.addEventListener('DOMContentLoaded', function () {
    var nodes = document.querySelectorAll('.ab-count');
    if (!('IntersectionObserver' in window)) return;
    var io = new IntersectionObserver(function (entries) {
        entries.forEach(function (en) {
            if (!en.isIntersecting) return;
            io.unobserve(en.target);
            var el = en.target, to = parseFloat(el.getAttribute('data-to')), suf = el.getAttribute('data-suffix') || '';
            var steps = 50, i = 0;
            var t = setInterval(function () {
                i++;
                el.textContent = Math.round(to * i / steps) + (i >= steps ? suf : '');
                if (i >= steps) clearInterval(t);
            }, 30);
        });
    }, { threshold: 0.4 });
    nodes.forEach(function (n) { io.observe(n); });
});
