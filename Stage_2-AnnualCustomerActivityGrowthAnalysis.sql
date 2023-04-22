--Task 1
--Calculate Monthly Active User (MAU) average by year

WITH mau AS (
	SELECT year, round(AVG(mau), 3) AS avg_mau
	FROM (
		SELECT date_part('year', o.order_purchase_timestamp) AS year,
			date_part('month', o.order_purchase_timestamp) AS month,
			count(distinct cs.customer_unique_id) AS mau
		FROM orders AS o
		JOIN customers AS cs ON o.customer_id = cs.customer_id
		GROUP BY 1, 2
	) subq
	GROUP BY 1
	ORDER BY 1 ASC
	),

-- Task 2
-- New Customer (First Order) by Year
new_customer AS(
	SELECT 	date_part('year', first_order) AS year, 
		COUNT(DISTINCT customer_unique_id) AS total_new_customer
	FROM(
		SELECT 	cs.customer_unique_id,
			min(o.order_purchase_timestamp) AS first_order
		FROM orders AS o
		JOIN customers AS cs ON o.customer_id = cs.customer_id
		GROUP BY 1
		) subq
	GROUP BY 1
	ORDER BY 1 ASC
	),

-- Task 3
-- Regular Customer (Repeat Order) by Year
repeat AS(
	SELECT 	year,
		COUNT(customer) AS total_repeat_customer
	FROM(
		SELECT cs.customer_unique_id, 
			COUNT(1) AS customer,
			date_part('year', o.order_purchase_timestamp) AS year
		FROM orders AS o
		JOIN customers AS cs ON o.customer_id = cs.customer_id
		GROUP BY 1, 3
		HAVING COUNT (1) > 1
	) subq
	GROUP BY 1
	ORDER BY 1 ASC
),

-- Task 4
-- Average Order by Year
avg_freq AS(
	SELECT 	year,
		ROUND(AVG(total_order), 3) AS avg_total_order
	FROM(
		SELECT  cs.customer_unique_id, 
			date_part('year', o.order_purchase_timestamp) AS year, 
			COUNT(1) AS total_order
		FROM orders AS o
		JOIN customers AS cs ON o.customer_id = cs.customer_id
	GROUP BY 1, 2
	) subsq
	GROUP BY 1
	ORDER BY 1 ASC
)
select m.year, m.avg_mau, nc.total_new_customer, r.total_repeat_customer, af.avg_total_order
from mau as m
join new_customer as nc on m.year = nc.year
join repeat as r on m.year = r.year
join avg_freq as af on m.year = af.year;