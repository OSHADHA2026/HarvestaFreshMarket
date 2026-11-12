package com.example.supermarket.service;

import com.example.supermarket.model.Order;
import com.example.supermarket.model.SavedPaymentMethod;
import com.example.supermarket.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class PaymentService {

    private static final String DEMO_CARD_NUMBER = "4222222222222222";

    @Autowired
    private OrderRepository orderRepository;

    public boolean processPayment(Order order, String cardNumber, String expiryDate,
                                  String cvv, String cardHolderName) {
        return processCardPayment(order, cardNumber, expiryDate, cvv, cardHolderName, true);
    }

    private boolean processCardPayment(Order order, String cardNumber, String expiryDate,
                                       String cvv, String cardHolderName, boolean verifyChecksum) {
        if (cardNumber == null || !cardNumber.replaceAll("[\\s-]", "").matches("\\d{13,19}")
                || (verifyChecksum && !isValidCardNumber(cardNumber))) {
            throw new RuntimeException("Invalid card number");
        }

        if (expiryDate == null || !expiryDate.matches("^(0[1-9]|1[0-2])/[0-9]{2}$")) {
            throw new RuntimeException("Invalid expiry date format (MM/YY)");
        }

        if (cvv == null || !cvv.matches("^[0-9]{3,4}$")) {
            throw new RuntimeException("Invalid CVV");
        }

        if (cardHolderName == null || cardHolderName.trim().isEmpty()) {
            throw new RuntimeException("Card holder name is required");
        }

        // Simulate payment processing
        try {
            // In a real application, you would integrate with a payment gateway here
            // For demo purposes, we'll simulate a successful payment 95% of the time

            Thread.sleep(2000); // Simulate processing time

            double failureRate = 0.05; // 5% failure rate for demo
            if (Math.random() < failureRate) {
                throw new RuntimeException("Payment declined by bank");
            }

            // Update order payment status
            order.setPaymentStatus("COMPLETED");
            order.setOrderStatus("PROCESSING");
            order.setUpdatedAt(LocalDateTime.now());
            orderRepository.save(order);

            return true;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("Payment processing interrupted");
        }
    }

    public boolean processPaypalPayment(Order order, String email) {
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new RuntimeException("Invalid PayPal email");
        }

        // Simulate PayPal payment processing
        try {
            Thread.sleep(2000);

            order.setPaymentStatus("COMPLETED");
            order.setOrderStatus("PROCESSING");
            order.setUpdatedAt(LocalDateTime.now());
            orderRepository.save(order);

            return true;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("Payment processing interrupted");
        }
    }

    public boolean processSavedCardPayment(Order order, SavedPaymentMethod saved, String cvv) {
        if (saved == null || !"card".equalsIgnoreCase(saved.getPaymentType())) {
            throw new RuntimeException("Invalid saved card");
        }
        if (cvv == null || !cvv.matches("^[0-9]{3,4}$")) {
            throw new RuntimeException("Invalid CVV");
        }
        if (saved.getLastFour() == null || saved.getExpiryMonth() == null || saved.getExpiryYear() == null) {
            throw new RuntimeException("Saved card is incomplete");
        }

        String year = saved.getExpiryYear();
        String shortYear = year.length() == 4 ? year.substring(2) : year;
        String expiryDate = saved.getExpiryMonth() + "/" + shortYear;
        String cardNumber = "000000000000" + saved.getLastFour();
        String cardHolderName = saved.getCardholderName() != null ? saved.getCardholderName() : "Cardholder";

        return processCardPayment(order, cardNumber, expiryDate, cvv, cardHolderName, false);
    }

    public boolean processApplePayPayment(Order order, String applePayToken) {
        if (applePayToken == null || applePayToken.trim().isEmpty()) {
            throw new RuntimeException("Invalid Apple Pay token");
        }

        // Simulate Apple Pay payment processing
        try {
            Thread.sleep(2000);

            order.setPaymentStatus("COMPLETED");
            order.setOrderStatus("PROCESSING");
            order.setUpdatedAt(LocalDateTime.now());
            orderRepository.save(order);

            return true;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("Payment processing interrupted");
        }
    }

    public boolean validateCard(String cardNumber, String expiryDate, String cvv) {
        if (!isValidCardNumber(cardNumber)) {
            return false;
        }

        if (expiryDate == null || !expiryDate.matches("^(0[1-9]|1[0-2])/[0-9]{2}$")) {
            return false;
        }

        // Check expiry date
        String[] parts = expiryDate.split("/");
        int month = Integer.parseInt(parts[0]);
        int year = Integer.parseInt("20" + parts[1]);

        LocalDateTime now = LocalDateTime.now();
        if (year < now.getYear()) {
            return false;
        }
        if (year == now.getYear() && month < now.getMonthValue()) {
            return false;
        }

        if (cvv == null || !cvv.matches("^[0-9]{3,4}$")) {
            return false;
        }

        return true;
    }

    public boolean isValidCardNumber(String cardNumber) {
        if (cardNumber == null) {
            return false;
        }

        String digits = cardNumber.replaceAll("[\\s-]", "");
        if (!digits.matches("\\d{13,19}")) {
            return false;
        }
        if (DEMO_CARD_NUMBER.equals(digits)) {
            return true;
        }

        int sum = 0;
        boolean doubleDigit = false;
        for (int i = digits.length() - 1; i >= 0; i--) {
            int digit = digits.charAt(i) - '0';
            if (doubleDigit) {
                digit *= 2;
                if (digit > 9) {
                    digit -= 9;
                }
            }
            sum += digit;
            doubleDigit = !doubleDigit;
        }
        return sum % 10 == 0;
    }

    public Optional<Order> validateOrderPayment(Long orderId) {
        Optional<Order> optionalOrder = orderRepository.findById(orderId);
        if (optionalOrder.isPresent()) {
            Order order = optionalOrder.get();
            if ("COMPLETED".equals(order.getPaymentStatus())) {
                return optionalOrder;
            }
        }
        return Optional.empty();
    }
}