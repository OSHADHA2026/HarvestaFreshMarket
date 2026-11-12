<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Login</title>
    <link rel="stylesheet" href="/css/pages/login.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="login-container">
    <div class="login-card">
        <h1 class="login-title">Welcome Back</h1>
        <p class="login-subtitle">Sign in to your account to continue shopping</p>

        <!-- Error Message (shown when login fails) -->
        <div class="error-message" id="errorMessage">
            Invalid email or password. Please try again.
        </div>

        <!-- Success Message (shown after signup) -->
        <div class="success-message" id="successMessage">
            Account created successfully! Please log in.
        </div>

        <form action="/login" method="POST" id="loginForm">
            <div class="form-group">
                <label for="email" class="form-label"><i class="fa-solid fa-envelope" aria-hidden="true"></i> Email Address</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label for="password" class="form-label"><i class="fa-solid fa-lock" aria-hidden="true"></i> Password</label>
                <div class="password-container">
                    <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
                    <button type="button" class="toggle-password" id="togglePassword"><i class="fa-solid fa-eye" aria-hidden="true"></i></button>
                </div>
            </div>

            <div class="forgot-password">
                <a href="/forgot-password">Forgot your password?</a>
            </div>

            <button type="submit" class="btn-login">Sign In</button>
        </form>

        <div class="divider">
            <span class="divider-text">New to SuperMarket?</span>
        </div>

        <p class="signup-link">
            Don't have an account? <a href="/register">Create one here</a>
        </p>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script src="/js/pages/login.js"></script>
</body>
</html>
