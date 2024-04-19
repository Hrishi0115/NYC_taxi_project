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
 
ALTER TABLE time_dim ADD column day_part VARCHAR (15);
UPDATE time_dim
SET day_part =
    CASE WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
         WHEN time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
         WHEN time BETWEEN '17:00:00' AND '23:59:59' THEN 'Evening'
    END;
 