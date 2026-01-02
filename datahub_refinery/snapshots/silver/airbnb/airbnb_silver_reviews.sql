{% snapshot airbnb_silver_reviews %}

{{ config(alias='AirBnBReviews') }}

SELECT
    CURRENT_TIMESTAMP       AS SYSLOADDATE,
    '{{ invocation_id }}'   AS SYSRUNID,
    'DBT'                   AS SYSPROCESSINGTOOL,
    '{{ project_name }}'    AS SYSDATAPROCESSORNAME,
    SYSSOURCE,
    "listing_id",
    "id",
    "date",
    "reviewer_id",
    "reviewer_name",
    "reviewer_name" AS "reviewer_name_2",
    "comments"
from {{ ref('airbnb_bronze_reviews') }}

{% endsnapshot %}
