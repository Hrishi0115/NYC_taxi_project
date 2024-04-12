-- Setup
USE WAREHOUSE tyler_wh;
USE DATABASE bronze_layer;
USE SCHEMA flattened;



-- count of columns
SELECT COUNT(*) FROM bronze_layer.flattened.yellow_flat;


-- look at the columns in table to inspect
SHOW COLUMNS IN TABLE yellow_flat;


------ 1. inspect values that should have discrete values in low cardinality

-- 1a: vendor id (data dict shows only 1 and 2)
-- notes: 
--    output shows 1, 2, 4, and 5
--    where is vendor id 3?
-- actions:
--    drop non 1 and 2s?
--    OR (cecily idea) change all non 1 and 2s to 3 (create 3 = unknown in dimension table)
SELECT 
    vendorid,
    COUNT(*)
FROM yellow_flat
GROUP BY vendorid
ORDER BY COUNT(*) DESC;


-- 1b: rate code id (data dict shows values 1-6)
-- notes:
--    values found null, 2, 3, 4, 5, 6, 99
--    5089 instances of 99 (rogue value)
-- actions:
--    change all non 1-6 to 7, 7 references unknown in rate code dimension table
SELECT 
    RATECODEID,
    COUNT(*)
FROM yellow_flat
GROUP BY RATECODEID
ORDER BY COUNT(*) DESC;


-- 1c: store and forward flag (data dict shows ony 'y' or 'n')
-- notes:
--    only 'y' 'N' and null found (no rogue values)
-- actions:
--    change 'y' to uppercase?
--    change nulls to 'U' and in storeflag dimension add U (PK) = unknown 
SELECT 
    STORE_AND_FWD_FLAG,
    COUNT(*)
FROM yellow_flat
GROUP BY STORE_AND_FWD_FLAG
ORDER BY COUNT(*) DESC;

-- 1d: payment type (data dict shows values 1-6)
-- notes:
--    all values within 0-6 
--    is 0 a rogue value (not in data dict)?
--    only three instances of payment type 5
--    could 0 actually be 5
-- actions:
--    set anythin non 1-6 to be 5 (this column already contains unknown label = 5)
SELECT 
    PAYMENT_TYPE,
    COUNT(*)
FROM yellow_flat
GROUP BY PAYMENT_TYPE
ORDER BY COUNT(*) DESC;



------ 2. inspect cash amounts and distances

---- NUMERIC VALUES, two options:
-- Create error table (good for filtering entire rows when moving to silver)
-- set error numbers to null (quicker given time constraints)


---- taxi fares expected to be approx < $200
---- tolls expected to be approx < $30
---- extra should be limited to < $1
---- trip distances expected to be < 25 miles

---- 2a: fare amount
-- notes:
--    lots of values below zero
--    102 values above $1000 fare
--    Only 338 negative values below -100
--    97000 negative values in range -100 < v < 0
-- actions:
--    EITHER DROP OR SET TO NULL
--    drop all values above taxi threshold (e.g., $1000? $500? ask cecily and net)
--    drop all negatives below -100
--    convert all negatives above -100 to positive values 
--        (assumption here is the sign is simply incorrect for the 97000 vals)


-- set all fares above 500 or below -500 to null
WITH my_cte AS (
SELECT
    CASE
    WHEN fare_amount < 100 AND fare_amount > 0 THEN '<100'
    WHEN fare_amount < 200 THEN '100 to 200'
    WHEN fare_amount < 500 THEN '200 to 500'
    WHEN fare_amount < 1000 THEN '500 to 1000'
    ELSE '1000+' END AS price_groups
FROM yellow_flat
)
SELECT 
    price_groups,
    COUNT(*)
FROM my_cte
GROUP BY price_groups
ORDER BY COUNT(*) DESC;


SELECT -- high fare amounts:
    fare_amount,
    COUNT(*)
FROM yellow_flat
WHERE fare_amount > 500 OR fare_amount > 1000
GROUP BY fare_amount
ORDER BY fare_amount DESC;

SELECT -- negative fare amounts:
    COUNT(*)
FROM yellow_flat
WHERE fare_amount > 200
ORDER BY fare_amount DESC;


