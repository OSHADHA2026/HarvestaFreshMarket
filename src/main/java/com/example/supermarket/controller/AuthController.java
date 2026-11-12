package com.example.supermarket.controller;

import com.example.supermarket.model.User;
import com.example.supermarket.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public String loginUser(@RequestParam String email,
                            @RequestParam String password,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        try {
            System.out.println("Login attempt for email: " + email);
            User user = userService.loginUser(email, password);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            System.out.println("Login successful, user ID: " + user.getId());
            // Redirect admins to /admin
            if ("ADMIN".equals(user.getRole())) {
                return "redirect:/admin";
            }
            return "redirect:/";
        } catch (RuntimeException e) {
            System.out.println("Login failed for email: " + email);
            redirectAttributes.addAttribute("error", "true");
            return "redirect:/login";
        }
    }

    @PostMapping("/signup")
    public String registerUser(@RequestParam String firstName,
                               @RequestParam String lastName,
                               @RequestParam String email,
                               @RequestParam String password,
                               @RequestParam(required = false) String phone,
                               @RequestParam(required = false) String confirmPassword,
                               @RequestParam(required = false) String address,
                               RedirectAttributes redirectAttributes) {
        try {
            System.out.println("Registration attempt for: " + email);
            System.out.println("First Name: " + firstName + ", Last Name: " + lastName);

            // Create new user
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPassword(password);
            user.setPhone(phone);
            user.setAddress(address);

            User savedUser = userService.registerUser(user);

            System.out.println("Registration successful for: " + email + " with ID: " + savedUser.getId());

            // Redirect to login page with success message
            redirectAttributes.addAttribute("signup", "success");
            return "redirect:/login";

        } catch (RuntimeException e) {
            System.out.println("Registration failed for: " + email + " - " + e.getMessage());
            redirectAttributes.addAttribute("error", "true");
            return "redirect:/register";
        }
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return "redirect:/login";
            }

            // Validate inputs
            if (newPassword == null || newPassword.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "New password cannot be empty");
                return "redirect:/profile?section=settings";
            }

            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "New passwords do not match");
                return "redirect:/profile?section=settings";
            }

            if (newPassword.length() < 6) {
                redirectAttributes.addFlashAttribute("error", "Password must be at least 6 characters long");
                return "redirect:/profile?section=settings";
            }

            // Change password
            userService.changePassword(user.getId(), currentPassword, newPassword);

            // Update user in session
            User updatedUser = userService.getUserById(user.getId()).orElse(null);
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }

            redirectAttributes.addFlashAttribute("success", "Password changed successfully");
            return "redirect:/profile?section=settings";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/profile?section=settings";
        }
    }

    @PostMapping("/delete-account")
    public String deleteAccount(@RequestParam String password,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return "redirect:/login";
            }

            // Validate password
            if (password == null || password.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Password is required to delete account");
                return "redirect:/profile?section=settings";
            }

            userService.deleteAccount(user.getId(), password);
            session.invalidate();

            redirectAttributes.addFlashAttribute("accountDeleted", "true");
            return "redirect:/";

        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/profile?section=settings";
        }
    }

    @PostMapping("/update-profile")
    public String updateProfile(@RequestParam String firstName,
                                @RequestParam String lastName,
                                @RequestParam String phone,
                                @RequestParam String address,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return "redirect:/login";
            }

            // Update profile
            userService.updateUserProfile(user.getId(), firstName, lastName, phone, address);

            // Update user in session
            User updatedUser = userService.getUserById(user.getId()).orElse(null);
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }

            redirectAttributes.addAttribute("success", "Profile updated successfully");
            return "redirect:/profile?section=profile";

        } catch (RuntimeException e) {
            redirectAttributes.addAttribute("error", e.getMessage());
            return "redirect:/profile?section=profile";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addAttribute("logout", "true");
        return "redirect:/login";
    }
}