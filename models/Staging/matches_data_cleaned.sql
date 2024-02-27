with 

{# Retrieve raw data #}

events_raw_data as
(
    select * from {{ source('european_football_data', 'events_table') }}
),

matches_raw_data as
(
    select * from {{ source('european_football_data', 'matches_final_data_table') }}
),

clean_matches_data as
(
    select distinct

    matches_raw_data.match_id,
    matches_raw_data.stage_name,

    case when matches_raw_data.match_date = 'Yesterday'
    then to_date('10/06/2023', 'dd/mm/yyyy')
    else to_date(substring(matches_raw_data.match_date, 1, 2) || '/' ||
                     substring(matches_raw_data.match_date, 4, 2) || '/' ||
                     substring(matches_raw_data.match_date, 7, 4), 'dd/mm/yyyy')
    end as match_date,

    case when events_raw_data.event_type = 'penalty'
    then true
    else false
    end as pens,

    sum (case when events_raw_data.event_type = 'penalty'
    and events_raw_data.event_team = 'Home' and events_raw_data.action_player_2 = 'Penalty'
    then 1
    else 0
    end) over (partition by matches_raw_data.match_id, matches_raw_data.league_name) as pens_home_score,

    sum (case when events_raw_data.event_type = 'penalty'
    and events_raw_data.event_team = 'Away' and events_raw_data.action_player_2 = 'Penalty'
    then 1
    else 0
    end) over (partition by matches_raw_data.match_id, matches_raw_data.league_name) as pens_away_score,

    matches_raw_data.team_name_home,
    matches_raw_data.team_name_away,
    matches_raw_data.team_home_score,
    matches_raw_data.team_away_score,
    matches_raw_data.possession_home,
    matches_raw_data.possession_away,
    matches_raw_data.total_shots_home,
    matches_raw_data.total_shots_away,
    matches_raw_data.shots_on_target_home,
    matches_raw_data.shots_on_target_away,
    matches_raw_data.duels_won_home,
    matches_raw_data.duels_won_away,
    matches_raw_data.prediction_team_home_win,
    matches_raw_data.prediction_draw,
    matches_raw_data.prediction_team_away_win,
    matches_raw_data.prediction_quantity,
    matches_raw_data.prediction_location,

    matches_raw_data.player_1_home_name,
    matches_raw_data.player_1_home_number,
    matches_raw_data.player_2_home_name,
    matches_raw_data.player_2_home_number,
    matches_raw_data.player_3_home_name,
    matches_raw_data.player_3_home_number,


    matches_raw_data.league_name

    from matches_raw_data
    left join events_raw_data
    on matches_raw_data.league_name = events_raw_data.league_name
    and matches_raw_data.match_id = events_raw_data.match_id
    and events_raw_data.event_type = 'penalty'
)

select * from clean_matches_data