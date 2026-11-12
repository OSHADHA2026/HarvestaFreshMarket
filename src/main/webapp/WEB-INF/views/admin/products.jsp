<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${pageTitle != null ? pageTitle : 'Product Management'}</title>
    <link rel="stylesheet" href="/css/pages/admin/products.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<div class="container">
    <div class="header-actions">
        <h1>Product Management</h1>
        <a class="btn btn-success" href="/admin/products/new">+ Add New Product</a>
    </div>
    
    <div class="card">
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${products != null && !products.isEmpty()}">
                <table class="products-table">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Rating</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${products}">
                            <c:if test="${product != null}">
                            <tr>
                                <td>
                                    <img src="<c:out value='${product.image != null ? product.image : "/images/placeholder.png"}' />" 
                                         alt="<c:out value='${product.name != null ? product.name : "Product"}' />" 
                                         class="product-image" 
                                         onerror="if(this.src !== '/images/placeholder.png') { this.src='/images/placeholder.png'; }"
                                         loading="lazy">
                                </td>
                                <td>
                                    <strong><c:out value="${product.name != null ? product.name : 'N/A'}" /></strong>
                                    <c:if test="${product.isFeatured != null && product.isFeatured}">
                                        <span class="badge badge-featured">Featured</span>
                                    </c:if>
                                    <c:if test="${product.isDeal != null && product.isDeal}">
                                        <span class="badge badge-deal">Deal</span>
                                    </c:if>
                                </td>
                                <td><c:out value="${product.category != null ? product.category : 'N/A'}" /></td>
                                <td>
                                    <c:if test="${product.price != null}">
                                        <strong>$${product.price}</strong>
                                        <c:if test="${product.originalPrice != null && product.originalPrice.compareTo(product.price) > 0}">
                                            <br><small style="text-decoration: line-through; color: #7f8c8d;">$${product.originalPrice}</small>
                                        </c:if>
                                    </c:if>
                                    <c:if test="${product.price == null}">N/A</c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${product.stock == null || product.stock <= 0}">
                                            <span class="stock-badge stock-out">Out of Stock</span>
                                        </c:when>
                                        <c:when test="${product.minStock != null && product.stock <= product.minStock}">
                                            <span class="stock-badge stock-low">Low (${product.stock})</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-badge stock-in">In Stock (${product.stock})</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${product.rating != null ? product.rating : 'N/A'}" /></td>
                                <td>
                                    <c:if test="${product.isFeatured != null && product.isFeatured}">Featured</c:if>
                                    <c:if test="${product.isDeal != null && product.isDeal}">Deal</c:if>
                                    <c:if test="${(product.isFeatured == null || !product.isFeatured) && (product.isDeal == null || !product.isDeal)}">-</c:if>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <c:if test="${product.id != null}">
                                            <a href="/admin/products/${product.id}" class="btn btn-info">View</a>
                                            <a href="/admin/products/${product.id}/edit" class="btn btn-warning">Edit</a>
                                            <form action="/admin/products/${product.id}/delete" method="post" class="delete-form">
                                                <button type="submit" class="btn btn-danger"
                                                        onclick="return confirm('Are you sure you want to delete this product?');">
                                                    Delete
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <p>No products found. <a href="/admin/products/new">Add your first product</a></p>
                </div>
            </c:otherwise>
        </c:choose>
        
        <div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:20px;">
            <a class="btn back" href="/admin">Back to Admin Console</a>
        </div>
    </div>
</div>
</body>
</html>
