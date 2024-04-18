-- setup
USE ROLE accountadmin;
USE DATABASE nyc_taxi;
USE SCHEMA bronze;

-- azure stage for triathlon azure blob using SAS token
-- CREATE OR REPLACE STAGE all_fhvhv_azure_stage
-- url = 'azure://triathlonnyc.blob.core.windows.net/output/fhvhv/'
-- credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
-- ;

-- inspect inside stage (change end of url to see different files)
-- list @all_fhvhv_azure_stage;

-- parquet file format 
-- create or replace FILE FORMAT parquet_taxis
-- TYPE = PARQUET
-- ;

-- create empty table to load parquet file into
CREATE OR REPLACE TABLE fhvhv (taxi_col VARIANT);

-- copy staged data into snowflake table
COPY INTO fhvhv
FROM @fhvhv_stage
file_format = parquet_taxis;

-- inspect inserted data
-- SELECT COUNT(*) FROM fhvhv
-- SELECT * FROM fhvhv LIMIT 5;
