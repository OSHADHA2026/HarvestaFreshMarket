<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>About Us | Harvesta Fresh Market</title>
    <link rel="preconnect" href="https://images.pexels.com" crossorigin>
    <link rel="stylesheet" href="/css/pages/about.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body class="ab-body">
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<!-- ===================== HERO: headline + photo mosaic ===================== -->
<header class="ab-hero">
    <div class="ab-wrap ab-hero-grid">
        <div>
            <span class="ab-eyebrow"><i class="fa-solid fa-leaf"></i> About Harvesta</span>
            <h1>Good food, <em>honestly</em> delivered.</h1>
            <p>Your trusted partner for fresh groceries and everyday essentials delivered right to your doorstep &mdash; made by people who care what ends up on your table.</p>
            <div class="ab-hero-cta">
                <a href="/products" class="ab-btn ab-btn-dark"><i class="fa-solid fa-basket-shopping"></i> Start shopping</a>
                <a href="/contactus" class="ab-btn ab-btn-line">Talk to us</a>
            </div>
        </div>
        <div class="ab-mosaic" aria-hidden="true">
            <figure class="m1"><img src="https://images.pexels.com/photos/7658474/pexels-photo-7658474.jpeg?auto=compress&cs=tinysrgb&w=700" alt="" onerror="this.style.display='none'"></figure>
            <figure class="m2"><img src="https://images.pexels.com/photos/1383908/pexels-photo-1383908.jpeg?auto=compress&cs=tinysrgb&w=600" alt="" loading="lazy" onerror="this.style.display='none'"></figure>
            <figure class="m3"><img src="https://images.pexels.com/photos/12180692/pexels-photo-12180692.jpeg?auto=compress&cs=tinysrgb&w=600" alt="" loading="lazy" onerror="this.style.display='none'"></figure>
            <div class="ab-since"><b>2015</b><span>Serving fresh<br>since</span></div>
        </div>
    </div>
</header>

