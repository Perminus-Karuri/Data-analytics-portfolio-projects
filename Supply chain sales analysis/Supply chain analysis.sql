-- SQL PORTOLIO PROJECT
-- Total customers
SELECT COUNT(DISTINCT Customer_id) AS total_customers
FROM sales;

-- Total orders
SELECT COUNT(DISTINCT Order_id) AS total_orders
FROM sales;

-- Total sales
SELECT ROUND(SUM(sales), 2) AS total_sales
FROM sales;

-- Total profit
SELECT ROUND(SUM(profit), 2) AS total_profit
FROM sales;

-- Average order value (AOV)
SELECT ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS AOV
FROM sales;

-- Profit margin
SELECT ROUND(SUM(sales), 2) AS sales,
	   ROUND(SUM(profit), 2) AS profit,
       ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin
FROM sales;

-- Sales by category
SELECT category, ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY category
ORDER BY 2 DESC;

-- Sales by segment
SELECT segment, ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY segment
ORDER BY 2 DESC;

-- Segment sales performance
SELECT segment, COUNT(DISTINCT customer_id) AS customers, ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY segment
ORDER BY 3 DESC;

-- Regional sales
SELECT region, ROUND(SUM(sales), 2) AS sales
FROM sales
GROUP BY region
ORDER BY 2 DESC;

-- Regional sales performance
SELECT region,COUNT(DISTINCT customer_id) AS customers, ROUND(SUM(sales), 2) AS sales
FROM sales
GROUP BY region
ORDER BY 3 DESC;

-- 2. PROFITABILITY ANALYSIS
-- Profit by category
SELECT category, ROUND(SUM(profit), 2) AS profit
FROM sales
GROUP BY category
ORDER BY 2 DESC;

-- Profit margin by category
SELECT category, ROUND(SUM(sales), 2) AS sales,
	ROUND(SUM(profit), 2) AS profit,
	ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin
FROM sales
GROUP BY category
ORDER BY 3 DESC;

-- Profit by region
SELECT region, ROUND(SUM(profit), 2) AS profit
FROM sales
GROUP BY region
ORDER BY 2 DESC;

-- Profit margin by region
SELECT region, ROUND(SUM(sales), 2) AS sales,
	ROUND(SUM(profit), 2) AS profit,
	ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin
FROM sales
GROUP BY region
ORDER BY 3 DESC;

-- Profit by segment
SELECT segment, ROUND(SUM(profit), 2) AS profit
FROM sales
GROUP BY segment
ORDER BY 2 DESC;

-- Profit margin by segment
SELECT segment, ROUND(SUM(sales), 2) AS sales,
	ROUND(SUM(profit), 2) AS profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin
FROM sales
GROUP BY segment
ORDER BY 4 DESC;

-- Top customers by sales
SELECT customer_name, ROUND(SUM(sales), 2) AS total_sales
FROM sales
GROUP BY customer_name
ORDER BY 2 DESC
LIMIT 15;

-- Top customers by profit
SELECT customer_name, ROUND(SUM(profit), 2) AS total_profit
FROM sales
GROUP BY customer_name
ORDER BY 2 DESC
LIMIT 15;

-- Regional performance by customers, sales, profit and profit margin
SELECT region, COUNT(DISTINCT customer_id) AS No_of_customers, ROUND(SUM(sales), 2) AS sales,
	ROUND(SUM(profit), 2) AS profit,
	ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin
FROM sales
GROUP BY region;

-- Segment performance by customers, sales, profit and profit margin
SELECT segment, COUNT(DISTINCT customer_id) AS No_of_customers,
	ROUND(SUM(sales), 2) AS sales, ROUND(SUM(profit), 2) AS profit,
	ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin
FROM sales
GROUP BY segment;

-- Discount analysis
-- Maximum and minimum discounts
SELECT MAX(discount) AS max_disc, MIN(discount) AS min_disc
FROM sales;

-- Average discount per category
SELECT category, ROUND(AVG(discount), 2) AS avg_discount
FROM sales
GROUP BY category;

-- Average discount per sub-category
SELECT category, sub_category, ROUND(AVG(discount), 2) AS avg_discount
FROM sales
GROUP BY category, sub_category;

-- Discount bands
-- Maximun discount is 0.8 while the minimum discount 0
-- Discount analysis: By category
SELECT category,
	CASE WHEN discount = 0 THEN '0%'
		 WHEN discount <= 0.1 THEN '1% - 10%'
         WHEN discount <= 0.2 THEN '11% - 20%'
         WHEN discount <= 0.3 THEN '21% - 30%'
         WHEN discount <= 0.4 THEN '31% - 40%'
         WHEN discount <= 0.5 THEN '41% - 50%'
         WHEN discount <= 0.6 THEN '51% - 60%'
         WHEN discount <= 0.7 THEN '61% - 70%'
         WHEN discount <= 0.8 THEN '71% - 80%'
         ELSE NULL
         END AS discount_band,
         COUNT(*) AS transactions,
         ROUND(SUM(profit), 2) AS profit
FROM sales
GROUP BY category, discount_band
ORDER BY category, discount_band, profit DESC;

-- Highly discounted sub-category
SELECT category, sub_category,
	CASE WHEN discount = 0 THEN '0%'
		 WHEN discount <= 0.1 THEN '1% - 10%'
         WHEN discount <= 0.2 THEN '11% - 20%'
         WHEN discount <= 0.3 THEN '21% - 30%'
         WHEN discount <= 0.4 THEN '31% - 40%'
         WHEN discount <= 0.5 THEN '41% - 50%'
         WHEN discount <= 0.6 THEN '51% - 60%'
         WHEN discount <= 0.7 THEN '61% - 70%'
         WHEN discount <= 0.8 THEN '71% - 80%'
         ELSE NULL
         END AS discount_band,
         COUNT(*) AS transactions,
         ROUND(SUM(profit), 2) AS profit
FROM sales
GROUP BY category, sub_category, discount_band
ORDER BY category, sub_category, discount_band, profit DESC;

-- Discount analysis: by segment
SELECT segment, ROUND(AVG(discount), 2) AS avg_disc,
         ROUND(SUM(profit), 2) AS profit
FROM sales
GROUP BY segment;

SELECT segment,
	CASE WHEN discount = 0 THEN '0%'
		 WHEN discount <= 0.1 THEN '1% - 10%'
         WHEN discount <= 0.2 THEN '11% - 20%'
         WHEN discount <= 0.3 THEN '21% - 30%'
         WHEN discount <= 0.4 THEN '31% - 40%'
         WHEN discount <= 0.5 THEN '41% - 50%'
         WHEN discount <= 0.6 THEN '51% - 60%'
         WHEN discount <= 0.7 THEN '61% - 70%'
         WHEN discount <= 0.8 THEN '71% - 80%'
         ELSE NULL
         END AS discount_band,
         COUNT(*) AS transactions,
		 ROUND(SUM(sales), 2) AS sales,
		 ROUND(SUM(profit), 2) AS profit,
		 ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin
FROM sales
GROUP BY segment, discount_band
ORDER BY segment DESC;