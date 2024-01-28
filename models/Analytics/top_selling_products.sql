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

top_selling_products as
(
    select 

    dim_product.product_id,
    dim_product.product_name,
    count(distinct dim_order.order_id) as total_orders,
    sum(fct_sales.quantity) as total_products_purchased,
    round(sum(fct_sales.sales),3) as total_product_sales

    from fct_sales

    inner join dim_product
    on fct_sales.product_iterative_key = dim_product.product_iterative_key

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    group by dim_product.product_id, dim_product.product_name
    order by  total_product_sales desc
    limit 10
)

select * from top_selling_products


