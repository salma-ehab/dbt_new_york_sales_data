{# Ensure that the quantity of the item ordered is consistently equal to or greater than one #}

select

quantity

from {{ ref('superstore_data') }}

where quantity < 1
