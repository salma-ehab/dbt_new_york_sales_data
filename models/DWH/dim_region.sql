{# Create a region dimension containing unique combinations of 
   country, city, state, region, and postal code of every customer, 
   with an iterative key serving as the primary key #}


{{ config(
  unique_key='region_iterative_key')}}


with

data_source as 
(
    select * from {{ ref('superstore_data') }}
),

dim_region_distinct_fields as
(
    select distinct

    country,
    region,
    state, 
    city,
    postal_code

    from data_source
),

dim_region as
(
    select *, 
    row_number() over (order by  country, region, state, city, postal_code) as region_iterative_key

    from dim_region_distinct_fields
)

select * from dim_region