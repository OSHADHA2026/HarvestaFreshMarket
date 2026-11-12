<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.supermarket.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("/login");
        return;
    }

    String section = request.getParameter("section");
    if (section == null) section = "profile";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Harvesta | My Account</title>
    <link rel="stylesheet" href="/css/pages/profile.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="profile-container">
    <!-- Sidebar Navigation -->
    <div class="profile-sidebar">
        <div class="profile-picture">
            <%= user.getFirstName().charAt(0) %><%= user.getLastName().charAt(0) %>
        </div>
        <h2 class="profile-name"><%= user.getFirstName() %> <%= user.getLastName() %></h2>
        <p class="profile-email"><%= user.getEmail() %></p>
        <p class="member-since">Member since <%= user.getCreatedAt().getMonth().toString() %> <%= user.getCreatedAt().getYear() %></p>

        <ul class="sidebar-menu">
            <li><a href="/profile?section=profile" data-section="profile" class="<%= section.equals("profile") ? "active" : "" %>" onclick="return switchProfileSection('profile', event)">
                <span class="icon"><i class="fa-solid fa-user" aria-hidden="true"></i></span>Profile Information
            </a></li>
            <li><a href="/profile?section=orders" data-section="orders" class="<%= section.equals("orders") ? "active" : "" %>" onclick="return switchProfileSection('orders', event)">
                <span class="icon"><i class="fa-solid fa-box" aria-hidden="true"></i></span>My Orders
            </a></li>
            <li><a href="/profile?section=wishlist" data-section="wishlist" class="<%= section.equals("wishlist") ? "active" : "" %>" onclick="return switchProfileSection('wishlist', event)">
                <span class="icon"><i class="fa-solid fa-heart" aria-hidden="true"></i></span>Wishlist
            </a></li>
            <li><a href="/profile?section=payments" data-section="payments" class="<%= section.equals("payments") ? "active" : "" %>" onclick="return switchProfileSection('payments', event)">
                <span class="icon"><i class="fa-solid fa-credit-card" aria-hidden="true"></i></span>Payment Methods
            </a></li>
            <li><a href="/profile?section=addresses" data-section="addresses" class="<%= section.equals("addresses") ? "active" : "" %>" onclick="return switchProfileSection('addresses', event)">
                <span class="icon"><i class="fa-solid fa-house" aria-hidden="true"></i></span>Address Book
            </a></li>
            <li><a href="/profile?section=settings" data-section="settings" class="<%= section.equals("settings") ? "active" : "" %>" onclick="return switchProfileSection('settings', event)">
                <span class="icon"><i class="fa-solid fa-gear" aria-hidden="true"></i></span>Account Settings
            </a></li>
        </ul>
    </div>

    <!-- Main Content Sections (all loaded once; switched without page reload) -->
    <div class="profile-main">
        <div class="profile-section <%= section.equals("profile") ? "is-active" : "" %>" data-section="profile">
            <jsp:include page="/WEB-INF/views/account/sections/profile-info.jsp" />
        </div>
        <div class="profile-section <%= section.equals("orders") ? "is-active" : "" %>" data-section="orders">
            <jsp:include page="/WEB-INF/views/account/sections/orders.jsp" />
        </div>
        <div class="profile-section <%= section.equals("wishlist") ? "is-active" : "" %>" data-section="wishlist">
            <jsp:include page="/WEB-INF/views/account/sections/wishlist.jsp" />
        </div>
        <div class="profile-section <%= section.equals("payments") ? "is-active" : "" %>" data-section="payments">
            <jsp:include page="/WEB-INF/views/account/sections/payments.jsp" />
        </div>
        <div class="profile-section <%= section.equals("addresses") ? "is-active" : "" %>" data-section="addresses">
            <jsp:include page="/WEB-INF/views/account/sections/addresses.jsp" />
        </div>
        <div class="profile-section <%= section.equals("settings") ? "is-active" : "" %>" data-section="settings">
            <jsp:include page="/WEB-INF/views/account/sections/settings.jsp" />
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script src="/js/pages/profile.js"></script>
</body>
</html>
