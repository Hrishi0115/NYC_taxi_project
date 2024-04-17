CREATE OR REPLACE TABLE ADF_TEST.ADF_PRE_SILVER.PRE_FHVHV AS
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
FROM ADF_TEST.ADF_LANDING.FHVHV_IN
;

CREATE TABLE ADF_TEST.ADF_SILVER.FHVHV AS
SELECT
    -- Assuming id is generated in a different way since auto-increment is not typical in all DBMS for SELECT INTO statements
    row_number() OVER (ORDER BY (SELECT NULL)) AS id,
    upper(hvfhs_license_num) AS hvfhs_license_number,
    upper(dispatching_base_num) AS dispatching_base_number,
    upper(originating_base_num) AS originating_base_number,
    CASE WHEN year(to_date(pickup_datetime)) BETWEEN 2018 AND 2024 THEN to_date(pickup_datetime) ELSE NULL END AS pickup_date,
    to_time(pickup_datetime) AS pickup_time,
    CASE WHEN year(to_date(dropoff_datetime)) BETWEEN 2018 AND 2024 THEN to_date(dropoff_datetime) ELSE NULL END AS dropoff_date,
    to_time(dropoff_datetime) AS dropoff_time,
    CASE WHEN pulocationid BETWEEN 1 AND 265 THEN pulocationid ELSE 264 END AS PUlocationID,
    CASE WHEN dolocationid BETWEEN 1 AND 265 THEN dolocationid ELSE 264 END AS DOlocationID,
    CASE WHEN year(to_date(request_datetime)) BETWEEN 2018 AND 2024 THEN to_date(request_datetime) ELSE NULL END AS request_date,
    to_time(request_datetime) AS request_time,
    CASE WHEN year(to_date(on_scene_datetime)) BETWEEN 2018 AND 2024 THEN to_date(on_scene_datetime) ELSE NULL END AS on_scene_date,
    to_time(on_scene_datetime) AS on_scene_time,
    CASE WHEN ABS(trip_miles) > 200 THEN NULL ELSE ABS(trip_miles) / 60 END AS trip_miles,
    CASE WHEN ABS(trip_time / 60) > 480 THEN NULL ELSE ROUND((ABS(trip_time) / 60), 1) END AS trip_time,
    CASE WHEN base_passenger_fare BETWEEN -500 AND 500 THEN ABS(base_passenger_fare) ELSE NULL END AS base_passenger_fare,
    CASE WHEN ABS(tolls) > 120 THEN NULL ELSE ABS(tolls) END AS tolls,
    CASE WHEN ABS(black_car_fund) < 50 THEN black_car_fund ELSE NULL END AS black_car_fund,
    CASE WHEN ABS(sales_tax) < 50 THEN sales_tax ELSE NULL END AS sales_tax,
    CASE WHEN ABS(congestion_surcharge) < 50 THEN congestion_surcharge ELSE NULL END AS congestion_surcharge,
    CASE WHEN airport_fee NOT IN (NULL, 0) THEN NULL ELSE airport_fee END AS airport_fee,
    ABS(tips) AS tips,
    CASE WHEN ABS(driver_pay) > 500 THEN NULL ELSE driver_pay END AS driver_pay,
    CASE WHEN upper(shared_request_flag) NOT IN ('Y', 'N') THEN 'U' ELSE upper(shared_request_flag) END AS shared_request_flag,
    CASE WHEN upper(shared_match_flag) NOT IN ('Y', 'N') THEN 'U' ELSE upper(shared_match_flag) END AS shared_match_flag,
    CASE WHEN upper(access_a_ride_flag) != 'N' THEN 'Y' ELSE upper(access_a_ride_flag) END AS access_a_ride_flag,
    CASE WHEN upper(wav_request_flag) NOT IN ('Y', 'N') THEN 'U' ELSE upper(wav_request_flag) END AS wav_request_flag,
    CASE WHEN upper(wav_match_flag) NOT IN ('Y', 'N') THEN 'U' ELSE upper(wav_match_flag) END AS wav_match_flag
FROM
    ADF_TEST.ADF_PRE_SILVER.PRE_FHVHV;


SELECT * FROM ADF_TEST.ADF_SILVER.YELLOW LIMIT 10;