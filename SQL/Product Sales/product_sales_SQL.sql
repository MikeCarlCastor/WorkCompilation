--update date--
UPDATE cprodsales
SET sched = TO_DATE(sched,'mmyyyy');

--change date type--
ALTER TABLE cprodsales
ALTER COLUMN sched TYPE DATE USING (sched::DATE);

SELECT *
FROM cprodsales;

--check spellings--
SELECT DISTINCT location, product
FROM cprodsales;

--correct spellings--
UPDATE cprodsales
SET location = 'Branch Beta'
Where location = 'Branch Betta' AND product = 'Siidan';

UPDATE cprodsales
SET product = 'Sedan'
Where location = 'Branch Beta' AND product = 'Siidan';

UPDATE cprodsales
SET product = 'Sedan'
Where location = 'Branch Beta' AND product = 'Siidan';

UPDATE cprodsales
SET location = 'Branch Charlie'
Where location = 'Branch Charlee'

UPDATE cprodsales
SET product = 'Big bikes'
Where location = 'Branch Delta'

UPDATE cprodsales
SET product = 'Motorcycle'
Where location = 'Branch Charlie'

--check nulls--
SELECT *
FROM cprodsales
WHERE NOT (cprodsales IS NOT NULL);

--update nulls--
UPDATE cprodsales
SET location = 'Branch Alpha'
Where location IS NULL AND product = 'SUV';

UPDATE cprodsales
SET location = 'Branch Beta'
Where location IS NULL AND product = 'Sedan';

UPDATE cprodsales
SET gross_profit = 300-162
WHERE ref = 268;

UPDATE cprodsales
SET gross_profit = 2017-178
WHERE ref = 236;


--add new column--
ALTER TABLE cprodsales
ADD COLUMN loc_prod varchar;

--update column with concat--
UPDATE cprodsales
SET loc_prod = LOWER(location) || '-' || UPPER(product);

--remove the word "branch" with substring--
UPDATE cprodsales
SET loc_prod = SUBSTRING (loc_prod FROM 8);


--check duplicates--
SELECT sched, loc_prod, revenue, cogs, gross_profit
FROM cprodsales
GROUP BY sched, loc_prod, revenue, cogs, gross_profit
HAVING COUNT(*)>1;

--show duplicates--
SELECT *
FROM cprodsales
WHERE loc_prod = 'beta-SEDAN' AND revenue = '2067' AND cogs = '240';

--delete duplicates--
DELETE from cprodsales
WHERE ref = '255';

--show duplicates--
SELECT *
FROM cprodsales
WHERE loc_prod = 'beta-SEDAN' AND revenue = '526' AND cogs = '191';

--delete duplicates--
DELETE from cprodsales
WHERE ref = '229';


--show the standard deviations--
SELECT ref, loc_prod, revenue, cogs, gross_profit,
(gross_profit - AVG(gross_profit) over ()) / stddev(gross_profit) over () as zscore
FROM cprodsales;


--show the outliers--
SELECT * FROM
(SELECT ref, loc_prod, revenue, cogs, gross_profit,
(gross_profit - AVG(gross_profit) over ()) / stddev(gross_profit) over () as zscore
FROM cprodsales) AS outliers
WHERE zscore > 2.576
OR zscore <-2.576;


--update the outliers--
UPDATE cprodsales
SET gross_profit = 360 - 196
WHERE ref = 283;

UPDATE cprodsales
SET gross_profit = 355 - 186
WHERE ref = 343;

UPDATE cprodsales
SET gross_profit = (revenue-cogs)*1000
WHERE ref IN (283, 268, 236, 343);

SELECT *
FROM cprodsales
WHERE ref IN (283, 268, 236, 343);