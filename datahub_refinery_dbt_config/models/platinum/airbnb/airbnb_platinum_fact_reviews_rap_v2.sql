{{ config(
    alias='FACT_AIRBNB_REVIEWS_RAP_VIEW2',
    row_access_policy = '{{ target.name }}_DBTGOVERN.POLICIES.SPECIFIC_YEAR_ACCESS_POLICY on ("date")'
) }}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    1000                 AS ID,
    '2023-01-01'::DATE   AS DATE,
    'Steve'              AS REVIEWER_NAME,
    'A Comment'          AS COMMENTS,
    CURRENT_TIMESTAMP()  AS LAST_MODIFIED_AT
UNION ALL
SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    1000                 AS ID,
    '2024-01-01'::DATE   AS DATE,
    'Steve'              AS REVIEWER_NAME,
    'A Comment'          AS COMMENTS,
    CURRENT_TIMESTAMP()  AS LAST_MODIFIED_AT