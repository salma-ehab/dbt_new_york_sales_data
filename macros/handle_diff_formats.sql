{# The 2018 format, being devoid of dashes, served as a benchmark. 
Within this format, it was identified that fields pertaining to units and square feets were null 
in instances where certain dimensions, like the building_class_column, were also null. 
Nevertheless, there were occurrences where both residential and commercial units equated to zero, 
while the total units did not. Moreover, there were situations where all units registered as zero, 
yet the land square feets did not. In response to these variations, 
a decision was reached to assign null values to all units and feet when fields like building_class were null. 
This was deemed necessary when a pattern was noticed in the 2016 format 
where, in the absence of data in that column, all units and square feets were represented as dashes; 
and in the 2017 format, the units were zeros and square feets were dashes #}

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