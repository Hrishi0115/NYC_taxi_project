CREATE OR REPLACE TABLE ADF_TEST.ADF_PRE_SILVER.PRE_YELLOW
AS 
SELECT
    $1:DOLocationID::int as DOLocationID,
    $1:PULocationID::int as PULocationID,
    $1:RatecodeID::int as RatecodeID,
    $1:VendorID::int as VendorID,
    $1:extra::float as extra,
    $1:fare_amount::float as fare_amount,
    $1:improvement_surcharge::float as improvement_surcharge,
    $1:mta_tax::float as mta_tax,
    $1:passenger_count::int as passenger_count,
    $1:payment_type::int as payment_type,
    $1:store_and_fwd_flag::string(10) as store_and_fwd_flag,
    $1:tip_amount::float as tip_amount,
    $1:tolls_amount::float as tolls_amount,
    $1:total_amount::float as total_amount,
    $1:tpep_dropoff_datetime::string(50) as tpep_dropoff_datetime,
    $1:tpep_pickup_datetime::string(50) as tpep_pickup_datetime,
    $1:trip_distance::float as trip_distance,
    $1:congestion_surchage::float as congestion_surcharge,
    $1:airport_fee::float as airport_fee,
FROM ADF_TEST.ADF_LANDING.YELLOW_IN;
;

CREATE OR REPLACE TABLE ADF_TEST.ADF_SILVER.YELLOW AS
SELECT
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,
    CASE WHEN dolocationid NOT BETWEEN 1 AND 265 THEN 264 ELSE dolocationid END AS dolocationid,
    CASE WHEN pulocationid NOT BETWEEN 1 AND 265 THEN 264 ELSE pulocationid END AS pulocationid,
    CASE WHEN ratecodeid NOT BETWEEN 1 AND 6 THEN 7 ELSE ratecodeid END AS ratecodeid,
    CASE WHEN vendorid NOT BETWEEN 1 AND 2 THEN 3 ELSE vendorid END AS vendorid,
    CASE WHEN extra NOT IN (0, 0.5, 1, 4.5, 2.75, -0.5, -1, -2.75, -4.5) THEN NULL WHEN extra < 0 THEN extra * -1 ELSE extra END AS extra,
    CASE WHEN fare_amount > 500 OR fare_amount < -500 THEN NULL WHEN fare_amount BETWEEN -500 AND 0 THEN fare_amount * -1 ELSE fare_amount END AS fare_amount,
    CASE WHEN improvement_surcharge NOT IN (-0.3, 0, 0.3) THEN NULL WHEN improvement_surcharge = -0.3 THEN improvement_surcharge * -1 ELSE improvement_surcharge END AS improvement_surcharge,
    CASE WHEN mta_tax NOT IN (-0.5, 0, 0.5) THEN NULL WHEN mta_tax = -0.5 THEN mta_tax * -1 ELSE mta_tax END AS mta_tax,
    CASE WHEN passenger_count NOT BETWEEN 0 AND 6 THEN NULL ELSE passenger_count END AS passenger_count,
    CASE WHEN payment_type NOT BETWEEN 1 AND 6 THEN 5 ELSE payment_type END AS payment_type,
    CASE WHEN UPPER(store_and_fwd_flag) NOT IN ('Y', 'N') THEN 'U' ELSE UPPER(store_and_fwd_flag) END AS store_and_fwd_flag,
    tip_amount,
    CASE WHEN ABS(tolls_amount) > 120 THEN NULL ELSE ABS(tolls_amount) END AS tolls_amount,
    CASE WHEN YEAR(TO_DATE(tpep_dropoff_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(tpep_dropoff_datetime) ELSE NULL END AS tpep_dropoff_date,
    TO_TIME(tpep_dropoff_datetime) AS tpep_dropoff_time,
    CASE WHEN YEAR(TO_DATE(tpep_pickup_datetime)) BETWEEN 2018 AND 2024 THEN TO_DATE(tpep_pickup_datetime) ELSE NULL END AS tpep_pickup_date,
    TO_TIME(tpep_pickup_datetime) AS tpep_pickup_time,
    CASE WHEN ABS(trip_distance) > 200 THEN NULL ELSE ABS(trip_distance) END AS trip_distance,
    CASE WHEN congestion_surcharge > 120 THEN NULL ELSE congestion_surcharge END AS congestion_surcharge,
    CASE WHEN ABS(airport_fee) NOT IN (0, 1.25) THEN NULL ELSE ABS(airport_fee) END AS airport_fee,
    fare_amount + COALESCE(extra, 0) + COALESCE(improvement_surcharge, 0) + COALESCE(mta_tax, 0) + COALESCE(tip_amount, 0) + COALESCE(tolls_amount, 0) + COALESCE(congestion_surcharge, 0) + COALESCE(airport_fee, 0) AS total_amount
FROM
    ADF_TEST.ADF_PRE_SILVER.PRE_YELLOW;


SELECT * FROM ADF_TEST.ADF_SILVER.YELLOW order by tpep_pickup_date desc LIMIT 5;