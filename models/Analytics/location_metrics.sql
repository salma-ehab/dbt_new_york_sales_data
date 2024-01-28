with 

dim_region as
(
    select * from {{ ref('dim_region') }}
),

dim_order as
(
    select * from {{ ref('dim_order') }}
),

fct_sales as
(
    select * from {{ ref('fct_sales') }}
),

location_metrics as
(
    select 

    dim_region.country,
    dim_region.region,
    dim_region.state,
    dim_region.city,
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

    cast (round((sum(fct_sales.profit) / sum(fct_sales.sales)) * 100 ,3) as varchar) || '%' as profit_margin


    from fct_sales

    inner join dim_region
    on fct_sales.region_iterative_key = dim_region.region_iterative_key

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    group by dim_region.country, dim_region.region, dim_region.state, dim_region.city
    order by dim_region.country, dim_region.region, dim_region.state, dim_region.city
)

select * from location_metrics


