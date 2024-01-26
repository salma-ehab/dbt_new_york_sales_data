with 

dim_customer as
(
    select * from {{ ref('dim_customer') }}
),

dim_order as
(
    select * from {{ ref('dim_order') }}
),

dim_date as
(
    select * from {{ ref('dim_date') }}
),

fct_sales as
(
    select * from {{ ref('fct_sales') }}
),

monthly_customer_sales as
(
    select 

    dim_date.year_value,
    dim_date.month_value,
    dim_customer.customer_id,
    dim_customer.customer_name,
    round(sum(fct_sales.sales),3) as monthly_sales

    from fct_sales

    inner join dim_customer
    on fct_sales.customer_id = dim_customer.customer_id

    inner join dim_order
    on fct_sales.order_id = dim_order.order_id

    inner join dim_date
    on dim_order.order_date = dim_date.date_key

    group by dim_date.year_value, dim_date.month_value, dim_customer.customer_id, dim_customer.customer_name
    order by dim_date.year_value, dim_date.month_value, dim_customer.customer_id, dim_customer.customer_name
)

select * from monthly_customer_sales


