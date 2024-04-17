-- FHV CREATE BRONZE FLATTENED TABLE

CREATE OR REPLACE TABLE fhv_pre2019_flat_data (
  dispatching_base_num string,
  dropOff_datetime string,
  pickup_datetime string,
  DOlocationID int,
  PUlocationID int,
  SR_Flag int
);