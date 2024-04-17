


SELECT *
FROM bronze_layer.flattened.fhvhv_flat
LIMIT 100;

-- hvfhs_license_num
-- 3 rows
SELECT hvfhs_license_num, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY hvfhs_license_num
;
-- action: upper()

-- dipatching_base_num
-- group by dipatching_base_num --> 32 rows
SELECT dispatching_base_num, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY dispatching_base_num
;
-- action upper()

-- origating_base-num
SELECT originating_base_num, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY originating_base_num
;
-- action upper()

-- pick up date --> all in 2020
SELECT year(to_timestamp(pickup_datetime)), count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY year(to_timestamp(pickup_datetime))
;

-- drop off date --> all in 2020
SELECT year(to_timestamp(dropoff_datetime)), count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY year(to_timestamp(dropoff_datetime))
;

-- pu location id
SELECT pulocationid, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY pulocationid
ORDER BY pulocationid
;

-- do location id
SELECT dolocationid, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY dolocationid
ORDER BY dolocationid
;

-- request date --> all 2019-2020
SELECT year(to_timestamp(request_datetime)), count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY year(to_timestamp(request_datetime))
;

-- on-scene date --> all null/2020/2019
SELECT year(to_timestamp(on_scene_datetime)), count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY year(to_timestamp(on_scene_datetime))
;

-- trip miles
-- max 1,310 miles
-- min 0 miles
SELECT trip_miles
FROM bronze_layer.flattened.fhvhv_flat
WHERE trip_miles IS NULL
LIMIT 20;

CASE WHEN ABS(trip_miles) > 200 THEN NULL
    ELSE ABS(trip_miles) END AS trip_miles

-- trip time
-- max 84,894
-- min is 0
SELECT trip_miles, trip_time/120
FROM bronze_layer.flattened.fhvhv_flat
ORDER BY trip_time/120 DESC
LIMIT 20;
-- null if trip time > 10 hours (36,000 seconds)

-- base_passenger_fare
SELECT *
FROM bronze_layer.flattened.fhvhv_flat
ORDER BY base_passenger_fare
LIMIT 20;



-- tolls
WITH ctetolls AS (
SELECT CASE WHEN tolls > 50 THEN '> 50' 
    WHEN tolls > 25 THEN '> 25' 
    WHEN tolls > 15 THEN '> 15'
    WHEN tolls > 0 THEN '> 0'
    ELSE '< 0' END AS tollss
FROM bronze_layer.flattened.fhvhv_flat
)
SELECT tollss, count(*)
FROM ctetolls
GROUP BY tollss
;
-- action: if >50 or <-50 then null
-- if between -50 and 0 then flip sign

-- bcf
SELECT *
FROM bronze_layer.flattened.fhvhv_flat
ORDER BY black_car_fund
LIMIT 20;

-- what year is bronze data
SELECT year(to_date(pickup_datetime))
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY year(to_date(pickup_datetime));

-- sales tax
SELECT sales_tax, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY sales_tax
ORDER BY sales_tax DESC
LIMIT 100;

--congestion surcharge
SELECT
congestion_surcharge, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY congestion_surcharge
ORDER BY congestion_surcharge DESC
;

--airport fee

SELECT
airport_fee, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY airport_fee
;
-- tip amount
SELECT
tips, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY tips
LIMIT 20
;

--driver pay
SELECT
driver_pay, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY driver_pay
ORDER BY driver_pay DESC
LIMIT 20
;

-- shared_request_flag
SELECT shared_request_flag, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY shared_request_flag
HAVING shared_request_flag = 'Y'
;
-- should be Y or N

-- shared match flag
SELECT shared_match_flag, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY shared_match_flag
;

-- access_a_ride_flag
SELECT access_a_ride_flag, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY access_a_ride_flag
;
-- change all non-N to Y

-- wav request flag
SELECT wav_request_flag, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY wav_request_flag
;
-- wav match flag
SELECT wav_match_flag, count(*)
FROM bronze_layer.flattened.fhvhv_flat
GROUP BY wav_match_flag
;