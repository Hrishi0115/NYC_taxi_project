-- Setup
USE WAREHOUSE --your wh (XL recommended for this job);
USE DATABASE -- your db;
USE SCHEMA -- your schema;

-- azure stage for triathlon azure blob using SAS token
CREATE OR REPLACE STAGE all_yellow_azure_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/yellow/'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;

-- inspect inside stage (change end of url to see different files)
list @all_yellow_azure_stage;

-- parquet file format 
create or replace FILE FORMAT parquet_taxis
TYPE = PARQUET
;

-- -- can now see inside file on azure blob
-- SELECT $1
-- from @all_yellow_azure_stage
-- (file_format => parquet_taxis, pattern => '.*yellow_tripdata_2009-1.*')
-- LIMIT 10;

-- create empty table to load json into
CREATE OR REPLACE TABLE yellow_all_pre2019_data_taxi_in (taxi_col VARIANT);

-- copy staged data into snowflake table
COPY INTO yellow_all_pre2019_data_taxi_in
FROM @all_yellow_azure_stage
file_format = parquet_taxis;

-- inspect inserted data
SELECT COUNT(*) FROM yellow_all_pre2019_data_taxi_in;

-- SELECT COUNT(*) FROM tyler.testing.yellow_taxi_1month_in;
