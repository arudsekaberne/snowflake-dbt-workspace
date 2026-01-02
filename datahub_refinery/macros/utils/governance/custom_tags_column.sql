{% macro custom_tags_column (model, object_type) %}

    {{ log_info('Column Tags') }}
    {{ log_start() }}
    
    {# Unset tags #}
    {% set tag_reference_sql %}

        SELECT COLUMN_NAME, TAG_NAME FROM TABLE (
            {{ model.database }}.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS (
                '{{ this }}',
                'TABLE'
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
    {% for column in model.columns.values() %}

        {% if column.config and column.config.custom_tags %}
            
            {% set tags_config = column.config.custom_tags %}
        
            {% for tag in tags_config %}

                {# Validate required configuration values #}
                {% if not tag.name %}
                    {{ exceptions.raise_compiler_error('Missing tag name. Set custom_tags[i].name to a non-empty string for column ' ~ tojson(column.name) ) }}
                {% endif %}

                {% if not tag.value %}
                    {{ exceptions.raise_compiler_error('Missing tag value. Set custom_tags[i].value to a non-empty string for column ' ~ tojson(column.name) ) }}
                {% endif %}
    
                ALTER {{ object_type }} {{ this }}
                MODIFY COLUMN "{{ column.name }}"
                SET TAG {{ target.name | upper }}_DBTGOVERN.TAGS."{{ tag.name }}" = '{{ tag.value }}'
                ;

                {{ log_info('SET column ' ~ tojson(column.name)) }}
            
            {% endfor %}
            
        {% endif %}
        
    {% endfor %}

    {{ log_end() }}
    
{% endmacro %}