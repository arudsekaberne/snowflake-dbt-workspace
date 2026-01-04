{% macro manage_governance_adm() %}

    {% if execute %}
    
        {# Macro constants #}
        {% set model = graph.nodes[model.unique_id] %}
        {% set object_type = 'VIEW' if model.config.materialized == 'view' else 'TABLE' %}
        
        {# Manage row access policy #}
        {{ custom_access_policy_adm(object_type) }}
        
    {% endif %}
    
{% endmacro %}