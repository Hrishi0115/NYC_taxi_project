-- Setup
USE WAREHOUSE NETT_WH;
USE DATABASE silver_layer;
USE SCHEMA test;
 
-- source table columns:
SHOW COLUMNS IN bronze_layer.flattened.green_flat;

WITH test_silver_cte AS (
SELECT
        CASE
        WHEN dolocationid < 1 or dolocationid > 265 THEN 264
        ELSE dolocationid END AS
    dolocationid,
        CASE
        WHEN pulocationid < 1 OR pulocationid > 265 THEN 264
        ELSE pulocationid END AS
    pulocationid,
        CASE
        WHEN ratecodeid < 1 OR ratecodeid > 6 THEN 7 -- SET 7 as UKNOWN FOR RATECODE ID IN DIMENSION TABLE.
        WHEN ratecodeid IS NULL THEN 7
        ELSE ratecodeid END AS
    ratecodeid,
        CASE
        WHEN vendorid < 1 OR vendorid > 2 THEN 3 -- SET 3 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE. 
        WHEN vendorid IS NULL Then 3
        ELSE vendorid END AS
    vendorid,
        CASE 
        WHEN extra NOT IN (0, 0.5, 1, 4.5, 2.75, -0.5, -1, -2.75, -4.75) THEN NULL
        WHEN extra < 0 THEN extra*-1
        ELSE extra END AS
    extra,
        CASE
        WHEN fare_amount > 500 or fare_amount < -500 THEN NULL
        WHEN fare_amount BETWEEN -500 AND 0 THEN fare_amount*-1
        ELSE fare_amount END AS
    fare_amount,
        CASE 
        WHEN improvement_surcharge NOT IN (-0.3, 0, 0.3) THEN NULL
        WHEN improvement_surcharge = -0.3 THEN improvement_surcharge*-1
        ELSE improvement_surcharge END AS
    improvement_surcharge,
        CASE
        WHEN MTA_TAX NOT IN (-0.5, 0, 0.5) THEN NULL
        WHEN MTA_TAX = -0.5 THEN MTA_TAX*-1
        ELSE MTA_TAX END AS
    MTA_TAX,
        CASE
        WHEN passenger_count < 0 OR passenger_count > 6 THEN NULL
        ELSE passenger_count END AS 
    passenger_count,
        CASE 
        WHEN payment_type < 1 OR payment_type > 6 THEN 5
        WHEN payment_type IS NULL THEN 5
        ELSE payment_type END AS
    payment_type

    FROM bronze_layer.flattened.green_flat
)

SELECT
    -- MAX(dolocationid),
    -- MIN(dolocationid),
    -- MAX(pulocationid),
    -- MIN(pulocationid),
    -- MAX(extra),
    -- MIN(extra),
    -- MAX(fare_amount),
    -- MIN(fare_amount),
    -- MAX(improvement_surcharge),
    -- MIN(improvement_surcharge)
    DISTINCT payment_type
FROM test_silver_cte;


    


