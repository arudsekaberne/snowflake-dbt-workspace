{{
    config(
        alias = 'FACT_AIRBNB_REVIEWS_RAP',
        incremental_strategy = 'merge',
        unique_key = 'ID',
        row_access_policy = '{{ target.name }}_DBTGOVERN.POLICIES.SPECIFIC_YEAR_ACCESS_POLICY on ("date")'
    )
}}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    "id"                 AS ID,
    "date"               AS DATE,
    "reviewer_name"      AS REVIEWER_NAME,
    "comments"           AS COMMENTS,
    DBT_UPDATED_AT       AS LAST_MODIFIED_AT
FROM
    {{ ref('airbnb_silver_reviews_rap') }}
WHERE DBT_VALID_TO IS NULL

{% if is_incremental() %}
    AND DBT_UPDATED_AT > (
        SELECT COALESCE(MAX(LAST_MODIFIED_AT), '0000-01-01'::TIMESTAMP_NTZ) FROM {{ this }}
    )
{% endif %}