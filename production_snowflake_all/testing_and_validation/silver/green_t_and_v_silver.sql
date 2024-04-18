USE WAREHOUSE NETT_WH;

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
FROM silver_layer.test.green
WHERE dolocationid NOT BETWEEN 1 AND 265
   OR dolocationid IS NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;

-- 2. pulocationid column
-- Should be between 1-265, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.green
WHERE pulocationid NOT BETWEEN 1 AND 265
   OR pulocationid IS NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;

-- 3. ratecodeid column
-- Should be between 1-7, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.green
WHERE ratecodeid NOT IN (1, 2, 3, 4, 5, 6, 7)
   OR ratecodeid IS NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;

-- 4. vendorid column
-- Should be between 1-3, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.green
WHERE vendorid NOT IN (1, 2, 3)
   OR vendorid IS NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;

-- 5. extra column
-- Should be in (0, 0.5, 1.0, 2.75, 4.5) or nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.green
WHERE extra NOT IN (0, 0.5, 1, 2.75, 4.5)
   AND extra IS NOT NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;

-- 6. fare_amount column
-- Should be between 0-500, or nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.green
WHERE fare_amount NOT BETWEEN 0 AND 500
   AND fare_amount IS NOT NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;

-- 7. improvement_surcharge column
-- Should be in (0, 0.3) or nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.green
WHERE improvement_surcharge NOT IN (0, 0.3)
   AND improvement_surcharge IS NOT NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;

-- 8. mta_tax column
-- Should be in (0, 0.5) or nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.green
WHERE mta_tax NOT IN (0, 0.5)
   AND mta_tax IS NOT NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;


-- 9. passenger_count column
-- Should be between 1-3, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.green
WHERE passenger_count NOT IN (0, 1, 2, 3, 4, 5, 6)
   AND passenger_count IS NOT NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;

-- 10. payment_type column
-- Should be between 1-6, no nulls

INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.green
WHERE payment_type NOT IN (1, 2, 3, 4, 5, 6)
   OR payment_type IS NULL;

--Error table should be empty.
SELECT COUNT(*) FROM error_checking.silver.green_errors;

-- 11. store_and_fwd_flag column
-- should be in (Y,N,U), no nulls
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'store_and_fwd_flag'
FROM silver_layer.test.green
WHERE store_and_fwd_flag NOT IN ('Y', 'N', 'U')
   OR store_and_fwd_flag IS NULL;
 
 
-- 12. tip_amount column
-- should not be a negative number, nulls allowed
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid tip_amount'
FROM silver_layer.test.green
WHERE tip_amount < 0
    AND tip_amount IS NOT NULL;
 
 
-- 13. tolls_amount column
-- should not be a negative number,  nulls allowed
INSERT INTO error_checking.silver.green_errors
SELECT
    id,
    'invalid tolls_amount'
FROM silver_layer.test.green
WHERE tolls_amount NOT BETWEEN 0 AND 120
    AND tolls_amount IS NOT NULL;

--14. 