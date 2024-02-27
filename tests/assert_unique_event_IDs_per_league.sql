{# Ensure that each event ID is unique within its respective league. #}

select

event_id, league_name

from {{ ref('events_data_cleaned') }}

group by event_id, league_name

having count(*) > 1