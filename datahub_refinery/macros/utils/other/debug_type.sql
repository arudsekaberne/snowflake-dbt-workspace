{% macro debug_type(value) %}

    {# Execution (Run operation): debug_type --args '{value: (1,2,3)}' #}

    {% if value is none %}
        {{ log_info('value => None') }}
    
    {% elif value is string %}
        {{ log_info('value => string') }}
    
    {% elif value is number %}
        {{ log_info('value => number') }}
    
    {% elif value is mapping %}
        {{ log_info('value => dict / mapping') }}
    
    {% elif value is iterable %}
        {{ log_info('value => list / iterable') }}
    
    {% else %}
        {{ log_info('value => unknown type') }}
    
    {% endif %}

{% endmacro %}
