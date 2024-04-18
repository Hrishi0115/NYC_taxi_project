INSERT INTO nyc_taxi.silver.yellow
(
    dolocationid,
    pulocationid,
    ratecodeid,
    vendorid,
    extra, 
    fare_amount,
    improvement_surcharge,
    mta_tax,
    passenger_count,
    payment_type,
    store_and_fwd_flag,
    tip_amount,
    tolls_amount,
    tpep_dropoff_date,
    tpep_dropoff_time,
    tpep_pickup_date,
    tpep_pickup_time,
    trip_distance,
    congestion_surcharge,
    airport_fee,
    total_amount,
    trip_duration_minutes
)
-- testing cleaning query for insert silver table
WITH silver_cte AS (
SELECT
        CASE 
        WHEN dolocationid BETWEEN 1 AND 265 THEN dolocationid
        ELSE 264 END AS -- 264 means unknown in zone mapping
    dolocationid,
        CASE 
        WHEN pulocationid BETWEEN 1 AND 265 THEN pulocationid
        ELSE 264 END AS -- 264 means unknown in zone mapping
    pulocationid,
        CASE 
        WHEN ratecodeid BETWEEN 1 AND 6 THEN ratecodeid 
        ELSE 7 END AS -- SET 7 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE
    ratecodeid,
        CASE 
        WHEN vendorid IN (1,2) THEN vendorid -- SET 3 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE
        ELSE 3 END AS 
    vendorid,
        CASE 
        WHEN extra IN (0, 0.5, 1, 4.5, 2.75, -0.5, -1, -2.75, -4.5) THEN ABS(extra)
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
        WHEN mta_tax IN (-0.5, 0, 0.5) THEN ABS(mta_tax)
        ELSE NULL END AS 
    mta_tax,
        CASE
        WHEN passenger_count BETWEEN 0 AND 6 THEN passenger_count
        ELSE NULL END AS
    passenger_count,
        CASE
        WHEN payment_type BETWEEN 1 AND 6 THEN payment_type
        ELSE 5 END AS --payment type 5 is unknown
    payment_type,
        CASE
        WHEN store_and_fwd_flag NOT IN ('Y', 'y', 'N', 'n') THEN 'U' -- put Unknown in dimension table
        WHEN store_and_fwd_flag IS NULL THEN 'U' -- have to be explicit as we use UPPER below
        ELSE UPPER(store_and_fwd_flag) END AS
    store_and_fwd_flag,
    ABS(tip_amount) AS tip_amount, -- ask richard about tips (theoretically could be any amount)
        CASE
        WHEN ABS(tolls_amount) > 120 THEN NULL
        ELSE ABS(tolls_amount) END AS
    tolls_amount,
        CASE 
        WHEN YEAR(TO_DATE(tpep_dropoff_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(tpep_dropoff_datetime)
        ELSE NULL END AS 
    tpep_dropoff_date,
    TO_TIME(tpep_dropoff_datetime) AS tpep_dropoff_time,
        CASE 
        WHEN YEAR(TO_DATE(tpep_pickup_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(tpep_pickup_datetime)
        ELSE NULL END AS 
    tpep_pickup_date,
    TO_TIME(tpep_pickup_datetime) AS tpep_pickup_time,
        CASE 
        WHEN ABS(trip_distance) <= 200 THEN ABS(trip_distance)
        ELSE NULL END AS 
    trip_distance,
        CASE 
        WHEN ABS(congestion_surcharge) < 120 THEN ABS(congestion_surcharge)
        ELSE NULL END AS
    congestion_surcharge,
        CASE 
        WHEN ABS(airport_fee) IN (0, 1.25) THEN ABS(airport_fee)
        ELSE NULL END AS 
    airport_fee
FROM nyc_taxi.senior_bronze.yellow
)  
SELECT
    *,
        COALESCE(fare_amount,0) + COALESCE(extra,0) + COALESCE(mta_tax,0) + COALESCE(improvement_surcharge,0) + COALESCE(tip_amount,0) + COALESCE(tolls_amount,0) AS 
    total_amount,
        CASE 
        WHEN TIMEDIFF(second, tpep_pickup_time, tpep_dropoff_time) / 60 < 0 AND ROUND((TIMEDIFF(second, tpep_pickup_time, tpep_dropoff_time) / 60) + 1440 , 1) > 300 
            THEN NULL
        WHEN TIMEDIFF(second, tpep_pickup_time, tpep_dropoff_time) / 60 < 0
            THEN ROUND((TIMEDIFF(second, tpep_pickup_time, tpep_dropoff_time) / 60) + 1440 , 1) 
        WHEN TIMEDIFF(second, tpep_pickup_time, tpep_dropoff_time) / 60 > 300 
            THEN NULL
        ELSE ROUND((TIMEDIFF(second, tpep_pickup_time, tpep_dropoff_time) / 60), 1) END AS 
    trip_duration_minutes
    -- trips limited to 5hrs (300 mins) max (justification: trips of 200 miles with time 280 mins exist, so we limit to 300 minutes)
FROM silver_cte;


