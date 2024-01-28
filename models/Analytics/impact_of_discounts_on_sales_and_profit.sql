with 

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

impact_of_discounts_on_sales_and_profit as
(
    select 

    dim_product.product_id,
    dim_product.product_name,
    fct_sales.discount,
    
    count(distinct dim_order.order_id) as total_orders,
    sum(fct_sales.quantity) as total_products_purchased,

    round(sum(fct_sales.sales),3) as total_sales,
    round(sum(fct_sales.profit),3) as total_profit,

    round(avg(fct_sales.sales),3) as avg_sales,
    round(avg(fct_sales.profit),3) as avg_profit,

    cast (round((sum(fct_sales.profit) / sum(fct_sales.sales)) * 100 ,3) as varchar) || '%' as profit_margin


    from fct_sales

    inner join dim_product
    on fct_sales.product_iterative_key = dim_product.product_iterative_key

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    group by dim_product.product_id, dim_product.product_name, fct_sales.discount
    order by fct_sales.discount desc, dim_product.product_id, dim_product.product_name
)

select * from impact_of_discounts_on_sales_and_profit


