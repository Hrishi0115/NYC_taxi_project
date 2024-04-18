use database nyc_taxi;
use schema gold;

create or replace table vendor_dim
(
vendor_id INT PRIMARY KEY
,vendor_name VARCHAR(50)
);