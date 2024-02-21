-- Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions.
-- The final report contains these columns:
-- Month
-- Year
-- Gross sales Amount

SELECT
    CONCAT(MONTHNAME(s.date), '_', YEAR(s.date)) AS 'Month',
    s.fiscal_year,
    ROUND(SUM(G.gross_price*s.sold_quantity)/1000000, 2) AS Gross_sales_Amount_mln
FROM fact_sales_monthly s
JOIN dim_customer c
    ON s.customer_code = c.customer_code
JOIN fact_gross_price G
    ON s.product_code = G.product_code
WHERE c.customer = 'Atliq Exclusive'
GROUP BY  Month, s.fiscal_year
ORDER BY s.fiscal_year ;
