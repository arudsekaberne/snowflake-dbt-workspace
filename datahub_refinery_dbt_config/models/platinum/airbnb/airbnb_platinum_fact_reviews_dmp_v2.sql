{{ config( alias='FACT_AIRBNB_REVIEWS_DMP_VIEW2' ) }}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    1000                 AS ID,
    '2024-01-01'::DATE   AS DATE,
    'Steve'              AS REVIEWER_NAME,
    'A Comment'          AS COMMENTS,
    CURRENT_TIMESTAMP    AS LAST_MODIFIED_AT
