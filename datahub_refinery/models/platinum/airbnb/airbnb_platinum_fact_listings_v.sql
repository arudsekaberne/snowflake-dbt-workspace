{{ config( alias='FACT_AIRBNBLISTINGS_VIEW' ) }}

SELECT
    *
FROM {{ ref('airbnb_gold_fact_listings') }}