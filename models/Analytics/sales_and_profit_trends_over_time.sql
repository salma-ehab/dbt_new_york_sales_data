with 

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

sales_and_profit_trends_by_year as
(
    select 

    dim_date.year_value,
    null as quarter_value,
    null as month_value,
    count(distinct dim_order.order_id) as total_orders,

    round(sum(fct_sales.sales),3) as total_sales,
    round(sum(fct_sales.profit),3) as total_profit,

    round(avg(fct_sales.sales),3) as avg_sales,
    round(avg(fct_sales.profit),3) as avg_profit,

    round(percentile_cont(0.25) within group (order by fct_sales.sales) ,3) as percentile_25_sales,
    round(percentile_cont(0.25) within group (order by fct_sales.profit),3) as percentile_25_profit,
    round(percentile_cont(0.5) within group (order by fct_sales.sales),3) as median_sales,
    round(percentile_cont(0.5) within group (order by fct_sales.profit),3) as median_profit,
    round(percentile_cont(0.75) within group (order by fct_sales.sales),3) as percentile_75_sales,
    round(percentile_cont(0.75) within group (order by fct_sales.profit),3) as percentile_75_profit,

    round(stddev(fct_sales.sales),3) as sales_standard_deviation,
    round(stddev(fct_sales.profit),3) as profit_standard_deviation,

    case when lag(sum(fct_sales.sales), 1, 0) 
    over (order by dim_date.year_value)  = 0
    then null
    else 
    cast(round(((sum(fct_sales.sales) - lag(sum(fct_sales.sales), 1, 0) 
    over (order by dim_date.year_value)) / lag(sum(fct_sales.sales), 1, 1) 
    over (order by dim_date.year_value)) * 100 ,3) as varchar) || '%'
    end as sales_growth_rate,

    case when lag(sum(fct_sales.sales), 1, 0) 
    over (order by dim_date.year_value)  = 0
    then null
    else 
    cast(round(((sum(fct_sales.profit) - lag(sum(fct_sales.profit), 1, 0) 
    over (order by dim_date.year_value)) / lag(sum(fct_sales.profit), 1, 1) 
    over (order by dim_date.year_value)) * 100 ,3) as varchar) || '%'
    end as profit_growth_rate,

    cast (round((sum(fct_sales.profit) / sum(fct_sales.sales)) * 100 ,3) as varchar) || '%' as profit_margin


    from fct_sales

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    inner join dim_date
    on dim_order.order_date = dim_date.date_key

    group by dim_date.year_value
),

sales_and_profit_trends_by_quarter as
(
    select 

    dim_date.year_value,
    dim_date.quarter_value as quarter_value,
    null as month_value,
    count(distinct dim_order.order_id) as total_orders,

    round(sum(fct_sales.sales),3) as total_sales,
    round(sum(fct_sales.profit),3) as total_profit,

    round(avg(fct_sales.sales),3) as avg_sales,
    round(avg(fct_sales.profit),3) as avg_profit,

    round(percentile_cont(0.25) within group (order by fct_sales.sales),3) as percentile_25_sales,
    round(percentile_cont(0.25) within group (order by fct_sales.profit),3) as percentile_25_profit,
    round(percentile_cont(0.5) within group (order by fct_sales.sales),3) as median_sales,
    round(percentile_cont(0.5) within group (order by fct_sales.profit),3) as median_profit,
    round(percentile_cont(0.75) within group (order by fct_sales.sales),3) as percentile_75_sales,
    round(percentile_cont(0.75) within group (order by fct_sales.profit),3) as percentile_75_profit,

    round(stddev(fct_sales.sales),3) as sales_standard_deviation,
    round(stddev(fct_sales.profit),3) as profit_standard_deviation,

    case when lag(sum(fct_sales.sales), 1, 0) 
    over (order by dim_date.year_value, dim_date.quarter_value)  = 0
    then null
    else 
    cast(round(((sum(fct_sales.sales) - lag(sum(fct_sales.sales), 1, 0) 
    over (order by dim_date.year_value, dim_date.quarter_value)) / lag(sum(fct_sales.sales), 1, 1) 
    over (order by dim_date.year_value, dim_date.quarter_value)) * 100 ,3) as varchar ) || '%'
    end as sales_growth_rate,

    case when lag(sum(fct_sales.sales), 1, 0) 
    over (order by dim_date.year_value, dim_date.quarter_value)  = 0
    then null
    else 
    cast(round(((sum(fct_sales.profit) - lag(sum(fct_sales.profit), 1, 0) 
    over (order by dim_date.year_value, dim_date.quarter_value)) / lag(sum(fct_sales.profit), 1, 1) 
    over (order by dim_date.year_value, dim_date.quarter_value)) * 100 ,3) as varchar) || '%'
    end as profit_growth_rate,

    cast (round((sum(fct_sales.profit) / sum(fct_sales.sales)) * 100 ,3) as varchar) || '%' as profit_margin


    from fct_sales

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    inner join dim_date
    on dim_order.order_date = dim_date.date_key

    group by dim_date.year_value, dim_date.quarter_value
),

