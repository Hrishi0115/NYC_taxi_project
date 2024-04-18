USE WAREHOUSE NET_WH;

--See documentation for silver tables.
--This script validates that  correct transformations have been applied.


--create error table for silver layer green taxis.
DROP TABLE IF EXISTS error_checking.silver.green_errors;
CREATE OR REPLACE TABLE error_checking.silver.green_errors
(
    row_id INT,
    message STRING
);

-- 1. dolocationid column
-- Should be between 1-265, no nulls
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM nyc_taxi.silver.green
WHERE dolocationid NOT BETWEEN 1 AND 265
   OR dolocationid IS NULL;



-- 2. pulocationid column
-- Should be between 1-265, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid pulocationid'
FROM nyc_taxi.silver.green
WHERE pulocationid NOT BETWEEN 1 AND 265
   OR pulocationid IS NULL;



-- 3. ratecodeid column
-- Should be between 1-7, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid ratecodeid'
FROM nyc_taxi.silver.green
WHERE ratecodeid NOT IN (1, 2, 3, 4, 5, 6, 7)
   OR ratecodeid IS NULL;



-- 4. vendorid column
-- Should be between 1-3, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid vendorid'
FROM nyc_taxi.silver.green
WHERE vendorid NOT IN (1, 2, 3)
   OR vendorid IS NULL;



-- 5. extra column
-- Should be in (0, 0.5, 1.0, 2.75, 4.5) or nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid extra'
FROM nyc_taxi.silver.green
WHERE extra NOT IN (0, 0.5, 1, 2.75, 4.5)
   AND extra IS NOT NULL;



-- 6. fare_amount column
-- Should be between 0-500, or nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid fare_amount'
FROM nyc_taxi.silver.green
WHERE fare_amount NOT BETWEEN 0 AND 500
   AND fare_amount IS NOT NULL;



-- 7. improvement_surcharge column
-- Should be in (0, 0.3) or nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid improvement_surcharge'
FROM nyc_taxi.silver.green
WHERE improvement_surcharge NOT IN (0, 0.3)
   AND improvement_surcharge IS NOT NULL;



-- 8. mta_tax column
-- Should be in (0, 0.5) or nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid mta_tax'
FROM nyc_taxi.silver.green
WHERE mta_tax NOT IN (0, 0.5)
   AND mta_tax IS NOT NULL;




-- 9. passenger_count column
-- Should be between 1-3, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid passenger_count'
FROM nyc_taxi.silver.green
WHERE passenger_count NOT IN (0, 1, 2, 3, 4, 5, 6)
   AND passenger_count IS NOT NULL;



-- 10. payment_type column
-- Should be between 1-6, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid payment_type'
FROM nyc_taxi.silver.green
WHERE payment_type NOT IN (1, 2, 3, 4, 5, 6)
   OR payment_type IS NULL;



-- 11. store_and_fwd_flag column
-- should be in (Y,N,U), no nulls
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid store_and_fwd_flag'
FROM nyc_taxi.silver.green
WHERE store_and_fwd_flag NOT IN ('Y', 'N', 'U')
   OR store_and_fwd_flag IS NULL;
 
 
-- 12. tip_amount column
-- should not be a negative number, nulls allowed
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid tip_amount'
FROM nyc_taxi.silver.green
WHERE tip_amount < 0
    AND tip_amount IS NOT NULL;
 
 
-- 13. tolls_amount column
-- should not be a negative number,  nulls allowed
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid tolls_amount'
FROM nyc_taxi.silver.green
WHERE tolls_amount NOT BETWEEN 0 AND 120
    AND tolls_amount IS NOT NULL;

-- 14. lpep_dropoff_date column
-- should be between 2018-2024, nulls allowed
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid lpep_dropoff_date'
FROM nyc_taxi.silver.green
WHERE YEAR(lpep_dropoff_date) NOT BETWEEN 2018 AND 2024
    AND lpep_dropoff_date IS NOT NULL;

-- 15. lpep_dropoff_time column
-- should not be a negative number, nulls allowed
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'lpep_dropoff_time'
FROM nyc_taxi.silver.green
WHERE (lpep_dropoff_time NOT BETWEEN TIME('00:00:00') AND TIME('23:59:59'))
    AND lpep_dropoff_time IS NOT NULL;

-- 16. lpep_pickup_date column
-- should be between 2018-2024, nulls allowed
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid lpep_pickup_date'
FROM nyc_taxi.silver.green
WHERE YEAR(lpep_pickup_date) NOT BETWEEN 2018 AND 2024
    AND lpep_pickup_date IS NOT NULL;

-- 17. lpep_pickup_time column
-- should not be a negative number, nulls allowed
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid lpep_pickup_time'
FROM nyc_taxi.silver.green
WHERE (lpep_pickup_time NOT BETWEEN TIME('00:00:00') AND TIME('23:59:59'))
    AND lpep_pickup_time IS NOT NULL;

-- 18. trip_distance column
-- Should be between 0-200, or nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid trip_distance'
FROM nyc_taxi.silver.green
WHERE trip_distance NOT BETWEEN 0 AND 200
   AND trip_distance IS NOT NULL;

-- 19. total_amount column
-- should not be a negative number, nulls allowed
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid total_amount'
FROM nyc_taxi.silver.green
WHERE total_amount < 0
    AND total_amount IS NOT NULL;

-- 20. trip_type column
-- Should be in ('Street-hail', 'Dispatch', 'Unknown'), no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid trip_type'
FROM nyc_taxi.silver.green
WHERE trip_type NOT IN ('Street-hail', 'Dispatch', 'Unknown')
   OR trip_type IS NULL;


--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;


-- -- view error rows:
-- SELECT
--     silver.*
-- FROM nyc_taxi.silver.green AS silver
-- INNER JOIN error_checking.silver.green_errors AS errors
--     ON silver.id = errors.row_id; 