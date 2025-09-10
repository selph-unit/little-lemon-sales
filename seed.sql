USE little_lemon;

INSERT INTO customers (full_name,email) VALUES
('Layla Ahmed','layla@example.com'),
('Omar Nasser','omar@example.com'),
('Sara Ali','sara@example.com');

INSERT INTO menu_items (item_name,category,price) VALUES
('Lemon Tart','Dessert',18.00),
('Grilled Chicken','Main',42.00),
('Pasta Pesto','Main',35.00),
('Iced Lemonade','Beverage',12.00),
('Espresso','Beverage',9.00);

-- طلبات خلال شهرين كمثال
INSERT INTO orders (customer_id,order_datetime,order_status) VALUES
(1, '2025-08-30 12:15:00', 'PAID'),
(2, '2025-09-01 19:40:00', 'PAID'),
(3, '2025-09-03 09:05:00', 'PAID'),
(1, '2025-09-05 13:30:00', 'PAID'),
(2, '2025-09-06 21:10:00', 'CANCELLED');

-- تفاصيل الطلبات (السعر عند الشراء ينسخ من price)
INSERT INTO order_items (order_id,item_id,quantity,unit_price) VALUES
(1, 1, 1, 18.00), (1, 4, 2, 12.00),
(2, 2, 1, 42.00), (2, 5, 1,  9.00),
(3, 3, 1, 35.00), (3, 4, 1, 12.00),
(4, 2, 1, 42.00), (4, 1, 1, 18.00),
(5, 4, 2, 12.00); -- هذا الطلب مُلغى ولن يُحتسب في الإيراد
