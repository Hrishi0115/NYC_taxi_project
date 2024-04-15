-- Setup
USE WAREHOUSE tyler_wh;
USE DATABASE bronze_layer_2018_on;
USE SCHEMA flattened;

-- look at the columns in table to inspect
SHOW COLUMNS IN TABLE yellow_flat_FROM_2018;



------ 1. inspect values that should have discrete values in low cardinality

-- 1a: vendor id (data dict shows only 1 and 2)
-- notes: 
--    output shows 1, 2, 4, and 5
--    where is vendor id 3?
SELECT 
    vendorid,
    COUNT(*)
FROM yellow_flat_FROM_2018
GROUP BY vendorid
ORDER BY COUNT(*) DESC;


-- 1b: rate code id (data dict shows values 1-6)
-- notes:
--    values found null, 2, 3, 4, 5, 6, 99
--    5089 instances of 99 (rogue value)
-- actions:
--    inspect the instances of 99 (replace or put to null?)
SELECT 
    RATECODEID,
    COUNT(*)
FROM yellow_flat_FROM_2018
GROUP BY RATECODEID
ORDER BY COUNT(*) DESC;


-- 1c: store and forward flag (data dict shows ony 'y' or 'n')
-- notes:
--    only 'y' 'N' and null found (no rogue values)
-- actions:
--    change 'y' to uppercase?
SELECT 
    STORE_AND_FWD_FLAG,
    COUNT(*)
FROM yellow_flat_FROM_2018
GROUP BY STORE_AND_FWD_FLAG
ORDER BY COUNT(*) DESC;

-- 1d: payment type (data dict shows values 1-6)
-- notes:
--    all values within 0-6 
--    is 0 a rogue value (not in data dict)?
--    only three instances of payment type 5
--    could 0 actually be 5
-- actions:
--    decide on 0 and 5 
SELECT 
    PAYMENT_TYPE,
    COUNT(*)
FROM yellow_flat_FROM_2018
GROUP BY PAYMENT_TYPE
ORDER BY COUNT(*) DESC;





------ 2. inspect cash amounts and distances
---- taxi fares expected to be approx < $200
---- tolls expected to be approx < $30
---- extra should be limited to < $1
---- trip distances expected to be < 25 miles

-- 2a: 








------ 3. inspect datetimes
---- for now all datetimes, when converted, should be between Jan-Dec 2018

-- 3a: pickup datetime



-- 3b: dropoff datetime








------ 4. inspect pickup and dropoff zones
---- should be within 1-262?


