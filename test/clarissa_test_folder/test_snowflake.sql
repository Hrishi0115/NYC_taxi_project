use role accountadmin;
use warehouse nyc_test_data;

use clarissa;

use schema public;

-- step 1: creating stage
CREATE OR REPLACE STAGE my_azure_stage

url = 'azure://triathlonnyc.blob.core.windows.net/output/yellow/yellow_tripdata_2018-01'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;

list @my_azure_stage;

-- create a file format
CREATE OR REPLACE FILE FORMAT parquet_format
    type = parquet
;

-- select all files from stage
SELECT *
from @my_azure_stage
(file_format => parquet_format);

-- 

create or replace table taxi_data(v variant);

copy into taxi_data
from @nyc_weather
file_format = (type=parquet_format);
