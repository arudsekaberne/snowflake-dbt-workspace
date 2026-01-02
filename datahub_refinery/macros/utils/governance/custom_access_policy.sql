{% macro custom_access_policy (model, object_type) %}

    {{ log_info('Custom access policy') }}
    {{ log_start() }}
    
    {# Unset row access policy #}
    ALTER {{ object_type }} {{ this }}
    DROP ALL ROW ACCESS POLICIES
    ;
    
    {{ log_info('UNSET (default)') }}
    
    {# Set row access policy #}
    {% set policy = model.config.custom_access_policy %}
  
    {% if policy %}
    
        {# Validate required configuration values #}
        {% if not policy.name %}
            {{ exceptions.raise_compiler_error('Missing access policy name. Set custom_access_policy.name to a non-empty string.') }}
        {% endif %}

        {% if not policy.columns %}
            {{ exceptions.raise_compiler_error('Missing access policy columns. Set custom_access_policy.columns to a non-empty list of column names.') }}
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