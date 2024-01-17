with 

property_fact_table as
(
    select * from {{ ref('property_facts') }}
),

date_dim as
(
    select * from {{ ref('date_dim') }}
),

property_specs_at_sale_dim as
(
    select * from {{ ref('property_specs_at_sale_dim') }}
),


{# The dataset was filtered to exclude cases where the year built was null, 
   indicating missing data, and sale price was zero, 
   suggesting a transfer of ownership without a cash consideration #}

diff_in_years_bet_sale_date_and_year_built as
(
    select 

    date_dim.year_value,
    property_specs_at_sale_dim.year_built,
    date_dim.year_value - property_specs_at_sale_dim.year_built as diff_in_years,
    property_fact_table.sales_price

    from
    property_fact_table

    inner join date_dim
    on property_fact_table.date_key = date_dim.date_key

    inner join property_specs_at_sale_dim
    on property_fact_table.property_specs_at_sale_key = property_specs_at_sale_dim.property_specs_at_sale_key

    where property_specs_at_sale_dim.year_built is not null
    and property_fact_table.sales_price != 0
),


analyze_distribution_of_sale_price_based_on_diff_in_years_bet_sale_date_and_year_built as
(
    select 

    diff_in_years,
    max(sales_price) max_sales_price,
    min(sales_price) min_sales_price,
    avg(sales_price) avg_sales_price,
    percentile_cont(0.5) within group (order by sales_price) as median_sales_price,
    stddev(sales_price) as std_dev_sales_price

    from diff_in_years_bet_sale_date_and_year_built

    group by diff_in_years
    order by diff_in_years



)

select *  from analyze_distribution_of_sale_price_based_on_diff_in_years_bet_sale_date_and_year_built