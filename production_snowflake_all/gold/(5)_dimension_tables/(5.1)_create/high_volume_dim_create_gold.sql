use database nyc_taxi;
use schema gold;

create or replace table high_volume_dim
(
hv_license_number VARCHAR(15) PRIMARY KEY
,app_company_affiliation varchar(50)
);
