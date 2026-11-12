<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Checkout</title>
    <link rel="stylesheet" href="/css/pages/checkout.css">
    <link rel="stylesheet" href="/css/components/checkout-progress.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="checkout-header">
    <h1 class="checkout-title"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i> Checkout</h1>
    <p class="checkout-subtitle">Complete your order with secure checkout</p>
    <jsp:include page="/WEB-INF/views/partials/checkout-progress.jsp">
        <jsp:param name="currentStep" value="payment"/>
    </jsp:include>
</div>

<div class="checkout-container">
    <!-- Checkout Form -->
    <div class="checkout-form">
        <form id="checkoutForm" action="/orders/create" method="post">
            <!-- Step 1: Shipping Address -->
            <div class="checkout-section">
                <h2 class="section-title">
                    <span class="section-step">1</span>
                    Shipping Address
                </h2>

                <div class="shipping-address-list" id="addressList">
                    <c:forEach var="savedAddress" items="${addresses}">
                        <div class="address-option${savedAddress.isDefault ? ' selected' : ''}"
                             data-address-id="${savedAddress.id}"
                             data-name="<c:out value='${savedAddress.fullName}'/>"
                             data-address-line1="<c:out value='${savedAddress.addressLine1}'/>"
                             data-address-line2="<c:out value='${savedAddress.addressLine2}'/>"
                             data-city="<c:out value='${savedAddress.city}'/>"
                             data-state="<c:out value='${savedAddress.state}'/>"
                             data-zip-code="<c:out value='${savedAddress.zipCode}'/>"
                             data-phone="<c:out value='${savedAddress.phone}'/>">
                            <div class="address-title">
                                <c:out value="${savedAddress.label}"/>
                                <c:if test="${savedAddress.isDefault}">
                                    <span class="default-badge">Default</span>
                                </c:if>
                            </div>
                            <div class="address-details">
                                <c:out value="${savedAddress.fullName}"/><br>
                                <c:out value="${savedAddress.addressLine1}"/>
                                <c:if test="${not empty savedAddress.addressLine2}">, <c:out value="${savedAddress.addressLine2}"/></c:if><br>
                                <c:out value="${savedAddress.city}"/>, <c:out value="${savedAddress.state}"/> <c:out value="${savedAddress.zipCode}"/>
                                <c:if test="${not empty savedAddress.phone}"><br><i class="fa-solid fa-phone" aria-hidden="true"></i> <c:out value="${savedAddress.phone}"/></c:if>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty addresses}">
                        <p>No saved address found. Add a shipping address to continue.</p>
                    </c:if>
                </div>

                <button type="button" class="btn-new-address" onclick="showNewAddressForm()">
                    + Add New Address
                </button>

                <!-- New Address Form (Hidden by default) -->
                <div id="newAddressForm" style="display: none; margin-top: 20px;">
                    <div class="form-group">
                        <label for="addressLabel">Address Label <span class="required">*</span></label>
                        <input type="text"
                               id="addressLabel"
                               name="addressLabel"
                               class="form-input"
                               placeholder="Home, Office, etc.">
                    </div>

                    <div class="form-group">
                        <label for="fullName">Full Name <span class="required">*</span></label>
                        <input type="text"
                               id="fullName"
                               name="fullName"
                               class="form-input"
                               placeholder="John Doe"
                               value="${sessionScope.user.firstName} ${sessionScope.user.lastName}">
                    </div>

                    <div class="form-group">
                        <label for="addressLine1">Address Line 1 <span class="required">*</span></label>
                        <input type="text"
                               id="addressLine1"
                               name="addressLine1"
                               class="form-input"
                               placeholder="123 Main Street"
                               value="${sessionScope.user.address}">
                    </div>

                    <div class="form-group">
                        <label for="addressLine2">Address Line 2 (Optional)</label>
                        <input type="text"
                               id="addressLine2"
                               name="addressLine2"
                               class="form-input"
                               placeholder="Apt, Suite, Building">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="city">City <span class="required">*</span></label>
                            <input type="text"
                                   id="city"
                                   name="city"
                                   class="form-input"
                                   placeholder="New York"
                                   value="${sessionScope.user.city}">
                        </div>
                        <div class="form-group">
                            <label for="state">State <span class="required">*</span></label>
                            <input type="text"
                                   id="state"
                                   name="state"
                                   class="form-input"
                                   placeholder="NY"
                                   value="${sessionScope.user.state}">
                        </div>
                        <div class="form-group">
                            <label for="zipCode">ZIP Code <span class="required">*</span></label>
                            <input type="text"
                                   id="zipCode"
                                   name="zipCode"
                                   class="form-input"
                                   placeholder="10001"
                                   value="${sessionScope.user.zipCode}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="country">Country <span class="required">*</span></label>
                        <select id="country" name="country" class="form-select">
                            <option value="US" selected>United States</option>
                            <option value="CA">Canada</option>
                            <option value="UK">United Kingdom</option>
                            <option value="AU">Australia</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number <span class="required">*</span></label>
                        <input type="tel"
                               id="phone"
                               name="phone"
                               class="form-input"
                               placeholder="(123) 456-7890"
                               value="${sessionScope.user.phone}">
                    </div>

                    <div class="checkbox-group">
                        <input type="checkbox" id="setDefault" name="setDefault">
                        <label for="setDefault">Set as default shipping address</label>
                    </div>
                </div>

                <!-- Hidden field for selected address -->
                <input type="hidden" id="shippingAddress" name="shippingAddress">
            </div>

            <!-- Step 2: Delivery Method -->
            <div class="checkout-section">
                <h2 class="section-title">
                    <span class="section-step">2</span>
                    Delivery Method
                </h2>

                <div class="delivery-options">
                    <div class="delivery-option selected" data-method="standard" onclick="selectDeliveryMethod('standard')">
                        <div class="delivery-icon"><i class="fa-solid fa-truck" aria-hidden="true"></i></div>
                        <div class="delivery-name">Standard Delivery</div>
                        <div class="delivery-price" id="standardPrice">$4.99</div>
                        <div class="delivery-time">2-3 business days</div>
                    </div>
                    <div class="delivery-option" data-method="express" onclick="selectDeliveryMethod('express')">
                        <div class="delivery-icon"><i class="fa-solid fa-bolt" aria-hidden="true"></i></div>
                        <div class="delivery-name">Express Delivery</div>
                        <div class="delivery-price" id="expressPrice">$9.99</div>
                        <div class="delivery-time">Next day delivery</div>
                    </div>
                    <div class="delivery-option" data-method="same-day" onclick="selectDeliveryMethod('same-day')">
                        <div class="delivery-icon"><i class="fa-solid fa-person-running" aria-hidden="true"></i></div>
                        <div class="delivery-name">Same Day</div>
                        <div class="delivery-price" id="sameDayPrice">$14.99</div>
                        <div class="delivery-time">Within 4 hours</div>
                    </div>
                </div>

                <input type="hidden" id="deliveryMethod" name="deliveryMethod" value="standard">
                <input type="hidden" id="deliveryFee" name="deliveryFee" value="4.99">
            </div>

            <!-- Step 3: Contact Information -->
            <div class="checkout-section">
                <h2 class="section-title">
                    <span class="section-step">3</span>
                    Contact Information
                </h2>

                <div class="form-group">
                    <label for="email">Email Address <span class="required">*</span></label>
                    <input type="email"
                           id="email"
                           name="email"
                           class="form-input"
                           placeholder="john.doe@example.com"
                           value="${sessionScope.user.email}"
                           required>
                </div>

                <div class="form-group">
                    <label for="contactPhone">Contact Phone <span class="required">*</span></label>
                    <input type="tel"
                           id="contactPhone"
                           name="contactPhone"
                           class="form-input"
                           placeholder="(123) 456-7890"
                           value="${sessionScope.user.phone}"
                           required>
                </div>

                <div class="checkbox-group">
                    <input type="checkbox" id="subscribeNewsletter" name="subscribeNewsletter" checked>
                    <label for="subscribeNewsletter">Subscribe to newsletter for updates and offers</label>
                </div>
            </div>

            <!-- Step 4: Payment Method -->
            <div class="checkout-section">
                <h2 class="section-title">
                    <span class="section-step">4</span>
                    Payment Method
                </h2>

                <div class="form-group">
                    <label for="paymentMethodSelect">Select Payment Method <span class="required">*</span></label>
                    <select id="paymentMethodSelect" name="paymentMethod" class="form-select" required>
                        <option value="card" selected>Credit/Debit Card</option>
                        <option value="paypal">PayPal</option>
                        <option value="apple">Apple Pay</option>
                        <option value="cod">Cash on Delivery</option>
                    </select>
                </div>

                <div class="security-badge">
                    <span><i class="fa-solid fa-lock" aria-hidden="true"></i></span>
                    <span>Your payment information is secure and encrypted</span>
                </div>
            </div>

            <!-- Step 5: Order Notes -->
            <div class="checkout-section">
                <h2 class="section-title">
                    <span class="section-step">5</span>
                    Order Notes (Optional)
                </h2>

                <div class="form-group">
                    <label for="orderNotes">Special Instructions</label>
                    <textarea id="orderNotes"
                              name="notes"
                              class="form-input"
                              rows="4"
                              placeholder="Add delivery instructions, gift message, or any special requests..."></textarea>
                </div>
            </div>

            <div class="form-actions">
                <a href="/cart" class="btn-back">← Back to Cart</a>
                <button type="button" class="btn-proceed" onclick="validateAndSubmit()">
                    Continue to Payment →
                </button>
            </div>
        </form>
    </div>

    <!-- Order Summary -->
    <div class="order-summary">
        <h2 class="section-title">Order Summary</h2>

        <div class="order-items" id="orderItems">
            <!-- Cart items will be loaded here -->
        </div>

        <div class="summary-row">
            <span class="summary-label">Subtotal</span>
            <span class="summary-value" id="subtotal">$0.00</span>
        </div>

        <div class="summary-row">
            <span class="summary-label">Delivery</span>
            <span class="summary-value" id="deliverySummary">$4.99</span>
        </div>

        <div class="summary-row">
            <span class="summary-label">Tax</span>
            <span class="summary-value" id="tax">$0.00</span>
        </div>

        <div class="summary-row">
            <span class="summary-label">Discount</span>
            <span class="summary-value discount-value" id="discount">-$0.00</span>
        </div>

        <div class="summary-row total">
            <span class="summary-label">Total</span>
            <span class="summary-value" id="total">$0.00</span>
        </div>

        <!-- Promo Code -->
        <div class="promo-code">
            <input type="text"
                   class="promo-input"
                   placeholder="Promo code"
                   id="promoCode">
            <button type="button" class="btn-apply" onclick="applyPromoCode()">Apply</button>
        </div>

        <div class="delivery-info">
            <div class="delivery-title"><i class="fa-solid fa-gift" aria-hidden="true"></i> You're saving $0.00!</div>
            <div class="delivery-text">Free delivery on orders over $50</div>
        </div>

        <div class="security-badge">
            <span><i class="fa-solid fa-lock" aria-hidden="true"></i></span>
            <span>Secure checkout • Your information is safe</span>
        </div>

        <div class="trust-icons">
            <div class="trust-icon">
                <div><i class="fa-solid fa-truck" aria-hidden="true"></i></div>
                <div>Fast Delivery</div>
            </div>
            <div class="trust-icon">
                <div><i class="fa-solid fa-credit-card" aria-hidden="true"></i></div>
                <div>Secure Payment</div>
            </div>
            <div class="trust-icon">
                <div>↩️</div>
                <div>Easy Returns</div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
    // Global variables
    let selectedDeliveryMethod = 'standard';
    let deliveryFees = {
        'standard': 4.99,
        'express': 9.99,
        'same-day': 14.99
    };
    let cartData = null;
    let promoDiscount = 0;

    // Load cart data on page load
    document.addEventListener('DOMContentLoaded', function() {
        loadCartData();
        loadUserAddresses();
        updateCartCount();

    });

    // Load cart data from server
    function loadCartData() {
        fetch('/api/cart/data')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    cartData = data.cart;
                    updateOrderSummary();
                    updateOrderItems();
                } else {
                    showNotification('Unable to load cart data', 'error');
                    window.location.href = '/cart';
                }
            })
            .catch(error => {
                console.error('Error loading cart data:', error);
                showNotification('Error loading cart data', 'error');
            });
    }

    // Load user addresses
    function loadUserAddresses() {
        const options = document.querySelectorAll('.address-option[data-address-id]');
        options.forEach(function (option) {
            option.addEventListener('click', function () {
                selectAddress(option.dataset.addressId);
            });
        });

        const defaultAddress = Array.prototype.find.call(options, function (option) {
            return option.querySelector('.default-badge');
        }) || options[0];
        if (defaultAddress) {
            selectAddress(defaultAddress.dataset.addressId);
        }
    }

    // Select address
    function selectAddress(addressId) {
        // Remove selected class from all addresses
        document.querySelectorAll('.address-option').forEach(option => {
            option.classList.remove('selected');
        });

        // Add selected class to clicked address
        const selectedOption = document.querySelector(`[data-address-id="${addressId}"]`);
        if (selectedOption) {
            selectedOption.classList.add('selected');

            // Update shipping address field
            document.getElementById('shippingAddress').value = formatShippingAddress({
                name: selectedOption.dataset.name,
                address: [
                    selectedOption.dataset.addressLine1,
                    selectedOption.dataset.addressLine2
                ].filter(Boolean).join(', '),
                city: selectedOption.dataset.city,
                state: selectedOption.dataset.state,
                zipCode: selectedOption.dataset.zipCode
            });
        }
    }

    function formatShippingAddress(address) {
        const cityRegion = [address.city, address.state, address.zipCode].filter(Boolean).join(', ');
        return [address.name, address.address, cityRegion].filter(Boolean).join(', ');
    }

    function updateShippingAddressFromForm() {
        const address = {
            name: document.getElementById('fullName').value.trim(),
            address: [
                document.getElementById('addressLine1').value.trim(),
                document.getElementById('addressLine2').value.trim()
            ].filter(Boolean).join(', '),
            city: document.getElementById('city').value.trim(),
            state: document.getElementById('state').value.trim(),
            zipCode: document.getElementById('zipCode').value.trim()
        };

        if (!address.name || !address.address || !address.city || !address.state || !address.zipCode) {
            showNotification('Please complete all required shipping address fields', 'error');
            return false;
        }

        document.getElementById('shippingAddress').value = formatShippingAddress(address);
        return true;
    }

    // Show new address form
    function showNewAddressForm() {
        document.getElementById('newAddressForm').style.display = 'block';
        document.getElementById('addressList').style.display = 'none';
        document.querySelector('.btn-new-address').style.display = 'none';
    }

    // Select delivery method
    function selectDeliveryMethod(method) {
        selectedDeliveryMethod = method;

        // Update UI
        document.querySelectorAll('.delivery-option').forEach(option => {
            option.classList.remove('selected');
        });
        document.querySelector(`[data-method="${method}"]`).classList.add('selected');

        // Update form fields
        document.getElementById('deliveryMethod').value = method;
        document.getElementById('deliveryFee').value = deliveryFees[method];

        // Update summary
        updateOrderSummary();
    }

    // Update order items display
    function updateOrderItems() {
        if (!cartData || !cartData.items) return;

        const orderItemsContainer = document.getElementById('orderItems');
        orderItemsContainer.innerHTML = '';

        cartData.items.forEach((item, index) => {
            const itemElement = document.createElement('div');
            itemElement.className = 'order-item';

            const colors = ['#e74c3c', '#3498db', '#ff8a3d', '#2fa36f', '#9b59b6'];
            const color = colors[index % colors.length];
            const imageUrl = item.product.image;

            let productImageHtml = '<span class="fallback-icon"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>';
            if (imageUrl && (imageUrl.startsWith('http://') || imageUrl.startsWith('https://') || imageUrl.startsWith('/'))) {
                productImageHtml = `
                    <img src="${imageUrl}"
                         alt="${item.product.name || 'Product'}"
                         loading="lazy"
                         onerror="this.style.display='none'; this.parentElement.querySelector('.fallback-icon').style.display='inline-block';">
                    <span class="fallback-icon" style="display:none;"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
                `;
            } else if (imageUrl && imageUrl.length <= 10) {
                productImageHtml = `<span>${imageUrl}</span>`;
            } else if (imageUrl) {
                productImageHtml = `
                    <img src="${imageUrl}"
                         alt="${item.product.name || 'Product'}"
                         loading="lazy"
                         onerror="this.style.display='none'; this.parentElement.querySelector('.fallback-icon').style.display='inline-block';">
                    <span class="fallback-icon" style="display:none;"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
                `;
            }

            itemElement.innerHTML = `
                <div class="item-info">
                    <div class="item-icon" style="background: ${color};">${productImageHtml}</div>
                    <div class="item-details">
                        <div class="item-name">${item.product.name || 'Product'}</div>
                        <div class="item-quantity">Qty: ${item.quantity}</div>
                    </div>
                </div>
                <div class="item-price">$${(item.totalPrice || 0).toFixed(2)}</div>
            `;

            orderItemsContainer.appendChild(itemElement);
        });
    }

    // Update order summary
    function updateOrderSummary() {
        if (!cartData) return;

        const subtotal = cartData.totalPrice || 0;
        const deliveryFee = deliveryFees[selectedDeliveryMethod] || 0;
        const tax = subtotal * 0.09; // 9% tax
        const discount = promoDiscount;
        const total = subtotal + deliveryFee + tax - discount;

        // Update UI
        document.getElementById('subtotal').textContent = `$${subtotal.toFixed(2)}`;
        document.getElementById('deliverySummary').textContent = `$${deliveryFee.toFixed(2)}`;
        document.getElementById('tax').textContent = `$${tax.toFixed(2)}`;
        document.getElementById('discount').textContent = `-$${discount.toFixed(2)}`;
        document.getElementById('total').textContent = `$${total.toFixed(2)}`;

        // Update delivery info
        const deliveryInfo = document.querySelector('.delivery-info .delivery-text');
        if (subtotal >= 50) {
            document.getElementById('deliverySummary').textContent = 'FREE';
            document.querySelector('.delivery-info .delivery-title').innerHTML = '<i class="fa-solid fa-champagne-glasses" aria-hidden="true"></i> You qualify for free delivery!';
            deliveryInfo.textContent = 'Standard delivery is free for this order';
        } else {
            const needed = (50 - subtotal).toFixed(2);
            document.querySelector('.delivery-info .delivery-title').innerHTML = '<i class="fa-solid fa-gift" aria-hidden="true"></i> Add items to save!';
            deliveryInfo.textContent = `Add $${needed} more for free delivery`;
        }

        // Update delivery prices based on subtotal
        updateDeliveryPrices(subtotal);
    }

    // Update delivery prices
    function updateDeliveryPrices(subtotal) {
        if (subtotal >= 50) {
            document.getElementById('standardPrice').textContent = 'FREE';
            document.getElementById('expressPrice').textContent = '$5.99';
            document.getElementById('sameDayPrice').textContent = '$10.99';

            deliveryFees.standard = 0;
            deliveryFees.express = 5.99;
            deliveryFees['same-day'] = 10.99;
        } else {
            document.getElementById('standardPrice').textContent = '$4.99';
            document.getElementById('expressPrice').textContent = '$9.99';
            document.getElementById('sameDayPrice').textContent = '$14.99';

            deliveryFees.standard = 4.99;
            deliveryFees.express = 9.99;
            deliveryFees['same-day'] = 14.99;
        }
    }

    // Apply promo code
    function applyPromoCode() {
        const promoCode = document.getElementById('promoCode').value.trim().toUpperCase();

        if (!promoCode) {
            showNotification('Please enter a promo code', 'error');
            return;
        }

        // Simulate promo code validation
        if (promoCode === 'SUPER10') {
            promoDiscount = (cartData.totalPrice || 0) * 0.10; // 10% discount
            showNotification('Promo code applied! 10% discount', 'success');
            updateOrderSummary();
        } else if (promoCode === 'FREESHIP') {
            // Free shipping logic would be handled differently
            showNotification('Promo code applied!', 'success');
        } else {
            showNotification('Invalid promo code', 'error');
        }
    }

    // Validate and submit form
    function validateAndSubmit() {
        const addressFormVisible = document.getElementById('newAddressForm').style.display !== 'none';
        if (addressFormVisible && !updateShippingAddressFromForm()) {
            return;
        }

        // Validate shipping address
        const shippingAddress = document.getElementById('shippingAddress').value;
        if (!shippingAddress || shippingAddress.trim() === '') {
            showNotification('Please select or add a shipping address', 'error');
            return;
        }

        // Validate email
        const email = document.getElementById('email').value;
        if (!email || !/^\S+@\S+\.\S+$/.test(email)) {
            showNotification('Please enter a valid email address', 'error');
            return;
        }

        // Validate phone
        const phone = document.getElementById('contactPhone').value;
        if (!phone || phone.trim() === '') {
            showNotification('Please enter a contact phone number', 'error');
            return;
        }

        // Check if cart is empty
        if (!cartData || cartData.items.length === 0) {
            showNotification('Your cart is empty', 'error');
            window.location.href = '/cart';
            return;
        }

        // Show loading state
        const submitButton = document.querySelector('.btn-proceed');
        const originalText = submitButton.innerHTML;
        submitButton.innerHTML = 'Processing...';
        submitButton.disabled = true;

        // Submit form
        setTimeout(() => {
            document.getElementById('checkoutForm').submit();
        }, 1000);
    }

    // Update cart count
    function updateCartCount() {
        fetch('/api/cart/count')
            .then(response => response.json())
            .then(data => {
                document.getElementById('cartCount').textContent = data.count || 0;
            });
    }

    // Show notification
    function showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${type == 'error' ? '#e74c3c' : type == 'success' ? '#2fa36f' : '#3498db'};
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            z-index: 1000;
            transform: translateX(100%);
            transition: transform 0.3s ease;
        `;
        notification.textContent = message;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
        }, 100);

        setTimeout(() => {
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 300);
        }, 3000);
    }
</script>

</body>
</html>
