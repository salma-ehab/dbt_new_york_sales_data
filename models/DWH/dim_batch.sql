{{ config(
  unique_key='batch_version',
  materialized='incremental',
  incremental_strategy='merge')}}

with

data_source as 
(
    select * from {{ source('superstore_data_2', 'superstore_table_2') }}
),


dim_batch as
(
    {% if is_incremental() %}

    select distinct

    data_source.batch_version, 
    data_source.batch_loaded_at

    from data_source

    where batch_loaded_at > (select batch_loaded_at from {{this}})

    {% endif %}

)

select * from dim_batch  