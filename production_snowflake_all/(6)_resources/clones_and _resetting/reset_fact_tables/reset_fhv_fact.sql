-- reset fact table to 2018 clone

-- drop fact table
DROP TABLE IF EXISTS nyc_taxi.gold.fact_fhv_trip;

-- create table as clone
CREATE TABLE nyc_taxi.gold.fact_fhv_trip AS 
SELECT * 
FROM clone.gold.FACT_FHV_TRIP2018
;

-- check fhv table has been reset row count of 260,874,753 (n rows for all 2018)
SELECT COUNT(*) FROM nyc_taxi.gold.fact_fhv_trip; -- 260,874,753

