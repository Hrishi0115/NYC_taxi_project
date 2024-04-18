


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
    id,
    'taxi_colour_id'
FROM nyc_taxi.gold.fact_taxi_trip
WHERE dolocationid NOT IN (1,2)
   AND dolocationid IS NOT NULL;



-- error table overview after all tests:
SELECT COUNT(*) FROM error_checking.gold.yellow_errors;


-- -- view error rows:
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