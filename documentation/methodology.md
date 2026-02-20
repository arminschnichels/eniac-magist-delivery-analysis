# Methodology

## Analytical Approach

### Research Question
Can Magist deliver tech products fast and reliably enough to maintain Eniac's reputation for customer satisfaction?

### Data Source
- **Database:** Magist transactional data (Brazilian e-commerce logistics platform)
- **Time Period:** September 2016 - October 2018 (25 months)
- **Sample Size:** 96,476 delivered orders
- **Tech Product Focus:** 14,051 orders across 7 categories

### Key Metrics Defined

**Delivery Time:**
- Calculated as: `DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)`
- Measured in days from order placement to customer receipt

**Delay:**
- Calculated as: `DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)`
- Positive value = late, negative = early, zero = on-time
- **Important:** Used date-based comparison, not timestamp (see technical_challenges.md)

**Tech Product Categories:**
- computers
- computers_accessories
- electronics
- telephony
- tablets_printing_image
- cine_photo
- small_appliances

### Statistical Methods

**Measures of Central Tendency:**
- **Mean (Average):** Standard arithmetic mean
- **Median:** Used ROW_NUMBER() window function to find middle value
- **90th Percentile:** Calculated position at 90% of sorted delivery times

**Trend Analysis:**
- Year-over-year comparison (2016 vs 2017 vs 2018)
- Percentage change calculation

**Comparative Analysis:**
- Tech products vs overall platform
- Geographic performance (city/state level)

### Data Quality Decisions

**Filtering Criteria:**
- Only analyzed delivered orders (excluded cancelled, processing, etc.)
- Required both delivered_date AND estimated_date to be non-NULL
- Used DISTINCT order_id to avoid duplicate counting from JOINs

**Outlier Handling:**
- Reported both mean and median to show distribution shape
- Used 90th percentile to understand worst-case scenarios
- Did not remove outliers (they represent real customer experiences)

**Weighting:**
- SQL's AVG() function properly weights by order volume
- 2016 data (0.28% of orders) has minimal impact on overall averages

### Limitations

1. **Premium Product Data:** Limited sample size for products >€400 (Eniac's price range)
2. **Service Mix Unknown:** Cannot determine if Magist uses economy vs express postal services
3. **Customer Satisfaction:** No direct satisfaction scores; delivery time is proxy
4. **Seasonality:** 25-month period may not capture all seasonal patterns
5. **Freight Costs:** Analysis focused on delivery performance, not detailed cost breakdown

### Tools & Technologies

- **Database:** MySQL
- **Query Tool:** MySQL Workbench
- **Techniques:** Multi-table JOINs, subqueries, window functions, aggregate functions
