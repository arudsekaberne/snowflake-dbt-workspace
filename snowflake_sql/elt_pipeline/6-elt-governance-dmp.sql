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
--select +path:snapshots/silver/airbnb/

-- 4. Validate policy apply

DESC TABLE DEV_BRONZE_ADF.AIRBNB."AirBnBReviews"; -- (or)

SELECT REF_COLUMN_NAME, POLICY_NAME
FROM TABLE(
  DEV_BRONZE_ADF.INFORMATION_SCHEMA.POLICY_REFERENCES(
    ref_entity_name  => 'DEV_BRONZE_ADF.AIRBNB."AirBnBReviews"',
    ref_entity_domain => 'TABLE'
  )
)
WHERE POLICY_KIND = 'MASKING_POLICY' AND TAG_NAME IS NULL
;

-- 5. Validate dbt models
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