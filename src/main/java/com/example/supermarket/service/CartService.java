package com.example.supermarket.service;

import com.example.supermarket.model.*;
import com.example.supermarket.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    public Cart getOrCreateCart(Long userId) {
        Optional<Cart> optionalCart = cartRepository.findByUserId(userId);

        if (optionalCart.isPresent()) {
            return optionalCart.get();
        } else {
            Optional<User> optionalUser = userRepository.findById(userId);
            if (optionalUser.isPresent()) {
                Cart cart = new Cart();
                cart.setUser(optionalUser.get());
                cart.setCreatedAt(LocalDateTime.now());
                cart.setLastUpdated(LocalDateTime.now());
                return cartRepository.save(cart);
            }
            throw new RuntimeException("User not found with id: " + userId);
        }
    }

    @Transactional
    public Cart addToCart(Long userId, Long productId, Integer quantity) {
        Cart cart = getOrCreateCart(userId);
        Optional<Product> optionalProduct = productRepository.findById(productId);

        if (optionalProduct.isEmpty()) {
            throw new RuntimeException("Product not found with id: " + productId);
        }

        Product product = optionalProduct.get();

        // Check stock availability
        if (product.getStock() != null && product.getStock() < quantity) {
            throw new RuntimeException("Insufficient stock for product: " + product.getName());
        }

        // Check if product is already in cart
        Optional<CartItem> existingItem = cartItemRepository.findByCartAndProduct(cart, product);

        if (existingItem.isPresent()) {
            CartItem cartItem = existingItem.get();
            cartItem.setQuantity(cartItem.getQuantity() + quantity);
            cartItem.
                    updateTotalPrice();
            cartItemRepository.save(cartItem);
        } else {
            CartItem newItem = new CartItem(product, quantity);
            newItem.setCart(cart);
            cart.getItems().add(newItem);
            cartItemRepository.save(newItem);
        }

        cart.updateCart();
        return cartRepository.save(cart);
    }

    @Transactional
    public Cart updateCartItemQuantity(Long userId, Long productId, Integer quantity) {
        Cart cart = getOrCreateCart(userId);
        Optional<Product> optionalProduct = productRepository.findById(productId);

        if (optionalProduct.isEmpty()) {
            throw new RuntimeException("Product not found with id: " + productId);
        }

        Product product = optionalProduct.get();
        Optional<CartItem> optionalItem = cartItemRepository.findByCartAndProduct(cart, product);

        if (optionalItem.isPresent()) {
            CartItem item = optionalItem.get();

            // Set to the new quantity directly (not adding to existing)
            int newQuantity = quantity; // This is the NEW quantity from the request

            if (newQuantity <= 0) {
                cartItemRepository.delete(item);
                cart.getItems().remove(item);
            } else {
                // Check stock availability with new quantity
                if (product.getStock() != null && product.getStock() < newQuantity) {
                    throw new RuntimeException("Insufficient stock for product: " + product.getName());
                }
                item.setQuantity(newQuantity);
                item.updateTotalPrice();
                cartItemRepository.save(item);
            }
            cart.updateCart();
            return cartRepository.save(cart);
        }

        throw new RuntimeException("Item not found in cart");
    }

    @Transactional
    public Cart removeFromCart(Long userId, Long productId) {
        Cart cart = getOrCreateCart(userId);
        Optional<Product> optionalProduct = productRepository.findById(productId);

        if (optionalProduct.isEmpty()) {
            throw new RuntimeException("Product not found with id: " + productId);
        }

        Product product = optionalProduct.get();
        Optional<CartItem> optionalItem = cartItemRepository.findByCartAndProduct(cart, product);

        if (optionalItem.isPresent()) {
            CartItem item = optionalItem.get();
            cartItemRepository.delete(item);
            cart.getItems().remove(item);
            cart.updateCart();
            return cartRepository.save(cart);
        }

        throw new RuntimeException("Item not found in cart");
    }

    @Transactional
    public void clearCart(Long userId) {
        Cart cart = getOrCreateCart(userId);
        cart.getItems().clear();
        cart.updateCart();
        cartRepository.save(cart);
    }

    public Cart getCart(Long userId) {
        return getOrCreateCart(userId);
    }

    public Integer getCartItemCount(Long userId) {
        Cart cart = getOrCreateCart(userId);
        return cart.getItemCount();
    }

    public BigDecimal getCartTotal(Long userId) {
        Cart cart = getOrCreateCart(userId);
        return cart.getTotalPrice();
    }
}