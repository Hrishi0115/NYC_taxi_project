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