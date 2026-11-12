<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<ol class="hv-checkout-progress" aria-label="Checkout progress">
    <li class="${param.currentStep eq 'cart' ? 'is-current' : (param.currentStep eq 'payment' or param.currentStep eq 'delivery' or param.currentStep eq 'done' ? 'is-complete' : '')}" ${param.currentStep eq 'cart' ? 'aria-current="step"' : ''}>
        <span class="hv-progress-marker">1</span><span class="hv-progress-label">Cart</span>
    </li>
    <li class="${param.currentStep eq 'payment' ? 'is-current' : (param.currentStep eq 'delivery' or param.currentStep eq 'done' ? 'is-complete' : '')}" ${param.currentStep eq 'payment' ? 'aria-current="step"' : ''}>
        <span class="hv-progress-marker">2</span><span class="hv-progress-label">Payment</span>
    </li>
    <li class="${param.currentStep eq 'delivery' ? 'is-current' : (param.currentStep eq 'done' ? 'is-complete' : '')}" ${param.currentStep eq 'delivery' ? 'aria-current="step"' : ''}>
        <span class="hv-progress-marker">3</span><span class="hv-progress-label">Delivery</span>
    </li>
    <li class="${param.currentStep eq 'done' ? 'is-current' : ''}" ${param.currentStep eq 'done' ? 'aria-current="step"' : ''}>
        <span class="hv-progress-marker">4</span><span class="hv-progress-label">Done</span>
    </li>
</ol>
