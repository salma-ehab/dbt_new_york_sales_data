{% docs location_dim_description %}

The location dimension encompasses attributes borough_name, borough_code, neighborhood, block, lot, and zip_code.

While the addition of block, lot, and zip_code results in a greater number of rows within this dimension, 
their incorporation was motivated by the recognition that these attributes might be utilized for grouping and filtering 
in future analyses. Although their usage may be infrequent, there is a possibility that they could prove valuable for 
upcoming work.

{% enddocs %}

{% docs property_specs_at_sale_dim_description %}

This dimension encompasses building properties, excluding those pertaining to the present.

It is crucial to maintain a separation between present and at sale properties as combining them 
would inevitably result in a higher row count.

{% enddocs %}