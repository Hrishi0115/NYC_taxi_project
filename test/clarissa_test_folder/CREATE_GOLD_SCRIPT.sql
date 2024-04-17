use warehouse CLARISSA_XS; use gold_level;


-- CREATING DIMENSION TABLES
-- PAYMENT TYPE DIMENSION
create or replace table payment_type_dim
( 
payment_type_id INT PRIMARY KEY
,payment_type VARCHAR(25)
);

INSERT INTO payment_type_dim
(payment_type_id,payment_type)
VALUES
(1, 'Credit Card')
,(2, 'Cash')
,(3, 'No charge')
,(4, 'Dispute')
,(5, 'Unknown')
,(6, 'Voided trip')
;

-- RATE DIMENSION
create or replace table rate_dim
( 
rate_code_id INT PRIMARY KEY
,rate VARCHAR(50)

);

INSERT INTO rate_dim (rate_code_id, rate)
VALUES
(1, 'Standard rate')
,(2,'JFK' )
,(3, 'Newark' )
,(4, 'Nassau or Westchester')
,(5, 'Negotiated fare' )
,(6, 'Group ride')
;

-- TRIP TYPE DIMENSION
create or replace table trip_type_dim
( 
trip_type_id INT PRIMARY KEY
,trip_type VARCHAR (25)
);


INSERT INTO trip_type_dim
VALUES
(1, 'Street-hail')
,(2,'Dispatch')
,(3,'Unknown');


-- TAXI COLOUR DIMENSION
create or replace table taxi_colour_dim
( 
taxi_colour_id INT PRIMARY KEY
,taxi_colour VARCHAR(25)
);

INSERT INTO taxi_colour_dim
VALUES
(1, 'Yellow')
,(2,'Green')


-- VENDOR DIMENSION 
create or replace table vendor_dim
( 
vendor_id INT PRIMARY KEY 
,vendor_name VARCHAR(50)
);

INSERT INTO vendor_dim (vendor_id, vendor_name)
VALUES
(1, 'Creative Mobile Technologies, LLC')
,(2, 'VeriFone Inc')
;

------------------------------------------------------------------------------- DATE DIMENSION 

create or replace table date_dim AS

WITH my_cte AS (
SELECT DATEADD(DAY, SEQ4(), '2018-01-01 00:00:00') AS MY_DATE
FROM TABLE(GENERATOR(ROWCOUNT=>20000))
)
SELECT
TO_DATE(MY_DATE) as date
,DAYNAME(MY_DATE) as day
,MONTHNAME(MY_DATE) as monthname
,YEAR(MY_DATE) as year
,WEEKOFYEAR(MY_DATE) as weekofyear
,QUARTER(MY_DATE) as quarter
FROM my_cte
;
CREATE or replace TABLE TEST_TABLE_TEMP LIKE date_dim;
ALTER TABLE TEST_TABLE_TEMP ADD COLUMN primary_key int IDENTITY(1,1);
create or replace sequence seq_01 start = 1 increment = 1;
INSERT INTO TEST_TABLE_TEMP 
SELECT *,seq_01.NEXTVAL FROM date_dim;
select * from test_table_temp;
drop table date_dim;
ALTER TABLE TEST_TABLE_TEMP RENAME TO date_dim;
alter table date_dim rename column primary_key to date_id;
ALTER TABLE date_dim
ADD COLUMN is_holiday INT;
UPDATE date_dim
SET is_holiday = -- ONLY INCLUDES HOLIDAYS UP TO 2024 
    CASE WHEN date IN (
        '2018-01-01', '2018-01-15', '2018-02-19', '2018-05-28', '2018-07-04', '2018-09-03', '2018-10-08', 
        '2018-11-11', '2018-11-12', '2018-11-22', '2018-12-25', '2019-01-01', '2019-01-21', '2019-02-18', 
        '2019-05-27', '2019-07-04', '2019-09-02', '2019-10-14', '2019-11-11', '2019-11-28', '2019-12-25', 
        '2020-01-01', '2020-01-20', '2020-02-17', '2020-05-25', '2020-07-03', '2020-07-04', '2020-09-07', 
        '2020-10-12', '2020-11-11', '2020-11-26', '2020-12-25', '2021-01-01', '2021-01-18', '2021-02-15', 
        '2021-05-31', '2021-06-18', '2021-06-19', '2021-07-04', '2021-07-05', '2021-09-06', '2021-10-11', 
        '2021-11-11', '2021-11-25', '2021-12-24', '2021-12-25', '2021-12-31', '2022-01-01', '2022-01-17', 
        '2022-02-21', '2022-05-30', '2022-06-19', '2022-06-20', '2022-07-04', '2022-09-05', '2022-10-10', 
        '2022-11-11', '2022-11-24', '2022-12-25', '2022-12-26', '2023-01-01', '2023-01-02', '2023-01-16', 
        '2023-02-20', '2023-05-29', '2023-06-19', '2023-07-04', '2023-09-04', '2023-10-09', '2023-11-10', 
        '2023-11-11', '2023-11-23', '2023-12-25', '2024-01-01', '2024-01-15', '2024-02-19', '2024-05-27', 
        '2024-06-19', '2024-07-04', '2024-09-02', '2024-10-14', '2024-11-11', '2024-11-28', '2024-12-25'
    ) THEN 1
    ELSE 0
    END;


