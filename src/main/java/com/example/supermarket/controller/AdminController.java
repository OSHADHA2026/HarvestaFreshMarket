package com.example.supermarket.controller;

import com.example.supermarket.model.Product;
import com.example.supermarket.model.User;
import com.example.supermarket.service.ProductService;
import com.example.supermarket.service.UserService;
import com.example.supermarket.util.DealExpiryUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private ProductService productService;

    @GetMapping
    public String dashboard(Model model) {
        model.addAttribute("pageTitle", "Admin Console");
        return "admin/dashboard";
    }

    @GetMapping("/admin-accounts")
    public String adminAccounts(Model model) {
        List<User> admins = userService.getAllUsers()
                .stream()
                .filter(u -> "ADMIN".equalsIgnoreCase(u.getRole()))
                .toList();

        model.addAttribute("pageTitle", "Admin Account Management");
        model.addAttribute("admins", admins);
        return "admin/admin-accounts";
    }

    @PostMapping("/admin-accounts/create")
    public String createAdmin(@RequestParam String email,
                              @RequestParam String password,
                              RedirectAttributes redirectAttributes) {
        try {
            userService.createAdminIfNotExists(email, password);
            redirectAttributes.addFlashAttribute("success", "Admin account created/updated for " + email);
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/admin-accounts";
    }

    @PostMapping("/admin-accounts/{id}/delete")
    public String deleteAdmin(@PathVariable Long id,
                              RedirectAttributes redirectAttributes) {
        try {
            userService.deleteUser(id);
            redirectAttributes.addFlashAttribute("success", "Admin account removed");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/admin-accounts";
    }

    @GetMapping("/users")
    public String users(Model model) {
        List<User> users = userService.getAllUsers()
                .stream()
                .filter(u -> !"ADMIN".equalsIgnoreCase(u.getRole()))
                .toList();

        model.addAttribute("pageTitle", "User Account Management");
        model.addAttribute("users", users);
        return "admin/users";
    }

    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id,
                             RedirectAttributes redirectAttributes) {
        try {
            userService.deleteUser(id);
            redirectAttributes.addFlashAttribute("success", "User removed");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/admin/users";
    }

    @GetMapping("/products")
    public String products(Model model) {
        try {
            System.out.println("AdminController: Loading products page");
            List<Product> products = productService.getAllProducts();
            System.out.println("AdminController: Found " + (products != null ? products.size() : 0) + " products");
            model.addAttribute("pageTitle", "Product Management");
            model.addAttribute("products", products != null ? products : List.of());
            System.out.println("AdminController: Returning admin/products view");
            return "admin/products";
        } catch (Exception ex) {
            System.err.println("AdminController: Error loading products: " + ex.getMessage());
            ex.printStackTrace();
            model.addAttribute("pageTitle", "Product Management");
            model.addAttribute("products", List.of());
            model.addAttribute("error", "Error loading products: " + ex.getMessage());
            return "admin/products";
        }
    }

    @GetMapping("/products/new")
    public String showAddProductForm(Model model) {
        model.addAttribute("pageTitle", "Add New Product");
        return "admin/add-product";
    }

    @PostMapping("/products")
    public String createProduct(
            @RequestParam String name,
            @RequestParam(required = false) String description,
            @RequestParam BigDecimal price,
            @RequestParam(required = false) BigDecimal originalPrice,
            @RequestParam(required = false) Integer discountPercentage,
            @RequestParam String category,
            @RequestParam(required = false) String subCategory,
            @RequestParam String image,
            @RequestParam Integer stock,
            @RequestParam(required = false) Integer minStock,
            @RequestParam(required = false) Boolean isFeatured,
            @RequestParam(required = false) Boolean isDeal,
            @RequestParam(required = false) String dealExpiry,
            @RequestParam(required = false) String dealExpiryDate,
            @RequestParam(required = false) String dealExpiryTime,
            @RequestParam(required = false) BigDecimal rating,
            @RequestParam(required = false) String weight,
            @RequestParam(required = false) String unit,
            @RequestParam(required = false) String brand,
            RedirectAttributes redirectAttributes) {
        try {
            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setOriginalPrice(originalPrice);
            product.setDiscountPercentage(discountPercentage);
            product.setCategory(category);
            product.setSubCategory(subCategory);
            product.setImage(image);
            product.setStock(stock);
            product.setMinStock(minStock != null ? minStock : 10);
            product.setIsFeatured(isFeatured != null && isFeatured);
            DealExpiryUtil.applyForCreate(
                    product,
                    isDeal != null && isDeal,
                    dealExpiry,
                    dealExpiryDate,
                    dealExpiryTime);
            product.setRating(rating != null ? rating : BigDecimal.valueOf(4.0));
            product.setWeight(weight);
            product.setUnit(unit);
            product.setBrand(brand);

            productService.saveProduct(product);
            redirectAttributes.addFlashAttribute("success", "Product added successfully!");
            return "redirect:/admin/products";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error adding product: " + ex.getMessage());
            return "redirect:/admin/products/new";
        }
    }

    @GetMapping("/products/{id}")
    public String viewProduct(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        model.addAttribute("pageTitle", "Product Details");
        model.addAttribute("product", product);
        return "admin/view-product";
    }

    @GetMapping("/products/{id}/edit")
    public String showEditProductForm(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        model.addAttribute("pageTitle", "Edit Product");
        model.addAttribute("product", product);
        model.addAttribute("dealExpiryDate", DealExpiryUtil.formatDate(product.getDealExpiry()));
        model.addAttribute("dealExpiryTime", DealExpiryUtil.formatTime(product.getDealExpiry()));
        return "admin/edit-product";
    }

    @PostMapping("/products/{id}")
    public String updateProduct(
            @PathVariable Long id,
            @RequestParam String name,
            @RequestParam(required = false) String description,
            @RequestParam BigDecimal price,
            @RequestParam(required = false) BigDecimal originalPrice,
            @RequestParam(required = false) Integer discountPercentage,
            @RequestParam String category,
            @RequestParam(required = false) String subCategory,
            @RequestParam String image,
            @RequestParam Integer stock,
            @RequestParam(required = false) Integer minStock,
            @RequestParam(required = false) Boolean isFeatured,
            @RequestParam(required = false) Boolean isDeal,
            @RequestParam(required = false) String dealExpiry,
            @RequestParam(required = false) String dealExpiryDate,
            @RequestParam(required = false) String dealExpiryTime,
            @RequestParam(required = false) BigDecimal rating,
            @RequestParam(required = false) String weight,
            @RequestParam(required = false) String unit,
            @RequestParam(required = false) String brand,
            RedirectAttributes redirectAttributes) {
        try {
            Product product = productService.getProductById(id)
                    .orElseThrow(() -> new RuntimeException("Product not found"));
            
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setOriginalPrice(originalPrice);
            product.setDiscountPercentage(discountPercentage);
            product.setCategory(category);
            product.setSubCategory(subCategory);
            product.setImage(image);
            product.setStock(stock);
            product.setMinStock(minStock != null ? minStock : 10);
            product.setIsFeatured(isFeatured != null && isFeatured);
            DealExpiryUtil.applyForUpdate(
                    product,
                    isDeal != null && isDeal,
                    dealExpiry,
                    dealExpiryDate,
                    dealExpiryTime);
            product.setRating(rating != null ? rating : BigDecimal.valueOf(4.0));
            product.setWeight(weight);
            product.setUnit(unit);
            product.setBrand(brand);

            productService.saveProduct(product);
            redirectAttributes.addFlashAttribute("success", "Product updated successfully!");
            return "redirect:/admin/products";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error updating product: " + ex.getMessage());
            return "redirect:/admin/products/" + id + "/edit";
        }
    }

    @PostMapping("/products/{id}/delete")
    public String deleteProduct(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            productService.deleteProduct(id);
            redirectAttributes.addFlashAttribute("success", "Product deleted successfully!");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Error deleting product: " + ex.getMessage());
        }
        return "redirect:/admin/products";
    }
}

