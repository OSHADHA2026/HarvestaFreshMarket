let selectedPaymentMethod = 'card';
let isSubmitting = false;
let usingSavedPayment = false;
const DEMO_CARD_NUMBER = '4222222222222222';

function selectSavedPayment(radio) {
    if (!radio || radio.value === 'new') {
        useNewPaymentMethod();
        return;
    }

    usingSavedPayment = true;
    document.getElementById('savedPaymentId').value = radio.value;

    document.querySelectorAll('.saved-payment-option').forEach(el => el.classList.remove('selected'));
    radio.closest('.saved-payment-option').classList.add('selected');

    const type = radio.dataset.type;
    selectPaymentMethod(type === 'upi' ? 'paypal' : type);

    if (type === 'card') {
        document.getElementById('savedCardPanel').style.display = 'block';
        document.getElementById('manualCardFields').style.display = 'none';
        document.getElementById('savedCardMask').textContent =
            '**** **** **** ' + (radio.dataset.lastfour || '0000');
        document.getElementById('savedCardMeta').textContent =
            radio.dataset.label + (radio.dataset.expiry ? ' · Expires ' + radio.dataset.expiry : '');
        document.getElementById('savedCvv').setAttribute('name', 'cvv');
        document.getElementById('cvv').removeAttribute('name');
    } else {
        document.getElementById('savedCardPanel').style.display = 'none';
        document.getElementById('manualCardFields').style.display = 'none';
        document.getElementById('cvv').removeAttribute('name');
        document.getElementById('savedCvv').removeAttribute('name');
    }

    if (type === 'paypal' || type === 'upi') {
        document.getElementById('savedPaypalPanel').style.display = 'block';
        document.getElementById('manualPaypalFields').style.display = 'none';
        const detail = type === 'upi' ? radio.dataset.upi : radio.dataset.email;
        document.getElementById('savedPaypalText').textContent =
            'Pay with saved ' + (type === 'upi' ? 'UPI: ' : 'PayPal: ') + detail;
    } else {
        document.getElementById('savedPaypalPanel').style.display = 'none';
        document.getElementById('manualPaypalFields').style.display = 'block';
    }
}

function useNewPaymentMethod() {
    usingSavedPayment = false;
    document.getElementById('savedPaymentId').value = '';

    document.querySelectorAll('.saved-payment-option').forEach(el => el.classList.remove('selected'));
    const newOption = document.getElementById('savedOption-new');
    if (newOption) newOption.classList.add('selected');

    document.getElementById('savedCardPanel').style.display = 'none';
    document.getElementById('manualCardFields').style.display = 'block';
    document.getElementById('savedPaypalPanel').style.display = 'none';
    document.getElementById('manualPaypalFields').style.display = 'block';

    document.getElementById('savedCvv').removeAttribute('name');
    document.getElementById('cvv').setAttribute('name', 'cvv');

    selectPaymentMethod('card');
}

// ── Switch visible payment sub-form ──────────────────────────────────────
function selectPaymentMethod(method) {
    selectedPaymentMethod = method;

    document.querySelectorAll('.payment-method').forEach(el => el.classList.remove('selected'));
    document.querySelector('.payment-method[data-method="' + method + '"]').classList.add('selected');

    document.querySelectorAll('.payment-method-content').forEach(el => el.classList.remove('active'));
    document.getElementById(method + '-form').classList.add('active');

    document.getElementById('paymentMethod').value = method;
}

// ── Input formatters ──────────────────────────────────────────────────────
// Input formatters (null-safe)
(function () {
    const cardEl = document.getElementById('cardNumber');
    if (cardEl) {
        cardEl.addEventListener('input', function (e) {
            let raw = e.target.value.replace(/\D/g, '').substring(0, 19);
            let formatted = raw.match(/.{1,4}/g) || [];
            e.target.value = formatted.join(' ');
        });
    }

    const expEl = document.getElementById('expiryDate');
    if (expEl) {
        expEl.addEventListener('input', function (e) {
            let raw = e.target.value.replace(/\D/g, '').substring(0, 4);
            if (raw.length >= 3) {
                raw = raw.substring(0, 2) + '/' + raw.substring(2);
            }
            e.target.value = raw;
        });
    }

    // CVV: digits only
    const cvvEl = document.getElementById('cvv');
    if (cvvEl) {
        cvvEl.addEventListener('input', function (e) {
            e.target.value = e.target.value.replace(/\D/g, '').substring(0, 4);
        });
    }
})();

