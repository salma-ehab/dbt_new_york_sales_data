with 

{# Retrieve raw data #}

raw_data as
(
    select * from {{ source('superstore_data', 'superstore_table') }}
),

{# It was observed that, in instances where a customer, order, product, and region were identical,
   there might be several rows, each depicting the same product within the same order.
   In such cases, the sales, quantity, and profit values for that product in that order were aggregated, 
   while the discount remained unchanged #}

clean_data as
(
    select 

    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    subcategory,
    product_name,
    sum (sales) as sales,
    sum (quantity) as quantity,
    discount,
    sum (profit) as profit

    from raw_data 

    group by order_id, order_date, ship_date, ship_mode, customer_id, customer_name, segment, country,
             city, state, postal_code, region, product_id, category, subcategory, product_name, discount
),

clean_data_row_number as
(
    select *, 
    row_number() over (order by order_id, order_date, ship_date, ship_mode, customer_id, customer_name, 
                       segment, country, city, state, postal_code, region, product_id, category, 
                       subcategory, product_name) as row_id

    from clean_data
)


select * from clean_data_row_number