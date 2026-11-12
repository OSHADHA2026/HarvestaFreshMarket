package com.example.supermarket.service;

import com.example.supermarket.model.SavedPaymentMethod;
import com.example.supermarket.model.User;
import com.example.supermarket.repository.SavedPaymentMethodRepository;
import com.example.supermarket.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class SavedPaymentMethodService {

    @Autowired
    private SavedPaymentMethodRepository savedPaymentMethodRepository;

    @Autowired
    private UserRepository userRepository;

    public List<SavedPaymentMethod> getPaymentMethodsForUser(Long userId) {
        return savedPaymentMethodRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
    }

    public SavedPaymentMethod getPaymentMethodForUser(Long paymentId, Long userId) {
        return savedPaymentMethodRepository.findByIdAndUserId(paymentId, userId)
                .orElseThrow(() -> new RuntimeException("Payment method not found"));
    }

    @Transactional
    public SavedPaymentMethod savePaymentMethod(Long userId, Long paymentId, String paymentType,
                                                String cardBrand, String cardNumber, String expiryDate,
                                                String cardholderName, String paypalEmail, String upiId,
                                                boolean setAsDefault) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        SavedPaymentMethod method;
        if (paymentId != null) {
            method = getPaymentMethodForUser(paymentId, userId);
        } else {
            method = new SavedPaymentMethod();
            method.setUser(user);
        }

        String type = paymentType != null ? paymentType.toLowerCase() : "card";
        method.setPaymentType(type);

        if ("card".equals(type)) {
            method.setCardBrand(cardBrand);
            if (cardNumber != null && !cardNumber.replaceAll("\\D", "").isEmpty()) {
                method.setLastFour(extractLastFour(cardNumber));
            } else if (paymentId == null) {
                throw new RuntimeException("Card number is required");
            }
            if (expiryDate != null && !expiryDate.isBlank()) {
                parseExpiry(expiryDate, method);
            } else if (paymentId == null) {
                throw new RuntimeException("Expiry date is required");
            }
            method.setCardholderName(cardholderName);
            method.setPaypalEmail(null);
            method.setUpiId(null);
        } else if ("paypal".equals(type)) {
            if (paypalEmail == null || paypalEmail.isBlank()) {
                throw new RuntimeException("PayPal email is required");
            }
            method.setPaypalEmail(paypalEmail);
            method.setCardBrand(null);
            method.setLastFour(null);
            method.setExpiryMonth(null);
            method.setExpiryYear(null);
            method.setCardholderName(null);
            method.setUpiId(null);
        } else if ("upi".equals(type)) {
            if (upiId == null || upiId.isBlank()) {
                throw new RuntimeException("UPI ID is required");
            }
            method.setUpiId(upiId);
            method.setCardBrand(null);
            method.setLastFour(null);
            method.setExpiryMonth(null);
            method.setExpiryYear(null);
            method.setCardholderName(null);
            method.setPaypalEmail(null);
        }

        method.setUpdatedAt(LocalDateTime.now());
        SavedPaymentMethod saved = savedPaymentMethodRepository.save(method);

        if (setAsDefault || savedPaymentMethodRepository.countByUserId(userId) == 1) {
            setDefaultPaymentMethod(saved.getId(), userId);
            saved = getPaymentMethodForUser(saved.getId(), userId);
        }

        return saved;
    }

    @Transactional
    public void setDefaultPaymentMethod(Long paymentId, Long userId) {
        getPaymentMethodForUser(paymentId, userId);
        List<SavedPaymentMethod> all = savedPaymentMethodRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);

        for (SavedPaymentMethod method : all) {
            method.setIsDefault(method.getId().equals(paymentId));
            method.setUpdatedAt(LocalDateTime.now());
            savedPaymentMethodRepository.save(method);
        }
    }

    @Transactional
    public void deletePaymentMethod(Long paymentId, Long userId) {
        SavedPaymentMethod method = getPaymentMethodForUser(paymentId, userId);
        boolean wasDefault = Boolean.TRUE.equals(method.getIsDefault());
        savedPaymentMethodRepository.delete(method);

        if (wasDefault) {
            List<SavedPaymentMethod> remaining = savedPaymentMethodRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
            if (!remaining.isEmpty()) {
                setDefaultPaymentMethod(remaining.get(0).getId(), userId);
            }
        }
    }

    private String extractLastFour(String cardNumber) {
        if (cardNumber == null) {
            return "0000";
        }
        String digits = cardNumber.replaceAll("\\D", "");
        if (digits.length() < 4) {
            throw new RuntimeException("Invalid card number");
        }
        return digits.substring(digits.length() - 4);
    }

    private void parseExpiry(String expiryDate, SavedPaymentMethod method) {
        if (expiryDate == null || !expiryDate.contains("/")) {
            throw new RuntimeException("Expiry date must be MM/YY");
        }
        String[] parts = expiryDate.split("/");
        method.setExpiryMonth(parts[0].trim());
        String year = parts[1].trim();
        method.setExpiryYear(year.length() == 2 ? "20" + year : year);
    }
}
