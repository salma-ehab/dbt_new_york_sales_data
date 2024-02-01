{# Create a region dimension containing unique combinations of 
   country, city, state, region, and postal code of every customer, 
   with an iterative key serving as the primary key #}


{{ config(
  unique_key=['country','region','state','city','postal_code'],
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

dim_region_distinct_fields as
(
    {% if is_incremental() %}

    select distinct

    country,
    region,
    state, 
    city,
    postal_code

    from data_source

    where batch_loaded_at > (select max_batch_loaded_at from latest_batch)

    {% endif %}
),

dim_region as
(
    select *, 
    row_number() over (order by  country, region, state, city, postal_code) as region_iterative_key

    from dim_region_distinct_fields
),

dim_region_exists as
(
    select 

    country,
    region,
    state, 
    city,
    postal_code,

    max(region_iterative_key) as region_iterative_key
    
    from {{ this }}

    group by  country, region, state, city, postal_code
),

max_region_iterative_key as
(
    select 

    max(region_iterative_key)  as max_region_iterative_key
    
    from {{ this }}

),

incremental_dim_region as
(
    select 
    
    dim_region_distinct_fields.* ,
    dim_region_exists.region_iterative_key

    from dim_region_distinct_fields

    left join dim_region_exists on 
    dim_region_distinct_fields.country = dim_region_exists.country
    and dim_region_distinct_fields.region = dim_region_exists.region
    and dim_region_distinct_fields.state = dim_region_exists.state
    and dim_region_distinct_fields.city = dim_region_exists.city
    and dim_region_distinct_fields.postal_code = dim_region_exists.postal_code

    where dim_region_exists.region_iterative_key is not null

    union 

    select 

    dim_region_distinct_fields.* ,

    max_region_iterative_key.max_region_iterative_key + 
    row_number() over (order by dim_region_distinct_fields.country, 
    dim_region_distinct_fields.region, dim_region_distinct_fields.state, 
    dim_region_distinct_fields.city, dim_region_distinct_fields.postal_code) as region_iterative_key

    from dim_region_distinct_fields
    cross join max_region_iterative_key

    left join dim_region_exists on 
    dim_region_distinct_fields.country = dim_region_exists.country
    and dim_region_distinct_fields.region = dim_region_exists.region
    and dim_region_distinct_fields.state = dim_region_exists.state
    and dim_region_distinct_fields.city = dim_region_exists.city
    and dim_region_distinct_fields.postal_code = dim_region_exists.postal_code

    where dim_region_exists.region_iterative_key is null
)

select * from incremental_dim_region
