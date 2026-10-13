-- KPIs
-- 1. Total sales made
SELECT ROUND(SUM(quantity * list_price * (1 - discount)), 2) AS total_sales
FROM order_items;

-- 2. Total orders made
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

-- 3. Total customers served
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM customers;

-- 1. Total sales revenue by product category
SELECT 
		category_name,
        ROUND(SUM(t1.quantity * t1.list_price * (1 - t1.discount)),2) AS sales
FROM order_items t1
INNER JOIN orders t2
ON t1.order_id = t2.order_id
INNER JOIN products t3
ON t1.product_id = t3.product_id
INNER JOIN categories t4
ON t3.category_id = t4.category_id
GROUP BY category_name
ORDER BY 2 DESC
;
-- Mountain bikes category generates the most sales.

-- 2. Top 5 best selling products categorized by brand
SELECT b.brand_name, ROUND(SUM(i.quantity * i.list_price * (1 - i.discount)), 2) AS total_sales
FROM order_items i
JOIN products p
ON i.product_id = p.product_id
JOIN brands b
ON p.brand_id = b.brand_id
GROUP BY brand_name
ORDER BY 2 DESC;
-- Trek brand is the with the most sales

-- 3. Customer lifetime value (CLV) - Listing all customers with their total spend and also the total amount of orders they placed.
SELECT t1.customer_id,
		concat(first_name, ' ', last_name) as 'Customer name',
        count(t1.order_id) AS 'Total orders',
        ROUND(SUM(t3.quantity * t3.list_price * (1 - t3.discount)),2) AS 'Total spend'
FROM orders t1
INNER JOIN customers t2
ON t1.customer_id = t2.customer_id
INNER JOIN order_items t3
ON t1.order_id = t3.order_id
GROUP BY first_name, last_name, t1.customer_id
ORDER BY 1
;

-- 4. Finding the total orders per store and total sales generated per store from highest to lowest
SELECT t3.store_name, t3.city,
	   count(t2.order_id) AS 'total orders',
	   ROUND((SUM(t1.quantity * t1.list_price * (1 - t1.discount))), 2) AS 'store sales'
FROM order_items t1
JOIN orders t2
ON t1.order_id = t2.order_id
JOIN stores t3
ON t2.store_id = t3.store_id
GROUP BY store_name, city
ORDER BY 4 DESC
;
-- Baldwin Bikes store has the most sales and the most orders.

-- 5. Finding the brand that made most sales and the total orders for the brand
SELECT 
		t1.brand_name AS 'Brand name', 
		count(t3.order_id) AS 'Total orders',
		ROUND(SUM(t3.list_price * t3.quantity * (1 - t3.discount)), 2) AS 'Total sales'
FROM brands t1
JOIN products t2
ON t1.brand_id = t2.brand_id
INNER JOIN order_items t3
ON t3.product_id = t2.product_id
INNER JOIN orders t4
ON t4.order_id = t3.order_id
GROUP BY brand_name
ORDER BY 3 DESC, 2 DESC
;
-- Trek bicycle brand is the most sold brand despite being the second ordered brand with only 1235 orders
-- as compared to Electra brand with the highest orders with 1729 but is the second most sold brand.

-- 6. Finding top 5 customers per store by revenue generated/sales - customer name, total orders, total amount, store name
WITH cust_rank AS (
SELECT
	   CONCAT(first_name, ' ', last_name) AS 'Customer name',
       COUNT(t2.order_id) AS 'Total orders',
       ROUND(SUM(t1.list_price * t1.quantity * (1 - t1.discount)), 2) AS total_sales,
       t4.store_name AS store_name,
       RANK() OVER (PARTITION BY store_name 
					ORDER BY ROUND(SUM(t1.list_price * t1.quantity * (1 - t1.discount)), 2) DESC) AS rankings
FROM order_items t1
JOIN orders t2
ON t1.order_id = t2.order_id
JOIN customers t3
ON t3.customer_id = t2.customer_id
JOIN stores t4
ON t4.store_id = t2.store_id
GROUP BY t3.customer_id, concat(first_name, ' ', last_name), store_name
)
SELECT *
FROM cust_rank
WHERE rankings <= 5
;
-- Top customers for Baldwin Bikes store are: Sharyn Hopkins, Pamelia Newman, Abby Gamble, Lyndsey Bean and Emmitt Sanchez
-- Top customers for Rowlett Bikes store are: Elinore Aguilar, Abram Copeland, Mozelle Carter, Lorrie Becker and Charmain Webster
-- Top 5 customers for Santa Cruz Bikes store are: Tameka Fisher, Brigid Sharp, Williemae Holloway, Kasha Todd and Deloris Burke

-- 7. Staff who made the most sales
SELECT t2.staff_id,
		concat(t2.first_name, ' ', t2.last_name) AS staff_name,
        t2.email,
        t2.phone,
        ROUND(SUM(t3.list_price * t3.quantity * (1 - t3.discount)), 2) AS total_sales,
        t4.store_name
FROM orders t1
JOIN staffs t2
ON t2.staff_id = t1.staff_id
JOIN order_items t3
ON t1.order_id = t3.order_id
JOIN stores t4
ON t1.store_id = t4.store_id
GROUP BY t2.staff_id, concat(t2.first_name, ' ', t2.last_name), email, phone, store_name
ORDER BY 5 DESC
;
-- Marcelene Boyer and Venita Daniel from Baldwine bike store made the most sales.

-- 8. Products whose stocks are running out i.e. less than 10
SELECT t2.product_name, t3.brand_name, t2.model_year, t1.quantity,
		ROW_NUMBER() OVER(PARTITION BY t3.brand_name ORDER BY t1.quantity ASC) AS serial_no
FROM stocks t1
INNER JOIN products t2
ON t1.product_id = t2.product_id
INNER JOIN brands t3
ON t2.brand_id = t3.brand_id
WHERE t1.quantity < 10
;

-- 9. Late deliveries 
SELECT concat(first_name, ' ', last_name) AS customer_name, store_name,
		ROW_NUMBER() OVER (PARTITION BY store_name ORDER BY datediff(shipped_date, required_date) ASC) as late_serial_no,
		order_date, required_date, shipped_date,
		datediff(required_date, shipped_date) AS late_deliveries_by_days
FROM orders t1
INNER JOIN customers t2
ON t1.customer_id = t2.customer_id
INNER JOIN stores t3
ON t1.store_id = t3.store_id
WHERE datediff(shipped_date, required_date) > 0
;
-- There were late ddeliveries experienced with maximum delivery by days being 2 days and the minimun being 1 day.