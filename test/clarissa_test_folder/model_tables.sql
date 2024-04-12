-- create database for gold level
use warehouse nyc_test_data;
create database gold_level;
use gold_level;


create or replace table payment_type_dim
( 
payment_type_id INT PRIMARY KEY
,payment_type VARCHAR(25)
);

create or replace table rate_dim
( 
rate_code_id INT PRIMARY KEY
,rate VARCHAR(50)

);
create or replace table taxi_type_dim
( 
taxi_type_id INT PRIMARY KEY -- need to generate 1,2,3
,taxi_type VARCHAR(25)
,trip_type VARCHAR (25)

);

create or replace table vendor_dim
( 
vendor_id INT PRIMARY KEY 
,vendor_name VARCHAR(25)
);

create or replace table time_dim AS

WITH my_cte AS (
SELECT DATEADD(SECOND, SEQ4(), '2018-01-01 00:00:00') AS MY_DATE
FROM TABLE(GENERATOR(ROWCOUNT=>86400))
)
SELECT
,TO_TIME(MY_DATE) as time
,HOUR(MY_DATE) as hour
FROM my_cte
;

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
,DAYOFYEAR(MY_DATE) as dayofyear
,HOUR(MY_DATE) as hour
FROM my_cte
;

create or replace table zone_dim
(
zone_id INT PRIMARY KEY 
,borough VARCHAR(75)
,zone_name VARCHAR (75)
,service_zone VARCHAR (15)
);


create or replace table high_volume_dim
(
hv_license_number VARCHAR(15) PRIMARY KEY 
,app_company_affiliation varchar(50)
);

create or replace table base_dim
(
base_num VARCHAR(15) PRIMARY KEY 
,base_name varchar(50)
,hv_license_number VARCHAR(15)
);



create or replace table trip_fact_table
(
taxi_trip_id INT PRIMARY KEY 
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
,taxi_type_id INT
,fare_amount DECIMAL(10,2)
,extra DECIMAL(10,2)
,mta_tax DECIMAL(10,2)
,improvement_surcharge DECIMAL(10,2)
,tip_amount DECIMAL(10,2)
,total_amount DECIMAL(10,2)
,airport_fee DECIMAL(10,2)
,congestion_surcharge DECIMAL(10,2)
);


create or replace table fhv_trip_fact_table
(
fhv_trip_id INT PRIMARY KEY 
,dispatching_base_number VARCHAR(15)
,originating_base_number VARCHAR(15)
,PU_date_id INT
,PU_time_id INT
,DO_date_id INT
,DO_time_id INT
,PU_location_id INT
,DO_location_id INT
,SR_flag BOOL
,request_date_id INT
,request_time_id INT
,onscene_date_id INT
,onscene_time_id INT
,accessible_vehicle VARCHAR (1) 
,trip_miles DECIMAL(10,2)
,trip_time DECIMAL(10,2) --duration
,base_passenger_fare DECIMAL(10,2)
,tolls DECIMAL(10,2)
,bcf DECIMAL(10,2)
,sales_tax DECIMAL(10,2)
,congestion_surcharge DECIMAL(10,2)
,airport_fee DECIMAL(10,2)
,tips DECIMAL(10,2)
,driver_pay DECIMAL(10,2)
,shared_request_flag VARCHAR(1)
,access_a_ride_flag VARCHAR(1)
,wav_request VARCHAR(1)
,wav_match_flag VARCHAR(1)
);


-- Insert data into dimension tables

INSERT INTO vendor_dim (vendor_id, vendor_name)
VALUES
(1, 'Creative Mobile Technologies, LLC')
,(2, 'VeriFone Inc')
;

INSERT INTO rate_dim (rate_code_id, rate)
VALUES
(1, 'Standard rate')
,(2,'JFK' )
,(3, 'Newark' )
,(4, 'Nassau or Westchester')
,(5, 'Negotiated fare' )
,(6, 'Group ride')
;

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

INSERT INTO taxi_type_dim
( 
taxi_type_id
,taxi_type
,trip_type
)
VALUES
(1, 'Yellow', 'Street-hail' )
,(2, 'Green', 'Dispatch')
,(3, ' Green', 'Street-hail' )




---- Load values from lookup table into zone dimension table
create or replace stage zone_stage
url = 'azure://triathlonnyc.blob.core.windows.net/output/taxi_zone_lookup'
credentials = (AZURE_SAS_TOKEN = 'sp=rl&st=2024-04-10T13:48:21Z&se=2024-04-19T21:48:21Z&spr=https&sv=2022-11-02&sr=c&sig=gnfFLDUs19AGWxqa10Hp%2BQctVrHQe6I6DC2s2qhWOns%3D')
;
list @zone_stage;

create or replace FILE FORMAT csv_zone
TYPE = csv

SELECT $1,$2,$3,$4,$5
from @zone_stage
(file_format => csv_zone)
LIMIT 10;

copy into zone_dim
from @zone_stage
file_format = csv_zone