<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | Products</title>
    <link rel="stylesheet" href="/css/pages/shop.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="products-header">
    <h1 class="products-title">
        <span class="products-title-emoji" aria-hidden="true"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
        <span>Shop all products</span>
    </h1>
    <p class="products-subtitle">Browse groceries by category, compare prices, and add items to your cart</p>
</div>

<div class="products-container">
    <!-- Filter drawer backdrop -->
    <div class="hv-drawer-backdrop" id="hvDrawerBackdrop" aria-hidden="true"></div>
    <!-- Sidebar Filters (now a slide-in drawer) -->
    <div class="sidebar" id="hvFilterDrawer" role="dialog" aria-label="Product filters">
        <button type="button" class="hv-drawer-close" id="hvDrawerClose" aria-label="Close filters"><i class="fa-solid fa-xmark" aria-hidden="true"></i></button>
        <h2 class="filter-title"><i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i> Filters</h2>

        <form id="filterForm" action="/products" method="get">
            <!-- Search Box -->
            <div class="search-box">
                <input type="text"
                       name="search"
                       class="search-input"
                       placeholder="Search products..."
                       value="${param.search}">
                <button type="submit" class="btn-search" title="Search" aria-label="Search products"><i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i></button>
            </div>

            <!-- Category Filter -->
            <div class="filter-group">
                <h3 class="filter-group-title">Categories</h3>
                <div class="filter-options">
                    <c:forEach var="category" items="${categories}">
                        <div class="filter-option">
                            <input type="checkbox"
                                   id="cat-${fn:replace(fn:toLowerCase(category), ' ', '-')}"
                                   name="categories"
                                   value="${category}"
                                ${selectedCategories.contains(category) ? 'checked' : ''}
                                   onchange="this.form.submit()">
                            <label for="cat-${fn:replace(fn:toLowerCase(category), ' ', '-')}">
                                <c:choose>
                                    <c:when test="${category == 'Fruits'}"> <i class="fa-solid fa-apple-whole" aria-hidden="true"></i> </c:when>
                                    <c:when test="${category == 'Dairy'}"> <i class="fa-solid fa-cheese" aria-hidden="true"></i> </c:when>
                                    <c:when test="${category == 'Meat'}"> <i class="fa-solid fa-drumstick-bite" aria-hidden="true"></i> </c:when>
                                    <c:when test="${category == 'Beverages'}"> <i class="fa-solid fa-bottle-water" aria-hidden="true"></i> </c:when>
                                    <c:when test="${category == 'Snacks'}"> <i class="fa-solid fa-cookie-bite" aria-hidden="true"></i> </c:when>
                                    <c:when test="${category == 'Household'}"> <i class="fa-solid fa-house" aria-hidden="true"></i> </c:when>
                                    <c:when test="${category == 'Bakery'}"> <i class="fa-solid fa-bread-slice" aria-hidden="true"></i> </c:when>
                                    <c:when test="${category == 'Frozen'}"> <i class="fa-solid fa-snowflake" aria-hidden="true"></i> </c:when>
                                    <c:when test="${category == 'Food'}"> <i class="fa-solid fa-bowl-food" aria-hidden="true"></i> </c:when>
                                </c:choose>
                                    ${category}
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Price Range -->
            <div class="filter-group">
                <h3 class="filter-group-title">Price Range</h3>
                <div class="price-range">
                    <div class="price-inputs">
                        <input type="number"
                               class="price-input"
                               placeholder="Min $"
                               name="minPrice"
                               value="${param.minPrice}"
                               onchange="this.form.submit()">
                        <input type="number"
                               class="price-input"
                               placeholder="Max $"
                               name="maxPrice"
                               value="${param.maxPrice}"
                               onchange="this.form.submit()">
                    </div>
                </div>
            </div>

            <!-- Rating Filter -->
            <div class="filter-group">
                <h3 class="filter-group-title">Customer Rating</h3>
                <div class="filter-options rating-options">
                    <div class="filter-option">
                        <input type="radio"
                               id="rating-5"
                               name="rating"
                               value="4.5"
                        ${param.rating == '4.5' ? 'checked' : ''}
                               class="rating-radio"
                               onchange="this.form.submit()">
                        <label for="rating-5">
                            <span class="custom-radio"></span>
                            <span class="rating-label">
                    <span class="rating-stars">★★★★★</span> 4.5 & above
                </span>
                        </label>
                    </div>
                    <div class="filter-option">
                        <input type="radio"
                               id="rating-4"
                               name="rating"
                               value="4.0"
                        ${param.rating == '4.0' ? 'checked' : ''}
                               class="rating-radio"
                               onchange="this.form.submit()">
                        <label for="rating-4">
                            <span class="custom-radio"></span>
                            <span class="rating-label">
                    <span class="rating-stars">★★★★☆</span> 4.0 & above
                </span>
                        </label>
                    </div>
                    <div class="filter-option">
                        <input type="radio"
                               id="rating-3"
                               name="rating"
                               value="3.0"
                        ${param.rating == '3.0' ? 'checked' : ''}
                               class="rating-radio"
                               onchange="this.form.submit()">
                        <label for="rating-3">
                            <span class="custom-radio"></span>
                            <span class="rating-label">
                    <span class="rating-stars">★★★☆☆</span> 3.0 & above
                </span>
                        </label>
                    </div>
                    <div class="filter-option">
                        <input type="radio"
                               id="rating-none"
                               name="rating"
                               value=""
                        ${empty param.rating ? 'checked' : ''}
                               class="rating-radio"
                               onchange="this.form.submit()">
                        <label for="rating-none">
                            <span class="custom-radio"></span>
                            <span class="rating-label">Any Rating</span>
                        </label>
                    </div>
                </div>
            </div>

            <!-- Availability -->
            <div class="filter-group">
                <h3 class="filter-group-title">Availability</h3>
                <div class="filter-options">
                    <div class="filter-option">
                        <input type="checkbox"
                               id="stock-in"
                               name="inStock"
                               value="true"
                        ${param.inStock == 'true' ? 'checked' : ''}
                               onchange="this.form.submit()">
                        <label for="stock-in">In Stock</label>
                    </div>
                    <div class="filter-option">
                        <input type="checkbox"
                               id="stock-out"
                               name="outStock"
                               value="true"
                        ${param.outStock == 'true' ? 'checked' : ''}
                               onchange="this.form.submit()">
                        <label for="stock-out">Out of Stock</label>
                    </div>
                </div>
            </div>
            <!-- Add this hidden input for scroll position -->
            <input type="hidden" name="scrollY" id="scrollYInput" value="${scrollY}">
            <input type="hidden" name="sort" id="sortValue" value="${param.sort}">
        </form>

        <button type="button" class="btn-apply" onclick="clearFilters()">Clear Filters</button>
    </div>

    <!-- Products Content -->
    <div class="products-content">
        <div class="products-toolbar">
            <button type="button" class="hv-filter-toggle" id="hvFilterToggle" aria-controls="hvFilterDrawer"><i class="fa-solid fa-sliders" aria-hidden="true"></i> Filters <span class="hv-fcount" id="hvFilterCount" hidden>0</span></button>
            <div class="results-count" id="resultsCount">
                ${productCount} product<c:if test="${productCount != 1}">s</c:if>
                <c:if test="${not empty param.search}">
                    <span> · matching &quot;<c:out value="${param.search}"/>&quot;</span>
                </c:if>
            </div>
            <div class="sort-options">
                <label for="sort">Sort by:</label>
                <select class="sort-select" id="sort" onchange="sortProducts(this.value)">
                    <option value="featured" ${param.sort == 'featured' ? 'selected' : ''}>Featured</option>
                    <option value="price-low" ${param.sort == 'price-low' ? 'selected' : ''}>Price: Low to High</option>
                    <option value="price-high" ${param.sort == 'price-high' ? 'selected' : ''}>Price: High to Low</option>
                    <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>Customer Rating</option>
                    <option value="name" ${param.sort == 'name' ? 'selected' : ''}>Name A-Z</option>
                </select>
            </div>
            <div class="view-options">
                <button type="button" class="view-btn active" id="viewGridBtn" onclick="changeView('grid', this)">Grid</button>
                <button type="button" class="view-btn" id="viewListBtn" onclick="changeView('list', this)">List</button>
            </div>
        </div>

        <c:if test="${not empty categories}">
            <div class="category-chips">
                <a href="/products?sort=${empty param.sort ? 'featured' : param.sort}" class="category-chip ${empty selectedCategories ? 'active' : ''}">All</a>
                <c:forEach var="category" items="${categories}">
                    <c:url var="catUrl" value="/products">
                        <c:param name="categories" value="${category}"/>
                        <c:if test="${not empty param.sort}"><c:param name="sort" value="${param.sort}"/></c:if>
                        <c:if test="${not empty param.search}"><c:param name="search" value="${param.search}"/></c:if>
                    </c:url>
                    <a href="${catUrl}" class="category-chip ${selectedCategories.contains(category) ? 'active' : ''}">
                        <c:out value="${category}"/>
                    </a>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${not empty selectedCategories || not empty param.search || not empty param.minPrice || not empty param.maxPrice || not empty param.rating || param.inStock == 'true' || param.outStock == 'true'}">
            <div class="active-filters">
                <c:forEach var="cat" items="${selectedCategories}">
                    <span class="filter-tag">
                        <c:out value="${cat}"/>
                        <button type="button" class="filter-tag-remove" data-category="<c:out value='${cat}'/>" title="Remove filter">×</button>
                    </span>
                </c:forEach>
                <c:if test="${not empty param.search}">
                    <span class="filter-tag">Search: <c:out value="${param.search}"/></span>
                </c:if>
                <c:if test="${not empty param.minPrice || not empty param.maxPrice}">
                    <span class="filter-tag">Price: ${empty param.minPrice ? '0' : param.minPrice} – ${empty param.maxPrice ? '∞' : param.maxPrice}</span>
                </c:if>
                <c:if test="${param.inStock == 'true'}"><span class="filter-tag">In stock</span></c:if>
                <c:if test="${param.outStock == 'true'}"><span class="filter-tag">Out of stock</span></c:if>
            </div>
        </c:if>

        <div class="products-grid" id="productsGrid">
            <c:choose>
                <c:when test="${not empty products}">
                    <c:forEach var="product" items="${products}">
                        <article class="product-card"
                             data-category="${fn:toLowerCase(product.category)}"
                             data-price="${product.price}"
                             data-rating="${product.rating}"
                             data-stock="${product.stockStatus}">

                            <div class="product-badges">
                                <c:if test="${product.dealActive}">
                                    <span class="product-badge deal">Deal</span>
                                </c:if>
                                <c:if test="${product.isFeatured}">
                                    <span class="product-badge featured">Featured</span>
                                </c:if>
                            </div>

                            <div class="product-image-link">
                                <div class="product-image-container">
                                    <c:choose>
                                        <c:when test="${not empty product.image && (fn:startsWith(product.image, 'http://') || fn:startsWith(product.image, 'https://') || fn:startsWith(product.image, '/'))}">
                                            <img src="<c:out value='${product.image}' />"
                                                 alt="<c:out value='${product.name}' />"
                                                 loading="lazy"
                                                 onerror="handleImageError(this);">
                                        </c:when>
                                        <c:when test="${not empty product.image && fn:length(product.image) <= 10}">
                                            <span class="emoji-fallback"><c:out value="${product.image}" /></span>
                                        </c:when>
                                        <c:when test="${not empty product.image}">
                                            <img src="<c:out value='${product.image}' />"
                                                 alt="<c:out value='${product.name}' />"
                                                 loading="lazy"
                                                 onerror="handleImageError(this);">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="emoji-fallback"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i></span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="product-content">
                                <div class="product-category-row">
                                    <span class="product-category"><c:out value="${product.category}"/></span>
                                    <c:if test="${not empty product.brand}">
                                        <span class="product-brand"><c:out value="${product.brand}"/></span>
                                    </c:if>
                                </div>
                                <span class="product-title-link"><c:out value="${product.name}"/></span>
                                <c:if test="${not empty product.description}">
                                    <p class="product-description"><c:out value="${product.description}"/></p>
                                </c:if>

                                <div class="product-rating">
                                    <span class="stars">
                                        <c:forEach begin="1" end="5" var="star">
                                            <c:choose>
                                                <c:when test="${product.rating != null and star <= product.rating}">★</c:when>
                                                <c:otherwise>☆</c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </span>
                                    <span class="rating-count">
                                        <fmt:formatNumber value="${product.rating != null ? product.rating : 0}" pattern="#.#"/>
                                        <c:if test="${product.reviewCount != null && product.reviewCount > 0}">
                                            · ${product.reviewCount} reviews
                                        </c:if>
                                    </span>
                                </div>

                                <div class="product-price">
                                    <span class="current-price">
                                        $<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </span>
                                    <c:if test="${product.originalPrice != null && product.originalPrice > product.price}">
                                        <span class="original-price">
                                            $<fmt:formatNumber value="${product.originalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                        <c:if test="${product.discountPercentage != null && product.discountPercentage > 0}">
                                            <span class="discount">${product.discountPercentage}% OFF</span>
                                        </c:if>
                                    </c:if>
                                </div>

                                <div class="product-meta">
                                    <span class="stock-status
                                        ${product.stockStatus == 'in' ? 'in-stock' : ''}
                                        ${product.stockStatus == 'low' ? 'low-stock' : ''}
                                        ${product.stockStatus == 'out' ? 'out-of-stock' : ''}">
                                        <c:choose>
                                            <c:when test="${product.stockStatus == 'in'}">In stock</c:when>
                                            <c:when test="${product.stockStatus == 'low'}">Only ${product.stock} left</c:when>
                                            <c:otherwise>Out of stock</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <c:if test="${not empty product.weight || not empty product.unit}">
                                        <span><c:out value="${product.weight}"/> <c:out value="${product.unit}"/></span>
                                    </c:if>
                                </div>

                                <div class="product-actions">
                                    <button type="button" class="btn-add-cart"
                                            data-product-id="${product.id}"
                                            onclick="event.stopPropagation(); addToCart(this);"
                                            title="Add to cart" aria-label="Add to cart"
                                        <c:if test="${product.stockStatus == 'out'}">disabled</c:if>>
                                        <c:choose>
                                            <c:when test="${product.stockStatus == 'out'}"><i class="fa-solid fa-ban" aria-hidden="true"></i> Out of stock</c:when>
                                            <c:otherwise><i class="fa-solid fa-cart-plus" aria-hidden="true"></i> Add to cart</c:otherwise>
                                        </c:choose>
                                    </button>
                                    <button type="button" class="btn-wishlist"
                                            data-product-id="${product.id}"
                                            onclick="event.stopPropagation(); toggleWishlist(this);"
                                            title="Add to wishlist" aria-label="Add to wishlist">
                                        <i class="fa-regular fa-heart" aria-hidden="true"></i>
                                    </button>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-products">
                        <div class="icon"><i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i></div>
                        <h3>No products found</h3>
                        <p style="color:#7f8c8d; margin: 10px 0 20px;">Try a different search, category, or clear your filters.</p>
                        <button type="button" class="btn-apply" onclick="clearFilters()" style="display: inline-block; width: auto; padding: 12px 28px;">
                            Clear all filters
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pagination -->
        <div class="pagination" id="pagination">
            <!-- Pagination will be added dynamically if needed -->
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script src="/js/pages/shop.js"></script>

</body>
</html>
