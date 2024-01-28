with 

dim_customer as
(
    select * from {{ ref('dim_customer') }}
),

dim_order as
(
    select * from {{ ref('dim_order') }}
),

dim_product as
(
    select * from {{ ref('dim_product') }}
),

dim_date as
(
    select * from {{ ref('dim_date') }}
),


fct_sales as
(
    select * from {{ ref('fct_sales') }}
),

preferred_category as 
(
    select

    dim_customer.customer_id,
    dim_product.category,
    sum(fct_sales.quantity) as category_quantity,
    sum(fct_sales.sales) as category_sales,
    
    rank() over (partition by dim_customer.customer_id
    order by sum(fct_sales.quantity) desc, sum(fct_sales.sales) desc) as category_rank

    from fct_sales

    inner join dim_customer
    on fct_sales.customer_id = dim_customer.customer_id

    inner join dim_product
    on fct_sales.product_iterative_key = dim_product.product_iterative_key

    group by dim_customer.customer_id, dim_product.category
    order by dim_customer.customer_id, dim_product.category
),

preferred_subcategory as 
(
    select

    dim_customer.customer_id,
    dim_product.subcategory,
    sum(fct_sales.quantity) as subcategory_quantity,
    sum(fct_sales.sales) as subcategory_sales,

    rank() over (partition by dim_customer.customer_id
    order by sum(fct_sales.quantity) desc, sum(fct_sales.sales) desc) as subcategory_rank

    from fct_sales

    inner join dim_customer
    on fct_sales.customer_id = dim_customer.customer_id

    inner join dim_product
    on fct_sales.product_iterative_key = dim_product.product_iterative_key

    group by dim_customer.customer_id, dim_product.subcategory
    order by dim_customer.customer_id, dim_product.subcategory
),

customer_metrics as
(
    select 

    dim_customer.customer_id,
    dim_customer.customer_name,
    dim_customer.segment,

    case
    when datediff(day, max(dim_date.date_value), '2017-12-31') > 90 
    then 'Not Active'
    else 'Active'
    end as customer_status,

    count(distinct dim_order.order_id) as total_orders,
    round(sum(fct_sales.sales),3) as customer_lifetime_sales,
    round((sum(fct_sales.sales) /  count(distinct dim_order.order_id)),3) as average_order_value,
    
    datediff(day, min (dim_date.date_value), max(dim_date.date_value)) as customer_life_span_in_days,
    max(dim_date.date_value) as latest_order_date,
    datediff(day, max(dim_date.date_value), '2017-12-31') as recency_in_days,
    
    round((datediff(day, min (dim_date.date_value), max(dim_date.date_value)) / 
    count(distinct dim_order.order_id)), 3) as average_time_gap,

    preferred_category.category as preferred_category,
    preferred_subcategory.subcategory as preferred_subcategory,
    round(avg(fct_sales.quantity),3) as average_basket_size


    from fct_sales

    inner join dim_customer
    on fct_sales.customer_id = dim_customer.customer_id

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    inner join dim_product
    on fct_sales.product_iterative_key = dim_product.product_iterative_key

    inner join dim_date
    on dim_order.order_date = dim_date.date_key

    inner join preferred_category 
    on dim_customer.customer_id = preferred_category .customer_id 
    and category_rank = 1

    inner join preferred_subcategory 
    on dim_customer.customer_id = preferred_subcategory .customer_id 
    and subcategory_rank = 1

    group by dim_customer.customer_id, dim_customer.customer_name, dim_customer.segment,
    preferred_category.category, preferred_subcategory.subcategory
    order by dim_customer.customer_id, dim_customer.customer_name
)

select * from customer_metrics


