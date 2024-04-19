use warehouse cecily_xs;
use database nyc_taxi;
use role accountadmin;

-- look at gold fact table
SELECT * FROM GOLD.FACT_FHV_TRIP LIMIT 5;

-- checking number of rows

-- silver vs gold
-- fhv
SELECT COUNT(*) FROM silver.fhv; -- 260,874,753
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP
WHERE hvfhs_license_number IS NULL; -- 260,874,753

-- fhv hv
SELECT COUNT(*) FROM silver.fhvhv; -- 211,991,508
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP
WHERE hvfhs_license_number IS NOT NULL; -- 211,991,508

-- sum over metrics to check gold vs gold joined w dimensions
SELECT * FROM gold.base_dim LIMIT 5;

-- base_dim

-- join fact table to base_dim, count rows
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP; 
SELECT COUNT(*)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.base_dim AS dim
ON dim.base_num = fact.dispatching_base_number; 

-- join fact table to base_dim, sum trip_miles column
SELECT SUM(trip_miles) 
FROM GOLD.FACT_FHV_TRIP;
SELECT SUM(trip_miles)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.base_dim AS dim
ON dim.base_num = fact.dispatching_base_number;

-- join fact table to base_dim, sum trip_time column
SELECT SUM(trip_time) 
FROM GOLD.FACT_FHV_TRIP;
SELECT SUM(trip_time)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.base_dim AS dim
ON dim.base_num = fact.dispatching_base_number;

-- join fact table to base_dim, sum base_passenger_fare column
SELECT SUM(base_passenger_fare) 
FROM GOLD.FACT_FHV_TRIP;
SELECT SUM(base_passenger_fare)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.base_dim AS dim
ON dim.base_num = fact.dispatching_base_number;

-- join fact table to base_dim, sum tips column
SELECT SUM(tips) 
FROM GOLD.FACT_FHV_TRIP;
SELECT SUM(tips)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.base_dim AS dim
ON dim.base_num = fact.dispatching_base_number;

-- zone dim
-- join fact table to zone_dim, count rows
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP; 
SELECT COUNT(*)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.zone_dim AS dim
ON dim.zone_id = fact.pu_location_id; 

-- join fact table to zone_dim, sum trip_miles column
SELECT SUM(trip_miles) 
FROM GOLD.FACT_FHV_TRIP;
SELECT SUM(trip_miles)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.zone_dim AS dim
ON dim.zone_id = fact.pu_location_id; 

-- join fact table to zone_dim, sum trip_time column
SELECT SUM(trip_time) 
FROM GOLD.FACT_FHV_TRIP;
SELECT SUM(trip_time)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.zone_dim AS dim
ON dim.zone_id = fact.pu_location_id; 

-- join fact table to zone_dim, sum base_passenger_fare column
SELECT SUM(base_passenger_fare) 
FROM GOLD.FACT_FHV_TRIP;
SELECT SUM(base_passenger_fare)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.zone_dim AS dim
ON dim.zone_id = fact.pu_location_id; 

-- join fact table to zone_dim, sum tips column
SELECT SUM(tips) 
FROM GOLD.FACT_FHV_TRIP;
SELECT SUM(tips)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.zone_dim AS dim
ON dim.zone_id = fact.pu_location_id; 

-- silver vs gold
-- fhv
SELECT COUNT(*) FROM silver.fhv;
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP
WHERE hvfhs_license_number IS NULL;

-- fhv hv
SELECT COUNT(*) FROM silver.fhvhv;
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP
WHERE hvfhs_license_number IS NOT NULL;