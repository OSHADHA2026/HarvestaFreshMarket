package com.example.supermarket.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PaymentServiceTest {

    private final PaymentService paymentService = new PaymentService();

    @Test
    void acceptsValidCardNumbersWithSupportedLengthsAndFormatting() {
        assertTrue(paymentService.isValidCardNumber("4111 1111 1111 1111"));
        assertTrue(paymentService.isValidCardNumber("378282246310005"));
        assertTrue(paymentService.isValidCardNumber("4222 2222 2222 2222"));
    }

    @Test
    void rejectsCardNumbersWithInvalidDigitsOrChecksum() {
        assertFalse(paymentService.isValidCardNumber("4111 1111 1111 1112"));
        assertFalse(paymentService.isValidCardNumber("1234 5678"));
        assertFalse(paymentService.isValidCardNumber("4111-1111-1111-11A1"));
    }
}
