{# Create an order dimension containing unique combinations of 
   order ID, order date, shipping date and shipping mode, with order ID serving as the primary key #}

{# It is recommended to employ an iterative key as the primary key, 
   especially when joining multiple tables. However, due to the small 
   size of the dataset, the order ID is used as the primary key #}

{# Even though integrating order ID, order date, ship date, and ship mode directly into the fact 
   would necessitate only one join for accessing date values, the decision was made to preserve a 
   distinct Order dimension. This choice is driven by the small dataset, and the need for a clearer 
   understanding of the business case. Additionally, in the event of changes to order-related attributes, 
   maintaining a separate Order dimension proves to be more straightforward, as updates only need to 
   be made within that specific dimension #}


{{ config(
  unique_key='order_id',
  materialized='incremental',
  strategy='merge')}}


with

data_source as 
(
    select * from {{ ref('superstore_data') }}
),

dim_date as
(
    select * from {{ ref('dim_date') }}
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

dim_order as
(
    {% if is_incremental() %}

    select distinct

    data_source.order_id, 
    ddo.date_key as order_date,
    dds.date_key as ship_date,
    data_source.ship_mode

    from data_source

    left join dim_date ddo
    on to_number(to_char(data_source.order_date, 'YYYYMMDD')) = ddo.date_key

    left join dim_date dds
    on to_number(to_char(data_source.ship_date, 'YYYYMMDD')) = dds.date_key

    where batch_loaded_at > (select max_batch_loaded_at from latest_batch)

    {% endif %}

)

select * from dim_order 