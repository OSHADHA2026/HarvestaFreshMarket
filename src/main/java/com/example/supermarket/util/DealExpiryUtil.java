package com.example.supermarket.util;

import com.example.supermarket.model.Product;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public final class DealExpiryUtil {

    private static final DateTimeFormatter DATE_TIME_MINUTES =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    private DealExpiryUtil() {
    }

    public static LocalDateTime parse(String combined, String date, String time) {
        if (combined != null && !combined.isBlank()) {
            return parseCombined(combined.trim());
        }
        if (date != null && !date.isBlank()) {
            LocalDate localDate = LocalDate.parse(date.trim());
            LocalTime localTime = parseTime(time);
            return LocalDateTime.of(localDate, localTime);
        }
        return null;
    }

    private static LocalTime parseTime(String time) {
        if (time == null || time.isBlank()) {
            return LocalTime.of(23, 59);
        }
        String value = time.trim();
        if (value.length() == 5) {
            return LocalTime.parse(value);
        }
        if (value.length() >= 5) {
            return LocalTime.parse(value.substring(0, 5));
        }
        throw new DateTimeParseException("Invalid time", value, 0);
    }

    private static LocalDateTime parseCombined(String value) {
        try {
            if (value.length() <= 16) {
                return LocalDateTime.parse(value, DATE_TIME_MINUTES);
            }
            return LocalDateTime.parse(value, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        } catch (DateTimeParseException ex) {
            return LocalDateTime.parse(value.replace(' ', 'T'), DATE_TIME_MINUTES);
        }
    }

    public static void applyForCreate(Product product, boolean isDeal, String combined, String date, String time) {
        product.setIsDeal(isDeal);
        if (!isDeal) {
            product.setDealExpiry(null);
            return;
        }
        LocalDateTime expiry = parse(combined, date, time);
        if (expiry == null) {
            throw new IllegalArgumentException("Deal expiry date and time are required for deal products");
        }
        product.setDealExpiry(expiry);
    }

    public static void applyForUpdate(Product product, boolean isDeal, String combined, String date, String time) {
        product.setIsDeal(isDeal);
        if (!isDeal) {
            product.setDealExpiry(null);
            return;
        }
        LocalDateTime expiry = parse(combined, date, time);
        if (expiry != null) {
            product.setDealExpiry(expiry);
        }
    }

    public static String formatDate(LocalDateTime expiry) {
        return expiry == null ? "" : expiry.toLocalDate().toString();
    }

    public static String formatTime(LocalDateTime expiry) {
        if (expiry == null) {
            return "";
        }
        LocalTime time = expiry.toLocalTime().withSecond(0).withNano(0);
        return time.format(DateTimeFormatter.ofPattern("HH:mm"));
    }
}
