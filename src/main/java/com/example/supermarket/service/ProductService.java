package com.example.supermarket.service;

import com.example.supermarket.model.OrderItem;
import com.example.supermarket.model.Product;
import com.example.supermarket.repository.CartItemRepository;
import com.example.supermarket.repository.OrderItemRepository;
import com.example.supermarket.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }

    public List<Product> getProductsByCategory(String category) {
        return productRepository.findByCategory(category);
    }

    public List<Product> getFeaturedProducts() {
        return productRepository.findByIsFeaturedTrue();
    }

    public List<Product> getDeals() {
        return productRepository.findActiveDeals(java.time.LocalDateTime.now());
    }

    public List<Product> searchProducts(String category, Double minPrice, Double maxPrice,
                                        String search, Boolean inStock, String rating) {
        List<Product> products;

        // Start with all products
        if (category != null && !category.isEmpty()) {
            // Handle multiple categories
            String[] categoryArray = category.split(",");
            if (categoryArray.length == 1) {
                products = productRepository.findByCategory(categoryArray[0]);
            } else {
                products = productRepository.findByCategoryIn(Arrays.asList(categoryArray));
            }
        } else {
            products = productRepository.findAll();
        }

        // Apply other filters
        return products.stream()
                .filter(p -> minPrice == null || (p.getPrice() != null && p.getPrice().doubleValue() >= minPrice))
                .filter(p -> maxPrice == null || (p.getPrice() != null && p.getPrice().doubleValue() <= maxPrice))
                .filter(p -> search == null || search.trim().isEmpty() ||
                        (p.getName() != null && p.getName().toLowerCase().contains(search.toLowerCase())) ||
                        (p.getDescription() != null && p.getDescription().toLowerCase().contains(search.toLowerCase())))
                .filter(p -> inStock == null ||
                        (inStock ? (p.getStock() != null && p.getStock() > 0) :
                                (p.getStock() == null || p.getStock() <= 0)))
                .filter(p -> rating == null || rating.trim().isEmpty() ||
                        (p.getRating() != null && p.getRating().doubleValue() >= Double.parseDouble(rating)))
                .collect(Collectors.toList());
    }

    // Keep the old method for backward compatibility
    public List<Product> searchProducts(String category, Double minPrice, Double maxPrice,
                                        String search, Boolean inStock) {
        return searchProducts(category, minPrice, maxPrice, search, inStock, null);
    }

    // Add this method if it doesn't exist
    public List<Product> findByCategoryIn(List<String> categories) {
        return productRepository.findByCategoryIn(categories);
    }

    public Product saveProduct(Product product) {
        // Set default image if missing
        if (product.getImage() == null || product.getImage().trim().isEmpty()) {
            product.setImage("/images/placeholder.png");
        }
        if (product.getId() == null) {
            product.setCreatedAt(LocalDateTime.now());
        }
        product.setUpdatedAt(LocalDateTime.now());
        return productRepository.save(product);
    }

    @Transactional
    public void deleteProduct(Long id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        for (OrderItem orderItem : orderItemRepository.findByProduct_Id(id)) {
            if (orderItem.getProductName() == null || orderItem.getProductName().isBlank()) {
                orderItem.setProductName(product.getName());
            }
            if (orderItem.getProductImage() == null || orderItem.getProductImage().isBlank()) {
                orderItem.setProductImage(product.getImage());
            }
            orderItem.setProduct(null);
            orderItemRepository.save(orderItem);
        }

        cartItemRepository.deleteByProductId(id);
        productRepository.delete(product);
    }

    public Product updateStock(Long productId, Integer quantity) {
        Optional<Product> optionalProduct = productRepository.findById(productId);
        if (optionalProduct.isPresent()) {
            Product product = optionalProduct.get();
            int newStock = product.getStock() - quantity;
            product.setStock(Math.max(0, newStock));
            product.setSoldCount(product.getSoldCount() + quantity);
            product.setUpdatedAt(LocalDateTime.now());
            return productRepository.save(product);
        }
        throw new RuntimeException("Product not found with id: " + productId);
    }

    public List<Product> getProductsWithLowStock() {
        return productRepository.findAll().stream()
                .filter(p -> p.getStock() != null && p.getStock() <= p.getMinStock())
                .collect(Collectors.toList());
    }

    public List<Product> getRecommendedProducts(Long productId) {
        Optional<Product> optionalProduct = productRepository.findById(productId);
        if (optionalProduct.isPresent()) {
            Product product = optionalProduct.get();
            // Get products from same category, excluding the current one
            return productRepository.findByCategory(product.getCategory()).stream()
                    .filter(p -> !p.getId().equals(productId))
                    .limit(4)
                    .collect(Collectors.toList());
        }
        return List.of();
    }

    // New method for in-stock products only
    public List<Product> getInStockProducts() {
        return productRepository.findByStockGreaterThan(0);
    }

    public List<Product> getProductsByIds(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return List.of();
        }
        return productRepository.findAllById(ids);
    }
}