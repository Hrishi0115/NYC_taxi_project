-- FLATTEN_fhv DATA

-- setup
use role accountadmin;
use warehouse cecily_big_wh;
USE DATABASE bronze_layer;
USE SCHEMA public;

-- all fhv data
SELECT * FROM cecily.public.fhv_all_pre2019_data_taxi_in LIMIT 500;

-- flatten data in select
SELECT
  $1:dispatching_base_num::string as dispatching_base_num,
  $1:dropOff_datetime::string as dropOff_datetime,
  $1:pickup_datetime::string as pickup_datetime,
  $1:DOlocationID::int as DOLocationID,
  $1:PUlocationID::int as PULocationID,
  $1:SR_Flag::int AS SR_flag
FROM public.fhv_all_pre2019_data_taxi_in
LIMIT 50;

-- create view of flattened data
CREATE OR REPLACE VIEW flattened_fhv_pre2019_data AS
SELECT
  $1:dispatching_base_num::string as dispatching_base_num,
  $1:dropOff_datetime::string as dropOff_datetime,
  $1:pickup_datetime::string as pickup_datetime,
  $1:DOlocationID::int as DOLocationID,
  $1:PUlocationID::int as PULocationID,
  $1:SR_Flag::int AS SR_flag
FROM public.fhv_all_pre2019_data_taxi_in
;

-- -- select from view
SELECT * FROM flattened_fhv_pre2019_data;


-- -- create table to copy into
CREATE OR REPLACE TABLE fhv_pre2019_flat_data (
  dispatching_base_num string,
  dropOff_datetime string,
  pickup_datetime string,
  DOlocationID int,
  PUlocationID int,
  SR_Flag int
);

-- -- copy unflattened data into table we've just created
INSERT INTO fhv_pre2019_flat_data
SELECT
  $1:dispatching_base_num::string as dispatching_base_num,
  $1:dropOff_datetime::string as dropOff_datetime,
  $1:pickup_datetime::string as pickup_datetime,
  $1:DOlocationID::int as DOLocationID,
  $1:PUlocationID::int as PULocationID,
  $1:SR_Flag::int AS SR_flag
FROM public.fhv_all_pre2019_data_taxi_in
;

SELECT * FROM fhv_pre2019_flat_data LIMIT 5;

-- -- check all rows copied

-- -- # rows in unflattened table
SELECT COUNT(*) FROM public.fhv_all_pre2019_data_taxi_in;
-- 648,686,926

-- -- # rows in flattened table
SELECT COUNT(*) FROM fhv_pre2019_flat_data;
-- 648,686,926