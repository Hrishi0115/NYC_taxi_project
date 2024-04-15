use warehouse CLARISSA_XS;use gold_level;

-- create a temporary table like time_dim table
CREATE or replace TABLE TEST_TABLE_TEMP LIKE time_dim;
-- add an identity column with primary key identity
ALTER TABLE TEST_TABLE_TEMP ADD COLUMN primary_key int IDENTITY(1,1);


create or replace sequence seq_01 start = 1 increment = 1;
INSERT INTO TEST_TABLE_TEMP 
SELECT *,seq_01.NEXTVAL FROM time_dim;

SELECT * FROM TEST_TABLE_TEMP;

drop table time_dim;
ALTER TABLE TEST_TABLE_TEMP RENAME TO time_dim;

select * from time_dim;

alter table time_dim rename column primary_key to time_id;

