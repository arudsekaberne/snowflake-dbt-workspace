{% macro custom_masking_policy(model, object_type) %}

    {# Unset masking policies #}
    {% set policy_reference_sql %}
    
        SELECT REF_COLUMN_NAME FROM TABLE(
            {{ model.database }}.INFORMATION_SCHEMA.POLICY_REFERENCES(
                ref_entity_name   => '{{ this }}',
                ref_entity_domain => '{{ object_type }}'
            )
        )
        WHERE POLICY_KIND = 'MASKING_POLICY' AND TAG_NAME IS NULL
        ;
        
    {% endset %}
    
    {% set policy_reference_result =  run_query(policy_reference_sql) %}
    
    {% for row in policy_reference_result.rows %}
    
        ALTER {{ object_type }} {{ this }}
        MODIFY COLUMN "{{ row[0] }}"
        UNSET MASKING POLICY
        ;
    
    {% endfor %}
    
    {# Set masking policies #}
    {% for column in model.columns.values() %}

        {% set policy = column.config.custom_masking_policy %}
        
        {% if policy %}
            
            {% if not policy.name %}
                {{ exceptions.raise_compiler_error('Missing masking policy name. Set custom_masking_policy.name to a non-empty string for column ' ~ tojson(column.name) ) }}
            {% endif %}
        
            ALTER {{ object_type }} {{ this }}
            MODIFY COLUMN "{{ column.name }}"
                SET MASKING POLICY {{ target.name | upper }}_DBTGOVERN.POLICIES."{{ policy.name }}"
            
            {% if policy.using %}
                USING ({{ ([ column.name ] + policy.using) | map("tojson") | join(", ") }})
            {% endif %}
            ;
        
        {% endif %}
        
    {% endfor %}
    
{% endmacro %}