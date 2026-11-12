<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Shopping Cart</title>
    <link rel="stylesheet" href="/css/pages/cart.css">
    <link rel="stylesheet" href="/css/components/checkout-progress.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body data-user-logged-in="${not empty sessionScope.user}">

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="cart-header">
    <h1 class="cart-title"><i class="fa-solid fa-bag-shopping" aria-hidden="true"></i> Your Shopping Cart</h1>
    <p class="cart-subtitle">Review your items and proceed to checkout</p>
    <jsp:include page="/WEB-INF/views/partials/checkout-progress.jsp">
        <jsp:param name="currentStep" value="cart"/>
    </jsp:include>
</div>

    <div class="cart-container">
        <!-- Cart Items -->
        <div class="cart-items">
            <div class="cart-section">
                <h2 class="section-title">Cart Items (<span id="itemCount">${cart.itemCount}</span>)</h2>

                <c:choose>
                    <c:when test="${empty cart.items}">
                        <div class="empty-cart">
                            <div style="font-size: 48px; margin-bottom: 20px;"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></div>
                            <h3>Your cart is empty</h3>
                            <p>Add some products to get started!</p>
                            <a href="/products" class="btn-apply" style="display: inline-block; margin-top: 20px;">Browse Products</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${cart.items}" varStatus="status">
                            <div class="cart-item" data-product-id="${item.product.id}">
                                <div class="item-image item-image-bg-${status.index % 6}">
                                    <c:choose>
                                        <c:when test="${not empty item.product.image && (fn:startsWith(item.product.image, 'http://') || fn:startsWith(item.product.image, 'https://') || fn:startsWith(item.product.image, '/'))}">
                                            <img src="<c:out value='${item.product.image}' />" 
                                                 alt="<c:out value='${item.product.name}' />" 
                                                 onerror="handleImageError(this);">
                                        </c:when>
                                        <c:when test="${not empty item.product.image && fn:length(item.product.image) <= 10}">
                                            <span class="emoji-fallback"><c:out value="${item.product.image}" /></span>
                                        </c:when>
                                        <c:when test="${not empty item.product.image}">
                                            <img src="<c:out value='${item.product.image}' />" 
                                                 alt="<c:out value='${item.product.name}' />" 
                                                 onerror="handleImageError(this);">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="emoji-fallback"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="item-details">
                                    <div class="item-name">${item.product.name}</div>
                                    <div class="item-category">${item.product.category} • ${item.product.weight}${item.product.unit}</div>
                                    <div class="item-price">
                                        <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="$"/>
                                    </div>
                                </div>
                                <div class="item-actions">
                                    <div class="quantity-controls">
                                        <!-- MINUS BUTTON AS FORM -->
                                        <form method="POST" action="/cart/update" style="display: inline;" onsubmit="saveScrollPosition();">
                                            <input type="hidden" name="productId" value="${item.product.id}">
                                            <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                            <button type="submit" class="quantity-btn">-</button>
                                        </form>

                                        <!-- QUANTITY DISPLAY -->
                                        <span style="display: inline-block; width: 50px; text-align: center;">
                                                ${item.quantity}
                                        </span>

                                        <!-- PLUS BUTTON AS FORM -->
                                        <form method="POST" action="/cart/update" style="display: inline;" onsubmit="saveScrollPosition();">
                                            <input type="hidden" name="productId" value="${item.product.id}">
                                            <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                            <button type="submit" class="quantity-btn">+</button>
                                        </form>
                                    </div>

                                    <!-- REMOVE BUTTON AS FORM -->
                                    <form method="POST" action="/cart/remove" style="display: inline;" onsubmit="saveScrollPosition();">
                                        <input type="hidden" name="productId" value="${item.product.id}">
                                        <button type="submit" class="btn-remove">Remove</button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Delivery Information -->
            <div class="cart-section">
                <h2 class="section-title"><i class="fa-solid fa-truck" aria-hidden="true"></i> Delivery Information</h2>
                <div class="delivery-info">
                    <div class="delivery-title">Standard Delivery</div>
                    <div class="delivery-text">Free delivery on orders over $50. Your order will arrive within 2 hours.</div>
                </div>
                <c:if test="${not empty sessionScope.user}">
                    <div class="delivery-info">
                        <div class="delivery-title">Delivery Address</div>
                        <div class="delivery-text">
                                ${sessionScope.user.address} •
                            <a href="/profile?section=addresses" style="color: var(--hv-ac-green, #1f8a5b);">Change</a>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Recommended Products -->
            <div class="cart-section recommendations">
                <h2 class="section-title">You Might Also Like</h2>
                <div class="products-grid" id="recommendedProducts">
                    <c:choose>
                        <c:when test="${not empty recommendedProducts}">
                            <c:forEach var="product" items="${recommendedProducts}">
                                <div class="product-card">
                                    <div class="product-image-link">
                                        <div class="product-image-container">
                                            <c:choose>
                                                <c:when test="${not empty product.image && (fn:startsWith(product.image, 'http://') || fn:startsWith(product.image, 'https://') || fn:startsWith(product.image, '/'))}">
                                                    <img src="<c:out value='${product.image}' />"
                                                         alt="<c:out value='${product.name}' />"
                                                         loading="lazy"
                                                         onerror="handleImageError(this);">
                                                </c:when>
                                                <c:when test="${not empty product.image && fn:length(product.image) <= 10}">
                                                    <span class="emoji-fallback"><c:out value="${product.image}" /></span>
                                                </c:when>
                                                <c:when test="${not empty product.image}">
                                                    <img src="<c:out value='${product.image}' />"
                                                         alt="<c:out value='${product.name}' />"
                                                         loading="lazy"
                                                         onerror="handleImageError(this);">
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="emoji-fallback"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="product-content">
                                        <span class="product-title-link"><c:out value="${product.name}"/></span>
                                        <div class="product-price">$<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state" style="grid-column: 1 / -1; text-align: center; padding: 20px;">
                                No recommendations available right now. Browse <a href="/products">products</a>.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Order Summary -->
        <div class="order-summary">
            <h2 class="section-title">Order Summary</h2>

            <div class="summary-row">
                <span class="summary-label">Subtotal (${cart.itemCount} items)</span>
                <span class="summary-value" id="subtotal">
                <fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="$"/>
            </span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Delivery Fee</span>
                <span class="summary-value" id="deliveryFee">
                <c:choose>
                    <c:when test="${deliveryFee == 0}">FREE</c:when>
                    <c:otherwise>
                        <fmt:formatNumber value="${deliveryFee}" type="currency" currencySymbol="$"/>
                    </c:otherwise>
                </c:choose>
            </span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Tax</span>
                <span class="summary-value" id="tax">
                <fmt:formatNumber value="${tax}" type="currency" currencySymbol="$"/>
            </span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Discount</span>
                <span class="summary-value" style="color: var(--hv-ac-green, #1f8a5b);" id="discount">
                -<fmt:formatNumber value="${discount}" type="currency" currencySymbol="$"/>
            </span>
            </div>

            <div class="summary-row total">
                <span class="summary-label">Total</span>
                <span class="summary-value" id="total">
                <fmt:formatNumber value="${total}" type="currency" currencySymbol="$"/>
            </span>
            </div>

            <div class="discount-code">
                <input type="text" class="discount-input" placeholder="Enter discount code" id="discountCode">
                <button class="btn-apply" onclick="applyDiscount()">Apply</button>
            </div>

            <div class="delivery-info">
                <div class="delivery-title">
                    <c:choose>
                        <c:when test="${discount > 0}"><i class="fa-solid fa-gift" aria-hidden="true"></i> You're saving <fmt:formatNumber value="${discount}" type="currency" currencySymbol="$"/>!</c:when>
                        <c:otherwise><i class="fa-solid fa-gift" aria-hidden="true"></i> Add items to save!</c:otherwise>
                    </c:choose>
                </div>
                <div class="delivery-text" id="deliveryMessage">
                    <c:choose>
                        <c:when test="${subtotal >= 50}"><i class="fa-solid fa-champagne-glasses" aria-hidden="true"></i> You qualify for free delivery!</c:when>
                        <c:otherwise>
                            Add $<fmt:formatNumber value="${50 - subtotal}" type="number" maxFractionDigits="2"/> more for free delivery
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty cart.items}">
                    <button class="btn-checkout" disabled>
                        <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i> Cart is Empty
                    </button>
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${empty sessionScope.user.address or empty fn:trim(sessionScope.user.address)}">
                            <button class="btn-checkout" onclick="showAddressAlert()">
                                <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i> Proceed to Checkout
                            </button>
                        </c:when>
                        <c:otherwise>
                            <form action="/orders/create" method="post" id="checkoutForm">
                                <input type="hidden" name="shippingAddress" value="${sessionScope.user.address}">
                                <input type="hidden" name="paymentMethod" value="card">
                                <input type="hidden" name="billingAddress" value="${sessionScope.user.address}">
                                <input type="hidden" name="notes" value="">
                                <button type="submit" class="btn-checkout" onclick="return confirm('Proceed to checkout? Your cart will be converted to an order.')">
                                    <i class="fa-solid fa-cart-shopping" aria-hidden="true"></i> Proceed to Checkout
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>

            <div class="security-badge">
                <span><i class="fa-solid fa-lock" aria-hidden="true"></i></span>
                <span>Secure checkout • Your information is safe</span>
            </div>
        </div>
    </div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
    // DEBUG VERSION - with lots of logging

    console.log('Cart JavaScript loaded');

    // Update quantity - DEBUG VERSION
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

    function showAddressAlert() {
        alert('Please add a delivery address in your profile before checkout.');
        window.location.href = '/profile?section=addresses';
    }

    function applyDiscount() {
        const code = document.getElementById('discountCode').value.trim();
        if (!code) {
            alert('Please enter a discount code.');
            return;
        }
        alert('Discount codes are applied automatically at checkout when eligible.');
    }

    function updateQuantity(productId, change) {
        console.log('=== UPDATE QUANTITY DEBUG ===');
        console.log('Product ID:', productId);
        console.log('Change:', change);
        const isLoggedIn = document.body.dataset.userLoggedIn === 'true';
        console.log('Is user logged in?', isLoggedIn);

        if (!isLoggedIn) {
            alert('Please login first');
            window.location.href = '/login?redirect=/cart';
            return;
        }

        // TEST 1: Check if we can find the cart item
        const cartItem = document.querySelector(`.cart-item[data-product-id="${productId}"]`);
        console.log('Found cart item?', !!cartItem);
        console.log('Cart item:', cartItem);

        if (!cartItem) {
            alert('Cannot find cart item with ID: ' + productId);
            return;
        }

        // TEST 2: Check if we can find the quantity input
        const quantityInput = cartItem.querySelector('.quantity-input');
        console.log('Found quantity input?', !!quantityInput);
        console.log('Quantity input value:', quantityInput ? quantityInput.value : 'NOT FOUND');

        let currentQuantity = parseInt(quantityInput.value);
        let newQuantity = currentQuantity + change;

        if (newQuantity < 1) newQuantity = 1;

        console.log('Current:', currentQuantity, 'New:', newQuantity);

        // TEST 3: Try the API endpoint
        console.log('Making API call to /api/cart/update');

        const requestBody = {
            productId: productId,
            quantity: newQuantity
        };
        console.log('Request body:', requestBody);

        fetch('/api/cart/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(requestBody)
        })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response headers:', response.headers);
                return response.json();
            })
            .then(data => {
                console.log('Response data:', data);
                if (data.success) {
                    // Save scroll position before reload
                    const scrollPosition = window.pageYOffset || document.documentElement.scrollTop;
                    sessionStorage.setItem('cartScrollPosition', scrollPosition.toString());
                    
                    // Update quantity display immediately
                    if (quantityInput) {
                        quantityInput.value = newQuantity;
                    }
                    
                    // Update cart total if displayed
                    const cartTotalElement = document.querySelector('.cart-total, .total-price, [class*="total"]');
                    if (cartTotalElement && data.cartTotal) {
                        cartTotalElement.textContent = '$' + parseFloat(data.cartTotal).toFixed(2);
                    }
                    
                    // Reload to get updated cart data, but restore scroll position
                    location.reload();
                } else {
                    alert('Error: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Fetch error:', error);
                alert('Network error: ' + error.message);
            });
    }

    // Remove item - DEBUG VERSION
    function removeItemDirect(productId) {
        console.log('=== REMOVE ITEM DEBUG ===');
        console.log('Product ID:', productId);

        if (!confirm('Remove this item?')) return;

        // Try form submission (since this works for you)
        console.log('Creating form submission...');

        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/cart/remove';

        const productIdField = document.createElement('input');
        productIdField.type = 'hidden';
        productIdField.name = 'productId';
        productIdField.value = productId;

        form.appendChild(productIdField);
        document.body.appendChild(form);

        console.log('Submitting form...');
        form.submit();
    }

    // Test function - call this from browser console
    window.testUpdate = function() {
        // Get first product ID from page
        const firstItem = document.querySelector('.cart-item');
        if (firstItem) {
            const productId = firstItem.dataset.productId;
            console.log('Testing with product:', productId);
            updateQuantity(productId, 1);
        } else {
            console.log('No cart items found');
        }
    };

    // Save scroll position before form submission
    function saveScrollPosition() {
        const scrollPosition = window.pageYOffset || document.documentElement.scrollTop;
        sessionStorage.setItem('cartScrollPosition', scrollPosition.toString());
    }

    // Restore scroll position after page load
    function restoreScrollPosition() {
        const savedScroll = sessionStorage.getItem('cartScrollPosition');
        if (savedScroll) {
            const scrollY = parseInt(savedScroll);
            // Restore immediately
            window.scrollTo(0, scrollY);
            // Also restore after a short delay to ensure DOM is fully loaded
            setTimeout(function() {
                window.scrollTo(0, scrollY);
            }, 10);
            setTimeout(function() {
                window.scrollTo(0, scrollY);
            }, 100);
            // Clear the saved position after restoring
            sessionStorage.removeItem('cartScrollPosition');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== PAGE LOADED ===');
        console.log('Number of cart items:', document.querySelectorAll('.cart-item').length);

        // Restore scroll position
        restoreScrollPosition();

        // Prevent form submissions from scrolling to top
        document.querySelectorAll('form[action="/cart/update"], form[action="/cart/remove"]').forEach(function(form) {
            form.addEventListener('submit', function(e) {
                saveScrollPosition();
            });
        });

        // Test: Can we find elements?
        document.querySelectorAll('.cart-item').forEach((item, index) => {
            console.log(`Item ${index}:`, {
                id: item.dataset.productId,
                hasMinusBtn: !!item.querySelector('.quantity-btn:first-child'),
                hasPlusBtn: !!item.querySelector('.quantity-btn:last-child'),
                quantityInput: item.querySelector('.quantity-input')?.value
            });
        });
    });
</script>

</body>
</html>
