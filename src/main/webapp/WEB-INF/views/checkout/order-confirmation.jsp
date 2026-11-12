<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Order Confirmation</title>
    <link rel="stylesheet" href="/css/pages/order-confirmation.css">
    <link rel="stylesheet" href="/css/components/checkout-progress.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="confirmation-container">
    <jsp:include page="/WEB-INF/views/partials/checkout-progress.jsp">
        <jsp:param name="currentStep" value="done"/>
    </jsp:include>
    <div class="confirmation-icon"><i class="fa-solid fa-circle-check" aria-hidden="true"></i></div>
    <h1 class="confirmation-title">Order Confirmed!</h1>
    <p class="confirmation-subtitle">Thank you for your purchase. Your order has been received and is being processed.</p>

    <c:if test="${not empty order}">
        <div class="order-details">
            <div class="detail-row">
                <span class="detail-label">Order Number:</span>
                <span class="detail-value">${order.orderNumber}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Order Date:</span>
                <span class="detail-value">
                    <fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy hh:mm a"/>
                </span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Total Amount:</span>
                <span class="detail-value" style="font-weight: bold; color: var(--hv-ac-green, #1f8a5b);">
                    $<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Payment Status:</span>
                <span class="detail-value" style="color: var(--hv-ac-green, #1f8a5b); font-weight: bold;">
                        ${order.paymentStatus}
                </span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Estimated Delivery:</span>
                <span class="detail-value">
                    <fmt:formatDate value="${order.estimatedDelivery}" pattern="MMM dd, yyyy hh:mm a"/>
                </span>
            </div>
        </div>
    </c:if>

    <p style="margin: 20px 0; color: #7f8c8d;">
        You will receive an email confirmation shortly with your order details.
    </p>

    <div style="margin-top: 30px;">
        <a href="/orders" class="btn-primary">View All Orders</a>
        <a href="/products" class="btn-secondary">Continue Shopping</a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
</body>
</html>
