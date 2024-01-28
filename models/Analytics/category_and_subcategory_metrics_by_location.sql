with 

dim_region as
(
    select * from {{ ref('dim_region') }}
),

dim_product as
(
    select * from {{ ref('dim_product') }}
),

dim_order as
(
    select * from {{ ref('dim_order') }}
),

fct_sales as
(
    select * from {{ ref('fct_sales') }}
),

category_and_subcategory_metrics_by_location as
(
    select 
    
    dim_region.country,
    dim_region.region,
    dim_region.state,
    dim_region.city,
    dim_product.category,
    dim_product.subcategory,

    count(distinct dim_order.order_id) as total_orders,
    sum(fct_sales.quantity) as total_products_purchased,

    round(sum(fct_sales.sales),3) as total_sales,
    round(sum(fct_sales.profit),3) as total_profit,

    round(avg(fct_sales.sales),3) as avg_sales,
    round(avg(fct_sales.profit),3) as avg_profit,

    cast (round((sum(fct_sales.profit) / sum(fct_sales.sales)) * 100 ,3) as varchar) || '%' as profit_margin


    from fct_sales

    inner join dim_region
    on fct_sales.region_iterative_key = dim_region.region_iterative_key

    inner join dim_product
    on fct_sales.product_iterative_key = dim_product.product_iterative_key

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    group by dim_region.country, dim_region.region, dim_region.state, dim_region.city,
             dim_product.category,dim_product.subcategory

    order by total_sales desc
)

select * from category_and_subcategory_metrics_by_location

