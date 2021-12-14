--========================
-- Main Listeners start HERE
--========================

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

    if enable_logging_debug then
      SRWNEWLOG()
    end;
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

core:add_listener(
  "SRW_Agent_created",
  "CharacterCreated",
  function(context)
    local faction = context:character():faction();
    return (factionChecker(faction))
  end,
  function(context)
    local character = context:character();
    if not cm:char_is_agent(character) then return end;

    SRWLOG("======================");
    SRWLOG("AGENT Recruted")
    local faction = context:character():faction();
    Supply_lines_rework.calculate_agents_supply(faction)
  end,
  true
);

core:add_listener(
  "SRW_UNIT_DISBANDED",
  "UnitDisbanded",
  function(context)
    local faction = context:unit():faction()
    return (factionChecker(faction))
  end,
  function(context)
    if block_scripts then return end;
    local faction_name = context:unit():faction():name();
    block_scripts = faction_name;

    cm:callback(function()
      if not block_scripts then return end;
      local faction = cm:get_faction(block_scripts);

      if faction then

        SRWLOG("======================");
        SRWLOG("UNIT DISBANDED");
        srw_apply_upkeep_penalty(faction);
        calculate_supply_balance(faction);
        block_scripts = false;
      end;
    end, 0.2);

  end,
  true
);


