use database nyc_taxi;
use schema gold;

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