
---- see documentation for silver tables
---- this script validates correct transformations have been applied



------ create error table for silver layer fhv taxis ------
DROP TABLE IF EXISTS error_checking.silver.fhv_errors;
CREATE OR REPLACE TABLE error_checking.silver.fhv_errors
(
    row_id INT,
    message STRING -- message will change depending on test
);

------ populate error table with values that dont conform to silver cleaning/transformations outlined in data dictionary ------

-- 1. dolocationid column
-- should be between 1-265, no nulls
INSERT INTO error_checking.silver.fhv_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.fhv
WHERE dolocationid NOT BETWEEN 1 AND 265
   OR dolocationid IS NULL;


-- 2. pulocationid column
-- should be between 1-265, no nulls
INSERT INTO error_checking.silver.fhv_errors
SELECT
    id,
    'invalid pulocationid'
FROM silver_layer.test.fhv
WHERE pulocationid NOT BETWEEN 1 AND 265
   OR pulocationid IS NULL;


-- 3. sr_flag column
-- should be between 0 and 2, no nulls
INSERT INTO error_checking.silver.fhv_errors
SELECT
    id,
    'invalid sr_flag'
FROM silver_layer.test.fhv
WHERE sr_flag NOT IN (0,1,2);


-- 4. dispatching_base_number column
-- should be 6 character string, where first character is 'B'
INSERT INTO error_checking.silver.fhv_errors
SELECT
    id,
    'invalid dispatching_base_number'
FROM silver_layer.test.fhv
WHERE len(trim(dispatching_base_number)) != 6 
    OR LEFT(dispatching_base_number,1) != 'B';


-- 5. dropoff_date date column
-- should be year 2018 or later
INSERT INTO error_checking.silver.fhv_errors
SELECT
    id,
    'invalid dropoff_date'
FROM silver_layer.test.fhv
WHERE year(dropoff_date) NOT BETWEEN 2018 AND 2024;


-- 5. pickup_date date column
-- should be year 2018 or later
INSERT INTO error_checking.silver.fhv_errors
SELECT
    id,
    'invalid pickup_date'
FROM silver_layer.test.fhv
WHERE year(pickup_date) NOT BETWEEN 2018 AND 2024;

-- 6. dropoff_time time column
-- should be time format, no nulls
INSERT INTO error_checking.silver.fhv_errors
SELECT
    id,
    'invalid dropoff_time'
FROM silver_layer.test.fhv
WHERE dropoff_time IS NULL;

-- 7. pickup_time time column
-- should be time format, no nulls
INSERT INTO error_checking.silver.fhv_errors
SELECT
    id,
    'invalid pickup_time'
FROM silver_layer.test.fhv
WHERE pickup_time IS NULL;


---- error table should be empty ----
SELECT COUNT(*) FROM error_checking.silver.fhv_errors;

