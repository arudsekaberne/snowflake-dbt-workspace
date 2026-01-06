{{ config(alias = 'MASKING_POLICY_VIEW') }}

SELECT
    CURRENT_TIMESTAMP                                             AS SYSLOADDATE,
    '{{ invocation_id }}'                                         AS SYSRUNID,
    'DBT'                                                         AS SYSPROCESSINGTOOL,
    '{{ project_name }}'                                          AS SYSDATAPROCESSORNAME,
    CONCAT('{{ target.name | upper }}', '_', TRIM(DATABASE_NAME)) AS DATABASE_NAME,
    TRIM(SCHEMA_NAME)                                             AS SCHEMA_NAME,
    TRIM(OBJECT_NAME)                                             AS OBJECT_NAME,
    TRIM(COLUMN_NAME)                                             AS COLUMN_NAME,
    TRIM(POLICY_NAME)                                             AS POLICY_NAME,
    TRANSFORM(SPLIT(POLICY_USING, '|'), POLICY -> TRIM(POLICY))   AS POLICY_USING
FROM
    {{ ref('masking_policy') }}