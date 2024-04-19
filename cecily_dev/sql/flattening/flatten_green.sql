-- FLATTEN GREEN DATA

-- setup
use role accountadmin;
use warehouse cecily_big_wh;
USE DATABASE bronze_layer;
USE SCHEMA public;

-- all green data
SELECT * FROM cecily.public.green_all_pre2019_data_taxi_in LIMIT 5;

-- the stage used previously:
list @all_green_azure_stage;

-- flatten data using select
SELECT
  $1:DOLocationID::int as DOLocationID,
  $1:PULocationID::int as PULocationID,
  $1:RatecodeID::int as RatecodeID,
  $1:VendorID::int as VendorID,
  $1:extra::float as extra,
  $1:fare_amount::float as fare_amount,
  $1:improvement_surcharge::float as improvement_surcharge,
  $1:lpep_dropoff_datetime::string as lpep_dropoff_datetime,
  $1:lpep_pickup_datetime::string as lpep_pickup_datetime,
  $1:mta_tax::float as mta_tax,
  $1:passenger_count::int as passenger_count,
  $1:payment_type::int as payment_type,
  $1:store_and_fwd_flag::string as store_and_fwd_flag,
  $1:tip_amount::float as tip_amount,
  $1:tolls_amount::float as tolls_amount,
  $1:total_amount::float as total_amount,
  $1:trip_distance::float as trip_distance,
  $1:trip_type::int as trip_type,
FROM public.green_all_pre2019_data_taxi_in
LIMIT 5;

-- create view of flattened data
CREATE OR REPLACE VIEW flattened_green_pre2019_data AS
SELECT
  $1:DOLocationID::int as DOLocationID,
  $1:PULocationID::int as PULocationID,
  $1:RatecodeID::int as RatecodeID,
  $1:VendorID::int as VendorID,
  $1:extra::float as extra,
  $1:fare_amount::float as fare_amount,
  $1:improvement_surcharge::float as improvement_surcharge,
  $1:lpep_dropoff_datetime::string as lpep_dropoff_datetime,
  $1:lpep_pickup_datetime::string as lpep_pickup_datetime,
  $1:mta_tax::float as mta_tax,
  $1:passenger_count::int as passenger_count,
  $1:payment_type::int as payment_type,
  $1:store_and_fwd_flag::string as store_and_fwd_flag,
  $1:tip_amount::float as tip_amount,
  $1:tolls_amount::float as tolls_amount,
  $1:total_amount::float as total_amount,
  $1:trip_distance::float as trip_distance,
  $1:trip_type::int as trip_type,
FROM public.green_all_pre2019_data_taxi_in
;

-- select from view
SELECT * FROM flattened_green_pre2019_data LIMIT 5;

-- pre 2019 green data (unflattened)
SELECT * FROM cecily.public.green_all_pre2019_data_taxi_in LIMIT 5;

-- create table to copy into
CREATE OR REPLACE TABLE green_pre2019_flat_data (
  DOLocationID int,
  PULocationID int,
  RatecodeID int,
  VendorID int,
  extra float,
  fare_amount float,
  improvement_surcharge float,
  lpep_dropoff_datetime string,
  lpep_pickup_datetime string,
  mta_tax float,
  passenger_count int,
  payment_type int,
  store_and_fwd_flag string,
  tip_amount float,
  tolls_amount float,
  total_amount float,
  trip_distance float,
  trip_type int
);

-- copy unflattened data into table we've just created
INSERT INTO green_pre2019_flat_data
SELECT
  $1:DOLocationID::int as DOLocationID,
  $1:PULocationID::int as PULocationID,
  $1:RatecodeID::int as RatecodeID,
  $1:VendorID::int as VendorID,
  $1:extra::float as extra,
  $1:fare_amount::float as fare_amount,
  $1:improvement_surcharge::float as improvement_surcharge,
  $1:lpep_dropoff_datetime::string as lpep_dropoff_datetime,
  $1:lpep_pickup_datetime::string as lpep_pickup_datetime,
  $1:mta_tax::float as mta_tax,
  $1:passenger_count::int as passenger_count,
  $1:payment_type::int as payment_type,
  $1:store_and_fwd_flag::string as store_and_fwd_flag,
  $1:tip_amount::float as tip_amount,
  $1:tolls_amount::float as tolls_amount,
  $1:total_amount::float as total_amount,
  $1:trip_distance::float as trip_distance,
  $1:trip_type::int as trip_type
FROM public.green_all_pre2019_data_taxi_in
;

SELECT * FROM green_pre2019_flat_data LIMIT 5;

-- check all rows copied

-- # rows in unflattened table
SELECT COUNT(*) FROM public.green_all_pre2019_data_taxi_in;
-- 72,093,092

-- # rows in flattened table
SELECT COUNT(*) FROM green_pre2019_flat_data;
-- 72,093,092