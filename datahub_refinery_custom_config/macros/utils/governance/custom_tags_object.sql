{% macro custom_tags_object(model, object_type) %}

    {{ log_info('Tags: Object') }}
    {{ log_start() }}
    
    {# Unset tags #}
    {% if object_type == 'TABLE' %}
    
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
        
    {% endif %}
    
    {# Set tags #}
    {% set tags_config = model.config.custom_tags %}

    {% for tag in tags_config %}

        {# Validate required configuration values #}
        {% if not tag.name %}
            {{ exceptions.raise_compiler_error('Missing tag name. Set custom_tags[i].name to a non-empty string') }}
        {% endif %}

        {% if not tag.value %}
            {{ exceptions.raise_compiler_error('Missing tag value. Set custom_tags[i].value to a non-empty string') }}
        {% endif %}
 
        ALTER {{ object_type }} {{ this }}
        SET TAG {{ target.name | upper }}_DBTGOVERN.TAGS."{{ tag.name }}" = '{{ tag.value }}'
        ;

        {{ log_info('SET ' ~ tojson(tag.name)) }}
        
    {% endfor %}

    {{ log_end() }}
    
{% endmacro %}