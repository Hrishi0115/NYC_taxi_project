-- table to clone
SELECT COUNT(*) 
FROM GOLD.FACT_FHV_TRIP
WHERE hvfhs_license_number IS NULL; -- 260,874,753

-- clone
CREATE TABLE clone.gold.FACT_FHV_TRIP2018 CLONE nyc_taxi.GOLD.FACT_FHV_TRIP;

-- check clone
SELECT COUNT(*) 
FROM clone.gold.FACT_FHV_TRIP2018 -- 260,874,753
;

