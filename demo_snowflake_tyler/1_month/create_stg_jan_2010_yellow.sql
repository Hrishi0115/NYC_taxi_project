-- Setup
USE WAREHOUSE --your wh;
USE DATABASE --your db;
USE SCHEMA --your schema;

-- azure stage for triathlon azure blob using SAS token
CREATE OR REPLACE STAGE my_azure_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/yellow/yellow_tripdata_2010-01'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;

-- inspect inside stage (change end of url to see different files)
list @my_azure_stage;

-- parquet file format 
create or replace FILE FORMAT parquet_taxis
TYPE = PARQUET
;

-- -- can now see inside file on azure blob
-- SELECT $1
-- from @my_azure_stage
-- (file_format => parquet_taxis)
-- LIMIT 10;

-- create empty table to load json into
CREATE OR REPLACE TABLE yellow_taxi_1month_in (taxi_col VARIANT);

-- copy staged data into snowflake table
COPY INTO yellow_taxi_1month_in
FROM @my_azure_stage
file_format = parquet_taxis;

-- inspect inserted data
SELECT * FROM yellow_taxi_1month_in LIMIT 10;

