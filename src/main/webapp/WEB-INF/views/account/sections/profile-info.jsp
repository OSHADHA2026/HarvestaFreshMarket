<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="section-header">
    <h1 class="section-title">Profile Information</h1>
    <button class="btn-primary" onclick="toggleEditMode()"><i class="fa-solid fa-pen" aria-hidden="true"></i> Edit Profile</button>
</div>

<!-- View Mode -->
<div id="viewMode">
    <div class="info-grid">
        <div class="card">
            <h3><i class="fa-solid fa-user" aria-hidden="true"></i> Personal Information</h3>
            <div class="info-item">
                <span class="info-label">First Name:</span>
                <span class="info-value">${user.firstName}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Last Name:</span>
                <span class="info-value">${user.lastName}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Email:</span>
                <span class="info-value">${user.email}</span>
            </div>
            <div class="info-item">
                <span class="info-label">Phone:</span>
                <span class="info-value">
                    ${not empty user.phone ? user.phone : '<span style="color: #95a5a6; font-style: italic;">Not provided</span>'}
                </span>
            </div>
        </div>

        <div class="card">
            <h3><i class="fa-solid fa-house" aria-hidden="true"></i> Delivery Information</h3>
            <div class="info-item">
                <span class="info-label">Address:</span>
                <span class="info-value">
                    ${not empty user.address ? user.address : '<span style="color: #95a5a6; font-style: italic;">No address saved</span>'}
                </span>
            </div>
        </div>
    </div>

    <div class="action-buttons">
        <a href="/profile?section=orders" class="btn-secondary" onclick="return switchProfileSection('orders', event)"><i class="fa-solid fa-box" aria-hidden="true"></i> View Order History</a>
        <a href="/profile?section=settings" class="btn-secondary" onclick="return switchProfileSection('settings', event)"><i class="fa-solid fa-gear" aria-hidden="true"></i> Account Settings</a>
        <a href="/logout" class="btn-danger" onclick="return confirm('Are you sure you want to logout?')"><i class="fa-solid fa-arrow-right-from-bracket" aria-hidden="true"></i> Logout</a>
    </div>
</div>

<!-- Edit Mode -->
<div id="editMode" style="display: none;">
    <form action="/update-profile" method="POST" id="profileForm">
        <div class="info-grid">
            <div class="card">
                <h3><i class="fa-solid fa-user" aria-hidden="true"></i> Edit Personal Information</h3>
                <div class="form-group">
                    <label class="form-label">First Name</label>
                    <input type="text" name="firstName" class="form-input" value="${user.firstName}" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Last Name</label>
                    <input type="text" name="lastName" class="form-input" value="${user.lastName}" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-input" value="${user.email}" readonly style="background-color: var(--hv-page, #f3faf5);">
                    <small style="color: #7f8c8d; font-size: 12px;">Email cannot be changed</small>
                </div>
                <div class="form-group">
                    <label class="form-label">Phone Number</label>
                    <input type="tel" name="phone" class="form-input" value="${user.phone}">
                </div>
            </div>

            <div class="card">
                <h3><i class="fa-solid fa-house" aria-hidden="true"></i> Edit Delivery Information</h3>
                <div class="form-group">
                    <label class="form-label">Delivery Address</label>
                    <textarea name="address" class="form-input" rows="4" placeholder="Enter your complete delivery address">${user.address}</textarea>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-primary"><i class="fa-solid fa-floppy-disk" aria-hidden="true"></i> Save Changes</button>
            <button type="button" class="btn-secondary" onclick="toggleEditMode()"><i class="fa-solid fa-circle-xmark" aria-hidden="true"></i> Cancel</button>
        </div>
    </form>
</div>
