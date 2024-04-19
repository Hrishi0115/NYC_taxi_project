-- set up
use warehouse cecily_xs;
use database silver_layer;

-- look at the data
SELECT * FROM silver_layer.test.fhv LIMIT 10;

-- how many rows in total
-- pre clean --> 260,874,753
SELECT count(*) FROM bronze_layer.flattened.fhv_flat;
-- post clean --> 260,874,753
SELECT count(*) FROM test.fhv;

-- dipatching_base_num, 812 rows --> CLEAN
SELECT dispatching_base_num, count(*)
FROM test.fhv
GROUP BY dispatching_base_num
;

-- dolocationid, no nulls --> CLEAN
SELECT dolocationid, count(*)
FROM test.fhv
GROUP BY dolocationid
ORDER BY dolocationid
;

-- pulocationid, no nulls --> CLEAN
SELECT pulocationid, count(*)
FROM test.fhv
GROUP BY pulocationid
ORDER BY pulocationid
;

-- sr_flag, no nulls --> CLEAN
SELECT sr_flag, count(*)
FROM test.fhv
GROUP BY sr_flag
ORDER BY sr_flag
;

-- dropoff_datetime
-- check all years are 2018 - 2019
SELECT year(dropoff_datetime), count(*)
FROM test.fhv
GROUP BY year(dropoff_datetime);
-- 23 nulls, 7,500 2019, the rest are 2018

-- pickup_datetime
-- check all years are 2018 - 2019
SELECT year(pickup_datetime), count(*)
FROM test.fhv
GROUP BY year(pickup_datetime);
-- 2018 only

-- if there are nulls and we try to find the trip length: returns null
SELECT timediff(minute, pickup_datetime, dropoff_datetime)
FROM silver_layer.test.fhv 
WHERE dropoff_datetime IS NULL
LIMIT 10;
