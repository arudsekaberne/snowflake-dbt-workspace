{% macro _validate_usage_policy (
    macro_name,
    selected_resources        = ['model', 'snapshot'],
    selected_materializations = ['table', 'view', 'snapshot', 'incremental', 'dynamic_table']
) %}

    {# Ensure the macro is used only on supported dbt resources #}
    {% if model.resource_type not in selected_resources %}
        {{ exceptions.raise_compiler_error (
            macro_name ~ " can only be used on resources: " ~ selected_resources | join(', ')
        ) }}
    {% endif %}

    {# Ensure the macro is used only on supported materializations #}
    {% if model.config.materialized not in selected_materializations %}
        {{ exceptions.raise_compiler_error (
            macro_name ~ " can only be used on materializations: " ~ selected_materializations | join(', ')
        ) }}
    {% endif %}

{% endmacro %}
