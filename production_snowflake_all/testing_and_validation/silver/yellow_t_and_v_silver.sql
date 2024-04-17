
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
-- should be between 1-265, no nulls
INSERT INTO error_checking.silver.yellow_errors
SELECT
    id,
    'invalid ratecodeid'
FROM silver_layer.test.yellow
WHERE ratecodeid NOT BETWEEN 1 AND 7
   OR ratecodeid IS NULL;





---- error table should be empty ----
SELECT COUNT(*) FROM error_checking.silver.yellow_errors;
