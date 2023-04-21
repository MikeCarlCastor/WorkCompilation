--change to date--
UPDATE service_data
SET sched = TO_DATE(sched,'mmyyyy');

SELECT *
FROM service_data;

--check spellings--
SELECT DISTINCT branch, service
FROM service_data;

--correct spellings--
UPDATE service_data
SET branch = 'Beta'
WHERE branch = 'Eta' AND service = 'Restaurant';

UPDATE service_data
SET service = 'Restaurant'
WHERE branch = 'Eta' AND service = 'Restorant';

UPDATE service_data
SET service = 'Convenience Store'
WHERE service = 'Conviinience Store';

--check nulls--
SELECT *
FROM service_data
WHERE NOT (service_data IS NOT NULL);

--update nulls--
UPDATE service_data
SET gross_profit = 164-161
WHERE record = 288;

UPDATE service_data
SET gross_profit = 200-192
WHERE record = 342;

UPDATE service_data
SET gross_profit = 203-199
WHERE record = 405;

--add new column--
ALTER TABLE service_data
ADD COLUMN bran_serv varchar;

--add values to new column using concat--
UPDATE service_data
SET bran_serv = LOWER(branch) || '-' || UPPER(service);

--checking duplicates--
SELECT sched, bran_serv, revenue, cos, gross_profit
FROM service_data
GROUP BY sched, bran_serv, revenue, cos, gross_profit
HAVING COUNT(*)>1;

--show duplicates--
SELECT *
FROM service_data
WHERE revenue = 441 
AND cos = 122
AND gross_profit = 319;

--delete one entry--
DELETE FROM service_data
WHERE record = 338;

--get standard deviation of values--
SELECT record, branch, service, revenue, cos, gross_profit,
(gross_profit - AVG(gross_profit) over ()) / stddev(gross_profit) over () as zscore
FROM service_data;

--check for outliers--
SELECT * 
FROM
(SELECT record, bran_serv, revenue, cos, gross_profit,
(gross_profit - AVG(gross_profit) over ()) / stddev(gross_profit) over () as zscore
FROM service_data) AS outliers
WHERE zscore > 2.576
OR zscore <-2.576;

--update outliers--
UPDATE service_data
SET gross_profit = 200-180
WHERE record = 364;

UPDATE service_data
SET gross_profit = 324-110
WHERE record = 412;