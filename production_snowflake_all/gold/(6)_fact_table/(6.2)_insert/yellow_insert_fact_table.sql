
-- Insert all yellow data (check no limit at end of statement)
INSERT INTO nyc_taxi.gold.fact_taxi_trip
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
FROM nyc_taxi.silver.yellow AS silver
LEFT JOIN nyc_taxi.gold.date_dim AS pickup_date
    ON silver.tpep_pickup_date = pickup_date.date 
LEFT JOIN nyc_taxi.gold.date_dim AS dropoff_date
    ON silver.tpep_dropoff_date = dropoff_date.date
LEFT JOIN nyc_taxi.gold.time_dim AS pickup_time
    ON silver.tpep_pickup_time = pickup_time.time
LEFT JOIN nyc_taxi.gold.time_dim AS dropoff_time
    ON silver.tpep_dropoff_time = dropoff_time.time
LEFT JOIN nyc_taxi.gold.taxi_colour_dim AS taxi_colour_dim
    ON LOWER(taxi_colour_dim.taxi_colour) = 'yellow'
LEFT JOIN nyc_taxi.gold.trip_type_dim AS trip_type_dim
    ON LOWER(trip_type_dim.trip_type) = 'street-hail'
-- LIMIT 5
;

