USE WAREHOUSE tyler_wh;
USE DATABASE gold_level;
USE SCHEMA public;


-- testing fact table function before inserting all data
SELECT * FROM gold_level.public.trip_fact_table;
INSERT INTO gold_level.public.trip_fact_table
(
    vendor_id,
    passenger_count
)
VALUES(4, 5);




-- -- real insert
-- INSERT INTO gold_level.public.trip_fact_table
-- (
-- vendor_id
-- ,passenger_count
-- ,trip_distance
-- ,PU_zone_id
-- ,DO_zone_id
-- ,PU_date_id
-- ,PU_time_id
-- ,DO_date_id
-- ,DO_time_id
-- ,rate_code_id
-- ,payment_type_id
-- ,taxi_type_id
-- ,fare_amount
-- ,extra
-- ,mta_tax
-- ,improvement_surcharge
-- ,tip_amount
-- ,total_amount
-- ,airport_fee
-- ,congestion_surcharge
-- )
-- SELECT
--     -- cols
-- FROM silver_layer.test.yellow;











-- reset fact table (need to drop AND create):
DROP TABLE IF EXISTS gold_level.public.trip_fact_table;
create or replace table gold_level.public.trip_fact_table
(
taxi_trip_id INT PRIMARY KEY AUTOINCREMENT 
,taxi_colour VARCHAR(6)
,vendor_id VARCHAR(5)
,passenger_count INT
,trip_distance FLOAT
,PU_zone_id INT
,DO_zone_id INT
,PU_date_id INT
,PU_time_id INT
,DO_date_id INT
,DO_time_id INT
,rate_code_id INT
,payment_type_id INT
,taxi_type_id INT
,fare_amount FLOAT
,extra FLOAT
,mta_tax FLOAT
,improvement_surcharge FLOAT
,tip_amount FLOAT
,total_amount FLOAT
,airport_fee FLOAT
,congestion_surcharge FLOAT
);