sales_and_profit_trends_by_month as
(
    select 

    dim_date.year_value,
    dim_date.quarter_value as quarter_value,
    dim_date.month_value as month_value,
    count(distinct dim_order.order_id) as total_orders,

    round(sum(fct_sales.sales),3) as total_sales,
    round(sum(fct_sales.profit),3) as total_profit,

    round(avg(fct_sales.sales),3) as avg_sales,
    round(avg(fct_sales.profit),3) as avg_profit,

    round(percentile_cont(0.25) within group (order by fct_sales.sales),3) as percentile_25_sales,
    round(percentile_cont(0.25) within group (order by fct_sales.profit),3) as percentile_25_profit,
    round(percentile_cont(0.5) within group (order by fct_sales.sales),3) as median_sales,
    round(percentile_cont(0.5) within group (order by fct_sales.profit),3) as median_profit,
    round(percentile_cont(0.75) within group (order by fct_sales.sales),3) as percentile_75_sales,
    round(percentile_cont(0.75) within group (order by fct_sales.profit),3) as percentile_75_profit,

    round(stddev(fct_sales.sales),3) as sales_standard_deviation,
    round(stddev(fct_sales.profit),3) as profit_standard_deviation,

    case when lag(sum(fct_sales.sales), 1, 0) 
    over (order by dim_date.year_value, dim_date.quarter_value, dim_date.month_value)  = 0
    then null
    else 
    cast(round(((sum(fct_sales.sales) - lag(sum(fct_sales.sales), 1, 0) 
    over (order by dim_date.year_value, dim_date.quarter_value, dim_date.month_value)) / lag(sum(fct_sales.sales), 1, 1) 
    over (order by dim_date.year_value, dim_date.quarter_value, dim_date.month_value)) * 100 ,3) as varchar) || '%'
    end as sales_growth_rate,

    case when lag(sum(fct_sales.sales), 1, 0) 
    over (order by dim_date.year_value, dim_date.quarter_value, dim_date.month_value)  = 0
    then null
    else 
    cast(round(((sum(fct_sales.profit) - lag(sum(fct_sales.profit), 1, 0) 
    over (order by dim_date.year_value, dim_date.quarter_value, dim_date.month_value)) / lag(sum(fct_sales.profit), 1, 1) 
    over (order by dim_date.year_value, dim_date.quarter_value, dim_date.month_value)) * 100 ,3) as varchar) || '%'
    end as profit_growth_rate,

    cast (round((sum(fct_sales.profit) / sum(fct_sales.sales)) * 100 ,3) as varchar) || '%' as profit_margin


    from fct_sales

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    inner join dim_date
    on dim_order.order_date = dim_date.date_key

    group by dim_date.year_value, dim_date.quarter_value, dim_date.month_value
),

sales_and_profit_trends_over_time as
(
    select * 

    from sales_and_profit_trends_by_year

    union

    select * 

    from sales_and_profit_trends_by_quarter

    union

    select * 

    from sales_and_profit_trends_by_month
)

select * from sales_and_profit_trends_over_time
order by  year_value, quarter_value, month_value


