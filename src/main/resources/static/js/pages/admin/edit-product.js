(function () {
    var isDealCheckbox = document.getElementById('isDeal');
    var dealExpiryGroup = document.getElementById('dealExpiryGroup');
    var dealExpiryDate = document.getElementById('dealExpiryDate');
    var dealExpiryTime = document.getElementById('dealExpiryTime');
    var productForm = document.getElementById('productForm');

    function toggleDealFields() {
        var show = isDealCheckbox.checked;
        dealExpiryGroup.style.display = show ? 'block' : 'none';
        dealExpiryDate.required = show;
        dealExpiryTime.required = show;
    }

    isDealCheckbox.addEventListener('change', toggleDealFields);
    toggleDealFields();

    productForm.addEventListener('submit', function (e) {
        if (!isDealCheckbox.checked) {
            return true;
        }
        if (!dealExpiryDate.value) {
            e.preventDefault();
            alert('Please enter a deal expiry date.');
            dealExpiryDate.focus();
            return false;
        }
        if (!dealExpiryTime.value) {
            e.preventDefault();
            alert('Please enter a deal expiry time.');
            dealExpiryTime.focus();
            return false;
        }
        var expiry = new Date(dealExpiryDate.value + 'T' + dealExpiryTime.value);
        if (isNaN(expiry.getTime())) {
            e.preventDefault();
            alert('Please enter a valid deal expiry date and time.');
            return false;
        }
        return true;
    });
})();
