# Technical Challenges & Solutions

## Challenge 1: Duplicate Row Counting

### Problem
JOINs between orders and order_items created duplicate rows for orders with multiple items.

**Example:**
- Order #123 has 2 tech products
- After JOIN: 2 rows
- COUNT(*) = 2 (wrong)
- Should be: 1 unique order

**Initial result:** 8,715 delayed orders  
**Correct result:** 6,666 delayed orders

### Solution
Used `COUNT(DISTINCT order_id)` instead of `COUNT(*)`

Alternatively, filtered orders using subquery:
```sql
WHERE order_id IN (SELECT DISTINCT order_id FROM ...)
```

### Learning
Always use DISTINCT when counting entities across one-to-many joins.

---

## Challenge 2: Timestamp vs Date Comparison

### Problem
Two methods produced different results:
- Direct comparison: 7,827 late orders
- DATEDIFF: 6,666 late orders
- Discrepancy: 1,161 orders

### Root Cause
1,161 orders delivered on same **date** but different **time**.

**Example:**
```
Estimated: 2018-03-29 02:00:00
Delivered: 2018-03-29 20:17:31
Direct (>): "late" (timestamp later)
DATEDIFF: "on-time" (same date = 0 days)
```

### Solution
Used DATEDIFF (date-based) because:
1. Delivery windows measured in days, not hours
2. Customer expectation: "March 29" = anytime on March 29
3. Industry standard

### Learning
Technical correctness must align with business context. The mathematically accurate timestamp comparison was less meaningful for this use case.

---

## Challenge 3: Weighted Averages

### Problem
Simple average of yearly averages ≠ actual overall average
- 2016: 19.56, 2017: 12.95, 2018: 12.10
- Simple avg: 14.87 days
- Actual avg: 12.5 days

### Root Cause
2016 = only 0.28% of orders (272 / 96,476)

### Solution
SQL's AVG() automatically weights by row count (correct behavior).

### Learning
Be cautious when averaging pre-aggregated values. Consider sample sizes in grouped statistics.

---

## Summary

| Issue | Impact | Resolution |
|-------|--------|------------|
| Duplicate rows | 2,049 orders overcounted | COUNT(DISTINCT) |
| Timestamp comparison | 1,161 orders misclassified | Use DATEDIFF |
| Simple averages | Overweighted 2016 | Use raw data AVG() |

These challenges reinforced importance of data structure understanding and business context application.
