
SELECT
    COUNT(*) AS rows_in_fact_table,
    (SELECT COUNT(*) FROM nyc_taxi.silver.yellow) AS rows_in_silver_yellow,
    (SELECT COUNT(*) FROM nyc_taxi.silver.green) AS rows_in_silver_green,
    COUNT(*) - ((SELECT COUNT(*) FROM nyc_taxi.silver.yellow) + (SELECT COUNT(*) FROM nyc_taxi.silver.green)) AS lost_rows_between_silver_and_gold,
FROM nyc_taxi.gold.fact_taxi_trip;