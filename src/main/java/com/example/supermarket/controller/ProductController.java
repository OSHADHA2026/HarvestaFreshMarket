package com.example.supermarket.controller;

import com.example.supermarket.model.Product;
import com.example.supermarket.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    @GetMapping
    public String getAllProducts(
            @RequestParam(required = false) String[] categories, // Changed to array
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Boolean inStock,
            @RequestParam(required = false) String rating,
            @RequestParam(defaultValue = "featured") String sort,
            @RequestParam(required = false) Boolean outStock,
            @RequestParam(required = false) Integer scrollY,
            Model model) {

        List<Product> products;

        // Check if any filter is applied
        boolean hasFilters = (categories != null && categories.length > 0) ||
                minPrice != null || maxPrice != null ||
                search != null || inStock != null ||
                rating != null || outStock != null;

        if (hasFilters) {
            // Convert categories array to comma-separated string
            String categoryParam = null;
            if (categories != null && categories.length > 0) {
                categoryParam = String.join(",", categories);
            }

            // Handle stock filtering
            Boolean stockFilter = null;
            if (inStock != null && inStock) {
                stockFilter = true;
            } else if (outStock != null && outStock) {
                stockFilter = false;
            }

            products = productService.searchProducts(categoryParam, minPrice, maxPrice, search, stockFilter, rating);
        } else {
            products = productService.getAllProducts();
        }

        // Apply sorting
        if ("price-low".equals(sort)) {
            products.sort((p1, p2) -> {
                if (p1.getPrice() == null && p2.getPrice() == null) return 0;
                if (p1.getPrice() == null) return 1;
                if (p2.getPrice() == null) return -1;
                return p1.getPrice().compareTo(p2.getPrice());
            });
        } else if ("price-high".equals(sort)) {
            products.sort((p1, p2) -> {
                if (p1.getPrice() == null && p2.getPrice() == null) return 0;
                if (p1.getPrice() == null) return -1;
                if (p2.getPrice() == null) return 1;
                return p2.getPrice().compareTo(p1.getPrice());
            });
        } else if ("rating".equals(sort)) {
            products.sort((p1, p2) -> {
                if (p1.getRating() == null && p2.getRating() == null) return 0;
                if (p1.getRating() == null) return 1;
                if (p2.getRating() == null) return -1;
                return p2.getRating().compareTo(p1.getRating());
            });
        } else if ("name".equals(sort)) {
            products.sort((p1, p2) -> {
                if (p1.getName() == null && p2.getName() == null) return 0;
                if (p1.getName() == null) return 1;
                if (p2.getName() == null) return -1;
                return p1.getName().compareToIgnoreCase(p2.getName());
            });
        } else { // "featured" or default
            products.sort((p1, p2) -> {
                // Featured products first
                boolean p1Featured = p1.getIsFeatured() != null && p1.getIsFeatured();
                boolean p2Featured = p2.getIsFeatured() != null && p2.getIsFeatured();

                if (p1Featured && !p2Featured) return -1;
                if (!p1Featured && p2Featured) return 1;

                // Then by rating
                if (p1.getRating() == null && p2.getRating() == null) return 0;
                if (p1.getRating() == null) return 1;
                if (p2.getRating() == null) return -1;
                return p2.getRating().compareTo(p1.getRating());
            });
        }

        // Get unique categories for filter (sorted for easier browsing)
        List<String> allCategories = productService.getAllProducts().stream()
                .map(Product::getCategory)
                .filter(cat -> cat != null && !cat.trim().isEmpty())
                .distinct()
                .sorted(String.CASE_INSENSITIVE_ORDER)
                .collect(Collectors.toList());

        model.addAttribute("products", products);
        model.addAttribute("categories", allCategories);
        model.addAttribute("selectedCategories", categories != null ? Arrays.asList(categories) : List.of());
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("search", search);
        model.addAttribute("inStock", inStock);
        model.addAttribute("outStock", outStock);
        model.addAttribute("rating", rating);
        model.addAttribute("sort", sort);
        model.addAttribute("productCount", products.size());

        // Add scrollY to model if provided
        if (scrollY != null && scrollY > 0) {
            model.addAttribute("scrollY", scrollY);
        }

        return "shop/products";
    }

    @GetMapping("/{id}")
    public String getProductDetail(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        List<Product> recommended = productService.getRecommendedProducts(id);

        model.addAttribute("product", product);
        model.addAttribute("recommended", recommended);

        return "product-detail";
    }

    @GetMapping("/category/{category}")
    public String getProductsByCategory(@PathVariable String category, Model model) {
        List<Product> products = productService.getProductsByCategory(category);
        model.addAttribute("products", products);
        model.addAttribute("category", category);
        model.addAttribute("productCount", products.size());
        return "shop/products";
    }

    @GetMapping("/featured")
    public String getFeaturedProducts(Model model) {
        List<Product> featured = productService.getFeaturedProducts();
        model.addAttribute("products", featured);
        model.addAttribute("title", "Featured Products");
        return "shop/products";
    }
}