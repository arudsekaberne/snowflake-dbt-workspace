-- 1. Set policy in landing table

ALTER TABLE DEV_LANDING_ADF.AIRBNB."AirBnBReviews"
MODIFY COLUMN "comments"
UNSET MASKING POLICY
;

ALTER TABLE DEV_LANDING_ADF.AIRBNB."AirBnBReviews"
MODIFY COLUMN "comments"
SET MASKING POLICY DEV_DBTGOVERN.POLICIES.COLUMN_VARCHAR_DYNAMIC_MASKING_POLICY
    USING ("comments", "reviewer_name")
;

-- 2. Validate policy implementation on LANDING table

USE ROLE ACCOUNTADMIN;
USE ROLE SYSADMIN;

SELECT "id", "reviewer_name", "comments" FROM DEV_LANDING_ADF.AIRBNB."AirBnBReviews"
WHERE LOWER("reviewer_name") IN ('steve')
LIMIT 4
;

-- 3. Validate policy implementation on BRONZE table (dbt model)
DROP TABLE IF EXISTS DEV_BRONZE_ADF.AIRBNB."AirBnBReviews";
--select path:models/bronze/airbnb/airbnb_bronze_reviews.sql

-- 4. Validate policy implementation on BRONZE table (Snowflake)
CREATE OR REPLACE TRANSIENT TABLE DEV_BRONZE_ADF.AIRBNB."AirBnBReviews2" AS
SELECT * FROM DEV_LANDING_ADF.AIRBNB."AirBnBReviews"
;

-- 5. Validate policy implementation on BRONZE table (both)
USE ROLE ACCOUNTADMIN;
USE ROLE SYSADMIN;

WITH
MASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_LANDING_ADF.AIRBNB."AirBnBReviews"
    WHERE LOWER("reviewer_name") = 'steve'
    LIMIT 1
),
UNMASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_LANDING_ADF.AIRBNB."AirBnBReviews"
    WHERE LOWER("reviewer_name") != 'steve'
    LIMIT 4
)
SELECT * FROM MASKED_DATA UNION ALL
SELECT * FROM UNMASKED_DATA
;

WITH
MASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB."AirBnBReviews"
    WHERE LOWER("reviewer_name") = 'steve'
    LIMIT 1
),
UNMASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB."AirBnBReviews"
    WHERE LOWER("reviewer_name") != 'steve'
    LIMIT 4
)
SELECT * FROM MASKED_DATA UNION ALL
SELECT * FROM UNMASKED_DATA
;

WITH
MASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB."AirBnBReviews2"
    WHERE LOWER("reviewer_name") = 'steve'
    LIMIT 1
),
UNMASKED_DATA AS (
    SELECT "id", "reviewer_name", "comments" FROM DEV_BRONZE_ADF.AIRBNB."AirBnBReviews2"
    WHERE LOWER("reviewer_name") != 'steve'
    LIMIT 4
)
SELECT * FROM MASKED_DATA UNION ALL
SELECT * FROM UNMASKED_DATA
;