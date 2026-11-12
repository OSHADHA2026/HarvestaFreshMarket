<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Details</title>
    <link rel="stylesheet" href="/css/pages/admin/view-product.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<div class="container">
    <h1>Product Details</h1>
    
    <div class="card">
        <div class="product-details">
            <div class="product-image-section">
                <img src="${product.image}" alt="${product.name}" class="product-image" 
                     onerror="this.src='/images/placeholder.png'">
            </div>
            
            <div class="product-info">
                <h2>
                    ${product.name}
                    <c:if test="${product.isFeatured}">
                        <span class="badge badge-featured">Featured</span>
                    </c:if>
                    <c:if test="${product.isDeal}">
                        <span class="badge badge-deal">Deal</span>
                    </c:if>
                </h2>
                
                <div class="price-section">
                    $${product.price}
                    <c:if test="${product.originalPrice != null && product.originalPrice.compareTo(product.price) > 0}">
                        <span class="original-price">$${product.originalPrice}</span>
                    </c:if>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Description:</span>
                    <span class="info-value">${product.description != null ? product.description : 'N/A'}</span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Category:</span>
                    <span class="info-value">${product.category}</span>
                </div>
                
                <c:if test="${product.subCategory != null && !product.subCategory.isEmpty()}">
                <div class="info-row">
                    <span class="info-label">Sub Category:</span>
                    <span class="info-value">${product.subCategory}</span>
                </div>
                </c:if>
                
                <c:if test="${product.brand != null && !product.brand.isEmpty()}">
                <div class="info-row">
                    <span class="info-label">Brand:</span>
                    <span class="info-value">${product.brand}</span>
                </div>
                </c:if>
                
                <div class="info-row">
                    <span class="info-label">Stock:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${product.stock == null || product.stock <= 0}">
                                <span class="stock-badge stock-out">Out of Stock (${product.stock != null ? product.stock : 0})</span>
                            </c:when>
                            <c:when test="${product.stock <= product.minStock}">
                                <span class="stock-badge stock-low">Low Stock (${product.stock})</span>
                            </c:when>
                            <c:otherwise>
                                <span class="stock-badge stock-in">In Stock (${product.stock})</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Minimum Stock:</span>
                    <span class="info-value">${product.minStock != null ? product.minStock : 10}</span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Rating:</span>
                    <span class="info-value">${product.rating != null ? product.rating : 'N/A'}</span>
                </div>
                
                <c:if test="${product.reviewCount != null}">
                <div class="info-row">
                    <span class="info-label">Review Count:</span>
                    <span class="info-value">${product.reviewCount}</span>
                </div>
                </c:if>
                
                <c:if test="${product.soldCount != null}">
                <div class="info-row">
                    <span class="info-label">Sold Count:</span>
                    <span class="info-value">${product.soldCount}</span>
                </div>
                </c:if>
                
                <c:if test="${product.weight != null && !product.weight.isEmpty()}">
                <div class="info-row">
                    <span class="info-label">Weight:</span>
                    <span class="info-value">${product.weight}</span>
                </div>
                </c:if>
                
                <c:if test="${product.unit != null && !product.unit.isEmpty()}">
                <div class="info-row">
                    <span class="info-label">Unit:</span>
                    <span class="info-value">${product.unit}</span>
                </div>
                </c:if>
                
                <c:if test="${product.discountPercentage != null && product.discountPercentage > 0}">
                <div class="info-row">
                    <span class="info-label">Discount:</span>
                    <span class="info-value">${product.discountPercentage}%</span>
                </div>
                </c:if>
                
                <c:if test="${product.dealExpiry != null}">
                <div class="info-row">
                    <span class="info-label">Deal Expiry:</span>
                    <span class="info-value">${product.dealExpiry}</span>
                </div>
                </c:if>
                
                <div class="info-row">
                    <span class="info-label">Created At:</span>
                    <span class="info-value">${product.createdAt != null ? product.createdAt : 'N/A'}</span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Updated At:</span>
                    <span class="info-value">${product.updatedAt != null ? product.updatedAt : 'N/A'}</span>
                </div>
                
                <div class="btn-group">
                    <a href="/admin/products/${product.id}/edit" class="btn btn-warning">Edit Product</a>
                    <a href="/admin/products" class="btn btn-secondary">Back to Products</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

