package com.example.supermarket.controller;

import com.example.supermarket.model.Order;
import com.example.supermarket.model.User;
import com.example.supermarket.service.OrderService;
import com.example.supermarket.service.ProductService;
import com.example.supermarket.service.SavedPaymentMethodService;
import com.example.supermarket.service.UserAddressService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private ProductService productService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserAddressService userAddressService;

    @Autowired
    private SavedPaymentMethodService savedPaymentMethodService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("featuredProducts", productService.getFeaturedProducts());
        model.addAttribute("deals", productService.getDeals());
        return "home/index";
    }

    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }

    @GetMapping("/register")
    public String register() {
        return "auth/register";
    }

    /*@GetMapping("/products")
    public String products() {
        return "redirect:/products";
    }*/

    /*@GetMapping("/deals")
    public String deals() {
        return "redirect:/deals";
    }*/

    /*@GetMapping("/cart")
    public String cart(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        return "cart/cart";
    }

    @GetMapping("/payment")
    public String payment() {
        return "checkout/payment";
    }*/

    @GetMapping("/privacy")
    public String privacy() {
        return "info/privacy";
    }

    @GetMapping("/FAQ")
    public String FAQ() {
        return "info/FAQ";
    }

    @GetMapping("/footer")
    public String footer() {
        return "partials/footer";
    }

    @GetMapping("/terms")
    public String terms() {
        return "info/terms";
    }

    @GetMapping("/navbar")
    public String navbar() {
        return "partials/navbar";
    }

    /*@GetMapping("/checkout")
    public String checkout(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        return "checkout/checkout";
    }*/

    @GetMapping("/profile")
    public String profile(
            @RequestParam(required = false, defaultValue = "profile") String section,
            @RequestParam(required = false) Long editAddressId,
            @RequestParam(required = false) Long editPaymentId,
            HttpSession session,
            Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login?redirect=/profile";
        }

        model.addAttribute("section", section);
        model.addAttribute("orders", orderService.getUserOrders(user.getId()));
        model.addAttribute("addresses", userAddressService.getAddressesForUser(user.getId()));
        model.addAttribute("paymentMethods", savedPaymentMethodService.getPaymentMethodsForUser(user.getId()));

        if (editAddressId != null) {
            model.addAttribute("editAddress", userAddressService.getAddressForUser(editAddressId, user.getId()));
        }
        if (editPaymentId != null) {
            model.addAttribute("editPayment", savedPaymentMethodService.getPaymentMethodForUser(editPaymentId, user.getId()));
        }

        return "account/profile";
    }

    @GetMapping("/aboutus")
    public String aboutus() {
        return "info/aboutus";
    }

    @GetMapping("/contactus")
    public String contactus() {
        return "info/contactus";
    }

    @GetMapping("/change-password")
    public String changePasswordPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        return "auth/change-password";
    }

    @GetMapping("/contact")
    public String contact() {
        return "contact";
    }

    @GetMapping("/forgot-password")
    public String forgotPassword() {
        return "forgot-password";
    }

    // New routes
    /*@GetMapping("/orders")
    public String orders(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        return "orders";
    }*/

    /*@GetMapping("/order-confirmation")
    public String orderConfirmation() {
        return "checkout/order-confirmation";
    }*/
}