-- schema.sql
DROP DATABASE IF EXISTS little_lemon;
CREATE DATABASE little_lemon CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE little_lemon;

-- العملاء
CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name    VARCHAR(100) NOT NULL,
  email        VARCHAR(120) UNIQUE,
  created_at   DATETIME DEFAULT NOW()
);

-- الأصناف
CREATE TABLE menu_items (
  item_id INT PRIMARY KEY AUTO_INCREMENT,
  item_name   VARCHAR(100) NOT NULL,
  category    VARCHAR(50)  NOT NULL,
  price       DECIMAL(10,2) NOT NULL,
  is_active   TINYINT(1) DEFAULT 1
);

-- الطلبات
CREATE TABLE orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  order_datetime DATETIME NOT NULL,
  order_status ENUM('PLACED','PAID','CANCELLED','REFUNDED') DEFAULT 'PLACED',
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- تفاصيل الطلب
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  item_id  INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (item_id)  REFERENCES menu_items(item_id)
);

CREATE INDEX idx_orders_dt ON orders(order_datetime);
CREATE INDEX idx_menu_cat  ON menu_items(category);
