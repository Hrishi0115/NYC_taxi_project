-- create a temporary table with 
CREATE or replace TABLE TEST_TABLE_TEMP LIKE date_dim;
ALTER TABLE TEST_TABLE_TEMP ADD COLUMN primary_key int IDENTITY(1,1);

create or replace sequence seq_01 start = 1 increment = 1;

INSERT INTO TEST_TABLE_TEMP 
SELECT *,seq_01.NEXTVAL FROM date_dim;

-- add a journey time column 

select * from test_table_temp;

drop table date_dim;

ALTER TABLE TEST_TABLE_TEMP RENAME TO date_dim;

alter table date_dim rename column primary_key to date_id;

select * from date_dim;
