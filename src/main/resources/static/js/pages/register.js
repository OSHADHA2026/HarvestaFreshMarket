// Show error message if registration fails
const urlParams = new URLSearchParams(window.location.search);
if (urlParams.get('error') === 'true') {
    document.getElementById('errorMessage').style.display = 'block';
}

// Password toggle functionality
const togglePassword = document.getElementById('togglePassword');
const passwordInput = document.getElementById('password');
const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
const confirmPasswordInput = document.getElementById('confirmPassword');

togglePassword.addEventListener('click', function() {
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);
    this.innerHTML = type === 'password' ? '<i class="fa-solid fa-eye" aria-hidden="true"></i>' : '<i class="fa-solid fa-eye-slash" aria-hidden="true"></i>';
});

toggleConfirmPassword.addEventListener('click', function() {
    const type = confirmPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    confirmPasswordInput.setAttribute('type', type);
    this.innerHTML = type === 'password' ? '<i class="fa-solid fa-eye" aria-hidden="true"></i>' : '<i class="fa-solid fa-eye-slash" aria-hidden="true"></i>';
});

// Password strength indicator
document.getElementById('password').addEventListener('input', function(e) {
    const password = e.target.value;
    const strengthBar = document.getElementById('passwordStrength');

    // Reset
    strengthBar.className = 'password-strength';

    if (password.length === 0) {
        return;
    }

    let strength = 0;

    // Length check
    if (password.length >= 8) strength += 1;

    // Contains lowercase
    if (/[a-z]/.test(password)) strength += 1;

    // Contains uppercase
    if (/[A-Z]/.test(password)) strength += 1;

    // Contains numbers
    if (/[0-9]/.test(password)) strength += 1;

    // Contains special characters
    if (/[^A-Za-z0-9]/.test(password)) strength += 1;

    // Update strength bar
    if (strength <= 2) {
        strengthBar.classList.add('strength-weak');
    } else if (strength <= 4) {
        strengthBar.classList.add('strength-medium');
    } else {
        strengthBar.classList.add('strength-strong');
    }
});

// Password confirmation check
document.getElementById('confirmPassword').addEventListener('input', function(e) {
    const password = document.getElementById('password').value;
    const confirmPassword = e.target.value;
    const matchText = document.getElementById('passwordMatch');

    if (confirmPassword.length === 0) {
        matchText.textContent = '';
        return;
    }

    if (password === confirmPassword) {
        matchText.innerHTML = '✓ Passwords match';
        matchText.style.color = '#4cb98a';
    } else {
        matchText.innerHTML = '✗ Passwords do not match';
        matchText.style.color = '#e74c3c';
    }
});

// Form validation - ONLY PREVENT SUBMISSION IF VALIDATION FAILS
document.getElementById('signupForm').addEventListener('submit', function(e) {
    const firstName = document.getElementById('firstName').value;
    const lastName = document.getElementById('lastName').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const terms = document.getElementById('terms').checked;

    // Basic validation
    if (!firstName || !lastName || !email || !password || !confirmPassword) {
        e.preventDefault();
        showError('Please fill in all required fields');
        return false;
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        e.preventDefault();
        showError('Please enter a valid email address');
        return false;
    }

    // Password validation
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
    if (!passwordRegex.test(password)) {
        e.preventDefault();
        showError('Password must be at least 8 characters with uppercase, lowercase, and number');
        return false;
    }

    // Password match
    if (password !== confirmPassword) {
        e.preventDefault();
        showError('Passwords do not match');
        return false;
    }

    // Terms agreement
    if (!terms) {
        e.preventDefault();
        showError('Please agree to the Terms of Service and Privacy Policy');
        return false;
    }

    // If all validations pass, ALLOW the form to submit to the backend
    // Show loading state but don't prevent form submission
    document.getElementById('successMessage').style.display = 'block';
    document.getElementById('signupButton').disabled = true;
    document.getElementById('signupButton').textContent = 'Creating Account...';
});

function showError(message) {
    const errorDiv = document.getElementById('errorMessage');
    errorDiv.textContent = message;
    errorDiv.style.display = 'block';

    // Hide error after 5 seconds
    setTimeout(() => {
        errorDiv.style.display = 'none';
    }, 5000);
}
