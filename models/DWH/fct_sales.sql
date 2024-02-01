{# Create a sales fact table in which each row corresponds to an item per order, 
   with the combined foreign keys of customer ID, region iterative key, order ID, and product iterative key
   serving as the primary key #}


{{ config(
  unique_key=['customer_id', 'region_iterative_key','order_id','product_iterative_key'],
  materialized='incremental',
  incremental_strategy='merge')}}


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

dim_batch as
(
    select * from {{ ref('dim_batch') }}
),

latest_batch as 
(
    select 
       
    max(batch_loaded_at) as max_batch_loaded_at
       
    from dim_batch
),

previous_batch_version as
(
    select 

    max(batch_version) as max_batch_version

    from {{this}}

),

incremental_fct_sales as
(
    select 

    {% if is_incremental() %}

    data_source.row_id,
    data_source.sales,
    data_source.quantity,
    data_source.discount,
    data_source.profit,
    dim_customer.customer_id,
    dim_region.region_iterative_key,
    dim_order.order_id,
    dim_product.product_iterative_key,
    coalesce(dim_batch.batch_version, previous_batch_version.max_batch_version + 1) as batch_version

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

    left join dim_batch
    on data_source.batch_version = dim_batch.batch_version

    cross join previous_batch_version

    where data_source.batch_loaded_at > (select max_batch_loaded_at from latest_batch)

    {% endif %}

)

select * from incremental_fct_sales 