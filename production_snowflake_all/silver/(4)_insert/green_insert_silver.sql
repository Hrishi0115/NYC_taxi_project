
INSERT INTO nyc_taxi.silver.green
(
    dolocationid,
    pulocationid,
    ratecodeid,
    vendorid,
    extra,
    fare_amount,
    improvement_surcharge,
    MTA_TAX,
    passenger_count,
    payment_type,
    Store_and_fwd_flag,
    tip_amount,
    tolls_amount,
    lpep_dropoff_date,
    lpep_dropoff_time,
    lpep_pickup_date,
    lpep_pickup_time,
    trip_distance,
    trip_type,
    total_amount,
    trip_duration_minutes
)
WITH silver_cte AS (
SELECT
        CASE
        WHEN dolocationid BETWEEN 1 AND 265 THEN dolocationid
        ELSE 264 END AS
    dolocationid,
        CASE
        WHEN pulocationid BETWEEN 1 AND 265 THEN pulocationid
        ELSE 264 END AS
    pulocationid,
        CASE
        WHEN ratecodeid BETWEEN 1 AND 6 THEN ratecodeid -- SET 7 as UKNOWN FOR RATECODE ID IN DIMENSION TABLE.
        ELSE 7 END AS
    ratecodeid,
        CASE
        WHEN vendorid BETWEEN 1 AND 2 THEN vendorid -- SET 3 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE. 
        ELSE 3 END AS
    vendorid,
        CASE 
        WHEN extra IN (0, 0.5, 1, 4.5, 2.75, -0.5, -1, -2.75, -4.75) THEN ABS(extra)
        ELSE NULL END AS
    extra,
        CASE
        WHEN fare_amount BETWEEN -500 AND 500 THEN ABS(fare_amount)
        ELSE NULL END AS
    fare_amount,
        CASE 
        WHEN improvement_surcharge IN (-0.3, 0, 0.3) THEN ABS(improvement_surcharge)
        ELSE NULL END AS
    improvement_surcharge,
        CASE
        WHEN MTA_TAX IN (-0.5, 0, 0.5) THEN ABS(MTA_TAX)
        ELSE NULL END AS
    MTA_TAX,
        CASE
        WHEN passenger_count BETWEEN 0 AND 6 THEN passenger_count
        ELSE NULL END AS 
    passenger_count,
        CASE 
        WHEN payment_type BETWEEN 1 AND 6 THEN payment_type
        ELSE 5 END AS
    payment_type,
        CASE
        WHEN Store_and_fwd_flag NOT IN ('Y', 'y', 'N', 'n') THEN 'U'
        WHEN Store_and_fwd_flag IS NULL THEN 'U'
        ELSE UPPER(Store_and_fwd_flag) END AS
    Store_and_fwd_flag,
    ABS(tip_amount) AS tip_amount,
        CASE
        WHEN ABS(tolls_amount) > 120 THEN NULL
        ELSE ABS(tolls_amount) END AS
    tolls_amount,
        CASE
        WHEN YEAR(TO_DATE(lpep_dropoff_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(lpep_dropoff_datetime)
        ELSE NULL END AS
    lpep_dropoff_date,
    TO_TIME(lpep_dropoff_datetime) AS lpep_dropoff_time,
        CASE
        WHEN YEAR(TO_DATE(lpep_pickup_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(lpep_pickup_datetime)
        ELSE NULL END AS
    lpep_pickup_date,
    TO_TIME(lpep_pickup_datetime) AS lpep_pickup_time,
        CASE
        WHEN ABS(trip_distance) <= 200 THEN ABS(trip_distance)
        ELSE NULL END AS
    trip_distance,
        CASE 
        WHEN trip_type = 1 THEN 'Street-hail'
        WHEN trip_type = 2 THEN 'Dispatch'
        ELSE 'Unknown' END AS
    trip_type
    FROM nyc_taxi.senior_bronze.green
)
SELECT
*, 
COALESCE(fare_amount,0) + COALESCE(extra,0) + COALESCE(mta_tax,0) + COALESCE(improvement_surcharge,0) + COALESCE(tip_amount,0) + COALESCE(tolls_amount,0) AS
total_amount,
    CASE
    WHEN TIMEDIFF(second, lpep_pickup_time, lpep_dropoff_time) / 60 < 0 AND ROUND((TIMEDIFF(second, lpep_pickup_time, lpep_dropoff_time) / 60) + 1440 , 1) > 300
    THEN NULL
    WHEN TIMEDIFF(second, lpep_pickup_time, lpep_dropoff_time) / 60 < 0
    THEN ROUND((TIMEDIFF(second, lpep_pickup_time, lpep_dropoff_time) / 60) + 1440 , 1)
    WHEN TIMEDIFF(second, lpep_pickup_time, lpep_dropoff_time) / 60 > 300
    THEN NULL
    ELSE ROUND((TIMEDIFF(second, lpep_pickup_time, lpep_dropoff_time) / 60), 1) END AS
    trip_duration_minutes
FROM silver_cte;