package com.example.supermarket.service;

import com.example.supermarket.model.*;
import com.example.supermarket.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private CartService cartService;

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public Order createOrder(Long userId, String shippingAddress, String paymentMethod,
                             String billingAddress, String notes) {

        // Get user cart
        Cart cart = cartService.getCart(userId);

        if (cart.getItems().isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        // Get user
        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        User user = optionalUser.get();

        // Create order
        Order order = new Order();
        order.setUser(user);
        order.setShippingAddress(shippingAddress);
        order.setPaymentMethod(paymentMethod);
        order.setBillingAddress(billingAddress != null ? billingAddress : shippingAddress);
        order.setNotes(notes);

        // Set delivery fee (free for orders over $50)
        BigDecimal subtotal = cart.getTotalPrice();
        BigDecimal deliveryFee = subtotal.compareTo(BigDecimal.valueOf(50)) >= 0 ?
                BigDecimal.ZERO : BigDecimal.valueOf(4.99);
        order.setDeliveryFee(deliveryFee);

        // Calculate discount (example: $2 discount for orders over $30)
        BigDecimal discount = subtotal.compareTo(BigDecimal.valueOf(30)) >= 0 ?
                BigDecimal.valueOf(2.00) : BigDecimal.ZERO;
        order.setDiscount(discount);

        // Create order items from cart items
        for (CartItem cartItem : cart.getItems()) {
            Product product = cartItem.getProduct();

            // Check stock before creating order
            if (product.getStock() < cartItem.getQuantity()) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }

            OrderItem orderItem = new OrderItem(product, cartItem.getQuantity());
            orderItem.setOrder(order);
            order.getItems().add(orderItem);

            // Update product stock
            product.setStock(product.getStock() - cartItem.getQuantity());
            product.setSoldCount(product.getSoldCount() + cartItem.getQuantity());
            product.setUpdatedAt(LocalDateTime.now());
            productRepository.save(product);
        }

        // Calculate order totals
        order.calculateTotals();

        // Set estimated delivery (2 hours from now)
        order.setEstimatedDelivery(LocalDateTime.now().plusHours(2));

        // Save order
        Order savedOrder = orderRepository.save(order);

        // Clear cart after successful order creation
        cartService.clearCart(userId);

        return savedOrder;
    }

    public List<Order> getUserOrders(Long userId) {
        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isPresent()) {
            return orderRepository.findByUserOrderByCreatedAtDesc(optionalUser.get());
        }
        throw new RuntimeException("User not found");
    }

    public Optional<Order> getOrderById(Long orderId) {
        return orderRepository.findById(orderId);
    }

    public Optional<Order> getOrderByNumber(String orderNumber) {
        return orderRepository.findByOrderNumber(orderNumber);
    }

    public Order updateOrderStatus(Long orderId, String status) {
        Optional<Order> optionalOrder = orderRepository.findById(orderId);
        if (optionalOrder.isPresent()) {
            Order order = optionalOrder.get();
            order.setOrderStatus(status);
            order.setUpdatedAt(LocalDateTime.now());

            if ("DELIVERED".equals(status)) {
                order.setDeliveredAt(LocalDateTime.now());
            }

            return orderRepository.save(order);
        }
        throw new RuntimeException("Order not found with id: " + orderId);
    }

    public Order updatePaymentStatus(Long orderId, String paymentStatus) {
        Optional<Order> optionalOrder = orderRepository.findById(orderId);
        if (optionalOrder.isPresent()) {
            Order order = optionalOrder.get();
            order.setPaymentStatus(paymentStatus);
            order.setUpdatedAt(LocalDateTime.now());

            // If payment completed, update order status to PROCESSING
            if ("COMPLETED".equals(paymentStatus)) {
                order.setOrderStatus("PROCESSING");
            }

            return orderRepository.save(order);
        }
        throw new RuntimeException("Order not found with id: " + orderId);
    }

    @Transactional
    public Order cancelOrder(Long orderId) {
        Optional<Order> optionalOrder = orderRepository.findById(orderId);
        if (optionalOrder.isPresent()) {
            Order order = optionalOrder.get();

            // Check if order can be cancelled
            if (!"PENDING".equals(order.getOrderStatus()) && !"PROCESSING".equals(order.getOrderStatus())) {
                throw new RuntimeException("Order cannot be cancelled at this stage");
            }

            // Restore product stock (skip if product was removed from catalog)
            for (OrderItem item : order.getItems()) {
                Product product = item.getProduct();
                if (product == null) {
                    continue;
                }
                product.setStock(product.getStock() + item.getQuantity());
                product.setSoldCount(Math.max(0, product.getSoldCount() - item.getQuantity()));
                productRepository.save(product);
            }

            order.setOrderStatus("CANCELLED");
            order.setPaymentStatus("REFUNDED");
            order.setUpdatedAt(LocalDateTime.now());

            return orderRepository.save(order);
        }
        throw new RuntimeException("Order not found with id: " + orderId);
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public List<Order> getOrdersByStatus(String status) {
        return orderRepository.findByOrderStatus(status);
    }

    @Transactional
    public Order createOrderFromCart(Long userId) {
        // Get user cart
        Cart cart = cartService.getCart(userId);

        if (cart.getItems().isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        // Get user
        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        User user = optionalUser.get();

        // Create order
        Order order = new Order();
        order.setUser(user);

        // Use user's default address or empty string
        String defaultAddress = user.getAddress() != null ? user.getAddress() : "";
        order.setShippingAddress(defaultAddress);
        order.setPaymentMethod("card"); // Default payment method
        order.setBillingAddress(defaultAddress);
        order.setNotes("");

        // Set delivery fee (free for orders over $50)
        BigDecimal subtotal = cart.getTotalPrice();
        BigDecimal deliveryFee = subtotal.compareTo(BigDecimal.valueOf(50)) >= 0 ?
                BigDecimal.ZERO : BigDecimal.valueOf(4.99);
        order.setDeliveryFee(deliveryFee);

        // Calculate discount (example: $2 discount for orders over $30)
        BigDecimal discount = subtotal.compareTo(BigDecimal.valueOf(30)) >= 0 ?
                BigDecimal.valueOf(2.00) : BigDecimal.ZERO;
        order.setDiscount(discount);

        // Create order items from cart items
        for (CartItem cartItem : cart.getItems()) {
            Product product = cartItem.getProduct();

            // Check stock before creating order
            if (product.getStock() < cartItem.getQuantity()) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }

            OrderItem orderItem = new OrderItem(product, cartItem.getQuantity());
            orderItem.setOrder(order);
            order.getItems().add(orderItem);

            // Update product stock
            product.setStock(product.getStock() - cartItem.getQuantity());
            product.setSoldCount(product.getSoldCount() + cartItem.getQuantity());
            product.setUpdatedAt(LocalDateTime.now());
            productRepository.save(product);
        }

        // Calculate order totals
        order.calculateTotals();

        // Set estimated delivery (2 hours from now)
        order.setEstimatedDelivery(LocalDateTime.now().plusHours(2));

        // Set default statuses
        order.setOrderStatus("PENDING");
        order.setPaymentStatus("PENDING");

        // Save order
        Order savedOrder = orderRepository.save(order);

        // Clear cart after successful order creation
        cartService.clearCart(userId);

        return savedOrder;
    }
}