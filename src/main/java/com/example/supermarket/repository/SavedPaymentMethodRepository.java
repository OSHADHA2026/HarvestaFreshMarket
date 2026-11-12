package com.example.supermarket.repository;

import com.example.supermarket.model.SavedPaymentMethod;
import com.example.supermarket.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SavedPaymentMethodRepository extends JpaRepository<SavedPaymentMethod, Long> {
    List<SavedPaymentMethod> findByUserOrderByIsDefaultDescCreatedAtDesc(User user);
    List<SavedPaymentMethod> findByUserIdOrderByIsDefaultDescCreatedAtDesc(Long userId);
    Optional<SavedPaymentMethod> findByIdAndUserId(Long id, Long userId);
    long countByUserId(Long userId);
}
