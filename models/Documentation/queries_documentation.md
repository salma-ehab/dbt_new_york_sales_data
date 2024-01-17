{% docs query_4_description %}

This query involved tallying the number of buildings based on various dimensions. 

This entailed counting buildings in each neighborhood, borough, and block, 
and subsequently combining all the data through a union operation.

It was noted that multiple records for the same building may exist due to occasional missing or 
incorrectly entered zip codes. To ensure the unique identification of buildings in such instances, 
distinctive combinations of borough, neighborhood, block, and lot were chosen.

{% enddocs %}

{% docs query_5_description %}

This query entailed calculating cumulative sales figures across different date intervals.

The analysis was conducted on a yearly, monthly, and quarterly basis, avoiding daily breakdowns to 
enhance result readability. Subsequently, the data was consolidated using a union operation.

{% enddocs %}

{% docs query_6_description %}

This query involved  grouping the data by the current tax class and the tax class at the time of sale, 
followed by comparing the average sale prices for each combination, determining whether they were greater, lesser, or equal. 

The unknown class category was excluded due to its status as a missing data value.

{% enddocs %}