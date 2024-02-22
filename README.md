# Provide Insights to Management in Consumer Goods Domain

---

## Objective

- AtliqHardware (fictitious corporation) is one ofthe major computer hardware manufacturers in India, with a strong presence in other nations.
- Nevertheless,the management did note thatthey do not have sufficientinsights to make prompt, wise, and data-informed judgments.
- Plan to expand the data analytics team by adding junior data analysts.
- To assess candidates, Data analytics director, TonySharma plans to conduct aSQL challenge to evaluate both tech and soft skills.
- The company seeks insights for 10 ad hoc requests.

---

## Company Details

Atliq Hardware is a computer hardware and accessory manufacturer.

| Division | Segment     | Category                    |
| -------- | ----------- | --------------------------- |
| N & S    | Storage     | External Solid State Drives |
|          |             | USB Flash Drives            |
|          | Networking  | WI-Fi Extender              |
| P & A    | Peripherals | Graphic Card                |
|          |             | Internal HDD                |
|          |             | MotherBoard                 |
|          |             | Processors                  |
|          | Accessories | Batteries                   |
|          |             | Keyboard                    |
|          |             | Mouse                       |
| PC       | Notebook    | Personal Laptop             |
|          |             | Business Laptop             |
|          |             | Gaming Laptop               |
|          | Desktop     | Personal Desktop            |
|          |             | Business Laptop             |

---

