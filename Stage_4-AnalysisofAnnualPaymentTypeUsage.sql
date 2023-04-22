WITH payment_detail AS(
	SELECT payment_type,
       COUNT(order_id) AS total_transaction
	FROM order_payments
	GROUP BY payment_type
	ORDER BY total_transaction DESC
), 
payment_type AS(
	SELECT payment_type,
       SUM(CASE WHEN(date_part('year', order_purchase_timestamp)) = 2016 THEN 1 ELSE 0 END) AS year_2016,
       SUM(CASE WHEN(date_part('year', order_purchase_timestamp)) = 2017 THEN 1 ELSE 0 END) AS year_2017,
       SUM(CASE WHEN(date_part('year', order_purchase_timestamp)) = 2018 THEN 1 ELSE 0 END) AS year_2018
	FROM order_payments AS op
	JOIN orders o ON op.order_id = o.order_id 
	GROUP BY 1
	ORDER BY 4 DESC
)
SELECT 	pd.payment_type, pd.total_transaction, pt.year_2016, pt.year_2017, pt.year_2018
FROM payment_detail AS pd
JOIN payment_type AS pt ON pd.payment_type = pt.payment_type