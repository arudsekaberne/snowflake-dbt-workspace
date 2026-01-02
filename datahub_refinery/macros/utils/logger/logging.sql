{% macro log_start() %}

    {{ log('╭────────────────────── start ──────────────────────╮', info=True) }}

{% endmacro %}

{% macro log_info(message) %}

    {{ log(message, info=True) }}

{% endmacro %}

{% macro log_end() %}

    {{ log('╰─────────────────────── end ───────────────────────╯', info=True) }}

{% endmacro %}