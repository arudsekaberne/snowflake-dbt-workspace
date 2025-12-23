USE ROLE ACCOUNTADMIN;

-- 1. Create database and schema for dbt governance
CREATE DATABASE IF NOT EXISTS DEV_DBTGOVERN;
CREATE SCHEMA IF NOT EXISTS DEV_DBTGOVERN.POLICIES;


-- 2. Create tags & policies
CREATE OR REPLACE MASKING POLICY DEV_DBTGOVERN.POLICIES.COLUMN_NUMBER_MASKING_POLICY AS (pii_value NUMBER)
RETURNS NUMBER ->
    CASE
        WHEN CURRENT_ROLE() IN ('ACCOUNTADMIN') THEN pii_value
        ELSE -1
    END
;

CREATE OR REPLACE MASKING POLICY DEV_DBTGOVERN.POLICIES.COLUMN_VARCHAR_DYNAMIC_MASKING_POLICY AS (pii_value VARCHAR, name VARCHAR)
RETURNS STRING ->
    CASE
        WHEN CURRENT_ROLE() IN ('ACCOUNTADMIN') THEN pii_value
        WHEN CURRENT_ROLE() IN ('SYSADMIN') AND LOWER(name) != 'steve' THEN pii_value
        ELSE '*** COLUMN-MASKED ***'
    END
;

-- 3. . Run dbt models
--select +path:snapshots/silver/airbnb +path:models/platinum/airbnb

-- 4. Validate dbt models
USE ROLE ACCOUNTADMIN;
USE ROLE SYSADMIN;

SELECT "id", "reviewer_name", "comments" FROM DEV_LANDING_ADF.AIRBNB."AirBnBReviews"
WHERE LOWER("reviewer_name") IN ('steve', 'emma')
LIMIT 5
;

SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB."AirBnBReviews"
WHERE LOWER("reviewer_name") IN ('steve', 'emma')
LIMIT 5
;

SELECT "id", "reviewer_name", "comments" FROM DEV_SILVER_ADF.AIRBNB."AirBnBReviews"
WHERE LOWER("reviewer_name") IN ('steve', 'emma')
LIMIT 5
;

SELECT "id", "reviewer_name", "comments" FROM DEV_PLATINUM_ADF.AIRBNB.FACT_AIRBNBREVIEWS_VIEW
WHERE LOWER("reviewer_name") IN ('steve', 'emma')
LIMIT 5
;

SELECT "id", "reviewer_name", "comments" FROM DEV_PLATINUM_ADF.AIRBNB.FACT_AIRBNBREVIEWS_SVIEW
WHERE LOWER("reviewer_name") IN ('steve', 'emma')
LIMIT 5
;

SELECT "id", "reviewer_name", "comments" FROM DEV_PLATINUM_ADF.AIRBNB.FACT_AIRBNBREVIEWS_DTABLE
WHERE LOWER("reviewer_name") IN ('steve', 'emma')
LIMIT 5
;