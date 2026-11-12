package com.example.supermarket.controller;

import com.example.supermarket.model.User;
import com.example.supermarket.service.UserAddressService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    @Autowired
    private UserAddressService userAddressService;

    @GetMapping
    public String checkout(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("user", user);
        model.addAttribute("addresses", userAddressService.getAddressesForUser(user.getId()));
        return "checkout/checkout";
    }
}