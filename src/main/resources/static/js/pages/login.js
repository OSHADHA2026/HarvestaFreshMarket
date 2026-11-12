// Show success message if redirected from signup
const urlParams = new URLSearchParams(window.location.search);
if (urlParams.get('signup') === 'success') {
    document.getElementById('successMessage').style.display = 'block';
}

// Show error message if login fails
if (urlParams.get('error') === 'true') {
    document.getElementById('errorMessage').style.display = 'block';
}

// Password toggle functionality
const togglePassword = document.getElementById('togglePassword');
const passwordInput = document.getElementById('password');

togglePassword.addEventListener('click', function() {
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);
    this.innerHTML = type === 'password' ? '<i class="fa-solid fa-eye" aria-hidden="true"></i>' : '<i class="fa-solid fa-eye-slash" aria-hidden="true"></i>';
});

// Form validation
document.getElementById('loginForm').addEventListener('submit', function(e) {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    if (!email || !password) {
        e.preventDefault();
        alert('Please fill in all fields');
        return false;
    }

    // Basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        e.preventDefault();
        alert('Please enter a valid email address');
        return false;
    }
});
