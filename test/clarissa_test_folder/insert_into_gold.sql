

INSERT INTO trip_fact_table (
,vendor_id
,passenger_count 
,trip_distance
,PU_zone_id
,DO_zone_id 
,PU_date_id -- dimension
,PU_time_id -- dimension
,DO_date_id -- dimension
,DO_time_id -- dimension
,rate_code_id -- dimension
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
)

SELECT

vendor_id
,passenger_count
,trip_distance
,PU_zone_id 
,DO_zone_id 
,PU_date_id 
,t.PU_time_id 
,d.DO_date_id 
,t.DO_time_id 
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

FROM
    -- snowflake silver table
JOIN
    time_dim t ON tf.pickup_time = t.time
JOIN
    date_dim p ON st.product_id = p.product_id;

-- FHV gold layer insertion
INSERT INTO fhv_trip_fact_table
(
fhv_trip_id
,dispatching_base_number
,PU_date_id
,PU_time_id
,DO_date_id
,DO_time_id
,PU_location_id
,DO_location_id
,SR_flag
)
SELECT
id
,dispatching_base_number
,date.date_id
,time.time_id
,date.date_id
,time.time_id
,dolocationid
,pulocationid
,sr_flag
FROM silver_layer.test.fhv AS SL
JOIN
    time_dim time ON sl.dropoff_time = time.time
JOIN
    date_dim date ON sl.dropoff_date = date.date