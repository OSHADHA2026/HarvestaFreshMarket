package com.example.supermarket.controller;

import com.example.supermarket.model.Cart;
import com.example.supermarket.model.User;
import com.example.supermarket.service.CartService;
import com.example.supermarket.service.ProductService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.supermarket.model.Product;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class ApiController {

    @Autowired
    private CartService cartService;

    @Autowired
    private ProductService productService;

    @PostMapping("/cart/add")
    public ResponseEntity<Map<String, Object>> addToCart(@RequestBody Map<String, Object> request,
                                                         HttpSession session) {
        User user = (User) session.getAttribute("user");
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.ok(response);
        }

        try {
            Long productId = Long.parseLong(request.get("productId").toString());
            Integer quantity = Integer.parseInt(request.get("quantity").toString());

            Cart cart = cartService.addToCart(user.getId(), productId, quantity);

            response.put("success", true);
            response.put("message", "Added to cart");
            response.put("cartItemCount", cart.getItemCount());
            response.put("cartTotal", cart.getTotalPrice());

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/cart/update")
    public ResponseEntity<Map<String, Object>> updateCart(@RequestBody Map<String, Object> request,
                                                          HttpSession session) {
        User user = (User) session.getAttribute("user");
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.ok(response);
        }

        try {
            Long productId = Long.parseLong(request.get("productId").toString());
            Integer quantity = Integer.parseInt(request.get("quantity").toString()); // This should be the NEW quantity

            Cart cart = cartService.updateCartItemQuantity(user.getId(), productId, quantity);

            response.put("success", true);
            response.put("message", "Cart updated");
            response.put("cartItemCount", cart.getItemCount());
            response.put("cartTotal", cart.getTotalPrice());

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return ResponseEntity.ok(response);
    }


    @GetMapping("/cart/count")
    public ResponseEntity<Map<String, Object>> getCartCount(HttpSession session) {
        User user = (User) session.getAttribute("user");
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("count", 0);
        } else {
            response.put("count", cartService.getCartItemCount(user.getId()));
        }

        return ResponseEntity.ok(response);
    }

    @GetMapping("/products/search")
    public ResponseEntity<Map<String, Object>> searchProducts(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice) {

        Map<String, Object> response = new HashMap<>();

        try {
            // Use the method without rating parameter
            var products = productService.searchProducts(category, minPrice, maxPrice, query, true, null);
            response.put("success", true);
            response.put("products", products);
            response.put("count", products.size());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    @GetMapping("/cart/data")
    public ResponseEntity<Map<String, Object>> getCartData(HttpSession session) {
        User user = (User) session.getAttribute("user");
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.ok(response);
        }

        try {
            Cart cart = cartService.getCart(user.getId());

            // Create a simplified cart response
            Map<String, Object> cartData = new HashMap<>();
            cartData.put("id", cart.getId());
            cartData.put("itemCount", cart.getItemCount());
            cartData.put("totalPrice", cart.getTotalPrice());

            // Convert cart items to simple format
            List<Map<String, Object>> items = cart.getItems().stream()
                    .map(item -> {
                        Map<String, Object> itemData = new HashMap<>();
                        itemData.put("id", item.getId());
                        itemData.put("quantity", item.getQuantity());
                        itemData.put("totalPrice", item.getTotalPrice());

                        // Add product info
                        Map<String, Object> productData = new HashMap<>();
                        productData.put("id", item.getProduct().getId());
                        productData.put("name", item.getProduct().getName());
                        productData.put("image", item.getProduct().getImage());
                        productData.put("price", item.getProduct().getPrice());
                        itemData.put("product", productData);

                        return itemData;
                    })
                    .collect(Collectors.toList());

            cartData.put("items", items);

            response.put("success", true);
            response.put("cart", cartData);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    @GetMapping("/wishlist/products")
    public ResponseEntity<Map<String, Object>> getWishlistProducts(
            @RequestParam(required = false) String ids) {

        Map<String, Object> response = new HashMap<>();

        try {
            List<Long> productIds = new ArrayList<>();
            if (ids != null && !ids.trim().isEmpty()) {
                for (String part : ids.split(",")) {
                    String trimmed = part.trim();
                    if (!trimmed.isEmpty()) {
                        productIds.add(Long.parseLong(trimmed));
                    }
                }
            }

            List<Map<String, Object>> products = productService.getProductsByIds(productIds).stream()
                    .map(this::toWishlistProductMap)
                    .collect(Collectors.toList());

            response.put("success", true);
            response.put("products", products);
            response.put("count", products.size());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    private Map<String, Object> toWishlistProductMap(Product product) {
        Map<String, Object> data = new HashMap<>();
        data.put("id", product.getId());
        data.put("name", product.getName());
        data.put("description", product.getDescription());
        data.put("image", product.getImage());
        data.put("price", product.getPrice());
        data.put("category", product.getCategory());
        data.put("weight", product.getWeight());
        data.put("unit", product.getUnit());
        data.put("stockStatus", product.getStockStatus());
        data.put("inStock", product.getStock() != null && product.getStock() > 0);
        return data;
    }

    @PostMapping("/cart/remove")
    public ResponseEntity<Map<String, Object>> removeFromCart(@RequestBody Map<String, Object> request,
                                                              HttpSession session) {
        User user = (User) session.getAttribute("user");
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Please login first");
            return ResponseEntity.ok(response);
        }

        try {
            Long productId = Long.parseLong(request.get("productId").toString());

            Cart cart = cartService.removeFromCart(user.getId(), productId);

            response.put("success", true);
            response.put("message", "Item removed from cart");
            response.put("cartItemCount", cart.getItemCount());
            response.put("cartTotal", cart.getTotalPrice());

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

}