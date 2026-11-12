<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="/css/pages/admin/users.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
<div class="container">
    <div class="header">
        <div>
            <h1>User Account Management</h1>
            <div class="muted">View, filter, and remove user accounts</div>
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
        <h3 style="margin-top:0;">Users</h3>
        <c:if test="${empty users}">
            <div class="empty">No users found.</div>
        </c:if>
        <c:if test="${not empty users}">
            <table>
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Created</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td>${u.firstName} ${u.lastName}</td>
                        <td>${u.email}</td>
                        <td>${u.username}</td>
                        <td><span class="badge">${u.role}</span></td>
                        <td>${u.createdAt}</td>
                        <td>
                            <div class="actions">
                                <form method="post" action="/admin/users/${u.id}/delete">
                                    <button class="btn danger" type="submit" onclick="return confirm('Delete user ${u.email}?')">Delete</button>
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
