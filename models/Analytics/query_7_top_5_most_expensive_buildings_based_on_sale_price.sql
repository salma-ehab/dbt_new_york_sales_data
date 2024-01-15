{# The identification of the building relied on factors such as 
   borough, neighborhood, block, and lot rather than the address. 
   This approach was adopted due to variations in address representation, 
   where the same location could be expressed differently,
   such as "street" or "st" and "3rd" or "3." #}
   
{# It was observed that there can be multiple records for the same building due 
   to the occasional absence of the zipcode. To uniquely identify buildings in such cases, 
   distinct combinations of borough, neighborhood, block, and lot were selected. 
   These distinct combinations were then grouped, and the resulting groups were joined with 
   the location dimension to obtain the location key. 
   This location key was then used to join with the sales fact table to 
   analyze multiple transactions for each building #}


with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

location_dim as
(
    select * from {{ ref('location_dim') }}
),

distinct_building as
(
    select distinct

    borough_name, neighborhood, block, lot
    
    from location_dim

),

top_5_most_expensive_buildings_based_on_sale_price as
(
    select 

    distinct_building.borough_name,
    distinct_building.neighborhood,
    distinct_building.block,
    distinct_building.lot,
    max(property_fact_table.sales_price) as sale_price

    from distinct_building

    inner join location_dim
    on  distinct_building.borough_name = location_dim.borough_name
    and distinct_building.neighborhood = location_dim.neighborhood
    and distinct_building.block = location_dim.block
    and distinct_building.lot = location_dim.lot

    inner join property_fact_table
    on property_fact_table.location_key = location_dim.location_key

    group by distinct_building.borough_name, distinct_building.neighborhood, distinct_building.block, distinct_building.lot
    order by sale_price desc 
    limit 5

)

select * from top_5_most_expensive_buildings_based_on_sale_price 