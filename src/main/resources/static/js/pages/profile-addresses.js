function showAddAddressForm() {
    document.getElementById('addAddressForm').style.display = 'block';
    window.scrollTo({ top: document.getElementById('addAddressForm').offsetTop - 20, behavior: 'smooth' });
}

function hideAddAddressForm() {
    window.location.href = '/profile?section=addresses';
}
