<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Today's Deals</title>
    <link rel="stylesheet" href="/css/pages/deals.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="deals-header">
    <h1 class="deals-title"><i class="fa-solid fa-fire" aria-hidden="true"></i> Today's Hot Deals</h1>
    <p class="deals-subtitle">Limited time offers - Don't miss out on these amazing discounts!</p>
    <!--<div class="timer">
        ⏰ Deal ends in: <span id="countdown">23:59:59</span>
    </div>-->
</div>

<div class="deals-container">
    <h2 class="section-title">Featured Deals</h2>

    <!-- Category Filters -->
    <div class="categories">
        <a href="/deals?sort=${sort}"
           class="category-btn ${empty selectedCategory ? 'active' : ''}">
            All Deals
        </a>
        <c:forEach var="cat" items="${categories}">
            <a href="/deals?category=${fn:escapeXml(cat)}&sort=${sort}"
               class="category-btn ${selectedCategory == cat ? 'active' : ''}">
                <c:choose>
                    <c:when test="${cat == 'Fruits'}"> <i class="fa-solid fa-apple-whole" aria-hidden="true"></i> </c:when>
                    <c:when test="${cat == 'Dairy'}"> <i class="fa-solid fa-cheese" aria-hidden="true"></i> </c:when>
                    <c:when test="${cat == 'Meat'}"> <i class="fa-solid fa-drumstick-bite" aria-hidden="true"></i> </c:when>
                    <c:when test="${cat == 'Beverages'}"> <i class="fa-solid fa-bottle-water" aria-hidden="true"></i> </c:when>
                    <c:when test="${cat == 'Snacks'}"> <i class="fa-solid fa-cookie-bite" aria-hidden="true"></i> </c:when>
                    <c:when test="${cat == 'Household'}"> <i class="fa-solid fa-house" aria-hidden="true"></i> </c:when>
                    <c:when test="${cat == 'Bakery'}"> <i class="fa-solid fa-bread-slice" aria-hidden="true"></i> </c:when>
                    <c:otherwise> <i class="fa-solid fa-box" aria-hidden="true"></i> </c:otherwise>
                </c:choose>
                    ${cat}
            </a>
        </c:forEach>
    </div>

    <!-- Filters and Sort -->
    <div class="deals-filters">
        <div class="results-count">
            Showing ${dealCount} deals
            <c:if test="${not empty selectedCategory}">in ${selectedCategory}</c:if>
        </div>
        <div style="display: flex; align-items: center;">
            <div class="sort-options">
                <label for="sort">Sort by:</label>
                <select class="sort-select" id="sort" onchange="sortDeals(this.value)">
                    <option value="featured" ${sort == 'featured' ? 'selected' : ''}>Featured</option>
                    <option value="price-low" ${sort == 'price-low' ? 'selected' : ''}>Price: Low to High</option>
                    <option value="price-high" ${sort == 'price-high' ? 'selected' : ''}>Price: High to Low</option>
                    <option value="discount" ${sort == 'discount' ? 'selected' : ''}>Highest Discount</option>
                    <option value="ending-soon" ${sort == 'ending-soon' ? 'selected' : ''}>Ending Soon</option>
                </select>
            </div>
            <div class="reset-filters">
                <a href="/deals" class="btn-reset">Reset Filters</a>
            </div>
        </div>
    </div>

    <!-- Deals Grid -->
    <div class="deals-grid">
        <c:choose>
            <c:when test="${not empty allDeals and dealCount > 0}">
                <c:forEach var="product" items="${allDeals}">
                    <div class="deal-card ${product.stock <= product.minStock ? 'limited-stock' : ''}">
                        <!-- Deal Badge -->
                        <c:if test="${product.originalPrice != null and product.originalPrice > product.price}">
                            <div class="deal-badge">
                                <c:choose>
                                    <c:when test="${product.discountPercentage != null}">
                                        ${product.discountPercentage}% OFF
                                    </c:when>
                                    <c:otherwise>
                                        SALE
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <!-- Product Image -->
                        <div class="deal-image">
                            <div class="deal-image-media">
                                <c:choose>
                                    <c:when test="${not empty product.image && (fn:startsWith(product.image, 'http://') || fn:startsWith(product.image, 'https://') || fn:startsWith(product.image, '/'))}">
                                        <img src="<c:out value='${product.image}' />" 
                                             alt="<c:out value='${product.name}' />" 
                                             onerror="handleImageError(this);">
                                    </c:when>
                                    <c:when test="${not empty product.image && fn:length(product.image) <= 10}">
                                        <span class="emoji-fallback"><c:out value="${product.image}" /></span>
                                    </c:when>
                                    <c:when test="${not empty product.image}">
                                        <img src="<c:out value='${product.image}' />" 
                                             alt="<c:out value='${product.name}' />" 
                                             onerror="handleImageError(this);">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="emoji-fallback"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:if test="${product.dealExpiry != null}">
                                <div class="deal-countdown-overlay">
                                    <span class="deal-countdown-label">Ends in</span>
                                    <span class="deal-countdown-value"
                                          id="dealTimer${product.id}"
                                          data-expiry="<c:out value='${product.dealExpiry}' />">--:--:--</span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Product Details -->
                        <div class="deal-content">
                            <h3 class="deal-title">${product.name}</h3>
                            <p class="deal-description">${fn:substring(product.description, 0, 100)}<c:if test="${fn:length(product.description) > 100}">...</c:if></p>

                            <!-- Price -->
                            <div class="deal-price">
                                <span class="current-price">
                                    $<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </span>
                                <c:if test="${product.originalPrice != null and product.originalPrice > product.price}">
                                    <span class="original-price">
                                        $<fmt:formatNumber value="${product.originalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </span>
                                </c:if>
                            </div>

                            <!-- Stock Info -->
                            <div class="stock-info">
                                <c:choose>
                                    <c:when test="${product.stock == 0}">
                                        <span class="stock-out"><i class="fa-solid fa-circle-xmark" aria-hidden="true"></i> Out of Stock</span>
                                    </c:when>
                                    <c:when test="${product.stock <= product.minStock}">
                                        <span class="stock-low"><i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i> Only ${product.stock} left!</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="stock-in"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> In Stock</span>
                                    </c:otherwise>
                                </c:choose>
                                <span style="margin-left: auto; font-size: 11px; color: #95a5a6;">
                                    <c:if test="${not empty product.weight}">${product.weight}</c:if>
                                    <c:if test="${not empty product.unit}">${product.unit}</c:if>
                                </span>
                            </div>

                            <!-- Stats -->
                            <div class="deal-stats">
                                <span class="sold-count"><i class="fa-solid fa-fire" aria-hidden="true"></i> ${product.soldCount} sold</span>
                                <span class="rating">
                                    <c:forEach begin="1" end="5" var="star">
                                        <c:choose>
                                            <c:when test="${product.rating != null and star <= product.rating}">★</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    (<fmt:formatNumber value="${product.rating}" pattern="#.##"/>)
                                </span>
                            </div>

                            <!-- Add to Cart Button -->
                            <button type="button" class="btn-deal"
                                    data-product-id="${product.id}"
                                    onclick="addToCart(this)"
                                <c:if test="${product.stock == 0}">disabled</c:if>>
                                    <c:choose>
                                        <c:when test="${product.stock == 0}"><i class="fa-solid fa-ban" aria-hidden="true"></i> Out of Stock</c:when>
                                        <c:otherwise><i class="fa-solid fa-cart-plus" aria-hidden="true"></i> Add to Cart</c:otherwise>
                                    </c:choose>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="icon"><i class="fa-solid fa-face-frown" aria-hidden="true"></i></div>
                    <h3>No deals available at the moment</h3>
                    <p>Check back soon for amazing discounts!</p>
                    <a href="/products" class="btn-nav" style="display: inline-block; margin-top: 20px;">Browse All Products</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Flash Sales Section -->
