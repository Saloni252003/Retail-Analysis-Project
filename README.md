# Retail Data Analysis using SQL
## 📌 Project Overview

This project focuses on analyzing a retail database to generate meaningful business insights using SQL.
The objective was to understand customer behavior, revenue trends, seller performance, delivery efficiency, and payment patterns to support data-driven decision-making.

The project demonstrates how SQL can be used to solve real-world business problems using structured queries and analytical techniques.

## 🎯 Objectives

▪️ Analyze customer purchase behavior and retention

▪️ Identify the most preferred payment methods

▪️ Study monthly revenue growth trends

▪️ Evaluate delivery efficiency and its impact on reviews

▪️ Identify top-performing sellers by state

▪️ Discover high-performing geographic regions

## 🛠️ Tools & Technologies

▪️ Joins

▪️ CTEs (Common Table Expressions)

▪️ Window Functions

▪️ Aggregations

▪️ Relational Database Concepts

## 📊 Key Analysis & Findings
1️⃣ Customer Analysis

▪️ Identified 96,000+ unique customers

▪️ Observed that a significant portion of customers are one-time buyers
### Code : 
SELECT COUNT(DISTINCT(customer_unique_id)) AS total_unique_costomer 
FROM customers;
<img width="1197" height="410" alt="image" src="https://github.com/user-attachments/assets/b00b2701-6ba0-4872-8f59-7b5ab5317a9a" />


2️⃣ Payment Analysis

▪️ Credit Card is the most preferred payment method
### Code :
SELECT p.payment_type, count(*) AS most_common_payment 
FROM payments p
GROUP BY p.payment_type
ORDER BY most_common_payment DESC
LIMIT 1;
<img width="1200" height="302" alt="image" src="https://github.com/user-attachments/assets/a5884c42-4945-4a25-8fce-b70ceb09ecd3" />

3️⃣ Revenue Analysis

▪️ Monthly revenue initially showed strong growth

▪️ Later periods indicated revenue decline trends
### Code :
SELECT count(customer_id) as highest_no_customer ,customer_state  
 FROM customers  
GROUP BY customer_state 
ORDER BY highest_no_customer DESC 
LIMIT 5 ;
<img width="1046" height="331" alt="image" src="https://github.com/user-attachments/assets/a72bbfea-1c5f-4429-bbe4-a9ac265eed67" />

4️⃣ Geographic Insights

▪️ Certain states contribute the majority of customers and revenue

▪️ Revenue distribution is geographically concentrated
### Code :
SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_time
FROM orders
WHERE order_status = 'delivered';
<img width="958" height="296" alt="image" src="https://github.com/user-attachments/assets/532a9987-7fce-4bbd-81b2-af902d3fef94" />


5️⃣ Delivery Performance

▪️ Delivery efficiency directly impacts customer review scores

▪️ Delays negatively affect customer satisfaction
### Code :
WITH monthly AS (SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month, SUM(oi.price + oi.freight_value) AS monthly_revenue
FROM orders o
JOIN order_item oi ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m'))SELECT month, monthly_revenue, LAG(monthly_revenue) OVER (ORDER BY month) AS prev_month_revenue, ROUND((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month)) / LAG(monthly_revenue) OVER (ORDER BY month) * 100,2) AS growth_percent
FROM monthly
ORDER BY month;
<img width="1236" height="445" alt="image" src="https://github.com/user-attachments/assets/24c96841-787e-41c1-9e09-c43e118be584" />


6️⃣ Seller Performance

▪️ Top 3 sellers in each state generate significant revenue

▪️ Revenue contribution is uneven across sellers
### Code :
SELECT seller_state, seller_id, revenue 
FROM (SELECT s.seller_state, s.seller_id, SUM(oi.price + oi.freight_value) AS revenue, ROW_NUMBER() OVER (PARTITION BY s.seller_state ORDER BY SUM(oi.price + oi.freight_value) DESC) AS rn
FROM order_item oi
JOIN sellers s ON s.seller_id = oi.seller_id
GROUP BY s.seller_state, s.seller_id) AS ranked_sellers
WHERE rn <= 3
ORDER BY seller_state, revenue DESC;
<img width="975" height="420" alt="image" src="https://github.com/user-attachments/assets/7e7f67b6-8c7d-4603-b66c-bf51431555f5" />

## 💡 Business Insights

▪️ Focus on improving customer retention strategies

▪️ Strengthen partnerships with high-performing sellers

▪️ Improve delivery timelines to enhance customer satisfaction

▪️ Expand marketing efforts in high-potential regions

▪️ Optimize payment-based promotional strategies


##  Conclusion

This project highlights the power of SQL in transforming raw retail data into actionable business insights. It reflects practical problem-solving skills and a strong understanding of data-driven business analysis.

## About Me
Aspiring Data Analyst with a strong interest in transforming raw data into meaningful business insights.

LinkedIn: https://www.linkedin.com/in/saloni-g-a6629139b
