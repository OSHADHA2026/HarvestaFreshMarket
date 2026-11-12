(function () {
    const grid = document.getElementById('wishlistGrid');
    const emptyState = document.getElementById('wishlistEmpty');
    const loading = document.getElementById('wishlistLoading');

    function getWishlistMap() {
        try {
            return JSON.parse(localStorage.getItem('wishlist') || '{}');
        } catch (e) {
            return {};
        }
    }

    function getWishlistIds() {
        const wishlist = getWishlistMap();
        return Object.keys(wishlist).filter(function (id) {
            return wishlist[id] === true || wishlist[id] === 'true';
        });
    }

    function showEmpty() {
        loading.style.display = 'none';
        grid.style.display = 'none';
        emptyState.style.display = 'block';
    }

    function showGrid() {
        loading.style.display = 'none';
        emptyState.style.display = 'none';
        grid.style.display = 'grid';
    }

    function escapeHtml(text) {
        if (text == null) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function renderProductImage(image) {
        if (!image) {
            return '<span><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>';
        }
        if (image.length <= 10 &&
            !image.startsWith('http://') &&
            !image.startsWith('https://') &&
            !image.startsWith('/')) {
            return '<span>' + escapeHtml(image) + '</span>';
        }
        if (!image.startsWith('http://') && !image.startsWith('https://') && !image.startsWith('/')) {
            image = '/' + image;   // relative paths from the database must resolve from the site root
        }
        // The fallback icon is a hidden sibling that the (quote-safe) onerror handler reveals.
        return '<img src="' + escapeHtml(image) + '" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:10px;" ' +
               'onerror="this.onerror=null;this.style.display=\'none\';this.nextElementSibling.style.display=\'flex\';">' +
               '<span style="display:none;align-items:center;justify-content:center;"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>';
    }

    function formatPrice(price) {
        const amount = parseFloat(price);
        return isNaN(amount) ? '0.00' : amount.toFixed(2);
    }

    function renderWishlist(products) {
        grid.innerHTML = '';

        products.forEach(function (product) {
            const weightLabel = [product.weight, product.unit].filter(Boolean).join(' ');
            const subtitle = weightLabel || product.category || '';
            const outOfStock = product.inStock === false || product.stockStatus === 'out';

            const card = document.createElement('div');
            card.className = 'wishlist-item';
            card.dataset.productId = product.id;
            card.innerHTML =
                '<div class="wishlist-image">' + renderProductImage(product.image) + '</div>' +
                '<h3>' + escapeHtml(product.name) + '</h3>' +
                '<p>' + escapeHtml(subtitle) + '</p>' +
                '<div style="color: #2fa36f; font-weight: bold; margin: 10px 0;">$' + formatPrice(product.price) + '</div>' +
                '<div class="action-buttons">' +
                '<button type="button" class="btn-primary btn-wishlist-add" style="width: 100%;" data-product-id="' + product.id + '"' +
                (outOfStock ? ' disabled' : '') + '>' +
                (outOfStock ? 'Out of Stock' : '<i class="fa-solid fa-cart-shopping" aria-hidden="true"></i> Add to Cart') +
                '</button>' +
                '<button type="button" class="btn-danger btn-wishlist-remove" style="width: 100%; margin-top: 5px;" data-product-id="' + product.id + '"><i class="fa-solid fa-circle-xmark" aria-hidden="true"></i> Remove</button>' +
                '</div>';

            grid.appendChild(card);
        });

        grid.querySelectorAll('.btn-wishlist-add').forEach(function (btn) {
            btn.addEventListener('click', function () {
                addWishlistItemToCart(btn.dataset.productId, btn);
            });
        });

        grid.querySelectorAll('.btn-wishlist-remove').forEach(function (btn) {
            btn.addEventListener('click', function () {
                removeFromWishlist(btn.dataset.productId);
            });
        });

        showGrid();
    }

    function loadWishlist() {
        const ids = getWishlistIds();

        if (ids.length === 0) {
            showEmpty();
            return;
        }

        fetch('/api/wishlist/products?ids=' + encodeURIComponent(ids.join(',')))
            .then(function (response) { return response.json(); })
            .then(function (data) {
                if (!data.success) {
                    throw new Error(data.message || 'Failed to load wishlist');
                }
                if (!data.products || data.products.length === 0) {
                    showEmpty();
                    return;
                }
                renderWishlist(data.products);
            })
            .catch(function (error) {
                console.error(error);
                loading.textContent = 'Could not load wishlist. Please try again.';
                loading.style.color = '#e74c3c';
            });
    }

    window.removeFromWishlist = function (productId) {
        if (!confirm('Remove this item from wishlist?')) {
            return;
        }

        const wishlist = getWishlistMap();
        delete wishlist[productId];
        localStorage.setItem('wishlist', JSON.stringify(wishlist));

        const card = grid.querySelector('.wishlist-item[data-product-id="' + productId + '"]');
        if (card) {
            card.remove();
        }

        if (getWishlistIds().length === 0) {
            showEmpty();
        }
    };

    function addWishlistItemToCart(productId, button) {
        fetch('/api/cart/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ productId: productId, quantity: 1 })
        })
            .then(function (response) { return response.json(); })
            .then(function (data) {
                if (data.success) {
                    const originalText = button.textContent;
                    button.innerHTML = 'Added! <i class="fa-solid fa-champagne-glasses" aria-hidden="true"></i>';
                    button.style.background = '#2d9a68';
                    setTimeout(function () {
                        if (!button.disabled) {
                            button.textContent = originalText;
                            button.style.background = '';
                        }
                    }, 2000);
                } else {
                    alert(data.message || 'Failed to add to cart');
                    if (data.message && data.message.toLowerCase().includes('login')) {
                        window.location.href = '/login?redirect=/profile?section=wishlist';
                    }
                }
            })
            .catch(function () {
                alert('Error adding to cart. Please try again.');
            });
    }

    window.initWishlistSection = function () {
        if (window._wishlistSectionLoaded) {
            return;
        }
        window._wishlistSectionLoaded = true;
        loadWishlist();
    };
})();
