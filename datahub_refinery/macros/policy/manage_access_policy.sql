{% macro manage_access_policy() %}
    
    {# Prevents accidental usage on other resource type #}
    {% if model.resource_type not in ['model', 'snapshot'] %}
        {{ exceptions.raise_compiler_error("manage_access_policy can only be used on models and snapshots") }}
    {% endif %}

    {# Remove existing row access policy #}
    ALTER TABLE {{ this }} DROP ALL ROW ACCESS POLICIES;
    
    {# Fetch configuration from the model config #}
    {% set rap = config.get('access_policy') %}
  
    {% if rap %}
    
        {# Validate rap mandatory fields exists and not empty #}
        {% if not rap.name %}
            {{ exceptions.raise_compiler_error("access_policy must include a non-empty 'name'") }}
        {% endif %}

        {% if not rap.columns %}
            {{ exceptions.raise_compiler_error("access_policy must include a non-empty 'columns'") }}
        {% endif %}
    
        {% set cols = rap.columns | map('tojson') | join(', ') %}

        {# Apply configured row access policy #}
        ALTER TABLE {{ this }}
        ADD ROW ACCESS POLICY {{ (target.name ~ '_DBTGOVERN') | upper }}.POLICIES."{{ rap.name }}"
        ON ({{ cols }});
        
    {% endif %}
    
{% endmacro %}