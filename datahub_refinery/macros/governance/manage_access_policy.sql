{% macro manage_access_policy() %}

    {# Macro variables#}
    {% set allowed_resources = ['model', 'snapshot'] %}
    {% set picked_materialization = config.get('materialized') %}
    {% set allowed_materializations = ['table', 'view', 'snapshot', 'incremental', 'dynamic_table'] %}
    
    {# Prevents accidental usage on other resource type #}
    {% if model.resource_type not in allowed_resources %}
        {{ exceptions.raise_compiler_error(
            "manage_access_policy can only be used on resources: " ~ allowed_resources | join(', ')
        ) }}
    {% endif %}

    {% if picked_materialization not in allowed_materializations %}
        {{ exceptions.raise_compiler_error(
            "manage_access_policy can only be used on materializations: " ~ allowed_materializations | join(', ')
        ) }}
    {% endif %}

    {# Get target schema object #}
    {% set target_object = 'VIEW' if picked_materialization == 'view' else 'TABLE' %}

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
    
        {% set cols = rap.columns | map('tojson') | join(', ') %}

        {# Apply configured row access policy #}
        ALTER {{ target_object }} {{ this }}
        ADD ROW ACCESS POLICY {{ (target.name ~ '_DBTGOVERN') | upper }}.POLICIES."{{ rap.name }}"
        ON ({{ cols }});
        
    {% endif %}
    
{% endmacro %}