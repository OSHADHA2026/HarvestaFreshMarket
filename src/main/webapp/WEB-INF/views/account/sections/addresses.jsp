<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="section-header">
    <h1 class="section-title">Address Book</h1>
    <button type="button" class="btn-primary" onclick="showAddAddressForm()"><i class="fa-solid fa-house" aria-hidden="true"></i> Add New Address</button>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-error">${error}</div>
</c:if>

<div class="address-grid">
    <c:choose>
        <c:when test="${not empty addresses}">
            <c:forEach var="addr" items="${addresses}">
                <div class="address-card ${addr.isDefault ? 'address-default' : ''}">
                    <c:if test="${addr.isDefault}">
                        <span class="default-badge">Default</span>
                    </c:if>
                    <h3>
                        <c:choose>
                            <c:when test="${addr.label == 'home'}"><i class="fa-solid fa-house" aria-hidden="true"></i> Home</c:when>
                            <c:when test="${addr.label == 'work'}"><i class="fa-solid fa-building" aria-hidden="true"></i> Work</c:when>
                            <c:otherwise><i class="fa-solid fa-location-dot" aria-hidden="true"></i> ${addr.label}</c:otherwise>
                        </c:choose>
                    </h3>
                    <p>
                        <strong><c:out value="${addr.fullName}"/></strong><br>
                        <c:out value="${addr.addressLine1}"/><br>
                        <c:if test="${not empty addr.addressLine2}">
                            <c:out value="${addr.addressLine2}"/><br>
                        </c:if>
                        <c:out value="${addr.city}"/>, <c:out value="${addr.state}"/> <c:out value="${addr.zipCode}"/><br>
                        <c:if test="${not empty addr.landmark}">
                            Landmark: <c:out value="${addr.landmark}"/><br>
                        </c:if>
                        Phone: <c:out value="${not empty addr.phone ? addr.phone : 'Not provided'}"/>
                    </p>
                    <div class="action-buttons">
                        <c:if test="${!addr.isDefault}">
                            <form action="/profile/addresses/${addr.id}/default" method="post" style="display:inline;">
                                <button type="submit" class="btn-primary"><i class="fa-solid fa-star" aria-hidden="true"></i> Set Default</button>
                            </form>
                        </c:if>
                        <a href="/profile?section=addresses&amp;editAddressId=${addr.id}" class="btn-outline"><i class="fa-solid fa-pen" aria-hidden="true"></i> Edit</a>
                        <form action="/profile/addresses/${addr.id}/delete" method="post" style="display:inline;"
                              onsubmit="return confirm('Remove this address?');">
                            <button type="submit" class="btn-danger"><i class="fa-solid fa-trash" aria-hidden="true"></i> Remove</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="empty-state" style="grid-column: 1 / -1;">
                <div class="icon"><i class="fa-solid fa-house" aria-hidden="true"></i></div>
                <h3>No Addresses Saved</h3>
                <p>Add addresses for faster checkout.</p>
                <button type="button" class="btn-primary" onclick="showAddAddressForm()"><i class="fa-solid fa-house" aria-hidden="true"></i> Add New Address</button>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<div id="addAddressForm" style="display: ${not empty editAddress ? 'block' : 'none'}; margin-top: 30px;">
    <div class="card">
        <h3>${not empty editAddress ? '<i class="fa-solid fa-pen" aria-hidden="true"></i> Edit Address' : '<i class="fa-solid fa-house" aria-hidden="true"></i> Add New Address'}</h3>
        <form action="/profile/addresses/save" method="post" id="addressForm">
            <c:if test="${not empty editAddress}">
                <input type="hidden" name="addressId" value="${editAddress.id}">
            </c:if>
            <c:set var="defaultFullName" value="${user.firstName} ${user.lastName}"/>
            <div class="form-group">
                <label class="form-label">Address Type</label>
                <select class="form-input" name="label" required>
                    <option value="home" ${editAddress.label == 'home' ? 'selected' : ''}>Home</option>
                    <option value="work" ${editAddress.label == 'work' ? 'selected' : ''}>Work</option>
                    <option value="other" ${editAddress.label == 'other' ? 'selected' : ''}>Other</option>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Full Name</label>
                <input type="text" name="fullName" class="form-input"
                       value="${not empty editAddress ? editAddress.fullName : defaultFullName}"
                       required>
            </div>
            <div class="form-group">
                <label class="form-label">Phone Number</label>
                <input type="tel" name="phone" class="form-input"
                       value="${not empty editAddress ? editAddress.phone : user.phone}" required>
            </div>
            <div class="form-group">
                <label class="form-label">Address Line 1</label>
                <input type="text" name="addressLine1" class="form-input"
                       value="${not empty editAddress ? editAddress.addressLine1 : user.address}"
                       placeholder="Street address" required>
            </div>
            <div class="form-group">
                <label class="form-label">Address Line 2</label>
                <input type="text" name="addressLine2" class="form-input"
                       value="${editAddress.addressLine2}"
                       placeholder="Apartment, suite, unit, etc.">
            </div>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div class="form-group">
                    <label class="form-label">City</label>
                    <input type="text" name="city" class="form-input"
                           value="${not empty editAddress ? editAddress.city : user.city}" required>
                </div>
                <div class="form-group">
                    <label class="form-label">State</label>
                    <input type="text" name="state" class="form-input"
                           value="${not empty editAddress ? editAddress.state : user.state}" required>
                </div>
            </div>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div class="form-group">
                    <label class="form-label">ZIP Code</label>
                    <input type="text" name="zipCode" class="form-input"
                           value="${not empty editAddress ? editAddress.zipCode : user.zipCode}" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Landmark</label>
                    <input type="text" name="landmark" class="form-input" value="${editAddress.landmark}">
                </div>
            </div>
            <div class="form-group">
                <label>
                    <input type="checkbox" name="defaultAddress" value="on"
                        <c:if test="${not empty editAddress && editAddress.isDefault}">checked</c:if>
                        <c:if test="${empty editAddress && empty addresses}">checked</c:if>>
                    Set as default address
                </label>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn-primary"><i class="fa-solid fa-floppy-disk" aria-hidden="true"></i> Save Address</button>
                <button type="button" class="btn-secondary" onclick="hideAddAddressForm()"><i class="fa-solid fa-circle-xmark" aria-hidden="true"></i> Cancel</button>
            </div>
        </form>
    </div>
</div>

<script src="/js/pages/profile-addresses.js"></script>
