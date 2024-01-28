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

locations_with_highest_profit_margins as
(
    select 

    dim_region.country,
    dim_region.region,
    dim_region.state,
    dim_region.city,
    count(distinct dim_order.order_id) as total_orders,
    cast (round((sum(fct_sales.profit) / sum(fct_sales.sales)) * 100 ,3) as varchar) || '%' as profit_margin


    from fct_sales

    inner join dim_region
    on fct_sales.region_iterative_key = dim_region.region_iterative_key

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    group by dim_region.country, dim_region.region, dim_region.state, dim_region.city
    order by cast(replace(profit_margin, '%','')as decimal(10,2)) asc
    limit 10
)

select * from locations_with_highest_profit_margins

