with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

property_specs_at_sale_dim as
(
    select * from {{ ref('property_specs_at_sale_dim') }}
),

building_class_category_highest_average_land_square_feet as
(
    select 

    property_specs_at_sale_dim.building_class_category,
    avg(property_fact_table.land_square_feet) as avg_land_square_feet

    from property_fact_table
    inner join property_specs_at_sale_dim
    on property_fact_table.property_specs_at_sale_key = property_specs_at_sale_dim.property_specs_at_sale_key

    group by property_specs_at_sale_dim.building_class_category
    order by avg_land_square_feet desc
    limit 1
)

select * from building_class_category_highest_average_land_square_feet