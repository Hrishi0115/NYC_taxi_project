-- create database for gold level
create database gold_level;
use gold_level;


create or replace table payment_type_dimension
( 
payment_type_id INT PRIMARY KEY
,payment_type VARCHAR(25)

);

create or replace table rate_dimension
( 
rate_code_id INT PRIMARY KEY
,rate VARCHAR(50)

);
create or replace table taxi_type_dimension
( 
taxi_type_id INT PRIMARY KEY -- need to generate 1,2,3
,taxi_type VARCHAR(25)
,trip_type VARCHAR (25)

);

create or replace table vendor_dimension
( 
vendor_id INT PRIMARY KEY 
,vendor_name VARCHAR(25)

);

create or replace table time_dimension
( 
time_id INT PRIMARY KEY 
,time VARCHAR(25)

);

create or replace table date_dimension
( 
date_id INT PRIMARY KEY 
,date DATETIME
,day_of_week VARCHAR (15)
,month VARCHAR (15)
,quarter INT
,year INT
)

create or replace table zone_dimension
(
zone_id INT PRIMARY KEY 
,borough VARCHAR(75)
,zone_name VARCHAR (75)
,service_zone VARCHAR (15)
)


create or replace table trip_fact_table
(
zone_id INT PRIMARY KEY 
,borough VARCHAR(75)
,zone_name VARCHAR (75)
,service_zone VARCHAR (15)
)