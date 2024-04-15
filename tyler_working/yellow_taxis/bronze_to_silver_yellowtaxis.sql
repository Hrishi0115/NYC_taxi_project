-- Setup
USE WAREHOUSE tyler_wh;
USE DATABASE silver_layer;
USE SCHEMA test;

-- source table columns:
SHOW COLUMNS IN bronze_layer.flattened.yellow_flat;



-- testing create silver table
WITH silver_cte AS (
SELECT
        CASE 
        WHEN dolocationid < 1 OR dolocationid > 265 THEN 264 -- 264 means unknown in zone mapping
        ELSE dolocationid END AS 
    dolocationid,
        CASE 
        WHEN pulocationid < 1 OR pulocationid > 265 THEN 264 -- 264 means unknown in zone mapping
        ELSE pulocationid END AS 
    pulocationid,
        CASE 
        WHEN ratecodeid < 1 OR ratecodeid > 6 THEN 7 -- SET 7 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE
        WHEN ratecodeid IS NULL THEN 7
        ELSE ratecodeid END AS
    ratecodeid,
        CASE 
        WHEN vendorid < 1 OR vendorid > 2 THEN 3 -- SET 3 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE
        WHEN vendorid IS NULL THEN 3
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
        WHEN passenger_count < 0 OR passenger_count > 6 THEN NULL
        ELSE passenger_count END AS
    passenger_count,
        CASE
        WHEN payment_type < 1 OR payment_type > 6 THEN 5
        WHEN payment_type IS NULL THEN 5
        ELSE payment_type END AS
    payment_type,
        CASE
        WHEN UPPER(store_and_fwd_flag) NOT IN ('Y', 'N') THEN 'U' -- put Unknown in dimension table
        ELSE UPPER(store_and_fwd_flag) END AS
    store_and_fwd_flag,
    tip_amount, -- ask richard about tips (theoretically could be any amount)
        CASE
        WHEN ABS(tolls_amount) > 120 THEN NULL
        ELSE ABS(tolls_amount) END AS
    tolls_amount,
        CASE 
        WHEN YEAR(TO_DATE(tpep_dropoff_datetime)) > 2017 THEN TO_DATE(tpep_dropoff_datetime)
        ELSE NULL END AS 
    tpep_dropoff_date,
    TO_TIME(tpep_dropoff_datetime) AS tpep_dropoff_time,
        CASE 
        WHEN YEAR(TO_DATE(tpep_pickup_datetime)) > 2017 THEN TO_DATE(tpep_pickup_datetime)
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
FROM silver_cte
LIMIT 100;


