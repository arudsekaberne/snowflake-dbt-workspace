{% macro custom_access_policy_adm(object_type) %}

    {{ log_info('Custom access policy (admin)') }}
    {{ log_start() }}
    
    {# Unset row access policy #}
    ALTER {{ object_type }} {{ this }}
    DROP ALL ROW ACCESS POLICIES
    ;
    
    {{ log_info('UNSET (default)') }}
    
    {# Set row access policy #}
    {% set policy_catalog_sql %}
    
        SELECT
            POLICY_NAME, POLICY_ON
        FROM {{ target.name | upper }}_DBTGOVERN.CATALOG.ROW_ACCESS_POLICY_VIEW
        WHERE DATABASE_NAME = '{{ model.database }}'
          AND SCHEMA_NAME = '{{ model.schema }}'
          AND OBJECT_NAME = '{{ model.alias }}'
        ;
        
    {% endset %}
    
    {% set policy_catalog_result =  run_query(policy_catalog_sql) %}
    
    {% for row in policy_catalog_result.rows %}

        {% set policy_name = row[0] %}
        {% set policy_on   = row[1] %}

        ALTER {{ object_type }} {{ this }}
        ADD ROW ACCESS POLICY
              {{ target.name | upper }}_DBTGOVERN.POLICIES."{{ policy_name }}"
          ON ({{ fromjson(policy_on) | map("tojson") | join(", ") }})
        ;

        {{ log_info('SET') }}
    
    {% endfor %}

    {{ log_end() }}
    
{% endmacro %}