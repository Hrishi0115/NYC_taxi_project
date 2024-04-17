-- azure stage for triathlon azure blob using SAS token
CREATE OR REPLACE STAGE all_fhv_azure_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/fhv/'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;

-- parquet file format 
create or replace FILE FORMAT parquet_taxis
TYPE = PARQUET
;

-- create empty table to load json into
CREATE OR REPLACE TABLE fhv_from_2018_in (taxi_col VARIANT);

-- copy staged data into snowflake table
COPY INTO fhv_from_2018_in
FROM @all_fhv_azure_stage
file_format = parquet_taxis;
