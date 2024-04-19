-- FHV INSERT INTO SILVER

INSERT INTO nyc_taxi.silver.fhv (dispatching_base_number,
    dropoff_date,
    dropoff_time,
    pickup_date,
    pickup_time,
    DOlocationID,
    PUlocationID,
    sr_flag,
    trip_time)
SELECT
    upper(DISPATCHING_BASE_NUM),
    CASE WHEN year(to_date(dropoff_datetime)) BETWEEN 2018 AND 2024 THEN to_date(dropoff_datetime)
    ELSE NULL END AS dropoff_date,
    to_time(dropoff_datetime),
    CASE WHEN year(to_date(pickup_datetime)) BETWEEN 2018 AND 2024 THEN to_date(pickup_datetime)
    ELSE NULL END AS pickup_date,
    to_time(pickup_datetime),
    CASE WHEN dolocationid BETWEEN 1 AND 265 THEN dolocationid ELSE 264 END AS dolocationid, 
    CASE WHEN pulocationid BETWEEN 1 AND 265 THEN pulocationid ELSE 264 END AS pulocationid, 
    CASE WHEN sr_flag IS NULL THEN 0 WHEN sr_flag = 1 THEN 1 ELSE 2 END AS sr_flag,
    CASE WHEN TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60 < 0 AND ROUND((TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60) + 1440 , 1) > 480 THEN NULL
        WHEN TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60 < 0 THEN ROUND((TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60) + 1440 , 1)
        WHEN TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60 > 480 THEN NULL
        ELSE ROUND((TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60), 1) END AS trip_time
FROM nyc_taxi.senior_bronze.fhv
;