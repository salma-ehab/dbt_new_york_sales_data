{# Create a product dimension containing unique combinations of 
   product ID, product name, category, and subcategory, with an iterative key 
   serving as the primary key #}

{# The uniqueness of the product ID is compromised, as it is estimated that certain products, 
   upon becoming extinct, had their IDs repurposed for newer products. 
   Due to the absence of specific dates indicating these changes, 
   incorporation into a slowly changing dimension is unfeasible. 
   Consequently, the current approach utilizes an iterative key to address this scenario #}


{{ config(
  unique_key=['product_id','product_name','category','subcategory'],
  materialized='incremental',
  incremental_strategy='merge')}}


with

data_source as 
(
    select * from {{ ref('superstore_data') }}
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

dim_product_distinct_fields as
(
    {% if is_incremental() %}

    select distinct

    product_id, 
    product_name,
    category,
    subcategory

    from data_source

    where batch_loaded_at > (select max_batch_loaded_at from latest_batch)

    {% endif %}
),

dim_product as
(
    select *, 
    row_number() over (order by  product_id, product_name, category, subcategory) as product_iterative_key

    from dim_product_distinct_fields
),

dim_product_exists as
(
    select 

    product_id, 
    product_name,
    category,
    subcategory,

    max(product_iterative_key) as product_iterative_key
    
    from {{ this }}

    group by product_id, product_name, category, subcategory

),

max_product_iterative_key as
(
    select 

    max(product_iterative_key)  as max_product_iterative_key
    
    from {{ this }}

),

incremental_dim_product as
(
    select 
    
    dim_product_distinct_fields.* ,
    dim_product_exists.product_iterative_key 

    from dim_product_distinct_fields
    left join dim_product_exists on 
    dim_product_distinct_fields.product_id = dim_product_exists.product_id
    and dim_product_distinct_fields.product_name = dim_product_exists.product_name
    and dim_product_distinct_fields.category = dim_product_exists.category
    and dim_product_distinct_fields.subcategory = dim_product_exists.subcategory

    where dim_product_exists.product_iterative_key is not null

    union 

    select 

    dim_product_distinct_fields.* ,

    max_product_iterative_key.max_product_iterative_key + 
    row_number() over (order by dim_product_distinct_fields.product_id,
    dim_product_distinct_fields.product_name, dim_product_distinct_fields.category,
    dim_product_distinct_fields.subcategory) as product_iterative_key

    from dim_product_distinct_fields
    cross join max_product_iterative_key

    left join dim_product_exists on 
    dim_product_distinct_fields.product_id = dim_product_exists.product_id
    and dim_product_distinct_fields.product_name = dim_product_exists.product_name
    and dim_product_distinct_fields.category = dim_product_exists.category
    and dim_product_distinct_fields.subcategory = dim_product_exists.subcategory

    where dim_product_exists.product_iterative_key is null
)

select * from incremental_dim_product