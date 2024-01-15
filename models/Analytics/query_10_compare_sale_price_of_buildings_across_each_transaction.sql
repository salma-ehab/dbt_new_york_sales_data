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

{# At times, individual apartments were sold instead of the entire building. 
  Filtering was performed using the apartment number. However, instances were identified 
  where the apartment number was not applicable, yet apartments were still sold. 
  This was particularly evident when the count for such cases exceeded 850 #}

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


distinct_building as
(
    select distinct

    borough_name, neighborhood, block, lot
    
    from location_dim

),

buildings_sold_multiple_times as
(
    select 
    
    count(*),
    distinct_building.borough_name,
    distinct_building.neighborhood,
    distinct_building.block,
    distinct_building.lot

    from distinct_building

    inner join location_dim
    on  distinct_building.borough_name = location_dim.borough_name
    and distinct_building.neighborhood = location_dim.neighborhood
    and distinct_building.block = location_dim.block
    and distinct_building.lot = location_dim.lot

    inner join property_fact_table
    on property_fact_table.location_key = location_dim.location_key

    where property_fact_table.apartment_number = 'Not Applicable'

    group by distinct_building.borough_name, distinct_building.neighborhood, distinct_building.block, distinct_building.lot
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