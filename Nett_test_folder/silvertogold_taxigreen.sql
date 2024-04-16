USE WAREHOUSE NETT_WH;
USE DATABASE gold_level;
USE SCHEMA public;

SELECT * FROM gold_level.public.trip_fact_table;
--TRUNCATE TABLE gold_level.public.trip_fact_table;

--Insert all green data into fact table.
INSERT INTO gold_level.public.trip_fact_table
(
vendor_id
,passenger_count
,trip_distance
,PU_zone_id
,DO_zone_id
,PU_date_id
,PU_time_id
,DO_date_id
,DO_time_id
,rate_code_id
,payment_type_id
,taxi_type_id
,fare_amount
,extra
,mta_tax
,improvement_surcharge
,tip_amount
,total_amount
,trip_duration_minutes
)

SELECT
    silver.vendorid
    ,silver.passenger_count
    ,silver.trip_distance
    ,silver.pulocationid
    ,silver.dolocationid
    ,pickup_date.date_id
    ,pickup_time.time_id
    ,dropoff_date.date_id
    ,dropoff_time.time_id
    ,silver.ratecodeid
    ,silver.payment_type
    ,taxi_type_dim.taxi_type_id
    ,silver.fare_amount
    ,silver.extra
    ,silver.mta_tax
    ,silver.improvement_surcharge
    ,silver.tip_amount
    ,silver.total_amount
    ,silver.trip_duration_minutes
FROM silver_layer.test.green AS silver
LEFT JOIN gold_level.public.date_dim AS pickup_date
    ON silver.lpep_pickup_date = pickup_date.date
LEFT JOIN gold_level.public.date_dim AS dropoff_date
    ON silver.lpep_dropoff_date = dropoff_date.date
LEFT JOIN gold_level.public.time_dim AS pickup_time
    ON silver.lpep_pickup_time = pickup_time.time
LEFT JOIN gold_level.public.time_dim AS dropoff_time
    ON silver.lpep_dropoff_time = dropoff_time.time
LEFT JOIN gold_level.public.taxi_type_dim AS taxi_type_dim
    ON UPPER(silver.trip_type) = UPPER(taxi_type_dim.trip_type)
WHERE taxi_type_dim.taxi_type != 'yellow'
--LIMIT 5
;


--SELECT silver.trip_type FROM silver_layer.test.green AS silver LIMIT 5;