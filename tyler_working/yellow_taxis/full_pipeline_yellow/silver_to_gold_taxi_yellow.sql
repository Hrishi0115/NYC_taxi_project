USE WAREHOUSE tyler_wh;
USE DATABASE gold_level;
USE SCHEMA public;


-- Insert all yellow data (check no limit at end of statement)
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
,airport_fee
,congestion_surcharge
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
    ,1 -- yellow taxi
    ,silver.fare_amount
    ,silver.extra
    ,silver.mta_tax
    ,silver.improvement_surcharge
    ,silver.tip_amount
    ,silver.total_amount
    ,silver.airport_fee
    ,silver.congestion_surcharge
    ,silver.trip_duration_minutes
FROM silver_layer.test.yellow AS silver
LEFT JOIN gold_level.public.date_dim AS pickup_date
    ON silver.tpep_pickup_date = pickup_date.date 
LEFT JOIN gold_level.public.date_dim AS dropoff_date
    ON silver.tpep_dropoff_date = dropoff_date.date
LEFT JOIN gold_level.public.time_dim AS pickup_time
    ON silver.tpep_pickup_time = pickup_time.time
LEFT JOIN gold_level.public.time_dim AS dropoff_time
    ON silver.tpep_dropoff_time = dropoff_time.time
-- LIMIT 5
;




--------------------------------------



-- -- reset fact table (need to drop AND create):
-- -- send back to clarissa (final create table for fact table)
-- DROP TABLE IF EXISTS gold_level.public.trip_fact_table;




---------------------------


-- -- pre validation (practice entering one row at a time)
-- -- testing fact table function before inserting all data

-- -- inspect table
-- SELECT * FROM gold_level.public.trip_fact_table;

-- -- insert to table
-- INSERT INTO gold_level.public.trip_fact_table
-- (
--     improvement_surcharge
-- )
-- VALUES(7);


--------------------------


-- -- post validation (check date/time insert conversion) here:
-- SELECT 
--     *
-- FROM silver_layer.test.yellow
-- WHERE vendorid = 2
--     AND passenger_count = 1
--     AND trip_distance = 9.95
--     AND pulocationid = 142
--     AND dolocationid = 138
--     AND ratecodeid = 1
--     AND payment_type = 2
--     AND fare_amount = 30.5
--     AND total_amount = 31.3
--     AND trip_duration_minutes = 25.1
-- ;


--SELECT * FROM gold_level.public.taxi_type_dim;