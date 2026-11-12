// Smooth scrolling for quick navigation
document.querySelectorAll('.quick-nav a').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();

        const targetId = this.getAttribute('href');
        const targetElement = document.querySelector(targetId);

        window.scrollTo({
            top: targetElement.offsetTop - 100,
            behavior: 'smooth'
        });
    });
});

// Terms acceptance button
document.querySelector('.accept-btn').addEventListener('click', function() {
    this.textContent = 'Terms Accepted!';
    this.style.backgroundColor = '#4caf50';
    this.disabled = true;

    // In a real implementation, you would save this preference
    alert('Thank you for accepting our Terms of Service.');
});

// Sticky quick navigation
window.addEventListener('scroll', function() {
    const quickNav = document.querySelector('.quick-nav');
    const scrollPosition = window.scrollY;

    if (scrollPosition > 200) {
        quickNav.style.boxShadow = '0 5px 15px rgba(0,0,0,0.1)';
    } else {
        quickNav.style.boxShadow = 'var(--shadow)';
    }
});
