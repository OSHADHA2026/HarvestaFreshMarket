# Harvesta Fresh Market

Online supermarket built with Spring Boot, JPA and JSP/JSTL.

## Run

```bash
./mvnw spring-boot:run          # or: mvn clean package && java -jar target/*.jar
```

Database settings live in `src/main/resources/application.properties`.
After changing anything under `src/main/resources/static`, restart (or run `mvn clean package`)
and hard-refresh the browser (Ctrl+F5) so the new CSS/JS is served.

## Project layout

```
src/main
├── java/com/example/supermarket
│   ├── config/            WebConfig (MVC) and a one-off DB schema migration
│   ├── controller/        Web layer: one controller per feature, returns view names
│   ├── service/           Business logic
│   ├── repository/        Spring Data JPA repositories
│   ├── model/             JPA entities
│   └── util/              DealExpiryUtil
├── resources
│   ├── application.properties
│   └── static/                         ← served as-is at "/"
│       ├── css/
│       │   ├── base/theme.css          design tokens (colours, radii, fonts) + global polish
│       │   ├── base/dark.css           dark theme (token values only)
│       │   ├── components/             header.css, footer.css, buttons.css (shared UI pieces)
│       │   └── pages/                  one stylesheet per page (admin/ for admin pages)
│       ├── js/
│       │   ├── components/             header.js (cart badge, toast, logout modal), footer.js
│       │   └── pages/                  one script per page that needs one
│       └── images/
│           ├── brand/                  logo, mark, favicon
│           ├── auth/                   login / register backgrounds
│           ├── flags/                  currency dropdown country flags
│           └── placeholder.png         default product image
└── webapp/WEB-INF/views                ← JSP views, grouped by feature
    ├── partials/                       navbar.jsp, footer.jsp, head-assets.jsp (included, never routed)
    ├── home/        index.jsp
    ├── shop/        products.jsp, deals.jsp
    ├── cart/        cart.jsp
    ├── checkout/    checkout.jsp, payment.jsp, order-confirmation.jsp
    ├── orders/      order-detail.jsp
    ├── auth/        login.jsp, register.jsp, change-password.jsp
    ├── account/     profile.jsp + sections/ (profile tabs: orders, wishlist, addresses, …)
    ├── info/        aboutus.jsp, contactus.jsp, FAQ.jsp, privacy.jsp, terms.jsp
    └── admin/       dashboard, products, users, accounts
```

A controller returns the view path relative to `views/`, e.g. `return "shop/products";`.

## Conventions

**Every page** has the same skeleton:

```jsp
<head>
    <title>Harvesta | Page name</title>
    <link rel="stylesheet" href="/css/pages/<page>.css">                      <%-- page styles first --%>
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />            <%-- theme, header, buttons, footer, icons --%>
</head>
<body>
    <jsp:include page="/WEB-INF/views/partials/navbar.jsp" />
    ...
    <jsp:include page="/WEB-INF/views/partials/footer.jsp" />
    <script src="/js/pages/<page>.js"></script>
</body>
```

- **Styles:** colours, radii and fonts are CSS variables in `css/base/theme.css` (`--hv-forest`,
  `--hv-green`, `--hv-orange`, …). Change the brand look there. Greens: `--hv-forest` / `--hv-green` for surfaces and
  buttons, `--hv-heading` / `--hv-green-text` for text on light backgrounds (kept darker for readability). Shared component classes are prefixed `hv-`.
- **Dark mode:** `<html data-theme="dark">` switches the theme. The navbar toggle sets it and remembers the
  choice in `localStorage` (`hv-theme`); with no saved choice it follows the OS setting. A tiny script in
  `partials/head-assets.jsp` applies it before first paint (no light flash).
  Light colours in the stylesheets are written as `var(--hv-surface, #fff)`: the fallback is the light colour, and
  `css/base/dark.css` defines the dark value for each token (`--hv-surface`, `--hv-page`, `--hv-text-strong`,
  `--hv-border`, `--hv-ac-green`, …). **When you add a new rule, use these tokens for backgrounds, text and borders**
  (e.g. `background: var(--hv-surface, #fff); color: var(--hv-text-strong, #17382c);`) and it will work in both themes.
- **Currency (USD / LKR):** the navbar dropdown (`js/components/currency.js`) shows country flags and converts the dollar amounts shown on the
  page to Sri Lankan rupees using a live rate fetched in the browser (cached 6 h, fallback `FALLBACK_RATE` in the script).
  It is display-only: the database, cart maths and payments stay in USD, and a note under the order totals says so.
  Admin pages always show USD. To support another currency, extend `formatLKR`/`rate` in that script.
- **No inline `<style>` blocks.** Add rules to the page's file in `css/pages/`.
- **Scripts:** page logic lives in `js/pages/`. A few pages (cart, checkout, deals, FAQ, settings tab)
  keep a small inline `<script>` because it embeds server-rendered values (`${...}`).
  Inside a `.js` file write template literals normally (`${x}`); inside a JSP they must be escaped (`\${x}`).
- **Icons:** Font Awesome (loaded in `head-assets.jsp`). No emoji in the UI.
- **Renaming the brand:** search for `Harvesta`, `HARVEST` (phone) and `harvesta.com` (email).

## Known issues in the original code (not changed)

- Product cards no longer link to `/products/{id}` (that route returns the missing `product-detail` view). If you add a detail page later, wrap the card image/title in a link again.
- Controllers return view names that have no JSP: `product-detail`, `payment-success`, `payment-error`,
  `orders`, `contact`, `forgot-password`. Those routes will error until the pages are created.
- `HomeController` exposes `/navbar` and `/footer` as routes; they only render the partials and can be deleted.
- Contact page address and map, footer address and phone are placeholders.
