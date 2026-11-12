<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Frequently Asked Questions | Harvesta Supermarket</title>
    <link rel="stylesheet" href="/css/pages/faq.css">
    <jsp:include page="/WEB-INF/views/partials/head-assets.jsp" />
</head>
<body>
<!-- Header -->
<jsp:include page="/WEB-INF/views/partials/navbar.jsp" />

<!-- FAQ Hero Section -->
<section class="faq-hero">
    <div class="container">
        <h1>Frequently Asked Questions</h1>
        <p>Find quick answers to common questions about shopping at Harvesta, delivery services, payment options, and more.</p>
        <div class="search-box">
            <input type="text" placeholder="Search for answers...">
            <button><i class="fas fa-search"></i> Search</button>
        </div>
    </div>
</section>

<!-- FAQ Content -->
<section class="faq-content">
    <div class="container">
        <div class="faq-categories">
            <button class="category-btn active">All Questions</button>
            <button class="category-btn">Shopping</button>
            <button class="category-btn">Delivery</button>
            <button class="category-btn">Payments</button>
            <button class="category-btn">Returns</button>
            <button class="category-btn">Loyalty Program</button>
        </div>

        <!-- Shopping Questions -->
        <div class="faq-section">
            <div class="section-title">
                <div class="section-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h2>Shopping at Harvesta</h2>
            </div>

            <div class="faq-list">
                <div class="faq-item">
                    <div class="faq-question">
                        <span>What are your store hours?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Our stores are open from 7:00 AM to 10:00 PM Monday through Saturday, and from 8:00 AM to 9:00 PM on Sundays. Holiday hours may vary, so please check our website or call your local store for specific holiday schedules.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        <span>Do you offer senior discounts?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Yes, we offer a 10% discount for seniors (65+) every Wednesday. Just present a valid ID at checkout to receive your discount. This discount applies to all regular-priced items and cannot be combined with other promotions.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        <span>Do you price match competitors?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Yes, we offer price matching on identical products from local competitors. Simply show us the current advertised price at the time of purchase, and we'll match it. Some restrictions apply, and this policy does not include online-only retailers or clearance items.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        <span>Do you carry organic and gluten-free products?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Yes, we have a wide selection of organic, gluten-free, and specialty diet products. Look for our designated sections in each store, or use our online shopping tool to filter by dietary preferences. If you can't find what you're looking for, ask our staff for assistance.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delivery Questions -->
        <div class="faq-section">
            <div class="section-title">
                <div class="section-icon">
                    <i class="fas fa-truck"></i>
                </div>
                <h2>Delivery & Pickup Services</h2>
            </div>

            <div class="faq-list">
                <div class="faq-item">
                    <div class="faq-question">
                        <span>What delivery options do you offer?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>We offer several delivery options to suit your needs:
                        <ul>
                            <li><strong>Same-day delivery:</strong> Available for orders placed before 2 PM</li>
                            <li><strong>Next-day delivery:</strong> For orders placed after 2 PM</li>
                            <li><strong>Express delivery:</strong> 2-hour delivery window (additional fee applies)</li>
                            <li><strong>Curbside pickup:</strong> Free pickup at your selected store</li>
                        </ul>
                        Delivery fees start at $4.99, with free delivery on orders over $50.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        <span>How does curbside pickup work?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Curbside pickup is simple and contact-free:
                        <ol>
                            <li>Place your order online or through our app</li>
                            <li>Select your preferred store and pickup time</li>
                            <li>You'll receive a notification when your order is ready</li>
                            <li>When you arrive, park in a designated curbside spot and call the number provided</li>
                            <li>Our staff will bring your order directly to your car</li>
                        </ol>
                        There is no fee for curbside pickup.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        <span>What if an item is out of stock for my delivery?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>If an item you ordered is out of stock, our shoppers will try to contact you to discuss substitution options. You can specify your substitution preferences when placing your order. If we're unable to contact you and no substitution preference is indicated, we'll refund the item to your original payment method.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Questions -->
        <div class="faq-section">
            <div class="section-title">
                <div class="section-icon">
                    <i class="fas fa-credit-card"></i>
                </div>
                <h2>Payments & Billing</h2>
            </div>

            <div class="faq-list">
                <div class="faq-item">
                    <div class="faq-question">
                        <span>What payment methods do you accept?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>We accept various payment methods for your convenience:
                        <ul>
                            <li>All major credit and debit cards (Visa, MasterCard, American Express, Discover)</li>
                            <li>Harvesta gift cards</li>
                            <li>Apple Pay, Google Pay, and Samsung Pay</li>
                            <li>EBT/SNAP benefits (in-store only)</li>
                            <li>Cash (in-store only)</li>
                        </ul>
                        For online orders, we also accept PayPal and Venmo.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        <span>Is my payment information secure?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Yes, we take your security seriously. All online payments are processed through encrypted connections, and we comply with PCI DSS standards to protect your payment information. We never store your complete payment details on our servers. For added security, you can save your payment method for faster checkout, but only the last four digits of your card are stored.</p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        <span>Can I use multiple payment methods for one order?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <p>Yes, you can split payment between multiple methods. For example, you can use a gift card for part of your purchase and pay the remainder with a credit card. In-store, simply inform the cashier how you'd like to split the payment. Online, you'll have the option to apply a gift card or store credit first, then pay the balance with another method.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Contact Section -->
        <div class="contact-section">
            <h2>Still Have Questions?</h2>
            <p>Can't find the answer you're looking for? Our customer service team is here to help.</p>
            <div class="contact-buttons">
                <a href="#" class="contact-btn">
                    <i class="fas fa-envelope"></i> Email Us
                </a>
                <a href="#" class="contact-btn phone">
                    <i class="fas fa-phone"></i> Call 1-800-HARVEST
                </a>
                <a href="#" class="contact-btn">
                    <i class="fas fa-comments"></i> Live Chat
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<jsp:include page="/WEB-INF/views/partials/footer.jsp" />

<script>
    // FAQ Accordion Functionality
    document.querySelectorAll('.faq-question').forEach(question => {
        question.addEventListener('click', () => {
            const faqItem = question.parentElement;
            faqItem.classList.toggle('active');
        });
    });

    // Category Filtering (basic implementation)
    document.querySelectorAll('.category-btn').forEach(button => {
        button.addEventListener('click', () => {
            // Remove active class from all buttons
            document.querySelectorAll('.category-btn').forEach(btn => {
                btn.classList.remove('active');
            });

            // Add active class to clicked button
            button.classList.add('active');

            // In a real implementation, you would filter FAQ items here
            // based on the selected category
        });
    });

    // Search Functionality (basic implementation)
    const searchInput = document.querySelector('.search-box input');
    searchInput.addEventListener('keyup', (e) => {
        if (e.key === 'Enter') {
            const searchTerm = searchInput.value.toLowerCase();

            // In a real implementation, you would search through FAQ items
            // and display only those matching the search term
            alert(`Searching for: ${searchTerm}`);
        }
    });
</script>
</body>
</html>
