{% macro custom_tags_column_adm(object_type) %}

    {{ log_info('Tags: Column') }}
    {{ log_start() }}
    
    {# Unset tags #}
    {% if object_type == 'TABLE' %}
    
        {% set tag_reference_sql %}
        
            SELECT COLUMN_NAME, TAG_NAME FROM TABLE (
                {{ model.database }}.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS (
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

    {% endif %}
    
    {# Set tags #}
    {% set catalog_sql %}
    
        SELECT
            COLUMN_NAME, TAG_NAME, TAG_VALUE
        FROM {{ target.name | upper }}_DBTGOVERN.CATALOG.TAGS_ON_COLUMN_VIEW
        WHERE DATABASE_NAME = '{{ model.database }}'
          AND SCHEMA_NAME = '{{ model.schema }}'
          AND OBJECT_NAME = '{{ model.alias }}'
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