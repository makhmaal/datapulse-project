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
