CREATE OR REPLACE TABLE `project-2a65c62d-111a-4f39-827.online_retail.online_retail_velocity_analysis` AS
WITH base_sales AS (
  SELECT 
    StockCode AS stock_code,
    Description AS description,
    InvoiceNo AS invoice_no,
    Quantity AS quantity,
    InvoiceDate AS invoice_time,
    (Quantity * UnitPrice) AS line_total
  FROM 
    `project-2a65c62d-111a-4f39-827.online_retail.online_retail_sales`
  WHERE 
    Quantity > 0 
    AND UnitPrice > 0
    AND StockCode IS NOT NULL
),
sku_metrics AS (
  SELECT 
    stock_code,
    APPROX_TOP_COUNT(description, 1)[OFFSET(0)].value AS description,
    SUM(quantity) AS total_units_sold,
    COUNT(DISTINCT invoice_no) AS total_orders,
    ROUND(SUM(line_total), 2) AS total_revenue,
    MIN(invoice_time) AS first_sale_date,
    MAX(invoice_time) AS last_sale_date,
    -- Active selling period in days (minimum 1 day to prevent division by zero)
    GREATEST(DATE_DIFF(DATE(MAX(invoice_time)), DATE(MIN(invoice_time)), DAY), 1) AS active_days
  FROM 
    base_sales
  GROUP BY 
    stock_code
)
SELECT 
  abc.stock_code,
  abc.description,
  abc.abc_class,
  v.total_units_sold,
  v.total_orders,
  abc.total_revenue,
  v.active_days,
  -- Daily and Monthly Sales Velocity
  ROUND(v.total_units_sold / v.active_days, 2) AS avg_daily_units_sold,
  ROUND((v.total_units_sold / v.active_days) * 30, 2) AS avg_monthly_units_sold,
  -- Movement Categorization
  CASE 
    WHEN (v.total_units_sold / v.active_days) * 30 >= 100 THEN 'Fast-Moving'
    WHEN (v.total_units_sold / v.active_days) * 30 >= 20 THEN 'Medium-Moving'
    WHEN (v.total_units_sold / v.active_days) * 30 > 0 THEN 'Slow-Moving'
    ELSE 'Dead Stock'
  END AS movement_category
FROM 
  `project-2a65c62d-111a-4f39-827.online_retail.online_retail_abc_analysis` abc
JOIN 
  sku_metrics v ON abc.stock_code = v.stock_code
ORDER BY 
  avg_monthly_units_sold DESC;
