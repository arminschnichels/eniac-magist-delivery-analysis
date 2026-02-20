# Magist Delivery Performance Analysis

**SQL Analysis | E-Commerce Logistics | Strategic Recommendation**

---

## 📊 Project Overview

**Business Context:**  
Eniac, a European e-commerce company specializing in Apple-compatible tech products (€540 average order value), is evaluating a 3-year partnership with Magist, a Brazilian logistics platform. As the Data Analyst responsible for delivery performance assessment within a 4-person analytical team, I evaluated whether Magist can meet Eniac's customer service standards for speed and reliability.

**Core Question:**  
*Can Magist deliver tech products fast and reliably enough to maintain Eniac's reputation for excellent customer service?*

**My Role:** Delivery & Logistics Performance Analysis  
**Tools:** MySQL, SQL  
**Dataset:** 96,476 delivered orders (Sept 2016 - Oct 2018)

---

## 🎯 Key Findings

| Metric | Result | Insight |
|--------|--------|---------|
| **Average Delivery** | 12.5 days | Competitive with Brazilian standard (4-15 days) ✅ |
| **Median Delivery** | 11 days | Most customers experience faster delivery |
| **On-Time/Early Rate** | 93% | Strong reliability; under-promises, over-delivers ✅ |
| **Delay Rate** | 6.9% | Better than platform average (8.8%) ✅ |
| **Performance Trend** | +38% improvement | Delivery 38% faster than 2016 while scaling 355x ✅ |
| **90th Percentile** | 23 days | Predictable worst-case for 90% of customers |

---

## ✅ Strategic Recommendation

**Proceed with partnership under these conditions:**

- **Contract Duration:** 1-year pilot (not original 3-year term)
- **Geographic Focus:** São Paulo region initially  
- **Service Requirements:** Service-level agreements for premium products (€400+)

**Rationale:**  
Delivery performance supports partnership, but a focused pilot mitigates risk while validating Magist's capability with Eniac's premium product mix (€540 average) and customer expectations. São Paulo shows optimal performance (12-day average, 5,256 orders/month).

---

## 📁 Repository Contents
```
├── sql_queries/           # Organized SQL analysis queries
│   ├── 01_data_exploration.sql
│   ├── 02_delivery_time_analysis.sql
│   ├── 03_delay_analysis.sql
│   └── 04_geographic_analysis.sql
├── documentation/         # Methodology and technical notes
│   ├── methodology.md
│   ├── findings_summary.md
│   └── technical_challenges.md
├── presentation/          # Stakeholder presentation materials
│   ├── delivery_performance_slides.pdf
│   └── presentation_script.md
└── results/              # Summary metrics and data tables
    └── key_metrics.md
```

---

## 🔍 Analytical Approach

### Data Source
- **Database:** Magist transactional data
- **Time Period:** 25 months (Sept 2016 - Oct 2018)
- **Sample Size:** 96,476 delivered orders
- **Tech Products:** 14,051 orders across 7 categories

### SQL Skills Demonstrated
- **Complex Multi-table JOINs:** Joined 4-5 tables (orders, order_items, products, customers, geo)
- **Subqueries:** Used IN/NOT IN with nested SELECT for filtering and deduplication
- **Window Functions:** ROW_NUMBER() OVER for ranking delivery times to calculate percentiles
- **Aggregate Functions:** COUNT(DISTINCT), AVG(), SUM(), MAX(), MIN() with ROUND()
- **GROUP BY and HAVING:** Grouped data by year, category, geography with conditional filtering
- **CASE Statements:** Categorical binning for price ranges, delivery time ranges, delivery status
- **Date/Time Calculations:** DATEDIFF(), TIMESTAMPDIFF(), YEAR() for temporal analysis
- **Data Quality Management:** Explicit NULL handling, duplicate prevention, timestamp vs date decisions

### Key Techniques
1. **Statistical Analysis:** Calculated mean, median, and 90th percentile to understand distribution
2. **Trend Analysis:** Year-over-year comparison to assess performance trajectory  
3. **Comparative Analysis:** Tech products vs overall platform performance
4. **Data Validation:** Cross-checked results using multiple approaches to identify discrepancies

