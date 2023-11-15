CREATE DATABASE salesdataWalmart 

-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- ------------------------------------------------------------------------------------
-- EDA (Exploratory Data Analysis)
-- GENERIC QUESTION -------------------------------------------------------------------
-- 1. How many unique cities does the data have ?
SELECT 
	DISTINCT city
FROM sales;

-- 2. In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;

-- ---------------------------------------------------------------------------------------
-- Product Question ---------------------------------------------------------------------
-- 1. What is the most selling product line

SELECT
	DISTINCT `Product line`
FROM sales;

SELECT
	SUM(quantity) as qty,
    `Product line`
FROM sales
GROUP BY `Product line`
ORDER BY qty DESC;

-- 2. What is the most selling product line
SELECT
	SUM(quantity) as qty,
   `Product line`
FROM sales
GROUP BY `Product line`
ORDER BY qty DESC;

-- 3. What is the total revenue by month
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;


-- 4. What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;


-- 5. What product line had the largest revenue?
SELECT
	`Product line`,
	SUM(total) as total_revenue
FROM sales
GROUP BY `Product line`
ORDER BY total_revenue DESC;

-- 6. What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;


-- 7. What product line had the largest VAT?
SELECT
 `Product line`,
	AVG(`Tax 5%`) as avg_tax
FROM sales
GROUP BY `Product line`
ORDER BY avg_tax DESC;


-- 8. Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	`Product line`,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY `Product line`;


-- 9. Which branch sold more products than average product sold?

SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- 10. What is the most common product line by gender
SELECT
	gender,
    `Product line`,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, `Product line`
ORDER BY total_cnt DESC;

-- 11. What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
   `Product line`
FROM sales
GROUP BY `Product line`
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- -- Customers related Questiona-------------------------------
-- --------------------------------------------------------------------

-- 1. How many unique customer types does the data have?
SELECT
	DISTINCT `Customer type`
FROM sales;

-- 2. How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;


-- 3. What is the most common customer type?
SELECT
	`Customer type`,
	count(*) as count
FROM sales
GROUP BY `Customer type`
ORDER BY count DESC;

-- 4. Which customer type buys the most?
SELECT
	`Customer type`,
    COUNT(*)
FROM sales
GROUP BY `Customer type`;


-- 5. What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- 6.  What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- 7. Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- 8. Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- 9. Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- 10. Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- 1.Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- 2. Which of the customer types brings the most revenue?
SELECT
	`Customer type`,
	SUM(total) AS total_revenue
FROM sales
GROUP BY `Customer type`
ORDER BY total_revenue;

-- 3. Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(`Tax 5%`), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- 4. Which customer type pays the most in VAT?
SELECT
	`Customer type`,
	AVG(`Tax 5%`) AS total_tax
FROM sales
GROUP BY `Customer type`
ORDER BY total_tax;

-- --------------------------------------------------------------------
-- --------------------------------THANKYOU!------------------------------------

