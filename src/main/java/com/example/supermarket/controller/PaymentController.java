package com.example.supermarket.controller;

import com.example.supermarket.model.Order;
import com.example.supermarket.model.OrderItem;
import com.example.supermarket.model.User;
import com.example.supermarket.model.SavedPaymentMethod;
import com.example.supermarket.service.OrderService;
import com.example.supermarket.service.PaymentService;
import com.example.supermarket.service.SavedPaymentMethodService;
import com.example.supermarket.service.UserAddressService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    private static final DateTimeFormatter DELIVERY_DATE_FORMAT =
            DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a", Locale.ENGLISH);

    @Autowired
    private OrderService orderService;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private SavedPaymentMethodService savedPaymentMethodService;

    @Autowired
    private UserAddressService userAddressService;

    /**
     * Main payment page - handles both direct access and checkout flow
     */
    @GetMapping
    public String paymentPage(
            @RequestParam(required = false) Long orderId,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login?redirect=payment";
        }

        try {
            Order order;

            // If orderId is provided, get that order
            if (orderId != null) {
                order = orderService.getOrderById(orderId)
                        .orElseThrow(() -> new RuntimeException("Order not found with ID: " + orderId));

                // Verify order belongs to user
                if (!order.getUser().getId().equals(user.getId())) {
                    model.addAttribute("error", "This order doesn't belong to you.");
                    return "payment-error";
                }

                // Check if payment already completed
                if ("COMPLETED".equals(order.getPaymentStatus())) {
                    return "redirect:/orders/" + orderId + "?payment=already_completed";
                }
            }
            // Otherwise, get the latest pending order
            else {
                List<Order> userOrders = orderService.getUserOrders(user.getId());
                Optional<Order> pendingOrder = userOrders.stream()
                        .filter(o -> "PENDING".equals(o.getPaymentStatus()))
                        .findFirst();

                if (pendingOrder.isPresent()) {
                    order = pendingOrder.get();
                } else {
                    // No pending orders, redirect to cart
                    return "redirect:/cart?message=no_pending_order";
                }
            }

            // Prepare model attributes
            preparePaymentModel(model, order, user);

            return "checkout/payment";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error loading payment page: " + e.getMessage());
            return "payment-error";
        }
    }

    /**
     * Checkout endpoint - redirects to payment page with order details
     */
    @GetMapping("/checkout")
    public String checkoutPage(
            @RequestParam Long orderId,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login?redirect=payment/checkout&orderId=" + orderId;
        }

        try {
            Order order = orderService.getOrderById(orderId)
                    .orElseThrow(() -> new RuntimeException("Order not found"));

            // Verify order belongs to user
            if (!order.getUser().getId().equals(user.getId())) {
                redirectAttributes.addFlashAttribute("error", "Access denied.");
                return "redirect:/orders";
            }

            // Check if payment already completed
            if ("COMPLETED".equals(order.getPaymentStatus())) {
                redirectAttributes.addFlashAttribute("success", "Payment already completed!");
                return "redirect:/orders/" + orderId;
            }

            // Prepare model attributes
            preparePaymentModel(model, order, user);

            return "checkout/payment";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error: " + e.getMessage());
            return "redirect:/cart";
        }
    }

    /**
     * Process payment
     */
    @PostMapping("/process")
    public String processPayment(
            @RequestParam Long orderId,
            @RequestParam String paymentMethod,
            @RequestParam(required = false) String cardNumber,
            @RequestParam(required = false) String expiryDate,
            @RequestParam(required = false) String cvv,
            @RequestParam(required = false) String cardHolderName,
            @RequestParam(required = false) String paypalEmail,
            @RequestParam(required = false) String applePayToken,
            @RequestParam(required = false) String billingFullName,
            @RequestParam(required = false) String billingAddress,
            @RequestParam(required = false) String billingCity,
            @RequestParam(required = false) String billingState,
            @RequestParam(required = false) String billingZipCode,
            @RequestParam(required = false) String billingCountry,
            @RequestParam(required = false) String contactEmail,
            @RequestParam(required = false) String contactPhone,
            @RequestParam(required = false) Long savedPaymentId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            // Validate required parameters
            if (orderId == null) {
                throw new RuntimeException("Order ID is required");
            }

            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                throw new RuntimeException("Payment method is required");
            }

            // Validate billing address information
            validateBillingAddress(billingFullName, billingAddress, billingCity, billingState, billingZipCode);

            // Validate contact information
            validateContactInfo(contactEmail, contactPhone);

            // Get the order
            Order order = orderService.getOrderById(orderId)
                    .orElseThrow(() -> new RuntimeException("Order not found"));

            // Verify order belongs to user
            if (!order.getUser().getId().equals(user.getId())) {
                throw new RuntimeException("This order doesn't belong to you");
            }

            // Check if payment already completed
            if ("COMPLETED".equals(order.getPaymentStatus())) {
                redirectAttributes.addFlashAttribute("info", "Payment already completed!");
                return "redirect:/orders/" + orderId;
            }

            boolean paymentSuccess = false;

            if (savedPaymentId != null) {
                SavedPaymentMethod saved = savedPaymentMethodService.getPaymentMethodForUser(savedPaymentId, user.getId());
                String savedType = saved.getPaymentType().toLowerCase();

                switch (savedType) {
                    case "card":
                        validateCvvOnly(cvv);
                        paymentSuccess = paymentService.processSavedCardPayment(order, saved, cvv);
                        break;
                    case "paypal":
                        paymentSuccess = paymentService.processPaypalPayment(order, saved.getPaypalEmail());
                        break;
                    case "upi":
                        paymentSuccess = paymentService.processPaypalPayment(order, saved.getUpiId() + "@upi");
                        break;
                    default:
                        throw new RuntimeException("Unsupported saved payment type");
                }
            } else {
                switch (paymentMethod.toLowerCase()) {
                    case "card":
                        validateCardDetails(cardNumber, expiryDate, cvv, cardHolderName);
                        paymentSuccess = paymentService.processPayment(order, cardNumber, expiryDate, cvv, cardHolderName);
                        break;

                    case "paypal":
                        validatePaypalEmail(paypalEmail);
                        paymentSuccess = paymentService.processPaypalPayment(order, paypalEmail);
                        break;

                    case "apple":
                        validateApplePayToken(applePayToken);
                        paymentSuccess = paymentService.processApplePayPayment(order, applePayToken);
                        break;

                    case "cod":
                        order.setPaymentStatus("PENDING");
                        order.setOrderStatus("CONFIRMED");
                        orderService.updatePaymentStatus(order.getId(), "PENDING");
                        paymentSuccess = true;
                        break;

                    default:
                        throw new RuntimeException("Unsupported payment method: " + paymentMethod);
                }
            }

            if (paymentSuccess) {
                // PaymentService already updates order status for card/paypal/apple payments
                // Only need to handle COD separately
                if ("cod".equals(paymentMethod.toLowerCase())) {
                    // COD is already handled in the switch statement above
                    // No additional update needed
                }

                redirectAttributes.addFlashAttribute("success",
                        "Payment processed successfully! Order #" + order.getOrderNumber());
                return "redirect:/orders/" + orderId;
            } else {
                throw new RuntimeException("Payment processing failed");
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            redirectAttributes.addAttribute("orderId", orderId);
            return "redirect:/payment";
        }
    }

    /**
     * Payment success page
     */
    @GetMapping("/success/{orderId}")
    public String paymentSuccess(
            @PathVariable Long orderId,
            @RequestParam(required = false) String transactionId,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            Order order = orderService.getOrderById(orderId)
                    .orElseThrow(() -> new RuntimeException("Order not found"));

            // Verify order belongs to user
            if (!order.getUser().getId().equals(user.getId())) {
                model.addAttribute("error", "Access denied.");
                return "payment-error";
            }

            model.addAttribute("order", order);
            model.addAttribute("transactionId", transactionId);
            model.addAttribute("successMessage", "Payment completed successfully!");

            return "payment-success";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "payment-error";
        }
    }

    /**
     * Payment failure page
     */
    @GetMapping("/failed/{orderId}")
    public String paymentFailed(
            @PathVariable Long orderId,
            @RequestParam(required = false) String error,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            Order order = orderService.getOrderById(orderId)
                    .orElseThrow(() -> new RuntimeException("Order not found"));

            model.addAttribute("order", order);
            model.addAttribute("error", error != null ? error : "Payment failed. Please try again.");

            return "checkout/payment";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "payment-error";
        }
    }

    /**
     * Validate payment method
     */
    @GetMapping("/validate")
    @ResponseBody
    public String validatePaymentMethod(
            @RequestParam String method,
            @RequestParam(required = false) String cardNumber,
            @RequestParam(required = false) String expiryDate) {

        try {
            switch (method.toLowerCase()) {
                case "card":
                    return paymentService.validateCard(cardNumber, expiryDate, "123")
                            ? "VALID" : "INVALID";
                default:
                    return "VALID";
            }
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }

    // =========== PRIVATE HELPER METHODS ===========

    private void preparePaymentModel(Model model, Order order, User user) {
        model.addAttribute("order", order);
        model.addAttribute("user", user);

        // Calculate delivery estimate
        LocalDateTime estimatedDelivery = order.getEstimatedDelivery();
        if (estimatedDelivery == null) {
            estimatedDelivery = LocalDateTime.now().plusHours(2);
            order.setEstimatedDelivery(estimatedDelivery);
        }
        model.addAttribute("estimatedDelivery", estimatedDelivery);
        model.addAttribute("estimatedDeliveryFormatted", DELIVERY_DATE_FORMAT.format(estimatedDelivery));

        // Calculate if free delivery
        boolean freeDelivery = order.getDeliveryFee().compareTo(BigDecimal.ZERO) == 0;
        model.addAttribute("freeDelivery", freeDelivery);

        var savedMethods = savedPaymentMethodService.getPaymentMethodsForUser(user.getId());
        model.addAttribute("savedPaymentMethods", savedMethods);
        savedMethods.stream()
                .filter(s -> Boolean.TRUE.equals(s.getIsDefault()))
                .findFirst()
                .ifPresent(s -> model.addAttribute("defaultSavedPayment", s));

        userAddressService.getAddressesForUser(user.getId()).stream()
                .filter(a -> Boolean.TRUE.equals(a.getIsDefault()))
                .findFirst()
                .ifPresent(a -> model.addAttribute("defaultBillingAddress", a));
    }

    private void validateCvvOnly(String cvv) {
        if (cvv == null || cvv.trim().isEmpty()) {
            throw new RuntimeException("CVV is required for saved card");
        }
        if (!cvv.matches("\\d{3,4}")) {
            throw new RuntimeException("CVV must be 3 or 4 digits");
        }
    }

    private void validateCardDetails(String cardNumber, String expiryDate, String cvv, String cardHolderName) {
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            throw new RuntimeException("Card number is required");
        }
        if (expiryDate == null || expiryDate.trim().isEmpty()) {
            throw new RuntimeException("Expiry date is required");
        }
        if (cvv == null || cvv.trim().isEmpty()) {
            throw new RuntimeException("CVV is required");
        }
        if (cardHolderName == null || cardHolderName.trim().isEmpty()) {
            throw new RuntimeException("Card holder name is required");
        }

        if (!paymentService.isValidCardNumber(cardNumber)) {
            throw new RuntimeException("Card number is invalid");
        }
        if (!expiryDate.matches("^(0[1-9]|1[0-2])/\\d{2}$")) {
            throw new RuntimeException("Expiry date must be in MM/YY format");
        }
        if (!cvv.matches("\\d{3,4}")) {
            throw new RuntimeException("CVV must be 3 or 4 digits");
        }
    }

    private void validatePaypalEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            throw new RuntimeException("PayPal email is required");
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new RuntimeException("Invalid email format");
        }
    }

    private void validateApplePayToken(String token) {
        if (token == null || token.trim().isEmpty()) {
            throw new RuntimeException("Apple Pay token is required");
        }
        if (token.length() < 10) {
            throw new RuntimeException("Invalid Apple Pay token");
        }
    }

    private void validateBillingAddress(String fullName, String address, String city, String state, String zipCode) {
        if (fullName == null || fullName.trim().isEmpty() || fullName.trim().length() < 2) {
            throw new RuntimeException("Full name is required");
        }
        if (address == null || address.trim().isEmpty() || address.trim().length() < 5) {
            throw new RuntimeException("Address is required and must be at least 5 characters");
        }
        if (city == null || city.trim().isEmpty() || city.trim().length() < 2) {
            throw new RuntimeException("City is required");
        }
        if (state == null || state.trim().isEmpty() || state.trim().length() < 2) {
            throw new RuntimeException("State is required");
        }
        if (zipCode == null || zipCode.trim().isEmpty() || !zipCode.matches("^[0-9A-Za-z\\s\\-]{3,10}$")) {
            throw new RuntimeException("ZIP code is required and must be valid");
        }
    }

    private void validateContactInfo(String email, String phone) {
        if (email == null || email.trim().isEmpty() || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            throw new RuntimeException("Valid email address is required");
        }
        if (phone == null || phone.trim().isEmpty() || phone.trim().length() < 7) {
            throw new RuntimeException("Valid phone number is required");
        }
    }

    // Inner class for payment method representation
    private static class PaymentMethod {
        private String id;
        private String name;
        private String description;

        public PaymentMethod(String id, String name, String description) {
            this.id = id;
            this.name = name;
            this.description = description;
        }

        public String getId() { return id; }
        public String getName() { return name; }
        public String getDescription() { return description; }
    }
}