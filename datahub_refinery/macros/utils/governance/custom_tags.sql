{% macro custom_tags() %}
    
    {# Guardrail: Prevent unsafe invocation #}
    {{ enforce_governance_context() }}

    {# Get target schema object #}
    {% set target_object = 'VIEW' if model.config.materialized == 'view' else 'TABLE' %}
    
    {% if execute %}

        {# Unset columns with existing masking policies #}
        {% set tag_reference_sql %}

            SELECT
                COLUMN_NAME, TAG_NAME
            FROM TABLE(
                {{ model.database }}.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
                    '{{ model.relation_name }}',
                    'TABLE'
                )
            )
            WHERE LEVEL = 'COLUMN'
            ;
            
        {% endset %}
        
        {% set tag_reference_result =  run_query(tag_reference_sql) %}
        
        {% for row in tag_reference_result.rows %}
        
            ALTER {{ target_object }} {{ model.relation_name }}
            MODIFY COLUMN "{{ row[0] }}"
                UNSET TAG {{ target.name | upper }}_DBTGOVERN.TAGS."{{ row[1] }}"
            ;
        
        {% endfor %}
        
        {# Set columns masking policy #}
        {% set defined_columns = graph.nodes[model.unique_id].get('columns') %}
        
        {% for value in defined_columns.values()%}

            {% set tag_column = value['name'] %}
            {% set tags_config = value.get('config', {}).get('custom_tags', []) %}
            {{ log('Tag config: ' ~ tags_config, info=True) }}

            {% for tag in tags_config %}

                    {% set tag_name   = tag.get('name') %}
                    {% set tag_value  = tag.get('value') %}
    
                    {% if not tag_name %}
                        {{ exceptions.raise_compiler_error("Tag must define 'name' for column '" ~ tag_column ~ "'") }}
                    {% endif %}
    
                    {% if not tag_value %}
                        {{ exceptions.raise_compiler_error("Tag must define 'value' for column '" ~ tag_column ~ "'") }}
                    {% endif %}
        
                    ALTER {{ target_object }} {{ model.relation_name }}
                    MODIFY COLUMN "{{ tag_column }}"
                        SET TAG {{ target.name | upper }}_DBTGOVERN.TAGS."{{ tag_name }}" = '{{ tag_value }}'
                    ;
            
            {% endfor %}
            
        {% endfor %}
        
    {% endif %}
    
{% endmacro %}