{# This task involved determining the cumulative sales figures across various date intervals. 
   The analysis was conducted on a yearly, monthly, and quarterly basis, avoiding daily breakdowns to 
   enhance result readability. Subsequently, the data was consolidated using a union operation #}

with

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

date_dim as
(
    select * from {{ ref('date_dim') }}
),

total_sale_price_over_time_diff_date_parts as
(
    select 

    date_dim.year_value,
    null as quarter_value,
    null as month_value,
    sum(property_fact_table.sales_price) as total_sales_price
    
    from property_fact_table

    inner join date_dim 
    on property_fact_table.date_key = date_dim.date_key

    group by date_dim.year_value

    union

    select 

    date_dim.year_value,
    date_dim.quarter_value,
    null as month_value,
    sum(property_fact_table.sales_price) as total_sales_price

    from property_fact_table

    inner join date_dim 
    on property_fact_table.date_key = date_dim.date_key

    group by date_dim.year_value, date_dim.quarter_value

    union

    select 

    date_dim.year_value,
    null as quarter_value,
    date_dim.month_value,
    sum(property_fact_table.sales_price) as total_sales_price

    from property_fact_table

    inner join date_dim 
    on property_fact_table.date_key = date_dim.date_key

    group by date_dim.year_value, date_dim.month_value

)

select * from total_sale_price_over_time_diff_date_parts 
order by year_value, quarter_value, month_value