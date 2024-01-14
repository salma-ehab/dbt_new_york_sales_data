{# It is essential to separate properties at the time of sale and present properties into two distinct dimensions. 
Merging them would inevitably lead to a higher number of rows #}

with 

clean_data_source as 
(
    select * from {{ ref('clean_raw_sales_data') }}
),

property_specs_at_sale_dim as
(
    select distinct

    building_class_category,
    building_class_at_time_of_sale, 
    tax_class_at_time_of_sale,
    easement,
    year_built,
    decade_built,

    dense_rank () over 
    (order by building_class_category, building_class_at_time_of_sale, tax_class_at_time_of_sale,
              easement, year_built, decade_built) as property_specs_at_sale_key

    from clean_data_source

)

select * from property_specs_at_sale_dim