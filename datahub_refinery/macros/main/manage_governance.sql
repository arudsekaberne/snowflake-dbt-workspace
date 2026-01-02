{% macro manage_governance() %}

    {% if execute %}
    
        {# Macro constants #}
        {% set model = graph.nodes[model.unique_id] %}
        {% set object_type = 'VIEW' if model.config.materialized == 'view' else 'TABLE' %}
        
        {# Manage dynamic masking policy #}
        {{ custom_masking_policy(model, object_type) }}

        {# Manage tags #}
        {{ custom_tags_model(model, object_type) }}
        {{ custom_tags_column(model, object_type) }}
        
        {# Manage row access policy #}
        {{ custom_access_policy(model, object_type) }}
        
    {% endif %}
    
{% endmacro %}