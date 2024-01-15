{# This task required grouping the data based on current tax class and tax class at the time of sale, 
  followed by comparing the average sale prices for each combination. 
  The unknown class category was excluded due to its status as a missing data value #}

with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

property_specs_at_present_dim as
(
    select * from {{ ref('property_specs_at_present_dim') }}
),

property_specs_at_sale_dim as
(
    select * from {{ ref('property_specs_at_sale_dim') }}
),

avg_sale_price_tax_present as
(
    select 

    property_specs_at_present_dim.tax_class_at_present,
    avg(property_fact_table.sales_price) as avg_sale_price

    from property_fact_table
    inner join property_specs_at_present_dim
    on property_fact_table.property_specs_at_present_key = property_specs_at_present_dim.property_specs_at_present_key

    where property_specs_at_present_dim.tax_class_at_present != 'Unknown'

    group by property_specs_at_present_dim.tax_class_at_present
    order by property_specs_at_present_dim.tax_class_at_present asc
),

avg_sale_price_tax_at_sale as
(
    select 

    property_specs_at_sale_dim.tax_class_at_time_of_sale,
    avg(property_fact_table.sales_price) as avg_sale_price

    from property_fact_table
    inner join property_specs_at_sale_dim
    on property_fact_table.property_specs_at_sale_key = property_specs_at_sale_dim.property_specs_at_sale_key

    group by property_specs_at_sale_dim.tax_class_at_time_of_sale
    order by property_specs_at_sale_dim.tax_class_at_time_of_sale asc
),

compare_avg_sale_price_each_combination_tax_present_tax_at_sale as
(
    select 
            
    avg_sale_price_tax_present.tax_class_at_present,
    avg_sale_price_tax_present.avg_sale_price as avg_sale_price_present,
    avg_sale_price_tax_at_sale.tax_class_at_time_of_sale,
    avg_sale_price_tax_at_sale.avg_sale_price as avg_sale_price_at_sale,

    case when avg_sale_price_tax_present.avg_sale_price > avg_sale_price_tax_at_sale.avg_sale_price
         then 'Tax class at present surpasses tax class at sale'
         when avg_sale_price_tax_present.avg_sale_price < avg_sale_price_tax_at_sale.avg_sale_price
         then 'Tax class at present is less than tax class at sale'
         else 'Tax class at present is the same as tax class at sale'
    end as comparing_avg_sale_price


    from avg_sale_price_tax_present
    cross join avg_sale_price_tax_at_sale

    order by  avg_sale_price_tax_present.tax_class_at_present, avg_sale_price_tax_at_sale.tax_class_at_time_of_sale
)

select * from compare_avg_sale_price_each_combination_tax_present_tax_at_sale