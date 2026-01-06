{{ config(alias='AirBnBReviews_TagTable') }}

SELECT
    CURRENT_TIMESTAMP           AS SYSLOADDATE,
    '{{ invocation_id }}'       AS SYSRUNID,
    'DBT'                       AS SYSPROCESSINGTOOL,
    '{{ project_name }}'        AS SYSDATAPROCESSORNAME,
    "SYSSOURCE"                 AS SYSSOURCE,
    CAST("listing_id" AS INT)   AS "listing_id",
    CAST("id" AS INT)           AS "id",
    CAST("date" AS DATE)        AS "date",
    CAST("reviewer_id" AS INT)  AS "reviewer_id",
    "reviewer_name"             AS "reviewer_name",
    "comments"                  AS "comments"
FROM
    {{ source('LANDING_AIRBNB', 'AirBnBReviews') }}