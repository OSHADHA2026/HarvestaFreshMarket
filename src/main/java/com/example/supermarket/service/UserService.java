package com.example.supermarket.service;

import com.example.supermarket.model.User;
import com.example.supermarket.repository.CartRepository;
import com.example.supermarket.repository.OrderRepository;
import com.example.supermarket.repository.SavedPaymentMethodRepository;
import com.example.supermarket.repository.UserAddressRepository;
import com.example.supermarket.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private UserAddressRepository userAddressRepository;

    @Autowired
    private SavedPaymentMethodRepository savedPaymentMethodRepository;

    // Remove PasswordEncoder autowiring

    public User registerUser(User user) {
        System.out.println("Attempting to register user: " + user.getEmail());

        // Check if email already exists
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email already registered");
        }

        // Check if username already exists
        if (user.getUsername() != null && userRepository.existsByUsername(user.getUsername())) {
            throw new RuntimeException("Username already taken");
        }

        // No password encoding - store as plain text
        // user.setPassword(user.getPassword()); // Already set
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        User savedUser = userRepository.save(user);
        System.out.println("User registered successfully with ID: " + savedUser.getId());
        return savedUser;
    }

    public User loginUser(String email, String password) {
        System.out.println("Attempting login for: " + email);

        Optional<User> userOptional = userRepository.findByEmail(email);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            // Simple password comparison (plain text)
            if (user.getPassword().equals(password)) {
                System.out.println("Login successful for: " + email);
                return user;
            } else {
                System.out.println("Invalid password for: " + email);
            }
        } else {
            System.out.println("User not found: " + email);
        }
        throw new RuntimeException("Invalid email or password");
    }

    public boolean changePassword(Long userId, String currentPassword, String newPassword) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            User user = userOptional.get();

            // Verify current password (plain text comparison)
            if (!user.getPassword().equals(currentPassword)) {
                throw new RuntimeException("Current password is incorrect");
            }

            // Set new password (plain text)
            user.setPassword(newPassword);
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
            return true;
        }
        throw new RuntimeException("User not found");
    }

    @Transactional
    public boolean deleteAccount(Long userId, String password) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!user.getPassword().equals(password)) {
            throw new RuntimeException("Password is incorrect");
        }

        orderRepository.deleteAll(orderRepository.findByUser(user));
        cartRepository.findByUser(user).ifPresent(cartRepository::delete);
        userAddressRepository.deleteAll(userAddressRepository.findByUserOrderByIsDefaultDescCreatedAtDesc(user));
        savedPaymentMethodRepository.deleteAll(savedPaymentMethodRepository.findByUserOrderByIsDefaultDescCreatedAtDesc(user));
        userRepository.delete(user);
        return true;
    }

    public User createAdminIfNotExists(String email, String password) {
        Optional<User> existing = userRepository.findByEmail(email);
        if (existing.isPresent()) {
            User user = existing.get();
            if (!"ADMIN".equals(user.getRole())) {
                user.setRole("ADMIN");
                user.setUpdatedAt(LocalDateTime.now());
                return userRepository.save(user);
            }
            return user;
        }
        User admin = new User();
        admin.setFirstName("Admin");
        admin.setLastName("User");
        admin.setEmail(email);
        admin.setPassword(password); // Note: plain text per current app
        admin.setRole("ADMIN");
        admin.setCreatedAt(LocalDateTime.now());
        admin.setUpdatedAt(LocalDateTime.now());
        return userRepository.save(admin);
    }

    public boolean isAdmin(User user) {
        return user != null && "ADMIN".equals(user.getRole());
    }

    // Rest of your existing methods
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }

    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public User updateUser(Long id, User userDetails) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setFirstName(userDetails.getFirstName());
        user.setLastName(userDetails.getLastName());
        user.setPhone(userDetails.getPhone());
        user.setAddress(userDetails.getAddress());
        user.setUpdatedAt(LocalDateTime.now());

        return userRepository.save(user);
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    public void updateUserProfile(Long userId, String firstName, String lastName, String phone, String address) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        user.setAddress(address);
        user.setUpdatedAt(LocalDateTime.now());

        userRepository.save(user);
    }
}