with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

location_dim as
(
    select * from {{ ref('location_dim') }}
),

avg_borough_sale_price as
(
    select 

    location_dim.borough_name,
    location_dim.borough_code,
    avg(property_fact_table.sales_price) as avg_borough_sales_price

    from property_fact_table
    inner join location_dim 
    on property_fact_table.location_key = location_dim.location_key

    group by location_dim.borough_name, location_dim.borough_code
    order by location_dim.borough_code asc
)

select * from avg_borough_sale_price