{% docs superstore_data_description %}

This table contains information related to the operations and functions of a retail superstore.

It was observed that, in instances where a customer, order, product, and region were identical,
there might be several rows, each depicting the same product within the same order.
In such cases, the sales, quantity, and profit values for that product in that order were aggregated, 
while the discount remained unchanged.

{% enddocs %}

{% docs customer_dim_description %}

A customer dimension containing unique combinations of customer ID, customer name, 
and segment, with customer ID serving as the primary key. 

While it is generally advisable to utilize an incremental key as the primary key, 
particularly when merging multiple tables, the small size of the dataset has led to 
the decision to use the customer ID as the primary key.

{% enddocs %}

{% docs product_dim_description %}

A product dimension containing unique combinations of product ID, product name, 
category, and subcategory, with an iterative key serving as the primary key.

The uniqueness of the product ID is compromised, as it is estimated that certain products, 
upon becoming extinct, had their IDs repurposed for newer products. The absence of specific 
dates indicating these changes makes incorporation into a slowly changing dimension impractical. 
As a result, the current approach adopts an iterative key to handle this situation.

{% enddocs %}

{% docs date_dim_description %}

A date dimension comprising date values ranging from "2014-01-03" to "2018-01-06".
The date values include date, year, quarter, month, day, and a numeric key corresponding to the date.

{% enddocs %}

{% docs order_dim_description %}

An order dimension containing unique combinations of order ID, order date, 
shipping date and shipping mode, with order ID serving as the primary key.

While it is generally advisable to utilize an incremental key as the primary key, 
particularly when merging multiple tables, the small size of the dataset has led to 
the decision to use the order ID as the primary key.

Even though integrating order ID, order date, ship date, and ship mode directly into the fact table
would necessitate only one join for accessing date values, the decision was made to preserve a 
distinct Order dimension. This choice is driven by the small dataset, and the need for a clearer 
understanding of the business case. Additionally, in the event of changes to order-related attributes, 
maintaining a separate Order dimension proves to be more straightforward, as updates only need to 
be made within that specific dimension.

{% enddocs %}

{% docs region_dim_description %}

A region dimension containing unique combinations of country, city, 
state, region, and postal code of every customer, with an iterative key serving as the primary key.

{% enddocs %}

{% docs sales_fct_description %}

A sales fact table in which each row corresponds to an item per order, 
with the combined foreign keys of customer ID, region iterative key, order ID, and product iterative key
serving as the primary key.

{% enddocs %}