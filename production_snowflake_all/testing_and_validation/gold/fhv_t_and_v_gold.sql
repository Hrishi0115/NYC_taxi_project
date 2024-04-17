use warehouse cecily_xs;
-- check same number of rows in silver and gold
SELECT COUNT(*) FROM silver_layer.test.fhv;
SELECT COUNT(*) FROM gold_level.public.fhv_trip_fact_table;
SELECT * FROM gold_level.public.fhv_trip_fact_table LIMIT 1;



-- check all non-null dates in silver have been converted to date_id in gold
-- pick_up date
SE
-- dropoff_date
-- request_date
-- onscene_date
