<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Us | Harvesta Fresh Market</title>
    <link rel="stylesheet" href="/css/pages/contact.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>

<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<div class="contact-header">
    <h1 class="contact-title">Contact Us</h1>
    <p class="contact-subtitle">We're here to help! Get in touch with our friendly team</p>
</div>

<div class="contact-container">
    <div class="contact-grid">
        <!-- Contact Information -->
        <div class="contact-info">
            <h2 class="info-title">Get In Touch</h2>

            <div class="info-item">
                <div class="info-icon"><i class="fa-solid fa-phone" aria-hidden="true"></i></div>
                <div class="info-content">
                    <div class="info-label">Phone Numbers</div>
                    <div class="info-text">
                        <div>Customer Service: <a href="tel:1-800-123-4567" class="info-link">1-800-123-4567</a></div>
                        <div>Delivery Support: <a href="tel:1-800-123-4568" class="info-link">1-800-123-4568</a></div>
                        <div>Corporate Office: <a href="tel:1-800-123-4569" class="info-link">1-800-123-4569</a></div>
                    </div>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon"><i class="fa-solid fa-envelope" aria-hidden="true"></i></div>
                <div class="info-content">
                    <div class="info-label">Email Addresses</div>
                    <div class="info-text">
                        <div>General Inquiries: <a href="mailto:info@supermarket.com" class="info-link">info@supermarket.com</a></div>
                        <div>Customer Support: <a href="mailto:support@supermarket.com" class="info-link">support@supermarket.com</a></div>
                        <div>Delivery Issues: <a href="mailto:delivery@supermarket.com" class="info-link">delivery@supermarket.com</a></div>
                    </div>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon"><i class="fa-solid fa-building" aria-hidden="true"></i></div>
                <div class="info-content">
                    <div class="info-label">Headquarters</div>
                    <div class="info-text">
                        123 Commerce Street<br>
                        Suite 500<br>
                        New York, NY 10001<br>
                        United States
                    </div>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon"><i class="fa-solid fa-clock" aria-hidden="true"></i></div>
                <div class="info-content">
                    <div class="info-label">Business Hours</div>
                    <div class="info-text">
                        <div class="hours-list">
                            <div class="hour-item">
                                <span class="hour-day">Monday - Friday</span>
                                <span class="hour-time">8:00 AM - 10:00 PM</span>
                            </div>
                            <div class="hour-item">
                                <span class="hour-day">Saturday</span>
                                <span class="hour-time">9:00 AM - 9:00 PM</span>
                            </div>
                            <div class="hour-item">
                                <span class="hour-day">Sunday</span>
                                <span class="hour-time">10:00 AM - 6:00 PM</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="info-item">
                <div class="info-icon"><i class="fa-solid fa-truck" aria-hidden="true"></i></div>
                <div class="info-content">
                    <div class="info-label">Delivery Support</div>
                    <div class="info-text">
                        Having issues with your delivery? Our delivery support team is available:<br>
                        <strong>7:00 AM - 11:00 PM Daily</strong><br>
                        Call: <a href="tel:1-800-DELIVER" class="info-link">1-800-DELIVER</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Contact Form -->
        <div class="contact-form">
            <h2 class="form-title">Send Us a Message</h2>

            <div class="success-message" id="successMessage">
                Thank you for your message! We'll get back to you within 24 hours.
            </div>

            <form id="contactForm">
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">First Name *</label>
                        <input type="text" id="firstName" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Last Name *</label>
                        <input type="text" id="lastName" class="form-input" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Email Address *</label>
                    <input type="email" id="email" class="form-input" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" class="form-input">
                </div>

                <div class="form-group">
                    <label for="subject">Subject *</label>
                    <select id="subject" class="form-select" required>
                        <option value="">Select a subject</option>
                        <option value="general">General Inquiry</option>
                        <option value="delivery">Delivery Issue</option>
                        <option value="product">Product Question</option>
                        <option value="return">Return/Refund</option>
                        <option value="technical">Technical Support</option>
                        <option value="feedback">Feedback/Suggestion</option>
                        <option value="other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="message">Message *</label>
                    <textarea id="message" class="form-textarea" placeholder="Please describe your inquiry in detail..." required></textarea>
                </div>

                <button type="submit" class="btn-submit">Send Message</button>
            </form>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="faq-section">
        <h2 class="section-title">Frequently Asked Questions</h2>
        <div class="faq-grid">
            <div class="faq-item" onclick="toggleFAQ(this)">
                <div class="faq-question">
                    How long does delivery take?
                    <span class="faq-toggle">+</span>
                </div>
                <div class="faq-answer">
                    We offer 2-hour delivery for orders placed before 8 PM. For orders after 8 PM, delivery will be scheduled for the next morning between 7-9 AM.
                </div>
            </div>

            <div class="faq-item" onclick="toggleFAQ(this)">
                <div class="faq-question">
                    What is your return policy?
                    <span class="faq-toggle">+</span>
                </div>
                <div class="faq-answer">
                    We accept returns within 7 days of delivery for most items. Perishable goods can be returned within 24 hours if there are quality issues. Please contact our support team for return instructions.
                </div>
            </div>

            <div class="faq-item" onclick="toggleFAQ(this)">
                <div class="faq-question">
                    Do you offer international delivery?
                    <span class="faq-toggle">+</span>
                </div>
                <div class="faq-answer">
                    Currently, we only deliver within the United States. We're working on expanding our services to Canada and Mexico in the near future.
                </div>
            </div>

            <div class="faq-item" onclick="toggleFAQ(this)">
                <div class="faq-question">
                    How can I track my order?
                    <span class="faq-toggle">+</span>
                </div>
                <div class="faq-answer">
                    You can track your order through your account on our website or mobile app. We also send real-time SMS and email notifications about your delivery status.
                </div>
            </div>

            <div class="faq-item" onclick="toggleFAQ(this)">
                <div class="faq-question">
                    What payment methods do you accept?
                    <span class="faq-toggle">+</span>
                </div>
                <div class="faq-answer">
                    We accept all major credit cards (Visa, MasterCard, American Express), PayPal, Apple Pay, Google Pay, and SuperMarket gift cards.
                </div>
            </div>

            <div class="faq-item" onclick="toggleFAQ(this)">
                <div class="faq-question">
                    Can I modify or cancel my order?
                    <span class="faq-toggle">+</span>
                </div>
                <div class="faq-answer">
                    You can modify or cancel your order within 30 minutes of placing it. After that, please contact our delivery support team immediately, and we'll do our best to accommodate your request.
                </div>
            </div>
        </div>
    </div>

    <!-- Map Section -->
    <div class="map-section">
        <div class="map-header">
            <h3 class="map-title">Visit Our Headquarters</h3>
        </div>
        <div class="map-container" style="position:relative;">
            <!-- Fallback shown only if the embedded map cannot load -->
            <div style="text-align: center; padding: 0 16px;">
                <div style="font-size: 48px; margin-bottom: 16px;"><i class="fa-solid fa-map-location-dot" aria-hidden="true"></i></div>
                <p style="margin:0 0 6px;">Map unavailable right now</p>
                <p style="font-size: 14px; margin: 0 0 14px;">123 Commerce Street, New York, NY 10001</p>
                <a href="https://www.google.com/maps/search/?api=1&amp;query=123+Commerce+Street%2C+New+York%2C+NY+10001"
                   target="_blank" rel="noopener" style="color:var(--hv-text-strong, #1d6b49); font-weight:700;">Open in Google Maps</a>
            </div>
            <iframe title="Map showing Harvesta headquarters"
                    src="https://www.google.com/maps?q=123+Commerce+Street%2C+New+York%2C+NY+10001&amp;z=15&amp;output=embed"
                    style="position:absolute; inset:0; width:100%; height:100%; border:0;"
                    loading="lazy" allowfullscreen referrerpolicy="no-referrer-when-downgrade"></iframe>
        </div>
    </div>

    <!-- Emergency Contact -->
    <div class="emergency-contact">
        <h3 class="emergency-title"><i class="fa-solid fa-triangle-exclamation" aria-hidden="true"></i> Urgent Delivery Issue?</h3>
        <p class="emergency-text">If you're experiencing an urgent issue with your current delivery, contact our emergency support line immediately.</p>
        <a href="tel:1-800-EMERGENCY" class="btn-emergency">Call Emergency Support: 1-800-EMERGENCY</a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script src="/js/pages/contact.js"></script>

</body>
</html>
