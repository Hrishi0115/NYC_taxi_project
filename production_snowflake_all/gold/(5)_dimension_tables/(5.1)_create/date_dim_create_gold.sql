create or replace table gold.date_dim AS
 
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
CREATE or replace TABLE gold.TEST_TABLE_TEMP LIKE gold.date_dim;
ALTER TABLE gold.TEST_TABLE_TEMP ADD COLUMN primary_key int IDENTITY(1,1);
create or replace sequence seq_01 start = 1 increment = 1;