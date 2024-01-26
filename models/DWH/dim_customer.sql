{# Create a customer dimension containing unique combinations of 
   customer ID, customer name, and segment, with customer ID serving as the primary key #}

{# It is recommended to employ an iterative key as the primary key, 
   especially when joining multiple tables. However, due to the small 
   size of the dataset, the customer ID is used as the primary key #}


{{ config(
  unique_key='customer_id')}}


with

data_source as 
(
    select * from {{ ref('superstore_data') }}
),

dim_customer as
(
    select distinct

    customer_id, 
    customer_name,
    segment
  
    from data_source
)

select * from dim_customer 