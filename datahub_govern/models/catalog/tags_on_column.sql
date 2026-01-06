{{ config(alias = 'TAGS_ON_COLUMN_VIEW') }}

SELECT
    CURRENT_TIMESTAMP                                             AS SYSLOADDATE,
    '{{ invocation_id }}'                                         AS SYSRUNID,
    'DBT'                                                         AS SYSPROCESSINGTOOL,
    '{{ project_name }}'                                          AS SYSDATAPROCESSORNAME,
    CONCAT('{{ target.name | upper }}', '_', TRIM(DATABASE_NAME)) AS DATABASE_NAME,
    TRIM(SCHEMA_NAME)                                             AS SCHEMA_NAME,
    TRIM(OBJECT_NAME)                                             AS OBJECT_NAME,
    TRIM(COLUMN_NAME)                                             AS COLUMN_NAME,
    TRIM(TAG_NAME)                                                AS TAG_NAME,
    TRIM(TAG_VALUE)                                               AS TAG_VALUE,
FROM
    {{ ref('tags_on_column') }}