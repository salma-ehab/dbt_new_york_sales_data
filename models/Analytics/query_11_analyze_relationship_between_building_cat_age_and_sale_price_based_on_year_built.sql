with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

property_specs_at_sale_dim as
(
    select * from {{ ref('property_specs_at_sale_dim') }}
),

{# The dataset was filtered to exclude cases where the year built was null, 
   indicating missing data, and sale price was zero, 
   suggesting a transfer of ownership without a cash consideration #}
   
analyze_relationship_bet_building_cat_age_and_sale_price_based_on_year_built as
(
     select 

     property_specs_at_sale_dim.year_built,
     property_specs_at_sale_dim.decade_built,
     max(property_fact_table.sales_price) max_sales_price,
     min(property_fact_table.sales_price) min_sales_price,
     avg(property_fact_table.sales_price) avg_sales_price,
     percentile_cont(0.5) within group (order by property_fact_table.sales_price) as median_sales_price,
     stddev(property_fact_table.sales_price) as std_dev_sales_price

     from property_fact_table
     inner join property_specs_at_sale_dim
     on property_fact_table.property_specs_at_sale_key = property_specs_at_sale_dim.property_specs_at_sale_key

     where property_specs_at_sale_dim.year_built is not null
     and property_fact_table.sales_price != 0

     group by property_specs_at_sale_dim.year_built, property_specs_at_sale_dim.decade_built
     order by property_specs_at_sale_dim.year_built, property_specs_at_sale_dim.decade_built 

)

select * from analyze_relationship_bet_building_cat_age_and_sale_price_based_on_year_built