USE ROLE ACCOUNTADMIN;
    
-- 1. Create database and schema for dbt governance
CREATE DATABASE IF NOT EXISTS DEV_DBTGOVERN;
DROP SCHEMA IF EXISTS DEV_DBTGOVERN.CATALOG;
    
-- 2. Clean models
DROP SCHEMA IF EXISTS DEV_BRONZE_ADF.AIRBNB_ADM;

-- 3. Catalog mapping table
SELECT * FROM DEV_DBTGOVERN.CATALOG.ROW_ACCESS_POLICY_VIEW;
SELECT * FROM DEV_DBTGOVERN.CATALOG.MASKING_POLICY_VIEW;
SELECT * FROM DEV_DBTGOVERN.CATALOG.TAGS_ON_COLUMN_VIEW;
SELECT * FROM DEV_DBTGOVERN.CATALOG.TAGS_ON_OBJECT_VIEW;

-- 4. Policy applied by developer
--select path:models/bronze/airbnb_adm (modify post hook)

USE ROLE ACCOUNTADMIN;
USE ROLE SYSADMIN;

-- a) Row access policy
SELECT
    COUNT(*),
    MIN("last_review"), MAX("last_review"),
    MIN("number_of_reviews"), MAX("number_of_reviews")
FROM DEV_BRONZE_ADF.AIRBNB_ADM."AirBnBListings"
;
    
-- b) Dynamic masking policy
WITH
MASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB_ADM."AirBnBReviews"
    WHERE LOWER("reviewer_name") = 'steve' LIMIT 1
),
UNMASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB_ADM."AirBnBReviews"
    WHERE LOWER("reviewer_name") != 'steve' LIMIT 4
)
SELECT * FROM MASKED_DATA UNION ALL
SELECT * FROM UNMASKED_DATA
;

-- c) Tag-based dynamic masking policy (Column)
SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB_ADM."AirBnBReviews_TagColumn"
LIMIT 5
;

-- d) Tag-based dynamic masking policy (Table)
SELECT * FROM DEV_BRONZE_ADF.AIRBNB_ADM."AirBnBReviews_TagTable"
LIMIT 5
;