<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="/css/pages/admin/dashboard.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<div class="container">
    <div class="header">
        <div>
            <div class="title">Admin Console</div>
            <div class="meta">Manage admins, users, and products from one place</div>
        </div>
        <a class="btn secondary" href="/">← Back to site</a>
    </div>

    <div class="cards">
        <div class="card">
            <h3>Admin Account Management</h3>
            <p>Create or manage admin accounts, reset passwords, and update roles.</p>
            <div class="actions">
                <a class="btn primary" href="/admin/admin-accounts">Open admin accounts</a>
            </div>
            <div class="meta">Access: Admin only</div>
        </div>

        <div class="card">
            <h3>User Account Management</h3>
            <p>View user list, lock or unlock accounts, and review recent activity.</p>
            <div class="actions">
                <a class="btn tertiary" href="/admin/users">Manage users</a>
            </div>
            <div class="meta">Access: Admin only</div>
        </div>

        <div class="card">
            <h3>Product Management</h3>
            <p>Add new products, edit details, update stock, and delete products.</p>
            <div class="actions">
                <a class="btn primary" href="/admin/products">Go to products</a>
            </div>
            <div class="meta">Access: Admin only</div>
        </div>
    </div>
</div>
</body>
</html>

