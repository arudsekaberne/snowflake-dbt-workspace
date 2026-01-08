{{ config(
    alias='FACT_AIRBNB_REVIEWS_RAP_DT',
    target_lag="20 days",
    materialized="dynamic_table",
    snowflake_warehouse="COMPUTE_WH",
) }}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    ID,
    DATE,
    REVIEWER_NAME,
    COMMENTS,
    LAST_MODIFIED_AT
FROM
    {{ ref('airbnb_gold_fact_reviews_rap') }}