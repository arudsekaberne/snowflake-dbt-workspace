{{ config(alias = 'ROW_ACCESS_POLICY_VIEW') }}

SELECT
    'DBT'                                                         AS SYSPROCESSINGTOOL,
    '{{ project_name }}'                                          AS SYSDATAPROCESSORNAME,
    CONCAT('{{ target.name | upper }}', '_', TRIM(DATABASE_NAME)) AS DATABASE_NAME,
    TRIM(SCHEMA_NAME)                                             AS SCHEMA_NAME,
    TRIM(OBJECT_NAME)                                             AS OBJECT_NAME,
    TRIM(POLICY_NAME)                                             AS POLICY_NAME,
    TRANSFORM(SPLIT(POLICY_ON, '|'), POLICY -> TRIM(POLICY))      AS POLICY_ON
FROM
    {{ ref('row_access_policy') }}