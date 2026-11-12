<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Harvesta Fresh Market - farm-fresh groceries, bakery, dairy and everyday essentials delivered to your door.">
    <title>Harvesta Fresh Market | Fresh Groceries Delivered</title>
    <link rel="preconnect" href="https://images.pexels.com" crossorigin>
    <link rel="stylesheet" href="/css/pages/home.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body class="hv-home" style="margin:0">

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<!-- ============================== HERO ============================== -->
<section class="hv-hero">
    <div class="hv-hero-grid">
        <div>
            <span class="hv-eyebrow"><i class="fa-solid fa-seedling"></i> Farm to doorstep in 2 hours</span>
            <h1>Groceries that taste like they were <em>picked this morning</em></h1>
            <p class="hv-sub">Crisp produce, warm-from-the-oven bread, fresh dairy and pantry favourites &mdash; chosen by hand, packed with care and delivered while it&rsquo;s still at its best.</p>
            <div class="hv-cta-row">
                <a href="/products" class="hv-btn hv-btn-primary hv-btn-lg"><i class="fa-solid fa-basket-shopping"></i> Start shopping</a>
                <a href="/deals" class="hv-btn hv-btn-ghost hv-btn-lg"><i class="fa-solid fa-tags"></i> See today&rsquo;s deals</a>
            </div>
            <div class="hv-stats">
                <div class="hv-stat"><b>50k+</b><span>Happy families</span></div>
                <div class="hv-stat"><b>4.9/5</b><span>Customer rating</span></div>
                <div class="hv-stat"><b>2 hrs</b><span>Average delivery</span></div>
            </div>
        </div>

        <div class="hv-hero-visual">
            <div class="hv-arch">
                <img src="https://images.pexels.com/photos/7658474/pexels-photo-7658474.jpeg?auto=compress&cs=tinysrgb&w=1000"
                     alt="Colourful fresh vegetables on a market stall" fetchpriority="high"
                     onerror="this.style.display='none'">
            </div>
            <div class="hv-float f1">
                <span class="ic"><i class="fa-solid fa-leaf"></i></span>
                <div><b>Hand-picked</b><small>Quality checked daily</small></div>
            </div>
            <div class="hv-float f2">
                <span class="ic"><i class="fa-solid fa-truck-fast"></i></span>
                <div><b>Delivery</b><small>30&ndash;120 min slots</small></div>
            </div>
            <div class="hv-float f3">
                <span class="ic"><i class="fa-solid fa-star"></i></span>
                <div><b>4.9 rated</b><small class="hv-stars"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></small></div>
            </div>
        </div>
    </div>
</section>

<!-- ============================ IMAGE SLIDER ============================ -->
<section class="hv-wrap" style="margin-top:-34px; position:relative; z-index:3;" aria-label="Featured collections">
    <div class="hv-slider" id="hvSlider" aria-roledescription="carousel">
        <div class="slider-track" id="sliderTrack">

            <div class="hv-slide is-current" aria-roledescription="slide" aria-label="1 of 4">
                <img src="https://images.pexels.com/photos/12974963/pexels-photo-12974963.jpeg?auto=compress&cs=tinysrgb&w=1600"
                     alt="Peppers, carrots and leafy greens on a market stall" onerror="this.style.display='none'">
                <div class="hv-slide-copy">
                    <span class="hv-tag"><i class="fa-solid fa-carrot"></i> Fresh produce</span>
                    <h3>Vegetables straight from the farm</h3>
                    <p>Seasonal, locally grown and delivered within hours of harvest.</p>
                    <a href="/products?categories=Fruits" class="hv-btn hv-btn-orange">Shop produce <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>

            <div class="hv-slide" aria-roledescription="slide" aria-label="2 of 4">
                <img src="https://images.pexels.com/photos/12180692/pexels-photo-12180692.jpeg?auto=compress&cs=tinysrgb&w=1600"
                     alt="Fresh fruit arranged on a market stall" loading="lazy" onerror="this.style.display='none'">
                <div class="hv-slide-copy">
                    <span class="hv-tag"><i class="fa-solid fa-apple-whole"></i> Juicy &amp; ripe</span>
                    <h3>Fruit that&rsquo;s ready to eat</h3>
                    <p>Sweet berries, crisp apples and citrus &mdash; ripened naturally and packed with care.</p>
                    <a href="/products?categories=Fruits" class="hv-btn hv-btn-orange">Shop fruit <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>

            <div class="hv-slide" aria-roledescription="slide" aria-label="3 of 4">
                <img src="https://images.pexels.com/photos/1383908/pexels-photo-1383908.jpeg?auto=compress&cs=tinysrgb&w=1600"
                     alt="Freshly baked rustic bread loaves" loading="lazy" onerror="this.style.display='none'">
                <div class="hv-slide-copy">
                    <span class="hv-tag"><i class="fa-solid fa-bread-slice"></i> Bakery</span>
                    <h3>Baked fresh, every single day</h3>
                    <p>Artisan loaves, rolls and pastries with a golden crust and a soft, warm crumb.</p>
                    <a href="/products?categories=Bakery" class="hv-btn hv-btn-orange">Shop bakery <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>

            <div class="hv-slide" aria-roledescription="slide" aria-label="4 of 4">
                <img src="https://images.pexels.com/photos/34622396/pexels-photo-34622396.jpeg?auto=compress&cs=tinysrgb&w=1600"
                     alt="Overhead view of a market stall full of fruit and vegetables" loading="lazy" onerror="this.style.display='none'">
                <div class="hv-slide-copy">
                    <span class="hv-tag"><i class="fa-solid fa-percent"></i> This week</span>
                    <h3>Market-fresh prices, every day</h3>
                    <p>Daily deals on the basics you buy most &mdash; with a price-match promise.</p>
                    <a href="/deals" class="hv-btn hv-btn-orange">View deals <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>
        </div>

        <button type="button" class="slider-btn prev-btn" id="prevBtn" aria-label="Previous slide"><i class="fa-solid fa-chevron-left"></i></button>
        <button type="button" class="slider-btn next-btn" id="nextBtn" aria-label="Next slide"><i class="fa-solid fa-chevron-right"></i></button>
        <div class="dots-container" id="dotsContainer" role="tablist" aria-label="Choose slide"></div>
        <div class="hv-slide-count" id="slideCount">01 / 04</div>
    </div>
