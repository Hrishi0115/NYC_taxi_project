
-- checking number of rows

-- fhv
SELECT COUNT(*) FROM silver_layer.test.fhv; -- 260,874,753
SELECT COUNT(*) 
FROM GOLD_LEVEL.PUBLIC.FHV_TRIP_FACT_TABLE
WHERE hvfhs_license_number IS NULL; -- 260,874,753

-- fhv hv
SELECT COUNT(*) FROM silver_layer.test.fhvhv; -- 60,000,305
SELECT COUNT(*) 
FROM GOLD_LEVEL.PUBLIC.FHV_TRIP_FACT_TABLE
WHERE hvfhs_license_number IS NOT NULL; -- 60,000,305

