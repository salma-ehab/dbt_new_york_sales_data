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

all_orders as
(
    select 
    
    count(*) as total_orders_count

    from dim_order
),

shipping_modes_analysis as
(
    select 

    dim_order.ship_mode,
    count(distinct dim_order.order_id) as total_orders_per_shipping_mode,
    cast(round((count(distinct dim_order.order_id) / all_orders.total_orders_count) * 100, 3) as varchar) || '%'
    as shipping_mode_percent_distribution,

    round(sum(datediff(day,dod.date_value,dsd.date_value)) /  count(distinct dim_order.order_id),3 )
    as avg_shipping_time,

    round(sum(fct_sales.sales),3) as total_sales,
    round(sum(fct_sales.profit),3) as total_profit,

    round(avg(fct_sales.sales),3) as avg_sales,
    round(avg(fct_sales.profit),3) as avg_profit,

    cast (round((sum(fct_sales.profit) / sum(fct_sales.sales)) * 100 ,3) as varchar) || '%' as profit_margin

    from fct_sales

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    inner join dim_date dod 
    on dim_order.order_date = dod.date_key

    inner join dim_date dsd 
    on dim_order.ship_date = dsd.date_key

    cross join all_orders

    group by dim_order.ship_mode, all_orders.total_orders_count
    order by dim_order.ship_mode
)

select * from shipping_modes_analysis

