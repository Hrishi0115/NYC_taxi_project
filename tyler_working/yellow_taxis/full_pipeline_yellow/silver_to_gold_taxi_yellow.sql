USE WAREHOUSE tyler_wh;
USE DATABASE gold_level;
USE SCHEMA public;


-- Insert all yellow data (check no limit at end of statement)
INSERT INTO gold_level.public.trip_fact_table
(
taxi_colour_id
,vendor_id
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
,fare_amount
,extra
,mta_tax
,improvement_surcharge
,tip_amount
,total_amount
,trip_type_id
,airport_fee
,congestion_surcharge
,trip_duration_minutes 
)
SELECT
    taxi_colour_dim.taxi_colour_id -- should be 1: yellow taxi only 
    ,silver.vendorid
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
    ,silver.fare_amount
    ,silver.extra
    ,silver.mta_tax
    ,silver.improvement_surcharge
    ,silver.tip_amount
    ,silver.total_amount
    ,trip_type_dim.trip_type_id -- should be 1: street hail only for yellow taxis     
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
LEFT JOIN gold_level.public.taxi_colour_dim AS taxi_colour_dim
    ON LOWER(taxi_colour_dim.taxi_colour) = 'yellow'
LEFT JOIN gold_level.public.trip_type_dim AS trip_type_dim
    ON LOWER(trip_type_dim.trip_type) = 'street-hail'
-- LIMIT 5
;




------ END OF INSERT QUERY ------
--------------------------------------


-- -- reset fact table (need to drop AND create):
-- -- send back to clarissa (final create table for fact table)
-- DROP TABLE IF EXISTS gold_level.public.trip_fact_table;
-- create or replace table gold_level.public.trip_fact_table
-- (
-- taxi_trip_id INT PRIMARY KEY AUTOINCREMENT --START 1 INCREMENT 1
-- ,taxi_colour_id INT
-- ,trip_type_id INT
-- ,vendor_id VARCHAR(5)
-- ,passenger_count INT
-- ,trip_distance FLOAT
-- ,PU_zone_id INT
-- ,DO_zone_id INT
-- ,PU_date_id INT
-- ,PU_time_id INT
-- ,DO_date_id INT
-- ,DO_time_id INT
-- ,rate_code_id INT
-- ,payment_type_id INT
-- ,fare_amount FLOAT
-- ,extra FLOAT
-- ,mta_tax FLOAT
-- ,improvement_surcharge FLOAT
-- ,tip_amount FLOAT
-- ,total_amount FLOAT
-- ,airport_fee FLOAT
-- ,congestion_surcharge FLOAT
-- ,trip_duration_minutes DECIMAL(10,1)
-- );



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

