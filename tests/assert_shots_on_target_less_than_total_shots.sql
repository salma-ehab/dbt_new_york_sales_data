{# Ensure that shots on target is less than total shots. #}

select

total_shots_home, total_shots_away, shots_on_target_home, shots_on_target_away

from {{ ref('matches_data_cleaned') }}

where (shots_on_target_home > total_shots_home) or  (shots_on_target_away > total_shots_away)
