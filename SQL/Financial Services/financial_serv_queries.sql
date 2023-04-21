SELECT * 
FROM cfinancialserv;

UPDATE cfinancialserv
SET market = 'Financial Services'
WHERE market = 'FincialServices';

SELECT funding_total_usd, seed_fund, venture_capital, equity_crowdfunding,
undisclosed_sources, convertible_notes, debt_financing, private_equity 
FROM cfinancialserv
WHERE funding_total_usd = 'NULL';

UPDATE cfinancialserv
SET funding_total_usd = '0'
WHERE funding_total_usd = 'NULL';

ALTER TABLE cfinancialserv
ALTER COLUMN funding_total_usd TYPE numeric USING (funding_total_usd::numeric);

--Number of observations, average seed funding, and standard deviation
--both max and min
SELECT COUNT (market) AS companies_operating,
ROUND (AVG(seed_fund),0) AS avg_seed_funding,
MAX (zscore) AS max_zscore, MIN (zscore) AS min_zscore
FROM
(SELECT market, funding_total_usd, status, country_code, seed_fund, venture_capital, equity_crowdfunding, undisclosed_sources, convertible_notes, debt_financing, private_equity,
(seed_fund- AVG(seed_fund) over ()) / stddev(seed_fund) over () as zscore
FROM cfinancialserv
WHERE status = 'operating') AS outliers
WHERE status ='operating';

--Company that received equity crowdfunding--
SELECT country_code,founded_year,status,equity_crowdfunding
FROM cfinancialserv
WHERE equity_crowdfunding > 0;

--Determine the outlier in terms of funding_total_usd--
SELECT * 
FROM
(SELECT country_code, status, founded_year, funding_total_usd,
(funding_total_usd- AVG(funding_total_usd) over ()) / stddev(funding_total_usd) over () as zscore
FROM cfinancialserv) AS outliers
WHERE zscore > 2.576
OR zscore <-2.576;

--Usual sources of financing--
SELECT COUNT(market) AS seed_fund_count
FROM cfinancialserv
WHERE seed_fund > 0;

SELECT COUNT(market) AS venture_capital_count
FROM cfinancialserv
WHERE venture_capital> 0;

SELECT COUNT(market) AS equity_crowdfunding_count
FROM cfinancialserv
WHERE equity_crowdfunding> 0;

SELECT COUNT(market) AS undisclosed_sources_count
FROM cfinancialserv
WHERE undisclosed_sources> 0;

SELECT COUNT(market) AS convertible_notes_count
FROM cfinancialserv
WHERE convertible_notes> 0;

SELECT COUNT(market) AS debt_financing_count
FROM cfinancialserv
WHERE debt_financing> 0;

SELECT COUNT(market) AS private_equity_count
FROM cfinancialserv
WHERE private_equity> 0;

--average funds--
SELECT *
FROM cfinancialserv
WHERE funding_total_usd<725000000;