<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="/css/pages/admin/admin-accounts.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<div class="container">
    <div class="header">
        <div>
            <h1>Admin Account Management</h1>
            <div class="muted">Create, view, and remove admin accounts</div>
        </div>
        <a class="btn back" href="/admin">← Back to Admin Console</a>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success"><i class="fa-solid fa-circle-check" aria-hidden="true"></i> ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error"><i class="fa-solid fa-circle-xmark" aria-hidden="true"></i> ${error}</div>
    </c:if>

    <div class="card">
        <h3>Create or promote admin</h3>
        <p class="muted">Provide an email and password. If the email exists, it will be promoted to ADMIN; otherwise a new admin is created.</p>
        <form method="post" action="/admin/admin-accounts/create">
            <div class="form-grid">
                <input class="input" type="email" name="email" placeholder="admin@example.com" required>
                <input class="input" type="text" name="password" placeholder="Password" required>
            </div>
            <div style="margin-top:12px; display:flex; gap:10px; flex-wrap:wrap;">
                <button class="btn success" type="submit">Create / Promote</button>
            </div>
        </form>
    </div>

    <div class="card" style="margin-top:16px;">
        <h3 style="margin-top:0;">Existing admins</h3>
        <c:if test="${empty admins}">
            <div class="empty">No admin accounts found.</div>
        </c:if>
        <c:if test="${not empty admins}">
            <table>
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Created</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="a" items="${admins}">
                    <tr>
                        <td>${a.firstName} ${a.lastName}</td>
                        <td>${a.email}</td>
                        <td>${a.createdAt}</td>
                        <td><span class="badge">${a.role}</span></td>
                        <td>
                            <div class="actions">
                                <form method="post" action="/admin/admin-accounts/${a.id}/delete">
                                    <button class="btn danger" type="submit" onclick="return confirm('Remove admin ${a.email}?')">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
</div>
</body>
</html>

