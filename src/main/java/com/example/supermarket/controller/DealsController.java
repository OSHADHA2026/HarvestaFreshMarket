package com.example.supermarket.controller;

import com.example.supermarket.model.Product;
import com.example.supermarket.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/deals")
public class DealsController {

    @Autowired
    private ProductService productService;

    @GetMapping
    public String getAllDeals(
            @RequestParam(required = false) String category,
            @RequestParam(required = false, defaultValue = "featured") String sort,
            Model model) {

        try {
            // Get all active deals
            List<Product> allDeals = productService.getDeals();

            // Filter by category if specified
            List<Product> deals;
            if (category != null && !category.isEmpty() && !"all".equalsIgnoreCase(category)) {
                deals = allDeals.stream()
                        .filter(p -> p.getCategory() != null &&
                                p.getCategory().equalsIgnoreCase(category))
                        .collect(Collectors.toList());
            } else {
                deals = allDeals;
            }

            // Apply sorting - FIXED VERSION
            if ("price-low".equals(sort)) {
                deals.sort((p1, p2) -> {
                    if (p1.getPrice() == null && p2.getPrice() == null) return 0;
                    if (p1.getPrice() == null) return 1;
                    if (p2.getPrice() == null) return -1;
                    return p1.getPrice().compareTo(p2.getPrice());
                });
            } else if ("price-high".equals(sort)) {
                deals.sort((p1, p2) -> {
                    if (p1.getPrice() == null && p2.getPrice() == null) return 0;
                    if (p1.getPrice() == null) return -1;
                    if (p2.getPrice() == null) return 1;
                    return p2.getPrice().compareTo(p1.getPrice());
                });
            } else if ("discount".equals(sort)) {
                deals.sort((p1, p2) -> {
                    Double discount1 = calculateDiscountPercentage(p1);
                    Double discount2 = calculateDiscountPercentage(p2);
                    return discount2.compareTo(discount1); // Descending order
                });
            } else if ("ending-soon".equals(sort)) {
                deals.sort((p1, p2) -> {
                    if (p1.getDealExpiry() == null && p2.getDealExpiry() == null) return 0;
                    if (p1.getDealExpiry() == null) return 1; // No expiry goes last
                    if (p2.getDealExpiry() == null) return -1; // No expiry goes last
                    return p1.getDealExpiry().compareTo(p2.getDealExpiry()); // Ascending (earliest first)
                });
            } else { // "featured" or default
                deals.sort((p1, p2) -> {
                    if (p1.getRating() == null && p2.getRating() == null) return 0;
                    if (p1.getRating() == null) return 1;
                    if (p2.getRating() == null) return -1;
                    return p2.getRating().compareTo(p1.getRating()); // Descending order
                });
            }

            // Get flash sales (ending within 24 hours)
            List<Product> flashSales = deals.stream()
                    .filter(p -> p.getDealExpiry() != null &&
                            p.getDealExpiry().isBefore(LocalDateTime.now().plusHours(24)) &&
                            p.getDealExpiry().isAfter(LocalDateTime.now()))
                    .collect(Collectors.toList());

            // Get unique categories from ALL deals
            List<String> categories = allDeals.stream()
                    .map(Product::getCategory)
                    .filter(cat -> cat != null && !cat.trim().isEmpty())
                    .distinct()
                    .collect(Collectors.toList());

            // Format dates for JavaScript
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

            model.addAttribute("allDeals", deals);
            model.addAttribute("flashSales", flashSales);
            model.addAttribute("categories", categories);
            model.addAttribute("selectedCategory", category);
            model.addAttribute("sort", sort);
            model.addAttribute("dealCount", deals.size());
            model.addAttribute("dateFormatter", formatter);
            model.addAttribute("currentTime", LocalDateTime.now().format(formatter));

            return "shop/deals";

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Unable to load deals. Please try again later.");
            return "shop/deals";
        }
    }

    // Helper method to calculate discount percentage
    private Double calculateDiscountPercentage(Product product) {
        if (product.getDiscountPercentage() != null) {
            return product.getDiscountPercentage().doubleValue();
        }
        if (product.getOriginalPrice() != null &&
                product.getPrice() != null &&
                product.getOriginalPrice().compareTo(product.getPrice()) > 0) {

            double original = product.getOriginalPrice().doubleValue();
            double current = product.getPrice().doubleValue();
            return ((original - current) / original) * 100;
        }
        return 0.0;
    }
}