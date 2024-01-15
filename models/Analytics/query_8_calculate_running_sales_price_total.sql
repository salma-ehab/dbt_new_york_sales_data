{# This task required employing a window function to compute the cumulative sum of sales prices. 
   The cumulative calculation was performed on a yearly and monthly basis, 
   deliberately avoiding daily breakdowns to improve the clarity of the results #}

with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

date_dim as
(
    select * from {{ ref('date_dim') }}
),

calculate_running_sales_price_total as 
(
    select distinct

    date_dim.year_value,
    date_dim.month_value,
    sum (property_fact_table.sales_price) over (order by date_dim.year_value, date_dim.month_value) 
                                                as running_total_sales_price

    from property_fact_table
    inner join date_dim
    on property_fact_table.date_key = date_dim.date_key

)

select * from calculate_running_sales_price_total
order by year_value, month_value