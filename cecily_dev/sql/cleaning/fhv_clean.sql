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
LIMIT 5;


-- sr_flag --> add value 2 for unknown, change null to 0 

SELECT dropoff_datetime, CASE 
    WHEN sr_flag IS NULL THEN 0
    WHEN sr_flag = 1 THEN 1
    ELSE 2
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

CREATE OR REPLACE TABLE silver_layer.test.fhv (
  id INT AUTOINCREMENT PRIMARY KEY,
  dispatching_base_num string,
  dropoff_datetime datetime,
  pickup_datetime datetime,
  DOlocationID int,
  PUlocationID int,
  sr_flag int
);

-- 2. insert into
INSERT INTO silver_layer.test.fhv(dispatching_base_num,
    dropoff_datetime,
    pickup_datetime,
    DOlocationID,
    PUlocationID,
    sr_flag)
SELECT
    upper(DISPATCHING_BASE_NUM),
    to_timestamp(dropoff_datetime) AS dropoff_datetime,
    to_timestamp(pickup_datetime) AS pickup_datetime,
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

SELECT * FROM silver_layer.test.fhv LIMIT 5;

-- changing non 2018-2019 dates to 2018 
UPDATE silver_layer.test.fhv
SET dropoff_datetime = TIMESTAMPFROMPARTS(2018, MONTH(dropoff_datetime), DAY(dropoff_datetime), HOUR(dropoff_datetime), MINUTE(dropoff_datetime), SECOND(dropoff_datetime))
WHERE YEAR(dropoff_datetime) != 2018 AND YEAR(dropoff_datetime) != 2019;

UPDATE silver_layer.test.fhv
SET pickup_datetime = TIMESTAMPFROMPARTS(2018, MONTH(pickup_datetime), DAY(pickup_datetime), HOUR(pickup_datetime), MINUTE(pickup_datetime), SECOND(pickup_datetime))
WHERE YEAR(pickup_datetime) != 2018 AND YEAR(pickup_datetime) != 2019;


-- get highest occuring year then overwrite each year with this
SELECT year(to_timestamp(dropoff_datetime)) AS dropoff_year, count(*)
FROM bronze_layer.flattened.fhv_flat 
GROUP BY year(to_timestamp(dropoff_datetime))
ORDER BY dropoff_year
;

-- if year not 2018 or 2019 then drop / change to 2018 / null
SELECT CASE 
    WHEN year(to_timestamp(dropoff_datetime)) != 2018 THEN 264 
    WHEN pulocationid IS NULL THEN 264
    ELSE pulocationid 
    END AS PUlocationid
    FROM bronze_layer.flattened.fhv_flat; 


SET current_year = WITH cteyr AS (
    SELECT year(to_timestamp(dropoff_datetime)) AS yr, count(*)
    FROM bronze_layer.flattened.fhv_flat 
    GROUP BY year(to_timestamp(dropoff_datetime))
    ORDER BY count(*) DESC
    LIMIT 1
    )
SELECT yr
FROM cteyr;



WITH cteyr AS (
    SELECT year(to_timestamp(dropoff_datetime)) AS yr, count(*)
    FROM bronze_layer.flattened.fhv_flat 
    GROUP BY year(to_timestamp(dropoff_datetime))
    ORDER BY count(*) DESC
    LIMIT 1
    )
SELECT yr
FROM cteyr;

SELECT current_year;


WITH cteyr AS (
    SELECT year(to_timestamp(dropoff_datetime)) AS yr, count(*)
    FROM bronze_layer.flattened.fhv_flat 
    GROUP BY year(to_timestamp(dropoff_datetime))
    ORDER BY count(*) DESC
    LIMIT 1
    )
SELECT yr
FROM cteyr
;




-- create table as but create identity

-- or create table as
use database silver_layer;
use schema test;
-- CREATE OR REPLACE TABLE silver_layer.test.fhv AS
-- SELECT 
--     IDENTITY(1,1) AS id,
--     upper(DISPATCHING_BASE_NUM) AS dispatching_base_num,
--     CASE WHEN dolocationid = 0 THEN 264 
--     WHEN dolocationid IS NULL THEN 264
--     ELSE dolocationid 
--     END AS dropofflocationid, 
--     CASE WHEN pulocationid = 0 THEN 264 
--     WHEN pulocationid IS NULL THEN 264
--     ELSE pulocationid 
--     END AS pickuplocationid,
--     to_timestamp(dropoff_datetime) AS dropoff_datetime,
--     to_timestamp(pickup_datetime) AS pickup_datetime,
--     CASE WHEN sr_flag IS NULL THEN 0
--     WHEN sr_flag = 1 THEN 1
--     ELSE 2
--     END AS sr_flag
-- FROM bronze_layer.flattened.fhv_flat
-- LIMIT 100
-- ;

SELECT * FROM silver_layer.test.fhv ORDER BY id LIMIT 5;

ALTER TABLE silver_layer.test.fhv
ADD COLUMN id INTEGER AUTOINCREMENT START 1;

