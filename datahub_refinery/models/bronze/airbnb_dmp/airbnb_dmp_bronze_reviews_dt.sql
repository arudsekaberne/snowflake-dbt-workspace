{{ config(
    alias='AirBnBReviews_dt',
    target_lag="10 days",
    materialized="dynamic_table",
    snowflake_warehouse="COMPUTE_WH",
) }}

SELECT
    CURRENT_TIMESTAMP           AS SYSLOADDATE,
    CAST("listing_id" AS INT)   AS "listing_id",
    CAST("id" AS INT)           AS "id",
    CAST("date" AS DATE)        AS "date",
    CAST("reviewer_id" AS INT)  AS "reviewer_id",
    "reviewer_name"             AS "reviewer_name",
    "comments"                  AS "comments"
FROM
    {{ source('LANDING_AIRBNB', 'AirBnBReviews') }}