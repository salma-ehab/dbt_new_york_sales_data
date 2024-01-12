with 

{# Retrieve raw data #}
raw_data as
(
    select * from {{ source('sales_data', 'sales_data_table') }}
),

{# Clean raw data #}
cleaned_data as
(
    select 

    borough_name,
    borough as borough_code,
    neighborhood,
    building_class_category,

    {# Create two columns, one for tax classes and the other for subclasses #}
    coalesce(
    case
      when length(tax_subclass_at_present) > 1 
      then left(tax_subclass_at_present, 1)
      else tax_subclass_at_present
    end,'Unknown') as tax_class_at_present,
    coalesce(tax_subclass_at_present,'Unknown') as tax_subclass_at_present,

    {# Replace null values with discriptive strings #}
    block,
    lot,
    coalesce(easement, 'No Easement') as easement,
    coalesce(building_class_at_present, 'Unknown') as building_class_at_present,
    Address,
    coalesce(apartment_number, 'Not Applicable') as apartment_number,
 
   {# As there are no valid zero zip codes in the USA, they have been replaced with 'unknown', same with null #}
    case
      when zip_code = 0 or zip_code is null 
      then 'Unknown'
      else zip_code
    end as zip_code,

   {# Reformat the columns to ensure uniformity across various files and align them with the 2018 format #}
   {{ transform_and_cast_column('residential_units','building_class_at_present','smallint') }},
   {{ transform_and_cast_column('commercial_units','building_class_at_present','smallint') }},
   {{ transform_and_cast_column('total_units','building_class_at_present','smallint') }},
   {{ transform_and_cast_column('land_square_feet','building_class_at_present','integer') }},
   {{ transform_and_cast_column('gross_square_feet','building_class_at_present','integer') }},

   {# If the year was 0, it was configured as null, particularly for scenarios where 
   aggregations, including calculating minimum values, were required #}
   cast (case
          when year_built = '0'
          then null
          else year_built
         end as smallint) as year_built,

    tax_class_at_time_of_sale,
    building_class_at_time_of_sale,

    {# Remove commas and other extraneous characters from fields to facilitate aggregations on the data #}
    cast (case 
           when sales_price = '-' 
           then 0
           else regexp_replace(regexp_replace(sales_price, ',', ''), '\\$', '') 
          end as integer ) as sales_price,
 
    sale_date,
    sale_year


    from raw_data

)

select * from cleaned_data