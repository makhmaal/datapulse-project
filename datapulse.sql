-- DataPulse Database Project
-- Analytical Database / OLAP

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (name, email) VALUES
('Ali', 'ali@gmail.com'),
('Sara', 'sara@gmail.com'),
('Reza', 'reza@gmail.com'),
('Nima', 'nima@gmail.com'),
('Mina', 'mina@gmail.com'),
('Amir', 'amir@gmail.com'),
('Zahra', 'zahra@gmail.com'),
('Maryam', 'maryam@gmail.com'),
('Hossein', 'hossein@gmail.com'),
('Arman', 'arman@gmail.com');

INSERT INTO orders (user_id, total_amount, status) VALUES
(1, 2500000, 'paid'),
(1, 1800000, 'paid'),
(2, 5200000, 'paid'),
(2, 3100000, 'paid'),
(3, 900000, 'paid'),
(4, 7500000, 'paid'),
(5, 4200000, 'paid'),
(5, 2800000, 'paid'),
(6, 1500000, 'paid'),
(7, 6300000, 'paid'),
(8, 2100000, 'paid'),
(9, 4700000, 'paid'),
(10, 1200000, 'paid'),
(10, 3600000, 'paid');

-- Exercise 2: Composite Indexes

CREATE INDEX idx_orders_user_created
ON orders(user_id, created_at);

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE user_id = 2
ORDER BY created_at DESC;

CREATE INDEX idx_orders_status_created
ON orders(status, created_at);

-- =========================================
-- Exercise 3: Partial Index
-- =========================================

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    stock INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO products (name, price, stock, is_active) VALUES
('Laptop', 45000000, 10, TRUE),
('Phone', 25000000, 15, TRUE),
('Headphones', 3500000, 20, TRUE),
('Keyboard', 2200000, 0, TRUE),
('Mouse', 1200000, 30, TRUE),
('Monitor', 18000000, 5, TRUE),
('Tablet', 20000000, 0, FALSE),
('Smart Watch', 8000000, 12, TRUE),
('Camera', 30000000, 4, FALSE),
('Speaker', 4500000, 8, TRUE);

CREATE INDEX idx_products_active_stock
ON products(price)
WHERE is_active = TRUE AND stock > 0;

EXPLAIN ANALYZE
SELECT *
FROM products
WHERE is_active = TRUE
  AND stock > 0
ORDER BY price;


-- =========================================
-- Exercise 4: Covering Index
-- =========================================

CREATE INDEX idx_orders_monthly_sales
ON orders(created_at, user_id)
INCLUDE (total_amount, status);

EXPLAIN ANALYZE
SELECT
    DATE_TRUNC('month', created_at) AS month,
    user_id,
    SUM(total_amount) AS total_sales
FROM orders
GROUP BY
    DATE_TRUNC('month', created_at),
    user_id
ORDER BY month;


-- =========================================
-- Exercise 5: Materialized View
-- =========================================

CREATE MATERIALIZED VIEW monthly_sales_report AS
SELECT
    DATE_TRUNC('month', created_at) AS month,
    user_id,
    SUM(total_amount) AS total_sales,
    COUNT(*) AS order_count
FROM orders
GROUP BY
    DATE_TRUNC('month', created_at),
    user_id;

EXPLAIN ANALYZE
SELECT *
FROM monthly_sales_report
ORDER BY month;
