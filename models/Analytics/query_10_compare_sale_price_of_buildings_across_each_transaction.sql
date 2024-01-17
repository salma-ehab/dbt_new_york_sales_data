{# The identification of the building relied on factors such as 
   borough, neighborhood, block, and lot rather than the address. 
   This approach was adopted due to variations in address representation, 
   where the same location could be expressed differently,
   such as "street" or "st" and "3rd" or "3." #}

{# It was noted that multiple records for the same building may exist due to occasional missing or 
  incorrectly entered zip codes. To ensure the unique identification of buildings in such instances, 
  distinctive combinations of borough, neighborhood, block, and lot were grouped together #}

{# As individual apartments are being sold, this query serves the purpose of identifying the sales 
   linked to a building, particularly when the building has been involved in multiple sales transactions #}

with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

location_dim as
(
    select * from {{ ref('location_dim') }}
),

date_dim as
(
   select * from {{ ref('date_dim') }}
),


buildings_sold_multiple_times as
(
    select 
    
    count(*),
    location_dim.borough_name,
    location_dim.neighborhood,
    location_dim.block,
    location_dim.lot

    from location_dim

    inner join property_fact_table
    on property_fact_table.location_key = location_dim.location_key

    group by location_dim.borough_name, location_dim.neighborhood, location_dim.block, location_dim.lot
    having (count(*) > 1)
    order by count(*) desc
),

compare_sale_price_of_buildings_across_each_transaction as
(
    select 

    buildings_sold_multiple_times.borough_name,
    buildings_sold_multiple_times.neighborhood,
    buildings_sold_multiple_times.block,
    buildings_sold_multiple_times.lot,
    property_fact_table.sales_price,
    date_dim.date_value

    from buildings_sold_multiple_times
    inner join location_dim
    on  buildings_sold_multiple_times.borough_name = location_dim.borough_name
    and buildings_sold_multiple_times.neighborhood = location_dim.neighborhood
    and buildings_sold_multiple_times.block = location_dim.block
    and buildings_sold_multiple_times.lot = location_dim.lot

    inner join property_fact_table
    on property_fact_table.location_key = location_dim.location_key

    inner join date_dim
    on property_fact_table.date_key = date_dim.date_key

    order by  buildings_sold_multiple_times.borough_name, buildings_sold_multiple_times.neighborhood,
              buildings_sold_multiple_times.block, buildings_sold_multiple_times.lot, date_dim.date_value
)

select * from compare_sale_price_of_buildings_across_each_transaction 