// ── Helper: show / hide an error under a field ────────────────────────────
// FIX: null-safe; also marks the input border red/green for clarity
function setFieldError(inputId, errorId, message) {
    const input = document.getElementById(inputId);
    const err   = document.getElementById(errorId);
    if (!input || !err) return;

    if (message) {
        err.textContent = message;
        err.style.display = 'block';
        input.classList.add('input-error');
        input.classList.remove('input-success');
    } else {
        err.textContent = '';
        err.style.display = 'none';
        input.classList.remove('input-error');
        input.classList.add('input-success');
    }
}

// ── Field-level validators ────────────────────────────────────────────────

function validateCardNumber() {
    const val = document.getElementById('cardNumber').value.replace(/\D/g, '');
    if (!/^\d{13,19}$/.test(val)) {
        setFieldError('cardNumber', 'cardNumberError', 'Enter a card number with 13 to 19 digits.');
        return false;
    }
    if (val === DEMO_CARD_NUMBER) {
        setFieldError('cardNumber', 'cardNumberError', '');
        return true;
    }

    // Luhn check
    let sum = 0, even = false;
    for (let i = val.length - 1; i >= 0; i--) {
        let d = parseInt(val[i], 10);
        if (even) { d *= 2; if (d > 9) d -= 9; }
        sum += d;
        even = !even;
    }
    if (sum % 10 !== 0) {
        setFieldError('cardNumber', 'cardNumberError', 'Invalid card number.');
        return false;
    }
    setFieldError('cardNumber', 'cardNumberError', '');
    return true;
}

function validateExpiryDate() {
    const val = document.getElementById('expiryDate').value;
    if (!/^\d{2}\/\d{2}$/.test(val)) {
        setFieldError('expiryDate', 'expiryDateError', 'Enter expiry as MM/YY.');
        return false;
    }
    const [mm, yy] = val.split('/').map(Number);
    if (mm < 1 || mm > 12) {
        setFieldError('expiryDate', 'expiryDateError', 'Month must be 01–12.');
        return false;
    }
    const expiry = new Date(2000 + yy, mm - 1, 1);
    const now    = new Date();
    now.setDate(1); now.setHours(0, 0, 0, 0);
    if (expiry < now) {
        setFieldError('expiryDate', 'expiryDateError', 'This card has expired.');
        return false;
    }
    setFieldError('expiryDate', 'expiryDateError', '');
    return true;
}

function validateSavedCvv() {
    const el = document.getElementById('savedCvv');
    const val = el ? el.value : '';
    if (!/^\d{3,4}$/.test(val)) {
        const err = document.getElementById('savedCvvError');
        if (err) {
            err.textContent = 'CVV must be 3 or 4 digits.';
            err.style.display = 'block';
        }
        if (el) el.classList.add('input-error');
        return false;
    }
    const err = document.getElementById('savedCvvError');
    if (err) { err.textContent = ''; err.style.display = 'none'; }
    if (el) el.classList.remove('input-error');
    return true;
}

function validateCVV() {
    const cvvEl = document.getElementById('cvv');
    if (!cvvEl || !cvvEl.getAttribute('name')) {
        return validateSavedCvv();
    }
    const val = cvvEl.value;
    // FIX: was missing null-guard on errorElement causing silent crash
    if (!/^\d{3,4}$/.test(val)) {
        setFieldError('cvv', 'cvvError', 'CVV must be 3 or 4 digits.');
        return false;
    }
    setFieldError('cvv', 'cvvError', '');
    return true;
}

function validateCardName() {
    const val = document.getElementById('cardName').value.trim();
    if (val.length < 2) {
        setFieldError('cardName', 'cardNameError', 'Please enter the name on your card.');
        return false;
    }
    setFieldError('cardName', 'cardNameError', '');
    return true;
}

function validatePaypalEmail() {
    const val = document.getElementById('paypalEmail').value.trim();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
        setFieldError('paypalEmail', 'paypalEmailError', 'Enter a valid PayPal email address.');
        return false;
    }
    setFieldError('paypalEmail', 'paypalEmailError', '');
    return true;
}

function validateApplePayToken() {
    const val = document.getElementById('applePayToken').value.trim();
    if (val.length < 10) {
        setFieldError('applePayToken', 'applePayTokenError',
                      'Apple Pay token could not be generated. Try a different browser.');
        return false;
    }
    setFieldError('applePayToken', 'applePayTokenError', '');
    return true;
}

