use warehouse cecily_xs;
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
	ACCESS_A_RIDE_FLAG VARCHAR(1),
	WAV_REQUEST VARCHAR(1),
	WAV_MATCH_FLAG VARCHAR(1),
	primary key (FHV_TRIP_ID)
);

-- columns in gold:
INSERT INTO GOLD_LEVEL.PUBLIC.FHV_TRIP_FACT_TABLE (
	DISPATCHING_BASE_NUMBER,
	ORIGINATING_BASE_NUMBER,
	PU_DATE_ID,
	PU_TIME_ID,
	DO_DATE_ID,
	DO_TIME_ID,
	PU_LOCATION_ID,
	DO_LOCATION_ID,
	SR_FLAG,
	TRIP_TIME
)

SELECT 
    trim(dispatching_base_number),
    trim(dispatching_base_number),
    pickup_date.date_id,
    pickup_time.time_id,
    dropoff_date.date_id,
    dropoff_time.time_id,
    PUlocationID,
    DOlocationID,
    sr_flag,
    CASE WHEN TIMEDIFF(second, pickup_time, dropoff_time) / 60 < 0 AND ROUND((TIMEDIFF(second, pickup_time, dropoff_time) / 60) + 1440 , 1) > 480 THEN NULL
        WHEN TIMEDIFF(second, pickup_time, dropoff_time) / 60 < 0 THEN ROUND((TIMEDIFF(second, pickup_time, dropoff_time) / 60) + 1440 , 1)
        WHEN TIMEDIFF(second, pickup_time, dropoff_time) / 60 > 480 THEN NULL
        ELSE ROUND((TIMEDIFF(second, pickup_time, dropoff_time) / 60), 1) END AS trip_time
FROM silver_layer.test.fhv AS silver
LEFT JOIN gold_level.public.date_dim AS pickup_date
    ON silver.pickup_date = pickup_date.date
LEFT JOIN gold_level.public.date_dim AS dropoff_date
    ON silver.dropoff_date = dropoff_date.date
LEFT JOIN gold_level.public.time_dim AS pickup_time
    ON silver.pickup_time = pickup_time.time
LEFT JOIN gold_level.public.time_dim AS dropoff_time
    ON silver.dropoff_time = dropoff_time.time
;


SELECT COUNT(*) FROM GOLD_LEVEL.PUBLIC.FHV_TRIP_FACT_TABLE;

-- how many rows in fhv silver
SELECT COUNT(*) FROM silver_layer.test.fhv;

-- test
SELECT 
    dispatching_base_number,
    dispatching_base_number,
    (SELECT date_id FROM gold_level.public.time_dim WHERE gold_level.public.time_dim.date = pickup_date),
    (SELECT time_id FROM gold_level.public.time_dim WHERE gold_level.public.time_dim.time = pickup_time),
    (SELECT date_id FROM gold_level.public.time_dim WHERE gold_level.public.time_dim.date = dropoff_date),
    (SELECT time_id FROM gold_level.public.time_dim WHERE gold_level.public.time_dim.time = dropoff_time),
    PUlocationID,
    DOlocationID,
    sr_flag,
    CASE WHEN TIMEDIFF(second, pickup_time, dropoff_time) / 60 < 0 AND ROUND((TIMEDIFF(second, pickup_time, dropoff_time) / 60) + 1440 , 1) > 480 THEN NULL
        WHEN TIMEDIFF(second, pickup_time, dropoff_time) / 60 < 0 THEN ROUND((TIMEDIFF(second, pickup_time, dropoff_time) / 60) + 1440 , 1)
        WHEN TIMEDIFF(second, pickup_time, dropoff_time) / 60 > 480 THEN NULL
        ELSE ROUND((TIMEDIFF(second, pickup_time, dropoff_time) / 60), 1) END AS trip_time
FROM silver_layer.test.fhv
LIMIT 100;