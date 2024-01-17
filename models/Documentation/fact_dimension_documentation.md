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

{% docs property_specs_at_present_dim_description %}

This dimension encompasses only those building properties that are pertinent to the present.

The present values shouldn't be considered as slowly changing dimensions since they only change once with each 
sale occurrence. Thus, it is suitable to include them as dimensions associated with the sales fact table, 
given that these values experience changes solely in correlation with each sale.

{% enddocs %}