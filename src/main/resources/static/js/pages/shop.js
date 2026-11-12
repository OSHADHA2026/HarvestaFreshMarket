// Store the original scroll position
let originalScrollY = 0;
let isFilterAction = false;

// Initialize everything
// Handle image loading errors
function handleImageError(img) {
    if (img && img.parentElement) {
        img.style.display = 'none';
        img.parentElement.innerHTML = '<span class="emoji-fallback"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    console.log('Products page loaded');

    updateCartCount();
    initializeWishlist();
    setupFilterListeners();
    restoreProductsView();

    document.querySelectorAll('.filter-tag-remove').forEach(function (btn) {
        btn.addEventListener('click', function () {
            removeCategoryFilter(btn.getAttribute('data-category'));
        });
    });

    // Restore scroll position if we have one saved
    restoreScrollPosition();

    // Debug info
    console.log('Initial scroll position:', window.scrollY);
});

// Save scroll position BEFORE any navigation happens
function saveScrollPosition() {
    originalScrollY = window.pageYOffset || document.documentElement.scrollTop;
    console.log('Scroll position saved:', originalScrollY);

    // Store in multiple places for reliability
    sessionStorage.setItem('productScrollY', originalScrollY.toString());
    localStorage.setItem('tempProductScrollY', originalScrollY.toString());

    // Also store in a hidden field in the form
    const scrollInput = document.getElementById('scrollPosition');
    if (!scrollInput) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.id = 'scrollPosition';
        input.name = 'scrollY';
        input.value = originalScrollY;
        document.getElementById('filterForm').appendChild(input);
    } else {
        scrollInput.value = originalScrollY;
    }

    // Create or update scroll anchor
    let anchor = document.getElementById('scroll-anchor');
    if (!anchor) {
        anchor = document.createElement('div');
        anchor.id = 'scroll-anchor';
        document.body.appendChild(anchor);
    }
    anchor.style.top = originalScrollY + 'px';
}

// Restore scroll position after page loads
function restoreScrollPosition() {
    // Try multiple sources to get saved scroll position
    let scrollY = null;

    // 1. Check URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const urlScrollY = urlParams.get('scrollY');
    if (urlScrollY) {
        scrollY = parseInt(urlScrollY);
        console.log('Found scrollY in URL:', scrollY);
    }

    // 2. Check sessionStorage
    if (!scrollY) {
        const sessionScroll = sessionStorage.getItem('productScrollY');
        if (sessionScroll) {
            scrollY = parseInt(sessionScroll);
            console.log('Found scrollY in sessionStorage:', scrollY);
            sessionStorage.removeItem('productScrollY');
        }
    }

    // 3. Check localStorage
    if (!scrollY) {
        const localScroll = localStorage.getItem('tempProductScrollY');
        if (localScroll) {
            scrollY = parseInt(localScroll);
            console.log('Found scrollY in localStorage:', scrollY);
            localStorage.removeItem('tempProductScrollY');
        }
    }

    // Restore if we have a valid position
    if (scrollY && scrollY > 0) {
        console.log('Restoring scroll to:', scrollY);

        // Method 1: Direct scroll (immediate)
        window.scrollTo(0, scrollY);

        // Method 2: After a small delay (in case browser resets it)
        setTimeout(() => {
            if (Math.abs(window.scrollY - scrollY) > 100) {
                window.scrollTo({ top: scrollY, behavior: 'instant' });
            }
        }, 10);

        // Method 3: After images load
        setTimeout(() => {
            if (Math.abs(window.scrollY - scrollY) > 100) {
                window.scrollTo({ top: scrollY, behavior: 'instant' });
            }
        }, 100);

        // Method 4: Final check after everything loads
        window.addEventListener('load', () => {
            setTimeout(() => {
                if (Math.abs(window.scrollY - scrollY) > 100) {
                    window.scrollTo({ top: scrollY, behavior: 'instant' });
                    console.log('Final scroll restoration');
                }
            }, 200);
        });
    }
}

