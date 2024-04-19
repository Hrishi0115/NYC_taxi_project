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
-- dimensions linked to fhv fact table
-- base_dim
-- zone dim

-- base_dim
-- count rows
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP; --606,694,100
SELECT COUNT(*)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.base_dim AS dim
ON dim.base_num = fact.dispatching_base_number; --551,031,560

-- there must be nulls

-- trip_miles column
SELECT SUM(trip_miles) 
FROM GOLD.FACT_FHV_TRIP; -- 16682336
SELECT SUM(trip_miles)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.base_dim AS dim
ON dim.base_num = fact.dispatching_base_number; -- 16682160

SELECT * FROM gold.base_dim LIMIT 3;


-- trip_miles
-- trip_time
-- base_passenger_fare
-- tolls
-- black_car_fund
-- sales_tax
-- congenstion_surcharge
-- airport_fee
-- tips
-- driver_pay




-- check dimensions
-- base_dim
SELECT COUNT(*)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.base_dim AS dim
ON fact.dispatching_base_number = dim.base_num; -- 260,874,753

SELECT COUNT(*) FROM gold.fact_fhv_trip; -- 260,874,753
-- 



SELECT COUNT(*) FROM silver_layer.test.fhv;
SELECT COUNT(*) FROM gold_level.public.fhv_trip_fact_table;
SELECT * FROM gold_level.public.fhv_trip_fact_table LIMIT 1;


-- checking number of rows

-- silver vs gold
-- fhv
SELECT COUNT(*) FROM silver.fhv; -- 260,874,753
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP
WHERE hvfhs_license_number IS NULL; -- 260,874,753

SELECT COUNT(*)
FROM GOLD.FACT_FHV_TRIP; -- 260,874,753
-- fhv hv
SELECT COUNT(*) FROM silver.fhvhv; -- 60,000,305
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP
WHERE hvfhs_license_number IS NOT NULL; -- 60,000,305


-- check dimensions
-- base_dim
SELECT COUNT(*)
FROM GOLD.FACT_FHV_TRIP AS fact
JOIN gold.base_dim AS dim
ON fact.dispatching_base_number = dim.base_num; -- 260,874,753

SELECT COUNT(*) FROM gold.fact_fhv_trip; -- 260,874,753

-- 

SELECT * FROM GOLD.FACT_FHV_TRIP LIMIT 5;

SELECT COUNT(*) FROM silver_layer.test.fhv;
SELECT COUNT(*) FROM gold_level.public.fhv_trip_fact_table;
SELECT * FROM gold_level.public.fhv_trip_fact_table LIMIT 1;

