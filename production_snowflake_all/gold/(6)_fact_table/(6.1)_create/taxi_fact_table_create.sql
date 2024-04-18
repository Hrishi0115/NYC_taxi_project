
DROP TABLE IF EXISTS nyc_taxi.gold.fact_taxi_trip;

-- create fact table for yellow and green taxis
CREATE OR REPLACE TABLE nyc_taxi.gold.fact_taxi_trip
(
taxi_trip_id INT PRIMARY KEY AUTOINCREMENT --START 1 INCREMENT 1
,taxi_colour_id INT
,trip_type_id INT
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
,fare_amount FLOAT
,extra FLOAT
,mta_tax FLOAT
,improvement_surcharge FLOAT
,tip_amount FLOAT
,total_amount FLOAT
,airport_fee FLOAT
,congestion_surcharge FLOAT
,trip_duration_minutes DECIMAL(10,1)
);
