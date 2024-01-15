with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

location_dim as
(
    select * from {{ ref('location_dim') }}
),

neighborhood_most_total_units as
(
    select 

    location_dim.neighborhood,
    sum(property_fact_table.total_units) as max_total_units

    from property_fact_table
    inner join location_dim 
    on property_fact_table.location_key = location_dim.location_key

    group by location_dim.neighborhood
    order by max_total_units desc
    limit 1
)

select * from neighborhood_most_total_units