</section>

<!-- ============================== CATEGORIES ============================== -->
<section class="hv-section">
    <div class="hv-wrap">
        <div class="hv-section-head">
            <div>
                <span class="hv-eyebrow"><i class="fa-solid fa-store"></i> Browse the aisles</span>
                <h2 class="hv-h2">Shop by category</h2>
            </div>
            <a href="/products" class="hv-link-arrow">View all products <i class="fa-solid fa-arrow-right"></i></a>
        </div>

        <div class="hv-cats">
            <a href="/products?categories=Fruits" class="hv-cat"><span class="ic"><i class="fa-solid fa-apple-whole"></i></span><span><b>Fruits</b><small>Fresh &amp; seasonal</small></span><i class="fa-solid fa-arrow-right go"></i></a>
            <a href="/products?categories=Dairy" class="hv-cat c-blue"><span class="ic"><i class="fa-solid fa-cheese"></i></span><span><b>Dairy</b><small>Milk, cheese &amp; more</small></span><i class="fa-solid fa-arrow-right go"></i></a>
            <a href="/products?categories=Meat" class="hv-cat c-red"><span class="ic"><i class="fa-solid fa-drumstick-bite"></i></span><span><b>Meat</b><small>Quality cuts</small></span><i class="fa-solid fa-arrow-right go"></i></a>
            <a href="/products?categories=Bakery" class="hv-cat c-gold"><span class="ic"><i class="fa-solid fa-bread-slice"></i></span><span><b>Bakery</b><small>Baked daily</small></span><i class="fa-solid fa-arrow-right go"></i></a>
            <a href="/products?categories=Beverages" class="hv-cat c-teal"><span class="ic"><i class="fa-solid fa-bottle-water"></i></span><span><b>Beverages</b><small>Drinks &amp; juices</small></span><i class="fa-solid fa-arrow-right go"></i></a>
            <a href="/products?categories=Snacks" class="hv-cat c-orange"><span class="ic"><i class="fa-solid fa-cookie-bite"></i></span><span><b>Snacks</b><small>Treats &amp; munchies</small></span><i class="fa-solid fa-arrow-right go"></i></a>
            <a href="/products?categories=Frozen" class="hv-cat c-blue"><span class="ic"><i class="fa-regular fa-snowflake"></i></span><span><b>Frozen</b><small>Ready when you are</small></span><i class="fa-solid fa-arrow-right go"></i></a>
            <a href="/products?categories=Household" class="hv-cat c-plum"><span class="ic"><i class="fa-solid fa-broom"></i></span><span><b>Household</b><small>Home essentials</small></span><i class="fa-solid fa-arrow-right go"></i></a>
        </div>
    </div>
</section>

