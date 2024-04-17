
---- see documentation for silver tables
---- this script validates correct transformations have been applied



------ create error table for silver layer yellow taxis ------
DROP TABLE IF EXISTS error_checking.silver.yellow_errors;
CREATE OR REPLACE TABLE error_checking.silver.yellow_errors
(
    row_id INT,
    message STRING -- message will change depending on test
);




------ populate error table with values that dont conform to silver cleaning/transformations outlined in data dictionary ------

-- 1. dolocationid column
-- should be between 1-265, no nulls
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.yellow
WHERE dolocationid NOT BETWEEN 1 AND 265
   OR dolocationid IS NULL;


-- 2. pulocationid column
-- should be between 1-265, no nulls
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid pulocationid'
FROM silver_layer.test.yellow
WHERE pulocationid NOT BETWEEN 1 AND 265
   OR pulocationid IS NULL;


-- 3. ratecodeid column
-- should be between 1-7, no nulls
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE ratecodeid NOT IN (1,2,3,4,5,6,7)
   OR ratecodeid IS NULL;


-- 4. vendorid column
-- should be between 1-3, no nulls
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE vendorid NOT IN (1,2,3)
   OR vendorid IS NULL;


-- 5. extra column
-- should be in (0, 0.5, 1, 2.75, 4.5) or null
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE extra NOT IN (0, 0.5, 1, 2.75, 4.5)
   AND extra IS NOT NULL;


-- 6. fare_amount column
-- should be between 0 and 500 or null
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE fare_amount NOT BETWEEN 0 AND 500
   AND fare_amount IS NOT NULL;


-- 7. improvement_surcharge column
-- should be in (0, 0.3) or null
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE improvement_surcharge NOT IN (0, 0.3)
   AND improvement_surcharge IS NOT NULL;


-- 8. mta_tax column
-- should be in (0, 0.5) or null
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE mta_tax NOT IN (0, 0.5)
   AND mta_tax IS NOT NULL;


-- 9. passenger_count column
-- should be between 0 and 6, or null
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE passenger_count NOT IN (0,1,2,3,4,5,6)
   AND passenger_count IS NOT NULL;


-- 10. payment_type column
-- should be between 1 and 6, no nulls
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE payment_type NOT IN (1,2,3,4,5,6)
   OR payment_type IS NULL;


-- 11. store_and_fwd_flag column
-- should be in (Y,N,U), no nulls
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE store_and_fwd_flag NOT IN ('Y', 'N', 'U')
   OR store_and_fwd_flag IS NULL;


-- 12. tip_amount column
-- should not be a negative number, nulls allowed
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE tip_amount < 0
    AND tip_amount IS NOT NULL;


-- 13. tolls_amount column
-- should not be a negative number,  nulls allowed
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE tolls_amount NOT BETWEEN 0 AND 120
    AND tolls_amount IS NOT NULL;



---- final check: error table should be empty ----
SELECT COUNT(*) FROM error_checking.silver.yellow_errors;


