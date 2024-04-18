DROP TABLE IF EXISTS target_table; 

CREATE TABLE target_table (
    json_data VARIANT 
);

INSERT INTO target_table (json_data)
VALUES (1);

SELECT * FROM target_table;

