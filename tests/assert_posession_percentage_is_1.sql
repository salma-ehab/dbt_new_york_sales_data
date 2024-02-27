{# Ensure that posession percentage is equal to 1 for all matches. #}

select

possession_home, possession_away

from {{ ref('matches_data_cleaned') }}

where possession_home + possession_away <> 1

