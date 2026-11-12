(function () {
    function initSlider() {
        var track = document.getElementById('sliderTrack');
        var prevBtn = document.getElementById('prevBtn');
        var nextBtn = document.getElementById('nextBtn');
        var dotsContainer = document.getElementById('dotsContainer');
        var counter = document.getElementById('slideCount');
        var root = document.getElementById('hvSlider');
        if (!track || !root) return;

        var slides = track.querySelectorAll('.hv-slide');
        var total = slides.length;
        if (!total) return;

        var current = 0;
        var timer = null;
        var delay = 5500;
        var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

        function pad(n) { return (n < 10 ? '0' : '') + n; }

        function render() {
            track.style.transform = 'translateX(' + (-current * 100) + '%)';
            for (var i = 0; i < slides.length; i++) {
                slides[i].classList.toggle('is-current', i === current);
                slides[i].setAttribute('aria-hidden', i === current ? 'false' : 'true');
            }
            var dots = dotsContainer.children;
            for (var d = 0; d < dots.length; d++) {
                dots[d].classList.toggle('active', d === current);
                dots[d].setAttribute('aria-selected', d === current ? 'true' : 'false');
            }
            if (counter) counter.textContent = pad(current + 1) + ' / ' + pad(total);
        }

        function go(i) {
            current = (i + total) % total;
            render();
        }

        function start() { if (!reduce) { stop(); timer = setInterval(function () { go(current + 1); }, delay); } }
        function stop() { if (timer) { clearInterval(timer); timer = null; } }
        function restart() { stop(); start(); }

        dotsContainer.innerHTML = '';
        for (var i = 0; i < total; i++) {
            (function (idx) {
                var dot = document.createElement('button');
                dot.type = 'button';
                dot.className = 'dot';
                dot.setAttribute('role', 'tab');
                dot.setAttribute('aria-label', 'Go to slide ' + (idx + 1));
                dot.addEventListener('click', function () { go(idx); restart(); });
                dotsContainer.appendChild(dot);
            })(i);
        }

        if (prevBtn) prevBtn.addEventListener('click', function () { go(current - 1); restart(); });
        if (nextBtn) nextBtn.addEventListener('click', function () { go(current + 1); restart(); });

        // swipe
        var startX = 0;
        root.addEventListener('touchstart', function (e) { startX = e.changedTouches[0].screenX; }, { passive: true });
        root.addEventListener('touchend', function (e) {
            var diff = e.changedTouches[0].screenX - startX;
            if (Math.abs(diff) > 50) { go(diff > 0 ? current - 1 : current + 1); restart(); }
        }, { passive: true });

        // keyboard + pause on hover/focus
        root.addEventListener('keydown', function (e) {
            if (e.key === 'ArrowLeft') { go(current - 1); restart(); }
            if (e.key === 'ArrowRight') { go(current + 1); restart(); }
        });
        root.addEventListener('mouseenter', stop);
        root.addEventListener('mouseleave', start);
        root.addEventListener('focusin', stop);
        root.addEventListener('focusout', start);
        document.addEventListener('visibilitychange', function () { document.hidden ? stop() : start(); });

        render();
        start();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initSlider);
    } else {
        initSlider();
    }
})();
