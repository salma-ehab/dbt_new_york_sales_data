{# The task involved tallying the number of buildings based on various dimensions. 
  This entailed counting buildings in each neighborhood, borough, and block, 
  and subsequently combining all the data through a union operation #}

{# It was noted that multiple records for the same building may exist due to occasional missing or 
  incorrectly entered zip codes. To ensure the unique identification of buildings in such instances, 
  distinctive combinations of borough, neighborhood, block, and lot were chosen #}

with 

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

count_buildings_no_by_different_dimensions as
(
    select 

    borough_name,
    null as neighborhood,
    null as block,
    count(*) as building_count
    
    from distinct_building

    group by borough_name

    union

    select 

    borough_name,
    neighborhood,
    null as block,
    count(*) as building_count

    from distinct_building

    group by borough_name, neighborhood

    union

    select 

    borough_name,
    neighborhood,
    block,
    count(*) as building_count

    from distinct_building

    group by borough_name, neighborhood, block

)

select * from count_buildings_no_by_different_dimensions
order by borough_name, neighborhood, block