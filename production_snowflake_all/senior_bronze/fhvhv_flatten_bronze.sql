-- FHV HV CREATE BRONZE FLATTENED TABLE AS

CREATE OR REPLACE TABLE nyc_taxi.senior_bronze.fhvhv AS 
SELECT
    $1:hvfhs_license_num::STRING AS hvfhs_license_num,
    $1:dispatching_base_num::STRING AS dispatching_base_num,
    $1:originating_base_num AS originating_base_num,
    $1:pickup_datetime::STRING AS pickup_datetime,
    $1:dropoff_datetime::STRING AS dropoff_datetime,
    $1:PULocationID::INT AS pulocationid,
    $1:DOLocationID::INT AS dolocationid,
    $1:request_datetime::STRING AS request_datetime,
    $1:on_scene_datetime::STRING AS on_scene_datetime,
    $1:trip_miles::DECIMAL(10,2) AS trip_miles,
    $1:trip_time::INT AS trip_time,
    $1:base_passenger_fare::DECIMAL(10,2) AS base_passenger_fare,
    $1:tolls::DECIMAL(10,2) AS tolls,
    $1:bcf::DECIMAL(10,2) AS black_car_fund,
    $1:sales_tax::DECIMAL(10,2) AS sales_tax,
    $1:congestion_surcharge::DECIMAL(10,2) AS congestion_surcharge,
    $1:airport_fee::DECIMAL(10,2) AS airport_fee,
    $1:tips::DECIMAL(10,2) AS tips,
    $1:driver_pay::DECIMAL(10,2) AS driver_pay,
    $1:shared_request_flag::STRING AS shared_request_flag,
    $1:shared_match_flag::STRING AS shared_match_flag,
    $1:access_a_ride_flag::STRING AS access_a_ride_flag, 
    $1:wav_request_flag::STRING AS wav_request_flag,
    $1:wav_match_flag::STRING AS wav_match_flag
FROM nyc_taxi.bronze.fhvhv
;