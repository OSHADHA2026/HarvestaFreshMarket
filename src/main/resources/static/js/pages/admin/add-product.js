(function () {
    var isDealCheckbox = document.getElementById('isDeal');
    var dealExpiryGroup = document.getElementById('dealExpiryGroup');
    var dealExpiryDate = document.getElementById('dealExpiryDate');
    var dealExpiryTime = document.getElementById('dealExpiryTime');
    var productForm = document.getElementById('productForm');

    function todayString() {
        var now = new Date();
        var month = String(now.getMonth() + 1).padStart(2, '0');
        var day = String(now.getDate()).padStart(2, '0');
        return now.getFullYear() + '-' + month + '-' + day;
    }

    function toggleDealFields() {
        var show = isDealCheckbox.checked;
        dealExpiryGroup.style.display = show ? 'block' : 'none';
        dealExpiryDate.required = show;
        dealExpiryTime.required = show;
        if (show) {
            dealExpiryDate.min = todayString();
        } else {
            dealExpiryDate.value = '';
            dealExpiryTime.value = '';
        }
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
