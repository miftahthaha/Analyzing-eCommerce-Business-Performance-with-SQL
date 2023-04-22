-- Step 1
-- Creating Table and match data type with the dataset

CREATE TABLE if not exists customers (
	customer_id varchar primary key,
	customer_unique_id varchar,
	customer_zip_code_prefix int,
	customer_city varchar,
	customer_state varchar
);

CREATE TABLE if not exists geolocation (
	geolocation_zip_code_prefix int,
	geolocation_lat decimal,
	geolocation_lng decimal,	
	geolocation_city varchar,
	geolocation_state varchar
);

CREATE TABLE if not exists order_items (
	order_id varchar,
	order_item_id int,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp,
	price numeric,
	freight_value numeric
);

CREATE TABLE if not exists order_payments (
	order_id varchar,
	payment_sequential int,
	payment_type varchar,
	payment_installments int,
	payment_value numeric	
);

CREATE TABLE if not exists order_reviews (
	review_id varchar,
	order_id varchar,
	review_score int,
	review_comment_title varchar,
	review_comment_message varchar,
	review_creation_date timestamp,
	review_answer_timestamp timestamp
);

CREATE TABLE if not exists orders (
	order_id varchar primary key,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp
);

CREATE TABLE if not exists product (
	" " int,
	product_id varchar primary key,
	product_category_name varchar,
	product_name_length float,
	product_description_length float,
	product_photos_qty float,
	product_weight_g float,
	product_length_cm float,
	product_height_cm float,
	product_width_cm float
);

CREATE TABLE if not exists sellers (
	seller_id varchar primary key,
	seller_zip_code_prefix int,
	seller_city varchar,
	seller_state varchar
);


-- Step 2
-- Importing CSV Into Dataset

COPY customers(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
FROM 'E:\Bootcamp\Rakamin Bootcamp Data Scientist\61 Mini Project\01 Analyzing eCommerce Business Performance with SQL\Dataset\customers_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY geolocation(
	geolocation_zip_code_prefix,
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state
)
FROM 'E:\Bootcamp\Rakamin Bootcamp Data Scientist\61 Mini Project\01 Analyzing eCommerce Business Performance with SQL\Dataset\geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_items(
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
)
FROM 'E:\Bootcamp\Rakamin Bootcamp Data Scientist\61 Mini Project\01 Analyzing eCommerce Business Performance with SQL\Dataset\order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_payments(
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
)
FROM 'E:\Bootcamp\Rakamin Bootcamp Data Scientist\61 Mini Project\01 Analyzing eCommerce Business Performance with SQL\Dataset\order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_reviews(
	review_id,
	order_id,
	review_score,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer_timestamp
)
FROM 'E:\Bootcamp\Rakamin Bootcamp Data Scientist\61 Mini Project\01 Analyzing eCommerce Business Performance with SQL\Dataset\order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY orders(
	order_id, 
	customer_id, 
	order_status, 
	order_purchase_timestamp, 
	order_approved_at, 
	order_delivered_carrier_date, 
	order_delivered_customer_date, 
	order_estimated_delivery_date)
FROM 'E:\Bootcamp\Rakamin Bootcamp Data Scientist\61 Mini Project\01 Analyzing eCommerce Business Performance with SQL\Dataset\orders_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY product(
	" ",
	product_id,
	product_category_name,
	product_name_length,
	product_description_length,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
FROM 'E:\Bootcamp\Rakamin Bootcamp Data Scientist\61 Mini Project\01 Analyzing eCommerce Business Performance with SQL\Dataset\product_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY sellers(
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
FROM 'E:\Bootcamp\Rakamin Bootcamp Data Scientist\61 Mini Project\01 Analyzing eCommerce Business Performance with SQL\Dataset\sellers_dataset.csv'
DELIMITER ','
CSV HEADER;


--Step 3
--Determine the foreign key for relation in each data and create The ERD.
--Foreign Key
ALTER TABLE order_items ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE order_items ADD FOREIGN KEY(product_id) REFERENCES product;
ALTER TABLE order_items	ADD FOREIGN KEY(seller_id) REFERENCES sellers;
ALTER TABLE order_payments ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE order_reviews ADD FOREIGN KEY(order_id) REFERENCES orders;
ALTER TABLE orders ADD FOREIGN KEY(customer_id) REFERENCES customers;