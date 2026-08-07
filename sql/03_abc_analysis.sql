CREATE OR REPLACE TABLE `project-2a65c62d-111a-4f39-827.online_retail.online_retail_abc_analysis` AS
WITH cleaned_data AS (
  SELECT 
    StockCode AS stock_code,
    Description AS description,
    InvoiceNo AS invoice_no,
    Quantity AS quantity,
    UnitPrice AS unit_price,
    (Quantity * UnitPrice) AS line_total
  FROM 
    `project-2a65c62d-111a-4f39-827.online_retail.online_retail_sales`
  WHERE 
    Quantity > 0 
    AND UnitPrice > 0
    AND StockCode IS NOT NULL
),
product_performance AS (
  SELECT 
    stock_code,
    APPROX_TOP_COUNT(description, 1)[OFFSET(0)].value AS description,
    SUM(quantity) AS total_units_sold,
    COUNT(DISTINCT invoice_no) AS total_orders,
    ROUND(SUM(line_total), 2) AS total_revenue
  FROM 
    cleaned_data
  GROUP BY 
    stock_code
),
cumulative_revenue AS (
  SELECT 
    stock_code,
    description,
    total_units_sold,
    total_orders,
    total_revenue,
    SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS running_revenue,
    SUM(total_revenue) OVER () AS grand_total_revenue
  FROM 
    product_performance
)
SELECT 
  stock_code,
  description,
  total_units_sold,
  total_orders,
  total_revenue,
  ROUND((total_revenue / grand_total_revenue) * 100, 2) AS pct_of_total_revenue,
  ROUND((running_revenue / grand_total_revenue) * 100, 2) AS cumulative_revenue_pct,
  CASE 
    WHEN (running_revenue / grand_total_revenue) <= 0.80 THEN 'A'
    WHEN (running_revenue / grand_total_revenue) <= 0.95 THEN 'B'
    ELSE 'C'
  END AS abc_class
FROM 
  cumulative_revenue
ORDER BY 
  total_revenue DESC;
