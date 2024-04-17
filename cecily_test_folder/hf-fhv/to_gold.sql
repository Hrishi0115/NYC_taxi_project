use role accountadmin;
use warehouse cecily_xs;
use database gold_level;
use schema public;


-- create table
create or replace TABLE GOLD_LEVEL.PUBLIC.FHV_TRIP_FACT_TABLE (
	FHV_TRIP_ID NUMBER(38,0) NOT NULL autoincrement start 1 increment 1 noorder,
	DISPATCHING_BASE_NUMBER VARCHAR(15),
	ORIGINATING_BASE_NUMBER VARCHAR(15),
	PU_DATE_ID NUMBER(38,0),
	PU_TIME_ID NUMBER(38,0),
	DO_DATE_ID NUMBER(38,0),
	DO_TIME_ID NUMBER(38,0),
	PU_LOCATION_ID NUMBER(38,0),
	DO_LOCATION_ID NUMBER(38,0),
	SR_FLAG NUMBER(38,0),
	REQUEST_DATE_ID NUMBER(38,0),
	REQUEST_TIME_ID NUMBER(38,0),
	ONSCENE_DATE_ID NUMBER(38,0),
	ONSCENE_TIME_ID NUMBER(38,0),
	ACCESSIBLE_VEHICLE VARCHAR(1),
	TRIP_MILES FLOAT,
	TRIP_TIME FLOAT,
	BASE_PASSENGER_FARE FLOAT,
	TOLLS FLOAT,
	BCF FLOAT,
	SALES_TAX FLOAT,
	CONGESTION_SURCHARGE FLOAT,
	AIRPORT_FEE FLOAT,
	TIPS FLOAT,
	DRIVER_PAY FLOAT,
	SHARED_REQUEST_FLAG VARCHAR(1),
    SHARED_MATCH_FLAG VARCHAR(1),
	ACCESS_A_RIDE_FLAG VARCHAR(1),
	WAV_REQUEST_FLAG VARCHAR(1),
	WAV_MATCH_FLAG VARCHAR(1),
	primary key (FHV_TRIP_ID)
);

-- insert into:
INSERT INTO gold_level.public.fhv_trip_fact_table(
    DISPATCHING_BASE_NUMBER,
	ORIGINATING_BASE_NUMBER,
	PU_DATE_ID,
	PU_TIME_ID,
	DO_DATE_ID,
	DO_TIME_ID,
	PU_LOCATION_ID,
	DO_LOCATION_ID,
	SR_FLAG,
	REQUEST_DATE_ID,
	REQUEST_TIME_ID,
	ONSCENE_DATE_ID,
	ONSCENE_TIME_ID,
	ACCESSIBLE_VEHICLE,
	TRIP_MILES,
	TRIP_TIME,
	BASE_PASSENGER_FARE,
	TOLLS,
	BCF,
	SALES_TAX,
	CONGESTION_SURCHARGE,
	AIRPORT_FEE,
	TIPS,
	DRIVER_PAY,
	SHARED_REQUEST_FLAG,
    SHARED_MATCH_FLAG,
	ACCESS_A_RIDE_FLAG,
	WAV_REQUEST_FLAG,
	WAV_MATCH_FLAG
    )

SELECT 
    dispatching_base_number,
    originating_base_number,
    pickup_date.date_id,
    pickup_time.time_id,
    dropoff_date.date_id,
    dropoff_time.time_id,
    PUlocationID,
    DOlocationID,
    CASE WHEN hvfhs_license_number = 'HV0005' AND shared_request_flag = 'Y' THEN 1
    WHEN hvfhs_license_number IN ('HV0002', 'HV0003', 'HV0004') AND shared_request_flag = 'Y' AND shared_match_flag = 'Y' THEN 1 ELSE 0 
    END AS sr_flag,
    request_date.date_id,
    request_time.time_id,
    onscene_date.date_id,
    onscene_time.time_id,
    CASE WHEN on_scene_time IS NOT NULL THEN 'Y' ELSE 'N' END AS accessible_vehicle,
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
	wav_match_flag
