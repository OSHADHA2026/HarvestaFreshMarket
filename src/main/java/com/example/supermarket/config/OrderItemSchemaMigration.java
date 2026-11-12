package com.example.supermarket.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Hibernate ddl-auto=update does not always change existing NOT NULL columns to nullable.
 * This ensures order_items can detach from products when a product is deleted.
 */
@Component
public class OrderItemSchemaMigration implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(OrderItemSchemaMigration.class);

    private final JdbcTemplate jdbcTemplate;

    public OrderItemSchemaMigration(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void run(ApplicationArguments args) {
        addColumnIfMissing("product_name", "VARCHAR(255) NULL");
        addColumnIfMissing("product_image", "VARCHAR(500) NULL");
        makeProductIdNullable();
    }

    private void addColumnIfMissing(String column, String definition) {
        try {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.COLUMNS " +
                            "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'order_items' AND COLUMN_NAME = ?",
                    Integer.class,
                    column);
            if (count != null && count == 0) {
                jdbcTemplate.execute("ALTER TABLE order_items ADD COLUMN " + column + " " + definition);
                log.info("Added order_items.{}", column);
            }
        } catch (Exception e) {
            log.warn("Could not add order_items.{}: {}", column, e.getMessage());
        }
    }

    private void makeProductIdNullable() {
        try {
            jdbcTemplate.execute("ALTER TABLE order_items MODIFY COLUMN product_id BIGINT NULL");
            log.info("order_items.product_id allows NULL");
        } catch (Exception e) {
            log.warn("Could not make order_items.product_id nullable: {}", e.getMessage());
        }
    }
}
