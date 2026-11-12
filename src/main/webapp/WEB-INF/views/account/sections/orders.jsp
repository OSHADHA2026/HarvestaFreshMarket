<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="section-header">
    <h1 class="section-title">My Orders</h1>
    <a href="/products" class="btn-primary"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i> Continue Shopping</a>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-error">${error}</div>
</c:if>

<div class="info-grid">
    <div class="card">
        <h3><i class="fa-solid fa-box" aria-hidden="true"></i> Order History</h3>

        <c:choose>
            <c:when test="${not empty orders}">
                <c:forEach var="order" items="${orders}">
                    <c:set var="statusClass" value="status-${fn:toLowerCase(order.orderStatus)}" />
                    <c:set var="itemCount" value="0" />
                    <c:forEach var="item" items="${order.items}">
                        <c:set var="itemCount" value="${itemCount + item.quantity}" />
                    </c:forEach>

                    <div class="order-card">
                        <div class="order-header">
                            <span class="order-id">Order #${order.orderNumber}</span>
                            <span class="order-status ${statusClass}">${order.orderStatus}</span>
                        </div>
                        <div class="order-details">
                            <div>
                                <strong>Date:</strong><br>
                                <c:out value="${order.createdAt}" />
                            </div>
                            <div>
                                <strong>Total:</strong><br>
                                $<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </div>
                            <div>
                                <strong>Items:</strong><br>
                                ${itemCount} item<c:if test="${itemCount != 1}">s</c:if>
                            </div>
                            <div>
                                <strong>Payment:</strong><br>
                                ${order.paymentStatus}
                            </div>
                        </div>

                        <c:if test="${not empty order.items}">
                            <div class="order-items">
                                <c:forEach var="item" items="${order.items}" varStatus="itemStatus">
                                    <c:if test="${itemStatus.index < 3}">
                                        <div class="order-item">
                                            <div class="product-image">
                                                <c:choose>
                                                    <c:when test="${not empty item.displayImage && fn:length(item.displayImage) <= 10}">
                                                        <c:out value="${item.displayImage}" />
                                                    </c:when>
                                                    <c:otherwise><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <div>${item.displayName}</div>
                                                <small>Qty: ${item.quantity} × $<fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></small>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${fn:length(order.items) > 3}">
                                    <small style="color: #7f8c8d;">+ ${fn:length(order.items) - 3} more item(s)</small>
                                </c:if>
                            </div>
                        </c:if>

                        <div class="action-buttons">
                            <a href="/orders/${order.id}" class="btn-outline"><i class="fa-solid fa-file-lines" aria-hidden="true"></i> View Details</a>
                            <c:if test="${order.paymentStatus == 'PENDING'}">
                                <a href="/payment?orderId=${order.id}" class="btn-primary"><i class="fa-solid fa-credit-card" aria-hidden="true"></i> Pay Now</a>
                            </c:if>
                            <c:if test="${order.orderStatus == 'PENDING' || order.orderStatus == 'PROCESSING'}">
                                <button type="button" class="btn-outline" data-order-id="${order.id}" onclick="cancelOrder(this.dataset.orderId)"><i class="fa-solid fa-circle-xmark" aria-hidden="true"></i> Cancel Order</button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="icon"><i class="fa-solid fa-box" aria-hidden="true"></i></div>
                    <h3>No Orders Yet</h3>
                    <p>You haven't placed any orders yet. Start shopping to see your orders here.</p>
                    <a href="/products" class="btn-primary"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i> Start Shopping</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
