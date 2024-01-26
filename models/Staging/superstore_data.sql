with 

{# Retrieve raw data #}
raw_data as
(
    select * from {{ source('superstore_data', 'superstore_table') }}
)


select * from raw_data