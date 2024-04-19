-- FHV CREATE AND INSERT BRONZE FHV FLATTENED TABLE
use warehouse cecily_xs;
USE DATABASE nyc_taxi;
USE SCHEMA senior_bronze;

CREATE OR REPLACE TABLE nyc_taxi.senior_bronze.fhv AS
SELECT
  $1:dispatching_base_num::string as dispatching_base_num,
  $1:dropOff_datetime::string as dropOff_datetime,
  $1:pickup_datetime::string as pickup_datetime,
  $1:DOlocationID::int as DOLocationID,
  $1:PUlocationID::int as PULocationID,
  $1:SR_Flag::int AS SR_flag
FROM nyc_taxi.bronze.fhv
;
