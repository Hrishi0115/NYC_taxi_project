-- Setup
USE WAREHOUSE tyler_wh;
USE DATABASE silver_layer;
USE SCHEMA test;

-- source table columns:
--SHOW COLUMNS IN bronze_layer.flattened.yellow_flat;

DROP TABLE IF EXISTS silver_layer.test.yellow;

-- writing silver ctas all together
CREATE OR REPLACE TABLE silver_layer.test.yellow 
(
    id INT AUTOINCREMENT PRIMARY KEY,
    dolocationid INT,
    pulocationid INT,
    ratecodeid INT,
    vendorid INT,
    extra DECIMAL(10,2), 
    fare_amount DECIMAL(10,2),
    improvement_surchage DECIMAL(10,2),
    mta_tax DECIMAL(10,2),
    passenger_count INT,
    payment_type INT,
    store_and_fwd_flag STRING(1),
    tip_amount DECIMAL(10,2),
    tolls_amount DECIMAL(10,2),
    tpep_dropoff_date DATE,
    tpep_dropoff_time TIME,
    tpep_pickup_date DATE,
    tpep_pickup_time TIME,
    trip_distance DECIMAL(10,2),
    congestion_surcharge DECIMAL(10,2),
    airport_fee DECIMAL(10,2),
    total_amount DECIMAL(10,2)
);

INSERT INTO silver_layer.test.yellow 
(
    dolocationid,
    pulocationid,
    ratecodeid,
    vendorid,
    extra, 
    fare_amount,
    improvement_surchage,
    mta_tax,
    passenger_count,
    payment_type,
    store_and_fwd_flag,
    tip_amount,
    tolls_amount,
    tpep_dropoff_date,
    tpep_dropoff_time,
    tpep_pickup_date,
    tpep_pickup_time,
    trip_distance,
    congestion_surcharge,
    airport_fee,
    total_amount
)
-- testing cleaning query for insert silver table
WITH silver_cte AS (
SELECT
        CASE 
        WHEN dolocationid >= 1 AND dolocationid <= 265 THEN dolocationid
        ELSE 264 END AS -- 264 means unknown in zone mapping
    dolocationid,
        CASE 
        WHEN pulocationid >= 1 AND pulocationid <= 265 THEN pulocationid
        ELSE 264 END AS -- 264 means unknown in zone mapping
    pulocationid,
        CASE 
        WHEN ratecodeid >= 1 AND ratecodeid <= 6 THEN ratecodeid 
        ELSE 7 END AS -- SET 7 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE
    ratecodeid,
        CASE 
        WHEN vendorid NOT IN (1,2) THEN 3 -- SET 3 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE
        ELSE vendorid END AS 
    vendorid,
        CASE 
        WHEN extra NOT IN (0, 0.5, 1, 4.5, 2.75, -0.5, -1, -2.75, -4.5) THEN NULL
        WHEN extra < 0 THEN extra*-1
        ELSE extra END AS
    extra,
        CASE 
        WHEN fare_amount > 500 OR fare_amount < -500 THEN NULL
        WHEN fare_amount BETWEEN -500 AND 0 THEN fare_amount*-1
        ELSE fare_amount END AS
    fare_amount,
        CASE
        WHEN improvement_surcharge NOT IN (-0.3, 0, 0.3) THEN NULL
        WHEN improvement_surcharge = -0.3 THEN improvement_surcharge*-1
        ELSE improvement_surcharge END AS 
    improvement_surcharge,
        CASE 
        WHEN mta_tax NOT IN (-0.5, 0, 0.5) THEN NULL
        WHEN mta_tax = -0.5 THEN mta_tax*-0.5
        ELSE mta_tax END AS 
    mta_tax,
        CASE
        WHEN passenger_count >= 0 AND passenger_count <= 6 THEN passenger_count
        ELSE NULL END AS
    passenger_count,
        CASE
        WHEN payment_type >= 1 AND payment_type <= 6 THEN payment_type
        ELSE 5 END AS --payment type 5 is unknown
    payment_type,
        CASE
        WHEN store_and_fwd_flag NOT IN ('Y', 'y', 'N', 'n') THEN 'U' -- put Unknown in dimension table
        WHEN store_and_fwd_flag IS NULL THEN 'U' -- have to be explicit as we use UPPER below
        ELSE UPPER(store_and_fwd_flag) END AS
    store_and_fwd_flag,
    tip_amount, -- ask richard about tips (theoretically could be any amount)
        CASE
        WHEN ABS(tolls_amount) > 120 THEN NULL
        ELSE ABS(tolls_amount) END AS
    tolls_amount,
        CASE 
        WHEN YEAR(TO_DATE(tpep_dropoff_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(tpep_dropoff_datetime)
        ELSE NULL END AS 
    tpep_dropoff_date,
    TO_TIME(tpep_dropoff_datetime) AS tpep_dropoff_time,
        CASE 
        WHEN YEAR(TO_DATE(tpep_pickup_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(tpep_pickup_datetime)
        ELSE NULL END AS 
    tpep_pickup_date,
    TO_TIME(tpep_pickup_datetime) AS tpep_pickup_time,
        CASE 
        WHEN ABS(trip_distance) > 200 THEN NULL
        ELSE ABS(trip_distance) END AS 
    trip_distance,
        CASE 
        WHEN congestion_surcharge > 120 THEN NULL
        ELSE congestion_surcharge END AS
    congestion_surcharge,
        CASE 
        WHEN ABS(airport_fee) NOT IN (0, 1.25) THEN NULL
        ELSE ABS(airport_fee) END AS 
    airport_fee
FROM bronze_layer.flattened.yellow_flat
)  
SELECT
    *,
    fare_amount + extra + mta_tax + improvement_surcharge + tip_amount + tolls_amount AS total_amount
FROM silver_cte;

