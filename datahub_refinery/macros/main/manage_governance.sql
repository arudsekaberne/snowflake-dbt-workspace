{% macro manage_governance() %}

    {% if not execute %}
    
        {# Prevent unsafe invocation #}
        {{ enforce_governance_context() }}
        
    {% endif %}

    {% if execute %}
    
        {# Macro constants #}
        {% set model = graph.nodes[model.unique_id] %}
        {% set object_type = 'VIEW' if model.config.materialized == 'view' else 'TABLE' %}
        
        {# Manage dynamic masking policy #}
        {{ custom_masking_policy(model, object_type) }}

        {# Manage tags #}
        {{ custom_tags(model, object_type) }}
        
        {# Manage row access policy #}
        {{ custom_access_policy(model, object_type) }}
        
    {% endif %}
    
{% endmacro %}