FROM silver_layer.test.fhvhv AS silver
LEFT JOIN gold_level.public.date_dim AS pickup_date
    ON silver.pickup_date = pickup_date.date
LEFT JOIN gold_level.public.date_dim AS dropoff_date
    ON silver.dropoff_date = dropoff_date.date
LEFT JOIN gold_level.public.date_dim AS request_date
    ON silver.request_date = request_date.date
LEFT JOIN gold_level.public.date_dim AS onscene_date
    ON silver.on_scene_date = onscene_date.date
LEFT JOIN gold_level.public.time_dim AS pickup_time
    ON silver.pickup_time = pickup_time.time
LEFT JOIN gold_level.public.time_dim AS dropoff_time
    ON silver.dropoff_time = dropoff_time.time
LEFT JOIN gold_level.public.time_dim AS request_time
    ON silver.request_time = request_time.time
LEFT JOIN gold_level.public.time_dim AS onscene_time
    ON silver.on_scene_time = onscene_time.time
;

-- how many in silver --> 60,000,305
SELECT COUNT(*) FROM silver_layer.test.fhvhv;
-- look at data
SELECT * FROM silver_layer.test.fhvhv LIMIT 5;
-- what years --> 2020 only
SELECT year(pickup_date) FROM silver_layer.test.fhvhv
GROUP BY year(pickup_date);




SELECT * FROM gold_level.public.fhv_trip_fact_table;
-- test cte

WITH cte1 AS (
    SELECT 
    dispatching_base_number,
    originating_base_number,
    pickup_date.date_id,
    pickup_time.time_id AS pu_time_id,
    dropoff_date.date_id,
    dropoff_time.time_id AS do_time_id,
    PUlocationID,
    DOlocationID,
    CASE WHEN hvfhs_license_number = 'HV0005' AND shared_request_flag = 'Y' THEN 1
    WHEN hvfhs_license_number IN ('HV0002', 'HV0003', 'HV0004') AND shared_request_flag = 'Y' AND shared_match_flag = 'Y' THEN 1 ELSE 0 
    END AS sr_flag,
    request_date.date_id,
    request_time.time_id,
    onscene_date.date_id,
    onscene_time.time_id,
    CASE WHEN on_scene_time IS NOT NULL THEN 'Y' ELSE 'N' END AS accessible_vehicle,
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
	wav_match_flag
FROM silver_layer.test.fhvhv AS silver
LEFT JOIN gold_level.public.date_dim AS pickup_date
    ON silver.pickup_date = pickup_date.date
LEFT JOIN gold_level.public.date_dim AS dropoff_date
    ON silver.dropoff_date = dropoff_date.date
LEFT JOIN gold_level.public.date_dim AS request_date
    ON silver.request_date = request_date.date
LEFT JOIN gold_level.public.date_dim AS onscene_date
    ON silver.on_scene_date = onscene_date.date
LEFT JOIN gold_level.public.time_dim AS pickup_time
    ON silver.pickup_time = pickup_time.time
LEFT JOIN gold_level.public.time_dim AS dropoff_time
    ON silver.dropoff_time = dropoff_time.time
LEFT JOIN gold_level.public.time_dim AS request_time
    ON silver.request_time = request_time.time
LEFT JOIN gold_level.public.time_dim AS onscene_time
    ON silver.on_scene_time = onscene_time.time
)
SELECT * 
FROM cte1
WHERE pu_time_id IS NULL
LIMIT 100;


SELECT * FROM silver_layer.test.fhvhv LIMIT 5;

SELECT * FROM gold_level.public.fhv_trip_fact_table LIMIT 5;

SELECT sr_flag
FROM gold_level.public.fhv_trip_fact_table
GROUP BY sr_flag
;

-- sr_flag


-- check each column
-- nulls in time
SELEC