with 

dim_product as
(
    select * from {{ ref('dim_product') }}
),

fct_sales as
(
    select * from {{ ref('fct_sales') }}
),

product_category_and_subcategory_total_sales as
(
    select 

    dim_product.category,
    dim_product.subcategory,
    round(sum(fct_sales.sales),3) as total_sales

    from fct_sales

    inner join dim_product
    on fct_sales.product_iterative_key = dim_product.product_iterative_key

    group by dim_product.category, dim_product.subcategory
    order by total_sales desc
)

select * from product_category_and_subcategory_total_sales


