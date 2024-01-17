{% docs cleaned_tax_class_at_present_description %}

Transformed tax classes at present to only include the main class and do not encompass any subclasses.

Also, replaced any null values with a descriptive string 'Unknown'.

{% enddocs %}

{% docs cleaned_tax_subclass_at_present_description %}

Added tax subclass at present field to encompass both the main class and its associated subclasses.

Also, replaced any null values with a descriptive string 'Unknown'.

{% enddocs %}

{% docs cleaned_address_description %}

Updated addresses by relocating apartment numbers from the address field to 
incorporate them into the apartment number field.

{% enddocs %}

{% docs cleaned_apartment_number_description %}

The apartment numbers now include those that were initially within the address field 
but were not originally assigned to their designated column.

Also, replaced any null values with a descriptive string 'Not Applicable'.

{% enddocs %}

{% docs cleaned_zip_code_description %}

Since there are no valid zero zip codes in the USA, they have been substituted with the descriptive string 
'Unknown,' as well as any null values.

{% enddocs %}

{% docs cleaned_units_description %}

This field was reformatted to establish consistency across multiple files, 
aligning them with the 2018 format. 

The 2018 format, being devoid of dashes, served as a benchmark. 

In this format, it was observed that fields related to units and square feets were null when certain dimensions, 
like the building_class_column, were also null. Despite this, instances occurred where residential and commercial 
units equaled zero while total units did not. Furthermore, there were situations where all units were registered 
as zero, yet the land square feet were not. 

To address these variations, a decision was made to assign null values 
to all units and feets when fields like building_class were null. This adjustment was considered necessary upon 
recognizing a pattern in the 2016 format, where, in the absence of data in that column, all units and square feets 
were represented as dashes. While in the 2017 format, units were zeros, and square feets were represented as dashes.

Furthermore, commas were eliminated from this field to ease data aggregations, and the field's type was changed to a small integer.

{% enddocs %}

{% docs cleaned_feets_description %}

This field was reformatted to establish consistency across multiple files, 
aligning them with the 2018 format. 

The 2018 format, being devoid of dashes, served as a benchmark.  

In this format, it was observed that fields related to units and square feets were null when certain dimensions, 
like the building_class_column, were also null. Despite this, instances occurred where residential and commercial 
units equaled zero while total units did not. Furthermore, there were situations where all units were registered 
as zero, yet the land square feet were not. 

To address these variations, a decision was made to assign null values 
to all units and feets when fields like building_class were null. This adjustment was considered necessary upon 
recognizing a pattern in the 2016 format, where, in the absence of data in that column, all units and square feets 
were represented as dashes. While in the 2017 format, units were zeros, and square feets were represented as dashes.

Furthermore, commas were eliminated from this field to ease data aggregations, and the field's type was changed to an integer.

{% enddocs %}

{% docs cleaned_year_built_description %}

If this field contained a value of 0, it was set to null, especially in cases where aggregations, 
including the calculation of minimum values, were needed.

Furthermore, the field's type was changed to a small integer.

{% enddocs %}

{% docs cleaned_sales_price_description %}

Removed commas and other extraneous characters from this field to facilitate aggregations on the data.

Furthermore, the field's type was changed to an integer.

{% enddocs %}