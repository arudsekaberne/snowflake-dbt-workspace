{% macro generate_schema_name(custom_schema_name, node) -%}

    {# Dynamically generates the schema name based on the model’s directory structure. #}
    {{ node.original_file_path.strip().upper().split('/')[-2] }}

{%- endmacro %}