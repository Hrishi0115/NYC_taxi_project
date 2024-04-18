-- CREATE SILVER FHV HV TABLE

use database nyc_taxi;
use schema silver;
CREATE OR REPLACE TABLE silver.fhvhv (
  id INT AUTOINCREMENT PRIMARY KEY,
  hvfhs_license_number string,
  dispatching_base_number string,
  originating_base_number string,
  pickup_date date,
  pickup_time time,
  dropoff_date date,
  dropoff_time time,
  PUlocationID int,
  DOlocationID int,
  request_date date,
  request_time time,
  on_scene_date date,
  on_scene_time time,
  trip_miles float,
  trip_time float,
  base_passenger_fare float,
  tolls float,
  black_car_fund string,
  sales_tax float,
  congestion_surcharge float,
  airport_fee float,
  tips float,
  driver_pay float,
  shared_request_flag string,
  shared_match_flag string,
  access_a_ride_flag string,
  wav_request_flag string,
  wav_match_flag string
);