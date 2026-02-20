-- =============================================================================
-- File: 04_geographic_analysis.sql
-- Purpose: Geographic performance breakdown
-- Author: Armin Schnichels
-- Date: 20.02.2026
-- =============================================================================

-- ----------------------------------------------------------------------------
-- TOP CITIES: Tech Product Delivery Performance
-- ----------------------------------------------------------------------------

SELECT 
    g.city,
    g.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
                       o.order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders o
JOIN customers c USING (customer_id)
JOIN geo g ON c.customer_zip_code_prefix = g.zip_code_prefix
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_id IN (
      SELECT DISTINCT oi.order_id
      FROM order_items oi
      JOIN products p USING (product_id)
      JOIN product_category_name_translation pc USING (product_category_name)
      WHERE pc.product_category_name_english IN (
          'computers', 'computers_accessories', 'electronics',
          'telephony', 'tablets_printing_image', 'cine_photo', 'small_appliances'
      )
  )
GROUP BY g.city, g.state
HAVING total_orders >= 500
ORDER BY total_orders DESC
LIMIT 10;

/* RESULT (Top 3):
   São Paulo: 5,256 orders, 11.99 days
   Maringá: 1,555 orders, 14.93 days
   Belo Horizonte: 856 orders, 13.05 days
   
   KEY FINDING: São Paulo has best performance + highest volume
   RECOMMENDATION: Ideal for pilot launch
*/
