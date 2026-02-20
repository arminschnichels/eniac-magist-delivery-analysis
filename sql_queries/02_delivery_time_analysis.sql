-- =============================================================================
-- File: 02_delivery_time_analysis.sql
-- Purpose: Calculate delivery time metrics (average, median, percentiles)
-- Author: Armin Schnichels
-- Date: 20.02.2026
-- =============================================================================

-- ----------------------------------------------------------------------------
-- AVERAGE DELIVERY TIME: All Products
-- ----------------------------------------------------------------------------

SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, 
                       order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

/* RESULT: 12.50 days
   INSIGHT: Competitive with Brazilian 4-15 day standard
*/


-- ----------------------------------------------------------------------------
-- DELIVERY TIME TREND: Year-over-Year
-- ----------------------------------------------------------------------------

SELECT 
    YEAR(order_purchase_timestamp) AS year,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, 
                       order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY year;

/* RESULT:
   2016: 19.56 days (272 orders)
   2017: 12.95 days (43,424 orders)
   2018: 12.10 days (52,780 orders)
   
   KEY FINDING: 38% improvement from 2016 to 2018
*/


-- ----------------------------------------------------------------------------
-- TECH PRODUCTS: Delivery Time by Year
-- ----------------------------------------------------------------------------

SELECT 
    YEAR(o.order_purchase_timestamp) AS year,
    COUNT(DISTINCT o.order_id) AS tech_order_count,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, 
                       o.order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders o
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
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY year;

/* RESULT:
   2016: 16.25 days
   2017: 12.94 days
   2018: 12.89 days
   
   KEY FINDING: 21% improvement for tech products
*/


-- ----------------------------------------------------------------------------
-- MEDIAN DELIVERY TIME: Uses Window Function
-- ----------------------------------------------------------------------------

SELECT 
    o.order_id,
    DATEDIFF(o.order_delivered_customer_date, 
             o.order_purchase_timestamp) AS delivery_days,
    ROW_NUMBER() OVER (
        ORDER BY DATEDIFF(o.order_delivered_customer_date, 
                         o.order_purchase_timestamp)
    ) AS row_num
FROM orders o
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
ORDER BY delivery_days;

/* MANUAL CALCULATION:
   Total: 14,050 orders
   Median position: 7,025
   Row 7,025 = 11 days
   
   RESULT: Median = 11 days
   INSIGHT: Median < Average indicates right-skewed distribution
*/


-- ----------------------------------------------------------------------------
-- 90TH PERCENTILE: Worst-Case for 90% of Customers
-- ----------------------------------------------------------------------------

/* Same query as median, but:
   90th percentile position = 14,050 × 0.90 = 12,645
   Row 12,645 = 23 days
   
   RESULT: 90th percentile = 23 days
   INSIGHT: 90% of customers receive orders within 23 days
*/
