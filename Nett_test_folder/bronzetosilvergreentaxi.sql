-- Setup
USE WAREHOUSE NETT_WH;
USE DATABASE silver_layer;
USE SCHEMA test;
 
-- source table columns:
SHOW COLUMNS IN bronze_layer.flattened.green_flat;


SELECT
        CASE
        WHEN dolocationid < 1 or dolocationid > 265 THEN 264
        ELSE dolocationid END AS
    dolocationid
        CASE
        WHEN pulocationid < 1 OR pulocationid > 265 THEN 264
        ELSE pulocationid END AS
    pulocationid,
        CASE
        WHEN ratecodeid < 1 OR ratecodeid > 6 THEN 7 -- SET 7 as UKNOWN FOR RATECODE ID IN DIMENSION TABLE.
        ELSE ratecodeid END AS
    ratecodeid,
        CASE
        WHEN vendor < 1 OR vendorid > 2 THEN 3 -- SET 3 as UNKNOWN FOR RATECODE ID IN DIMENSION TABLE. 
        ELSE vendorid END AS
    vendorid,
        CASE 
        WHEN extra NOT IN (0, 0.5, 1, 4.5, 2.75, -0.5, -1, -2.75, -4.75) THEN NULLWHEN extra < 0 THEN extra*-1
        ELSE extra END AS
    extra,

    FROM bronze_layer.flattened.green_flat
    LIMIT 10;


