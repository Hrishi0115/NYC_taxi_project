-- FHV INSERT INTO GOLD

INSERT INTO nyc_taxi.gold.fact_fhv_trip (
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
FROM silver.fhv AS silver
LEFT JOIN gold.date_dim AS pickup_date
    ON silver.pickup_date = pickup_date.date
LEFT JOIN gold.date_dim AS dropoff_date
    ON silver.dropoff_date = dropoff_date.date
LEFT JOIN gold.time_dim AS pickup_time
    ON silver.pickup_time = pickup_time.time
LEFT JOIN gold.time_dim AS dropoff_time
    ON silver.dropoff_time = dropoff_time.time
;

