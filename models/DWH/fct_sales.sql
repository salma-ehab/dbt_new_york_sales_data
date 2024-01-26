{# Create a fact table in which each row corresponds to an item per order, 
   with row ID serving as the primary key #}


{{ config(
  unique_key=['row_id'])}}


with 

data_source as 
(
    select * from {{ ref('superstore_data') }}
),

dim_customer as
(
    select * from {{ ref('dim_customer') }}
),

dim_region as
(
    select * from {{ ref('dim_region') }}
),

dim_order as
(
    select * from {{ ref('dim_order') }}
),

dim_product as
(
    select * from {{ ref('dim_product') }}
),

fct_sales as
(
    select 

    data_source.row_id,
    data_source.sales,
    data_source.quantity,
    data_source.discount,
    data_source.profit,
    dim_customer.customer_id,
    dim_region.region_iterative_key,
    dim_order.order_id,
    dim_product.product_iterative_key


    from data_source

    left join dim_customer 
    on data_source.customer_id = dim_customer.customer_id

    left join dim_region
    on data_source.country = dim_region.country
    and data_source.region = dim_region.region
    and data_source.state = dim_region.state
    and data_source.city = dim_region.city
    and data_source.postal_code = dim_region.postal_code

    left join dim_order
    on data_source.order_id = dim_order.order_id

    left join dim_product
    on data_source.product_id = dim_product.product_id
    and data_source.product_name = dim_product.product_name
    and data_source.category = dim_product.category
    and data_source.subcategory = dim_product.subcategory

)

select * from fct_sales