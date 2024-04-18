-- reset fact table to 2018 clone

-- drop fact table
DROP TABLE IF EXISTS nyc_taxi.gold.fact_fhv_trip;

-- create table as clone
CREATE TABLE nyc_taxi.gold.fact_fhv_trip AS 
SELECT * 
FROM clone.gold.FACT_FHV_TRIP2018
;
