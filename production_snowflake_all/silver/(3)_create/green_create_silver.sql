
DROP TABLE IF EXISTS nyc_taxi.silver.green;

CREATE OR REPLACE TABLE nyc_taxi.silver.green
(
    id INT AUTOINCREMENT PRIMARY KEY,
    dolocationid INT,
    pulocationid INT,
    ratecodeid INT,
    vendorid INT,
    extra DECIMAL(10,2),
    fare_amount DECIMAL(10,2),
    improvement_surcharge DECIMAL(10,2),
    MTA_TAX DECIMAL(10,2),
    passenger_count INT,
    payment_type INT,
    Store_and_fwd_flag STRING(1),
    tip_amount DECIMAL(10,2),
    tolls_amount DECIMAL(10,2),
    lpep_dropoff_date DATE,
    lpep_pickup_date DATE,
    lpep_pickup_time TIME,
    lpep_dropoff_time TIME,
    trip_distance DECIMAL(10,2),
    trip_type VARCHAR(15),
    total_amount DECIMAL(10,2),
    trip_duration_minutes DECIMAL(10,1)
);


