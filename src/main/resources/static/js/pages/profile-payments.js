function showAddPaymentForm() {
    document.getElementById('addPaymentForm').style.display = 'block';
    togglePaymentFields();
    window.scrollTo({ top: document.getElementById('addPaymentForm').offsetTop - 20, behavior: 'smooth' });
}

function hideAddPaymentForm() {
    window.location.href = '/profile?section=payments';
}

function togglePaymentFields() {
    const type = document.getElementById('paymentType').value;
    document.getElementById('cardFields').style.display = type === 'card' ? 'block' : 'none';
    document.getElementById('paypalFields').style.display = type === 'paypal' ? 'block' : 'none';
    document.getElementById('upiFields').style.display = type === 'upi' ? 'block' : 'none';
}

document.addEventListener('DOMContentLoaded', togglePaymentFields);
