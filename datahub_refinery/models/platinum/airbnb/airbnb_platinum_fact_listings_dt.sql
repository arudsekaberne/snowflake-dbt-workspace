{{ config(
    alias='FACT_AIRBNBLISTINGS_DTABLE',
    target_lag="10 days",
    materialized="dynamic_table",
    snowflake_warehouse="COMPUTE_WH",
) }}

SELECT
    *
FROM {{ ref('airbnb_gold_fact_listings') }}