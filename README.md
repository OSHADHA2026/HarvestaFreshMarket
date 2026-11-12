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

