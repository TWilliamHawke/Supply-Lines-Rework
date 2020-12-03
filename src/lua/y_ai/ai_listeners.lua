core:add_listener(
  "SRW_FactionTurnStart_ai",
  "FactionTurnStart",
  function(context)
    local faction = context:faction()
    return (not faction:is_human() and not helpers.srw_faction_is_horde(faction) and not (faction:culture() == "wh2_dlc09_tmb_tomb_kings"))
  end,  
  -- true,
  function(context) 
    local faction = context:faction();
    SRWLOGAI("--------");
    SRWLOGAI("CURRENT FACTION IS "..tostring(faction:name()));
    srw_apply_upkeep_penalty_AI(faction);
    SRWLOGDEBUG("[]CALCULATION SUPPLY FOR THIS fACTION IS FINISHED");

  end,
  true
);

