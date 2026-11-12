<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="section-header">
    <h1 class="section-title">Account Settings</h1>
</div>

<div class="info-grid">
    <!-- Security Settings -->
    <div class="card">
        <h3><i class="fa-solid fa-lock" aria-hidden="true"></i> Security Settings</h3>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <div class="info-item">
            <span class="info-label">Password:</span>
            <span class="info-value">••••••••</span>
        </div>
        <div class="action-buttons">
            <a href="/change-password" class="btn-primary"><i class="fa-solid fa-key" aria-hidden="true"></i> Change Password</a>
        </div>
    </div>

    <!-- Privacy Settings -->
    <div class="card">
        <h3><i class="fa-solid fa-eye" aria-hidden="true"></i> Privacy Settings</h3>

        <div class="form-group">
            <label>
                <input type="checkbox" checked> Show my profile in search results
            </label>
        </div>
        <div class="form-group">
            <label>
                <input type="checkbox"> Allow personalized recommendations
            </label>
        </div>
        <div class="form-group">
            <label>
                <input type="checkbox" checked> Share data with trusted partners
            </label>
        </div>
        <div class="form-actions">
            <button type="button" class="btn-primary" disabled title="Coming soon"><i class="fa-solid fa-floppy-disk" aria-hidden="true"></i> Save Settings</button>
        </div>
    </div>

    <!-- Account Actions -->
    <div class="card">
        <h3><i class="fa-solid fa-gear" aria-hidden="true"></i> Account Actions</h3>
        <p class="text-muted" style="margin-bottom: 15px;">Permanently remove your account and all associated data.</p>
        <div class="action-buttons">
            <button type="button" class="btn-danger" id="openDeleteAccountBtn"><i class="fa-solid fa-trash" aria-hidden="true"></i> Delete Account</button>
        </div>
    </div>
</div>

<!-- Delete Account Modal -->
<div id="deleteAccountModal" class="delete-account-modal" hidden>
    <div class="delete-account-modal-dialog" role="dialog" aria-labelledby="deleteAccountTitle" aria-modal="true">
        <h3 id="deleteAccountTitle" style="color: var(--hv-ac-red, #e74c3c); margin-bottom: 15px;"><i class="fa-solid fa-trash" aria-hidden="true"></i> Delete Account</h3>
        <p style="margin-bottom: 20px; color: var(--hv-text-strong, #214a38);">
            <strong>Warning:</strong> This action cannot be undone. This will permanently delete your account and all associated data including orders, addresses, and payment methods.
        </p>
        <form action="/delete-account" method="post" id="deleteAccountForm">
            <div class="form-group">
                <label class="form-label" for="deleteAccountPassword">Enter your password to confirm:</label>
                <input type="password" id="deleteAccountPassword" name="password" class="form-input" required autocomplete="current-password">
            </div>
            <div class="form-actions">
                <button type="submit" class="btn-danger" style="background-color: #e74c3c;"><i class="fa-solid fa-trash" aria-hidden="true"></i> Delete My Account</button>
                <button type="button" class="btn-secondary" id="cancelDeleteAccountBtn"><i class="fa-solid fa-circle-xmark" aria-hidden="true"></i> Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    (function () {
        var modal = document.getElementById('deleteAccountModal');
        var openBtn = document.getElementById('openDeleteAccountBtn');
        var cancelBtn = document.getElementById('cancelDeleteAccountBtn');

        function showDeleteAccountModal() {
            modal.removeAttribute('hidden');
        }

        function hideDeleteAccountModal() {
            modal.setAttribute('hidden', '');
        }

        if (openBtn) {
            openBtn.addEventListener('click', showDeleteAccountModal);
        }
        if (cancelBtn) {
            cancelBtn.addEventListener('click', hideDeleteAccountModal);
        }
        if (modal) {
            modal.addEventListener('click', function (e) {
                if (e.target === modal) {
                    hideDeleteAccountModal();
                }
            });
        }

        var openDeleteModal = ${not empty error};
        if (openDeleteModal) {
            showDeleteAccountModal();
        }
    })();
</script>