<c:if test="${not empty flashSales and fn:length(flashSales) > 0}">
    <div class="flash-sales">
        <div class="deals-container">
            <h2 class="section-title" style="color: white;"><i class="fa-solid fa-bolt" aria-hidden="true"></i> Flash Sales Ending Soon</h2>
            <div class="flash-grid">
                <c:forEach var="flashProduct" items="${flashSales}" varStatus="status">
                    <c:if test="${status.index < 4}">
                        <div class="flash-card">
                            <div class="flash-icon">
                                <c:choose>
                                    <c:when test="${not empty flashProduct.image && (fn:startsWith(flashProduct.image, 'http://') || fn:startsWith(flashProduct.image, 'https://') || fn:startsWith(flashProduct.image, '/'))}">
                                        <img src="<c:out value='${flashProduct.image}' />" 
                                             alt="<c:out value='${flashProduct.name}' />" 
                                             onerror="handleImageError(this);">
                                    </c:when>
                                    <c:when test="${not empty flashProduct.image && fn:length(flashProduct.image) <= 10}">
                                        <span class="emoji-fallback"><c:out value="${flashProduct.image}" /></span>
                                    </c:when>
                                    <c:when test="${not empty flashProduct.image}">
                                        <img src="<c:out value='${flashProduct.image}' />" 
                                             alt="<c:out value='${flashProduct.name}' />" 
                                             onerror="handleImageError(this);">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="emoji-fallback"><i class="fa-solid fa-bolt" aria-hidden="true"></i></span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h3 class="flash-title">${flashProduct.name}</h3>
                            <p class="flash-text">
                                $<fmt:formatNumber value="${flashProduct.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                <c:if test="${flashProduct.originalPrice != null and flashProduct.originalPrice > flashProduct.price}">
                                    <span style="text-decoration: line-through; opacity: 0.7; margin-left: 5px;">
                                        $<fmt:formatNumber value="${flashProduct.originalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </span>
                                </c:if>
                            </p>
                            <c:if test="${flashProduct.dealExpiry != null}">
                                <div class="flash-countdown-wrap">
                                    <span class="flash-countdown-label">Ends in</span>
                                    <span class="flash-countdown-value"
                                          id="dealExpiry${flashProduct.id}"
                                          data-expiry="<c:out value='${flashProduct.dealExpiry}' />">--:--:--</span>
                                </div>
                            </c:if>
                            <button type="button" class="btn-deal btn-deal-flash"
                                    data-product-id="${flashProduct.id}"
                                    onclick="addToCart(this)"
                                <c:if test="${flashProduct.stock == 0}">disabled</c:if>>
                                    <c:choose>
                                        <c:when test="${flashProduct.stock == 0}"><i class="fa-solid fa-ban" aria-hidden="true"></i> Out of Stock</c:when>
                                        <c:otherwise><i class="fa-solid fa-bolt" aria-hidden="true"></i> Grab Deal</c:otherwise>
                                    </c:choose>
                            </button>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
