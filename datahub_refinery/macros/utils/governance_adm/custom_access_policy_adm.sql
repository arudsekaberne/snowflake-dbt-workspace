{% macro custom_access_policy_adm(model_context) %}

    {{ log_info('Row access policy') }}
    {{ log_start() }}

    {# Flat macro arguments #}
    {% set database = model_context['database'] %}
    {% set schema = model_context['schema'] %}
    {% set object_name = model_context['object_name'] %}
    {% set object_type = model_context['object_type'] %}
    
    {# Unset row access policy #}
    {% set policy_reference_sql %}
    
        SELECT REF_COLUMN_NAME FROM TABLE (
            {{ database }}.INFORMATION_SCHEMA.POLICY_REFERENCES (
                ref_entity_name   => '{{ this }}',
                ref_entity_domain => '{{ object_type }}'
            )
        )
        WHERE POLICY_KIND = 'ROW_ACCESS_POLICY'
        ;
        
    {% endset %}
    
    {% set policy_reference_result =  run_query(policy_reference_sql) %}
    
    {% if policy_reference_result %}
    
        ALTER {{ object_type }} {{ this }}
        DROP ALL ROW ACCESS POLICIES
        ;

        {{ log_info('UNSET') }}
    
    {% endif %}
    
    {# Set row access policy #}
    {% set catalog_sql %}
    
        SELECT
            POLICY_NAME, POLICY_ON
        FROM {{ target.name | upper }}_DBTGOVERN.CATALOG.ROW_ACCESS_POLICY_VIEW
        WHERE DATABASE_NAME = '{{ database }}'
          AND SCHEMA_NAME = '{{ schema }}'
          AND OBJECT_NAME = '{{ object_name }}'
        ;
        
    {% endset %}
    
    {% set catalog_result =  run_query(catalog_sql) %}
    
    {% for row in catalog_result.rows %}

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