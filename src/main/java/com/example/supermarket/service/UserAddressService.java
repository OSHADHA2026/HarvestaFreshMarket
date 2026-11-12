package com.example.supermarket.service;

import com.example.supermarket.model.User;
import com.example.supermarket.model.UserAddress;
import com.example.supermarket.repository.UserAddressRepository;
import com.example.supermarket.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class UserAddressService {

    @Autowired
    private UserAddressRepository userAddressRepository;

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public List<UserAddress> getAddressesForUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        List<UserAddress> addresses = userAddressRepository.findByUserOrderByIsDefaultDescCreatedAtDesc(user);

        if (addresses.isEmpty()) {
            addresses = seedFromUserProfile(user);
        }

        return addresses;
    }

    @Transactional
    protected List<UserAddress> seedFromUserProfile(User user) {
        if (user.getAddress() == null || user.getAddress().isBlank()) {
            return List.of();
        }

        UserAddress address = new UserAddress();
        address.setUser(user);
        address.setLabel("home");
        address.setFullName(user.getFirstName() + " " + user.getLastName());
        address.setPhone(user.getPhone());
        address.setAddressLine1(user.getAddress());
        address.setCity(user.getCity() != null && !user.getCity().isBlank() ? user.getCity() : "N/A");
        address.setState(user.getState() != null && !user.getState().isBlank() ? user.getState() : "N/A");
        address.setZipCode(user.getZipCode() != null && !user.getZipCode().isBlank() ? user.getZipCode() : "00000");
        address.setIsDefault(true);

        return List.of(userAddressRepository.save(address));
    }

    public UserAddress getAddressForUser(Long addressId, Long userId) {
        return userAddressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() -> new RuntimeException("Address not found"));
    }

    @Transactional
    public UserAddress saveAddress(Long userId, Long addressId, String label, String fullName, String phone,
                                   String addressLine1, String addressLine2, String city, String state,
                                   String zipCode, String landmark, boolean setAsDefault) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        UserAddress address;
        if (addressId != null) {
            address = getAddressForUser(addressId, userId);
        } else {
            address = new UserAddress();
            address.setUser(user);
        }

        address.setLabel(label != null ? label : "home");
        address.setFullName(fullName);
        address.setPhone(phone);
        address.setAddressLine1(addressLine1);
        address.setAddressLine2(addressLine2);
        address.setCity(city);
        address.setState(state);
        address.setZipCode(zipCode);
        address.setLandmark(landmark);
        address.setUpdatedAt(LocalDateTime.now());

        UserAddress saved = userAddressRepository.save(address);

        if (setAsDefault || userAddressRepository.countByUserId(userId) == 1) {
            setDefaultAddress(saved.getId(), userId);
            saved = getAddressForUser(saved.getId(), userId);
        }

        return saved;
    }

    @Transactional
    public void setDefaultAddress(Long addressId, Long userId) {
        UserAddress address = getAddressForUser(addressId, userId);
        List<UserAddress> all = userAddressRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);

        for (UserAddress a : all) {
            a.setIsDefault(a.getId().equals(addressId));
            a.setUpdatedAt(LocalDateTime.now());
            userAddressRepository.save(a);
        }

        User user = address.getUser();
        user.setAddress(address.getFormattedAddress());
        user.setCity(address.getCity());
        user.setState(address.getState());
        user.setZipCode(address.getZipCode());
        if (address.getPhone() != null && !address.getPhone().isBlank()) {
            user.setPhone(address.getPhone());
        }
        user.setUpdatedAt(LocalDateTime.now());
        userRepository.save(user);
    }

    @Transactional
    public void deleteAddress(Long addressId, Long userId) {
        UserAddress address = getAddressForUser(addressId, userId);
        boolean wasDefault = Boolean.TRUE.equals(address.getIsDefault());
        userAddressRepository.delete(address);

        if (wasDefault) {
            List<UserAddress> remaining = userAddressRepository.findByUserIdOrderByIsDefaultDescCreatedAtDesc(userId);
            if (!remaining.isEmpty()) {
                setDefaultAddress(remaining.get(0).getId(), userId);
            }
        }
    }
}
