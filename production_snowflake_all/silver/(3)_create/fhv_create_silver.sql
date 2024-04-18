-- CREATE SILVER FHV TABLE

use database nyc_taxi;
use schema silver;
CREATE OR REPLACE TABLE silver.fhv(
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
