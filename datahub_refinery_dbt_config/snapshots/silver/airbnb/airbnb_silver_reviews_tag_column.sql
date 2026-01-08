{% snapshot airbnb_silver_reviews_tag_column %}

{{ config(alias='AirBnBReviews_TagColumn') }}

SELECT
    CURRENT_TIMESTAMP    AS SYSLOADDATE,
    '{{ project_name }}' AS SYSDATAPROCESSORNAME,
    "id",
    "date",
    "reviewer_name",
    "comments"
from {{ ref('airbnb_bronze_reviews_tag_column') }}

{% endsnapshot %}
