{# The identification of the building relied on factors such as 
   borough, neighborhood, block, and lot rather than the address. 
   This approach was adopted due to variations in address representation, 
   where the same location could be expressed differently,
   such as "street" or "st" and "3rd" or "3." #}
   
{# It was noted that multiple records for the same building may exist due to occasional missing or 
  incorrectly entered zip codes. To ensure the unique identification of buildings in such instances, 
  distinctive combinations of borough, neighborhood, block, and lot were grouped together #}

with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

location_dim as
(
    select * from {{ ref('location_dim') }}
),


top_5_most_expensive_buildings_based_on_sale_price as
(
    select 

    location_dim.borough_name,
    location_dim.neighborhood,
    location_dim.block,
    location_dim.lot,
    max(property_fact_table.sales_price) as sale_price

    from location_dim

    inner join property_fact_table
    on property_fact_table.location_key = location_dim.location_key

    group by location_dim.borough_name, location_dim.neighborhood, location_dim.block, location_dim.lot
    order by sale_price desc 
    limit 5

)

select * from top_5_most_expensive_buildings_based_on_sale_price 