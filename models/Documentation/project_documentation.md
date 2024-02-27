{% docs source_data_action_player_2_description %}

If a yellow card or red card event occurs, the Action Player 2 field is always null.

In the case of a penalty event, the field is either 'Penalty' or 'Missed penalty'. 

When a substitution event takes place, Player 2 is the player being replaced. 

In the event of a goal, Player 2 can be either the assisting player, or 'Goal', or 'Disallowed goal' if the goal is disallowed.

{% enddocs %}


{% docs events_data_cleaned_description %}

This model serves the purpose of cleaning events data, prompted by the observation that:

1- Each match merely mentioned one team without specifying the responsible team for the event.

2- In instances where the event was categorized as a 'penalty', the player 2 field was either 'Penalty' or 'Missed penalty'. 
   Thus, in these instances, the field for player 2 was nullified. Moreover, a supplementary column was introduced specifically for 'penalty' events.
   This additional column remains null for non-penalty events, and it denotes either a 'Penalty' or a 'Missed penalty' when the event type is classified as a 'penalty'.

3- It was also noted that if the event was classified as a 'goal', the player 2 field was either the assisting player, 'Goal' or 'Disallowed goal' or 'Own goal', 
   Thus, in instances where the player 2 field was either 'Goal' or 'Disallowed goal' or 'Own goal', the player 2 field was nullified.
   Moreover, a supplementary column was introduced specifically for 'goal' events. This additional column remains null for non-goal events, 
   and it denotes either a 'Goal' or a 'Disallowed goal' or an 'Own goal' when the event type is classified as a 'goal'.
  
{% enddocs %}

{% docs cleaned_event_data_action_player_2_description %}

If a yellow card or red card or penalty event occurs, the Action Player 2 field is always null.

When a substitution event takes place, Player 2 is the player being replaced. 

In the event of a goal, Player 2 may represent either the assisting player or remain null if non-existent.

{% enddocs %}