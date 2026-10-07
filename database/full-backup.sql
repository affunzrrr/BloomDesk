-- Four simple tables. The old project tables remain untouched on existing computers.
CREATE TABLE IF NOT EXISTS simple_users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(40) NOT NULL UNIQUE,
    password_hash CHAR(64) NOT NULL
);
CREATE TABLE IF NOT EXISTS simple_customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    phone VARCHAR(24) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL
);
CREATE TABLE IF NOT EXISTS simple_bouquets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(60) NOT NULL,
    price DECIMAL(12,2) NOT NULL CHECK (price > 0),
    availability ENUM('Available','Unavailable') NOT NULL DEFAULT 'Available'
);
CREATE TABLE IF NOT EXISTS simple_orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0 AND quantity <= 1000),
    unit_price DECIMAL(12,2) NOT NULL,
    total DECIMAL(15,2) NOT NULL,
    payment_method ENUM('CASH','CARD') NOT NULL,
    pickup_date DATE NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES simple_customers(id),
    FOREIGN KEY (item_id) REFERENCES simple_bouquets(id)
);
INSERT IGNORE INTO simple_users(id,username,password_hash) VALUES (1,'admin',SHA2('Bloom@2026',256));
INSERT IGNORE INTO simple_customers(id,first_name,last_name,phone,email) VALUES (1,'Demo','Customer','0771234567','demo@example.com');
INSERT IGNORE INTO simple_bouquets(id,name,type,price,availability) VALUES (1,'Rose bouquet','Birthday',3500,'Available');
INSERT IGNORE INTO simple_bouquets(id,name,type,price,availability) VALUES (2,'Lily bouquet','Wedding',5000,'Available');
INSERT IGNORE INTO simple_bouquets(id,name,type,price,availability) VALUES (3,'Mixed flowers','Gift',2800,'Unavailable');
INSERT IGNORE INTO simple_orders(id,customer_id,item_id,quantity,unit_price,total,payment_method,pickup_date) VALUES (1,1,1,2,3500,7000,'CASH',CURRENT_DATE);
