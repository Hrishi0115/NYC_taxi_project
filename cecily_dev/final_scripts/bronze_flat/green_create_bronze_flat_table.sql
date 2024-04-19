-- GREEN CREATE BRONZE FLATTENED TABLE

CREATE OR REPLACE TABLE flattened.green_from_2018_flat (
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