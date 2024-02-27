{# Ensure that the score for the home team matches that of the events. #}

with 

events_cleaned_data as
(
    select * from {{ ref('events_data_cleaned') }}
),

matches_cleaned_data as
(
    select * from {{ ref('matches_data_cleaned') }}
),

home_team_score as
(
    select

    sum (case when (events_data_cleaned.event_type = 'goal'
    and events_data_cleaned.event_team = 'Home' and events_data_cleaned.goal_status <> 'Disallowed goal')
    or (events_data_cleaned.event_type = 'penalty' and events_data_cleaned.event_team = 'Home' 
    and events_data_cleaned.penalty_outcome <> 'Missed penalty')
    then 1
    else 0
    end) over (partition by matches_data_cleaned.match_id, matches_data_cleaned.league_name) as score_by_home_team,

    matches_data_cleaned.team_home_score

    from matches_data_cleaned
    left join  events_data_cleaned
    on matches_data_cleaned.league_name = events_data_cleaned.league_name
    and matches_data_cleaned.match_id = events_data_cleaned.match_id
    and (events_data_cleaned.event_type = 'goal' or events_data_cleaned.event_type = 'penalty')

)

select *
from home_team_score
where score_by_home_team <> team_home_score

