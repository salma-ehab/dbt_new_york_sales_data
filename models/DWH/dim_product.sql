{# Create a product dimension containing unique combinations of 
   product ID, product name, category, and subcategory #}

{# The uniqueness of the product ID is compromised, as it is estimated that certain products, 
   upon becoming extinct, had their IDs repurposed for newer products. 
   Due to the absence of specific dates indicating these changes, 
   incorporation into a slowly changing dimension is unfeasible. 
   Consequently, the current approach utilizes an iterative key to address this scenario #}


{{ config(
  unique_key='product_iterative_key')}}


with

data_source as 
(
    select * from {{ ref('superstore_data') }}
),

dim_product_distinct_fields as
(
    select distinct

    product_id, 
    product_name,
    category,
    subcategory

    from data_source
),

dim_product as
(
    select *, 
    row_number() over (order by  product_id, product_name, category, subcategory) as product_iterative_key

    from dim_product_distinct_fields
)

select * from dim_product