{% snapshot airbnb_silver_reviews %}

{{ config(
    alias='AirBnBReviews',
    post_hook = "{{ manage_access_policy() }}"
) }}

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
    "comments"
from {{ ref('airbnb_bronze_reviews') }}

{% endsnapshot %}
