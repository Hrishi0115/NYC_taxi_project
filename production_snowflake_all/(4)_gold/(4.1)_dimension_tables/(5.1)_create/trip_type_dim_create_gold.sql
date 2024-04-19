use database nyc_taxi;
use schema gold;

create or replace table trip_type_dim
(
trip_type_id INT PRIMARY KEY
,trip_type VARCHAR (25)
);