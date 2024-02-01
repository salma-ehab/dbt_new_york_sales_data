{# Create a date dimension comprising date values ranging from "2014-01-03" to "2018-01-06".
   The date values include date, year, quarter, month, day, and a numeric key corresponding to the date #}


{{ config(
  unique_key='date_key')}}


with 

date_series as 
(
  {{ dbt_date.get_date_dimension("2014-01-03", "2018-07-10") }}
),

dim_date as
(
    select

    date_day as date_value,
    extract(year from date_day) as year_value,
    extract(quarter from date_day) as quarter_value,
    extract(month from date_day) as month_value,
    extract(day from date_day) as day_value,
    to_number(to_char(date_value, 'YYYYMMDD')) AS date_key

    from date_series
)

select * from dim_date