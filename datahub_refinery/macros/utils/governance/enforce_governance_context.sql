{% macro enforce_governance_context () %}

    {# Macro constants #}
    {% set supported_resources = ['model', 'snapshot'] %}
    {% set supported_materializations = ['table', 'view', 'snapshot', 'incremental', 'dynamic_table'] %}
    
    {# Supported dbt resources #}
    {% if model.resource_type not in supported_resources %}
        {{ exceptions.raise_compiler_error (
            "This macro can only be used on resources: " ~ supported_resources | join(', ')
        ) }}
    {% endif %}
    
    {# Supported materializations #}
    {% if model.config.materialized not in supported_materializations %}
        {{ exceptions.raise_compiler_error (
            "This macro can only be used on materializations: " ~ supported_materializations | join(', ')
        ) }}
    {% endif %}

{% endmacro %}
