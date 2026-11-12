package com.example.supermarket.repository;

import com.example.supermarket.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    List<Product> findByCategory(String category);
    List<Product> findByIsFeaturedTrue();
    List<Product> findByIsDealTrue();

    @Query("SELECT p FROM Product p WHERE " +
            "(:category IS NULL OR p.category = :category) AND " +
            "(:minPrice IS NULL OR p.price >= :minPrice) AND " +
            "(:maxPrice IS NULL OR p.price <= :maxPrice) AND " +
            "(:search IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(p.description) LIKE LOWER(CONCAT('%', :search, '%')))")
    List<Product> searchProducts(@Param("category") String category,
                                 @Param("minPrice") Double minPrice,
                                 @Param("maxPrice") Double maxPrice,
                                 @Param("search") String search);

    // Alternative: Separate query for inStock filtering
    @Query("SELECT p FROM Product p WHERE " +
            "(:category IS NULL OR p.category = :category) AND " +
            "(:minPrice IS NULL OR p.price >= :minPrice) AND " +
            "(:maxPrice IS NULL OR p.price <= :maxPrice) AND " +
            "(:search IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(p.description) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
            "(:inStock = TRUE AND p.stock > 0 OR :inStock = FALSE)")
    List<Product> searchProductsWithStock(@Param("category") String category,
                                          @Param("minPrice") Double minPrice,
                                          @Param("maxPrice") Double maxPrice,
                                          @Param("search") String search,
                                          @Param("inStock") Boolean inStock);

    // In ProductRepository.java, add this method:
    @Query("SELECT p FROM Product p WHERE p.isDeal = true AND " +
            "(p.dealExpiry IS NULL OR p.dealExpiry > :now) " +
            "ORDER BY p.dealExpiry ASC")
    List<Product> findActiveDeals(@Param("now") LocalDateTime now);

    List<Product> findByCategoryAndStockGreaterThan(String category, Integer stock);

    Optional<Product> findByName(String name);

    // Find products by stock status
    List<Product> findByStockGreaterThan(Integer stock);
    List<Product> findByStockLessThanEqual(Integer stock);

    // Add this method for multiple categories
    List<Product> findByCategoryIn(List<String> categories);

    // Update the search query to handle rating
    @Query("SELECT p FROM Product p WHERE " +
            "(:category IS NULL OR p.category = :category) AND " +
            "(:minPrice IS NULL OR p.price >= :minPrice) AND " +
            "(:maxPrice IS NULL OR p.price <= :maxPrice) AND " +
            "(:search IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
            "LOWER(p.description) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
            "(:inStock = TRUE AND p.stock > 0 OR :inStock = FALSE AND (p.stock IS NULL OR p.stock <= 0)) AND " +
            "(:rating IS NULL OR p.rating >= :rating)")
    List<Product> searchProductsWithStock(@Param("category") String category,
                                          @Param("minPrice") Double minPrice,
                                          @Param("maxPrice") Double maxPrice,
                                          @Param("search") String search,
                                          @Param("inStock") Boolean inStock,
                                          @Param("rating") Double rating);


}