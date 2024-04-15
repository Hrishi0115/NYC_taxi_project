-- Setup
USE WAREHOUSE;
USE DATABASE;
USE SCHEMA;
 
-- source table columns:
--SHOW COLUMNS IN bronze_layer.flattened.green_flat;

DROP TABLE IF EXISTS silver_layer.test.green;



CREATE OR REPLACE TABLE silver_layer.test.green
(
    id INT AUTOINCREMENT PRIMARY KEY,
    dolocationid INT,
    pulocationid INT,
    ratecodeid INT,
    vendorid INT,
    extra DECIMAL(10,2),
    fare_amount DECIMAL(10,2),
    improvement_surcharge DECIMAL(10,2),
    MTA_TAX DECIMAL(10,2),
    passenger_count INT,
    payment_type INT,
    Store_and_fwd_flag STRING(1),
    tip_amount DECIMAL(10,2),
    tolls_amount DECIMAL(10,2),
    lpep_dropoff_date DATE,
    lpep_pickup_date DATE,
    lpep_pickup_time TIME,
    lpep_dropoff_time TIME,
    trip_distance DECIMAL(10,2),
    TRIP_TYPE INT,
    total_amount DECIMAL(10,2)
);

INSERT INTO silver_layer.test.green 
(
    dolocationid,
    pulocationid,
    ratecodeid,
    vendorid,
    extra,
    fare_amount,
    improvement_surcharge,
    MTA_TAX,
    passenger_count,
    payment_type,
    Store_and_fwd_flag,
    tip_amount,
    tolls_amount,
    lpep_dropoff_date,
    lpep_dropoff_time,
    lpep_pickup_date,
    lpep_pickup_time,
    trip_distance,
    TRIP_TYPE,
    total_amount
)

WITH silver_cte AS (
SELECT
        CASE
        WHEN dolocationid < 1 or dolocationid > 265 THEN 264
        ELSE dolocationid END AS
    dolocationid,
        CASE
        WHEN pulocationid NOT BETWEEN 1 AND 265 THEN 264
        ELSE pulocationid END AS
    pulocationid,
        CASE
        WHEN ratecodeid NOT BETWEEN 1 AND 6 THEN 7 -- SET 7 as UKNOWN FOR RATECODE ID IN DIMENSION TABLE.
        ELSE ratecodeid END AS
    ratecodeid,
        CASE
        WHEN vendorid NOT BETWEEN 1 AND 2 THEN 3 -- SET 3 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE. 
        ELSE vendorid END AS
    vendorid,
        CASE 
        WHEN extra NOT IN (0, 0.5, 1, 4.5, 2.75, -0.5, -1, -2.75, -4.75) THEN NULL
        WHEN extra < 0 THEN extra*-1
        ELSE extra END AS
    extra,
        CASE
        WHEN fare_amount > 500 or fare_amount < -500 THEN NULL
        WHEN fare_amount BETWEEN -500 AND 0 THEN fare_amount*-1
        ELSE fare_amount END AS
    fare_amount,
        CASE 
        WHEN improvement_surcharge NOT IN (-0.3, 0, 0.3) THEN NULL
        WHEN improvement_surcharge = -0.3 THEN improvement_surcharge*-1
        ELSE improvement_surcharge END AS
    improvement_surcharge,
        CASE
        WHEN MTA_TAX NOT IN (-0.5, 0, 0.5) THEN NULL
        WHEN MTA_TAX = -0.5 THEN MTA_TAX*-1
        ELSE MTA_TAX END AS
    MTA_TAX,
        CASE
        WHEN passenger_count NOT BETWEEN 0 AND 6 THEN NULL
        ELSE passenger_count END AS 
    passenger_count,
        CASE 
        WHEN payment_type NOT BETWEEN 1 AND 6 THEN 5
        ELSE payment_type END AS
    payment_type,
        CASE
        WHEN UPPER(Store_and_fwd_flag) NOT IN ('Y', 'N') THEN 'U'
        ELSE UPPER(Store_and_fwd_flag) END AS
    Store_and_fwd_flag,
    tip_amount,
        CASE
        WHEN ABS(tolls_amount) > 120 THEN NULL
        ELSE ABS(tolls_amount) END AS
    tolls_amount,
        CASE
        WHEN YEAR(TO_DATE(lpep_dropoff_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(lpep_dropoff_datetime)
        ELSE NULL END AS
    lpep_dropoff_date,
    TO_TIME(lpep_dropoff_datetime) AS lpep_dropoff_time,
        CASE
        WHEN YEAR(TO_DATE(lpep_pickup_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(lpep_pickup_datetime)
        ELSE NULL END AS
    lpep_pickup_date,
    TO_TIME(lpep_pickup_datetime) AS lpep_pickup_time,
        CASE
        WHEN ABS(trip_distance) > 200 THEN NULL
        ELSE ABS(trip_distance) END AS
    trip_distance,
        CASE 
        WHEN TRIP_TYPE NOT IN (1, 2) THEN 3
        ELSE TRIP_TYPE END AS
    TRIP_TYPE
    FROM bronze_layer.flattened.green_flat
)

SELECT
*, 
(fare_amount + extra + mta_tax + improvement_surcharge + tip_amount + tolls_amount) AS total_amount
FROM silver_cte;


SELECT* FROM silver_layer.test.green LIMIT 10;




-- SELECT
--     -- MAX(dolocationid),
--     -- MIN(dolocationid),
--     -- MAX(pulocationid),
--     -- MIN(pulocationid),
--     -- MAX(extra),
--     -- MIN(extra),
--     -- MAX(fare_amount),
--     -- MIN(fare_amount),
--     -- MAX(improvement_surcharge),
--     -- MIN(improvement_surcharge)
--     DISTINCT payment_type
-- FROM test_silver_cte;


    