------------------------------------------------------------------------------- TIME DIMENSION

create or replace table time_dim AS

WITH my_cte AS (
SELECT DATEADD(SECOND, SEQ4(), '2018-01-01 00:00:00') AS MY_DATE
FROM TABLE(GENERATOR(ROWCOUNT=>86400))
)
SELECT
TO_TIME(MY_DATE) as time
,HOUR(MY_DATE) as hour
FROM my_cte
;

CREATE or replace TABLE TEST_TABLE_TEMP LIKE time_dim;
ALTER TABLE TEST_TABLE_TEMP ADD COLUMN primary_key int IDENTITY(1,1);
create or replace sequence seq_01 start = 1 increment = 1;
INSERT INTO TEST_TABLE_TEMP 
SELECT *,seq_01.NEXTVAL FROM time_dim;
alter table time_dim 
add column time_id INT;
INSERT INTO time_dim (time_id)
SELECT primary_key
FROM TEST_TABLE_TEMP;
drop table time_dim;
ALTER TABLE TEST_TABLE_TEMP RENAME TO time_dim;
alter table time_dim rename column primary_key to time_id;

------------------------------------------------------------------------------- ZONE DIMENSION

create or replace stage zone_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/taxi_zone_lookup'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;
list @zone_stage;

create or replace FILE FORMAT csv_zone
TYPE = csv;

-- SELECT $1,$2,$3,$4,$5
-- from @zone_stage
-- (file_format => csv_zone)
-- LIMIT 10;

copy into zone_dim ()
from @zone_stage
file_format = csv_zone;
-------------------------------------------------------------------------------- HV DIMENSION

create or replace table high_volume_dim
(
hv_license_number VARCHAR(15) PRIMARY KEY 
,app_company_affiliation varchar(50)
);
INSERT INTO high_volume_dim
(
hv_license_number
,app_company_affiliation)
VALUES
('HV0002', 'Juno')
,('HV0003', 'Uber')
,('HV0004', 'Via')
,('HV0005', 'Lyft');

-------------------------------------------------------------------------------- BASE DIMENSION 
create or replace table base_dim
(
hv_license_number VARCHAR(15)
,base_num VARCHAR(15) PRIMARY KEY 
,base_name varchar(50)
);

create or replace stage base_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/base_number_table'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;

list @base_stage;

create or replace FILE FORMAT csv_zone
TYPE = csv
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- SELECT $1,$2,$3,$4
-- from @base_stage
-- (file_format => csv_zone)
-- LIMIT 10;

copy into base_dim (hv_license_number,base_num ,base_name )
from @base_stage
file_format = csv_zone;


DROP TABLE IF EXISTS gold_level.public.trip_fact_table;
create or replace table gold_level.public.trip_fact_table
(
taxi_trip_id INT PRIMARY KEY AUTOINCREMENT --START 1 INCREMENT 1
,taxi_colour_id INT
,trip_type_id INT
,vendor_id VARCHAR(5)
,passenger_count INT
,trip_distance FLOAT
,PU_zone_id INT
,DO_zone_id INT
,PU_date_id INT
,PU_time_id INT
,DO_date_id INT
,DO_time_id INT
,rate_code_id INT
,payment_type_id INT
,fare_amount FLOAT
,extra FLOAT
,mta_tax FLOAT
,improvement_surcharge FLOAT
,tip_amount FLOAT
,total_amount FLOAT
,airport_fee FLOAT
,congestion_surcharge FLOAT
,trip_duration_minutes DECIMAL(10,1)
);

create or replace TABLE GOLD_LEVEL.PUBLIC.FHV_TRIP_FACT_TABLE (
    FHV_TRIP_ID NUMBER(38,0) NOT NULL autoincrement start 1 increment 1 noorder,
    DISPATCHING_BASE_NUMBER VARCHAR(15),
    ORIGINATING_BASE_NUMBER VARCHAR(15),
    PU_DATE_ID NUMBER(38,0),
    PU_TIME_ID NUMBER(38,0),
    DO_DATE_ID NUMBER(38,0),
    DO_TIME_ID NUMBER(38,0),
    PU_LOCATION_ID NUMBER(38,0),
    DO_LOCATION_ID NUMBER(38,0),
    SR_FLAG NUMBER(38,0),
    REQUEST_DATE_ID NUMBER(38,0),
    REQUEST_TIME_ID NUMBER(38,0),
    ONSCENE_DATE_ID NUMBER(38,0),
    ONSCENE_TIME_ID NUMBER(38,0),
    ACCESSIBLE_VEHICLE VARCHAR(1),
    TRIP_MILES FLOAT,
    TRIP_TIME FLOAT,
    BASE_PASSENGER_FARE FLOAT,
    TOLLS FLOAT,
    BCF FLOAT,
    SALES_TAX FLOAT,
    CONGESTION_SURCHARGE FLOAT,
    AIRPORT_FEE FLOAT,
    TIPS FLOAT,
    DRIVER_PAY FLOAT,
    SHARED_REQUEST_FLAG VARCHAR(1),
    SHARED_MATCH_FLAG VARCHAR(1),
    ACCESS_A_RIDE_FLAG VARCHAR(1),
    WAV_REQUEST_FLAG VARCHAR(1),
    WAV_MATCH_FLAG VARCHAR(1),
    primary key (FHV_TRIP_ID)
);