// ── Billing address validators ────────────────────────────────────────────
// FIX: these fields existed in the HTML before but had NO name="" attributes
//      AND were never validated — added both.

function validateBillingAddress() {
    let ok = true;

    const fullName = document.getElementById('billingFullName').value.trim();
    if (fullName.length < 2) {
        setFieldError('billingFullName', 'billingFullNameError', 'Full name is required.');
        ok = false;
    } else { setFieldError('billingFullName', 'billingFullNameError', ''); }

    const addr = document.getElementById('billingAddress').value.trim();
    if (addr.length < 5) {
        setFieldError('billingAddress', 'billingAddressError', 'Please enter a valid street address.');
        ok = false;
    } else { setFieldError('billingAddress', 'billingAddressError', ''); }

    const city = document.getElementById('billingCity').value.trim();
    if (city.length < 2) {
        setFieldError('billingCity', 'billingCityError', 'City is required.');
        ok = false;
    } else { setFieldError('billingCity', 'billingCityError', ''); }

    const state = document.getElementById('billingState').value.trim();
    if (state.length < 2) {
        setFieldError('billingState', 'billingStateError', 'State is required.');
        ok = false;
    } else { setFieldError('billingState', 'billingStateError', ''); }

    const zip = document.getElementById('billingZipCode').value.trim();
    if (!/^[0-9A-Za-z\s\-]{3,10}$/.test(zip)) {
        setFieldError('billingZipCode', 'billingZipCodeError', 'Enter a valid ZIP / postal code.');
        ok = false;
    } else { setFieldError('billingZipCode', 'billingZipCodeError', ''); }

    return ok;
}

// ── Contact validators ────────────────────────────────────────────────────
function validateContact() {
    let ok = true;

    const email = document.getElementById('contactEmail').value.trim();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        setFieldError('contactEmail', 'contactEmailError', 'Enter a valid email address.');
        ok = false;
    } else { setFieldError('contactEmail', 'contactEmailError', ''); }

    const phone = document.getElementById('contactPhone').value.trim();
    if (phone.length < 7) {
        setFieldError('contactPhone', 'contactPhoneError', 'Enter a valid phone number.');
        ok = false;
    } else { setFieldError('contactPhone', 'contactPhoneError', ''); }

    return ok;
}

// ── Master validation ─────────────────────────────────────────────────────
function validateForm() {
    let paymentOk = true;
    let billingOk = true;
    let contactOk = true;

    if (usingSavedPayment) {
        const savedId = document.getElementById('savedPaymentId').value;
        const savedRadio = document.querySelector('input[name="savedPaymentChoice"][value="' + savedId + '"]');
        const savedType = savedRadio ? savedRadio.dataset.type : 'card';

        if (savedType === 'card') {
            paymentOk = validateSavedCvv();
        } else {
            paymentOk = true;
        }
    } else {
    switch (selectedPaymentMethod) {
        case 'card':
            const cardNumOk = validateCardNumber();
            const expiryOk = validateExpiryDate();
            const cvvOk = validateCVV();
            const cardNameOk = validateCardName();
            paymentOk = cardNumOk && expiryOk && cvvOk && cardNameOk;
            break;
        case 'paypal':
            paymentOk = validatePaypalEmail();
            break;
        case 'apple':
            paymentOk = validateApplePayToken();
            break;
        default:
            paymentOk = true;
    }
    }

    // Run all validators (don't short-circuit)
    billingOk = validateBillingAddress();
    contactOk = validateContact();

    const formValid = paymentOk && billingOk && contactOk;

    console.log('Form validation result:', {
        paymentOk: paymentOk,
        billingOk: billingOk,
        contactOk: contactOk,
        formValid: formValid
    });

    return formValid;
}

