SELECT 
  COUNT(*) AS total_records,
  COUNT(DISTINCT InvoiceNo) AS unique_invoices,
  COUNT(DISTINCT StockCode) AS unique_products,
  COUNT(DISTINCT CustomerID) AS unique_customers,
  SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS missing_customer_ids,
  SUM(CASE WHEN Description IS NULL OR TRIM(Description) = '' THEN 1 ELSE 0 END) AS missing_descriptions,
  SUM(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 ELSE 0 END) AS cancellation_count,
  MIN(Quantity) AS min_quantity,
  MAX(Quantity) AS max_quantity,
  MIN(UnitPrice) AS min_unit_price,
  MAX(UnitPrice) AS max_unit_price
FROM 
  `project-2a65c62d-111a-4f39-827.online_retail.online_retail_sales`;
