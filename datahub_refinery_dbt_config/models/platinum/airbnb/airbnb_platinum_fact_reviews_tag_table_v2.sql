{{ config(
    alias='FACT_AIRBNB_REVIEWS_TAG_TABLE_VIEW2',
    table_tag="tag ({{ target.name }}_DBTGOVERN.TAGS.PII_TAG_COLUMN = 'name')"
) }}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    1000                 AS ID,
    '2024-01-01'::DATE   AS DATE,
    'Steve'              AS REVIEWER_NAME,
    'A Comment'          AS COMMENTS,
    CURRENT_TIMESTAMP()  AS LAST_MODIFIED_AT