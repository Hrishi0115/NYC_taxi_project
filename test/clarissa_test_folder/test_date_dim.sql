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
,QUARTER(MY_DATE) as quarter
FROM my_cte
;






------------------------------------------------------------------------adding id column 

CREATE or replace TABLE TEST_TABLE_TEMP LIKE date_dim;
ALTER TABLE TEST_TABLE_TEMP ADD COLUMN primary_key int IDENTITY(1,1);

create or replace sequence seq_01 start = 1 increment = 1;

INSERT INTO TEST_TABLE_TEMP 
SELECT *,seq_01.NEXTVAL FROM date_dim;

select * from test_table_temp;

drop table date_dim;

ALTER TABLE TEST_TABLE_TEMP RENAME TO date_dim;

alter table date_dim rename column primary_key to date_id;

ALTER TABLE date_dim
ADD COLUMN is_holiday INT;

UPDATE date_dim
SET is_holiday = -- ONLY INCLUDES HOLIDAYS UP TO 2024 
    CASE WHEN date IN (
        '2018-01-01', '2018-01-15', '2018-02-19', '2018-05-28', '2018-07-04', '2018-09-03', '2018-10-08', 
        '2018-11-11', '2018-11-12', '2018-11-22', '2018-12-25', '2019-01-01', '2019-01-21', '2019-02-18', 
        '2019-05-27', '2019-07-04', '2019-09-02', '2019-10-14', '2019-11-11', '2019-11-28', '2019-12-25', 
        '2020-01-01', '2020-01-20', '2020-02-17', '2020-05-25', '2020-07-03', '2020-07-04', '2020-09-07', 
        '2020-10-12', '2020-11-11', '2020-11-26', '2020-12-25', '2021-01-01', '2021-01-18', '2021-02-15', 
        '2021-05-31', '2021-06-18', '2021-06-19', '2021-07-04', '2021-07-05', '2021-09-06', '2021-10-11', 
        '2021-11-11', '2021-11-25', '2021-12-24', '2021-12-25', '2021-12-31', '2022-01-01', '2022-01-17', 
        '2022-02-21', '2022-05-30', '2022-06-19', '2022-06-20', '2022-07-04', '2022-09-05', '2022-10-10', 
        '2022-11-11', '2022-11-24', '2022-12-25', '2022-12-26', '2023-01-01', '2023-01-02', '2023-01-16', 
        '2023-02-20', '2023-05-29', '2023-06-19', '2023-07-04', '2023-09-04', '2023-10-09', '2023-11-10', 
        '2023-11-11', '2023-11-23', '2023-12-25', '2024-01-01', '2024-01-15', '2024-02-19', '2024-05-27', 
        '2024-06-19', '2024-07-04', '2024-09-02', '2024-10-14', '2024-11-11', '2024-11-28', '2024-12-25'
    ) THEN 1
    ELSE 0
    END;

------------------------------------------ TIME DIMENSION

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

INSERT INTO TEST_TABLE_TEMP 
SELECT *,seq_01.NEXTVAL FROM time_dim;

alter table time_dim 
add column time_id INT;

INSERT INTO time_dim (time_id)
SELECT primary_key
FROM TEST_TABLE_TEMP;

drop table time_dim;

ALTER TABLE TEST_TABLE_TEMP RENAME TO time_dim;

alter table time_dim rename column primary_key to time_id;
