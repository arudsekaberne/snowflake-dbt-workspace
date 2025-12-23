{% macro manage_masking_policy() %}
    
    {# Prevent accidential usage #}
    {{ manage_usage_policy( macro_name = 'manage_masking_policy' ) }}
    
{% endmacro %}