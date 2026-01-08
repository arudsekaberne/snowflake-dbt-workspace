{{ config(
    alias='AirBnBReviews_Rap',
    row_access_policy = '{{ target.name }}_DBTGOVERN.POLICIES.SPECIFIC_YEAR_ACCESS_POLICY on ("date")'
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