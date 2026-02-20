-- =============================================================================
-- File: 03_delay_analysis.sql
-- Purpose: Analyze delayed orders and reliability metrics
-- Technical Note: Uses DATEDIFF for date-based comparison (not timestamp)
-- Author: Armin Schnichels
-- Date: 20.02.2026
-- =============================================================================

-- ----------------------------------------------------------------------------
-- METHODOLOGICAL NOTE: Why DATEDIFF, not direct timestamp comparison
-- ----------------------------------------------------------------------------
/*
DATEDIFF compares DATES, not TIMESTAMPS.

Direct comparison (>) counts 7,827 orders as "late"
DATEDIFF counts 6,666 orders as "late"
Difference: 1,161 orders delivered same DATE but different TIME

Example:
  Estimated: 2018-03-29 02:00:00
  Delivered: 2018-03-29 20:17:31
  Direct: "late" (20:17 > 02:00)
  DATEDIFF: "on-time" (same date = 0 days)

Business Decision: Use DATEDIFF because delivery windows measured in DAYS
*/


-- ----------------------------------------------------------------------------
-- DELAYED ORDERS: Total Count and Rate
-- ----------------------------------------------------------------------------

SELECT 
    COUNT(DISTINCT order_id) AS total_delayed_orders,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / 
          (SELECT COUNT(DISTINCT order_id) 
           FROM orders 
           WHERE order_delivered_customer_date IS NOT NULL
             AND order_estimated_delivery_date IS NOT NULL), 2) AS delay_rate_pct
FROM orders
WHERE DATEDIFF(order_delivered_customer_date, 
               order_estimated_delivery_date) > 0
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

/* RESULT:
   total_delayed_orders: 6,666
   delay_rate_pct: 6.91%
   
   KEY FINDING: Only 6.91% delayed
*/


-- ----------------------------------------------------------------------------
-- EARLY / ON-TIME / LATE BREAKDOWN
-- ----------------------------------------------------------------------------

SELECT 
    CASE
        WHEN DATEDIFF(order_delivered_customer_date, 
                      order_estimated_delivery_date) < 0 THEN 'Early'
        WHEN DATEDIFF(order_delivered_customer_date, 
                      order_estimated_delivery_date) = 0 THEN 'On-time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / 
          (SELECT COUNT(DISTINCT order_id) 
           FROM orders 
           WHERE order_delivered_customer_date IS NOT NULL
             AND order_estimated_delivery_date IS NOT NULL), 2) AS percentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status;

/* RESULT:
   Early: 88,476 (91.71%)
   On-time: 1,334 (1.38%)
   Late: 6,666 (6.91%)
   
   KEY FINDING: 93% arrive on-time or early
*/


-- ----------------------------------------------------------------------------
-- AVERAGE EARLY ARRIVAL: How Early Does Magist Deliver?
-- ----------------------------------------------------------------------------

SELECT 
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, 
                       order_estimated_delivery_date)), 2) AS avg_diff_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

/* RESULT: -11.79 days (negative = early)
   INSIGHT: Magist under-promises by ~12 days on average
*/
