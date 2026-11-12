// Toggle FAQ items
function toggleFAQ(element) {
    element.classList.toggle('active');
}

// Form submission
document.getElementById('contactForm').addEventListener('submit', function(e) {
    e.preventDefault();

    // Simple form validation
    const firstName = document.getElementById('firstName').value;
    const lastName = document.getElementById('lastName').value;
    const email = document.getElementById('email').value;
    const subject = document.getElementById('subject').value;
    const message = document.getElementById('message').value;

    if (!firstName || !lastName || !email || !subject || !message) {
        alert('Please fill in all required fields.');
        return;
    }

    // Show success message
    const successMessage = document.getElementById('successMessage');
    successMessage.style.display = 'block';

    // Reset form
    this.reset();

    // Scroll to success message
    successMessage.scrollIntoView({ behavior: 'smooth' });

    // In a real application, you would send the form data to your server here
    console.log('Form submitted:', { firstName, lastName, email, subject, message });
});

// Phone number formatting
document.getElementById('phone').addEventListener('input', function(e) {
    let value = e.target.value.replace(/\D/g, '');

    if (value.length > 3 && value.length <= 6) {
        value = value.replace(/(\d{3})(\d+)/, '($1) $2');
    } else if (value.length > 6) {
        value = value.replace(/(\d{3})(\d{3})(\d+)/, '($1) $2-$3');
    }

    e.target.value = value;
});

// Auto-expand textarea
document.getElementById('message').addEventListener('input', function(e) {
    this.style.height = 'auto';
    this.style.height = (this.scrollHeight) + 'px';
});

// Initialize some sample data for demo
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('firstName').value = 'John';
    document.getElementById('lastName').value = 'Doe';
    document.getElementById('email').value = 'john.doe@example.com';
    document.getElementById('phone').value = '(123) 456-7890';
    document.getElementById('subject').value = 'general';
    document.getElementById('message').value = 'I would like to know more about your delivery services in my area.';
});
