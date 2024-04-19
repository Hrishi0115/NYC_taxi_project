-- RATE DIMENSION
use database nyc_taxi;
use schema gold;

create or replace table rate_dim
(
rate_code_id INT PRIMARY KEY
,rate VARCHAR(50)
 
);
 