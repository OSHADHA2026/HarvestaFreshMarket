<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.supermarket.model.User" %>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<%
    User user = (User) session.getAttribute("user");
%>

<header class="hv-header">
    <div class="hv-topbar">
        <div class="hv-topbar-in">
            <span><i class="fa-solid fa-truck-fast"></i> Free delivery on orders above $50</span>
            <span><i class="fa-regular fa-clock"></i> Open Mon&ndash;Sat 8am&ndash;10pm &middot; Sun 9am&ndash;8pm</span>
            <span><i class="fa-solid fa-phone"></i> <a href="tel:18004278378">1-800-HARVEST</a></span>
        </div>
    </div>

    <div class="hv-nav">
        <div class="hv-nav-shell">
            <a href="/" class="hv-brand" aria-label="Harvesta Fresh Market home">
                <img src="/images/brand/harvesta-mark.svg" alt="" width="42" height="42">
                <span class="hv-brand-text"><b>Harvesta</b><small>Fresh Market</small></span>
            </a>

            <button type="button" class="hv-burger" id="hvBurger" aria-label="Toggle menu" aria-expanded="false" aria-controls="hvPanel">
                <i class="fa-solid fa-bars"></i>
            </button>

            <div class="hv-panel" id="hvPanel">
                <ul class="hv-links" data-context-path="<%= HtmlUtils.htmlEscape(request.getContextPath()) %>">
                    <li><a href="/" data-nav-path="/"><i class="fa-solid fa-house"></i> Home</a></li>
                    <li><a href="/products" data-nav-path="/products"><i class="fa-solid fa-basket-shopping"></i> Shop</a></li>
                    <li><a href="/deals" class="hv-hot" data-nav-path="/deals"><i class="fa-solid fa-fire-flame-curved"></i> Deals</a></li>
                    <li><a href="/aboutus" data-nav-path="/aboutus"><i class="fa-solid fa-leaf"></i> About</a></li>
                    <li><a href="/contactus" data-nav-path="/contactus"><i class="fa-regular fa-envelope"></i> Contact</a></li>
                </ul>

                <form class="hv-search" action="/products" method="get" role="search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <label class="hv-sr" for="hvSearchInput">Search products</label>
                    <input id="hvSearchInput" type="search" name="search" placeholder="Search fruits, dairy, bakery&hellip;" autocomplete="off" required>
                </form>

                <div class="hv-actions">
                    <div class="hv-currency" id="hvCurrency">
                        <button type="button" class="hv-currency-trigger" id="hvCurrencyTrigger"
                                aria-haspopup="menu" aria-expanded="false" aria-label="Select currency">
                            <img src="/images/flags/us.svg" alt="" data-current-flag aria-hidden="true">
                            <span data-current-code>USD</span>
                            <i class="fa-solid fa-chevron-down" aria-hidden="true"></i>
                        </button>
                        <div class="hv-currency-menu" id="hvCurrencyMenu" role="menu" aria-label="Select currency" hidden>
                            <button type="button" role="menuitemradio" data-cur="USD" aria-checked="true">
                                <img src="/images/flags/us.svg" alt="" aria-hidden="true">
                                <span>USD</span><small>US Dollar</small>
                            </button>
                            <button type="button" role="menuitemradio" data-cur="LKR" aria-checked="false">
                                <img src="/images/flags/lk.svg" alt="" aria-hidden="true">
                                <span>LKR</span><small>Sri Lankan Rupee</small>
                            </button>
                        </div>
                    </div>
                    <button type="button" class="hv-iconbtn hv-theme-toggle" id="hvThemeToggle" title="Switch theme" aria-label="Switch to dark mode" aria-pressed="false">
                        <i class="fa-solid fa-moon hv-ico-moon" aria-hidden="true"></i>
                        <i class="fa-solid fa-sun hv-ico-sun" aria-hidden="true"></i>
                    </button>
                    <% if (user != null) { %>
                    <span class="hv-hello">Hi, <b><%= HtmlUtils.htmlEscape(user.getFirstName() == null ? "" : user.getFirstName()) %></b></span>
                    <a href="/cart" class="hv-iconbtn" title="Cart" aria-label="Cart">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <span class="hv-badge cart-count" id="cartCount">0</span>
                    </a>
                    <a href="/profile" class="hv-iconbtn" title="My account" aria-label="My account"><i class="fa-regular fa-user"></i></a>
                    <a href="#" class="hv-iconbtn is-danger" title="Log out" aria-label="Log out" onclick="confirmLogout(); return false;"><i class="fa-solid fa-arrow-right-from-bracket"></i></a>
                    <% } else { %>
                    <a href="/login" class="hv-btn hv-btn-ghost"><i class="fa-regular fa-user"></i> Log in</a>
                    <a href="/register" class="hv-btn hv-btn-primary">Sign up</a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- Logout confirmation -->
<div id="logoutModal" class="hv-modal" role="dialog" aria-modal="true" aria-labelledby="hvLogoutTitle">
    <div class="hv-modal-card">
        <div class="hv-modal-icon"><i class="fa-solid fa-arrow-right-from-bracket"></i></div>
        <h3 id="hvLogoutTitle">Leaving so soon?</h3>
        <p>You&rsquo;re about to log out of Harvesta. Your cart will be waiting when you&rsquo;re back.</p>
        <div class="hv-modal-actions">
            <button type="button" class="hv-btn hv-btn-ghost" onclick="closeLogoutModal()">Stay</button>
            <a href="/logout" class="hv-btn hv-btn-danger">Log out</a>
        </div>
    </div>
</div>

<script src="/js/components/header.js"></script>
<script src="/js/components/currency.js"></script>
