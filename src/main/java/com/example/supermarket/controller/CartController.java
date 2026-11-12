package com.example.supermarket.controller;

import com.example.supermarket.model.Cart;
import com.example.supermarket.model.Order;
import com.example.supermarket.model.Product;
import com.example.supermarket.model.User;
import com.example.supermarket.service.CartService;
import com.example.supermarket.service.OrderService;
import com.example.supermarket.service.ProductService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private ProductService productService;

    @Autowired
    private OrderService orderService;

    @GetMapping
    public String viewCart(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Cart cart = cartService.getCart(user.getId());
        BigDecimal subtotal = cart.getTotalPrice();
        BigDecimal deliveryFee = subtotal.compareTo(BigDecimal.valueOf(50)) >= 0 ?
                BigDecimal.ZERO : BigDecimal.valueOf(4.99);
        BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(0.09));
        BigDecimal discount = subtotal.compareTo(BigDecimal.valueOf(30)) >= 0 ?
                BigDecimal.valueOf(2.00) : BigDecimal.ZERO;
        BigDecimal total = subtotal.add(tax).add(deliveryFee).subtract(discount);

        model.addAttribute("cart", cart);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("deliveryFee", deliveryFee);
        model.addAttribute("tax", tax);
        model.addAttribute("discount", discount);
        model.addAttribute("total", total);
        model.addAttribute("itemCount", cart.getItemCount());

        List<Product> recommendedProducts = productService.getInStockProducts().stream()
                .filter(product -> cart.getItems().stream()
                        .noneMatch(item -> item.getProduct().getId().equals(product.getId())))
                .limit(4)
                .collect(Collectors.toList());
        model.addAttribute("recommendedProducts", recommendedProducts);

        return "cart/cart";
    }

    @PostMapping("/add")
    public String addToCart(@RequestParam Long productId,
                            @RequestParam(defaultValue = "1") Integer quantity,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            cartService.addToCart(user.getId(), productId, quantity);
            redirectAttributes.addFlashAttribute("success", "Product added to cart successfully!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/products";
    }

    @PostMapping("/update")
    public String updateCartItem(@RequestParam Long productId,
                                 @RequestParam Integer quantity,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            cartService.updateCartItemQuantity(user.getId(), productId, quantity);
            redirectAttributes.addFlashAttribute("success", "Cart updated successfully!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/cart";
    }

    @PostMapping("/remove")
    public String removeFromCart(@RequestParam Long productId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            cartService.removeFromCart(user.getId(), productId);
            redirectAttributes.addFlashAttribute("success", "Item removed from cart!");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/cart";
    }

    @PostMapping("/clear")
    public String clearCart(HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        cartService.clearCart(user.getId());
        redirectAttributes.addFlashAttribute("success", "Cart cleared successfully!");

        return "redirect:/cart";
    }

    @GetMapping("/count")
    @ResponseBody
    public Integer getCartItemCount(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return 0;
        }
        return cartService.getCartItemCount(user.getId());
    }

    @PostMapping("/checkout")
    public String checkout(HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            // Get current cart
            Cart cart = cartService.getCart(user.getId());

            if (cart.getItems().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Your cart is empty");
                return "redirect:/cart";
            }

            // Create order from cart (don't clear cart yet)
            Order order = orderService.createOrderFromCart(user.getId());

            // Clear cart only after successful order creation
            cartService.clearCart(user.getId());

            redirectAttributes.addFlashAttribute("success", "Order created successfully!");
            return "redirect:/payment?orderId=" + order.getId();

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/cart";
        }
    }
}