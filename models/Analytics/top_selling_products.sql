with 

dim_product as
(
    select * from {{ ref('dim_product') }}
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
    round(sum(fct_sales.sales),3) as total_product_sales

    from fct_sales

    inner join dim_product
    on fct_sales.product_iterative_key = dim_product.product_iterative_key

    group by dim_product.product_id, dim_product.product_name
    order by  total_product_sales desc
    limit 10
)

select * from top_selling_products