// Setup all filter event listeners
function setupFilterListeners() {
    console.log('Setting up filter listeners');

    // Save scroll position on any user interaction
    document.addEventListener('mousedown', function(e) {
        if (e.target.closest('#filterForm') ||
            e.target.closest('.sort-options') ||
            e.target.closest('.products-toolbar')) {
            originalScrollY = window.pageYOffset || document.documentElement.scrollTop;
            console.log('Mouse down - saved scroll:', originalScrollY);
        }
    });

    document.addEventListener('touchstart', function(e) {
        if (e.target.closest('#filterForm') ||
            e.target.closest('.sort-options') ||
            e.target.closest('.products-toolbar')) {
            originalScrollY = window.pageYOffset || document.documentElement.scrollTop;
            console.log('Touch start - saved scroll:', originalScrollY);
        }
    });

    // Intercept form submission
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        // Store original submit
        const originalSubmit = filterForm.submit;

        // Override submit method
        filterForm.submit = function() {
            console.log('Form submit intercepted');

            // Save scroll position
            saveScrollPosition();

            // Call original submit
            originalSubmit.call(this);
        };

        // Also handle submit event
        filterForm.addEventListener('submit', function(e) {
            console.log('Form submit event');

            // Validate price range
            if (!validatePriceRange()) {
                e.preventDefault();
                return false;
            }

            // Save scroll position
            saveScrollPosition();

            // Add loading indicator
            showFilterLoading();

            return true;
        });
    }

    // Handle all checkbox changes
    document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
        checkbox.addEventListener('change', function(e) {
            console.log('Checkbox changed:', this.name, this.value);
            e.preventDefault();

            // Save scroll position
            saveScrollPosition();

            // Submit form after small delay
            setTimeout(() => {
                document.getElementById('filterForm').submit();
            }, 50);
        });
    });

    // Handle sort select
    const sortSelect = document.getElementById('sort');
    if (sortSelect) {
        sortSelect.addEventListener('change', function(e) {
            console.log('Sort changed:', this.value);

            // Save scroll position
            saveScrollPosition();

            // Update hidden sort value and submit
            document.getElementById('sortValue').value = this.value;

            setTimeout(() => {
                document.getElementById('filterForm').submit();
            }, 50);
        });
    }

    // Price inputs with debounce
    const minPriceInput = document.querySelector('input[name="minPrice"]');
    const maxPriceInput = document.querySelector('input[name="maxPrice"]');

    if (minPriceInput) {
        let priceTimeout;
        minPriceInput.addEventListener('input', function() {
            clearTimeout(priceTimeout);
            priceTimeout = setTimeout(() => {
                if (this.value.trim() !== '') {
                    saveScrollPosition();
                    validateAndSubmit();
                }
            }, 800);
        });

        minPriceInput.addEventListener('blur', function() {
            if (this.value.trim() !== '') {
                saveScrollPosition();
                validateAndSubmit();
            }
        });
    }

    if (maxPriceInput) {
        let priceTimeout;
        maxPriceInput.addEventListener('input', function() {
            clearTimeout(priceTimeout);
            priceTimeout = setTimeout(() => {
                if (this.value.trim() !== '') {
                    saveScrollPosition();
                    validateAndSubmit();
                }
            }, 800);
        });

        maxPriceInput.addEventListener('blur', function() {
            if (this.value.trim() !== '') {
                saveScrollPosition();
                validateAndSubmit();
            }
        });
    }

    // Search input with debounce
    const searchInput = document.querySelector('input[name="search"]');
    if (searchInput) {
        let searchTimeout;
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                if (this.value.trim() !== '') {
                    saveScrollPosition();
                    document.getElementById('filterForm').submit();
                }
            }, 500);
        });
    }

    // Clear filters button
    const clearBtn = document.querySelector('.btn-apply[onclick="clearFilters()"]');
    if (clearBtn) {
        clearBtn.addEventListener('click', function(e) {
            e.preventDefault();
            saveScrollPosition();
            clearFilters();
        });
    }

    // Also save scroll on beforeunload as backup
    window.addEventListener('beforeunload', function() {
        if (isFilterAction) {
            const currentScroll = window.pageYOffset || document.documentElement.scrollTop;
            sessionStorage.setItem('productScrollY', currentScroll.toString());
        }
    });
}

function validateAndSubmit() {
    if (validatePriceRange()) {
        document.getElementById('filterForm').submit();
    }
}

