USE little_lemon;

-- إجمالي المبيعات الصافية لكل طلب (استبعاد CANCELLED/REFUNDED)
CREATE OR REPLACE VIEW v_order_net AS
SELECT
  o.order_id,
  o.order_datetime,
  DATE(o.order_datetime) AS order_date,
  o.customer_id,
  o.order_status,
  SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status IN ('PLACED','PAID')
GROUP BY o.order_id;

-- إجراء يُرجع 4 جداول: ملخص يومي، أفضل أصناف، فئات، مؤشرات عامة
DROP PROCEDURE IF EXISTS sp_sales_report;
DELIMITER $$
CREATE PROCEDURE sp_sales_report(IN p_start DATE, IN p_end DATE)
BEGIN
  -- 1) ملخص يومي
  SELECT
    order_date,
    COUNT(*)               AS orders_count,
    SUM(order_total)       AS revenue,
    ROUND(AVG(order_total),2) AS avg_order_value
  FROM v_order_net
  WHERE order_date BETWEEN p_start AND p_end
  GROUP BY order_date
  ORDER BY order_date;

  -- 2) أفضل 10 أصناف
  SELECT
    mi.item_name,
    SUM(oi.quantity) AS qty_sold,
    SUM(oi.quantity * oi.unit_price) AS revenue
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN menu_items mi  ON mi.item_id  = oi.item_id
  WHERE o.order_status IN ('PLACED','PAID')
    AND DATE(o.order_datetime) BETWEEN p_start AND p_end
  GROUP BY mi.item_id
  ORDER BY qty_sold DESC, revenue DESC
  LIMIT 10;

  -- 3) إيراد حسب الفئة
  SELECT
    mi.category,
    SUM(oi.quantity * oi.unit_price) AS revenue
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN menu_items mi  ON mi.item_id  = oi.item_id
  WHERE o.order_status IN ('PLACED','PAID')
    AND DATE(o.order_datetime) BETWEEN p_start AND p_end
  GROUP BY mi.category
  ORDER BY revenue DESC;

  -- 4) مؤشرات عامة للفترة
  SELECT
    COUNT(DISTINCT o.order_id)           AS orders,
    COUNT(DISTINCT o.customer_id)        AS unique_customers,
    SUM(oi.quantity * oi.unit_price)     AS revenue,
    ROUND(AVG(t.order_total),2)          AS avg_order_value
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN v_order_net t  ON t.order_id = o.order_id
  WHERE o.order_status IN ('PLACED','PAID')
    AND DATE(o.order_datetime) BETWEEN p_start AND p_end;
END$$
DELIMITER ;
