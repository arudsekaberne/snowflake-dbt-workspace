{% macro manage_masking_policy() %}
    
    {# Guardrail: prevent unsafe direct invocation #}
    {{ _validate_usage_policy( macro_name = 'manage_masking_policy' ) }}

    {# Get target schema object #}
    {% set target_object = "VIEW" if model.config.materialized == "view" else "TABLE" %}
    
    {% if execute %}

        {# Unset columns with existing masking policies #}
        {% set describe_sql %}
        
            DESC TABLE {{ model.relation_name }};
        
            SELECT "name" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
            WHERE "policy name" IS NOT NULL;
            
        {% endset %}
        
        {% set describe_sql_result =  run_query(describe_sql) %}
        
        {% for row in describe_sql_result.rows %}
        
            ALTER {{ target_object }} {{ model.relation_name }}
            MODIFY COLUMN "{{ row[0] }}" UNSET MASKING POLICY;
        
        {% endfor %}
        
        {# Set columns masking policy #}
        {% set defined_columns = graph.nodes[model.unique_id].get('columns') %}
        
        {% for value in defined_columns.values()%}

            {% set dmp = value.get('config', {}).get('custom_masking_policy') %}
            
            {% if dmp %}

                {% set policy_column = value['name'] %}
                {% set policy_name   = dmp.get('name') %}
                {% set policy_using  = dmp.get('using') %}

                {% if not policy_name %}
                    {{ exceptions.raise_compiler_error("custom_masking_policy must define 'name' for column '" ~ policy_column ~ "'") }}
                {% endif %}
    
                ALTER {{ target_object }} {{ model.relation_name }} MODIFY COLUMN "{{ policy_column }}"
                SET MASKING POLICY {{ target.name | upper }}_DBTGOVERN.POLICIES."{{ policy_name }}"
                
                {% if policy_using %}
                    USING ({{ ([ policy_column ] + policy_using) | map("tojson") | join(", ") }})
                {% endif %}
                ;
            
            {% endif %}
            
        {% endfor %}
        
    {% endif %}
    
{% endmacro %}