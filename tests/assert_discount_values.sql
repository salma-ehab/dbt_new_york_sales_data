
{# Ensure that the discount is consistently equal to or greater than zero and less than one #}

select

discount

from {{ ref('superstore_data') }}

where discount < 0 and discount >= 1
