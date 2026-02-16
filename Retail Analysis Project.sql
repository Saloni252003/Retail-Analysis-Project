CREATE DATABASE Retail;
USE Retail;

-- Geolocation
CREATE TABLE  geolocation(
geolocation_zip_code_prefix int not null,
geolocation_lat text not null,
geolocation_lng text not null,
geolocation_city varchar(225) not null,
geolocation_state varchar(225) not null);

-- Customers
CREATE TABLE  customers(
customer_id varchar(225) primary key,
customer_unique_id varchar(225) not null,
customer_zip_code_prefix int not null,
customer_city varchar(225) not null,
customer_state varchar(225) not null);

-- Sellers
CREATE TABLE sellers(
seller_id varchar(225) primary key,
seller_zip_code_prefix int not null,
seller_city varchar(225) not null,
seller_state varchar(100) not null);

-- Products
CREATE TABLE  products(
product_id varchar(225) primary key,
`product category` varchar(225) null,
product_name_length text null,
product_description_length text null,
product_photos_qty text null,
product_weight_g text null,
product_length_cm text null,
product_height_cm text null,
product_width_cm text null);

-- Orders
CREATE TABLE orders(
order_id varchar(225) primary key,
customer_id varchar(225) not null,
order_status varchar(225) not null,
order_purchase_timestamp text not null,
order_approved_at text null,
order_delivered_carrier_date text null,
order_delivered_customer_date text null,
order_estimated_delivery_date text not null,
foreign key(customer_id) references customers(customer_id));

-- Payments
CREATE TABLE  payments(
order_id varchar(225),
payment_sequential tinyint not null,
payment_type varchar(225) not null,
payment_installments tinyint not null,
payment_value decimal not null,
foreign key(order_id) references orders(order_id));

-- Order_review
CREATE TABLE  order_review(
review_id varchar(225) primary key,
order_id varchar(225),
review_score tinyint not null,
review_comment_title text,
review_creation_date text not null,
review_answer_timestamp text not null,
foreign key(order_id) references orders(order_id));

-- order_item
CREATE TABLE  order_item(
order_id varchar(225),
order_item_id char(20),
product_id varchar(225),
seller_id varchar(225),
shipping_limit_date text not null,
price text not null,
freight_value decimal not null,
foreign key(order_id) references orders(order_id),
foreign key(product_id) references products(product_id),
foreign key(seller_id) references sellers(seller_id));




## geolocation
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/geolocation.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(geolocation_zip_code_prefix, geolocation_lat ,geolocation_lng, geolocation_city, geolocation_state);

## customers
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO
TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);

## sellers
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sellers.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(seller_id, seller_zip_code_prefix, seller_city, seller_state);

## products
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, `product category`, product_name_length, product_description_length, product_photos_qty, product_weight_g,
product_length_cm, product_height_cm, product_width_cm);

## orders
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date,
order_delivered_customer_date, order_estimated_delivery_date);

## payments
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/payments.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id ,payment_sequential ,payment_type, payment_installments ,payment_value);

## Order_review
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_reviews.csv'
REPLACE
INTO TABLE order_review
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, order_id, review_score, review_creation_date, review_answer_timestamp);

## order_item
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
REPLACE
INTO TABLE order_item
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value
);

SHOW VARIABLES LIKE 'secure_file_priv';


SELECT * FROM customers;
SELECT * FROM geolocation;
SELECT * FROM order_item;
SELECT * FROM order_review;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM products;
SELECT * FROM sellers;


## Assignment Tasks
-- The assignment is divided into domains to simulate real-world business analysis.
-- ● Customer Analysis
-- 1. Find the total number of unique customers.
SELECT COUNT(DISTINCT(customer_unique_id)) AS total_unique_costomer FROM customers;

/* 2. Identify the top 5 states with the highest number of customers. - Calculate customer retention rate
 (customers who placed more than 1 order). - Find customers who gave the lowest review scores more than twice.*/
 
 ## Top 5 States
 SELECT count(customer_id) as highest_no_customer ,customer_state  
 FROM customers 
 GROUP BY customer_state
 ORDER BY highest_no_customer DESC
 LIMIT 5 ;

