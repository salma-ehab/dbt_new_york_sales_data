with date_series as 
(
  {{ dbt_date.get_date_dimension("2016-01-01", "2019-01-01") }}
),

date_dim as
(
    select

    date_day as date_value,
    extract(year from date_day) as year_value,
    extract(month from date_day) as month_value,
    extract(day from date_day) as day_value,
    extract(quarter from date_day) as quarter_value,
    row_number() over (order by date_day) as date_key
    
    from date_series
)

select * from date_dim