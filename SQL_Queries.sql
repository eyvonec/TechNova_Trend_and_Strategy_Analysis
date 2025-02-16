-- 0. Clean Data 
--- Count the % of null to decide how to deal with null
--- Make sure the number of duplications in the data

WITH total_counts AS (
    SELECT COUNT(*) AS total_orders FROM core.orders
),
null_counts AS (
    SELECT 'customer_id' AS column_name, COUNT(*) - COUNT(customer_id) AS null_count FROM core.orders
    UNION ALL
    SELECT 'id' AS column_name, COUNT(*) - COUNT(id) FROM core.orders
    UNION ALL
    SELECT 'purchase_ts' AS column_name, COUNT(*) - COUNT(purchase_ts) FROM core.orders
    UNION ALL
    SELECT 'product_id' AS column_name, COUNT(*) - COUNT(product_id) FROM core.orders
    UNION ALL
    SELECT 'usd_price' AS column_name, COUNT(*) - COUNT(usd_price) FROM core.orders
    UNION ALL
    SELECT 'ship_ts' AS column_name, COUNT(*) - COUNT(ship_ts) FROM core.order_status
    UNION ALL
    SELECT 'delivery_ts' AS column_name, COUNT(*) - COUNT(delivery_ts) FROM core.order_status
    UNION ALL
    SELECT 'refund_ts' AS column_name, COUNT(*) - COUNT(refund_ts) FROM core.order_status
)
SELECT 
    nc.column_name,
    ROUND(nc.null_count * 100.0 / tc.total_orders, 2) AS null_percentage
FROM null_counts nc
CROSS JOIN total_counts tc
ORDER BY null_percentage DESC;

WITH duplicate_orders AS (
    SELECT 
        id AS order_id, 
        COUNT(*) AS duplicate_count
    FROM core.orders
    GROUP BY id
    HAVING COUNT(*) > 1
)
SELECT * FROM duplicate_orders ORDER BY duplicate_count DESC;



-- 1. Customer Retention & Engagement
-- 	What are the purchase patterns of high-value customers?
-- 	What is the behavior of loyalty program members vs. non-members?
-- 	What factors drive higher customer spending?

-- 	Customer Lifetime Value (CLV): Evaluates how valuable a customer is over time. Sum of all purchases by a customer 

SELECT 
    customer_id,
    round(sum(usd_price), 2) AS customer_lifetime_value,
    count(DISTINCT id) AS total_orders,
    round(avg(usd_price), 2) AS avg_order_value
FROM core.orders
GROUP BY 1
ORDER BY customer_lifetime_value DESC
LIMIT 10;

--- the products bought by top 10 customers

WITH top_customers AS (
    -- Get the top 10 customers by CLV
    SELECT 
        customer_id,
        round(sum(usd_price), 2) AS customer_lifetime_value
    FROM core.orders
    GROUP BY 1
    ORDER BY customer_lifetime_value DESC
    LIMIT 10
)
SELECT 
    tc.customer_id,
    o.product_name,
    count(o.id) AS total_purchases,
    round(sum(o.usd_price), 2) AS total_spent_on_product,
    round(avg(o.usd_price), 2) AS avg_price_per_order
FROM core.orders o
LEFT JOIN top_customers tc 
    ON o.customer_id = tc.customer_id
GROUP BY 1, 2
ORDER BY tc.customer_id, total_spent_on_product DESC;


--- monthly rentention rate

WITH monthly_customers AS (
    SELECT 
        date_trunc(purchase_ts, month) AS purchase_month,
        customer_id,
        min(purchase_ts) OVER (PARTITION BY customer_id) AS first_purchase_date
    FROM core.orders
),
cohort_retention AS (
    SELECT 
        mc.purchase_month,
        date_trunc(mc.first_purchase_date, month) AS signup_month,
        COUNT(DISTINCT mc.customer_id) AS retained_customers
    FROM monthly_customers mc
    GROUP BY mc.purchase_month, signup_month
)
SELECT 
    signup_month,
    purchase_month,
    retained_customers,
    ROUND(retained_customers * 100.0 / 
        FIRST_VALUE(retained_customers) OVER (PARTITION BY signup_month ORDER BY purchase_month), 2) 
        AS retention_rate
