{# The task involved tallying the number of buildings based on various dimensions. 
  This entailed counting buildings in each neighborhood, borough, and block, 
  and subsequently combining all the data through a union operation #}

{# It was observed that at times, the zip code was unknown. 
   To uniquely identify buildings, the approach involved selecting distinct combinations of borough name, 
   neighborhood, block, and lot #}

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