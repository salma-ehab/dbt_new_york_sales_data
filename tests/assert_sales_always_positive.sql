{# Ensure that the sales of an ordered item are consistently positive #}

select

sales

from {{ ref('superstore_data') }}

where sales < 0
