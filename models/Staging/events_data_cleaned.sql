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

clean_events_data as
(
    select 

    events_raw_data.event_id,
    events_raw_data.match_id,

    {# Adjustments were made to the team names, as it was observed that each match had only one team mentioned, 
       rather than specifying which team was responsible for the event. This rectification was achieved by 
       retrieving the team information from the match table, leveraging knowledge of the home and away teams.#}

    case when events_raw_data.event_team = 'Home'
    then matches_raw_data.team_name_home
    when events_raw_data.event_team = 'Away'
    then matches_raw_data.team_name_away
    end as team,

    events_raw_data.event_team,
    events_raw_data.event_time,
    events_raw_data.event_type,
    events_raw_data.action_player_1,

    {# In cases where the event was classified as a "penalty", the field for player 2 was nullified. 
       If the event was labeled as a "goal" and the player 2 field was either "Goal" or "Disallowed goal" or "Own goal", 
       the player 2 field was nullified. Otherwise, the field remained unchanged.#}

    case when events_raw_data.event_type = 'penalty'
    then null
    when events_raw_data.event_type = 'goal' and 
    (events_raw_data.action_player_2 = 'Goal' or events_raw_data.action_player_2 = 'Disallowed goal'
    or events_raw_data.action_player_2 = 'Own goal')
    then null
    else events_raw_data.action_player_2
    end as action_player_2,

    {# A supplementary column was added specifically for "penalty" events. 
       While this additional column stays null for non-penalty events, it indicates 
       either a "Penalty" or a "Missed penalty" when the event type is classified as "penalty".#}

    case when events_raw_data.event_type = 'penalty' and events_raw_data.action_player_2 = 'Penalty'
    then 'Penalty'
    when events_raw_data.event_type = 'penalty' and events_raw_data.action_player_2 = 'Missed penalty'
    then 'Missed penalty'
    else null
    end as penalty_outcome,

    {# A supplementary column was added specifically for "goal" events.
       While this additional column stays null for non-goal events, it indicates 
       either a goal or a disallowed goal or an own goal when the event type is classified as "goal".#}
       
    case when events_raw_data.event_type = 'goal' and events_raw_data.action_player_2 <> 'Disallowed goal'
    and events_raw_data.action_player_2 <> 'Own goal'
    then 'Goal'
    when events_raw_data.event_type = 'goal' and events_raw_data.action_player_2 = 'Disallowed goal'
    then 'Disallowed goal'
    when events_raw_data.event_type = 'goal' and events_raw_data.action_player_2 = 'Own goal'
    then 'Own goal'
    else null
    end as goal_status,

    events_raw_data.league_name,
    events_raw_data.season


    from events_raw_data
    inner join matches_raw_data 
    on  events_raw_data.match_id = matches_raw_data.match_id
    and events_raw_data.league_name = matches_raw_data.league_name
    and events_raw_data.season = matches_raw_data.season

   
)

select * from clean_events_data