SELECT customer_id 
FROM orders
GROUP BY customer_id
HAVING count(order_id) > 1  ;

## calculate customer retention rate
SELECT (COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM orders)) * 100 AS retention_rate_percentage
FROM (SELECT customer_id FROM orders GROUP BY customer_id HAVING COUNT(order_id) > 1) AS retained;
 
## Find customers who gave the lowest review scores more than twice
SELECT o.customer_id, COUNT(*) AS low_score_count
FROM order_review r
JOIN orders o ON r.order_id = o.order_id
WHERE r.review_score = 1
GROUP BY o.customer_id
HAVING COUNT(*) > 2;

-- ● Order & Delivery Analysis
-- 1. Count the total number of delivered vs. canceled orders.
SELECT order_status, count(*) AS total_count FROM orders
WHERE order_status IN ('delivered' , 'canceled')
GROUP BY order_status;

-- 2. Calculate the average delivery time for delivered orders.
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_time
FROM orders
WHERE order_status = 'delivered';

-- 3. Identify the top 5 cities with the fastest delivery times.
SELECT c.customer_city, AVG(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS fastest_delivery
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id 
WHERE o.order_status = 'delivered'
GROUP BY c.customer_city
ORDER BY  fastest_delivery 
LIMIT 5;

-- 4. Determine the percentage of orders delivered late vs. estimated date. - Find the month with the maximum number of orders.
SELECT concat(round((
sum(CASE
WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0
END) *100)/count(*),2),'%') AS late_delivered FROM orders
WHERE order_status = 'delivered';

SELECT DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS month, COUNT(*)
FROM orders
GROUP BY month
ORDER BY COUNT(*) DESC
LIMIT 1;


-- ● Product & Category Analysis.
-- 1. Find the top 10 most sold product categories.

SELECT p.`product category`, COUNT(*) AS quantity
FROM order_item oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.`product category`
ORDER BY quantity DESC
LIMIT 10;


-- 2. Calculate average weight, length, height, and width for products in each category. - Identify products with the highest freight-to-price ratio.
SELECT * FROM products;
SELECT `product category`, AVG(product_weight_g) AS weight , AVG(product_length_cm) AS length, 
AVG(product_height_cm) AS height, AVG(product_width_cm) AS width FROM products 
GROUP BY `product category`;
SELECT * FROM order_item;
SELECT p.product_id, p.`product category`, 
(o.freight_value/o.price) AS freight_to_price_ratio
FROM order_item o
JOIN products p ON p.product_id = o.product_id
ORDER BY freight_to_price_ratio DESC
LIMIT 1;

-- 3. Find the top 3 products (by revenue) in each category.
SELECT product_category, revenue
FROM (SELECT p.`product category` AS product_category, SUM(o.price) AS revenue, ROW_NUMBER() 
OVER (PARTITION BY p.`product category` ORDER BY SUM(o.price) DESC) AS r
FROM order_item o
JOIN products p ON p.product_id = o.product_id
GROUP BY p.`product category`, o.product_id) p
WHERE r <= 3;

-- ● Payment & Revenue Analysis
-- 1. Find the most common payment type.
SELECT p.payment_type, count(*) AS most_common_payment
FROM payments p
GROUP BY p.payment_type
ORDER BY most_common_payment DESC
LIMIT 1;

-- 2. Calculate revenue by payment type.
SELECT p.payment_type, sum(o.price) AS revenue
FROM payments p
JOIN order_item o  ON o.order_id = p.order_id
GROUP BY p.payment_type
ORDER BY revenue ;

/* 3. Determine the average number of installments for credit card payments. 
- Find the top 5 highest-value orders and their payment details.*/
SELECT AVG(payment_installments) AS avg_installment
FROM payments
WHERE payment_type = 'credit_card';

WITH order_values AS (SELECT oi.order_id,SUM(oi.price) AS total_value FROM order_item oi GROUP BY oi.order_id)
SELECT ov.order_id,ov.total_value,p.payment_type,p.payment_installments,p.payment_value
FROM order_values ov
JOIN payments p 
    ON p.order_id = ov.order_id
ORDER BY ov.total_value DESC
LIMIT 5;

-- ● Review Analysis
-- 1. Find the average review score per product category.
SELECT p.`product category`,AVG(o.review_score) AS avg_score
FROM order_review o
JOIN order_item oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.`product category`
ORDER BY avg_score;

-- 2. Identify sellers consistently receiving reviews below 3
SELECT s.seller_id, o.review_score
FROM sellers s
JOIN order_item oi ON oi.seller_id = s.seller_id
JOIN order_review o ON o.order_id = oi.order_id
WHERE o.review_score < 3;

/* 3. Determine if there is a correlation between delivery time and review score. 
- Find the distribution of review scores across states.*/
SELECT oi.review_score, AVG(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_del_time
FROM orders o
JOIN order_review oi ON o.order_id = oi.order_id
GROUP BY oi.review_score
ORDER BY oi.review_score;

SELECT c.customer_state, oi.review_score 
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_review oi ON oi.order_id = o.order_id
GROUP BY c.customer_state,oi.review_score
ORDER BY c.customer_state,oi.review_score;

-- ● Seller & Location Analysis
-- 1. Count the number of sellers per state.
SELECT seller_state, count(*) AS sellers_per_state
FROM sellers
GROUP BY seller_state
ORDER BY sellers_per_state ;

-- 2. Find sellers with the highest total sales revenue.
SELECT seller_id, sum(price + freight_value) AS total_revenue
FROM order_item
GROUP BY seller_id
ORDER BY total_revenue DESC;

-- 3. Identify the top 5 cities with the highest seller density.
SELECT seller_city , count(*) AS seller_density
FROM sellers
GROUP BY seller_city
ORDER BY seller_density DESC
LIMIT 5;

-- 4. Match customers and sellers by ZIP code to find local transactions.
SELECT c.customer_id,c.customer_city, c.customer_zip_code_prefix AS customer_zip,
s.seller_zip_code_prefix AS seller_zip, s.seller_id, s.seller_city
FROM customers c
JOIN orders o ON c.customer_id = o. customer_id
JOIN order_item oi ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE c.customer_zip_code_prefix = s.seller_zip_code_prefix;

-- ● Advanced Analytics
-- 1. Calculate monthly revenue growth and plot a trend line.
WITH monthly AS (SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month, SUM(oi.price + oi.freight_value) AS monthly_revenue
FROM orders o
JOIN order_item oi ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m'))
SELECT month, monthly_revenue, LAG(monthly_revenue) OVER (ORDER BY month) AS prev_month_revenue,
 ROUND((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month)) / LAG(monthly_revenue) OVER (ORDER BY month) * 100,2) AS growth_percent
FROM monthly
ORDER BY month;



/* 2. Analyze customer purchase frequency (one-time vs. repeat). 
- Find the contribution percentage of each product category to overall revenue. 
- Identify the top 3 sellers in each state by revenue.*/
SELECT customer_id , count(order_id) AS frequency
FROM orders
GROUP BY customer_id
ORDER BY frequency ;   

SELECT p.`product category`, SUM(oi.price) * 100 / 
(SELECT SUM(price) FROM order_item) AS contribution_percentage
FROM order_item oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.`product category`
ORDER BY contribution_percentage DESC;

SELECT seller_state, seller_id, revenue 
FROM (SELECT s.seller_state, s.seller_id, SUM(oi.price + oi.freight_value) AS revenue, ROW_NUMBER() 
OVER (PARTITION BY s.seller_state ORDER BY SUM(oi.price + oi.freight_value) DESC) AS rn
FROM order_item oi
JOIN sellers s ON s.seller_id = oi.seller_id
GROUP BY s.seller_state, s.seller_id) AS ranked_sellers
WHERE rn <= 3
ORDER BY seller_state, revenue DESC;

