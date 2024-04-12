-- cleaning FHV data from bronze --> silver layer

use role accountadmin;
use warehouse cecily_xs;
USE DATABASE bronze_layer;

-- look at data
SELECT * FROM bronze_layer.flattened.fhv_flat LIMIT 5;

-- list of all columns:
-- dispatching base num
-- dropoff_datetime / pickup_datetime
-- dolocationid / pulocationid
-- sr_flag

-- dispatching base num --> need to cast to upper()
SELECT upper(dispatching_base_num)
FROM bronze_layer.flattened.fhv_flat
LIMIT 5
;

-- dolocationid / pulocationid --> change null and 0 entries to 264
SELECT dropoff_datetime, CASE 
    WHEN dolocationid = 0 THEN 264 
    WHEN dolocationid IS NULL THEN 264
    ELSE dolocationid 
    END AS dropofflocationid, CASE 
    WHEN pulocationid = 0 THEN 264 
    WHEN pulocationid IS NULL THEN 264
    ELSE pulocationid 
    END AS pickuplocationid
FROM flattened.fhv_flat
LIMIT 100;

-- check there are only 265
WITH cteloc AS (
SELECT dropoff_datetime, CASE 
    WHEN dolocationid = 0 THEN 264 
    WHEN dolocationid IS NULL THEN 264
    ELSE dolocationid 
    END AS dropofflocationid, CASE 
    WHEN pulocationid = 0 THEN 264 
    WHEN pulocationid IS NULL THEN 264
    ELSE pulocationid 
    END AS pickuplocationid
FROM flattened.fhv_flat
)
SELECT count(distinct dropofflocationid), count(distinct pickuplocationid)
FROM cteloc
;


-- dropoff_datetime / pickup_datetime --> cast to_datetime()
SELECT to_date(dropoff_datetime) as dropoff_datetime
    , to_date(pickup_datetime) as pickup_datetime
FROM flattened.fhv_flat
LIMIT 5
;

-- sr_flag --> change all values > 1 to null
SELECT dropoff_datetime, CASE 
    WHEN sr_flag != 1 THEN NULL 
    ELSE sr_flag 
    END AS sr_flag
FROM flattened.fhv_flat
LIMIT 100;

WITH ctesr AS (
    SELECT dropoff_datetime, CASE 
    WHEN sr_flag != 1 THEN NULL 
    ELSE sr_flag 
    END AS sr_flag
    FROM flattened.fhv_flat
)
SELECT sr_flag, count(*)
FROM ctesr
GROUP BY sr_flag
;
-- null (230 mil)
-- 1 (28 mil)

-- how to join this all together

-- 1. create silver fhv table

CREATE OR REPLACE TABLE silver_layer.fhv (
  dispatching_base_num string,
  dropoff_datetime datetime,
  pickup_datetime datetime,
  DOlocationID int,
  PUlocationID int,
  SR_Flag int
);

-- 2. insert into
INSERT INTO silver_layer.fhv
SELECT
  upper(dispatching_base_num)::string as dispatching_base_num,
  to_date(dropoff_datetime)::datetime as dropoff_datetime,
  to_date(pickup_datetime)::datetime as pickup_datetime,
  CASE  WHEN dolocationid = 0 THEN 264 
        WHEN dolocationid IS NULL THEN 264
        ELSE dolocationid 
        END AS dropoff_locationid::int,
  CASE  WHEN pulocationid = 0 THEN 264 
        WHEN pulocationid IS NULL THEN 264
        ELSE pulocationid 
        END AS pickup_locationid::int,
  CASE  WHEN sr_flag != 1 THEN NULL 
        ELSE sr_flag 
        END AS sr_flag::int
FROM bronze_layer.json.fhv_from_2018_in
;