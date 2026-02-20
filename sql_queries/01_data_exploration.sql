-- =============================================================================
-- MAGIST DELIVERY PERFORMANCE ANALYSIS
-- File: 01_data_exploration.sql
-- Purpose: Initial data exploration and validation
-- Author: Armin Schnichels
-- Date: 20.02/2026
-- =============================================================================

-- ----------------------------------------------------------------------------
-- DATABASE OVERVIEW: Timeline and Order Volume
-- ----------------------------------------------------------------------------

SELECT 
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS latest_order,
    TIMESTAMPDIFF(MONTH, 
                  MIN(order_purchase_timestamp), 
                  MAX(order_purchase_timestamp)) AS months_in_database,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;

/* RESULT:
   first_order: 2016-09-04
   latest_order: 2018-10-17
   months_in_database: 25
   total_orders: 99,441
   
   INSIGHT: 25 months of data provides robust sample for analysis
*/


-- ----------------------------------------------------------------------------
-- ORDER STATUS BREAKDOWN: Delivery Completion Rates
-- ----------------------------------------------------------------------------

SELECT 
    order_status, 
    COUNT(order_id) AS order_count,
    ROUND(COUNT(order_id) * 100.0 / 
          (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

/* RESULT:
   delivered: 96,478 (97.0%)
   shipped: 1,107 (1.1%)
   cancelled: 625 (0.6%)
   unavailable: 609 (0.6%)
   
   INSIGHT: 97% delivery rate is strong
*/


-- ----------------------------------------------------------------------------
-- TECH PRODUCT ORDERS: Scope of Analysis
-- ----------------------------------------------------------------------------

SELECT 
    o.order_status,
    COUNT(DISTINCT o.order_id) AS order_count
FROM orders o
JOIN order_items oi USING (order_id)
JOIN products p USING (product_id)
JOIN product_category_name_translation pc USING (product_category_name)
WHERE pc.product_category_name_english IN (
    'computers', 
    'computers_accessories', 
    'electronics',
    'telephony', 
    'tablets_printing_image', 
    'cine_photo', 
    'small_appliances'
)
GROUP BY o.order_status
ORDER BY order_count DESC;

/* RESULT:
   delivered: 14,051 (97.7% of tech orders)
   Total tech orders: 14,376
   
   INSIGHT: Adequate sample size for analysis
*/


-- ----------------------------------------------------------------------------
-- DATA QUALITY CHECK: Orders with Required Dates
-- ----------------------------------------------------------------------------

SELECT 
    COUNT(*) AS total_orders,
    COUNT(order_delivered_customer_date) AS has_delivered_date,
    COUNT(order_estimated_delivery_date) AS has_estimated_date,
    COUNT(CASE 
          WHEN order_delivered_customer_date IS NOT NULL 
           AND order_estimated_delivery_date IS NOT NULL 
          THEN 1 
          END) AS has_both_dates
FROM orders
WHERE order_status = 'delivered';

/* RESULT:
   total_orders: 96,478
   has_both_dates: 96,476
   
   INSIGHT: 99.998% data completeness
*/
