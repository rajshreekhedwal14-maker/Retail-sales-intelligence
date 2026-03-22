-- ============================================================
-- RETAIL SALES & CUSTOMER INTELLIGENCE SYSTEM
-- 02_sample_data.sql — Sample Data Only
-- ============================================================

-- 1. CATEGORIES
INSERT INTO categories (category_name, parent_category_id) VALUES
('Electronics',     NULL),
('Clothing',        NULL),
('Home & Kitchen',  NULL),
('Laptops',         1),
('Smartphones',     1),
('Men''s Wear',     2),
('Women''s Wear',   2);

-- 2. PRODUCTS
INSERT INTO products (product_name, category_id, unit_price, cost_price) VALUES
('ThinkPad X1 Carbon',    4,  1299.00, 850.00),
('Samsung Galaxy S24',    5,   899.00, 520.00),
('Sony WH-1000XM5',       1,   349.00, 180.00),
('Men''s Winter Jacket',  6,   149.00,  55.00),
('Women''s Blazer',       7,   129.00,  48.00),
('Coffee Maker Deluxe',   3,    89.00,  32.00),
('Standing Desk Pro',     3,   399.00, 210.00);

-- 3. STORES
INSERT INTO stores (store_name, city, country, region) VALUES
('Berlin Central',   'Berlin',    'Germany',     'DACH'),
('Munich Store',     'Munich',    'Germany',     'DACH'),
('Vienna Flagship',  'Vienna',    'Austria',     'DACH'),
('Amsterdam Hub',    'Amsterdam', 'Netherlands', 'Western Europe'),
('Paris Branch',     'Paris',     'France',      'Western Europe');

-- 4. CUSTOMERS
INSERT INTO customers (first_name, last_name, email, country, city, signup_date, segment) VALUES
('Anna',    'Müller',    'anna.mueller@email.de',    'Germany',     'Berlin',    '2022-03-15', 'Premium'),
('Thomas',  'Schmidt',   'thomas.schmidt@email.de',  'Germany',     'Munich',    '2021-08-20', 'VIP'),
('Sophie',  'Dubois',    'sophie.dubois@email.fr',   'France',      'Paris',     '2023-01-10', 'Standard'),
('Jan',     'De Vries',  'jan.devries@email.nl',     'Netherlands', 'Amsterdam', '2022-11-05', 'Standard'),
('Maria',   'Hofer',     'maria.hofer@email.at',     'Austria',     'Vienna',    '2021-05-30', 'VIP'),
('Lukas',   'Wagner',    'lukas.wagner@email.de',    'Germany',     'Hamburg',   '2023-06-01', 'Standard'),
('Elena',   'Richter',   'elena.richter@email.de',   'Germany',     'Berlin',    '2022-09-14', 'Premium');

-- 5. ORDERS
INSERT INTO orders (customer_id, store_id, order_date, status, shipping_country) VALUES
(1, 1, '2024-01-10', 'Completed', 'Germany'),
(1, 1, '2024-03-22', 'Completed', 'Germany'),
(2, 2, '2024-01-15', 'Completed', 'Germany'),
(2, 2, '2024-02-28', 'Completed', 'Germany'),
(2, 2, '2024-04-10', 'Completed', 'Germany'),
(3, 5, '2024-02-14', 'Completed', 'France'),
(4, 4, '2024-03-01', 'Cancelled', 'Netherlands'),
(5, 3, '2024-01-20', 'Completed', 'Austria'),
(5, 3, '2024-04-05', 'Completed', 'Austria'),
(6, 1, '2024-04-18', 'Completed', 'Germany'),
(7, 1, '2024-01-25', 'Returned',  'Germany');

-- 6. ORDER ITEMS
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct) VALUES
(1,  1, 1, 1299.00, 0.00),
(1,  3, 1,  349.00, 5.00),
(2,  2, 1,  899.00, 0.00),
(3,  1, 1, 1299.00, 10.00),
(4,  7, 2,  399.00, 0.00),
(5,  2, 1,  899.00, 5.00),
(6,  5, 2,  129.00, 0.00),
(7,  4, 1,  149.00, 0.00),
(8,  6, 1,   89.00, 0.00),
(9,  3, 1,  349.00, 0.00),
(10, 4, 1,  149.00, 0.00),
(11, 5, 1,  129.00, 0.00);

-- 7. INVENTORY
INSERT INTO inventory (product_id, store_id, stock_quantity, reorder_level) VALUES
(1, 1, 15, 5),
(1, 2,  8, 5),
(2, 1, 22, 8),
(2, 2,  3, 8),
(3, 1, 45, 10),
(4, 1, 30, 15),
(5, 5, 18, 10),
(6, 3, 60, 20),
(7, 1,  4, 5),
(7, 2,  0, 5);

-- 8. PAYMENTS
INSERT INTO payments (order_id, payment_date, amount, payment_method, status) VALUES
(1,  '2024-01-10', 1565.55, 'Credit Card',   'Paid'),
(2,  '2024-03-22',  899.00, 'PayPal',        'Paid'),
(3,  '2024-01-15', 1169.10, 'Bank Transfer', 'Paid'),
(4,  '2024-02-28',  798.00, 'Credit Card',   'Paid'),
(5,  '2024-04-10',  854.05, 'Credit Card',   'Paid'),
(6,  '2024-02-14',  258.00, 'PayPal',        'Paid'),
(7,  '2024-03-01',  149.00, 'Credit Card',   'Refunded'),
(8,  '2024-01-20',   89.00, 'Cash',          'Paid'),
(9,  '2024-04-05',  349.00, 'Credit Card',   'Paid'),
(10, '2024-04-18',  149.00, 'PayPal',        'Paid'),
(11, '2024-01-25',  129.00, 'Credit Card',   'Refunded');