function showFilterLoading() {
    // Create loading indicator
    let loader = document.getElementById('filterLoader');
    if (!loader) {
        loader = document.createElement('div');
        loader.id = 'filterLoader';
        loader.innerHTML = '<i class="fa-solid fa-rotate" aria-hidden="true"></i> Applying filters...';
        loader.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #2fa36f;
            color: white;
            padding: 10px 15px;
            border-radius: 5px;
            z-index: 9999;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            font-size: 14px;
        `;
        document.body.appendChild(loader);
    }

    // Remove after 2 seconds
    setTimeout(() => {
        if (loader.parentNode) {
            document.body.removeChild(loader);
        }
    }, 2000);
}

// Price range validation
function validatePriceRange() {
    const minPriceInput = document.querySelector('input[name="minPrice"]');
    const maxPriceInput = document.querySelector('input[name="maxPrice"]');
    const errorDiv = document.getElementById('priceError') || createPriceErrorDiv();

    // Clear previous error
    errorDiv.textContent = '';
    errorDiv.style.display = 'none';

    const minPrice = minPriceInput?.value ? parseFloat(minPriceInput.value) : null;
    const maxPrice = maxPriceInput?.value ? parseFloat(maxPriceInput.value) : null;

    // Only validate if at least one has a value
    if (minPrice !== null || maxPrice !== null) {
        // Check if values are valid numbers
        if (minPrice !== null && isNaN(minPrice)) {
            showPriceError('Minimum price must be a valid number');
            if (minPriceInput) minPriceInput.focus();
            return false;
        }

        if (maxPrice !== null && isNaN(maxPrice)) {
            showPriceError('Maximum price must be a valid number');
            if (maxPriceInput) maxPriceInput.focus();
            return false;
        }

        // Check for negative values
        if (minPrice !== null && minPrice < 0) {
            showPriceError('Price cannot be negative');
            if (minPriceInput) minPriceInput.focus();
            return false;
        }

        if (maxPrice !== null && maxPrice < 0) {
            showPriceError('Price cannot be negative');
            if (maxPriceInput) maxPriceInput.focus();
            return false;
        }

        // Check if min > max (only if both have values)
        if (minPrice !== null && maxPrice !== null && minPrice > maxPrice) {
            showPriceError('Minimum price cannot be greater than maximum price');
            if (minPriceInput) minPriceInput.focus();
            return false;
        }
    }

    return true;

    function showPriceError(message) {
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        errorDiv.style.color = '#e74c3c';
        errorDiv.style.fontSize = '12px';
        errorDiv.style.marginTop = '5px';
        errorDiv.style.padding = '5px';
        errorDiv.style.backgroundColor = '#ffeaea';
        errorDiv.style.borderRadius = '4px';
    }
}

function createPriceErrorDiv() {
    const div = document.createElement('div');
    div.id = 'priceError';
    const priceGroup = document.querySelector('.price-range');
    if (priceGroup) {
        priceGroup.appendChild(div);
    }
    return div;
}

// Sort Products
function sortProducts(sortValue) {
    console.log('Sorting by:', sortValue);
    isFilterAction = true;

    // Save scroll position
    saveScrollPosition();

    // Update hidden input and submit
    document.getElementById('sortValue').value = sortValue;

    // Submit after tiny delay
    setTimeout(() => {
        document.getElementById('filterForm').submit();
    }, 50);
}

// Clear Filters
function clearFilters() {
    console.log('Clearing filters');
    isFilterAction = true;

    // Save scroll position
    saveScrollPosition();

    // Redirect after tiny delay
    setTimeout(() => {
        window.location.href = '/products';
    }, 50);
}

// Add to Cart functionality
function addToCart(button) {
    const productId = button.dataset.productId;
    fetch('/api/cart/add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            productId: productId,
            quantity: 1
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showNotification('Product added to cart!');
                updateCartCount();

                const cartButton = document.querySelector('.btn-add-cart[data-product-id="' + productId + '"]');
                if (cartButton) {
                    const originalHtml = cartButton.innerHTML;
                    const wasDisabled = cartButton.disabled;
                    cartButton.innerHTML = '<i class="fa-solid fa-check" aria-hidden="true"></i> Added';
                    cartButton.classList.add('is-added');

                    setTimeout(() => {
                        if (!wasDisabled) {
                            cartButton.innerHTML = originalHtml;
                            cartButton.classList.remove('is-added');
                        }
                    }, 2000);
                }
            } else {
                showNotification(data.message || 'Failed to add to cart');
            }
        })
        .catch(error => {
            showNotification('Error adding to cart. Please try again.');
        });
}

// Toggle Wishlist
function toggleWishlist(button) {
    const productId = button.dataset.productId;
    let wishlist = JSON.parse(localStorage.getItem('wishlist')) || {};
    wishlist[productId] = !wishlist[productId];
    localStorage.setItem('wishlist', JSON.stringify(wishlist));

    button.classList.toggle('active');
    if (button.classList.contains('active')) {
        showNotification('Added to wishlist');
    } else {
        showNotification('Removed from wishlist');
    }
}

function initializeWishlist() {
    const wishlist = JSON.parse(localStorage.getItem('wishlist')) || {};
    document.querySelectorAll('.btn-wishlist').forEach(button => {
        const productId = button.dataset.productId;
        if (productId && wishlist[productId]) {
            button.classList.add('active');
        }
    });
}

function removeCategoryFilter(category) {
    const form = document.getElementById('filterForm');
    form.querySelectorAll('input[name="categories"]').forEach(function (cb) {
        if (cb.value === category) {
            cb.checked = false;
        }
    });
    saveScrollPosition();
    form.submit();
}

// Change View (Grid/List)
function changeView(view, btn) {
    const grid = document.getElementById('productsGrid');
    const viewBtns = document.querySelectorAll('.view-btn');

    viewBtns.forEach(function (b) { b.classList.remove('active'); });
    if (btn) {
        btn.classList.add('active');
    }

    if (view === 'list') {
        grid.classList.add('list-view');
    } else {
        grid.classList.remove('list-view');
    }
    localStorage.setItem('productsView', view);
}

function restoreProductsView() {
    const saved = localStorage.getItem('productsView');
    if (saved === 'list') {
        const listBtn = document.getElementById('viewListBtn');
        if (listBtn) {
            changeView('list', listBtn);
        }
    }
}

// Update cart count
function updateCartCount() {
    fetch('/api/cart/count')
        .then(response => response.json())
        .then(data => {
            const cartCount = document.getElementById('cartCount');
            if (cartCount) {
                cartCount.textContent = data.count || 0;
            }
        })
        .catch(error => {
            console.error('Error fetching cart count:', error);
        });
}

// Notification System
function showNotification(message) {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #2fa36f;
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        z-index: 1000;
        transform: translateX(100%);
        transition: transform 0.3s ease;
    `;
    notification.textContent = message;

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);

    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (notification.parentNode) {
                document.body.removeChild(notification);
            }
        }, 300);
    }, 3000);
}

