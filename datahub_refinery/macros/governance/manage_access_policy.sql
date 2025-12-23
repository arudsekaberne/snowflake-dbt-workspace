{% macro manage_access_policy() %}

    {# Prevent accidential usage #}
    {{ manage_usage_policy( macro_name = 'manage_access_policy' ) }}

    {# Get target schema object #}
    {% set target_object = 'VIEW' if model.config.materialized == 'view' else 'TABLE' %}
    
    {# Remove existing row access policy #}
    ALTER {{ target_object }} {{ this }} DROP ALL ROW ACCESS POLICIES;
    
    {# Fetch configuration from the model config #}
    {% set rap = config.get('custom_access_policy') %}
  
    {% if rap %}
    
        {# Validate rap mandatory fields exists and not empty #}
        {% if not rap.name %}
            {{ exceptions.raise_compiler_error("custom_access_policy must include a non-empty 'name'") }}
        {% endif %}
        
        {% if not rap.columns %}
            {{ exceptions.raise_compiler_error("custom_access_policy must include a non-empty 'columns'") }}
        {% endif %}
        
        {# Apply configured row access policy #}
        {% set cols = rap.columns | map('tojson') | join(', ') %}
        
        ALTER {{ target_object }} {{ this }}
        ADD ROW ACCESS POLICY
              {{ target.name | upper }}_DBTGOVERN.POLICIES."{{ rap.name }}"
          ON ({{ cols }})
        ;
        
    {% endif %}
    
{% endmacro %}