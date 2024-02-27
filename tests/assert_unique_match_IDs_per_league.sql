{# Ensure that each match ID is unique within its respective league. #}

select

match_id, league_name

from {{ ref('matches_data_cleaned') }}

group by match_id, league_name

having count(*) > 1