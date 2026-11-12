package com.example.supermarket.controller;

import com.example.supermarket.model.Order;
import com.example.supermarket.model.User;
import com.example.supermarket.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.List;

@Controller
@RequestMapping("/orders")
public class OrderController {

    private static final DateTimeFormatter ORDER_DATE_FORMAT =
            DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a", Locale.ENGLISH);

    @Autowired
    private OrderService orderService;

    @GetMapping
    public String getUserOrders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        return "redirect:/profile?section=orders";
    }

    @GetMapping("/{id}")
    public String getOrderDetail(@PathVariable Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Order order = orderService.getOrderById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        // Check if order belongs to user
        if (!order.getUser().getId().equals(user.getId())) {
            return "redirect:/orders";
        }

        model.addAttribute("order", order);
        model.addAttribute("orderCreatedAtFormatted",
                order.getCreatedAt() == null ? "" : ORDER_DATE_FORMAT.format(order.getCreatedAt()));
        model.addAttribute("estimatedDeliveryFormatted",
                order.getEstimatedDelivery() == null ? "" : ORDER_DATE_FORMAT.format(order.getEstimatedDelivery()));
        return "orders/order-detail";
    }

    @PostMapping("/{id}/cancel")
    public String cancelOrder(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            orderService.cancelOrder(id);
            redirectAttributes.addFlashAttribute("success", "Order cancelled successfully!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile?section=orders";
    }

    @PostMapping("/create")
    public String createOrder(@RequestParam String shippingAddress,
                              @RequestParam String paymentMethod,
                              @RequestParam(required = false) String billingAddress,
                              @RequestParam(required = false) String notes,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            Order order = orderService.createOrder(
                    user.getId(),
                    shippingAddress,
                    paymentMethod,
                    billingAddress,
                    notes
            );

            redirectAttributes.addFlashAttribute("success", "Order created successfully!");
            redirectAttributes.addAttribute("orderId", order.getId());
            return "redirect:/payment/checkout";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/cart";
        }
    }
}