<!-- ======================== FEATURED PRODUCTS (from backend) ======================== -->
<c:if test="${not empty featuredProducts}">
<section class="hv-section">
    <div class="hv-wrap">
        <div class="hv-section-head">
            <div>
                <span class="hv-eyebrow"><i class="fa-solid fa-heart"></i> Customer favourites</span>
                <h2 class="hv-h2">Featured this week</h2>
            </div>
            <a href="/products" class="hv-link-arrow">Shop everything <i class="fa-solid fa-arrow-right"></i></a>
        </div>
        <div class="hv-products">
            <c:forEach var="product" items="${featuredProducts}" begin="0" end="7">
                <article class="hv-pcard">
                    <div class="hv-pimg">
                        <c:if test="${product.dealActive}"><span class="hv-pbadge">DEAL</span></c:if>
                        <c:choose>
                            <c:when test="${not empty product.image && (fn:startsWith(product.image, 'http://') || fn:startsWith(product.image, 'https://') || fn:startsWith(product.image, '/'))}">
                                <img src="<c:out value='${product.image}'/>" alt="<c:out value='${product.name}'/>" loading="lazy"
                                     onerror="this.outerHTML='<span class=&quot;fallback&quot;><i class=&quot;fa-solid fa-basket-shopping&quot;></i></span>'">
                            </c:when>
                            <c:otherwise>
                                <span class="fallback"><i class="fa-solid fa-basket-shopping"></i></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="hv-pbody">
                        <span class="hv-pcat"><c:out value="${product.category}"/></span>
                        <span class="hv-pname"><c:out value="${product.name}"/></span>
                        <div class="hv-prate">
                            <span class="hv-stars"><i class="fa-solid fa-star"></i></span>
                            <span><fmt:formatNumber value="${product.rating != null ? product.rating : 0}" pattern="0.0"/>
                                <c:if test="${product.reviewCount != null && product.reviewCount > 0}">(${product.reviewCount})</c:if></span>
                        </div>
                        <div class="hv-price">
                            <b>$<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></b>
                            <c:if test="${product.originalPrice != null && product.originalPrice > product.price}">
                                <s>$<fmt:formatNumber value="${product.originalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></s>
                            </c:if>
                        </div>
                        <button type="button" class="hv-padd" onclick="addToCart(${product.id})" <c:if test="${product.stockStatus == 'out'}">disabled</c:if>>
                            <i class="fa-solid fa-cart-plus"></i>
                            <c:choose><c:when test="${product.stockStatus == 'out'}">Out of stock</c:when><c:otherwise>Add to cart</c:otherwise></c:choose>
                        </button>
                    </div>
                </article>
            </c:forEach>
        </div>
    </div>
</section>
</c:if>

<!-- ================================ DEALS (from backend) ================================ -->
<c:if test="${not empty deals}">
<section class="hv-section">
    <div class="hv-wrap">
        <div class="hv-section-head">
            <div>
                <span class="hv-eyebrow"><i class="fa-solid fa-bolt"></i> Limited time</span>
                <h2 class="hv-h2">Deals you&rsquo;ll love</h2>
            </div>
            <a href="/deals" class="hv-link-arrow">All deals <i class="fa-solid fa-arrow-right"></i></a>
        </div>
        <div class="hv-products">
            <c:forEach var="product" items="${deals}" begin="0" end="3">
                <article class="hv-pcard">
                    <div class="hv-pimg">
                        <span class="hv-pbadge"><c:choose><c:when test="${product.discountPercentage != null && product.discountPercentage > 0}">${product.discountPercentage}% OFF</c:when><c:otherwise>DEAL</c:otherwise></c:choose></span>
                        <c:choose>
                            <c:when test="${not empty product.image && (fn:startsWith(product.image, 'http://') || fn:startsWith(product.image, 'https://') || fn:startsWith(product.image, '/'))}">
                                <img src="<c:out value='${product.image}'/>" alt="<c:out value='${product.name}'/>" loading="lazy"
                                     onerror="this.outerHTML='<span class=&quot;fallback&quot;><i class=&quot;fa-solid fa-basket-shopping&quot;></i></span>'">
                            </c:when>
                            <c:otherwise>
                                <span class="fallback"><i class="fa-solid fa-basket-shopping"></i></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="hv-pbody">
                        <span class="hv-pcat"><c:out value="${product.category}"/></span>
                        <span class="hv-pname"><c:out value="${product.name}"/></span>
                        <div class="hv-price">
                            <b>$<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></b>
                            <c:if test="${product.originalPrice != null && product.originalPrice > product.price}">
                                <s>$<fmt:formatNumber value="${product.originalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></s>
                            </c:if>
                        </div>
                        <button type="button" class="hv-padd" onclick="addToCart(${product.id})" <c:if test="${product.stockStatus == 'out'}">disabled</c:if>>
                            <i class="fa-solid fa-cart-plus"></i>
                            <c:choose><c:when test="${product.stockStatus == 'out'}">Out of stock</c:when><c:otherwise>Add to cart</c:otherwise></c:choose>
                        </button>
                    </div>
                </article>
            </c:forEach>
        </div>
    </div>
