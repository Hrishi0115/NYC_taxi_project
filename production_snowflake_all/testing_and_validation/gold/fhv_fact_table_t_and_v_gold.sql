use warehouse cecily_xs;
-- checking number of rows

-- silver vs gold
-- fhv
SELECT COUNT(*) FROM silver.fhv; -- 260,874,753
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP
WHERE hvfhs_license_number IS NULL; -- 260,874,753

-- fhv hv
SELECT COUNT(*) FROM silver_layer.test.fhvhv; -- 60,000,305
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