1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.

   #### SQL Query: -

   ````sql
   SELECT
   DISTINCT market
   FROM dim_customer
   WHERE customer = "Atliq Exclusive"
       AND region = "APAC"
   GROUP BY market
   ORDER BY market;
   ```####    - Result:-

   | market      |
   | ----------- |
   | Australia   |
   | Bangladesh  |
   | India       |
   | Indonesia   |
   | Japan       |
   | Newzealand  |
   | Philiphines |
   | South Korea |
   ````

---

2. What is the percentage of unique product increase in 2021 vs. 2020? The
   final output contains these fields,

- unique_products_2020
- unique_products_2021
- percentage_chg

  #### SQL Query: -

  ```sql
  WITH unique_products_2020 AS (
    SELECT COUNT(DISTINCT product_code) AS unique_product_2020
    FROM fact_sales_monthly
    WHERE fiscal_year = 2020
    ),

    unique_products_2021 AS (
        SELECT COUNT(DISTINCT product_code) AS unique_product_2021
        FROM fact_sales_monthly
        WHERE fiscal_year = 2021
    )

    SELECT
        unique_product_2020,
        unique_product_2021,
        ROUND((unique_product_2021 - unique_product_2020) * 100 / unique_product_2020, 2) AS percentage_chg
    FROM unique_products_2020,
    unique_products_2021;
  ```

  #### Result:-

  | unique_product_2020 | unique_product_2021 | percentage_chg |
  | ------------------- | ------------------- | -------------- |
  | 245                 | 334                 | 36.33          |

---

3. Provide a report with all the unique product counts for each segment and
   sort them in descending order of product counts. The final output contains
   2 fields,

- segment
- product_count

  #### SQL Query: -

  ```sql
  SELECT
    segment,
    COUNT(DISTINCT product_code) AS product_count
    FROM dim_product
    GROUP BY segment
    ORDER BY product_count DESC;
  ```

  #### Result:-

  | segment     | product_count |
  | ----------- | ------------- |
  | Notebook    | 129           |
  | Accessories | 116           |
  | Peripherals | 84            |
  | Desktop     | 32            |
  | Storage     | 27            |
  | Networking  | 9             |

---

4. Follow-up: Which segment had the most increase in unique products in
   2021 vs 2020? The final output contains these fields,

- segment
- product_count_2020
- product_count_2021
- difference

  #### SQL Query: -

  ```sql
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

  ```

  #### Result:-

  | segment     | product_count_2020 | product_count_2021 | difference |
  | ----------- | ------------------ | ------------------ | ---------- |
  | Accessories | 69                 | 103                | 34         |
  | Notebook    | 92                 | 108                | 16         |
  | Peripherals | 59                 | 75                 | 16         |
  | Desktop     | 7                  | 22                 | 15         |
  | Storage     | 12                 | 17                 | 5          |
  | Networking  | 6                  | 9                  | 3          |

---

5. Get the products that have the highest and lowest manufacturing costs.
   The final output should contain these fields,

- product_code
- product
- manufacturing_cost

  #### SQL Query: -

  ```sql
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

  ```

  #### Result:-

  | product_code | product               | manufacturing_cost |
  | ------------ | --------------------- | ------------------ |
  | A6120110206  | AQ HOME Allin1 Gen 2  | 240.5364           |
  | A2118150101  | AQ Master wired x1 Ms | 0.892              |

---

6. Generate a report which contains the top 5 customers who received an
   average high pre_invoice_discount_pct for the fiscal year 2021 and in the
   Indian market. The final output contains these fields,

- customer_code
- customer
- average_discount_percentage

  #### SQL Query: -

  ```sql
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

  ```

  #### Result:-

  | customer_code | customer | average_discount_percentage |
  | ------------- | -------- | --------------------------- |
  | 90002009      | Flipkart | 0.3083                      |
  | 90002006      | Viveks   | 0.3038                      |
  | 90002003      | Ezone    | 0.3028                      |
  | 90002002      | Croma    | 0.3025                      |
  | 90002016      | Amazon   | 0.2933                      |

---

7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions.

- The final report contains these columns:
- Month
- Year
- Gross sales Amount

  #### SQL Query: -

  ```sql
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


  ```

  #### Result:-

  | Month          | fiscal_year | Gross_sales_Amount_mln |
  | -------------- | ----------- | ---------------------- |
  | September_2019 | 2020        | 9.09                   |
  | October_2019   | 2020        | 10.38                  |
  | November_2019  | 2020        | 15.23                  |
  | December_2019  | 2020        | 9.76                   |
  | January_2020   | 2020        | 9.58                   |
  | February_2020  | 2020        | 8.08                   |
  | March_2020     | 2020        | 0.77                   |
  | April_2020     | 2020        | 0.8                    |
  | May_2020       | 2020        | 1.59                   |
  | June_2020      | 2020        | 3.43                   |
  | July_2020      | 2020        | 5.15                   |
  | August_2020    | 2020        | 5.64                   |
  | September_2020 | 2021        | 19.53                  |
  | October_2020   | 2021        | 21.02                  |
  | November_2020  | 2021        | 32.25                  |
  | December_2020  | 2021        | 20.41                  |
  | January_2021   | 2021        | 19.57                  |
  | February_2021  | 2021        | 15.99                  |
  | March_2021     | 2021        | 19.15                  |
  | April_2021     | 2021        | 11.48                  |
  | May_2021       | 2021        | 19.2                   |
  | June_2021      | 2021        | 15.46                  |
  | July_2021      | 2021        | 19.04                  |
  | August_2021    | 2021        | 11.32                  |

---

8. In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity,

- Quarter
- total_sold_quantity

  #### SQL Query: -

  ```sql
    SELECT
        CASE
            WHEN MONTH(date) IN (9, 10, 11) THEN 'Q1'
            WHEN MONTH(date) IN (12, 1, 2) THEN 'Q2'
            WHEN MONTH(date) IN (3, 4, 5) THEN 'Q3'
            WHEN MONTH(date) IN (6, 7, 8) THEN 'Q4'
        END AS quarter,
        SUM(sold_quantity) AS total_sold_quantity
    FROM fact_sales_monthly
    WHERE fiscal_year = 2020
    GROUP BY quarter
    ORDER BY total_sold_quantity DESC;
  ```

  #### Result:-

  | quarter | total_sold_quantity |
  | ------- | ------------------- |
  | Q1      | 7005619             |
  | Q2      | 6649642             |
  | Q4      | 5042541             |
  | Q3      | 2075087             |

---

9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? The final output contains these fields,

- channel
- gross_sales_mln
- percentage

  #### SQL Query: -

  ```sql
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
  ```

  #### Result:-

  | channel     | gross_sales_mln | percentage |
  | ----------- | --------------- | ---------- |
  | Retailer    | 1924.17         | 73.22      |
  | Direct      | 406.69          | 15.47      |
  | Distributor | 297.18          | 11.31      |

---

10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? The final output contains these fields,

- division
- product_code
- product
- total_sold_quantity
- rank_order

  #### SQL Query: -

  ```sql
    WITH total_sold AS (
    SELECT
        p.division,
        s.product_code,
        p.product,
        SUM(s.sold_quantity) AS total_sold_quantity,
        RANK() OVER(partition BY p.division ORDER BY SUM(s.sold_quantity) DESC) AS rank_order
    FROM fact_sales_monthly s
    JOIN dim_product p
        ON s.product_code = p.product_code
    WHERE s.fiscal_year = 2021
    GROUP BY p.division, s.product_code, p.product
    ORDER BY p.division, total_sold_quantity DESC
    )
    SELECT *
    FROM total_sold
    WHERE rank_order <= 3;
  ```

  #### Result:-

  | division | product_code | product             | total_sold_quantity | rank_order |
  | -------- | ------------ | ------------------- | ------------------- | ---------- |
  | N & S    | A6720160103  | AQ Pen Drive 2 IN 1 | 701373              | 1          |
  | N & S    | A6818160202  | AQ Pen Drive DRC    | 688003              | 2          |
  | N & S    | A6819160203  | AQ Pen Drive DRC    | 676245              | 3          |
  | P & A    | A2319150302  | AQ Gamers Ms        | 428498              | 1          |
  | P & A    | A2520150501  | AQ Maxima Ms        | 419865              | 2          |
  | P & A    | A2520150504  | AQ Maxima Ms        | 419471              | 3          |
  | PC       | A4218110202  | AQ Digit            | 17434               | 1          |
  | PC       | A4319110306  | AQ Velocity         | 17280               | 2          |
  | PC       | A4218110208  | AQ Digit            | 17275               | 3          |

---
