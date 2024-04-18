-- setup
USE ROLE accountadmin;
USE DATABASE bronze_layer;
USE SCHEMA json;

-- azure stage for triathlon azure blob using SAS token
CREATE OR REPLACE STAGE nyc_taxi.bronze.green_from_2018_in.json.all_green_azure_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/green/'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;

-- inspect inside stage (change end of url to see different files)
list @bronze_layer.json.all_green_azure_stage;

-- -- parquet file format 
create or replace FILE FORMAT bronze_layer.json.parquet_taxis_green
TYPE = PARQUET
;

-- -- can now see inside file on azure blob
-- SELECT $1
-- from @all_green_azure_stage
-- (file_format => parquet_taxis, pattern => '.*green_tripdata_2015-1.*')
-- LIMIT 10;

-- -- create empty table to load parquet file into
CREATE OR REPLACE TABLE bronze_layer.json.green_from_2018_in (taxi_col VARIANT);

-- -- copy staged data into snowflake table
COPY INTO bronze_layer.json.green_from_2018_in
FROM @bronze_layer.json.all_green_azure_stage
file_format = parquet_taxis_green
pattern => '.*green_tripdata_2018.*';

-- -- inspect inserted data
-- SELECT COUNT(*) FROM bronze_layer.json.green_from_2018_in;
-- SELECT * FROM bronze_layer.json.green_from_2018_in LIMIT 5;
