{% macro custom_row_access_policy_dev(model, object_type) %}

    {{ log_info('Row access policy') }}
    {{ log_start() }}
    
    {# Unset row access policy #}
    {% set policy_reference_sql %}
    
        SELECT REF_COLUMN_NAME FROM TABLE (
            {{ model.database }}.INFORMATION_SCHEMA.POLICY_REFERENCES (
                ref_entity_name   => '{{ this }}',
                ref_entity_domain => '{{ object_type }}'
            )
        )
        WHERE POLICY_KIND = 'ROW_ACCESS_POLICY'
        ;
        
    {% endset %}
    
    {% set policy_reference_result =  run_query(policy_reference_sql) %}
    
    {% if policy_reference_result %}
    
        ALTER {{ object_type }} {{ this }}
        DROP ALL ROW ACCESS POLICIES
        ;

        {{ log_info('UNSET') }}
    
    {% endif %}
    
    {# Set row access policy #}
    {% set policy = model.config.custom_row_access_policy %}
  
    {% if policy %}
    
        {# Validate required configuration values #}
        {% if not policy.name %}
            {{ exceptions.raise_compiler_error('Missing access policy name. Set custom_row_access_policy.name to a non-empty string.') }}
        {% endif %}

        {% if not policy.columns %}
            {{ exceptions.raise_compiler_error('Missing access policy columns. Set custom_row_access_policy.columns to a non-empty list of column names.') }}
        {% endif %}
        
        ALTER {{ object_type }} {{ this }}
        ADD ROW ACCESS POLICY
              {{ target.name | upper }}_DBTGOVERN.POLICIES."{{ policy.name }}"
          ON ({{ policy.columns | map("tojson") | join(", ") }})
        ;

        {{ log_info('SET') }}
        
    {% endif %}

    {{ log_end() }}
    
{% endmacro %}