create or replace table gold.base_dim
(
hv_license_number VARCHAR(15)
,base_num VARCHAR(15) PRIMARY KEY
,base_name varchar(50)
);
 
create or replace stage gold.base_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/base_number_table'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;
 
list @base_stage;
 
create or replace FILE FORMAT csv_zone
TYPE = csv
FIELD_OPTIONALLY_ENCLOSED_BY = '"';
 
-- check insert
-- SELECT $1,$2,$3,$4
-- from @base_stage
-- (file_format => csv_zone)
-- LIMIT 10;