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

-- Possible Action --> Could change any values which are not 1 or 2 into another VendorID: 3 which refers to NULL.

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
--New Action --> Avoid dropping rows and change Nulls to U.

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

--Action--> Put 3 as Unknown and avoid putting NULL. Change NULL to 3, and document it so that we convert this to unknown in the Gold layer.
SELECT
Trip_type, 
COUNT(*)
FROM green_flat
GROUP BY Trip_type
ORDER BY COUNT(*) DESC;

--Checking lpep_pickup_datetime
--
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
--lpep_pickup_datetime,
YEAR(to_timestamp(LPEP_PICKUP_DATETIME)),
COUNT(*)
FROM green_flat
--WHERE YEAR(to_timestamp(LPEP_PICKUP_DATETIME)) != 2018
GROUP BY YEAR(to_timestamp(LPEP_PICKUP_DATETIME))
ORDER BY COUNT (*) DESC;

--lpep_dropoff_datetime,
SELECT
--lpep_pickup_datetime,
YEAR(to_timestamp(LPEP_PICKUP_DATETIME)),
COUNT(*)
FROM green_flat
--WHERE YEAR(to_timestamp(LPEP_PICKUP_DATETIME)) != 2018
GROUP BY YEAR(to_timestamp(LPEP_PICKUP_DATETIME))
ORDER BY COUNT (*) DESC;


SELECT
    extra,
    COUNT(*)
FROM yellow_flat
GROUP BY extra
ORDER BY COUNT(*) DESC
LIMIT 10;


SELECT
    CASE
    WHEN TIP_AMOUNT > 500,
    COUNT(*)
FROM green_flat
GROUP BY TIP_AMOUNT
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 2f: Notes about tolls_amount:
-- Above 102, all values for tolls are single digit.
-- Actions:
 -- Convert anything > 120 or <-120 null
 -- all values -120 
WITH my_cte AS (
SELECT -- see most frequent values
    ROUND(tolls_amount, 0) AS tolls
FROM yellow_flat
)
SELECT
    tolls,
    COUNT(*) AS toll_count
FROM my_cte
GROUP BY tolls
ORDER BY tolls DESC;


-- 2g: Notes about trip distance:
-- Above 200 mile cut off 
-- Actions:
 -- Convert anything > 120 or <-120 null
 -- all values -120 
SELECT
    TRIP_DISTANCE,
    COUNT(*)
FROM green_flat
GROUP BY TRIP_DISTANCE
ORDER BY COUNT(*) DESC

