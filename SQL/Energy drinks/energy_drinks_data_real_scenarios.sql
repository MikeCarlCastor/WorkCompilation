SELECT * 
FROM energy_drinks_data
WHERE year = 2020;

--Who are the competitors?--
SELECT DISTINCT Company
FROM energy_drinks_data;

--How much sales revenue was made last year?--
SELECT SUM (sales_usd_millions)
FROM energy_drinks_data
WHERE year = 2021;

--What drink earned the most last year? How about the least?--
--Answer 1--
SELECT DISTINCT product,
SUM(sales_usd_millions) AS total_sales
FROM energy_drinks_data
WHERE company IN ('Light Right', 'Red Rush', 'Dark Horse', 'Caffeine Crush')
AND year = 2021
GROUP BY product
ORDER BY total_sales DESC;
--Answer 2--
SELECT *
FROM energy_drinks_data
WHERE year = 2021
ORDER BY sales_usd_millions DESC;
--Answer 3--
SELECT MAX(sales_usd_millions) AS earned_the_most, MIN(sales_usd_millions) AS earned_the_least
FROM energy_drinks_data
WHERE year = 2021;

--Show me the history of the highest earning drink.
--and take out the decimals pg_relation_size.
SELECT type, company, product, year,
ROUND(sales_usd_millions,0) AS sales_no_decimal
FROM energy_drinks_data
WHERE product = 'Dark Horse';

--Can you show me the yearly revenue for light and regular drinks?--
SELECT type, year,
ROUND(SUM(sales_usd_millions),0) AS yearly_revenue
FROM energy_drinks_data
WHERE type IN ('Light', 'Regular')
GROUP BY type, year
ORDER BY type, YEAR DESC;

--Is there a competitor that left the market?
--If yes, who was it and what year did they leave?
SELECT company, year, type
FROM energy_drinks_data
GROUP BY 1, 2, 3
ORDER BY 1, 2 DESC;

--Insights--
--Investing on light drinks would be a good move since
--there an evident increase of revenue for this type of drink every year.
--Also, all companies remained in the market up to now EXCEPT
--Red Rush since they invested on regular drinks alone.