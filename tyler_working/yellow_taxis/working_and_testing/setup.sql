USE WAREHOUSE compute_wh;

-- warehouse for querying
CREATE WAREHOUSE IF NOT EXISTS tyler_wh WITH
    WAREHOUSE_TYPE = STANDARD
    WAREHOUSE_SIZE = SMALL; 
USE WAREHOUSE tyler_wh;


-- warehouse for loading 10s millions rows
CREATE WAREHOUSE IF NOT EXISTS tyler_big_wh WITH
    WAREHOUSE_TYPE = STANDARD
    WAREHOUSE_SIZE = XLARGE; 


 -- landing for yellow, green, fhv, fhvhv
CREATE DATABASE IF NOT EXISTS bronze_layer; 


-- create separate schema for json and flattened tables
USE DATABASE bronze_layer;
CREATE SCHEMA json;
CREATE SCHEMA flattened;