FROM cohort_retention
ORDER BY signup_month, purchase_month;

-- 	Repeat Purchase Rate: Percentage of customers with more than one order 19.84%

WITH customer_orders AS (
    -- Count the number of orders per customer
    SELECT 
        customer_id, 
        COUNT(DISTINCT id) AS total_orders
    FROM core.orders
    GROUP BY customer_id
)
SELECT 
    count(DISTINCT CASE WHEN total_orders > 1 THEN customer_id END) * 100.0 
        / count(DISTINCT customer_id) AS repeat_purchase_rate
FROM customer_orders;

-- 	Loyalty Program Impact: Comparing CLV, purchase frequency, and order size between loyalty vs. non-loyalty customers

WITH customer_spending AS (
    -- Calculate CLV, Purchase Frequency, and Avg Order Value per Customer
    SELECT 
        o.customer_id,
        sum(o.usd_price) AS total_spent,  -- CLV
        count(DISTINCT o.id) AS total_orders,  -- Purchase Frequency
        round(avg(o.usd_price), 2) AS avg_order_value  -- Avg Order Size
    FROM core.orders o
    GROUP BY o.customer_id
),
loyalty_analysis AS (
    -- Join with the customers table to categorize loyalty program members
    SELECT 
        cs.customer_id,
        c.loyalty_program,
        cs.total_spent,
        cs.total_orders,
        cs.avg_order_value
    FROM customer_spending cs
    LEFT JOIN core.customers c 
        ON cs.customer_id = c.id
)
SELECT 
    loyalty_program,
    count(DISTINCT customer_id) AS total_customers,
    round(avg(total_spent), 2) AS avg_clv,
    round(avg(total_orders), 2) AS avg_purchase_frequency,
    round(avg(avg_order_value), 2) AS avg_order_size
FROM loyalty_analysis
GROUP BY loyalty_program
ORDER BY avg_clv DESC;

--- does loyalty member make only one time purchase? 

WITH customer_orders AS (
    SELECT 
        customer_id,
        loyalty_program,
        count(DISTINCT o.id) AS total_orders
    FROM core.orders o
    LEFT JOIN core.customers c 
        ON o.customer_id = c.id
    GROUP BY customer_id, loyalty_program
)
SELECT 
    loyalty_program,
    count(DISTINCT CASE WHEN total_orders = 1 THEN customer_id END) AS single_purchase_customers,
    count(DISTINCT CASE WHEN total_orders > 1 THEN customer_id END) AS repeat_customers,
    round(count(DISTINCT CASE WHEN total_orders > 1 THEN customer_id END) * 100.0 
          / COUNT(DISTINCT customer_id), 2) AS repeat_purchase_rate
FROM customer_orders
GROUP BY loyalty_program
ORDER BY repeat_purchase_rate DESC;

--- does loyalty program impact refund rate? 
--- customer with loyalty program has higher refund rate than customer without

