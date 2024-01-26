{# Ensure that the combination of foreign keys is distinct for each row #}

select 

customer_id,
region_iterative_key,
order_id,
product_iterative_key

from {{ ref('fct_sales') }}

group by customer_id, region_iterative_key, order_id, product_iterative_key
having count(*) > 1