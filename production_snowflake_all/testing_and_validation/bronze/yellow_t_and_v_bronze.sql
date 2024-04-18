
-- list azure stage
list @nyc_taxi.bronze.yellow_2018_onwards_azure_stage;


-- compare staged data rows to 2018 copied bronze table. should be 0 in row difference
WITH azure_staged_data AS (
SELECT COUNT($1) AS cnt
from @nyc_taxi.bronze.yellow_2018_onwards_azure_stage
(file_format => nyc_taxi.bronze.parquet_taxis_yellow, pattern => '.*yellow_tripdata_2018.*')
)
SELECT cnt - (SELECT COUNT(*) FROM nyc_taxi.bronze.yellow) AS lost_rows
FROM azure_staged_data
;
