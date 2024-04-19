# NYC Taxi - Kubrick Group Training Final Project

## Overview
This Repository contains the snowflake files used in automated pipeline for the Kubrick Group Training Final Project. The project was orchestrated using Azure Data Factory, using snowflake as the data warehouse and azure blob storage for raw data landing. The project workflow followed the data lake medallion structure, with each stage stored in separated schema in the snowflake production database. Raw data is stored in bronze, flattened data in senior bronze, cleaned data in in silver, and the data placed into the dimensional model star schema is stored in gold.

## Brief:
- Develop automated pipeline for NYC taxi trip data: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- Design star schema dimemnsional model and populate fact table(s) and dimension tables with 2018 taxi data
- Starting from Feb 2019 - simulate running monthly batches up to 2020
- Produce some insightful Data Visualisations and Reports
- Agile project should be structured and run according to accepted best practice


## Repo Contents:
```
production_snowflake_all
│
├── (1)_bronze
│   ├── fhvhv_load_bronze.sql
│   ├── fhv_load_bronze.sql
│   ├── green_load_bronze.sql
│   └── yellow_load_bronze.sql
├── (2)_senior_bronze
│   ├── fhvhv_flatten_bronze.sql
│   ├── fhv_flatten_bronze.sql
│   ├── green_flatten_bronze.sql
│   └── yellow_flatten_bronze.sql
├── (3)_silver
│   ├── (3.1)_create
│   │   ├── fhvhv_create_silver.sql
│   │   ├── fhv_create_silver.sql
│   │   ├── green_create_silver.sql
│   │   └── yellow_create_silver.sql
│   └── (3.2)_insert
│       ├── fhvhv_insert_silver.sql
│       ├── fhv_insert_silver.sql
│       ├── green_insert_silver.sql
│       └── yellow_insert_silver.sql
├── (4)_gold
│   ├── (4.1)_dimension_tables
│   │   ├── (4.1.1)_create
│   │   │   ├── base_dim_create_gold.sql
│   │   │   ├── date_dim_create_gold.sql
│   │   │   ├── high_volume_dim_create_gold.sql
│   │   │   ├── payment_type_dim_create_gold.sql
│   │   │   ├── rate_dim_create_gold.sql
│   │   │   ├── taxi_colour_dim_create_gold.sql
│   │   │   ├── time_dim_create_gold.sql
│   │   │   ├── trip_type_dim_create_gold.sql
│   │   │   └── vendor_dim_create_gold.sql
│   │   └── (4.1.2)_insert
│   │       ├── base_dim_insert_gold.sql
│   │       ├── date_dim_insert_gold.sql
│   │       ├── high_volume_dim_insert_gold.sql
│   │       ├── payment_type_dim_insert_gold.sql
│   │       ├── rate_dim_insert_gold.sql
│   │       ├── taxi_colour_dim_insert_gold.sql
│   │       ├── time_dim_insert_gold.sql
│   │       ├── trip_type_dim_insert_gold.sql
│   │       └── vendor_dim_insert_gold.sql
│   └── (4.2)_fact_table
│       ├── (4.2.1)_create
│       │   ├── fhv_fact_table_create.sql
│       │   └── taxi_fact_table_create.sql
│       └── (4.2.2)_insert
│           ├── fhvhv_insert_fact_table.sql
│           ├── fhv_insert_fact_table.sql
│           ├── green_insert_fact_table.sql
│           └── yellow_insert_fact_table.sql
└── (5)_testing_and_validation
    ├── bronze
    │   ├── fhv_t_and_v_bronze.sql
    │   ├── green_t_and_v_bronze.sql
    │   └── yellow_t_and_v_bronze.sql
    ├── gold
    │   ├── fhv_fact_t_and_v.sql
    │   └── taxi_fact_t_and_v.sql
    ├── senior_bronze
    │   ├── fhvhv_t_and_v_senior_bronze.sql
    │   ├── fhv_t_and_v_senior_bronze.sql
    │   ├── green_t_and_v_senior_bronze.sql
    │   └── yellow_t_and_v_senior_bronze.sql
    └── silver
        ├── fhvhv_t_and_v_silver.sql
        ├── fhv_t_and_v_silver.sql
        ├── green_t_and_v_silver.sql
        └── yellow_t_and_v_silver.sql
```



