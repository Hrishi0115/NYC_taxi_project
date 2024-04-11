-- Setup
USE WAREHOUSE --your wh;
USE DATABASE --your db;
USE SCHEMA --your schema;


-- view flattened variant table
SELECT 
    taxi_col:dropoff_datetime::datetime AS dropoff_datetime,
    taxi_col:dropoff_latitude::float AS dropoff_latitude,
    taxi_col:dropoff_longitude::float AS dropoff_longitude,
    taxi_col:fare_amount::float AS fare_amount,
    taxi_col:mta_tax::float AS mta_tax,
    taxi_col:passenger_count::int AS passenger_count,
    taxi_col:payment_type::string AS payment_type,
    taxi_col:pickup_datetime::datetime AS pickup_datetime,
    taxi_col:pickup_longitude::float AS pickup_longitude,
    taxi_col:rate_code::int AS rate_code,
    taxi_col:surcharge::float AS surcharge,
    taxi_col:tip_amount::float AS tip_amount,
    taxi_col:tolls_amount::float AS tolls_amount,
    taxi_col:total_amount::float AS total_amount,
    taxi_col:trip_distance::float AS trip_distance,
    taxi_col:vendor_id::string AS vendor_id,
FROM yellow_taxi_1month_in LIMIT 10;


-- see original variant table
-- SELECT * FROM taxi_in LIMIT 1;


-- put into view for testing (remove limit 10 to insert all flattened data)
-- CREATE OR REPLACE VIEW taxi_snippet AS 
-- SELECT 
--     taxi_col:dropoff_datetime::datetime AS dropoff_datetime,
--     taxi_col:dropoff_latitude::float AS dropoff_latitude,
--     taxi_col:dropoff_longitude::float AS dropoff_longitude,
--     taxi_col:fare_amount::float AS fare_amount,
--     taxi_col:mta_tax::float AS mta_tax,
--     taxi_col:passenger_count::int AS passenger_count,
--     taxi_col:payment_type::string AS payment_type,
--     taxi_col:pickup_datetime::datetime AS pickup_datetime,
--     taxi_col:pickup_longitude::float AS pickup_longitude,
--     taxi_col:rate_code::int AS rate_code,
--     taxi_col:surcharge::float AS surcharge,
--     taxi_col:tip_amount::float AS tip_amount,
--     taxi_col:tolls_amount::float AS tolls_amount,
--     taxi_col:total_amount::float AS total_amount,
--     taxi_col:trip_distance::float AS trip_distance,
--     taxi_col:vendor_id::string AS vendor_id,
-- FROM yellow_taxi_1month_in LIMIT 10;