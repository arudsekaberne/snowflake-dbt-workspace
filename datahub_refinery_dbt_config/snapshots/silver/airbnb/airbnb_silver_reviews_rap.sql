{% snapshot airbnb_silver_reviews_rap %}

{{ config(alias='AirBnBReviews_Rap') }}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    "id",
    "date",
    "reviewer_name",
    "comments"
from {{ ref('airbnb_bronze_reviews_rap') }}

{% endsnapshot %}
