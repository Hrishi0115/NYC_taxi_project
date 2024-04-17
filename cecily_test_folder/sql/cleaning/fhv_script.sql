-- FHV
-- setup
use warehouse;
use database;
use schema;

-- create table
CREATE OR REPLACE TABLE silver_layer.test.fhv (
  id INT AUTOINCREMENT PRIMARY KEY,
  dispatching_base_number string,
  dropoff_date date,
  dropoff_time time,
  pickup_date date,
  pickup_time time,
  DOlocationID int,
  PUlocationID int,
  sr_flag int,
  trip_duration_minutes float
);

-- insert into
INSERT INTO silver_layer.test.fhv (dispatching_base_number,
    dropoff_date,
    dropoff_time,
    pickup_date,
    pickup_time,
    DOlocationID,
    PUlocationID,
    sr_flag,
    trip_duration_minutes)
SELECT
    upper(DISPATCHING_BASE_NUM),
    CASE WHEN year(to_date(dropoff_datetime)) BETWEEN 2018 AND 2024 THEN to_date(dropoff_datetime)
    ELSE NULL END AS dropoff_date,
    to_time(dropoff_datetime),
    CASE WHEN year(to_date(pickup_datetime)) BETWEEN 2018 AND 2024 THEN to_date(pickup_datetime)
    ELSE NULL END AS pickup_date,
    to_time(pickup_datetime),
    CASE WHEN dolocationid BETWEEN 1 AND 265 THEN dolocationid ELSE 264 END AS dolocationid, 
    CASE WHEN pulocationid BETWEEN 1 AND 265 THEN pulocationid ELSE 264 END AS pulocationid, 
    CASE WHEN sr_flag IS NULL THEN 0 WHEN sr_flag = 1 THEN 1 ELSE 2 END AS sr_flag,
    CASE WHEN TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60 < 0 AND ROUND((TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60) + 1440 , 1) > 480 THEN NULL
        WHEN TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60 < 0 THEN ROUND((TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60) + 1440 , 1)
        WHEN TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60 > 480 THEN NULL
        ELSE ROUND((TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60), 1) END AS trip_duration_minutes
FROM bronze_layer.flattened.fhv_flat
;

-- fhv hv data starts from 2019 feb, insert some data into silver, then into gold for BI testing





-- how many rows in fhv bronze --> 260,874,753
SELECT COUNT(*) FROM bronze_layer.flattened.fhv_flat;
--how many rows loaded into fhv silver --> 260,874,753
SELECT COUNT(*) FROM silver_layer.test.fhv;
-- how many rows loaded into gold --> 260,874,753
SELECT COUNT(*) FROM GOLD_LEVEL.PUBLIC.FHV_TRIP_FACT_TABLE;
-- look at silver data
SELECT * FROM silver_layer.test.fhv LIMIT 3;
-- what year
SELECT year(pickup_date) FROM silver_layer.test.fhv 
GROUP BY year(pickup_date);

-- test
WITH silver_cte AS(
    SELECT
    upper(DISPATCHING_BASE_NUM),
    CASE WHEN year(to_date(dropoff_datetime)) BETWEEN 2018 AND 2024 THEN to_date(dropoff_datetime)
    ELSE NULL END AS dropoff_date,
    to_time(dropoff_datetime),
    CASE WHEN year(to_date(pickup_datetime)) BETWEEN 2018 AND 2024 THEN to_date(pickup_datetime)
    ELSE NULL END AS pickup_date,
    to_time(pickup_datetime),
    CASE WHEN dolocationid BETWEEN 1 AND 265 THEN dolocationid ELSE 264 END AS dolocationid, 
    CASE WHEN pulocationid BETWEEN 1 AND 265 THEN pulocationid ELSE 264 END AS pulocationid, 
    CASE WHEN sr_flag IS NULL THEN 0 WHEN sr_flag = 1 THEN 1 ELSE 2 END AS sr_flag,
    CASE
        WHEN TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60 < 0 AND ROUND((TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60) + 1440 , 1) > 480
            THEN NULL
        WHEN TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60 < 0
            THEN ROUND((TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60) + 1440 , 1)
        WHEN TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60 > 480
            THEN NULL
        ELSE ROUND((TIMEDIFF(second, to_time(pickup_datetime), to_time(dropoff_datetime)) / 60), 1) END AS trip_duration_minutes
    FROM bronze_layer.flattened.fhv_flat
)
SELECT sr_flag, count(*)
FROM silver_cte
GROUP BY sr_flag
;
