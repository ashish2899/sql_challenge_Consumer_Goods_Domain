-- Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? The final output contains these fields,
-- channel
-- gross_sales_mln
-- percentage

WITH gross_sales AS (
    SELECT
        c.channel,
        s.fiscal_year,
        (s.sold_quantity * g.gross_price) AS net_sales
    FROM fact_sales_monthly s
    JOIN fact_gross_price g
        ON s.product_code = g.product_code
    JOIN dim_customer c
        ON s.customer_code = c.customer_code
    WHERE s.fiscal_year = 2021
)
SELECT 
    channel,
    ROUND(SUM(net_sales) / 1000000, 2) AS gross_sales_mln,
    ROUND(SUM(net_sales) / SUM(SUM(net_sales)) OVER() * 100,2) AS percentage
FROM gross_sales
GROUP BY channel
ORDER BY percentage DESC;