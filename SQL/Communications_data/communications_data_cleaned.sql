SELECT *
FROM communications_data
Limit 100;

--check spellings--
SELECT DISTINCT customer_country
FROM communications_data;

SELECT DISTINCT gender
FROM communications_data;

SELECT DISTINCT client_name
FROM communications_data;

SELECT DISTINCT product_type
FROM communications_data;

SELECT DISTINCT channel
FROM communications_data;

--check nulls--
SELECT *
FROM communications_data
WHERE NOT (communications_data IS NOT NULL);

--NULLS found in gender, age, and customer_country columns--

--update NULLS in gender column--
SELECT DISTINCT gender,
       COALESCE(gender, 'unspecified') AS updated_gender
FROM communications_data
LIMIT 100;

UPDATE communications_data
SET gender = 'unspecified'
WHERE gender IS NULL;


--check if there's still NULLS in gender column--
SELECT gender
FROM communications_data
WHERE gender IS NULL;

--No more NULLS in gender column--

--update age NULLS using median or mean--
--Before deciding which to choose, let's see if there are outliers in the data--
--First, Let's get the z-scores--
SELECT 
	DISTINCT age,
	(age - AVG(age) over ()) / stddev(age) over () as zscore
FROM communications_data
WHERE age IS NOT NULL
ORDER BY age
LIMIT 100;

--Now, the outliers. If outliers are valid we'll use mean, otherwise we use median--
SELECT * 
FROM
(SELECT 
	DISTINCT age,
	(age - AVG(age) over ()) / stddev(age) over () as zscore
FROM communications_data
WHERE age IS NOT NULL
ORDER BY age ASC) AS outliers 
WHERE zscore > 2.576
OR zscore <-2.576;

--Since outliers are valid, let's use mean. Let's get the mean of the age values first--
SELECT CAST(avg(age) as int) as mean_value_age
FROM communications_data;

--Now, let's use 43 as an imputated value to missing values in age column--
UPDATE communications_data
SET age = 43
WHERE age IS NULL;

--check if there's still NULLS in age column--
SELECT age
FROM communications_data
WHERE age IS NULL;

--No more NULLS in age column, imputation was successful--

--Lastly, update the NULLS in customer_country column with 'Unknown'--
SELECT DISTINCT customer_country,
       COALESCE(customer_country, 'unknown') AS updated_gender
FROM communications_data;

UPDATE communications_data
SET customer_country = 'unknown'
WHERE customer_country IS NULL;

--check if there's still NULLS in customer_country column--
SELECT customer_country
FROM communications_data
WHERE customer_country IS NULL;

--check duplicates--
SELECT 
    message_id,
    customer_id,
    gender,
    customer_country,
    age,
    COUNT(*) AS duplicate_count
FROM communications_data
GROUP BY 1,2,3,4,5
HAVING COUNT(*) > 1
LIMIT 10;

--No duplicates found-

--Let's check if there are still NULLS in the dataset--
SELECT
  COUNT(*) AS total_records,
  COUNT(*) FILTER (WHERE message_id IS NULL) AS message_id_nulls,
  COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
  COUNT(*) FILTER (WHERE sent_at IS NULL) AS sent_at_nulls,
  COUNT(*) FILTER (WHERE clicked IS NULL) AS clicked_count,
  COUNT(*) FILTER (WHERE converted IS NULL) AS converted_count,
  COUNT(*) FILTER (WHERE client_id IS NULL) AS client_id_nulls,
  COUNT(*) FILTER (WHERE gender IS NULL) AS column1_null_count,
  COUNT(*) FILTER (WHERE customer_country IS NULL) AS customer_country_nulls,
  COUNT(*) FILTER (WHERE age IS NULL) AS age_count,
  COUNT(*) FILTER (WHERE created_at IS NULL) AS created_at_count,
  COUNT(*) FILTER (WHERE client_name IS NULL) AS client_name_count,
  COUNT(*) FILTER (WHERE product_type IS NULL) AS product_type_nulls,
  COUNT(*) FILTER (WHERE client_country IS NULL) AS client_country_count,
  COUNT(*) FILTER (WHERE channel IS NULL) AS channel_nulls,
  COUNT(*) FILTER (WHERE message_number IS NULL) AS message_number_count
FROM communications_data;

--No nore NULLS--
--Now let's load the data to power BI--

