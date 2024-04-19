create or replace table zone_dim
(
zone_id INT PRIMARY KEY
,borough VARCHAR(75)
,zone_name VARCHAR (75)
,service_zone VARCHAR (15)
);
 
create or replace stage zone_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/taxi_zone_lookup'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;
list @zone_stage;
 
create or replace FILE FORMAT csv_zone
TYPE = csv;
 
-- SELECT $1,$2,$3,$4,$5
-- from @zone_stage
-- (file_format => csv_zone)
-- LIMIT 10;
