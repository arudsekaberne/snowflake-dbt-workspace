{{ config( alias='FACT_AIRBNBLISTINGS_SVIEW', secure=true ) }}

SELECT
    *
FROM {{ ref('airbnb_gold_fact_listings') }}