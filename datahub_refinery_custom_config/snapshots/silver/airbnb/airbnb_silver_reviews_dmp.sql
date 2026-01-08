{% snapshot airbnb_silver_reviews_dmp %}

{{ config(alias='AirBnBReviews_Dmp') }}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    "id",
    "date",
    "reviewer_name",
    "comments"
from {{ ref('airbnb_bronze_reviews_dmp') }}

{% endsnapshot %}
