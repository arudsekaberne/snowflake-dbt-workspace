{% macro custom_masking_policy_adm(model_context) %}

    {{ log_info('Masking policies') }}
    {{ log_start() }}

    {# Flat macro arguments #}
    {% set database = model_context['database'] %}
    {% set schema = model_context['schema'] %}
    {% set object_name = model_context['object_name'] %}
    {% set object_type = model_context['object_type'] %}
    
    {# Unset masking policies #}
    {% set policy_reference_sql %}
    
        SELECT REF_COLUMN_NAME FROM TABLE (
            {{ database }}.INFORMATION_SCHEMA.POLICY_REFERENCES (
                ref_entity_name   => '{{ this }}',
                ref_entity_domain => '{{ object_type }}'
            )
        )
        WHERE POLICY_KIND = 'MASKING_POLICY' AND TAG_NAME IS NULL
        ;
        
    {% endset %}
    
    {% set policy_reference_result =  run_query(policy_reference_sql) %}
    
    {% for row in policy_reference_result.rows %}
    
        ALTER {{ object_type }} {{ this }}
        MODIFY COLUMN "{{ row[0] }}"
        UNSET MASKING POLICY
        ;

        {{ log_info('UNSET column ' ~ tojson(row[0])) }}
    
    {% endfor %}
    
    {# Set masking policies #}
    {% set catalog_sql %}
    
        SELECT
            COLUMN_NAME, POLICY_NAME, POLICY_USING
        FROM {{ target.name | upper }}_DBTGOVERN.CATALOG.MASKING_POLICY_VIEW
        WHERE DATABASE_NAME = '{{ database }}'
          AND SCHEMA_NAME = '{{ schema }}'
          AND OBJECT_NAME = '{{ object_name }}'
        ;
        
    {% endset %}
    
    {% set catalog_result =  run_query(catalog_sql) %}
    
    {% for row in catalog_result.rows %}

        {% set column_name  = row[0] %}
        {% set policy_name  = row[1] %}
        {% set policy_using = row[2] %}

        ALTER {{ object_type }} {{ this }}
        MODIFY COLUMN "{{ column_name }}"
            SET MASKING POLICY {{ target.name | upper }}_DBTGOVERN.POLICIES."{{ policy_name }}"
        
        {% if policy_using %}
            USING ({{ ([ column_name ] + fromjson(policy_using)) | map("tojson") | join(", ") }})
        {% endif %}
        ;

        {{ log_info('SET column ' ~ tojson(column_name)) }}
    
    {% endfor %}

    {{ log_end() }}
    
{% endmacro %}