// Filter drawer (UI only: the filter form, its fields and its submit logic are unchanged)
(function () {
    var body = document.body;
    var toggle = document.getElementById('hvFilterToggle');
    var closeBtn = document.getElementById('hvDrawerClose');
    var backdrop = document.getElementById('hvDrawerBackdrop');
    var form = document.getElementById('filterForm');
    var KEY = 'hvFiltersOpen';

    function setOpen(open, remember) {
        body.classList.toggle('hv-filters-open', open);
        if (toggle) toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
        if (remember) { try { open ? sessionStorage.setItem(KEY, '1') : sessionStorage.removeItem(KEY); } catch (e) {} }
    }
    if (toggle) toggle.addEventListener('click', function () { setOpen(true, true); });
    if (closeBtn) closeBtn.addEventListener('click', function () { setOpen(false, true); });
    if (backdrop) backdrop.addEventListener('click', function () { setOpen(false, true); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') setOpen(false, true); });

    // keep the drawer open while ticking several filters (each tick reloads the page)
    try { if (sessionStorage.getItem(KEY) === '1') setOpen(true, false); } catch (e) {}

    // active-filter count badge
    if (form && toggle) {
        var n = form.querySelectorAll('input[name="categories"]:checked').length;
        ['minPrice', 'maxPrice', 'search'].forEach(function (k) { var el = form.elements[k]; if (el && el.value) n++; });
        var r = form.querySelector('input[name="rating"]:checked'); if (r && r.value) n++;
        ['inStock', 'outStock'].forEach(function (k) { var el = form.elements[k]; if (el && el.checked) n++; });
        var badge = document.getElementById('hvFilterCount');
        if (badge && n > 0) { badge.textContent = n; badge.hidden = false; }
    }
})();
