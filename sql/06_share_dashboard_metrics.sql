SELECT 
  risk_level,
  COUNT(DISTINCT stock_code) AS total_skus,
  ROUND(COUNT(DISTINCT stock_code) * 100.0 / SUM(COUNT(DISTINCT stock_code)) OVER(), 2) AS pct_of_total_skus,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(SUM(total_revenue) * 100.0 / SUM(SUM(total_revenue)) OVER(), 2) AS pct_of_total_revenue,
  SUM(estimated_current_stock) AS total_estimated_stock_units,
  ROUND(AVG(days_of_supply), 1) AS avg_days_of_supply
FROM 
  `project-2a65c62d-111a-4f39-827.online_retail.online_retail_stockout_risk`
GROUP BY 
  risk_level
ORDER BY 
  total_revenue DESC;
