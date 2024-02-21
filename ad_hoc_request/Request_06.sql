-- Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. The final output contains these fields,
-- customer_code
-- customer
-- average_discount_percentage

SELECT
    pre.customer_code,
    c.customer,
    AVG(pre.pre_invoice_discount_pct) AS average_discount_percentage
FROM gdb023.fact_pre_invoice_deductions pre
JOIN gdb023.dim_customer c
    ON pre.customer_code = c.customer_code
WHERE c.market = 'India'
    AND pre.fiscal_year = 2021
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;