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
  sr_flag int
);

-- insert into
INSERT INTO silver_layer.test.fhv(dispatching_base_number,
    dropoff_date,
    dropoff_time,
    pickup_date,
    pickup_time,
    DOlocationID,
    PUlocationID,
    sr_flag)
SELECT
    upper(DISPATCHING_BASE_NUM),
    CASE WHEN year(to_date(dropoff_datetime)) > 2017 THEN to_date(dropoff_datetime)
    ELSE NULL END AS dropoff_date,
    to_time(dropoff_datetime),
    CASE WHEN year(to_date(pickup_datetime)) > 2017 THEN to_date(pickup_datetime)
    ELSE NULL END AS pickusorrp_date,
    to_time(pickup_datetime),
    CASE WHEN dolocationid = 0 THEN 264 
    WHEN dolocationid IS NULL THEN 264
    ELSE dolocationid 
    END AS DOlocationid, 
    CASE WHEN pulocationid = 0 THEN 264 
    WHEN pulocationid IS NULL THEN 264
    ELSE pulocationid 
    END AS PUlocationid,
    CASE WHEN sr_flag IS NULL THEN 0
    WHEN sr_flag = 1 THEN 1
    ELSE 2
    END AS sr_flag
FROM bronze_layer.flattened.fhv_flat
;
