<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Sign Up</title>
    <link rel="stylesheet" href="/css/pages/register.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="signup-container">
    <div class="signup-card">
        <h1 class="signup-title">Join Us Today</h1>
        <p class="signup-subtitle">Create your account and start shopping fresh groceries</p>

        <!-- Error Message -->
        <div class="error-message" id="errorMessage">
            There was an error creating your account. Please try again.
        </div>

        <!-- Success Message -->
        <div class="success-message" id="successMessage">
            Account created successfully! Redirecting to login...
        </div>

        <form action="/signup" method="POST" id="signupForm">
            <div class="name-fields">
                <div class="form-group">
                    <label for="firstName" class="form-label"><i class="fa-solid fa-user" aria-hidden="true"></i> First Name</label>
                    <input type="text" id="firstName" name="firstName" class="form-input" placeholder="Enter your first name" required>
                </div>

                <div class="form-group">
                    <label for="lastName" class="form-label"><i class="fa-solid fa-user" aria-hidden="true"></i> Last Name</label>
                    <input type="text" id="lastName" name="lastName" class="form-input" placeholder="Enter your last name" required>
                </div>
            </div>

            <div class="form-group">
                <label for="email" class="form-label"><i class="fa-solid fa-envelope" aria-hidden="true"></i> Email Address</label>
                <input type="email" id="email" name="email" class="form-input" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label for="phone" class="form-label"><i class="fa-solid fa-phone" aria-hidden="true"></i> Phone Number</label>
                <input type="tel" id="phone" name="phone" class="form-input" placeholder="Enter your phone number">
            </div>

            <div class="form-group">
                <label for="password" class="form-label"><i class="fa-solid fa-lock" aria-hidden="true"></i> Password</label>
                <div class="password-container">
                    <input type="password" id="password" name="password" class="form-input" placeholder="Create a password" required>
                    <button type="button" class="toggle-password" id="togglePassword"><i class="fa-solid fa-eye" aria-hidden="true"></i></button>
                </div>
                <div class="password-strength" id="passwordStrength"></div>
                <div class="password-requirements">
                    Must be at least 8 characters with uppercase, lowercase, and number
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label"><i class="fa-solid fa-lock" aria-hidden="true"></i> Confirm Password</label>
                <div class="password-container">
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Confirm your password" required>
                    <button type="button" class="toggle-password" id="toggleConfirmPassword"><i class="fa-solid fa-eye" aria-hidden="true"></i></button>
                </div>
                <div class="password-requirements" id="passwordMatch"></div>
            </div>

            <div class="form-group">
                <label for="address" class="form-label"><i class="fa-solid fa-house" aria-hidden="true"></i> Delivery Address</label>
                <textarea id="address" name="address" class="form-input" placeholder="Enter your delivery address" rows="3"></textarea>
            </div>

            <div class="terms">
                <input type="checkbox" id="terms" name="terms" required>
                <label for="terms">I agree to the <a href="/terms">Terms of Service</a> and <a href="/privacy">Privacy Policy</a></label>
            </div>

            <button type="submit" class="btn-signup" id="signupButton">Create Account</button>
        </form>

        <div class="divider">
            <span class="divider-text">Already have an account?</span>
        </div>

        <p class="login-link">
            Already registered? <a href="/login">Sign in here</a>
        </p>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script src="/js/pages/register.js"></script>
</body>
</html>
