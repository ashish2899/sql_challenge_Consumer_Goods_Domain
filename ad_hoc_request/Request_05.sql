-- Get the products that have the highest and lowest manufacturing costs.
-- The final output should contain these fields,
-- product_code
-- product
-- manufacturing_cost

SELECT
    m.product_code,
    p.product,
    m.manufacturing_cost
FROM fact_manufacturing_cost m
JOIN dim_product p
    ON m.product_code = p.product_code
WHERE m.manufacturing_cost IN (
    SELECT MAX(manufacturing_cost)
    FROM fact_manufacturing_cost
    UNION
    SELECT MIN(manufacturing_cost)
    FROM fact_manufacturing_cost
)
ORDER BY manufacturing_cost DESC;