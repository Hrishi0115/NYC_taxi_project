-- FHV HV INSERT INTO SILVER

INSERT INTO nyc_taxi.silver.fhvhv(hvfhs_license_number,
  dispatching_base_number,
  originating_base_number,
  pickup_date,
  pickup_time,
  dropoff_date,
  dropoff_time,
  PUlocationID,
  DOlocationID,
  request_date,
  request_time,
  on_scene_date,
  on_scene_time,
  trip_miles,
  trip_time,
  base_passenger_fare,
  tolls,
  black_car_fund,
  sales_tax,
  congestion_surcharge,
  airport_fee,
  tips,
  driver_pay,
  shared_request_flag,
  shared_match_flag,
  access_a_ride_flag,
  wav_request_flag,
  wav_match_flag)

SELECT
    upper(hvfhs_license_num),
    upper(dispatching_base_num),
    upper(originating_base_num),
    CASE WHEN year(to_date(pickup_datetime)) BETWEEN 2018 AND 2024 THEN to_date(pickup_datetime)
    ELSE NULL END AS pickup_date,
    to_time(pickup_datetime),
    CASE WHEN year(to_date(dropoff_datetime)) BETWEEN 2018 AND 2024 THEN to_date(dropoff_datetime)
    ELSE NULL END AS dropoff_date,
    to_time(dropoff_datetime),
    CASE WHEN pulocationid BETWEEN 1 AND 265 THEN pulocationid ELSE 264 END AS pulocationid, 
    CASE WHEN dolocationid BETWEEN 1 AND 265 THEN dolocationid ELSE 264 END AS dolocationid, 
    CASE WHEN year(to_date(request_datetime)) BETWEEN 2018 AND 2024 THEN to_date(request_datetime) ELSE NULL END AS request_date,
    to_time(request_datetime),
    CASE WHEN year(to_date(on_scene_datetime)) BETWEEN 2018 AND 2024 THEN to_date(on_scene_datetime) ELSE NULL END AS on_scene_date,
    to_time(on_scene_datetime),
    CASE WHEN ABS(trip_miles) > 300 THEN NULL ELSE ABS(trip_miles/60) END AS trip_miles,
    CASE WHEN ABS(trip_time/60) > 480 THEN NULL ELSE ROUND((ABS(trip_time) / 60), 1) END AS trip_time, 
    CASE WHEN base_passenger_fare BETWEEN -500 AND 500 THEN ABS(base_passenger_fare) ELSE NULL END AS base_passenger_fare,
    CASE WHEN ABS(tolls) > 120 THEN NULL ELSE ABS(tolls) END AS tolls,
    CASE WHEN ABS(black_car_fund) < 50 THEN ABS(black_car_fund) ELSE NULL END AS black_car_fund,
    CASE WHEN ABS(sales_tax) < 50 THEN ABS(sales_tax) ELSE NULL END AS sales_tax,
    CASE WHEN ABS(congestion_surcharge) < 50 THEN ABS(congestion_surcharge) ELSE NULL END AS congestion_surcharge,
    CASE WHEN airport_fee NOT IN (2.5, 5.0, 7.5, 10.0) THEN NULL ELSE airport_fee END AS airport_fee,
    ABS(tips) AS tips,
    CASE WHEN ABS(driver_pay) > 500 THEN NULL ELSE ABS(driver_pay) END AS driver_pay,
    CASE WHEN upper(shared_request_flag) NOT IN ('Y','N') THEN 'U'
    ELSE upper(shared_request_flag) END AS shared_request_flag,
    CASE WHEN upper(shared_match_flag) NOT IN ('Y','N') THEN 'U'
    ELSE upper(shared_match_flag) END AS shared_match_flag,
    CASE WHEN upper(access_a_ride_flag) != 'N' THEN 'Y'
    ELSE upper(access_a_ride_flag) END AS access_a_ride_flag,
    CASE WHEN upper(wav_request_flag) NOT IN ('Y','N') THEN 'U'
    ELSE upper(wav_request_flag) END AS wav_request_flag,
    CASE WHEN upper(wav_match_flag) NOT IN ('Y','N') THEN 'U'
    ELSE upper(wav_match_flag) END AS wav_match_flag
FROM nyc_taxi.senior_bronze.fhvhv
;