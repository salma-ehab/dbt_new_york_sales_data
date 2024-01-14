{# The location dimension encompasses attributes borough_name, borough_code, neighborhood, block, lot, and zip_code. 
Despite the inclusion of block, lot, and zip_code leading to an increase in the number of rows within this dimension, 
their incorporation was motivated by the recognition that these attributes might be utilized for grouping and filtering 
in future analyses. Although their usage may be infrequent, there is a possibility that they could prove valuable for 
upcoming work. As part of future developments, there's consideration to incorporate these attributes into another dimension, 
possibly snowflaked to the existing location dimension #}

{# This also implies that as data is accumulated over future years, 
the dimension will maintain stability, while the fact will continue to grow #}

with 

clean_data_source as 
(
    select * from {{ ref('clean_raw_sales_data') }}
),

location_dim as
(
    select distinct

    borough_name, 
    borough_code,
    neighborhood,
    block,
    lot,
    zip_code,

    dense_rank () over 
    (order by borough_name, borough_code, neighborhood, block, lot, zip_code) as location_key

    from clean_data_source

)

select * from location_dim