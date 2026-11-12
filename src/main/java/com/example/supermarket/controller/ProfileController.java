package com.example.supermarket.controller;

import com.example.supermarket.model.User;
import com.example.supermarket.service.SavedPaymentMethodService;
import com.example.supermarket.service.UserAddressService;
import com.example.supermarket.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private UserAddressService userAddressService;

    @Autowired
    private SavedPaymentMethodService savedPaymentMethodService;

    @Autowired
    private UserService userService;

    @PostMapping("/addresses/save")
    public String saveAddress(
            @RequestParam(required = false) Long addressId,
            @RequestParam String label,
            @RequestParam String fullName,
            @RequestParam String phone,
            @RequestParam String addressLine1,
            @RequestParam(required = false) String addressLine2,
            @RequestParam String city,
            @RequestParam String state,
            @RequestParam String zipCode,
            @RequestParam(required = false) String landmark,
            @RequestParam(required = false) String defaultAddress,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = requireUser(session);
        if (user == null) {
            return "redirect:/login?redirect=/profile?section=addresses";
        }

        try {
            userAddressService.saveAddress(user.getId(), addressId, label, fullName, phone,
                    addressLine1, addressLine2, city, state, zipCode, landmark,
                    "on".equals(defaultAddress) || "true".equalsIgnoreCase(defaultAddress));
            refreshUserInSession(session, user.getId());
            redirectAttributes.addFlashAttribute("success", addressId != null ? "Address updated successfully" : "Address saved successfully");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile?section=addresses";
    }

    @PostMapping("/addresses/{id}/default")
    public String setDefaultAddress(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = requireUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            userAddressService.setDefaultAddress(id, user.getId());
            refreshUserInSession(session, user.getId());
            redirectAttributes.addFlashAttribute("success", "Default address updated");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile?section=addresses";
    }

    @PostMapping("/addresses/{id}/delete")
    public String deleteAddress(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = requireUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            userAddressService.deleteAddress(id, user.getId());
            refreshUserInSession(session, user.getId());
            redirectAttributes.addFlashAttribute("success", "Address removed");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile?section=addresses";
    }

    @PostMapping("/payments/save")
    public String savePayment(
            @RequestParam(required = false) Long paymentId,
            @RequestParam String paymentType,
            @RequestParam(required = false) String cardBrand,
            @RequestParam(required = false) String cardNumber,
            @RequestParam(required = false) String expiryDate,
            @RequestParam(required = false) String cardholderName,
            @RequestParam(required = false) String paypalEmail,
            @RequestParam(required = false) String upiId,
            @RequestParam(required = false) String defaultPayment,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = requireUser(session);
        if (user == null) {
            return "redirect:/login?redirect=/profile?section=payments";
        }

        try {
            savedPaymentMethodService.savePaymentMethod(user.getId(), paymentId, paymentType,
                    cardBrand, cardNumber, expiryDate, cardholderName, paypalEmail, upiId,
                    "on".equals(defaultPayment) || "true".equalsIgnoreCase(defaultPayment));
            redirectAttributes.addFlashAttribute("success", paymentId != null ? "Payment method updated" : "Payment method saved");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile?section=payments";
    }

    @PostMapping("/payments/{id}/default")
    public String setDefaultPayment(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = requireUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            savedPaymentMethodService.setDefaultPaymentMethod(id, user.getId());
            redirectAttributes.addFlashAttribute("success", "Default payment method updated");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile?section=payments";
    }

    @PostMapping("/payments/{id}/delete")
    public String deletePayment(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = requireUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            savedPaymentMethodService.deletePaymentMethod(id, user.getId());
            redirectAttributes.addFlashAttribute("success", "Payment method removed");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile?section=payments";
    }

    private User requireUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    private void refreshUserInSession(HttpSession session, Long userId) {
        userService.getUserById(userId).ifPresent(u -> session.setAttribute("user", u));
    }
}