---- 2b: Extra (data dict says this should only be $0.50 or $1)
-- notes:
--    116 different values given ranging from 96 to -80
--    Most values are within range 0 to 4.5 
--    -1 and -0.5 within top 7 values (will assume purely incorrect sign)
-- actions:
--    ask richard about this type of scenario?
--    convert -0.5 and -1 to $0.50 and $1 respectively
--    drop all values thayt arent 0, 0.5 or 1 OR keep all values within 0-5
--        pro: keep more rows and dont lose trip data
--        con: data dict says only 0, 0.5 or 1. Does having 2.75 damage data
--             integrity
SELECT 
    extra,
    COUNT(*)
FROM yellow_flat
GROUP BY extra
ORDER BY COUNT(*) DESC
LIMIT 10;


---- 2c: mta tax (data dict shows only $0.5)
-- notes:
--    almost all values between -0.5 and 0.5
-- actions:
--    drop everything that is not -0.5, 0 or 0.5
--    convert all -0.5 to 0.5
SELECT 
    mta_tax,
    COUNT(*)
FROM yellow_flat
GROUP BY mta_tax
ORDER BY COUNT(*) DESC
LIMIT 10;

---- 2d: improvement surcharge (data dict shows only $0.30)
-- notes:
--    almost all values either 0, 0.3 or -0.3
-- actions:
--    drop all values that arent 0, 0.3 or -0.3
--    convert all -0.3 to 0.3
SELECT 
    improvement_surcharge,
    COUNT(*)
FROM yellow_flat
GROUP BY improvement_surcharge
ORDER BY COUNT(*) DESC
LIMIT 10;


---- 2e: tip amount (data dict does not give standard values, use common reasoning)
-- notes:
--    716 values below 0
--    smallest value is -322
--    509 tips recorded at over $150
-- actions:
--    drop all tips below -$150
--    convert all tips -150 < t < 0 to positive values
--    ask richard about 509 tips over $150 (tempted to drop)
--        also $150 is arbitrary, i have just chosen as it seems sensible
SELECT 
    COUNT(*)
FROM yellow_flat
WHERE tip_amount > 150
ORDER BY tip_amount ASC;


---- 2f: tolls_amount (data dict says this is a total (sum of taxes and extra?))
-- notes:
--    most are 0
--    only 4000 values above 30
--    817 values below 0
--    almost all values below zero are > -50
-- actions:
--    convert all negative values above -50 to positive
--    drop all values above 30 and below -50? 
--        (again arbitrary numbers but only impacts a small relative number of rows)

SELECT -- see most frequent values
    tolls_amount,
    COUNT(*)
FROM yellow_flat
GROUP BY tolls_amount
ORDER BY COUNT(*) DESC
LIMIT 10;

SELECT -- see how many values are above or below a threshold (0 and 30?)
    COUNT(*)
FROM yellow_flat
WHERE tolls_amount < 0;

SELECT 
    tolls_amount,
    COUNT(*)
FROM yellow_flat
WHERE tolls_amount < 0
GROUP BY tolls_amount
ORDER BY tolls_amount ASC;


-- 2g: passenger count
-- 1
SELECT 
    passenger_count,
    COUNT(*)
FROM yellow_flat
GROUP BY passenger_count
ORDER BY COUNT(*) DESC;



------ 3. inspect datetimes
---- for now all datetimes, when converted, should be between Jan-Dec 2018


---- 3a: pickup datetime (should be 2018)
-- notes:
--    99% of all values in 2018
-- actions:
--    convert non 2018 years to 2018 
SELECT -- see all years
    YEAR(to_date(TPEP_PICKUP_DATETIME)),
    COUNT(*)
FROM yellow_flat
GROUP BY YEAR(to_date(TPEP_PICKUP_DATETIME))
ORDER BY COUNT(*) DESC;

SELECT -- what are the wrong years and how many rows are there
    to_date(TPEP_PICKUP_DATETIME),
    COUNT(*)
FROM yellow_flat
WHERE YEAR(to_date(TPEP_PICKUP_DATETIME)) != 2018
GROUP BY to_date(TPEP_PICKUP_DATETIME)
ORDER BY COUNT(*) DESC;


-- 3b: dropoff datetime








------ 4. inspect pickup and dropoff zones
---- should be within 1-262?

SELECT -- see most frequent values
    dolocationid,
    COUNT(*)
FROM yellow_flat
GROUP BY dolocationid
ORDER BY dolocationid DESC;
