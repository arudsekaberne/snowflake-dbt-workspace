{{ config( alias='FACT_AIRBNB_REVIEWS_TAG_TABLE_VIEW' ) }}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    ID,
    DATE,
    REVIEWER_NAME,
    COMMENTS,
    LAST_MODIFIED_AT
FROM
    {{ ref('airbnb_gold_fact_reviews_tag_table') }}