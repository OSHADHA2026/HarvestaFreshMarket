<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Secure Payment</title>
    <link rel="stylesheet" href="/css/pages/payment.css">
    <link rel="stylesheet" href="/css/components/checkout-progress.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body data-payment-flash="${not empty param.error ? 'error' : (not empty param.success ? 'success' : '')}">

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<!-- ===== PAGE HEADER ===== -->
<div class="payment-header">
    <h1 class="payment-title"><i class="fa-solid fa-credit-card" aria-hidden="true"></i> Secure Payment</h1>
    <p class="payment-subtitle">Complete your purchase with confidence</p>
    <jsp:include page="/WEB-INF/views/partials/checkout-progress.jsp">
        <jsp:param name="currentStep" value="payment"/>
    </jsp:include>
</div>

<div class="payment-container">

    <!-- ===== LEFT: PAYMENT FORM ===== -->
    <div class="payment-form">
        <form id="paymentForm" action="/payment/process" method="post" novalidate>

            <%-- Pass the order ID through to the controller --%>
            <input type="hidden" name="orderId" value="${order.id}">

            <%-- This hidden field is kept in sync with the JS variable selectedPaymentMethod --%>
            <input type="hidden" id="paymentMethod" name="paymentMethod" value="card">
            <input type="hidden" id="savedPaymentId" name="savedPaymentId" value="">

            <!-- ── STEP 1: Payment Method ── -->
            <div class="payment-section">
                <h2 class="section-title"><i class="fa-solid fa-lock" aria-hidden="true"></i> Payment Method</h2>

                <c:if test="${not empty savedPaymentMethods}">
                    <div class="saved-payments-box" id="savedPaymentsBox">
                        <div class="saved-payments-title"><i class="fa-solid fa-star" aria-hidden="true"></i> Use a saved payment method</div>
                        <c:forEach var="saved" items="${savedPaymentMethods}">
                            <label class="saved-payment-option ${saved.isDefault ? 'selected' : ''}"
                                   id="savedOption-${saved.id}">
                                <input type="radio" name="savedPaymentChoice"
                                       value="${saved.id}"
                                       data-type="${saved.paymentType}"
                                       data-label="${saved.displayLabel}"
                                       data-lastfour="${saved.lastFour}"
                                       data-expiry="${saved.expiryDisplay}"
                                       data-holder="${saved.cardholderName}"
                                       data-email="${saved.paypalEmail}"
                                       data-upi="${saved.upiId}"
                                       onchange="selectSavedPayment(this)"
                                    <c:if test="${saved.isDefault}">checked</c:if>>
                                <div class="saved-payment-details">
                                    <strong>
                                        <c:out value="${saved.displayLabel}"/>
                                        <c:if test="${saved.isDefault}"><span class="default-tag">Default</span></c:if>
                                    </strong>
                                    <small>
                                        <c:choose>
                                            <c:when test="${saved.paymentType == 'card'}">
                                                Expires <c:out value="${saved.expiryDisplay}"/>
                                            </c:when>
                                            <c:otherwise>Saved payment method</c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                            </label>
                        </c:forEach>
                        <label class="saved-payment-option" id="savedOption-new">
                            <input type="radio" name="savedPaymentChoice" value="new"
                                   onchange="useNewPaymentMethod()"
                                <c:if test="${empty defaultSavedPayment}">checked</c:if>>
                            <div class="saved-payment-details">
                                <strong>Enter payment details manually</strong>
                                <small>Use a different card or payment option</small>
                            </div>
                        </label>
                    </div>
                </c:if>
                <c:if test="${empty savedPaymentMethods}">
                    <div class="security-badge" style="margin-bottom:15px;">
                        <span><i class="fa-solid fa-lightbulb" aria-hidden="true"></i></span>
                        <span>No saved payment methods yet.
                            <a href="/profile?section=payments" style="color:var(--hv-ac-green, #1f8a5b);">Add one in your profile</a>
                            for faster checkout.</span>
                    </div>
                </c:if>

                <div class="payment-methods" id="paymentMethodTabs">
                    <div class="payment-method selected" data-method="card"
                         onclick="selectPaymentMethod('card')">
                        <div class="payment-icon"><i class="fa-solid fa-credit-card" aria-hidden="true"></i></div>
                        <div class="payment-name">Credit / Debit Card</div>
                        <div class="card-icons">
                            <span class="card-icon active"><i class="fa-brands fa-cc-visa" aria-hidden="true"></i></span>
                            <span class="card-icon"><i class="fa-brands fa-cc-mastercard" aria-hidden="true"></i></span>
                            <span class="card-icon"><i class="fa-brands fa-cc-amex" aria-hidden="true"></i></span>
                            <span class="card-icon"><i class="fa-brands fa-cc-discover" aria-hidden="true"></i></span>
                        </div>
                    </div>
                    <div class="payment-method" data-method="paypal"
                         onclick="selectPaymentMethod('paypal')">
                        <div class="payment-icon"><i class="fa-brands fa-cc-paypal" aria-hidden="true"></i></div>
                        <div class="payment-name">PayPal</div>
                    </div>
                    <div class="payment-method" data-method="apple"
                         onclick="selectPaymentMethod('apple')">
                        <div class="payment-icon"><i class="fa-brands fa-apple-pay" aria-hidden="true"></i></div>
                        <div class="payment-name">Apple Pay</div>
                    </div>
                </div>

                <!-- Card sub-form -->
                <div id="card-form" class="payment-method-content active">
                    <div id="savedCardPanel" style="display:none;">
                        <p class="masked-card" id="savedCardMask">**** **** **** ****</p>
                        <p style="color:#7f8c8d;font-size:14px;margin-bottom:12px;" id="savedCardMeta"></p>
                        <div class="form-group">
                            <label for="savedCvv">CVV <span class="required">*</span></label>
                            <input type="text" id="savedCvv" class="form-input"
                                   placeholder="123" maxlength="4" autocomplete="cc-csc">
                            <div class="error-message" id="savedCvvError"></div>
                            <small style="color:#7f8c8d;">Enter CVV for your saved card to confirm payment.</small>
                        </div>
                    </div>

                    <div id="manualCardFields">
                    <div class="form-group">
                        <label for="cardNumber">Card Number <span class="required">*</span></label>
                        <input type="text" id="cardNumber" name="cardNumber"
                               class="form-input" placeholder="1234 5678 9012 3456"
                               maxlength="23" autocomplete="cc-number">
                        <div class="error-message" id="cardNumberError"></div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="expiryDate">Expiry Date <span class="required">*</span></label>
                            <input type="text" id="expiryDate" name="expiryDate"
                                   class="form-input" placeholder="MM/YY"
                                   maxlength="5" autocomplete="cc-exp">
                            <div class="error-message" id="expiryDateError"></div>
                        </div>
                        <div class="form-group">
                            <label for="cvv">CVV <span class="required">*</span></label>
                            <input type="text" id="cvv" name="cvv"
                                   class="form-input" placeholder="123"
                                   maxlength="4" autocomplete="cc-csc">
                            <div class="error-message" id="cvvError"></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="cardName">Name on Card <span class="required">*</span></label>
                        <input type="text" id="cardName" name="cardHolderName"
                               class="form-input" placeholder="John Doe"
                               value="${sessionScope.user.firstName} ${sessionScope.user.lastName}"
                               autocomplete="cc-name">
                        <div class="error-message" id="cardNameError"></div>
                    </div>
                    </div>
                </div>

                <!-- PayPal sub-form -->
                <div id="paypal-form" class="payment-method-content">
                    <div id="savedPaypalPanel" style="display:none;" class="security-badge">
                        <span><i class="fa-solid fa-lock" aria-hidden="true"></i></span>
                        <span id="savedPaypalText">Pay with your saved PayPal account.</span>
                    </div>
                    <div id="manualPaypalFields">
                    <div class="security-badge">
                        <span><i class="fa-solid fa-lock" aria-hidden="true"></i></span>
                        <span>You will be redirected to PayPal to complete your payment securely.</span>
                    </div>
                    <div class="form-group" style="margin-top:15px;">
                        <label for="paypalEmail">PayPal Email <span class="required">*</span></label>
                        <input type="email" id="paypalEmail" name="paypalEmail"
                               class="form-input" placeholder="john.doe@example.com"
                               value="${sessionScope.user.email}">
                        <div class="error-message" id="paypalEmailError"></div>
                    </div>
                    </div>
                </div>

                <!-- Apple Pay sub-form -->
                <div id="apple-form" class="payment-method-content">
                    <div class="security-badge">
                        <span><i class="fa-solid fa-lock" aria-hidden="true"></i></span>
                        <span>Apple Pay will authenticate the payment on your device.</span>
                    </div>
                    <div class="form-group" style="margin-top:15px;">
                        <label for="applePayToken">Apple Pay Token <span class="required">*</span></label>
                        <input type="text" id="applePayToken" name="applePayToken"
                               class="form-input" placeholder="Token will be generated automatically…"
                               readonly>
                        <div class="error-message" id="applePayTokenError"></div>
                    </div>
                </div>

                <div class="security-badge">
                    <span><i class="fa-solid fa-lock" aria-hidden="true"></i></span>
                    <span>Your payment information is encrypted and secure (TLS 1.3)</span>
                </div>
            </div>

            <!-- ── STEP 2: Billing Address ── -->
            <%--
                FIX: Every input now has a `name` attribute so the values are
                     actually submitted with the POST request.
            --%>
            <div class="payment-section">
                <h2 class="section-title"><i class="fa-solid fa-house" aria-hidden="true"></i> Billing Address</h2>
                <c:choose>
                    <c:when test="${not empty defaultBillingAddress}">
                        <c:set var="billingFullNameValue" value="${defaultBillingAddress.fullName}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="billingFullNameValue" value="${user.firstName} ${user.lastName}"/>
                    </c:otherwise>
                </c:choose>

                <div class="form-group">
                    <label for="billingFullName">Full Name <span class="required">*</span></label>
                    <input type="text" id="billingFullName" name="billingFullName"
                           class="form-input" placeholder="John Doe"
                           value="${billingFullNameValue}"
                           autocomplete="name">
                    <div class="error-message" id="billingFullNameError"></div>
                </div>

                <div class="form-group">
                    <label for="billingAddress">Address <span class="required">*</span></label>
                    <input type="text" id="billingAddress" name="billingAddress"
                           class="form-input" placeholder="123 Main Street"
                           value="${not empty defaultBillingAddress ? defaultBillingAddress.addressLine1 : sessionScope.user.address}"
                           autocomplete="street-address">
                    <div class="error-message" id="billingAddressError"></div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="billingCity">City <span class="required">*</span></label>
                        <input type="text" id="billingCity" name="billingCity"
                               class="form-input" placeholder="New York"
                               value="${not empty defaultBillingAddress ? defaultBillingAddress.city : sessionScope.user.city}"
                               autocomplete="address-level2">
                        <div class="error-message" id="billingCityError"></div>
                    </div>
                    <div class="form-group">
                        <label for="billingState">State <span class="required">*</span></label>
                        <input type="text" id="billingState" name="billingState"
                               class="form-input" placeholder="NY"
                               value="${not empty defaultBillingAddress ? defaultBillingAddress.state : sessionScope.user.state}"
                               autocomplete="address-level1">
                        <div class="error-message" id="billingStateError"></div>
                    </div>
                    <div class="form-group">
                        <label for="billingZipCode">ZIP Code <span class="required">*</span></label>
                        <input type="text" id="billingZipCode" name="billingZipCode"
                               class="form-input" placeholder="10001"
                               value="${not empty defaultBillingAddress ? defaultBillingAddress.zipCode : sessionScope.user.zipCode}"
                               autocomplete="postal-code">
                        <div class="error-message" id="billingZipCodeError"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="billingCountry">Country</label>
                    <select id="billingCountry" name="billingCountry" class="form-input">
                        <option value="US" selected>United States</option>
                        <option value="CA">Canada</option>
                        <option value="UK">United Kingdom</option>
                        <option value="AU">Australia</option>
                    </select>
                </div>
            </div>

            <!-- ── STEP 3: Contact Information ── -->
            <div class="payment-section">
                <h2 class="section-title"><i class="fa-solid fa-envelope" aria-hidden="true"></i> Contact Information</h2>

                <div class="form-group">
                    <label for="contactEmail">Email Address <span class="required">*</span></label>
                    <input type="email" id="contactEmail" name="contactEmail"
                           class="form-input" placeholder="john.doe@example.com"
                           value="${sessionScope.user.email}"
                           autocomplete="email">
                    <div class="error-message" id="contactEmailError"></div>
                </div>

                <div class="form-group">
                    <label for="contactPhone">Phone Number <span class="required">*</span></label>
                    <input type="tel" id="contactPhone" name="contactPhone"
                           class="form-input" placeholder="(123) 456-7890"
                           value="${sessionScope.user.phone}"
                           autocomplete="tel">
                    <div class="error-message" id="contactPhoneError"></div>
                </div>
            </div>

            <!-- ── Submit row ── -->
            <div style="margin-top:30px;">
                <a href="/checkout" class="btn-back">← Back to Checkout</a>
            </div>
        </form>
    </div>

    <!-- ===== RIGHT: ORDER SUMMARY ===== -->
    <div class="order-summary">
        <h2 class="section-title">Order Summary</h2>

        <div class="order-items">
            <c:forEach var="item" items="${order.items}" varStatus="status">
                <div class="order-item">
                    <div class="item-info">
                        <div class="item-icon item-icon-color-${status.index % 6}">
                            <c:choose>
                                <c:when test="${not empty item.displayImage && (fn:startsWith(item.displayImage, 'http://') || fn:startsWith(item.displayImage, 'https://') || fn:startsWith(item.displayImage, '/'))}">
                                    <img src="<c:out value='${item.displayImage}' />"
                                         alt="<c:out value='${item.displayName}' />"
                                         loading="lazy"
                                         onerror="this.style.display='none'; this.parentElement.querySelector('.fallback-icon').style.display='inline-block';">
                                    <span class="fallback-icon" style="display:none;"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
                                </c:when>
                                <c:when test="${not empty item.displayImage && fn:length(item.displayImage) <= 10}">
                                    <span class="fallback-icon"><c:out value="${item.displayImage}" /></span>
                                </c:when>
                                <c:when test="${not empty item.displayImage}">
                                    <img src="<c:out value='${item.displayImage}' />"
                                         alt="<c:out value='${item.displayName}' />"
                                         loading="lazy"
                                         onerror="this.style.display='none'; this.parentElement.querySelector('.fallback-icon').style.display='inline-block';">
                                    <span class="fallback-icon" style="display:none;"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
                                </c:when>
                                <c:otherwise>
                                    <span class="fallback-icon"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="item-details">
                            <div class="item-name">${item.displayName}</div>
                            <div class="item-quantity">Qty: ${item.quantity}</div>
                        </div>
                    </div>
                    <div class="item-price">
                        $<fmt:formatNumber value="${item.totalPrice}"
                                           type="number"
                                           minFractionDigits="2"
                                           maxFractionDigits="2"/>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="summary-row">
            <span class="summary-label">Subtotal</span>
            <span class="summary-value">
                $<fmt:formatNumber value="${order.subtotal}"
                                   type="number" minFractionDigits="2" maxFractionDigits="2"/>
            </span>
        </div>

        <div class="summary-row">
            <span class="summary-label">Delivery Fee</span>
            <span class="summary-value">
                <c:choose>
                    <c:when test="${order.deliveryFee == 0}">FREE</c:when>
                    <c:otherwise>
                        $<fmt:formatNumber value="${order.deliveryFee}"
                                           type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </c:otherwise>
                </c:choose>
            </span>
        </div>

        <div class="summary-row">
            <span class="summary-label">Tax</span>
            <span class="summary-value">
                $<fmt:formatNumber value="${order.tax}"
                                   type="number" minFractionDigits="2" maxFractionDigits="2"/>
            </span>
        </div>

        <div class="summary-row">
            <span class="summary-label">Discount</span>
            <span class="summary-value discount-value">
                -$<fmt:formatNumber value="${order.discount}"
                                    type="number" minFractionDigits="2" maxFractionDigits="2"/>
            </span>
        </div>

        <div class="summary-row total">
            <span class="summary-label">Total</span>
            <span class="summary-value">
                $<fmt:formatNumber value="${order.totalAmount}"
                                   type="number" minFractionDigits="2" maxFractionDigits="2"/>
            </span>
        </div>

        <div class="delivery-info">
            <div class="delivery-title"><i class="fa-solid fa-truck" aria-hidden="true"></i> Delivery Information</div>
            <div>
                <strong>Address:</strong> <c:out value="${order.shippingAddress}"/><br>
                <strong>Estimated Delivery:</strong>
                <c:out value="${estimatedDeliveryFormatted}"/>
            </div>
        </div>

        <%-- Mirror of the main submit button so it's always visible in the sidebar --%>
        <button type="button" class="btn-pay" onclick="processPayment()">
            <i class="fa-solid fa-credit-card" aria-hidden="true"></i> Complete Payment
        </button>

        <div class="security-badge">
            <span><i class="fa-solid fa-lock" aria-hidden="true"></i></span>
            <span>Secure checkout &bull; Your information is safe</span>
        </div>

        <div class="trust-icons">
            <div class="trust-icon"><div><i class="fa-solid fa-truck" aria-hidden="true"></i></div><div>Fast Delivery</div></div>
            <div class="trust-icon"><div><i class="fa-solid fa-credit-card" aria-hidden="true"></i></div><div>Secure Payment</div></div>
            <div class="trust-icon"><div>↩️</div><div>Easy Returns</div></div>
        </div>
    </div>
</div>

<!-- ===== PROCESSING OVERLAY ===== -->
<div class="processing" id="processingOverlay">
    <div class="spinner"></div>
    <h3>Processing Your Payment</h3>
    <p>Please wait while we securely process your payment…</p>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<!-- ===================================================
     JAVASCRIPT — all fixes are annotated with // FIX
     =================================================== -->
<script src="/js/pages/payment.js"></script>

</body>
</html>
