<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Product</title>
    <link rel="stylesheet" href="/css/pages/admin/add-product.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<div class="container">
    <h1>Add New Product</h1>
    
    <div class="card">
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <form action="/admin/products" method="post" id="productForm">
            <div class="form-row">
                <div class="form-group">
                    <label for="name">Product Name <span class="required">*</span></label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="category">Category <span class="required">*</span></label>
                    <input type="text" id="category" name="category" required placeholder="e.g., Groceries, Electronics">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="subCategory">Sub Category</label>
                    <input type="text" id="subCategory" name="subCategory" placeholder="e.g., Fruits, Vegetables">
                </div>
                <div class="form-group">
                    <label for="brand">Brand</label>
                    <input type="text" id="brand" name="brand" placeholder="e.g., Brand Name">
                </div>
            </div>
            
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" placeholder="Product description..."></textarea>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="price">Price <span class="required">*</span></label>
                    <input type="number" id="price" name="price" step="0.01" min="0" required>
                </div>
                <div class="form-group">
                    <label for="originalPrice">Original Price</label>
                    <input type="number" id="originalPrice" name="originalPrice" step="0.01" min="0">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="discountPercentage">Discount Percentage</label>
                    <input type="number" id="discountPercentage" name="discountPercentage" min="0" max="100" placeholder="0-100">
                </div>
                <div class="form-group">
                    <label for="stock">Stock Quantity <span class="required">*</span></label>
                    <input type="number" id="stock" name="stock" min="0" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="minStock">Minimum Stock</label>
                    <input type="number" id="minStock" name="minStock" min="0" value="10">
                </div>
                <div class="form-group">
                    <label for="rating">Rating</label>
                    <input type="number" id="rating" name="rating" step="0.1" min="0" max="5" value="4.0">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="weight">Weight</label>
                    <input type="text" id="weight" name="weight" placeholder="e.g., 500g, 1kg">
                </div>
                <div class="form-group">
                    <label for="unit">Unit</label>
                    <input type="text" id="unit" name="unit" placeholder="e.g., kg, g, ml, l">
                </div>
            </div>
            
            <div class="form-group">
                <label for="image">Image URL <span class="required">*</span></label>
                <input type="text" id="image" name="image" required placeholder="/images/product.jpg">
            </div>
            
            <div class="form-row">
                <div class="form-group checkbox-group">
                    <input type="checkbox" id="isFeatured" name="isFeatured" value="true">
                    <label for="isFeatured">Featured Product</label>
                </div>
                <div class="form-group checkbox-group">
                    <input type="checkbox" id="isDeal" name="isDeal" value="true">
                    <label for="isDeal">Deal Product</label>
                </div>
            </div>
            
            <div id="dealExpiryGroup" style="display: none;">
                <div class="form-row">
                    <div class="form-group">
                        <label for="dealExpiryDate">Deal Expiry Date</label>
                        <input type="date" id="dealExpiryDate" name="dealExpiryDate">
                    </div>
                    <div class="form-group">
                        <label for="dealExpiryTime">Deal Expiry Time</label>
                        <input type="time" id="dealExpiryTime" name="dealExpiryTime" step="60">
                    </div>
                </div>
                <p class="muted" style="margin: 0 0 16px; color: #7f8c8d; font-size: 13px;">
                    Use separate date and time fields so you can type values like day 26 without the browser changing them.
                </p>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-success">Add Product</button>
                <a href="/admin/products" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script src="/js/pages/admin/add-product.js"></script>
</body>
</html>

