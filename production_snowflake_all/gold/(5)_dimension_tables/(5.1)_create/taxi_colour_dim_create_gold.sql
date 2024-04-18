use database nyc_taxi;
use schema gold;

create or replace table taxi_colour_dim
(
taxi_colour_id INT PRIMARY KEY
,taxi_colour VARCHAR(25)
);