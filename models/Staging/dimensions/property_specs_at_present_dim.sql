{# The current values shouldn't be considered as slowly changing dimensions since they only change once with each 
sale occurrence. Thus, it is suitable to include them as dimensions associated with the sales fact table, 
given that these values experience changes solely in correlation with each sale #}

with 

clean_data_source as 
(
    select * from {{ ref('clean_raw_sales_data') }}
),

property_specs_at_present_dim as
(
    select distinct

    building_class_at_present,
    tax_class_at_present,
    tax_subclass_at_present,

    dense_rank () over 
    (order by  building_class_at_present, tax_class_at_present, tax_subclass_at_present) 
     as property_specs_at_present_key

    from clean_data_source

)

select * from property_specs_at_present_dim