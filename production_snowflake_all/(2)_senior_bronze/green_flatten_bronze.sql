-- GREEN CREATE BRONZE FLATTENED TABLE

CREATE OR REPLACE TABLE nyc_taxi.senior_bronze.green AS
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
FROM nyc_taxi.bronze.green
;