</c:if>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
    // Simple countdown timer for daily deals
    // Fixed daily countdown timer
    function startDailyCountdown() {
        const countdownElement = document.getElementById('countdown');
        if (!countdownElement) return;

        // Function to calculate time until midnight
        function updateDailyCountdown() {
            const now = new Date();
            const tomorrow = new Date();
            tomorrow.setHours(24, 0, 0, 0); // Set to next day midnight

            const diff = tomorrow - now;

            // If difference is negative or zero, reset for next day
            if (diff <= 0) {
                countdownElement.textContent = '00:00:00';
                // Set timeout to restart at midnight
                const timeUntilMidnight = new Date().setHours(24, 0, 0, 0) - now;
                setTimeout(updateDailyCountdown, timeUntilMidnight);
                return;
            }

            const hours = Math.floor(diff / (1000 * 60 * 60));
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((diff % (1000 * 60)) / 1000);

            countdownElement.textContent =
                `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }

        // Start the countdown
        updateDailyCountdown();
        // Update every second
        setInterval(updateDailyCountdown, 1000);
    }

    function pad2(n) {
        return String(n).padStart(2, '0');
    }

    function parseDealExpiry(value) {
        if (!value) {
            return null;
        }
        let str = String(value).trim();
        if (str.includes(' ')) {
            str = str.replace(' ', 'T');
        }
        if (str.includes('.')) {
            str = str.substring(0, str.indexOf('.'));
        }
        const match = str.match(/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?/);
        if (match) {
            return new Date(
                Number(match[1]),
                Number(match[2]) - 1,
                Number(match[3]),
                Number(match[4]),
                Number(match[5]),
                Number(match[6] || 0)
            );
        }
        const parsed = new Date(str);
        return isNaN(parsed.getTime()) ? null : parsed;
    }

    function formatDealCountdown(diffMs) {
        const totalSeconds = Math.max(0, Math.floor(diffMs / 1000));
        const days = Math.floor(totalSeconds / 86400);
        const hours = Math.floor((totalSeconds % 86400) / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = totalSeconds % 60;

        if (days > 0) {
            return days + 'd ' + pad2(hours) + 'h ' + pad2(minutes) + 'm';
        }
        if (hours > 0) {
            return pad2(hours) + 'h ' + pad2(minutes) + 'm ' + pad2(seconds) + 's';
        }
        return pad2(minutes) + 'm ' + pad2(seconds) + 's';
    }

    function startIndividualDealTimers() {
        const timerElements = document.querySelectorAll('.deal-countdown-value, .flash-countdown-value');

        timerElements.forEach(function (element) {
            const elementId = element.id;
            const expiryDate = parseDealExpiry(element.getAttribute('data-expiry'));

            if (!expiryDate) {
                element.textContent = 'N/A';
                return;
            }

            function updateDealTimer() {
                const diff = expiryDate.getTime() - Date.now();

                if (diff <= 0) {
                    element.textContent = 'Expired';
                    element.classList.add('expired');

                    const productIdMatch = elementId.match(/\d+/);
                    if (productIdMatch) {
                        const productId = productIdMatch[0];
                        const addButton = document.querySelector('.btn-deal[data-product-id="' + productId + '"]');
                        if (addButton) {
                            addButton.textContent = 'Deal Expired';
                            addButton.disabled = true;
                            addButton.style.background = '#95a5a6';
                        }
                    }
                    return;
                }

                element.classList.remove('expired');
                element.textContent = formatDealCountdown(diff);
            }

            updateDealTimer();
            if (element._timerInterval) {
                clearInterval(element._timerInterval);
            }
            element._timerInterval = setInterval(updateDealTimer, 1000);
        });
    }

    // Fixed sortDeals function
    // Save scroll position before navigation
    function saveScrollPosition() {
        const scrollPosition = {
            x: window.pageXOffset || document.documentElement.scrollLeft,
            y: window.pageYOffset || document.documentElement.scrollTop
        };
        sessionStorage.setItem('dealsScrollPosition', JSON.stringify(scrollPosition));
    }

    // Updated sortDeals function
    // Save scroll position to multiple places for reliability
    function sortDeals(sortValue) {
        const scrollY = window.scrollY;

        // Save to multiple locations
        sessionStorage.setItem('dealsScrollY', scrollY.toString());
        localStorage.setItem('tempScrollY', scrollY.toString());
        document.cookie = `scrollY=${scrollY}; path=/`;

        // Create URL
        const currentUrl = new URL(window.location.href);
        const params = new URLSearchParams(currentUrl.search);
        params.set('sort', sortValue);

        if (params.get('category') === 'all') {
            params.delete('category');
        }

        const newUrl = '/deals?' + params.toString();
        window.location.href = newUrl;
    }

    // Restore scroll position
    function restoreScrollPosition() {
        // Try multiple sources
        let scrollY = null;

        // 1. Try sessionStorage
        if (sessionStorage.getItem('dealsScrollY')) {
            scrollY = parseInt(sessionStorage.getItem('dealsScrollY'));
            sessionStorage.removeItem('dealsScrollY');
        }
        // 2. Try localStorage
        else if (localStorage.getItem('tempScrollY')) {
            scrollY = parseInt(localStorage.getItem('tempScrollY'));
            localStorage.removeItem('tempScrollY');
        }
        // 3. Try cookie
        else {
            const cookies = document.cookie.split(';');
            for (let cookie of cookies) {
                cookie = cookie.trim();
                if (cookie.startsWith('scrollY=')) {
                    scrollY = parseInt(cookie.substring(8));
                    break;
                }
            }
            // Clear the cookie
            document.cookie = 'scrollY=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
        }

        if (scrollY && scrollY > 0) {
            // Restore immediately
            window.scrollTo(0, scrollY);

            // Restore after short delays
            const restore = () => window.scrollTo(0, scrollY);
            setTimeout(restore, 10);
            setTimeout(restore, 100);
            setTimeout(restore, 500);

            // Clean up
            localStorage.removeItem('tempScrollY');
            sessionStorage.removeItem('dealsScrollY');
        }
    }

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
        restoreScrollPosition();

        startDailyCountdown();
        startIndividualDealTimers();
        updateCartCount();
    });

    // Also handle reset button
    const resetBtn = document.querySelector('.btn-reset');
    if (resetBtn) {
        resetBtn.addEventListener('click', function(e) {
            e.preventDefault();
            sortDeals('featured');
        });
    }

    // Update reset filters button too
    document.addEventListener('DOMContentLoaded', function() {
        // Restore scroll position
        restoreScrollPosition();

        // Add click handler to reset button
        const resetBtn = document.querySelector('.btn-reset');
        if (resetBtn) {
            resetBtn.addEventListener('click', function(e) {
                e.preventDefault();
                saveScrollPosition();
                window.location.href = '/deals';
            });
        }

        // Start timers
        startDailyCountdown();
        startIndividualDealTimers();
        updateCartCount();
    });

    // Handle image loading errors
    function handleImageError(img) {
        if (img && img.parentElement) {
            img.style.display = 'none';
            var fallback = document.createElement('span');
            fallback.className = 'emoji-fallback';
            fallback.innerHTML = '<i class="fa-solid fa-cart-shopping" aria-hidden="true"></i>';
            img.parentElement.appendChild(fallback);
        }
    }

    // Add to Cart functionality
    function addToCart(button) {
        const productId = button.dataset.productId;
        fetch('/api/cart/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                productId: productId,
                quantity: 1
            })
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showNotification('Product added to cart!', 'success');
                    updateCartCount();

                    // Update button state
                    const cartButton = document.querySelector('.btn-deal[data-product-id="' + productId + '"]');
                    if (cartButton && !cartButton.disabled) {
                        const originalHtml = cartButton.innerHTML;
                        cartButton.innerHTML = '<i class="fa-solid fa-check" aria-hidden="true"></i> Added to cart';
                        cartButton.classList.add('is-added');

                        setTimeout(() => {
                            cartButton.innerHTML = originalHtml;
                            cartButton.classList.remove('is-added');
                        }, 2000);
                    }
                } else {
                    showNotification(data.message || 'Failed to add to cart', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Error adding to cart. Please try again.', 'error');
            });
    }

    // Update cart count
    function updateCartCount() {
        fetch('/api/cart/count')
            .then(response => response.json())
            .then(data => {
                const cartCountElements = document.querySelectorAll('.cart-count');
                cartCountElements.forEach(element => {
                    element.textContent = data.count || 0;
                });
            })
            .catch(error => {
                console.error('Error fetching cart count:', error);
            });
    }

    // Notification system
    function showNotification(message, type = 'success') {
        // Remove any existing notifications
        const existingNotifications = document.querySelectorAll('.notification');
        existingNotifications.forEach(n => n.remove());

        const notification = document.createElement('div');
        notification.className = `notification ${type == 'error' ? 'error' : ''}`;
        notification.textContent = message;

        document.body.appendChild(notification);

        // Animate in
        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
        }, 10);

        // Remove after 3 seconds
        setTimeout(() => {
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                if (notification.parentNode) {
                    document.body.removeChild(notification);
                }
            }, 300);
        }, 3000);
    }

    // Initialize everything when DOM is loaded
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Deals page loaded');

        // Start timers
        startDailyCountdown();
        startIndividualDealTimers();

        // Update cart count
        updateCartCount();

        // Debug: Log current URL parameters
        const urlParams = new URLSearchParams(window.location.search);
        console.log('Current URL parameters:', Object.fromEntries(urlParams.entries()));
        console.log('Selected category from JSTL:', '${selectedCategory}');
        console.log('Selected sort from JSTL:', '${sort}');
    });

    // Debug function
    function debugSort() {
        console.log('Current URL:', window.location.href);
        const urlParams = new URLSearchParams(window.location.search);
        console.log('Category param:', urlParams.get('category'));
        console.log('Sort param:', urlParams.get('sort'));
        console.log('JSTL Category:', '${selectedCategory}');
        console.log('JSTL Sort:', '${sort}');
    }

    // Call it on page load
    document.addEventListener('DOMContentLoaded', function() {
        debugSort();

        // Also log when sort changes
        document.getElementById('sort').addEventListener('change', function(e) {
            console.log('Sort changed to:', e.target.value);
            debugSort();
        });
    });

</script>

</body>
</html>
