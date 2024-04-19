USE WAREHOUSE tyler_big_wh;

-- azure stage for triathlon azure blob using SAS token
CREATE OR REPLACE STAGE nyc_taxi.bronze.yellow_2018_onwards_azure_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/yellow/'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;

-- inspect inside stage (change end of url to see different files)
list @nyc_taxi.bronze.yellow_2018_onwards_azure_stage;

-- parquet file format 
create or replace FILE FORMAT nyc_taxi.bronze.parquet_taxis_yellow
TYPE = PARQUET
;

-- -- can now see inside file on azure blob
-- -- 102871387 rows 
-- SELECT $1
-- from @yellow_2018_onwards_azure_stage
-- (file_format => parquet_taxis_yellow, pattern => '.*yellow_tripdata_2018.*')
-- LIMIT 10;

-- create bronze json table
CREATE OR REPLACE TABLE nyc_taxi.bronze.yellow (taxi_col VARIANT);

-- copy staged data into snowflake table
COPY INTO nyc_taxi.bronze.yellow
FROM @nyc_taxi.bronze.yellow_2018_onwards_azure_stage
file_format = nyc_taxi.bronze.parquet_taxis_yellow
pattern = '.*yellow_tripdata_2018.*';

-- inspect inserted data
SELECT COUNT(*) FROM nyc_taxi.bronze.yellow;

