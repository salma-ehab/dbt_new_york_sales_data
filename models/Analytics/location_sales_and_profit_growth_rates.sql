with

dim_region as
(
    select * from {{ ref('dim_region') }}
),

dim_order as
(
    select * from {{ ref('dim_order') }}
),

dim_date as
(
    select * from {{ ref('dim_date') }}
),

fct_sales as
(
    select * from {{ ref('fct_sales') }}
),

month_sequence as
(
    select distinct

    year_value,
    quarter_value,
    month_value
    
    from dim_date

    where year_value <> 2018
),

location_sales_and_profit_growth_rates as
(
    select 

    dim_region.country,
    dim_region.region,
    dim_region.state,
    dim_region.city,
    month_sequence.year_value,
    month_sequence.quarter_value,
    month_sequence.month_value,

    round(sum(fct_sales.sales),3) as total_sales,

    case when lag(sum(fct_sales.sales), 1, 0) 
    over (partition by dim_region.country, dim_region.region, dim_region.state, dim_region.city
    order by month_sequence.year_value, month_sequence.quarter_value, month_sequence.month_value) = 0
    then null
    else cast(round(((sum(fct_sales.sales) - lag(sum(fct_sales.sales), 1, 0) 
    over (partition by dim_region.country, dim_region.region, dim_region.state, dim_region.city
    order by month_sequence.year_value, month_sequence.quarter_value, month_sequence.month_value)) /
    abs(lag(sum(fct_sales.sales), 1, 1) 
    over (partition by dim_region.country, dim_region.region, dim_region.state, dim_region.city
    order by month_sequence.year_value, month_sequence.quarter_value, month_sequence.month_value))) * 100, 3) as varchar) || '%'
    end as sales_growth_rate,


    round(sum(fct_sales.profit),3) as total_profit,

    case when lag(sum(fct_sales.profit), 1, 0) 
    over (partition by dim_region.country, dim_region.region, dim_region.state, dim_region.city
    order by month_sequence.year_value, month_sequence.quarter_value, month_sequence.month_value) = 0
    then null
    else cast(round(((sum(fct_sales.profit) - lag(sum(fct_sales.profit), 1, 0) 
    over (partition by dim_region.country, dim_region.region, dim_region.state, dim_region.city
    order by month_sequence.year_value, month_sequence.quarter_value, month_sequence.month_value)) /
    abs(lag(sum(fct_sales.profit), 1, 1) 
    over (partition by dim_region.country, dim_region.region, dim_region.state, dim_region.city
    order by month_sequence.year_value, month_sequence.quarter_value, month_sequence.month_value))) * 100, 3) as varchar) || '%'
    end as profit_growth_rate


    from (dim_region
    cross join month_sequence)

    left join (fct_sales

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    inner join dim_date
    on dim_order.order_date = dim_date.date_key)

    on month_sequence.year_value = dim_date.year_value
    and month_sequence.quarter_value = dim_date.quarter_value
    and month_sequence.month_value = dim_date.month_value 
    and fct_sales.region_iterative_key = dim_region.region_iterative_key


    group by dim_region.country, dim_region.region, dim_region.state, dim_region.city,
    month_sequence.year_value, month_sequence.quarter_value, month_sequence.month_value

    order by dim_region.country, dim_region.region, dim_region.state, dim_region.city,
    month_sequence.year_value, month_sequence.quarter_value, month_sequence.month_value
)

select * from location_sales_and_profit_growth_rates