</section>
</c:if>

<!-- ============================== WHY HARVESTA ============================== -->
<section class="hv-section">
    <div class="hv-wrap">
        <div class="hv-section-head">
            <div>
                <span class="hv-eyebrow"><i class="fa-solid fa-shield-heart"></i> Why Harvesta</span>
                <h2 class="hv-h2">Better groceries, without the effort</h2>
            </div>
        </div>
        <div class="hv-bento">
            <div class="hv-feat"><span class="ic"><i class="fa-solid fa-truck-fast"></i></span><h3>Fast delivery</h3><p>Get your order within 2 hours. Free delivery above $50, with live tracking from store to door.</p></div>
            <div class="hv-feat"><span class="ic"><i class="fa-solid fa-leaf"></i></span><h3>Truly fresh</h3><p>Fresh and organic picks sourced from local farms and trusted suppliers, checked before they ship.</p></div>
            <div class="hv-feat"><span class="ic"><i class="fa-solid fa-hand-holding-dollar"></i></span><h3>Fair prices</h3><p>Competitive everyday prices, daily deals and a price-match promise on the basics.</p></div>
            <div class="hv-feat"><span class="ic"><i class="fa-solid fa-headset"></i></span><h3>Real support</h3><p>Friendly help around the clock, easy returns and loyalty rewards on every order.</p></div>
        </div>
    </div>
</section>

<!-- ============================== HOW IT WORKS ============================== -->
<section class="hv-section">
    <div class="hv-wrap">
        <div class="hv-section-head">
            <div>
                <span class="hv-eyebrow"><i class="fa-solid fa-route"></i> How it works</span>
                <h2 class="hv-h2">From shelf to doorstep in three steps</h2>
            </div>
        </div>
        <div class="hv-steps">
            <div class="hv-step"><span class="ic"><i class="fa-solid fa-magnifying-glass"></i></span><h3>Choose what you need</h3><p>Browse aisles or search by name, add items to your cart and pick a delivery address.</p></div>
            <div class="hv-step"><span class="ic"><i class="fa-solid fa-box-open"></i></span><h3>We pick &amp; pack</h3><p>Our team hand-selects every item and packs it carefully so it arrives in perfect shape.</p></div>
            <div class="hv-step"><span class="ic"><i class="fa-solid fa-house-circle-check"></i></span><h3>Delivered to you</h3><p>Track your order live and receive it at your door &mdash; usually within two hours.</p></div>
        </div>
    </div>
</section>

<!-- ================================ PROMO ================================ -->
<section class="hv-section">
    <div class="hv-wrap">
        <div class="hv-promo">
            <div>
                <span class="hv-tag"><i class="fa-solid fa-bolt"></i> Today only</span>
                <h2>Extra 15% cashback on your order</h2>
                <p>Up to 40% off organic groceries, plus a free ice cream on orders over $60. Limited time.</p>
            </div>
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <a href="/register" class="hv-btn hv-btn-orange hv-btn-lg"><i class="fa-solid fa-gift"></i> Create free account</a>
                </c:when>
                <c:otherwise>
                    <a href="/products" class="hv-btn hv-btn-orange hv-btn-lg"><i class="fa-solid fa-basket-shopping"></i> Start shopping</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- ============================== TESTIMONIALS ============================== -->
<section class="hv-section">
    <div class="hv-wrap">
        <div class="hv-section-head">
            <div>
                <span class="hv-eyebrow"><i class="fa-solid fa-star"></i> Rated 4.9/5 by 12k+ customers</span>
                <h2 class="hv-h2">Loved by local families</h2>
            </div>
        </div>
        <div class="hv-quotes">
            <div class="hv-quote"><i class="fa-solid fa-quote-right q"></i><span class="hv-stars"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></span><p>Harvesta changed the way I shop. The produce is genuinely fresh and the delivery is super fast.</p><div class="hv-who"><span class="hv-av">E</span><div><b>Emily R.</b><small>Weekly customer</small></div></div></div>
            <div class="hv-quote"><i class="fa-solid fa-quote-right q"></i><span class="hv-stars"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></span><p>The bakery section is my favourite. Bread arrives still soft, and the deals really do add up.</p><div class="hv-who"><span class="hv-av">M</span><div><b>Marcus T.</b><small>Family of four</small></div></div></div>
            <div class="hv-quote"><i class="fa-solid fa-quote-right q"></i><span class="hv-stars"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></span><p>Easy to order, easy to track, and support sorted out a missing item within minutes.</p><div class="hv-who"><span class="hv-av">A</span><div><b>Aisha K.</b><small>New customer</small></div></div></div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<!-- ============================== SLIDER SCRIPT ============================== -->
<script src="/js/pages/home.js"></script>
</body>
</html>
