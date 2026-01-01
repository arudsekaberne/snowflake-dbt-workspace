USE ROLE ACCOUNTADMIN;

-- 1. Create database and schema for dbt governance
CREATE DATABASE IF NOT EXISTS DEV_DBTGOVERN;
CREATE SCHEMA IF NOT EXISTS DEV_DBTGOVERN.POLICIES;

-- 2. Remove existings policies
DROP SCHEMA IF EXISTS DEV_BRONZE_ADF.AIRBNB;

-- 3. Create policies
CREATE OR REPLACE ROW ACCESS POLICY DEV_DBTGOVERN.POLICIES.CURRENT_YEAR_LESS_REVIEW_ACCESS_POLICY AS (date DATE, review_count NUMBER)
RETURNS BOOLEAN ->
    CASE
        WHEN CURRENT_ROLE() IN ('ACCOUNTADMIN') THEN TRUE
        WHEN CURRENT_ROLE() IN ('SYSADMIN') AND YEAR(date) = YEAR(CURRENT_DATE) AND review_count <= 10 THEN TRUE
        ELSE FALSE
    END
;

-- 4. Run dbt models
--select +path:models/platinum/airbnb

-- 4. Validate policy apply
SELECT *
FROM TABLE(
  DEV_BRONZE_ADF.INFORMATION_SCHEMA.POLICY_REFERENCES(
    ref_entity_name  => 'DEV_BRONZE_ADF.AIRBNB."AirBnBListings"',
    ref_entity_domain => 'TABLE'
  )
)
WHERE POLICY_KIND = 'ROW_ACCESS_POLICY'
;

-- 6. Validate dbt models
USE ROLE ACCOUNTADMIN;
USE ROLE SYSADMIN;

SELECT '0_landing' AS materialization,             MIN("last_review"::DATE), MAX("last_review"::DATE), MIN("number_of_reviews"::INT), MAX("number_of_reviews"::INT)
    FROM DEV_LANDING_ADF.AIRBNB."AirBnBListings"
UNION SELECT '1_table' AS materialization,         MIN("last_review"), MAX("last_review"), MIN("number_of_reviews"), MAX("number_of_reviews")
    FROM DEV_BRONZE_ADF.AIRBNB."AirBnBListings"
UNION SELECT '2_snapshot' AS materialization,      MIN("last_review"), MAX("last_review"), MIN("number_of_reviews"), MAX("number_of_reviews")
    FROM DEV_SILVER_ADF.AIRBNB."AirBnBListings"
UNION SELECT '3_incremental' AS materialization,   MIN(LAST_REVIEW),   MAX(LAST_REVIEW),   MIN(NUMBER_OF_REVIEWS),   MAX(NUMBER_OF_REVIEWS)
    FROM DEV_GOLD_ADF.AIRBNB.FACT_AIRBNBLISTINGS
UNION SELECT '4_view' AS materialization,          MIN(LAST_REVIEW),   MAX(LAST_REVIEW),   MIN(NUMBER_OF_REVIEWS),   MAX(NUMBER_OF_REVIEWS)
    FROM DEV_PLATINUM_ADF.AIRBNB.FACT_AIRBNBLISTINGS_VIEW
UNION SELECT '5_secure_view' AS materialization,   MIN(LAST_REVIEW),   MAX(LAST_REVIEW),   MIN(NUMBER_OF_REVIEWS),   MAX(NUMBER_OF_REVIEWS)
    FROM DEV_PLATINUM_ADF.AIRBNB.FACT_AIRBNBLISTINGS_SVIEW
UNION SELECT '6_dynamic_table' AS materialization, MIN(LAST_REVIEW),   MAX(LAST_REVIEW),   MIN(NUMBER_OF_REVIEWS),   MAX(NUMBER_OF_REVIEWS)
    FROM DEV_PLATINUM_ADF.AIRBNB.FACT_AIRBNBLISTINGS_DTABLE
ORDER BY 1;