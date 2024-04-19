
DROP TABLE IF EXISTS nyc_taxi.silver.yellow;


CREATE OR REPLACE TABLE nyc_taxi.silver.yellow
(
    id INT AUTOINCREMENT PRIMARY KEY,
    dolocationid INT,
    pulocationid INT,
    ratecodeid INT,
    vendorid INT,
    extra DECIMAL(10,2), 
    fare_amount DECIMAL(10,2),
    improvement_surcharge DECIMAL(10,2),
    mta_tax DECIMAL(10,2),
    passenger_count INT,
    payment_type INT,
    store_and_fwd_flag STRING(1),
    tip_amount DECIMAL(10,2),
    tolls_amount DECIMAL(10,2),
    tpep_dropoff_date DATE,
    tpep_dropoff_time TIME,
    tpep_pickup_date DATE,
    tpep_pickup_time TIME,
    trip_distance DECIMAL(10,2),
    congestion_surcharge DECIMAL(10,2),
    airport_fee DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    trip_duration_minutes DECIMAL(10,1)
);