{# It was noticed that in the 2018 format, these fields were null only when corresponding fields, 
such as the building_class_at_present column, were null and they were set to 0 when a value was absent #}

{# Additionally commas were removed from the fields to facilitate aggregations on the data #}

{% macro transform_and_cast_column(column_name, building_class_column,column_type) %}
    case 
      when {{building_class_column}} is null
      then null
      else 
        case 
          when {{ column_name }} = '-' then cast(0 as {{ column_type }})
          else cast(regexp_replace({{ column_name }}, ',', '') as {{ column_type }})
        end
    end as {{ column_name }}
{% endmacro %}