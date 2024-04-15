-- Setup
USE WAREHOUSE tyler_big_wh;
USE DATABASE bronze_layer_2018_on;
USE SCHEMA flattened;

-- create flat yellow taxi table in bronze layer
CREATE OR REPLACE TABLE yellow_flat_from_2018 AS 
SELECT
    taxi_col:DOLocationID::int as DOLocationID,
    taxi_col:PULocationID::int as PULocationID,
    taxi_col:RatecodeID::int as RatecodeID,
    taxi_col:VendorID::int as VendorID,
    taxi_col:extra::float as extra,
    taxi_col:fare_amount::float as fare_amount,
    taxi_col:improvement_surcharge::float as improvement_surcharge,
    taxi_col:mta_tax::float as mta_tax,
    taxi_col:passenger_count::int as passenger_count,
    taxi_col:payment_type::int as payment_type, 
    taxi_col:store_and_fwd_flag::string(10) as store_and_fwd_flag,
    taxi_col:tip_amount::float as tip_amount,
    taxi_col:tolls_amount::float as tolls_amount,
    taxi_col:total_amount::float as total_amount,
    taxi_col:tpep_dropoff_datetime::string(50) as tpep_dropoff_datetime, 
    taxi_col:tpep_pickup_datetime::string(50) as tpep_pickup_datetime,
    taxi_col:trip_distance::float as trip_distance,
    taxi_col:congestion_surchage::float as congestion_surcharge,
    taxi_col:airport_fee::float as airport_fee,
FROM bronze_layer_2018_on.json.yellow_from_2018_in
;

USE WAREHOUSE tyler_wh;
USE DATABASE bronze_layer_2018_on;
USE SCHEMA flattened;
--SELECT COUNT(*) FROM yellow_flat_from_2018;
--SHOW COLUMNS IN yellow_flat_from_2018;