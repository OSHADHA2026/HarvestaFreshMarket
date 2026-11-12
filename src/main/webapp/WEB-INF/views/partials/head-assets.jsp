<%--
  Shared <head> assets, included by every page:
      <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
  Put the page's own stylesheet BEFORE this include (see any page for an example).
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="color-scheme" content="light dark">
<%-- Apply the saved (or OS-preferred) theme before first paint to avoid a light flash --%>
<script>
    (function () {
        try {
            var saved = localStorage.getItem('hv-theme');
            var dark = saved ? saved === 'dark' : window.matchMedia('(prefers-color-scheme: dark)').matches;
            if (dark) document.documentElement.setAttribute('data-theme', 'dark');
            document.documentElement.setAttribute('data-currency', localStorage.getItem('hv-currency') === 'LKR' ? 'LKR' : 'USD');
        } catch (e) {}
    })();
</script>
<link rel="icon" type="image/svg+xml" href="/images/brand/favicon.svg">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="/css/base/theme.css">
<link rel="stylesheet" href="/css/components/header.css">
<link rel="stylesheet" href="/css/components/buttons.css">
<link rel="stylesheet" href="/css/components/footer.css">
<link rel="stylesheet" href="/css/base/dark.css">