SELECT 
    c.loyalty_program,
    count(DISTINCT o.id) AS total_orders,
    round(avg(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
FROM core.orders o
LEFT JOIN core.customers c 
    ON o.customer_id = c.id
LEFT JOIN core.order_status os
    ON o.id = os.order_id
GROUP BY c.loyalty_program
ORDER BY refund_rate DESC;

--- does customer join loyalty program simply because they are buying higher price product and may need to refund? 
--- do loyalty program members buy higher priced product? 

SELECT 
    c.loyalty_program,
    round(avg(o.usd_price), 2) AS avg_order_value,
    count(DISTINCT o.id) AS total_orders
FROM core.orders o
JOIN core.customers c 
    ON o.customer_id = c.id
GROUP BY c.loyalty_program
ORDER BY avg_order_value DESC;

--- do loyalty program members refunding higher priced product? 

SELECT 
    c.loyalty_program,
    round(avg(o.usd_price), 2) AS avg_price_of_refunded_orders,
    count(DISTINCT o.id) AS total_orders,
    round(avg(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
FROM core.orders o
LEFT JOIN core.customers c 
    ON o.customer_id = c.id
LEFT JOIN core.order_status os
    ON o.id = os.order_id
WHERE os.refund_ts IS NOT NULL
GROUP BY c.loyalty_program
ORDER BY avg_price_of_refunded_orders DESC;

--- the loyalty program join rate by each product

SELECT 
    CASE WHEN o.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE o.product_name END AS product_name,
    round(avg(c.loyalty_program), 4) AS loyalty_program_join_rate
FROM core.orders o
LEFT JOIN core.customers c
    ON o.customer_id = c.id
GROUP BY 1
ORDER BY 2 DESC;



-- 2. Revenue

-- 	Total revenue from all purchases
-- 	Average Order Value (AOV)

SELECT 
    date_trunc(purchase_ts, month) AS purchase_month,
    round(sum(usd_price), 2) AS total_sales,
    round(avg(usd_price), 2) AS aov
FROM core.orders
GROUP BY 1
ORDER BY 1;

-- 	Revenue by Purchase Platform: Understanding which platforms contribute the most revenue 

SELECT 
    purchase_platform,
    date_trunc(purchase_ts, year) AS purchase_year,
    round(sum(usd_price), 2) AS total_sales,
    round(avg(usd_price), 2) AS aov
FROM core.orders
GROUP BY 1, 2
ORDER BY 1, 2;



-- 3. Logistics
-- 	How long does it take for an order to be shipped and delivered?
-- 	Which regions have the slowest delivery times?

-- 	Order to shipment, shipment to delivery, order to delivery
--- avg_day_order_to_ship: 2.01 day
--- avg_day_ship_to_delivery: 5.5 day
--- avg_day_order_to_delivery: 7.51 day

SELECT 
  round(avg(date_diff(ship_ts, purchase_ts, day)), 2) AS avg_day_order_to_ship,
  round(avg(date_diff(delivery_ts, ship_ts, day)), 2) AS avg_day_ship_to_delivery,
  round(avg(date_diff(delivery_ts, purchase_ts, day)), 2) AS avg_day_order_to_delivery
FROM core.order_status; 

--  Order to shipment, shipment to delivery, order to delivery by region
--- avg_day_order_to_ship: APAC - 2.12; EMEA - 2.08; LATAM - 1.93; NA - 1.97
--- avg_day_ship_to_delivery: APAC - 5.48; EMEA - 5.51; LATAM - 5.5; NA - 5.51
--- avg_day_order_to_delivery: APAC - 5.59; EMEA - 5.59; LATAM - 7.44; NA - 7.48

SELECT 
  geo_lookup.region,
  round(avg(date_diff(order_status.ship_ts, order_status.purchase_ts, day)), 2) AS avg_day_order_to_ship,
  round(avg(date_diff(order_status.delivery_ts, order_status.ship_ts, day)), 2) AS avg_day_ship_to_delivery,
  round(avg(date_diff(order_status.delivery_ts, order_status.purchase_ts, day)), 2) AS avg_day_order_to_delivery
FROM core.order_status
LEFT JOIN core.orders
  ON orders.id = order_status.order_id
LEFT JOIN core.customers
  ON orders.customer_id = customers.id
LEFT JOIN core.geo_lookup
  ON customers.country_code = geo_lookup.country
GROUP BY 1
ORDER BY 1; 

--- Understand the difference from avg for each region
--- diff_day_order_to_ship: faster - LATAM > NA > overall_avg > EMEA > APAC
--- diff_day_ship_to_delivery: faster - APAC > overall_avg = LATAM > EMEA = NA
--- diff_day_order_to_delivery: faster - LATAM > NA > overall_avg > APAC = EMEA

WITH overall_avg AS (
  SELECT 
    round(avg(date_diff(ship_ts, purchase_ts, day)), 2) AS avg_day_order_to_ship,
    round(avg(date_diff(delivery_ts, ship_ts, day)), 2) AS avg_day_ship_to_delivery,
    round(avg(date_diff(delivery_ts, purchase_ts, day)), 2) AS avg_day_order_to_delivery
  FROM core.order_status
),

region_avg AS (
  SELECT 
    geo_lookup.region,
    round(avg(date_diff(order_status.ship_ts, order_status.purchase_ts, day)), 2) AS avg_day_order_to_ship,
    round(avg(date_diff(order_status.delivery_ts, order_status.ship_ts, day)), 2) AS avg_day_ship_to_delivery,
    round(avg(date_diff(order_status.delivery_ts, order_status.purchase_ts, day)), 2) AS avg_day_order_to_delivery
  FROM core.order_status
  LEFT JOIN core.orders
    ON orders.id = order_status.order_id
  LEFT JOIN core.customers
   ON orders.customer_id = customers.id
  LEFT JOIN core.geo_lookup
   ON customers.country_code = geo_lookup.country
  GROUP BY 1
)

SELECT 
    r.region,
    r.avg_day_order_to_ship,
    o.avg_day_order_to_ship AS overall_avg_day_order_to_ship,
    round(r.avg_day_order_to_ship - o.avg_day_order_to_ship, 2) AS diff_day_order_to_ship,

    r.avg_day_ship_to_delivery,
    o.avg_day_ship_to_delivery AS overall_avg_day_ship_to_delivery,
    round(r.avg_day_ship_to_delivery - o.avg_day_ship_to_delivery, 2) AS diff_day_ship_to_delivery,

    r.avg_day_order_to_delivery,
    o.avg_day_order_to_delivery AS overall_avg_day_order_to_delivery,
    round(r.avg_day_order_to_delivery - o.avg_day_order_to_delivery, 2) AS diff_day_order_to_delivery
FROM region_avg r
CROSS JOIN overall_avg o
ORDER BY r.region;



-- 4. Refund Rate
-- 	What percentage of orders result in refunds, and why?

-- 	Refund Rate: Percentage of refunded orders
--- NA > overall > APAC > EMEA > LATAM

WITH overall_refund_rate AS (
  SELECT 
    round(avg(CASE WHEN order_status.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS overall_refund_rate
  FROM core.order_status
),

region_refund_rate AS (
  SELECT
    geo_lookup.region,
    round(avg(CASE WHEN order_status.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
  FROM core.order_status
  LEFT JOIN core.orders
    ON orders.id = order_status.order_id
  LEFT JOIN core.customers
   ON orders.customer_id = customers.id
  LEFT JOIN core.geo_lookup
   ON customers.country_code = geo_lookup.country
  GROUP BY 1
)

SELECT 
  r.region,
  r.refund_rate,
  o.overall_refund_rate,
  round(refund_rate - overall_refund_rate, 4) AS diff_from_overall_refund_rate
FROM region_refund_rate r
CROSS JOIN overall_refund_rate o
ORDER BY 1; 

--- Refund by Product: ThinkPad Laptop > Macbook > iPhone > Monitor > Airpods > Webcam > Cable > Bose
--- Refund by product and region: NA ThinkPad Laptop > NA Macbook > APAC Macbook > LATAM Macbook > EMEA ThinkPad

SELECT distinct product_name
FROM core.orders;

SELECT 
    CASE WHEN o.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE o.product_name END AS product_name,
    round(avg(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
FROM core.order_status os
LEFT JOIN core.orders o 
    ON os.order_id = o.id
GROUP BY 1
ORDER BY refund_rate DESC;

SELECT 
    g.region,
    CASE WHEN o.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE o.product_name END AS product_name,
    round(avg(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
FROM core.order_status os
LEFT JOIN core.orders o 
    ON os.order_id = o.id
LEFT JOIN core.customers c
    ON o.customer_id = c.id
LEFT JOIN core.geo_lookup g
    ON c.country_code = g.country
GROUP BY 1, 2
ORDER BY refund_rate DESC;

--- Refund by purchase platform: website > mobile app
--- Refund by purchase platform and region: NA web > APAC web > LATAM web > EMEA web

SELECT 
  DISTINCT purchase_platform,
  count(id) AS total_orders
FROM core.orders
GROUP BY 1;

-- total orders website 89610 > mobile app 18517

SELECT 
    o.purchase_platform,
    round(avg(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
FROM core.order_status os
LEFT JOIN core.orders o 
    ON os.order_id = o.id
GROUP BY 1
ORDER BY refund_rate DESC;

SELECT 
    g.region,
    o.purchase_platform,
    round(avg(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
FROM core.order_status os
LEFT JOIN core.orders o 
    ON os.order_id = o.id
LEFT JOIN core.customers c
    ON o.customer_id = c.id
LEFT JOIN core.geo_lookup g
    ON c.country_code = g.country
GROUP BY 1, 2
ORDER BY refund_rate DESC;

--- Refund by marketing channel: unknown > social media > direct > affiliate > email 
--- Refund by marketing channel and region: EMEA unknown > NA unknown > APAC social media > NA social media > NA affiliate

SELECT 
    c.marketing_channel,
    round(avg(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
FROM core.order_status os
LEFT JOIN core.orders o 
    ON os.order_id = o.id
LEFT JOIN core.customers c 
    ON o.customer_id = c.id
GROUP BY 1
ORDER BY refund_rate DESC;

SELECT 
    g.region,
    c.marketing_channel,
    round(avg(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
FROM core.order_status os
LEFT JOIN core.orders o 
    ON os.order_id = o.id
LEFT JOIN core.customers c
    ON o.customer_id = c.id
LEFT JOIN core.geo_lookup g
    ON c.country_code = g.country
GROUP BY 1, 2
ORDER BY refund_rate DESC;

--- Refund by oder value : high > medium > low 

SELECT 
  APPROX_QUANTILES(usd_price, 5) AS price_distribution
FROM core.orders;

SELECT 
    CASE 
        WHEN o.usd_price < 50 THEN 'Low ($0-$50)'
        WHEN o.usd_price BETWEEN 50 AND 150 THEN 'Medium ($50-$150)'
        ELSE 'High ($150+)'
    END AS order_value_segment,
    round(avg(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 4) AS refund_rate
FROM core.order_status os
LEFT JOIN core.orders o 
    ON os.order_id = o.id
GROUP BY order_value_segment
ORDER BY refund_rate DESC;



-- 	5. Geographic Order Distribution
--- Apparently, the company is total orders focused more on English speaking countries US > GB > AU > CA

SELECT 
    geo_lookup.region, 
    geo_lookup.country, 
    count(orders.id) AS total_orders,
    round(sum(orders.usd_price), 2) AS total_revenue,
    round(avg(orders.usd_price), 2) AS avg_order_value
FROM core.orders
LEFT JOIN core.customers
    ON orders.customer_id = customers.id
LEFT JOIN core.geo_lookup
    ON customers.country_code = geo_lookup.country
GROUP BY 1, 2
ORDER BY total_orders DESC;

--- Look for total_orders by region: NA > EMEA > APAC > LATAM
--- avg_order_value by region: APAC > NA > EMEA > LATAM

SELECT 
    geo_lookup.region, 
    count(orders.id) AS total_orders,
    round(sum(orders.usd_price), 2) AS total_revenue,
    round(avg(orders.usd_price), 2) AS avg_order_value
FROM core.orders
LEFT JOIN core.customers
    ON orders.customer_id = customers.id
LEFT JOIN core.geo_lookup
    ON customers.country_code = geo_lookup.country
GROUP BY 1
ORDER BY total_orders DESC;

SELECT 
    geo_lookup.region, 
    count(orders.id) AS total_orders,
    round(sum(orders.usd_price), 2) AS total_revenue,
    round(avg(orders.usd_price), 2) AS avg_order_value
FROM core.orders
LEFT JOIN core.customers
    ON orders.customer_id = customers.id
LEFT JOIN core.geo_lookup
    ON customers.country_code = geo_lookup.country
GROUP BY 1
ORDER BY avg_order_value DESC;



-- 6. Customer Acquisition & Growth
-- 	Which marketing channels are the most profitable?

-- 	New vs. Returning Customers: Comparing first-time vs. repeat customers 

WITH first_order AS (
    -- Find the first purchase timestamp for each customer
    SELECT 
        customer_id, 
        MIN(purchase_ts) AS first_purchase_ts
    FROM core.orders
    GROUP BY customer_id
),
customer_type AS (
    -- Classify customers as 'New' if their purchase matches their first purchase
    SELECT 
        o.customer_id,
        CASE 
            WHEN o.purchase_ts = f.first_purchase_ts THEN 'New Customer'
            ELSE 'Returning Customer'
        END AS customer_status,
        o.usd_price
    FROM core.orders o
    LEFT JOIN first_order f
        ON o.customer_id = f.customer_id
)
SELECT 
    customer_status,
    count(DISTINCT customer_id) AS total_customers,
    count(*) AS total_orders,
    round(sum(usd_price), 2) AS total_revenue,
    round(avg(usd_price), 2) AS avg_order_value
FROM customer_type
GROUP BY customer_status
ORDER BY total_customers DESC;

-- 	Marketing Channel Effectiveness: Revenue contribution by marketing_channel 

SELECT 
  c.marketing_channel,
  count(o.id) AS total_orders,
  round(sum(o.usd_price), 2) AS total_sales,
  round(avg(o.usd_price), 2) AS avg_order_value
FROM core.orders o
LEFT JOIN core.customers c
  ON o.customer_id = c.id
GROUP BY 1
ORDER BY 2 DESC;

-- 	Account Creation Trends: Monthly sign-up trends 

SELECT 
  date_trunc(created_on, month) AS account_creation_month,
  count(id) AS new_account_count
FROM core.customers
GROUP BY 1
ORDER BY 2 DESC;

--- Relation between first purchase and account creation and marketing_channel: social media > affiliate > email > direct

WITH first_purchase AS (
    -- Find the first purchase date per customer
    SELECT 
        customer_id, 
        MIN(purchase_ts) AS first_purchase_date
    FROM core.orders
    GROUP BY customer_id
),
customer_marketing AS (
    -- Join customer sign-up data with first purchase
    SELECT 
        c.id,
        c.created_on AS account_creation_date,
        c.marketing_channel,
        f.first_purchase_date,
        DATE_DIFF(f.first_purchase_date, c.created_on, DAY) AS days_to_first_purchase
    FROM core.customers c
    LEFT JOIN first_purchase f 
        ON c.id = f.customer_id
)
SELECT 
    marketing_channel,
    count(DISTINCT id) AS total_signups,
    count(DISTINCT first_purchase_date) AS converted_customers,
    round(count(DISTINCT first_purchase_date) * 100.0 / count(DISTINCT id), 2) AS conversion_rate,
    round(avg(days_to_first_purchase), 2) AS avg_days_to_first_purchase
FROM customer_marketing
GROUP BY marketing_channel
ORDER BY conversion_rate DESC;
