{% macro get_current_time (timezone) %}

    {# Output datetime format #}
    {% set time_format = '%Y-%m-%d %I:%M:%S.%f %p (%Z)' %}
    
    {# Get current UTC time #}
    {% set cur_time = modules.datetime.datetime.utcnow() %}
    {% set out_time = modules.pytz.utc.localize(cur_time) %}

    {# Convert from UTC to the requested timezone #}
    {% if timezone %}
        {% set out_time = out_time.astimezone(modules.pytz.timezone(timezone)) %}
    {% endif %}

    {# Return formatted timestamp string #}
    {{ return (out_time.strftime(time_format)) }}

{% endmacro %}