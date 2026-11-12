package com.example.supermarket.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "saved_payment_methods")
public class SavedPaymentMethod {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "payment_type", length = 20, nullable = false)
    private String paymentType;

    @Column(name = "card_brand", length = 30)
    private String cardBrand;

    @Column(name = "last_four", length = 4)
    private String lastFour;

    @Column(name = "expiry_month", length = 2)
    private String expiryMonth;

    @Column(name = "expiry_year", length = 4)
    private String expiryYear;

    @Column(name = "cardholder_name", length = 100)
    private String cardholderName;

    @Column(name = "paypal_email", length = 100)
    private String paypalEmail;

    @Column(name = "upi_id", length = 100)
    private String upiId;

    @Column(name = "is_default", nullable = false)
    private Boolean isDefault = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public SavedPaymentMethod() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public String getDisplayLabel() {
        if ("card".equalsIgnoreCase(paymentType)) {
            String brand = cardBrand != null ? cardBrand.substring(0, 1).toUpperCase() + cardBrand.substring(1) : "Card";
            return brand + " ending in " + (lastFour != null ? lastFour : "****");
        }
        if ("paypal".equalsIgnoreCase(paymentType)) {
            return "PayPal - " + (paypalEmail != null ? paypalEmail : "");
        }
        if ("upi".equalsIgnoreCase(paymentType)) {
            return "UPI - " + (upiId != null ? upiId : "");
        }
        return paymentType;
    }

    public String getExpiryDisplay() {
        if (expiryMonth != null && expiryYear != null) {
            String year = expiryYear.length() == 4 ? expiryYear.substring(2) : expiryYear;
            return expiryMonth + "/" + year;
        }
        return "";
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getPaymentType() { return paymentType; }
    public void setPaymentType(String paymentType) { this.paymentType = paymentType; }

    public String getCardBrand() { return cardBrand; }
    public void setCardBrand(String cardBrand) { this.cardBrand = cardBrand; }

    public String getLastFour() { return lastFour; }
    public void setLastFour(String lastFour) { this.lastFour = lastFour; }

    public String getExpiryMonth() { return expiryMonth; }
    public void setExpiryMonth(String expiryMonth) { this.expiryMonth = expiryMonth; }

    public String getExpiryYear() { return expiryYear; }
    public void setExpiryYear(String expiryYear) { this.expiryYear = expiryYear; }

    public String getCardholderName() { return cardholderName; }
    public void setCardholderName(String cardholderName) { this.cardholderName = cardholderName; }

    public String getPaypalEmail() { return paypalEmail; }
    public void setPaypalEmail(String paypalEmail) { this.paypalEmail = paypalEmail; }

    public String getUpiId() { return upiId; }
    public void setUpiId(String upiId) { this.upiId = upiId; }

    public Boolean getIsDefault() { return isDefault; }
    public void setIsDefault(Boolean isDefault) { this.isDefault = isDefault; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
