-- CREATE SILVER FHV TABLE

CREATE OR REPLACE TABLE nyc_taxi.silver.fhv(
  id INT AUTOINCREMENT PRIMARY KEY,
  dispatching_base_number string,
  dropoff_date date,
  dropoff_time time,
  pickup_date date,
  pickup_time time,
  DOlocationID int,
  PUlocationID int,
  sr_flag int,
  trip_time int
);
