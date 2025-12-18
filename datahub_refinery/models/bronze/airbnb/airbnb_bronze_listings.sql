{{ config(alias = 'AirBnBListings') }}

SELECT
    CURRENT_TIMESTAMP                               AS SYSLOADDATE,
    '{{ invocation_id }}'                           AS SYSRUNID,
    'DBT'                                           AS SYSPROCESSINGTOOL,
    '{{ project_name }}'                            AS SYSDATAPROCESSORNAME,
    "SYSSOURCE"                                     AS SYSSOURCE,
    CAST("id" AS INT)                               AS "id",
    "name"                                          AS "name",
    CAST("host_id" AS INT)                          AS "host_id",
    "host_name"                                     AS "host_name",
    "neighbourhood_group"                           AS "neighbourhood_group",
    "neighbourhood"                                 AS "neighbourhood",
    CAST("latitude" AS NUMBER(17, 15))              AS "latitude",
    CAST("longitude" AS NUMBER(24, 21))             AS "longitude",
    "room_type"                                     AS "room_type",
    CAST("price" AS INT)                            AS "price",
    CAST("minimum_nights" AS INT)                   AS "minimum_nights",
    CAST("number_of_reviews" AS INT)                AS "number_of_reviews",
    CAST("last_review" AS DATE)                     AS "last_review",
    CAST("reviews_per_month" AS NUMBER(5, 2))       AS "reviews_per_month",
    CAST("calculated_host_listings_count" AS INT)   AS "calculated_host_listings_count",
    CAST("availability_365" AS INT)                 AS "availability_365",
    CAST("number_of_reviews_ltm" AS INT)            AS "number_of_reviews_ltm",
    "license"
FROM
    {{ source('LANDING_AIRBNB', 'AirBnBListings') }}