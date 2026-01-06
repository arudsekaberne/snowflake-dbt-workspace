{% macro manage_governance_adm() %}

    {% if execute %}

        {{ log_info('*** Manage Governance (Admin) ***') }}
    
        {# Macro constants #}
        {% set model = graph.nodes[model.unique_id] %}
        
        {% set model_context = {
              'database'    : model.database,
              'schema'      : model.schema,
              'object_name' : model.alias,
              'object_type' : 'VIEW' if model.config.materialized == 'view' else 'TABLE'
            }
        %}
        
        {# Manage row access policy #}
        {{ custom_access_policy_adm(model_context) }}

        {# Manage dynamic masking policy #}
        {{ custom_masking_policy_adm(model_context) }}

        {# Manage tags #}
        {{ custom_tags_column_adm(model_context) }}
        {{ custom_tags_object_adm(model_context) }}
        
    {% endif %}
    
{% endmacro %}