
-- list azure stage
list @bronze_layer.json.yellow_2018_onwards_azure_stage;


-- compare staged data rows to 2018 copied bronze table. should be 0 in row difference
WITH azure_staged_data AS (
SELECT COUNT($1) AS cnt
from @bronze_layer.json.yellow_2018_onwards_azure_stage
(file_format => bronze_layer.json.parquet_taxis_yellow, pattern => '.*yellow_tripdata_2018.*')
)
SELECT cnt - (SELECT COUNT(*) FROM bronze_layer.json.yellow_from_2018_in) AS lost_rows
FROM azure_staged_data
;