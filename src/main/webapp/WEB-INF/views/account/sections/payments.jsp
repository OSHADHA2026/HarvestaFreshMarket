<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="section-header">
    <h1 class="section-title">Payment Methods</h1>
    <button type="button" class="btn-primary" onclick="showAddPaymentForm()"><i class="fa-solid fa-credit-card" aria-hidden="true"></i> Add Payment Method</button>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-error">${error}</div>
</c:if>

<div class="info-grid">
    <div class="card">
        <h3><i class="fa-solid fa-credit-card" aria-hidden="true"></i> Saved Payment Methods</h3>

        <c:choose>
            <c:when test="${not empty paymentMethods}">
                <c:forEach var="payment" items="${paymentMethods}">
                    <div class="payment-card ${payment.isDefault ? 'payment-default' : ''}">
                        <div>
                            <strong><c:out value="${payment.displayLabel}"/></strong><br>
                            <small>
                                <c:choose>
                                    <c:when test="${payment.paymentType == 'card'}">
                                        Expires <c:out value="${payment.expiryDisplay}"/>
                                        <c:if test="${not empty payment.cardholderName}">
                                            · <c:out value="${payment.cardholderName}"/>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        Added <c:out value="${payment.createdAt}"/>
                                    </c:otherwise>
                                </c:choose>
                            </small>
                        </div>
                        <div>
                            <c:if test="${payment.isDefault}">
                                <span class="default-badge">Default</span>
                            </c:if>
                            <div class="action-buttons">
                                <c:if test="${!payment.isDefault}">
                                    <form action="/profile/payments/${payment.id}/default" method="post" style="display:inline;">
                                        <button type="submit" class="btn-primary"><i class="fa-solid fa-star" aria-hidden="true"></i> Set Default</button>
                                    </form>
                                </c:if>
                                <a href="/profile?section=payments&amp;editPaymentId=${payment.id}" class="btn-outline"><i class="fa-solid fa-pen" aria-hidden="true"></i> Edit</a>
                                <form action="/profile/payments/${payment.id}/delete" method="post" style="display:inline;"
                                      onsubmit="return confirm('Remove this payment method?');">
                                    <button type="submit" class="btn-danger"><i class="fa-solid fa-trash" aria-hidden="true"></i> Remove</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="icon"><i class="fa-solid fa-credit-card" aria-hidden="true"></i></div>
                    <h3>No Payment Methods</h3>
                    <p>Add a payment method for faster checkout. Only masked card details are stored.</p>
                    <button type="button" class="btn-primary" onclick="showAddPaymentForm()"><i class="fa-solid fa-credit-card" aria-hidden="true"></i> Add Payment Method</button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div id="addPaymentForm" style="display: ${not empty editPayment ? 'block' : 'none'}; margin-top: 30px;">
    <div class="card">
        <h3>${not empty editPayment ? '<i class="fa-solid fa-pen" aria-hidden="true"></i> Edit Payment Method' : '<i class="fa-solid fa-credit-card" aria-hidden="true"></i> Add New Payment Method'}</h3>
        <form action="/profile/payments/save" method="post" id="paymentForm">
            <c:if test="${not empty editPayment}">
                <input type="hidden" name="paymentId" value="${editPayment.id}">
            </c:if>
            <div class="form-group">
                <label class="form-label">Payment Type</label>
                <select class="form-input" name="paymentType" id="paymentType" required onchange="togglePaymentFields()">
                    <option value="card" ${empty editPayment || editPayment.paymentType == 'card' ? 'selected' : ''}>Credit / Debit Card</option>
                    <option value="paypal" ${editPayment.paymentType == 'paypal' ? 'selected' : ''}>PayPal</option>
                    <option value="upi" ${editPayment.paymentType == 'upi' ? 'selected' : ''}>UPI</option>
                </select>
            </div>

            <div id="cardFields">
                <div class="form-group">
                    <label class="form-label">Card Brand</label>
                    <select class="form-input" name="cardBrand">
                        <option value="visa" ${editPayment.cardBrand == 'visa' ? 'selected' : ''}>Visa</option>
                        <option value="mastercard" ${editPayment.cardBrand == 'mastercard' ? 'selected' : ''}>MasterCard</option>
                        <option value="rupay" ${editPayment.cardBrand == 'rupay' ? 'selected' : ''}>RuPay</option>
                        <option value="amex" ${editPayment.cardBrand == 'amex' ? 'selected' : ''}>American Express</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Card Number</label>
                    <input type="text" name="cardNumber" class="form-input" maxlength="19"
                           placeholder="1234 5678 9012 3456">
                    <small style="color:#7f8c8d;">Only the last 4 digits are stored.</small>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label class="form-label">Expiry Date</label>
                        <input type="text" name="expiryDate" class="form-input" placeholder="MM/YY"
                               value="${editPayment.expiryDisplay}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">CVV</label>
                        <input type="text" name="cvv" class="form-input" placeholder="Not stored" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Cardholder Name</label>
                    <input type="text" name="cardholderName" class="form-input"
                           value="${editPayment.cardholderName}">
                </div>
            </div>

            <div id="paypalFields" style="display:none;">
                <div class="form-group">
                    <label class="form-label">PayPal Email</label>
                    <input type="email" name="paypalEmail" class="form-input"
                           value="${editPayment.paypalEmail}" placeholder="john.doe@example.com">
                </div>
            </div>

            <div id="upiFields" style="display:none;">
                <div class="form-group">
                    <label class="form-label">UPI ID</label>
                    <input type="text" name="upiId" class="form-input"
                           value="${editPayment.upiId}" placeholder="user@bank">
                </div>
            </div>

            <div class="form-group">
                <label>
                    <input type="checkbox" name="defaultPayment" value="on"
                        <c:if test="${not empty editPayment && editPayment.isDefault}">checked</c:if>
                        <c:if test="${empty editPayment && empty paymentMethods}">checked</c:if>>
                    Set as default payment method
                </label>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn-primary"><i class="fa-solid fa-floppy-disk" aria-hidden="true"></i> Save Payment Method</button>
                <button type="button" class="btn-secondary" onclick="hideAddPaymentForm()"><i class="fa-solid fa-circle-xmark" aria-hidden="true"></i> Cancel</button>
            </div>
        </form>
    </div>
</div>

<script src="/js/pages/profile-payments.js"></script>
