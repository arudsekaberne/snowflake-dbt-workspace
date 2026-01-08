{{ config(
    alias='AirBnBReviews_TagTable',
    table_tag="tag ({{ target.name }}_DBTGOVERN.TAGS.PII_TAG_COLUMN = 'name')"
) }}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    CAST("id" AS INT)    AS "id",
    CAST("date" AS DATE) AS "date",
    "reviewer_name"      AS "reviewer_name",
    "comments"           AS "comments"
FROM
    {{ source('LANDING_AIRBNB', 'AirBnBReviews') }}