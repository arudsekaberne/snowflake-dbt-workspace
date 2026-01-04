USE ROLE ACCOUNTADMIN;
    
-- 1. Create database and schema for dbt governance
CREATE DATABASE IF NOT EXISTS DEV_DBTGOVERN;
DROP SCHEMA IF EXISTS DEV_DBTGOVERN.CATALOG;
    
-- 2. Clean models
DROP SCHEMA IF EXISTS DEV_BRONZE_ADF.AIRBNB;        -- DEV
DROP SCHEMA IF EXISTS DEV_BRONZE_ADF.AIRBNB_ADMIN;  -- ADMIN
    
-- 3. Policy applied by developer
--select path:models/bronze/airbnb/airbnb_bronze_listings.sql (modify post hook)

USE ROLE ACCOUNTADMIN;
USE ROLE SYSADMIN;

SELECT
    COUNT(*),
    MIN("last_review"), MAX("last_review"),
    MIN("number_of_reviews"), MAX("number_of_reviews")
FROM DEV_BRONZE_ADF.AIRBNB."AirBnBListings"
;
    
-- 4. Policy applied by admin
ALTER SESSION SET TIMEZONE = 'Asia/Kolkata';
SELECT * FROM DEV_DBTGOVERN.CATALOG.ROW_ACCESS_POLICY;
SELECT * FROM DEV_DBTGOVERN.CATALOG.ROW_ACCESS_POLICY_VIEW;
    
--select path:models/bronze/airbnb_admin/airbnb_admin_bronze_listings.sql (modify post hook)
    
USE ROLE ACCOUNTADMIN;
USE ROLE SYSADMIN;
    
SELECT
    COUNT(*),
    MIN("last_review"), MAX("last_review"),
    MIN("number_of_reviews"), MAX("number_of_reviews")
FROM DEV_BRONZE_ADF.AIRBNB_ADMIN."AirBnBListings"
;