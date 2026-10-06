-- Run once in a Databricks SQL editor before running the pipeline.
-- Change `main` here and in databricks.yml if you use another catalog.
USE CATALOG main;
CREATE SCHEMA IF NOT EXISTS clarity_medallion_demo;
USE SCHEMA clarity_medallion_demo;

-- The masked gold views demonstrate column masks on synthetic data.
-- These simple functions mask values for every viewer.
CREATE OR REPLACE FUNCTION phi_mask_string(value STRING)
RETURNS STRING
RETURN CASE WHEN value IS NULL THEN NULL ELSE '***MASKED***' END;

CREATE OR REPLACE FUNCTION phi_mask_date(value DATE)
RETURNS DATE
RETURN CAST(NULL AS DATE);
