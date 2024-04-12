-- FLATTEN fhv DATA

-- setup
use role accountadmin;
use warehouse cecily_big_wh;
USE DATABASE bronze_layer;


-- all fhv data
SELECT * FROM bronze_layer.json.fhv_pre_2019_in LIMIT 5;


-- flatten data using select
SELECT
  $1:dispatching_base_num::string as dispatching_base_num,
  $1:dropOff_datetime::string as dropOff_datetime,
  $1:pickup_datetime::string as pickup_datetime,
  $1:DOlocationID::int as DOLocationID,
  $1:PUlocationID::int as PULocationID,
  $1:SR_Flag::int AS SR_flag
FROM bronze_layer.json.fhv_pre_2019_in
LIMIT 50;


-- create table to copy into
use schema flattened;
CREATE OR REPLACE TABLE flattened.fhv_pre_2019_flat (
  dispatching_base_num string,
  dropOff_datetime string,
  pickup_datetime string,
  DOlocationID int,
  PUlocationID int,
  SR_Flag int
);

-- copy unflattened data into table we've just created
INSERT INTO flattened.fhv_pre_2019_flat
SELECT
  $1:dispatching_base_num::string as dispatching_base_num,
  $1:dropOff_datetime::string as dropOff_datetime,
  $1:pickup_datetime::string as pickup_datetime,
  $1:DOlocationID::int as DOLocationID,
  $1:PUlocationID::int as PULocationID,
  $1:SR_Flag::int AS SR_flag
FROM bronze_layer.json.fhv_pre_2019_in
;

SELECT * FROM flattened.fhv_pre_2019_flat LIMIT 5;

-- check all rows copied

-- # rows in unflattened table
SELECT COUNT(*) FROM bronze_layer.json.fhv_pre_2019_in;
-- 72,093,092

-- # rows in flattened table
SELECT COUNT(*) FROM flattened.fhv_pre_2019_flat;
-- 72,093,092