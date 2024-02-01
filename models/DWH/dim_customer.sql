{# Create a customer dimension containing unique combinations of 
   customer ID, customer name, and segment, with customer ID serving as the primary key #}

{# It is recommended to employ an iterative key as the primary key, 
   especially when joining multiple tables. However, due to the small 
   size of the dataset, the customer ID is used as the primary key #}


{{ config(
  unique_key='customer_id',
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

dim_customer as
(
   {% if is_incremental() %}
     
    select distinct

    customer_id, 
    customer_name,
    segment

    from  data_source
    
    where batch_loaded_at > (select max_batch_loaded_at from latest_batch)

    {% endif %}
)

select * from dim_customer