-- FHV CREATE AND INSERT BRONZE FHV FLATTENED TABLE

CREATE OR REPLACE TABLE bronze_layer.flattened.fhv_flat AS
SELECT
  $1:dispatching_base_num::string as dispatching_base_num,
  $1:dropOff_datetime::string as dropOff_datetime,
  $1:pickup_datetime::string as pickup_datetime,
  $1:DOlocationID::int as DOLocationID,
  $1:PUlocationID::int as PULocationID,
  $1:SR_Flag::int AS SR_flag
FROM public.fhv_from_2018_in
;