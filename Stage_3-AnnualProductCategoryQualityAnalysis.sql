-- Task 1
-- define total revenue each year.
WITH annual_revenue AS(
	SELECT date_part('year', order_purchase_timestamp) AS year,
       ROUND(SUM(revenue)) AS total_revenue
	FROM(
		SELECT order_id, 
			SUM(price + freight_value) AS revenue
		FROM order_items
		GROUP BY 1
	) subsq
	JOIN orders AS o
	ON subsq.order_id = o.order_id
	WHERE order_status = 'delivered'
	GROUP BY 1
	ORDER BY 1 ASC
),

-- Task 2
-- define total canceled customer each year.
canceled_order AS(
	SELECT date_part('year', order_purchase_timestamp) AS year,
       SUM(coc) AS canceled_order
	FROM(
		SELECT order_id, 
			COUNT(*) AS coc
		FROM order_items
		GROUP BY 1
	) subsq
	JOIN orders AS o
	ON subsq.order_id = o.order_id
	WHERE order_status = 'canceled'
	GROUP BY 1
	ORDER BY 1 ASC
),

-- Task 3
-- Define top total revenue product each year.
top_revenue_product AS(
	SELECT year, product_category_name AS top_product_category, 
		ROUND(total_revenue) AS top_product_revenue
	FROM (SELECT year, p.product_category_name,
             SUM(t1.revenue) AS total_revenue,
             RANK() OVER (PARTITION BY year ORDER BY SUM(t1.revenue) DESC) AS value_rank
		  FROM (SELECT order_id, date_part('year', order_purchase_timestamp) AS year
				FROM orders
				WHERE order_status = 'delivered'
			   ) AS o
		  JOIN (SELECT order_id, product_id, SUM(price + freight_value) AS revenue
				FROM order_items
				GROUP BY order_id, product_id
			   ) AS t1
		  ON o.order_id = t1.order_id
		  JOIN product p ON t1.product_id = p.product_id
		  GROUP BY year, p.product_category_name
		 ) AS t3
	WHERE value_rank = 1
	),

-- Task 4
-- Define top cancelled product each year.
top_canceled_product AS(
	SELECT year, product_category_name AS most_canceled_product, total_most_canceled_orders
	FROM (SELECT year, p.product_category_name,
             SUM(t1.num_canceled_orders) AS total_most_canceled_orders,
             RANK() OVER (PARTITION BY year ORDER BY SUM(t1.num_canceled_orders) DESC
						 ) AS value_rank
		  FROM (SELECT order_id, date_part('year', order_purchase_timestamp) AS year
				FROM orders
				WHERE order_status = 'canceled'
			   ) AS o
		  JOIN (SELECT order_id, product_id,
                   COUNT(order_id)
                   AS num_canceled_orders
				FROM order_items
				GROUP BY order_id, product_id
			   ) AS t1
		  ON o.order_id = t1.order_id
		  JOIN product AS p ON t1.product_id = p.product_id
		  GROUP BY year, p.product_category_name
		 ) AS t3
	WHERE value_rank = 1
)

-- Task 5
-- Create summary.
SELECT ar.year, ar.total_revenue, co.canceled_order, trp.top_product_category, 
	trp.top_product_revenue, tcp.most_canceled_product, tcp.total_most_canceled_orders
FROM annual_revenue AS ar
JOIN canceled_order AS co ON ar.year = co.year
JOIN top_revenue_product AS trp ON ar.year = trp.year
JOIN top_canceled_product AS tcp ON ar.year = tcp.year