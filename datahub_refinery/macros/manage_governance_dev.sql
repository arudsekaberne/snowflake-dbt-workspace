{% macro manage_governance_dev() %}

    {% if execute %}
    
        {# Macro constants #}
        {% set model = graph.nodes[model.unique_id] %}
        {% set object_type = 'VIEW' if model.config.materialized == 'view' else 'TABLE' %}
        
        {# Manage dynamic masking policy #}
        {# custom_masking_policy_dev(model, object_type) #}

        {# Manage tags #}
        {# custom_tags_model_dev(model, object_type) #}
        {# custom_tags_column_dev(model, object_type) #}
        
        {# Manage row access policy #}
        {{ custom_access_policy_dev(model, object_type) }}
        
    {% endif %}
    
{% endmacro %}