{% macro manage_governance() %}

    {% if execute %}

        {{ log_info('*** Manage Governance (Custom Catalog) ***') }}
    
        {# Macro constants #}
        {% set model = graph.nodes[model.unique_id] %}
        {% set object_type = 'VIEW' if model.config.materialized == 'view' else 'TABLE' %}
        
        {# Manage row access policy #}
        {{ custom_row_access_policy(object_type) }}
        
        {# Manage dynamic masking policy #}
        {{ custom_masking_policy(object_type) }}

        {# Manage tags #}
        {{ custom_tags_column(object_type) }}
        {{ custom_tags_object(object_type) }}
        
    {% endif %}
    
{% endmacro %}