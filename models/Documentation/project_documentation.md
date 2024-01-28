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

{% docs sales_and_profit_trends_over_time_query_description %}

This query aims to retrieve trends in sales and profit over time, encompassing metrics such as 
the count of unique orders, total sum, average, 25th percentile, median, 75th percentile, 
standard deviation, as well as the growth rates for both sales and profit, along with the profit margin.

The computation was executed on a yearly, quarterly and monthly basis, with a deliberate decision 
to avoid daily breakdowns for enhanced result clarity.

{% enddocs %}

{% docs product_category_and_subcategory_metrics_query_description %}

This query aims to extract metrics for product categories and subcategories, encompassing measures 
such as the number of distinct orders, the total number of purchased products, total sum, 
average, 25th percentile, median, 75th percentile, standard deviation for both sales and profit, 
along with the profit margin.

{% enddocs %}

{% docs customer_metrics_query_description %}

This query is designed to collect various customer metrics, including 
customer_status (active or inactive, determined by no sales within the last 90 days), 
distinct order count, lifetime sales, average order value, customer lifespan in days, 
latest order date, recency in days, average time gap between orders, 
preferred category and subcategory products (determined by the most frequently purchased items, 
with ties broken by selecting the one with the highest selling price), and finally, average basket size.

{% enddocs %}

{% docs categories_and_subcategories_sales_and_profit_growth_rates_query_description %}

This query aims to compute the monthly growth rates of sales and profits for 
every product category and subcategory. In instances where certain subcategories 
have no sales in a given month, the growth rates for both sales and profits in the 
subsequent month are null, as there is no basis for comparison.

{% enddocs %}

{% docs location_metrics_query_description %}

This query aims to extract metrics for every location, encompassing measures 
such as the number of distinct orders, total sum, average, 25th percentile, median, 75th percentile, 
standard deviation for both sales and profit, along with the profit margin.

{% enddocs %}

{% docs location_sales_and_profit_growth_rates_query_description %}

This query aims to compute the monthly growth rates of sales and profits for 
every location. In instances where certain locations have no sales in a given month, 
the growth rates for both sales and profits in the subsequent month are null, 
as there is no basis for comparison.

{% enddocs %}

{% docs category_and_subcategory_metrics_by_location_query_description %}

This query aims to obtain metrics for categories and subcategories specific to each location. 
It seeks to gather, for each specific location, category, and subcategory, the total number of distinct orders, 
the total number of purchased products, the total sum, and average values for both sales and profits, 
along with the associated profit margin.

{% enddocs %}

{% docs products_with_highest_profit_margins_query_description %}

This query seeks to identify the top 10 products exhibiting the greatest profit margins, 
accompanied by their respective counts of distinct orders and the number of purchased products.

{% enddocs %}

{% docs products_with_lowest_profit_margins_query_description %}

This query seeks to identify the top 10 products exhibiting the smallest profit margins, 
accompanied by their respective counts of distinct orders and the number of purchased products.

{% enddocs %}

{% docs locations_with_highest_profit_margins_query_description %}

This query seeks to identify the top 10 locations exhibiting the greatest profit margins, 
accompanied by their respective counts of distinct orders.

{% enddocs %}

{% docs locations_with_lowest_profit_margins_query_description %}

This query seeks to identify the top 10 locations exhibiting the smallest profit margins, 
accompanied by their respective counts of distinct orders.

{% enddocs %}

{% docs top_selling_products_query_description %}

A query to retrieve the top 10 selling products accompanied by their 
respective counts of distinct orders and the number of purchased products.

{% enddocs %}

{% docs impact_of_discounts_on_sales_and_profit_query_description %}

This query aims to analyze how discounts affect sales and profits on a per-product basis. 
It seeks to retrieve unique counts of orders, total products purchased, overall sums, 
and averages for both sales and profits for each combination of discount and product. 
Additionally, it includes a calculation for profit margin.

{% enddocs %}