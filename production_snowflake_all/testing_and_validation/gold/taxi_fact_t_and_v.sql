


-- gold layer error table to log faulty values in taxi fact table
DROP TABLE IF EXISTS error_checking.gold.yellow_errors;
CREATE OR REPLACE TABLE error_checking.gold.yellow_errors
(
    row_id INT, -- id of fact table row with bad data
    message STRING -- message will change depending on test
);


-- 1. taxi_colour_id
-- should be 1, 2 or null
INSERT INTO error_checking.gold.yellow_errors
SELECT
    taxi_trip_id,
    'taxi_colour_id'
FROM nyc_taxi.gold.fact_taxi_trip
WHERE taxi_colour_id NOT IN (1,2)
   AND taxi_colour_id IS NOT NULL;


-- 2. vendorid column
-- should be between 1-3, no nulls
INSERT INTO error_checking.gold.yellow_errors
SELECT
    taxi_trip_id,
    'invalid vendor_id'
FROM nyc_taxi.gold.fact_taxi_trip
WHERE vendor_id NOT IN (1,2,3)
   OR vendor_id IS NULL;


-- 3. passenger_count column
-- should be between 0 and 6, or null
INSERT INTO error_checking.gold.yellow_errors
SELECT
    taxi_trip_id,
    'invalid passenger_count'
FROM nyc_taxi.gold.fact_taxi_trip
WHERE passenger_count NOT IN (0,1,2,3,4,5,6)
   AND passenger_count IS NOT NULL;


-- 4. trip_distance column
-- Should be between 0-200, or nulls
INSERT INTO error_checking.gold.yellow_errors
SELECT
    taxi_trip_id,
    'invalid trip_distance'
FROM nyc_taxi.gold.fact_taxi_trip
WHERE trip_distance NOT BETWEEN 0 AND 200
   AND trip_distance IS NOT NULL;


-- 5. pu_zone_id column
-- should be between 1-265, no nulls
INSERT INTO error_checking.gold.yellow_errors
SELECT
    taxi_trip_id,
    'invalid pu_zone_id'
FROM nyc_taxi.gold.fact_taxi_trip
WHERE pu_zone_id NOT BETWEEN 1 AND 265
   OR pu_zone_id IS NULL;


-- 6. do_zone_id column
-- should be between 1-265, no nulls
INSERT INTO error_checking.gold.yellow_errors
SELECT
    taxi_trip_id,
    'invalid do_zone_id column'
FROM nyc_taxi.gold.fact_taxi_trip
WHERE pu_zone_id NOT BETWEEN 1 AND 265
   OR pu_zone_id IS NULL;





------ checking results of tests
-- error table overview after all tests:
SELECT COUNT(*) FROM error_checking.gold.yellow_errors;


-- -- see which columns have rows with errors:
-- SELECT message, COUNT(*) 
-- FROM error_checking.gold.yellow_errors
-- GROUP BY message
-- ORDER BY COUNT(*) DESC;


-- -- view the actual rows with errors in original table:
-- SELECT
--     gold.*
-- FROM nyc_taxi.gold.fact_taxi_trip AS gold
-- INNER JOIN error_checking.gold.yellow_errors AS errors
--     ON gold.taxi_trip_id = errors.row_id; 






















-- -- standalone test: check all rows have been added (taxi_fact rows should be = yellow_silver rows + bronze_silver rows)
-- SELECT
--     COUNT(*) AS rows_in_fact_table,
--     (SELECT COUNT(*) FROM nyc_taxi.silver.yellow) AS rows_in_silver_yellow,
--     (SELECT COUNT(*) FROM nyc_taxi.silver.green) AS rows_in_silver_green,
--     (SELECT COUNT(*) FROM nyc_taxi.silver.yellow) + (SELECT COUNT(*) FROM nyc_taxi.silver.green) AS silver_plus_green,
--     COUNT(*) - ((SELECT COUNT(*) FROM nyc_taxi.silver.yellow) + (SELECT COUNT(*) FROM nyc_taxi.silver.green)) AS lost_rows_between_silver_and_gold,
-- FROM nyc_taxi.gold.fact_taxi_trip;