// ── Main submit handler ───────────────────────────────────────────────────
// FIX: was silently broken because (a) fields had no name attrs, (b) CVV
//      validator crashed on null errorElement, (c) no double-submit guard.
function processPayment() {
    if (isSubmitting) {
        console.warn("Payment already being processed");
        return false;
    }

    if (!validateForm()) {
        showNotification('Please fix the highlighted errors before continuing.', 'error');
        // Scroll to first error
        const firstErr = document.querySelector('.input-error');
        if (firstErr) {
            firstErr.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return false;
    }

    isSubmitting = true;

    // Show processing overlay
    document.getElementById('processingOverlay').style.display = 'flex';

    // Disable ALL pay buttons
    document.querySelectorAll('.btn-pay').forEach(btn => {
        btn.disabled = true;
        btn.innerHTML = '⏳ Processing…';
    });

    // Keep hidden field in sync
    document.getElementById('paymentMethod').value = selectedPaymentMethod;

    // Submit the form
    try {
        console.log('Submitting payment form...');
        const form = document.getElementById('paymentForm');

        // Log form data for debugging
        const formData = new FormData(form);
        console.log('Form data:', Object.fromEntries(formData));

        form.submit();
    } catch (error) {
        console.error('Error submitting form:', error);
        showNotification('An error occurred while processing your payment. Please try again.', 'error');
        isSubmitting = false;

        // Re-enable buttons
        document.querySelectorAll('.btn-pay').forEach(btn => {
            btn.disabled = false;
            btn.innerHTML = '<i class="fa-solid fa-credit-card" aria-hidden="true"></i> Complete Payment';
        });

        // Hide processing overlay
        document.getElementById('processingOverlay').style.display = 'none';
    }

    return false;
}

// ── Toast notification ────────────────────────────────────────────────────
function showNotification(message, type) {
    const bg = type === 'success' ? '#4cb98a'
             : type === 'error'   ? '#e74c3c'
             :                      '#3498db';

    const n = document.createElement('div');
    n.style.cssText =
        'position:fixed;top:20px;right:20px;background:' + bg + ';color:white;' +
        'padding:15px 20px;border-radius:8px;box-shadow:0 5px 15px rgba(0,0,0,.2);' +
        'z-index:20000;transform:translateX(110%);transition:transform .3s ease;' +
        'max-width:320px;font-size:14px;line-height:1.4;';
    n.textContent = message;
    document.body.appendChild(n);
    setTimeout(function () { n.style.transform = 'translateX(0)'; }, 50);
    setTimeout(function () {
        n.style.transform = 'translateX(110%)';
        setTimeout(function () { document.body.removeChild(n); }, 350);
    }, 4000);
}

// ── Bootstrap on DOMContentLoaded ────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {

    // Blur-time validation for instant feedback
    document.getElementById('cardNumber')  .addEventListener('blur', validateCardNumber);
    document.getElementById('expiryDate')  .addEventListener('blur', validateExpiryDate);
    document.getElementById('cvv')         .addEventListener('blur', validateCVV);
    document.getElementById('cardName')    .addEventListener('blur', validateCardName);
    document.getElementById('paypalEmail') .addEventListener('blur', validatePaypalEmail);

    document.getElementById('billingFullName').addEventListener('blur', validateBillingAddress);
    document.getElementById('billingAddress') .addEventListener('blur', validateBillingAddress);
    document.getElementById('billingCity')    .addEventListener('blur', validateBillingAddress);
    document.getElementById('billingState')   .addEventListener('blur', validateBillingAddress);
    document.getElementById('billingZipCode') .addEventListener('blur', validateBillingAddress);
    document.getElementById('contactEmail')   .addEventListener('blur', validateContact);
    document.getElementById('contactPhone')   .addEventListener('blur', validateContact);

    // Ensure pay buttons always trigger the submit flow (null-safe)
    const payButtons = document.querySelectorAll('.btn-pay');
    if (payButtons) {
        payButtons.forEach(btn => {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                processPayment();
            });
        });
    }

    // Generate Apple Pay token if the browser supports it
    if (window.ApplePaySession && ApplePaySession.canMakePayments()) {
        document.getElementById('applePayToken').value = 'apt-' + Date.now();
    }

    const paymentFlash = document.body.dataset.paymentFlash;
    if (paymentFlash === 'error') {
        showNotification('Payment failed. Please check your details and try again.', 'error');
    } else if (paymentFlash === 'success') {
        showNotification('Payment completed successfully!', 'success');
    }

    const savedCvvEl = document.getElementById('savedCvv');
    if (savedCvvEl) {
        savedCvvEl.addEventListener('blur', validateSavedCvv);
    }

    const defaultSaved = document.querySelector('input[name="savedPaymentChoice"]:checked:not([value="new"])');
    if (defaultSaved) {
        selectSavedPayment(defaultSaved);
    }
});
