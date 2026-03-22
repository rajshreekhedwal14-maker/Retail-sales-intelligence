-- ============================================================
-- RETAIL SALES & CUSTOMER INTELLIGENCE SYSTEM
-- 01_schema.sql — Database Structure Only
-- ============================================================

CREATE TABLE categories (
    category_id        SERIAL PRIMARY KEY,
    category_name      VARCHAR(100) NOT NULL,
    parent_category_id INT REFERENCES categories(category_id)
);

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category_id  INT NOT NULL REFERENCES categories(category_id),
    unit_price   NUMERIC(10, 2) NOT NULL CHECK (unit_price > 0),
    cost_price   NUMERIC(10, 2) NOT NULL CHECK (cost_price > 0),
    is_active    BOOLEAN DEFAULT TRUE
);

CREATE TABLE stores (
    store_id   SERIAL PRIMARY KEY,
    store_name VARCHAR(150) NOT NULL,
    city       VARCHAR(100),
    country    VARCHAR(100) NOT NULL,
    region     VARCHAR(100)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(200) UNIQUE NOT NULL,
    country     VARCHAR(100) NOT NULL,
    city        VARCHAR(100),
    signup_date DATE NOT NULL DEFAULT CURRENT_DATE,
    segment     VARCHAR(50) DEFAULT 'Standard'
);

CREATE TABLE orders (
    order_id         SERIAL PRIMARY KEY,
    customer_id      INT NOT NULL REFERENCES customers(customer_id),
    store_id         INT NOT NULL REFERENCES stores(store_id),
    order_date       DATE NOT NULL DEFAULT CURRENT_DATE,
    status           VARCHAR(50) NOT NULL DEFAULT 'Completed',
    shipping_country VARCHAR(100)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES orders(order_id),
    product_id    INT NOT NULL REFERENCES products(product_id),
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(10, 2) NOT NULL,
    discount_pct  NUMERIC(5, 2) DEFAULT 0.00
);

CREATE TABLE inventory (
    inventory_id   SERIAL PRIMARY KEY,
    product_id     INT NOT NULL REFERENCES products(product_id),
    store_id       INT NOT NULL REFERENCES stores(store_id),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    reorder_level  INT NOT NULL DEFAULT 10,
    last_updated   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(product_id, store_id)
);

CREATE TABLE payments (
    payment_id     SERIAL PRIMARY KEY,
    order_id       INT NOT NULL REFERENCES orders(order_id),
    payment_date   DATE NOT NULL DEFAULT CURRENT_DATE,
    amount         NUMERIC(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status         VARCHAR(50) DEFAULT 'Paid'
);
