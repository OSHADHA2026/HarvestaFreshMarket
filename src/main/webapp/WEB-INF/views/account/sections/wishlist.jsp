<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="section-header">
    <h1 class="section-title">My Wishlist</h1>
    <a href="/products" class="btn-primary"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i> Continue Shopping</a>
</div>

<div id="wishlistLoading" style="text-align: center; padding: 40px; color: #7f8c8d;">
    Loading your wishlist...
</div>

<div class="wishlist-grid" id="wishlistGrid" style="display: none;"></div>

<div class="empty-state" id="wishlistEmpty" style="display: none; grid-column: 1 / -1;">
    <div class="icon"><i class="fa-solid fa-heart" aria-hidden="true"></i></div>
    <h3>Your Wishlist is Empty</h3>
    <p>Save your favorite items from the products page by clicking the heart icon.</p>
    <a href="/products" class="btn-primary"><i class="fa-solid fa-cart-shopping" aria-hidden="true"></i> Start Shopping</a>
</div>

<script src="/js/pages/profile-wishlist.js"></script>
