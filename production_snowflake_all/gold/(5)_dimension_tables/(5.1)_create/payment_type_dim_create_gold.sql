-- CREATING DIMENSION TABLES
-- PAYMENT TYPE DIMENSION
create or replace table payment_type_dim
(
payment_type_id INT PRIMARY KEY
,payment_type VARCHAR(25)
);