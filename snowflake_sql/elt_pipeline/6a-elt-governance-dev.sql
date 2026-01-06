USE ROLE ACCOUNTADMIN;
    
-- 1. Create database and schema for dbt governance
CREATE DATABASE IF NOT EXISTS DEV_DBTGOVERN;
    
-- 2. Clean models
DROP SCHEMA IF EXISTS DEV_BRONZE_ADF.AIRBNB;
    
-- 3. Policy applied by developer
--select path:models/bronze/airbnb (modify post hook)

USE ROLE ACCOUNTADMIN;
USE ROLE SYSADMIN;

-- a) Row access policy
SELECT
    COUNT(*),
    MIN("last_review"), MAX("last_review"),
    MIN("number_of_reviews"), MAX("number_of_reviews")
FROM DEV_BRONZE_ADF.AIRBNB."AirBnBListings"
;
    
-- b) Dynamic masking policy
WITH
MASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB."AirBnBReviews"
    WHERE LOWER("reviewer_name") = 'steve' LIMIT 1
),
UNMASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB."AirBnBReviews"
    WHERE LOWER("reviewer_name") != 'steve' LIMIT 4
)
SELECT * FROM MASKED_DATA UNION ALL
SELECT * FROM UNMASKED_DATA
;

-- c) Tag-based dynamic masking policy (Column)
SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB."AirBnBReviews_TagColumn"
LIMIT 5
;

-- d) Tag-based dynamic masking policy (Table)
SELECT * FROM DEV_BRONZE_ADF.AIRBNB."AirBnBReviews_TagTable"
LIMIT 5
;