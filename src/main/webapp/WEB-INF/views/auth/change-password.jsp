<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.supermarket.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Change Password</title>
    <link rel="stylesheet" href="/css/pages/change-password.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="main-container">
    <div class="password-card">
        <h1 class="password-title">Change Password</h1>
        <p class="password-subtitle">Update your account password</p>

        <!-- Error Message -->
        <div class="error-message" id="errorMessage"></div>

        <!-- Success Message -->
        <div class="success-message" id="successMessage"></div>

        <form action="/change-password" method="POST" id="passwordForm">
            <div class="form-group">
                <label for="currentPassword" class="form-label"><i class="fa-solid fa-lock" aria-hidden="true"></i> Current Password</label>
                <div class="input-container">
                    <input type="password" id="currentPassword" name="currentPassword" class="form-input" placeholder="Enter your current password" required>
                    <button type="button" class="toggle-password" onclick="togglePassword('currentPassword', this)"><i class="fa-solid fa-eye" aria-hidden="true"></i></button>
                </div>
            </div>

            <div class="form-group">
                <label for="newPassword" class="form-label"><i class="fa-solid fa-key" aria-hidden="true"></i> New Password</label>
                <div class="input-container">
                    <input type="password" id="newPassword" name="newPassword" class="form-input" placeholder="Enter new password" required>
                    <button type="button" class="toggle-password" onclick="togglePassword('newPassword', this)"><i class="fa-solid fa-eye" aria-hidden="true"></i></button>
                </div>
                <div class="password-requirements">
                    Must be at least 6 characters long
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label"><i class="fa-solid fa-key" aria-hidden="true"></i> Confirm New Password</label>
                <div class="input-container">
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Confirm new password" required>
                    <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword', this)"><i class="fa-solid fa-eye" aria-hidden="true"></i></button>
                </div>
                <div class="password-requirements" id="passwordMatch"></div>
            </div>

            <button type="submit" class="btn-change-password">Change Password</button>
            <a href="/profile?section=settings" class="btn-cancel">Cancel</a>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script src="/js/pages/change-password.js"></script>
</body>
</html>
