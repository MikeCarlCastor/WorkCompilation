--First, I cleaned the values in DATES column and removed the delimiters--
SELECT
	regexp_matches(dates, '\d{4}-\d{2}-\d{2}', 'g') AS extracted_dates
FROM schedule_copy;

--Then, I created a new table with clean dates.
--I made a subquery by copying all the columns from the first table except the DATES.
--I used the query for cleaning the DATES to replace the DATES column.

CREATE TABLE schedule_date_clean
AS
SELECT * 
FROM (SELECT 
	user_id,
	regexp_matches(dates, '\d{4}-\d{2}-\d{2}', 'g') AS extracted_dates,
	type,
	time_start,
	time_end,	
	timezone,	
	time_planned,	
	break_time,	
	leave_type	
FROM schedule_copy) as subq;

--Finally, a new table "schedule_date_clean" has been added.
--This table has a cleaner DATES values the only problem here was the curly braces.
--Now it's time to clean the USER_ID column. I just needed to repeat the process.

--First, I cleaned the user_id values--
SELECT user_id, regexp_matches(user_id, '\d+', 'g') AS extracted_id
FROM schedule_copy

--Then, I created a new table with clean USER_ID.
--I made a subquery by copying all the columns from the first table except the USER_ID.
--I used the query for cleaning the USER_ID to replace the USER_ID column.

CREATE TABLE schedule_id_clean
AS
SELECT * 
FROM (SELECT 
	regexp_matches(user_id, '\d+', 'g') AS extracted_id,
	extracted_dates,
	type,
	time_start,
	time_end,	
	timezone,	
	time_planned,	
	break_time,	
	leave_type	
FROM schedule_date_clean) as subq;

--Now, a new table "schedule_id_clean" has been added.
--This table has a cleaner values the only problem here was also the curly braces.

--I want to make sure that don't get NULL values--
SELECT count(extracted_dates)
FROM schedule_copy
WHERE extracted_id IS NULL;

SELECT count(extracted_id)
FROM schedule_copy
WHERE extracted_id IS NULL;

--For the last part, I removed the curly braces with UNNEST function--
SELECT 
	Unnest(extracted_id) AS user_id,
	Unnest(extracted_dates) AS dates,
	type,
	time_start,
	time_end,timezone,
	time_planned,
	break_time,
	leave_type
FROM schedule_id_clean;

--At this point, the data was already cleaned, all I had to do is to save the csv file--