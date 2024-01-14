with 

clean_data_source as 
(
    select * from {{ ref('clean_raw_sales_data') }}
),

loctaion_dimension as
(
    select * from {{ ref('location_dim') }}
),

property_specs_at_sale_dim as
(
    select * from {{ ref('property_specs_at_sale_dim') }}
),

property_specs_at_present_dim as
(
    select * from {{ ref('property_specs_at_present_dim') }}
),

date_dim as
(
    select * from {{ ref('date_dim') }}
),

{# Each row in this fact table signifies the sales of a building. 
   Address and apartment number have been included as degenerate dimensions 
   since they are descriptive fields. These fields are not utilized for grouping or filtering, 
   and their inclusion in any dimension would only contribute to the increase of its size#}

property_fact_table as
(
    select 

    clean_data_source.sales_price,
    clean_data_source.residential_units, 
    clean_data_source.commercial_units,
    clean_data_source.total_units,
    clean_data_source.land_square_feet,
    clean_data_source.gross_square_feet,
    clean_data_source.address,
    clean_data_source.apartment_number,
    loctaion_dimension.location_key,
    property_specs_at_sale_dim.property_specs_at_sale_key,
    property_specs_at_present_dim.property_specs_at_present_key,
    date_dim.date_key

    
    from clean_data_source


    inner join loctaion_dimension
    on clean_data_source.borough_name = loctaion_dimension.borough_name
    and clean_data_source.borough_code = loctaion_dimension.borough_code
    and clean_data_source.neighborhood = loctaion_dimension.neighborhood
    and clean_data_source.block = loctaion_dimension.block
    and clean_data_source.lot = loctaion_dimension.lot
    and clean_data_source.zip_code = loctaion_dimension.zip_code

    left join property_specs_at_sale_dim
    on clean_data_source.building_class_category = property_specs_at_sale_dim.building_class_category
    and clean_data_source.building_class_at_time_of_sale = property_specs_at_sale_dim.building_class_at_time_of_sale
    and clean_data_source.tax_class_at_time_of_sale = property_specs_at_sale_dim.tax_class_at_time_of_sale
    and clean_data_source.easement = property_specs_at_sale_dim.easement
    and (clean_data_source.year_built = property_specs_at_sale_dim.year_built or (clean_data_source.year_built is null and property_specs_at_sale_dim.year_built is null))
    and (clean_data_source.decade_built = property_specs_at_sale_dim.decade_built or (clean_data_source.decade_built is null and property_specs_at_sale_dim.decade_built is null))

    left join property_specs_at_present_dim
    on clean_data_source.building_class_at_present = property_specs_at_present_dim.building_class_at_present
    and clean_data_source.tax_class_at_present = property_specs_at_present_dim.tax_class_at_present
    and clean_data_source.tax_subclass_at_present = property_specs_at_present_dim.tax_subclass_at_present

    left join date_dim
    on clean_data_source.sale_date = date_dim.date_value

)

select * from property_fact_table