---

## 📊 Sample Insights

### Performance Improvement (2016 → 2018)
- **All Products:** 19.56 days → 12.10 days (**38% faster**)
- **Tech Products:** 16.25 days → 12.89 days (**21% faster**)

This improvement occurred while order volume grew **355-fold** (272 → 96,476 orders), demonstrating operational scalability.

### Reliability Analysis
- **91.7%** of orders arrive **before** estimated delivery date
- Average early arrival: **11.79 days** ahead of estimate
- Conservative estimation creates positive customer experiences

### Geographic Performance
**São Paulo** (target market):
- Average delivery: **11.99 days** (faster than 12.5 overall)
- Order volume: **5,256 orders** (highest in database)
- **Recommendation:** Ideal for pilot launch

---

## 🚧 Technical Challenges Solved

### Challenge 1: Duplicate Row Counting
**Problem:** JOINs created duplicate rows for orders with multiple items, inflating delay count (8,715 vs actual 6,666)

**Solution:** Used `COUNT(DISTINCT order_id)` and subquery approaches

**Learning:** Always validate aggregations in one-to-many relationships

---

### Challenge 2: Timestamp vs Date Comparison  
**Problem:** Two methods produced different results—7,827 vs 6,666 delayed orders (1,161 difference)

**Root Cause:** 1,161 orders delivered same **date** but different **time** than estimate

**Decision:** Used DATEDIFF (date-based) not direct comparison (timestamp-based) because delivery windows measured in days, not hours

**Learning:** Technical correctness must align with business context

---

### Challenge 3: Weighted Averages
**Problem:** Simple average of yearly averages (14.87 days) ≠ actual overall average (12.5 days)

**Root Cause:** 2016 represented only 0.28% of orders but weighted equally in simple average

**Solution:** Used SQL's `AVG()` which properly weights by row count

**Learning:** Always consider sample sizes when aggregating grouped statistics

---

## 💼 Skills Demonstrated

**Technical:**
- Advanced SQL (MySQL): JOINs, subqueries, window functions, aggregate functions
- Statistical Analysis: Distribution analysis, percentiles, trend analysis
- Data Validation: Cross-checking results, identifying discrepancies
- Data Cleaning: Handling duplicates, NULL values, data type issues

**Business:**
- Strategic Thinking: Risk-balanced recommendation (pilot vs full commitment)
- Stakeholder Communication: Technical → business language translation
- Decision-Making: Clear recommendation despite data limitations
- Risk Assessment: Identified conditions and success metrics

**Analytical:**
- Problem Decomposition: Breaking complex questions into measurable metrics
- Root Cause Analysis: Systematic debugging of data discrepancies
- Critical Thinking: Questioning assumptions, validating results
- Context Application: Industry benchmarking, business relevance

---

## 📈 Business Impact

This analysis directly informed executive decision-making on a multi-million dollar partnership opportunity. The recommendation to pursue a 1-year São Paulo pilot (rather than the proposed 3-year nationwide contract) balanced growth opportunity with risk management, demonstrating data-driven strategic thinking.

---

## 🎓 Key Learnings

1. **Data Quality First:** Small issues like duplicate rows can significantly skew results—validate early and often
2. **Context Drives Decisions:** The "right" calculation depends on business meaning, not just technical accuracy
3. **Communication Matters:** Technical precision means nothing if stakeholders don't understand implications
4. **Know Your Limits:** Acknowledging data gaps (premium product performance) led to stronger recommendation (SLAs, pilot phase)
5. **Recommendation > Analysis:** Better to have 3 well-supported insights than 10 superficial findings

---

## 📞 Contact

**Armin Schnichels**  
arminschnichels@gmail.com | [LinkedIn Profile] | 

---

## 📜 Project Context

This analysis was completed as part of a data analytics bootcamp case study. The dataset is anonymized and used for educational purposes. My focus was delivery performance; teammates analyzed product catalog fit, seller ecosystem, and customer satisfaction.

---

*Last Updated: 20.02.2026*
