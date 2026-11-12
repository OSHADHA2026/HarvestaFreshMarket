// Show messages from URL parameters
const urlParams = new URLSearchParams(window.location.search);
if (urlParams.get('error')) {
    document.getElementById('errorMessage').textContent = urlParams.get('error');
    document.getElementById('errorMessage').style.display = 'block';
}
if (urlParams.get('success')) {
    document.getElementById('successMessage').textContent = urlParams.get('success');
    document.getElementById('successMessage').style.display = 'block';
}

// Password toggle functionality
function togglePassword(inputId, button) {
    const input = document.getElementById(inputId);
    const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
    input.setAttribute('type', type);
    button.innerHTML = type === 'password' ? '<i class="fa-solid fa-eye" aria-hidden="true"></i>' : '<i class="fa-solid fa-eye-slash" aria-hidden="true"></i>';
}

// Password confirmation check
document.getElementById('confirmPassword').addEventListener('input', function(e) {
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = e.target.value;
    const matchText = document.getElementById('passwordMatch');

    if (confirmPassword.length === 0) {
        matchText.textContent = '';
        return;
    }

    if (newPassword === confirmPassword) {
        matchText.innerHTML = '✓ Passwords match';
        matchText.style.color = '#4cb98a';
    } else {
        matchText.innerHTML = '✗ Passwords do not match';
        matchText.style.color = '#e74c3c';
    }
});

// Form validation
document.getElementById('passwordForm').addEventListener('submit', function(e) {
    const currentPassword = document.getElementById('currentPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (!currentPassword || !newPassword || !confirmPassword) {
        e.preventDefault();
        showError('Please fill in all fields');
        return false;
    }

    if (newPassword.length < 6) {
        e.preventDefault();
        showError('New password must be at least 6 characters long');
        return false;
    }

    if (newPassword !== confirmPassword) {
        e.preventDefault();
        showError('New passwords do not match');
        return false;
    }

    if (newPassword === currentPassword) {
        e.preventDefault();
        showError('New password must be different from current password');
        return false;
    }
});

function showError(message) {
    const errorDiv = document.getElementById('errorMessage');
    errorDiv.textContent = message;
    errorDiv.style.display = 'block';

    // Auto-hide error after 5 seconds
    setTimeout(() => {
        errorDiv.style.display = 'none';
    }, 5000);
}
