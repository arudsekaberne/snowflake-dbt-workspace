{% macro manage_governance_adm() %}

    {% if execute %}

        {{ log_info('*** Manage Governance (Admin) ***') }}
    
        {# Macro constants #}
        {% set model = graph.nodes[model.unique_id] %}
        {% set object_type = 'VIEW' if model.config.materialized == 'view' else 'TABLE' %}
        
        {# Manage row access policy #}
        {{ custom_row_access_policy_adm(object_type) }}

        {# Manage dynamic masking policy #}
        {{ custom_masking_policy_adm(object_type) }}

        {# Manage tags #}
        {{ custom_tags_column_adm(object_type) }}
        {{ custom_tags_object_adm(object_type) }}
        
    {% endif %}
    
{% endmacro %}