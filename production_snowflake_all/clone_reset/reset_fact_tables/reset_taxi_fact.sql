-- reset fact table to 2018 clone

-- drop fact table
DROP TABLE IF EXISTS nyc_taxi.gold.fact_taxi_trip;

-- create table as clone
CREATE TABLE nyc_taxi.gold.fact_taxi_trip AS 
SELECT * 
FROM clone.gold.FACT_TAXI_TRIP2018
;

-- check taxi fact table has been reset row count of 110568004 (n rows for all 2018)
SELECT COUNT(*) FROM nyc_taxi.gold.fact_taxi_trip; --110568004

