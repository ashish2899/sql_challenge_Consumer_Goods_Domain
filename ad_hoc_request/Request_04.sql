-- Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields,
-- segment
-- product_count_2020
-- product_count_2021
-- difference

WITH unique_product_2020 AS(
    SELECT
        p.segment,
        COUNT(DISTINCT s.product_code) AS product_count_2020
    FROM fact_sales_monthly s
    JOIN dim_product p 
        ON s.product_code = p.product_code
    WHERE fiscal_year = 2020
    GROUP BY segment
),
unique_product_2021 AS (
    SELECT
        p.segment,
        COUNT(DISTINCT s.product_code) AS product_count_2021
    FROM fact_sales_monthly s
    JOIN dim_product p 
        ON s.product_code = p.product_code
    WHERE fiscal_year = 2021
    GROUP BY segment
)
SELECT
    unique_product_2020.segment,
    unique_product_2020.product_count_2020,
    unique_product_2021.product_count_2021,
    unique_product_2021.product_count_2021 - unique_product_2020.product_count_2020 AS difference
FROM unique_product_2020,
unique_product_2021
WHERE unique_product_2020.segment = unique_product_2021.segment
ORDER BY difference DESC;

