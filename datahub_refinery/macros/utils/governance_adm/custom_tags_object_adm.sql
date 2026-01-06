{% macro custom_tags_object_adm(object_type) %}

    {{ log_info('Tags: Object') }}
    {{ log_start() }}
    
    {# Unset tags #}
    {% set tag_reference_sql %}
        
        SELECT TAG_NAME FROM TABLE (
            {{ model.database }}.INFORMATION_SCHEMA.TAG_REFERENCES (
                '{{ this }}',
                '{{ object_type }}'
            )
        );
        
    {% endset %}
    
    {% set tag_reference_result =  run_query(tag_reference_sql) %}
    
    {% for row in tag_reference_result.rows %}
    
        ALTER {{ object_type }} {{ this }}
        UNSET TAG {{ target.name | upper }}_DBTGOVERN.TAGS."{{ row[0] }}"
        ;

        {{ log_info('UNSET ' ~ tojson(row[0])) }}
    
    {% endfor %}
    
    {# Set tags #}
    {% set catalog_sql %}
    
        SELECT
            TAG_NAME, TAG_VALUE
        FROM {{ target.name | upper }}_DBTGOVERN.CATALOG.TAGS_ON_OBJECT_VIEW
        WHERE DATABASE_NAME = '{{ model.database }}'
          AND SCHEMA_NAME = '{{ model.schema }}'
          AND OBJECT_NAME = '{{ model.alias }}'
        ;
        
    {% endset %}
    
    {% set catalog_result =  run_query(catalog_sql) %}
    
    {% for row in catalog_result.rows %}

        {% set tag_name  = row[0] %}
        {% set tag_value = row[1] %}

        ALTER {{ object_type }} {{ this }}
        SET TAG {{ target.name | upper }}_DBTGOVERN.TAGS."{{ tag_name }}" = '{{ tag_value }}'
        ;

        {{ log_info('SET ' ~ tojson(tag_name)) }}

    {% endfor %}

    {{ log_end() }}
    
{% endmacro %}