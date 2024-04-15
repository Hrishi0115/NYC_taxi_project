use role accountadmin;
create or replace database cecily;
use cecily;
use schema public;
use warehouse cecily_wh;

-- create table called geo_json with 1 column of type variant
create or replace table jan09_parquet (v variant);

-- creating public cloud stage
CREATE OR REPLACE STAGE jan_18_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/yellow/yellow_tripdata_2018-01.parquet'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;
-- create a file format
CREATE OR REPLACE FILE FORMAT parquet_format
    type = parquet
;

-- Select directly from the stage
SELECT
$1
FROM  @jan_09_stage
(file_format=>parquet_format)
LIMIT 5
;

--automation

-- check loading 1 files into one table - does it work

-- add colour identifier table