USE WAREHOUSE tyler_wh;
USE DATABASE bronze_layer;
USE SCHEMA flattened;



SELECT
        CASE
        WHEN hvfhs_liscense_num NOT IN 
            ('HV0002', 'HV0003', 'HV0004', 'HV0005') THEN 'U' -- set to unknown in dim table
        ELSE hvfhs_liscense_num END AS
    hvfhs_liscense_num,
        CASE
        WHEN dispatching_base_num NOT IN --(SELECT _ FROM base_number list in user guide for hvfhv)
        ELSE END AS 
    dispatching_base_num,
        CASE
        WHEN 
