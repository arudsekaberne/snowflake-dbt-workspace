{{ config(alias = 'MASKING_POLICY_VIEW') }}

SELECT
    'DBT'                                                         AS SYSPROCESSINGTOOL,
    '{{ project_name }}'                                          AS SYSDATAPROCESSORNAME,
    CONCAT(
        '{{ target.name | upper }}', '_',
        REGEXP_REPLACE(UPPER(TRIM(DATABASE_NAME)), '^(DEV|TEST|PREPROD|PROD)_', '')
    )                                                             AS DATABASE_NAME,
    TRIM(SCHEMA_NAME)                                             AS SCHEMA_NAME,
    TRIM(OBJECT_NAME)                                             AS OBJECT_NAME,
    TRIM(COLUMN_NAME)                                             AS COLUMN_NAME,
    TRIM(POLICY_NAME)                                             AS POLICY_NAME,
    TRANSFORM(SPLIT(POLICY_USING, '|'), POLICY -> TRIM(POLICY))   AS POLICY_USING
FROM
    {{ ref('masking_policy') }}