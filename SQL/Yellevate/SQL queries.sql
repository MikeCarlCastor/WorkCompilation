SELECT *
FROM cinvoice
order by customer_id;

SELECT  country, invoice_amount, invoice_date, settled_date,
days_to_settle, days_late
FROM cinvoice
order by days_late DESC;

--check spelling--
SELECT DISTINCT country
FROM cinvoice;

--check nulls--
SELECT *
FROM cinvoice
WHERE NOT (cinvoice IS NOT NULL);

--check duplicates--
SELECT invoice_number, country,
invoice_date, due_date,
invoice_amount,
disputed, dispute_lost,
settled_date, days_to_settle,
days_late
FROM cinvoice
GROUP BY invoice_number, country,
invoice_date, due_date,
invoice_amount,
disputed, dispute_lost,
settled_date, days_to_settle,
days_late
HAVING COUNT(*)>1;

--1. What is the average 
--processing time to settle invoices?
--Round to whole number
SELECT ROUND(AVG(days_to_settle),0)
AS time_in_days
FROM cinvoice;
--Answer: 26 days
--TABLE--
SELECT COUNT(invoice_date)
AS count_of_invoices, ROUND(AVG(days_to_settle),0)
AS processing_time_in_days
FROM cinvoice;

--2. What’s the processing
--time for the company to settle disputes?
--Round to whole number
SELECT ROUND(AVG(days_to_settle),0)
AS time_in_days
FROM cinvoice
WHERE disputed = 1;
--Answer: 36 days
--TABLE--
SELECT COUNT(invoice_date)
AS count_of_invoices, ROUND(AVG(days_to_settle),0)
AS processing_time_in_days
FROM cinvoice
WHERE disputed = 1;

--3. What is the percentage of disputes
--received by the company that were lost?
--Round to two decimal places
--METHOD 1--
SELECT ROUND(avg(dispute_lost)*100,2) 
AS dispute_lost_percentage
FROM cinvoice
WHERE disputed= 1;
--Answer: 17.69%
--TABLE--
SELECT COUNT (dispute_lost)
FROM cinvoice
WHERE disputed= 1
AND dispute_lost = 1;

SELECT COUNT (disputed) AS total_disputes,
(SELECT COUNT (dispute_lost)
FROM cinvoice
WHERE disputed= 1
AND dispute_lost = 1) AS disputes_lost,
 ROUND(avg(dispute_lost)*100,2) 
AS dispute_lost_percentage
FROM cinvoice
WHERE disputed= 1;

--4. What is the percentage revenue lost due
--to disputes?
--Round to two decimal places
--STEP 1--
SELECT ROUND(SUM(invoice_amount),2)
AS revenue_lost_revenue
FROM cinvoice
WHERE dispute_lost = 1 AND disputed = 1;
--total lost revenue: 690,167.00 USD

--STEP 2--
SELECT ROUND(SUM(invoice_amount),2)
AS total_revenue_in_usd
FROM cinvoice;
--total revenue: 14,770,318.00 USD

--STEP 3--
SELECT ROUND(690167.00/SUM(invoice_amount)*100,2)
AS revenue_lost_percentage
FROM cinvoice;
--Answer: 4.67%
--TABLE--
SELECT 
(SELECT ROUND(SUM(invoice_amount),2)
AS total_revenue_in_usd
FROM cinvoice) AS total_revenue,
ROUND(SUM(invoice_amount),2)
AS revenue_lost_revenue,
(SELECT ROUND(690167.00/SUM(invoice_amount)*100,2)
AS revenue_lost_percentage
FROM cinvoice) AS lost_percentage
FROM cinvoice
WHERE dispute_lost = 1 AND disputed = 1;

--5. What's the country where the company
--reached the highest losses from lost disputes(USD)
SELECT DISTINCT country,
SUM(invoice_amount) AS total_lost_disputes_usd
FROM cinvoice
WHERE dispute_lost>0
GROUP BY country
ORDER BY total_lost_disputes_usd DESC;
--Answer: France
--Revenue lost: 526,264 USD
--TABLE--
SELECT country AS country_name, MAX(total_dispute) 
AS total_lost_revenue
FROM (SELECT DISTINCT country AS country,
SUM(invoice_amount) AS total_dispute
FROM cinvoice
WHERE dispute_lost>0
GROUP BY country
ORDER BY total_dispute DESC) AS reference
WHERE country = 'France'
GROUP BY country;

--INSIGHT--
--76% of the total revenue lost
--due to disputes is from the country France.
--Since the company believes that the
--quality of the services is not the main reason
--for the disputes, the company should work on their contract 
--technicalities and make not only strict liability for breach
--but also understandable and unambiguous.
--This way, the company can demand payment firmly so clients won't get away
--from not paying the services, especially for clients in France. 
--Furthermore, giving better discounts for those who pay early
--will encourage clients to make early payments.