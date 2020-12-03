core:add_listener(
  "SRW_FactionTurnStart",
  "FactionTurnStart",
  function(context)
    local faction = context:faction()
    return factionChecker(faction)
  end,  
  -- true,
  function(context) 
    local faction = context:faction();
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (TURN START)");
      srw_apply_upkeep_penalty(faction);
      SRWLOG("FACTION NAME IS "..tostring(faction:name()));
      SRWLOG("FACTION CULTURE IS "..tostring(faction:subculture()));
      calculate_supply_balance(faction);
  end,
  true
);

core:add_listener(
  "SRW_FactionTurnEnd",
  "FactionTurnEnd",
  function(context)
    local faction = context:faction()
    return factionChecker(faction)
  end,  
  -- true,
  function(context) 
    local faction = context:faction();
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (TURN END)");
      srw_apply_upkeep_penalty(faction);
  end,
  true
);

core:add_listener(
  "SRW_RaiseDead",
  "ComponentLClickUp",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    return (UIComponent(context.component):Id() == "button_raise_dead" and factionChecker(faction))
  end,  
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (RAISE DEAD)");
      srw_apply_upkeep_penalty(faction) 
    end, 0.1);
  end,
  true
);

core:add_listener(
  "SRW_Hire_Blessed",
  "ComponentLClickUp",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    return (UIComponent(context.component):Id() == "button_hire_blessed" and factionChecker(faction))
  end,  
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (HIRE BLESSED)");
      srw_apply_upkeep_penalty(faction) 
    end, 0.1);
  end,
  true
);

core:add_listener(
  "SRW_Hire_Imperial",
  "ComponentLClickUp",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    return (UIComponent(context.component):Id() == "button_hire_imperial" and factionChecker(faction))
  end,
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (HIRE IMPERIAL)");
      srw_apply_upkeep_penalty(faction) 
    end, 0.1);
  end,
  true
);

core:add_listener(
  "SRW_Hire_Renown",
  "ComponentLClickUp",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    return (UIComponent(context.component):Id() == "button_hire_renown" and factionChecker(faction))
  end,
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (HIRE ROR)");
      srw_apply_upkeep_penalty(faction) 
    end, 0.1);
  end,
  true
);
-- core:add_listener(
--   "SRW_UI",
--   "ComponentLClickUp",
--   true, 
--   function(context)
--     local faction = cm:model():world():whose_turn_is_it()
--     local button = UIComponent(context.component):Id()
--     SRWLOG(tostring(button));
--   end,
--   true
-- );

core:add_listener(
  "SRW_FactionJoinsConfederation",
  "FactionJoinsConfederation",
  function(context)
    local faction = context:confederation();
    return factionChecker(faction)
  end,  
  function(context)
    local faction = context:confederation();
    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (CONFEDERATION)");
      srw_apply_upkeep_penalty(faction);
      calculate_supply_balance(faction)
    end, 0.1);
  end,
  true
);

core:add_listener(
  "SRW_player_army_created_listener",
  "MilitaryForceCreated",
  function(context)
    local faction = context:military_force_created():faction();
    return factionChecker(faction)
  end,
  function(context)
    local faction = context:military_force_created():faction();
    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (NEW FORCE)");
      srw_apply_upkeep_penalty(faction);
      calculate_supply_balance(faction);
    end, 0.1);
  end,
  true
);


core:add_listener(
  "SRW_Confederation_Bretonnia",
  "FactionJoinsConfederation",
  function(context)
    local faction = context:confederation();
    return (factionChecker(faction))
  end,  
  function(context)
    local faction = context:confederation();
    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("REMOVE UPKEEP FOR BERTONNIA");
      srw_remove_upkeep_penalty(faction);
    end, 0.1);
  end,
  true
);

core:add_listener(
  "SRW_SETTLEMENT_CAPTURED",
  "RegionFactionChangeEvent",
  function(context)
    local faction = context:region():owning_faction();
    return (factionChecker(faction))
  end,
  function(context)
    SRWLOG("======================");
    SRWLOG("SETTLEMENT CAPTURED")
    local faction = context:region():owning_faction();
    calculate_supply_balance(faction)
  end,
  true
);
