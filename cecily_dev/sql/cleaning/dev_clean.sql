
use role accountadmin;
use warehouse cecily_wh;
USE DATABASE bronze_layer;

-- FHV

-- investigate

-- how many rows in total --> 260,874,753
SELECT count(*) FROM bronze_layer.flattened.fhv_flat;

SELECT * FROM bronze_layer.flattened.fhv_flat LIMIT 5;

-- dipatching_base_num
-- group by dipatching_base_num --> 820 results
SELECT dispatching_base_num, count(*)
FROM flattened.fhv_flat
GROUP BY dispatching_base_num
;

-- group by upper(dispatching_base_num) --> 812 results
SELECT upper(dispatching_base_num), count(*)
FROM flattened.fhv_flat
GROUP BY upper(dispatching_base_num)
HAVING upper(dispatching_base_num) = 'B02395'
;
-- ACTION: cast to upper(dispatching_base_num)

-- FYI some of these base numbers are HV-FHV base numbers in dimension, some are not
-- how many dif base numbers
SELECT count(distinct dispatching_base_num)
FROM flattened.fhv_flat;

-- dolocationid 
-- (values should be 1 - 265, with 264 representing nulls)
-- group by dolocationid
SELECT dolocationid, count(*)
FROM flattened.fhv_flat
GROUP BY dolocationid
ORDER BY dolocationid
;
-- 7,000 rows with value 0
-- 20 mil rows with value null
-- ACTION: change null and 0 entries to 264

-- pulocationid 
-- (values should be 1 - 265, with 264 representing nulls)
-- group by pulocationid
SELECT pulocationid, count(*)
FROM flattened.fhv_flat
GROUP BY pulocationid
ORDER BY pulocationid
;
-- 9,000 rows with value 0
-- 37 mil rows with value null
-- ACTION: change null and 0 entries to 264

-- sr_flag 
-- (values should be null for non-shared rides and 1 for shared rides)

-- group by sr_flag
SELECT sr_flag, count(*)
FROM flattened.fhv_flat
GROUP BY sr_flag
ORDER BY sr_flag
;
-- 200 mil rows with value null (non-shared rides)
-- 28 mil rows with value 1 (shared rides)
-- 30 mil rows with values in range 2 - 53
-- ACTION: 
-- add value 2 for unknown, change null to 0 


-- dropoff_datetime and pickup_datetime
-- to_date() gives date format, ignores time
SELECT to_date(dropoff_datetime)
FROM bronze_layer.flattened.fhv_flat
LIMIT 5
;

-- check years
SELECT year(to_timestamp(dropoff_datetime)), count(*)
FROM bronze_layer.flattened.fhv_flat
GROUP BY year(to_timestamp(dropoff_datetime))
;

-- should be in year 2018, but there are entries from 1971 - 
WITH ctedate AS (
    SELECT to_date(dropoff_datetime) AS dropoff_date, count(*)
    FROM flattened.fhv_flat
    GROUP BY to_date(dropoff_datetime)
)
SELECT YEAR(dropoff_date)
FROM ctedate
GROUP BY YEAR(dropoff_date)
ORDER BY YEAR(dropoff_date)
;

-- how many non 2018 rows?
WITH ctedate AS (
    SELECT to_date(dropoff_datetime) AS dropoff_date, pickup_datetime
    FROM flattened.fhv_flat
)
SELECT YEAR(dropoff_date), count(*)
FROM ctedate
ORDER BY YEAR(dropoff_date)
;


-- figure out how to change year component to 2018

SELECT 2018 AS target_year;

WITH ctedate AS (
    SELECT to_date(dropoff_datetime) AS dropoff_date, count(*)
    FROM flattened.fhv_flat
    GROUP BY to_date(dropoff_datetime)
)

SELECT DATEADD(year, target_year - YEAR(dropoff_date), dropoff_date) AS updated_date
FROM ctedate;




-- to_time() gives time format
SELECT to_time(dropoff_datetime)
FROM flattened.fhv_flat
LIMIT 5
;

SELECT to_timestamp(dropoff_datetime)
FROM flattened.fhv_flat
LIMIT 5
;

-- check non 2018 years
SELECT
--lpep_pickup_datetime,
YEAR(to_timestamp(LPEP_PICKUP_DATETIME)),
COUNT(*)
FROM flattened.fhv_flat
--WHERE YEAR(to_timestamp(LPEP_PICKUP_DATETIME)) != 2018
GROUP BY YEAR(to_timestamp(LPEP_PICKUP_DATETIME))
ORDER BY COUNT (*) DESC;

-- splitting timestamp() to date and time
WITH cte AS
(SELECT to_timestamp(dropoff_datetime) AS dropoff_datetime
FROM flattened.fhv_flat
LIMIT 5)
SELECT to_date(dropoff_datetime), to_time(dropoff_datetime)
FROM cte;

-- look at date diff
SELECT datediff(year,dropoff_date,pickup_date) AS trip_length_days
FROM silver_layer.test.fhv
WHERE dropoff_date IS NOT NULL AND pickup_date IS NOT NULL
ORDER BY trip_length_days DESC
LIMIT 20
;

-- entry where drop off date in 2021
SELECT datediff(day,pickup_date, dropoff_date)
FROM silver_layer.test.fhv
WHERE id = 85091821
;
-- WHERE id = 85091821
SELECT datediff(day,pickup_date, dropoff_date) AS length_days, count(*)
FROM silver_layer.test.fhv
GROUP BY datediff(day,pickup_date, dropoff_date)
ORDER BY length_days DESC
LIMIT 10;


-- insert new column that gives length_days



-- look at years
SELECT year(dropoff_date) AS yr, count(*)
FROM silver_layer.test.fhv
GROUP BY year(dropoff_date)
ORDER BY yr DESC
;

SELECT year(pickup_date) AS yr, count(*)
FROM silver_layer.test.fhv
GROUP BY year(pickup_date)
ORDER BY yr DESC
;




-- things to note re cleaning FHV data
-- not all dispatching_base_num are in caps, upper() to get all in same format
-- pulocationid, there is -1 (4 trips) and 0 (191774) values, do we assume -1 means 1, do we get rid/null?
-- there are loads of nulls in dolocation id and some nulls in pulocationid
-- sr_flag should be 0 for solo ride and 1 for shared ride, but there are thousands of entries for other values

-- looking at pick up / drop off date/time

-- should span pre 2018, check no errors
