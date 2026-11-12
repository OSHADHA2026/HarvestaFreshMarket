<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Order Details</title>
    <link rel="stylesheet" href="/css/pages/order-detail.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="container">
    <c:if test="${not empty success}">
        <div class="alert alert-success">
            ${success}
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-error">
            ${error}
        </div>
    </c:if>

    <c:if test="${not empty order}">
        <!-- Order Header -->
        <div class="order-header">
            <div class="order-title">
                <h1>Order #${order.orderNumber}</h1>
                <span class="order-status status-${fn:toLowerCase(order.orderStatus)}">
                    ${order.orderStatus}
                </span>
            </div>

            <div class="order-info">
                <div class="info-item">
                    <div class="info-label">Order Date</div>
                    <div class="info-value">
                        <c:out value="${orderCreatedAtFormatted}"/>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Payment Status</div>
                    <div class="info-value ${order.paymentStatus == 'COMPLETED' ? 'payment-status-completed' : 'payment-status-pending'}">
                        ${order.paymentStatus}
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Estimated Delivery</div>
                    <div class="info-value">
                        <c:out value="${estimatedDeliveryFormatted}"/>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Shipping Address</div>
                    <div class="info-value">${order.shippingAddress}</div>
                </div>
            </div>
        </div>

        <!-- Order Items -->
        <div class="order-items-section">
            <h2 class="section-title">Order Items</h2>
            <c:forEach var="item" items="${order.items}" varStatus="status">
                <div class="order-item">
                    <div class="item-info">
                        <div class="item-icon item-icon-color-${status.index % 6}">
                            <c:choose>
                                <c:when test="${not empty item.displayImage && (fn:startsWith(item.displayImage, 'http://') || fn:startsWith(item.displayImage, 'https://') || fn:startsWith(item.displayImage, '/'))}">
                                    <img src="<c:out value='${item.displayImage}' />"
                                         alt="<c:out value='${item.displayName}' />"
                                         loading="lazy"
                                         onerror="this.style.display='none'; this.nextElementSibling.hidden=false;">
                                    <span class="item-image-fallback" hidden aria-hidden="true"><i class="fa-solid fa-cart-shopping"></i></span>
                                </c:when>
                                <c:when test="${not empty item.displayImage && fn:length(item.displayImage) <= 10}">
                                    <span class="item-image-fallback"><c:out value="${item.displayImage}"/></span>
                                </c:when>
                                <c:otherwise>
                                    <span class="item-image-fallback" aria-hidden="true"><i class="fa-solid fa-cart-shopping"></i></span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="item-details">
                            <div class="item-name">${item.displayName}</div>
                            <div class="item-meta">Quantity: ${item.quantity} × $<fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></div>
                        </div>
                    </div>
                    <div class="item-price">
                        $<fmt:formatNumber value="${item.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Order Summary -->
        <div class="order-summary">
            <h2 class="section-title">Order Summary</h2>

            <div class="summary-row">
                <span class="summary-label">Subtotal</span>
                <span class="summary-value">
                    $<fmt:formatNumber value="${order.subtotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Delivery Fee</span>
                <span class="summary-value">
                    <c:choose>
                        <c:when test="${order.deliveryFee == 0}">FREE</c:when>
                        <c:otherwise>
                            $<fmt:formatNumber value="${order.deliveryFee}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Tax</span>
                <span class="summary-value">
                    $<fmt:formatNumber value="${order.tax}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </span>
            </div>

            <div class="summary-row">
                <span class="summary-label">Discount</span>
                <span class="summary-value" style="color: var(--hv-ac-green, #1f8a5b);">
                    -$<fmt:formatNumber value="${order.discount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </span>
            </div>

            <div class="summary-row total">
                <span class="summary-label">Total</span>
                <span class="summary-value">
                    $<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </span>
            </div>

            <div class="action-buttons">
                <a href="/orders" class="btn btn-secondary">← Back to Orders</a>
                <a href="/products" class="btn btn-primary">Continue Shopping</a>
                <c:if test="${order.orderStatus != 'CANCELLED' && order.orderStatus != 'DELIVERED'}">
                    <form action="/orders/${order.id}/cancel" method="post" style="display: inline;">
                        <button type="submit" class="btn btn-outline" onclick="return confirm('Are you sure you want to cancel this order?')">
                            Cancel Order
                        </button>
                    </form>
                </c:if>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
</body>
</html>
