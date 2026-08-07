# Online Retail Inventory Optimization

## Executive Summary
This project analyzes transactional e-commerce data from an online retail dataset using BigQuery SQL to evaluate inventory performance, product revenue distribution, and stockout risk. By combining ABC revenue classification with sales velocity and estimated stock levels, this analysis provides actionable insights to help operations teams optimize inventory levels, reduce stockout risks, and focus capital on high-performing products.

---
## Key Features & Business Analysis
- **Data Integrity & Cleaning:** Cleaned transactional data by filtering cancelled orders, negative quantities, missing customer IDs, and non-product stock codes.
- **ABC Inventory Categorization:** Segmented SKUs based on revenue contribution:
  - **Class A:** Top 80% revenue drivers (high priority).
  - **Class B:** Next 15% revenue drivers.
  - **Class C:** Bottom 5% revenue drivers (low priority/long-tail items).
- **Sales Velocity Analysis:** Measured average daily sales rates to identify high-velocity vs. slow-moving stock.
- **Stockout & Inventory Risk Profiling:** Combined daily sales velocity and estimated current inventory levels to calculate **Days of Supply** and flag high-risk items.

---

## Repository Structure
## Business Recommendations
1. **Prioritize Class A Stocking:** Ensure continuous inventory availability for Class A items to protect core revenue drivers.
2. **Flag High Stockout Risk SKUs:** Implement automated reorder triggers for items identified with low days of supply.
3. **Liquidate or Reduce Class C SKUs:** Minimize holding costs by reducing buffer stock for slow-moving, low-revenue items.

---

## Tools & Technologies
- **SQL / BigQuery:** Data cleaning, window functions, aggregation, and analytical CTEs.
- **Git & GitHub:** Version control and portfolio documentation.
