package com.example.supermarket.repository;

import com.example.supermarket.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username); // Add this method
    boolean existsByEmail(String email);
    boolean existsByUsername(String username); // Add this method for consistency
}