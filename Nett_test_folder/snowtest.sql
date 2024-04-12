USE WAREHOUSE NETT_WH;
USE DATABASE bronze_layer;
USE SCHEMA json;

SELECT* FROM json.yellow_from_2018_in LIMIT 10;

-- Setup
USE WAREHOUSE nett_wh;
USE DATABASE bronze_layer;
USE SCHEMA flattened;
 
 
 
-- count of columns
SELECT COUNT(*) FROM bronze_layer.flattened.green_flat;
 
 
-- look at the columns in table to inspect
SHOW COLUMNS IN TABLE green_flat;
 
 
------ 1. inspect values that should have discrete values in low cardinality
 
-- 1a: vendor id (data dict shows only 1 and 2)
-- notes:
--    output shows 1, 2, and 5
--    where is vendor id 3 &4 ?
-- Could be an error of adding 3 individual vendor ID's being 2 + 2 + 1 = 5, otherwise just an error. 
--Why would it be repeated 26 times though aside from other errors?

SELECT
    vendorid,
    COUNT(*)
FROM green_flat
GROUP BY vendorid
ORDER BY COUNT(*) DESC;

--1b: RateCodeID (data dict shows only 1 through to 6)
--notes:
-- There are 100k rows with RateCodeID:Null
-- There are 67 rows with RateCodeID:99
--Both listed data above were incorrectly assigned at the end of the trip so this data is invalid; thus, can be dropped.

SELECT
RateCodeID, 
COUNT(*)
FROM green_flat
GROUP BY RATECODEID
ORDER BY COUNT(*) DESC;

--1c: Store_and_fwd_flag (data dict shows only Yand N in reference to storing trip data due to loss of connection to vendor)
--notes:
-- There are 100k rows with Store_and_fwd_flag:Null --> Data is not valuable and can be dropped.

SELECT
Store_and_fwd_flag, 
COUNT(*)
FROM green_flat
GROUP BY Store_and_fwd_flag
ORDER BY COUNT(*) DESC;

--1d: Payment_type (data dict shows only 1 through to 6)
--notes:
-- There are 100k rows with Payment_type:Null --> Payment type may not have been recorded, results are still valuable. This data could have been put down as uknown too so could be replaced as Payment_type:5 
-- No data is shown for Payment_type 6, so maybe the Payment_type:Null could be Payment_type:6.

SELECT
Payment_type, 
COUNT(*)
FROM green_flat
GROUP BY Payment_type
ORDER BY COUNT(*) DESC;

--1e: Trip_type (data dict shows only 1 or 2)
--notes:
-- There are 100k rows with Payment_type:Null --> Trip_type may not have been recorded, results are still valuable and should not be dropped.
--The Null trip types are of the lowest occurance.
-- There are 35 times more trips taken by street-hail (1) than Dispatch (2). 

SELECT
Trip_type, 
COUNT(*)
FROM green_flat
GROUP BY Trip_type
ORDER BY COUNT(*) DESC;

SELECT
lpep_pickup_datetime,
COUNT(*) AS null_count
FROM green_flat
WHERE lpep_pickup_datetime IS NULL;

SELECT 
lpep_pickup_datetime
FROM green_flat
LIMIT 1;

SELECT
lpep_pickup_datetime,
to_timestamp(LPEP_PICKUP_DATETIME),
COUNT(*) AS not_2018
FROM green_flat
WHERE lpep_pickup_datetime LIKE %2018% 