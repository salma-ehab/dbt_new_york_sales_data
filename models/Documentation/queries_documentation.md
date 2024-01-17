{% docs query_4_description %}

This query involved tallying the number of buildings based on various dimensions. 

This entailed counting buildings in each neighborhood, borough, and block, 
and subsequently combining all the data through a union operation.

It was noted that multiple records for the same building may exist due to occasional missing or 
incorrectly entered zip codes. To ensure the unique identification of buildings in such instances, 
distinctive combinations of borough, neighborhood, block, and lot were chosen.

{% enddocs %}