
use role accountadmin;
use warehouse cecily_wh;
USE DATABASE bronze_layer;

-- FHV

-- investigate

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
-- a) change all non-1 values to null
-- b) change all in range 2 - 6 to 1 (shared rides), these are most of the rogue data points
--    then change the rest (7 - 53 to null, non-shared rides)

-- dropoff_datetime and pickip_datetime
-- to_date() gives date format, ignores time
SELECT to_date(dropoff_datetime)
FROM flattened.fhv_flat
LIMIT 5
;
-- to_time() gives time format
SELECT to_time(dropoff_datetime)
FROM flattened.fhv_flat
LIMIT 5
;

SELECT to_timestamp(dropoff_datetime)
FROM flattened.fhv_flat
LIMIT 5
;

-- splitting timestamp() to date and time
WITH cte AS
(SELECT to_timestamp(dropoff_datetime) AS dropoff_datetime
FROM flattened.fhv_flat
LIMIT 5)
SELECT to_date(dropoff_datetime), to_time(dropoff_datetime)
FROM cte;


-- things to note re cleaning FHV data
-- not all dispatching_base_num are in caps, upper() to get all in same format
-- pulocationid, there is -1 (4 trips) and 0 (191774) values, do we assume -1 means 1, do we get rid/null?
-- there are loads of nulls in dolocation id and some nulls in pulocationid
-- sr_flag should be 0 for solo ride and 1 for shared ride, but there are thousands of entries for other values

-- looking at pick up / drop off date/time

-- should span pre 2018, check no errors
