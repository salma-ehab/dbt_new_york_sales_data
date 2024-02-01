{{ config(
  unique_key=['order_id','customer_id',' country','city','state','postal_code','region',
              'product_id','product_name','category','subcategory'],
  materialized='incremental',
  incremental_strategy='merge')}}


with 

{# Retrieve raw data #}

raw_data as
(
    select * from {{ source('superstore_data_2', 'superstore_table_2') }}
),

{# It was observed that, in instances where a customer, order, product, and region were identical,
   there might be several rows, each depicting the same product within the same order.
   In such cases, the sales, quantity, and profit values for that product in that order were aggregated, 
   while the discount remained unchanged #}

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


clean_data as
(
    {% if is_incremental() %}

    select 

    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    subcategory,
    product_name,
    sum (sales) as sales,
    sum (quantity) as quantity,
    discount,
    sum (profit) as profit,
    batch_loaded_at,
    batch_version

    from raw_data 

    where batch_loaded_at > (select max_batch_loaded_at from latest_batch)

    group by order_id, order_date, ship_date, ship_mode, customer_id, customer_name, segment, country,
             city, state, postal_code, region, product_id, category, subcategory, product_name, discount

    {% endif %}
),

clean_data_row_number as
(
    select *, 
    row_number() over (order by order_id, order_date, ship_date, ship_mode, customer_id, customer_name, 
                       segment, country, city, state, postal_code, region, product_id, category, 
                       subcategory, product_name, batch_loaded_at, batch_version) as row_id

    from clean_data
),

superstore_data_exists as
(
    select 

    order_id,
    customer_id,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    product_name,
    category,
    subcategory,

    max(row_id) as row_id
    
    from {{ this }}

    group by order_id, customer_id, country, city, state, postal_code, region,
             product_id, product_name, category, subcategory
),

max_row_id as
(
    select 

    max(row_id) as max_row_id
    
    from {{ this }}
),

incremental_cleaned_data as
(
    select 
       
    clean_data.* ,
    superstore_data_exists.row_id 

    from clean_data
    left join superstore_data_exists on 

    clean_data.order_id = superstore_data_exists.order_id
    and clean_data.customer_id = superstore_data_exists.customer_id
    and clean_data.country = superstore_data_exists.country
    and clean_data.city = superstore_data_exists.city
    and clean_data.state = superstore_data_exists.state
    and clean_data.postal_code = superstore_data_exists.postal_code
    and clean_data.region = superstore_data_exists.region
    and clean_data.product_id = superstore_data_exists.product_id
    and clean_data.product_name = superstore_data_exists.product_name
    and clean_data.category = superstore_data_exists.category
    and clean_data.subcategory = superstore_data_exists.subcategory

    where superstore_data_exists.row_id is not null

    union 

    select 
       
    clean_data.* ,

    max_row_id.max_row_id + 
    row_number() over (order by clean_data.order_id, clean_data.order_date, 
    clean_data.ship_date, clean_data.ship_mode, clean_data.customer_id, clean_data.customer_name, 
    clean_data.segment, clean_data.country, clean_data.city, clean_data.state, 
    clean_data.postal_code, clean_data.region, clean_data.product_id, clean_data.category, 
    clean_data.subcategory, clean_data.product_name) as row_id

    from clean_data
    cross join max_row_id

    left join superstore_data_exists on 
    clean_data.order_id = superstore_data_exists.order_id
    and clean_data.customer_id = superstore_data_exists.customer_id
    and clean_data.country = superstore_data_exists.country
    and clean_data.city = superstore_data_exists.city
    and clean_data.state = superstore_data_exists.state
    and clean_data.postal_code = superstore_data_exists.postal_code
    and clean_data.region = superstore_data_exists.region
    and clean_data.product_id = superstore_data_exists.product_id
    and clean_data.product_name = superstore_data_exists.product_name
    and clean_data.category = superstore_data_exists.category
    and clean_data.subcategory = superstore_data_exists.subcategory

    where superstore_data_exists.row_id is null
)


select * from incremental_cleaned_data