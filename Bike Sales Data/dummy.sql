select *
from orders;

select category_name, ROUND(SUM(t1.list_price), 2) as sales,
		ROUND(SUM(t1.quantity * t1.list_price * (1 - t1.discount)),2) as revenue
from order_items t1
inner join orders t2
on t1.order_id = t2.order_id
inner join products t3
on t1.product_id = t3.product_id
inner join categories t4
on t3.category_id = t4.category_id
-- WHERE category_name like '%Child%'
GROUP BY category_name
ORDER BY 1;

select 
		t3.product_name,
        t4.brand_name,
        SUM(t2.quantity) as total_qty_ordered,
        DENSE_RANK() OVER (PARTITION BY brand_name ORDER BY SUM(t2.quantity) DESC) AS qty_rankings
from orders t1
inner join order_items t2
on t1.order_id = t2.order_id
inner join products t3
on t2.product_id = t3.product_id
inner join brands t4
on t3.brand_id = t4.brand_id
GROUP BY t3.product_name, t4.brand_name
;

select count(*)
from orders t1
inner join customers t2
on t1.customer_id = t2.customer_id
;

select t3.customer_id, t3.first_name, t3.last_name, t1.order_id, t1.item_id, t1.product_id,
	   t1.quantity, t1.list_price, t1.discount, ROUND((t1.quantity * (t1.list_price * (1 - t1.discount))), 2) as total_rev,
       ROUND(
        SUM(SUM(t1.quantity * t1.list_price * (1 - t1.discount))) OVER (
            PARTITION BY t3.customer_id 
            ORDER BY t2.order_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2
    ) AS cumulative_spend,
       t2.order_status, t4.product_name
from order_items t1
inner join orders t2
on t1.order_id = t2.order_id
join customers t3
on t2.customer_id = t3.customer_id
join products t4
on t1.product_id = t4.product_id
GROUP BY 
    t3.customer_id,           
    t3.first_name,
    t3.last_name,
    t1.order_id,
    t1.item_id,
    t1.product_id,
    t1.quantity,
    t1.list_price,
    t1.discount,
    t2.order_date,            
    t2.order_status,
    t4.product_name
;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    count(o.order_id) as total_orders,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS total_spend
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spend DESC;

select count(*)
from orders
-- ORDER BY 2
;

select count(*)
from order_items;

select *
from order_items;

select *
from orders;

select *
from order_items t1
join orders t2
on t1.order_id = t2.order_id;

select *
from stores;

select t3.store_name, t3.city,
	   count(t2.order_id) as 'total orders',
	   ROUND((SUM(t1.quantity * t1.list_price * (1 - t1.discount))), 2) as 'store revenue'
from order_items t1
join orders t2
on t1.order_id = t2.order_id
join stores t3
on t2.store_id = t3.store_id
GROUP BY store_name, city
ORDER BY 4 DESC
;


SELECT concat(first_name, ' ', last_name) as 'Customer name'
FROM customers;

-- Finding the brand that made most sales and the total orders for the brand
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

-- Customers who made an order
select concat(first_name, ' ', last_name) as 'Customer name', count(t3.order_id) as 'Total orders'
from orders t1
join customers t2
on t1.customer_id = t2.customer_id
join order_items t3
on t3.order_id = t1.order_id
GROUP BY first_name, last_name
ORDER BY 2 desc
;

select count(*)
from orders t1
join customers t2
on t1.customer_id = t2.customer_id
join order_items t3
on t3.order_id = t1.order_id
-- GROUP BY first_name, last_name
;

select count(*)
from orders t1
inner join customers t2
on t1.customer_id = t2.customer_id
;

select *
from orders
;

-- Finding top 5 customers per store - customer name, total orders, total amount, store name
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

-- Staff who made the most sales
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

-- Products whose stocks are running out i.e. less than 10
SELECT t2.product_name, t3.brand_name, t1.quantity,
		ROW_NUMBER() OVER(PARTITION BY t3.brand_name ORDER BY t1.quantity ASC) AS serial_no
FROM stocks t1
INNER JOIN products t2
ON t1.product_id = t2.product_id
INNER JOIN brands t3
ON t2.brand_id = t3.brand_id
WHERE t1.quantity < 10
;

-- Late deliveries
SELECT concat(first_name, ' ', last_name) AS customer_name, store_name,
		ROW_NUMBER() OVER (PARTITION BY store_name ORDER BY datediff(shipped_date, required_date) ASC) as num,
		order_date, required_date, shipped_date,
		datediff(shipped_date, required_date) AS late_deliveries_by_days
FROM orders t1
INNER JOIN customers t2
ON t1.customer_id = t2.customer_id
INNER JOIN stores t3
ON t1.store_id = t3.store_id
WHERE datediff(shipped_date, required_date) < 0
;

-- Sum of sales generated by each store
SELECT store_name,
		ROUND(SUM(t2.list_price * t2.quantity * (1 - t2.discount)), 2) AS total_sales
FROM orders t1
INNER JOIN order_items t2
ON t1.order_id = t2.order_id
INNER JOIN stores t3
ON t1.store_id = t3.store_id
GROUP BY store_name
ORDER BY 2 DESC
;

select *
from categories
;

-- *** profits per category
with profits as (
select category_name, count(t1.order_id) as total_orders, ROUND(SUM(t1.list_price), 2) as sales,
		ROUND(SUM(t1.quantity * t1.list_price * (1 - t1.discount)),2) as revenue
from order_items t1
inner join orders t2
on t1.order_id = t2.order_id
inner join products t3
on t1.product_id = t3.product_id
inner join categories t4
on t3.category_id = t4.category_id
-- WHERE category_name like '%Child%'
GROUP BY category_name
)
select *, round((revenue - sales), 2) as profits
from profits
;