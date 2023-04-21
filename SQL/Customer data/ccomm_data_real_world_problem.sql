--What is the total revenue lost from churning customers?--
SELECT SUM(revenue_usd) AS total_revenue_lost
FROM ccomm_data
WHERE customer_churned = '1';
--Answer: 1,248,074.950

--How many customers churned?--
SELECT count(customer_churned)
FROM ccomm_data
WHERE customer_churned = '1';
--Answer: 20,000

--What is our churned rate?--
SELECT SUM(customer_churned)/COUNT(customer_churned)*100
FROM ccomm_data;
--Answer: 40%

--Is there any difference in dropped dropped_calls
--between customers who churn and those who stay 
--with us?

SELECT AVG (dropped_calls)
FROM ccomm_data
WHERE customer_churned = '1';

SELECT AVG (dropped_calls)
FROM ccomm_data
WHERE customer_churned = '0';

--Answer: Yes. Customers who churned has an average dropped calls
--of 6.2 while those who choose to stay has an average dropped calls
--of 5.1.

