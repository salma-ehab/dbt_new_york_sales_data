{% docs query_4_description %}

This query involved tallying the number of buildings based on various dimensions. 

This entailed counting buildings in each neighborhood, borough, and block, 
and subsequently combining all the data through a union operation.

It was noted that multiple records for the same building may exist due to occasional missing or 
incorrectly entered zip codes. To ensure the unique identification of buildings in such instances, 
distinctive combinations of borough, neighborhood, block, and lot were chosen.

{% enddocs %}

{% docs query_5_description %}

This query entailed calculating total sales figures across different date intervals.

The analysis was conducted on a yearly, monthly, and quarterly basis, avoiding daily breakdowns to 
enhance result readability. Subsequently, the data was consolidated using a union operation.

{% enddocs %}

{% docs query_6_description %}

This query involved  grouping the data by the current tax class and the tax class at the time of sale, 
followed by comparing the average sale prices for each combination, determining whether they were greater, lesser, or equal. 

The unknown class category was excluded due to its status as a missing data value.

{% enddocs %}

{% docs query_7_description %}

This query is designed to identify the top 5 most expensive buildings based on sale price.

The identification process focuses on factors such as borough, neighborhood, block, and lot, 
rather than the address. This approach is taken due to variations in address representation, 
where the same location might be expressed differently (e.g., "street" or "st" and "3rd" or "3").

It has been observed that multiple records for the same building may exist, 
primarily due to occasional missing or incorrectly entered zip codes. To ensure the unique identification of 
buildings in such instances, distinctive combinations of borough, neighborhood, block, and lot were 
grouped together, disregarding the zip code.

{% enddocs %}

{% docs query_8_description %}

This query involved utilizing a window function to calculate the running total of sales prices.

The computation was executed on a yearly and monthly basis, with a deliberate decision to 
avoid daily breakdowns for enhanced result clarity.

{% enddocs %}

{% docs query_9_description %}

This query involved grouping the data based on a column representing the difference in 
years between the sale date and the year built, and subsequently 
analyzing the distribution of sale prices.

The analysis included obtaining the maximum, minimum, average, median, and 
standard deviation for each group based on the year difference column.

The data was filtered to exclude cases where the year built was null, indicating missing data, 
and the sale price was zero, suggesting a transfer of ownership without a cash consideration.

{% enddocs %}

{% docs query_10_description %}

This query serves the purpose of identifying the sales linked to a building, 
particularly when the building has been involved in multiple sales transactions.

The identification process focuses on factors such as borough, neighborhood, block, and lot, 
rather than the address. This approach is taken due to variations in address representation, 
where the same location might be expressed differently (e.g., "street" or "st" and "3rd" or "3").

It has been observed that multiple records for the same building may exist, 
primarily due to occasional missing or incorrectly entered zip codes. To ensure the unique identification of 
buildings in such instances, distinctive combinations of borough, neighborhood, block, and lot were 
grouped together, disregarding the zip code and location key. Thus, buildings sold multiple times 
had to be reconnected with the location dimension to retrieve the location key.

{% enddocs %}

{% docs query_11_description %}

This query is aimed at analyzing sale prices based on the year built and the decade built. 
The process involves grouping the data by year and decade and then analyzing the distribution of sale prices.

The analysis included obtaining the maximum, minimum, average, median, and 
standard deviation for each group.

The data was filtered to exclude cases where the year built was null, indicating missing data, 
and the sale price was zero, suggesting a transfer of ownership without a cash consideration.

{% enddocs %}