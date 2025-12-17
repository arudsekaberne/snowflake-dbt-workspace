{% macro apply_row_access_policy() %}

    {# Fetch configuration from the model config #}
    {% set rap = config.get('row_access_policy') %}
    
    {% if rap %}
    
        {# Validate rap mandatory fields exists and not empty #}
        {% if not rap.name %}
            {{ exceptions.raise_compiler_error("row_access_policy must include a non-empty 'name'") }}
        {% endif %}

        {% if not rap.columns %}
            {{ exceptions.raise_compiler_error("row_access_policy must include a non-empty 'columns'") }}
        {% endif %}
    
        {% set cols = rap.columns | map('tojson') | join(', ') %}

        {# Remove existing row access policy #}
        ALTER TABLE {{ this }} DROP ALL ROW ACCESS POLICIES;

        {# Apply configured row access policy #}
        ALTER TABLE {{ this }}
        ADD ROW ACCESS POLICY {{ (target.name ~ '_DBTGOVERN') | upper }}.POLICIES."{{ rap.name }}"
        ON ({{ cols }});
        
    {% endif %}
{% endmacro %}