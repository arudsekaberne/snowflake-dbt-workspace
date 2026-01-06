{% macro custom_tags_column_adm(model_context) %}

    {{ log_info('Tags: Column') }}
    {{ log_start() }}

    {# Flat macro arguments #}
    {% set database = model_context['database'] %}
    {% set schema = model_context['schema'] %}
    {% set object_name = model_context['object_name'] %}
    {% set object_type = model_context['object_type'] %}
    
    {# Unset tags #}
    {% set tag_reference_sql %}
    
        SELECT COLUMN_NAME, TAG_NAME FROM TABLE (
            {{ database }}.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS (
                '{{ this }}',
                '{{ object_type }}'
            )
        )
        WHERE LEVEL = 'COLUMN'
        ;
        
    {% endset %}
    
    {% set tag_reference_result =  run_query(tag_reference_sql) %}
    
    {% for row in tag_reference_result.rows %}
    
        ALTER {{ object_type }} {{ this }}
        MODIFY COLUMN "{{ row[0] }}"
        UNSET TAG {{ target.name | upper }}_DBTGOVERN.TAGS."{{ row[1] }}"
        ;

        {{ log_info('UNSET column ' ~ tojson(row[0])) }}
    
    {% endfor %}
    
    {# Set tags #}
    {% set catalog_sql %}
    
        SELECT
            COLUMN_NAME, TAG_NAME, TAG_VALUE
        FROM {{ target.name | upper }}_DBTGOVERN.CATALOG.TAGS_ON_COLUMN_VIEW
        WHERE DATABASE_NAME = '{{ database }}'
          AND SCHEMA_NAME = '{{ schema }}'
          AND OBJECT_NAME = '{{ object_name }}'
        ;
        
    {% endset %}
    
    {% set catalog_result =  run_query(catalog_sql) %}
    
    {% for row in catalog_result.rows %}

        {% set column_name  = row[0] %}
        {% set tag_name     = row[1] %}
        {% set tag_value    = row[2] %}

        ALTER {{ object_type }} {{ this }}
        MODIFY COLUMN "{{ column_name }}"
        SET TAG {{ target.name | upper }}_DBTGOVERN.TAGS."{{ tag_name }}" = '{{ tag_value }}'
        ;

        {{ log_info('SET column ' ~ tojson(column_name)) }}

    {% endfor %}

    {{ log_end() }}
    
{% endmacro %}