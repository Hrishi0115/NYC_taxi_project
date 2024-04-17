
---- see documentation for silver tables
---- this script validates correct transformations have been applied

------ create error table for silver layer fhvhvhv taxis ------
DROP TABLE IF EXISTS error_checking.silver.fhvhvhv_errors;
CREATE OR REPLACE TABLE error_checking.silver.fhvhv_errors
(
    row_id INT,
    message STRING -- message will change depending on test
);

------ populate error table with values that dont conform to silver cleaning/transformations outlined in data dictionary ------

-- 1. dolocationid column
-- should be between 1-265, no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid dolocationid'
FROM silver_layer.test.fhvhv
WHERE dolocationid NOT BETWEEN 1 AND 265
   OR dolocationid IS NULL;


-- 2. pulocationid column
-- should be between 1-265, no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid pulocationid'
FROM silver_layer.test.fhvhv
WHERE pulocationid NOT BETWEEN 1 AND 265
   OR pulocationid IS NULL;


-- 3. dispatching_base_number column
-- should be 6 character string, where first character is 'B'
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid dispatching_base_number'
FROM silver_layer.test.fhvhv
WHERE len(trim(dispatching_base_number)) != 6 
    OR LEFT(dispatching_base_number,1) != 'B';


-- 4. originating_base_number column
-- should be 6 character string, where first character is 'B'
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid originating_base_number'
FROM silver_layer.test.fhvhv
WHERE len(trim(originating_base_number)) != 6 
    OR LEFT(originating_base_number,1) != 'B';


-- 5. dropoff_date date column
-- should be year 2018 or later
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid dropoff_date'
FROM silver_layer.test.fhvhv
WHERE year(dropoff_date) NOT BETWEEN 2018 AND 2024;


-- 6. pickup_date date column
-- should be year 2018 or later
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid pickup_date'
FROM silver_layer.test.fhvhv
WHERE year(pickup_date) NOT BETWEEN 2018 AND 2024;

-- 7. request_date date column
-- should be year 2018 or later
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid request_date'
FROM silver_layer.test.fhvhv
WHERE year(request_date) NOT BETWEEN 2018 AND 2024;

-- 8. on_scene_date date column
-- should be year 2018 or later
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid on_scene_date'
FROM silver_layer.test.fhvhv
WHERE year(on_scene_date) NOT BETWEEN 2018 AND 2024;

-- 9. dropoff_time time column
-- should be time format, no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid dropoff_time'
FROM silver_layer.test.fhvhv
WHERE dropoff_time IS NULL;

-- 10. pickup_time time column
-- should be time format, no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid pickup_time'
FROM silver_layer.test.fhvhv
WHERE pickup_time IS NULL;

-- 11. request_time time column
-- should be time format, no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid request_time'
FROM silver_layer.test.fhvhv
WHERE request_time IS NULL;

-- 12. trip_miles column
-- should be between 0 and 300
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid trip_miles'
FROM silver_layer.test.fhvhv
WHERE trip_miles NOT BETWEEN 0 AND 300;

-- 13. trip_time column
-- should be between 0 and 480
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid trip_time'
FROM silver_layer.test.fhvhv
WHERE trip_time NOT BETWEEN 0 AND 480;

-- 14. hvfhs_license_number column
-- should be in HV0002, HV0003, HV0004, HV0005
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid hvfhs_license_number'
FROM silver_layer.test.fhvhv
WHERE hvfhs_license_number NOT IN ('HV0002', 'HV0003', 'HV0004', 'HV0005');

-- 15. base_passenger_fare column
-- should be between 0 and 500
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid base_passenger_fare'
FROM silver_layer.test.fhvhv
WHERE base_passenger_fare NOT BETWEEN 0 AND 500;

-- 16. tolls column
-- should be between 0 and 120
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid tolls'
FROM silver_layer.test.fhvhv
WHERE tolls NOT BETWEEN 0 AND 120;

-- 17. black_car_fund column
-- should be between 0 and 50
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid black_car_fund'
FROM silver_layer.test.fhvhv
WHERE black_car_fund NOT BETWEEN 0 AND 50;

-- 18. sales_tax column
-- should be between 0 and 50
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid sales_tax'
FROM silver_layer.test.fhvhv
WHERE sales_tax NOT BETWEEN 0 AND 50;

-- 19. congestion_surcharge column
-- should be between 0 and 50
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid congestion_surcharge'
FROM silver_layer.test.fhvhv
WHERE congestion_surcharge NOT BETWEEN 0 AND 50;

-- 20. airport_fee column
-- should be in range (2.5, 5.0, 7.5) or null
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid airport_fee'
FROM silver_layer.test.fhvhv
WHERE airport_fee NOT IN (2.5, 5.0, 7.5) AND NOT NULL;

-- 21. tips column
-- should be positive and not null
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid tips'
FROM silver_layer.test.fhvhv
WHERE tips < 0 OR NULL;

-- 22. driver_pay column
-- should be between 0 and 500
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid driver_pay'
FROM silver_layer.test.fhvhv
WHERE driver_pay NOT BETWEEN 0 AND 500;

-- 23. shared_request_flag column
-- should be in ('Y', 'N', 'U'), no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid shared_request_flag'
FROM silver_layer.test.fhvhv
WHERE shared_request_flag NOT IN ('Y', 'N', 'U')
    OR shared_request_flag IS NULL;

-- 24. shared_match_flag column
-- should be in ('Y', 'N', 'U'), no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid shared_match_flag'
FROM silver_layer.test.fhvhv
WHERE shared_match_flag NOT IN ('Y', 'N', 'U')
    OR shared_match_flag IS NULL;

-- 25. access_a_ride_flag column
-- should be in ('Y', 'N', 'U'), no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid access_a_ride_flag'
FROM silver_layer.test.fhvhv
WHERE access_a_ride_flag NOT IN ('Y', 'N', 'U')
    OR access_a_ride_flag IS NULL;

-- 26. wav_request_flag column
-- should be in ('Y', 'N', 'U'), no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid wav_request_flag'
FROM silver_layer.test.fhvhv
WHERE wav_request_flag NOT IN ('Y', 'N', 'U')
    OR wav_request_flag IS NULL;

-- 27. wav_match_flag column
-- should be in ('Y', 'N', 'U'), no nulls
INSERT INTO error_checking.silver.fhvhv_errors
SELECT
    id,
    'invalid wav_match_flag'
FROM silver_layer.test.fhvhv
WHERE wav_match_flag NOT IN ('Y', 'N', 'U')
    OR wav_match_flag IS NULL;


---- error table should be empty ----
SELECT COUNT(*) FROM error_checking.silver.fhvhv_errors;


