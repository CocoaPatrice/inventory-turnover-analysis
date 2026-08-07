CREATE OR REPLACE TABLE `project-2a65c62d-111a-4f39-827.online_retail.online_retail_stockout_risk` AS
WITH velocity_base AS (
  SELECT 
    stock_code,
    description,
    abc_class,
    movement_category,
    total_units_sold,
    total_orders,
    total_revenue,
    active_days,
    avg_daily_units_sold,
    avg_monthly_units_sold
  FROM 
    `project-2a65c62d-111a-4f39-827.online_retail.online_retail_velocity_analysis`
),
stockout_calculations AS (
  SELECT 
    stock_code,
    description,
    abc_class,
    movement_category,
    total_units_sold,
    avg_daily_units_sold,
    avg_monthly_units_sold,
    total_revenue,
    -- Simulated Current Inventory Buffer (based on 45 days of average demand)
    ROUND(avg_daily_units_sold * 45, 0) AS estimated_current_stock,
    -- Target Safety Stock Buffer (15 days for Class A, 30 days for Class B, 45 days for Class C)
    CASE 
      WHEN abc_class = 'A' THEN ROUND(avg_daily_units_sold * 15, 0)
      WHEN abc_class = 'B' THEN ROUND(avg_daily_units_sold * 30, 0)
      ELSE ROUND(avg_daily_units_sold * 45, 0)
    END AS target_safety_stock,
    -- Days of Supply (DOS) remaining
    CASE 
      WHEN avg_daily_units_sold > 0 THEN ROUND((avg_daily_units_sold * 45) / avg_daily_units_sold, 1)
      ELSE 0
    END AS days_of_supply
  FROM 
    velocity_base
)
SELECT 
  stock_code,
  description,
  abc_class,
  movement_category,
  total_units_sold,
  avg_daily_units_sold,
  avg_monthly_units_sold,
  total_revenue,
  estimated_current_stock,
  target_safety_stock,
  days_of_supply,
  -- Risk Flagging Logic
  CASE 
    WHEN abc_class = 'A' AND movement_category = 'Fast-Moving' THEN 'High Priority Stockout Risk'
    WHEN abc_class = 'A' THEN 'Medium Stockout Risk'
    WHEN movement_category = 'Dead Stock' OR (abc_class = 'C' AND movement_category = 'Slow-Moving') THEN 'Excess / Overstock Risk'
    ELSE 'Low / Standard Risk'
  END AS risk_level
FROM 
  stockout_calculations
ORDER BY 
  abc_class ASC, 
  avg_daily_units_sold DESC;
