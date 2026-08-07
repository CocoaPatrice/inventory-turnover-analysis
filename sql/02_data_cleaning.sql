SELECT 
  CAST(InvoiceNo AS STRING) AS invoice_no,
  CAST(StockCode AS STRING) AS stock_code,
  TRIM(Description) AS description,
  Quantity AS quantity,
  InvoiceDate AS invoice_date,
  UnitPrice AS unit_price,
  CAST(CustomerID AS STRING) AS customer_id,
  Country AS country,
  -- Calculate total line-item revenue
  ROUND(Quantity * UnitPrice, 2) AS line_total
FROM 
  `project-2a65c62d-111a-4f39-827.online_retail.online_retail_sales`
WHERE 
  -- Remove order cancellations
  InvoiceNo NOT LIKE 'C%'
  -- Ensure valid positive sales
  AND Quantity > 0
  AND UnitPrice > 0
  -- Remove records missing product descriptions
  AND Description IS NOT NULL 
  AND TRIM(Description) != '';