<main>
    <!-- ============================== STORY ============================== -->
    <section class="ab-section">
        <div class="ab-wrap ab-story">
            <div class="ab-story-head">
                <span class="ab-eyebrow"><i class="fa-solid fa-book-open"></i> Our story</span>
                <h2>From a small local round to a trusted online market</h2>
            </div>
            <div class="ab-story-body">
                <p>Founded in 2015, Harvesta Fresh Market began as a small local grocery delivery service with a simple mission: to make fresh, high-quality groceries accessible to everyone. Today, we&rsquo;ve grown into a trusted online supermarket serving thousands of happy customers across the country, but our commitment to quality and convenience remains unchanged.</p>
                <div class="ab-mv">
                    <article>
                        <span class="ic"><i class="fa-solid fa-bullseye"></i></span>
                        <h3>Our mission</h3>
                        <p>To provide fresh, high-quality groceries with unparalleled convenience, making healthy eating accessible to everyone while supporting local farmers and sustainable practices.</p>
                    </article>
                    <article>
                        <span class="ic"><i class="fa-solid fa-binoculars"></i></span>
                        <h3>Our vision</h3>
                        <p>To become the most trusted online grocery platform, revolutionizing how people shop for food while promoting sustainability and community well-being.</p>
                    </article>
                </div>
            </div>
        </div>
    </section>

    <!-- ============================ MILESTONE RAIL ============================ -->
    <section class="ab-section ab-rail-section">
        <div class="ab-wrap">
            <span class="ab-eyebrow"><i class="fa-solid fa-route"></i> Our journey</span>
            <h2 class="ab-h2">Nine years, five big steps</h2>
        </div>
        <div class="ab-rail" tabindex="0" aria-label="Company milestones, scroll horizontally">
            <article class="ab-ms"><span class="yr">2015</span><h3>Humble beginnings</h3><p>Started as a small local delivery service with just 5 employees and 50 products.</p></article>
            <article class="ab-ms"><span class="yr">2017</span><h3>Digital transformation</h3><p>Launched our first mobile app and expanded our product range to over 1,000 items.</p></article>
            <article class="ab-ms"><span class="yr">2019</span><h3>National expansion</h3><p>Expanded operations to 10 major cities and reached 100,000+ satisfied customers.</p></article>
            <article class="ab-ms"><span class="yr">2022</span><h3>Sustainability focus</h3><p>Implemented eco-friendly packaging and partnered with 200+ local organic farms.</p></article>
            <article class="ab-ms is-now"><span class="yr">2024</span><h3>Today &amp; beyond</h3><p>Serving 500,000+ customers with 5,000+ products and a 2-hour delivery guarantee.</p></article>
        </div>
    </section>

    <!-- ================================ VALUES ================================ -->
    <section class="ab-section">
        <div class="ab-wrap">
            <span class="ab-eyebrow"><i class="fa-solid fa-heart"></i> What we stand for</span>
            <h2 class="ab-h2">Our values</h2>
            <div class="ab-values">
                <article class="v-big">
                    <span class="ic"><i class="fa-solid fa-star"></i></span>
                    <h3>Quality first</h3>
                    <p>We never compromise on quality. Every product is carefully selected and freshness guaranteed.</p>
                </article>
                <article>
                    <span class="ic"><i class="fa-solid fa-rocket"></i></span>
                    <h3>Fast delivery</h3>
                    <p>Your time is precious. We deliver fresh groceries to your doorstep within 2 hours.</p>
                </article>
                <article>
                    <span class="ic"><i class="fa-solid fa-seedling"></i></span>
                    <h3>Sustainability</h3>
                    <p>Committed to eco-friendly practices and supporting local, sustainable agriculture.</p>
                </article>
                <article class="v-wide">
                    <span class="ic"><i class="fa-solid fa-gift"></i></span>
                    <h3>Customer love</h3>
                    <p>Your satisfaction is our priority. We go above and beyond to make you happy.</p>
                </article>
            </div>
        </div>
    </section>

    <!-- ================================ STATS ================================ -->
    <section class="ab-stats">
        <div class="ab-wrap ab-stats-grid">
            <div><b class="ab-count" data-to="500" data-suffix="K+">500K+</b><span>Happy customers</span></div>
            <div><b class="ab-count" data-to="5" data-suffix="K+">5K+</b><span>Products available</span></div>
            <div><b class="ab-count" data-to="50" data-suffix="+">50+</b><span>Cities served</span></div>
            <div><b class="ab-count" data-to="98" data-suffix="%">98%</b><span>Customer satisfaction</span></div>
        </div>
    </section>

    <!-- ================================= TEAM ================================= -->
    <section class="ab-section">
        <div class="ab-wrap">
            <span class="ab-eyebrow"><i class="fa-solid fa-people-group"></i> The people</span>
            <h2 class="ab-h2">Meet our leadership</h2>
            <div class="ab-team">
                <article>
                    <span class="av a1">MC</span>
                    <h3>Michael Chen</h3>
                    <em>CEO &amp; Founder</em>
                    <p>Former retail executive with 15+ years of experience in grocery and supply chain management.</p>
                </article>
                <article>
                    <span class="av a2">SJ</span>
                    <h3>Sarah Johnson</h3>
                    <em>Chief Operations Officer</em>
                    <p>Operations expert focused on creating seamless customer experiences and efficient logistics.</p>
                </article>
                <article>
                    <span class="av a3">DR</span>
                    <h3>David Rodriguez</h3>
                    <em>Head of Procurement</em>
                    <p>Ensures we source the freshest products while maintaining strong relationships with local farmers.</p>
                </article>
            </div>
        </div>
    </section>

    <!-- ================================== CTA ================================== -->
    <section class="ab-section">
        <div class="ab-wrap">
            <div class="ab-cta">
                <div>
                    <h2>Ready to experience the difference?</h2>
                    <p>Join thousands of satisfied customers who trust Harvesta Fresh Market for their daily grocery needs. Fresh products, fast delivery, and exceptional service await you.</p>
                </div>
                <a href="/products" class="ab-btn ab-btn-orange"><i class="fa-solid fa-basket-shopping"></i> Start shopping now</a>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script src="/js/pages/about.js"></script>
</body>
</html>
