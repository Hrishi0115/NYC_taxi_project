use warehouse cecily_xs;
-- check same number of rows in silver and gold
SELECT COUNT(*) FROM silver_layer.test.fhv;
SELECT COUNT(*) FROM gold_level.public.fhv_trip_fact_table;
SELECT * FROM gold_level.public.fhv_trip_fact_table LIMIT 1;

