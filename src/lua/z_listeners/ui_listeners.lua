--========================
-- UI Listeners start HERE
--========================

core:add_listener(
  "SRW_BuildingTooltip",
  "ComponentMouseOn",
  function(context)
    return cm.campaign_ui_manager:is_panel_open("settlement_panel") and (enable_supply_balance == true) and uiFactionChecker(true)
  end,
  function(context)
    local component = UIComponent(context.component)
    set_building_tooltip(component)
  end,
  true
)

core:add_listener(
  "SRW_TreasuryTooltip",
  "ComponentMouseOn",
  function(context)
    return (UIComponent(context.component):Id() == "button_finance" and not _G.jgcaps_free_units)
  end,
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    set_tooltip_text_treasury(faction, "button_finance")
  end,
  true
)

core:add_listener(
  "SRW_TreasuryCompTooltip",
  "ComponentMouseOn",
  function(context)
    return (UIComponent(context.component):Id() == "resources_bar" and _G.jgcaps_free_units)
  end,
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    set_tooltip_text_treasury(faction, "resources_bar")
  end,
  true
)

core:add_listener(
  "SRW_new_lord_tooltip",
  "ComponentMouseOn",
  function(context)
    local component = UIComponent(context.component):Id()
    --this is raise new lord button, not undead button
    return component == "button_raise" and player_supply_custom_mult ~=0 and uiFactionChecker()
  end,
  function(context)
    local component = UIComponent(context.component)
    SRWLOGDEBUG("Component created");
    set_new_lord_tooltip(component)
    
  end,
  true
)

core:add_listener(
  "SRW_UnitTooltip",
  "ComponentMouseOn",
  function(context)
    local component = UIComponent(context.component):Id()
    return cm.campaign_ui_manager:is_panel_open("units_panel") and player_supply_custom_mult ~=0 and uiFactionChecker()
  end,
  function(context)
    local component = UIComponent(context.component)
    local component_id = component:Id()
    if string.find(component_id, "QueuedLandUnit") then return end;

    if string.find(component_id, "LandUnit") then
      set_unit_in_army_tooltip(component)
    elseif string.find(component_id, "_recruitable") then
      set_unit_tooltip(component, "_recruitable")
    elseif string.find(component_id, "_mercenary") then
      set_unit_tooltip(component, "_mercenary")
    end;
  end,
  true
)


--USED IN UNIT HINT
core:add_listener(
  "SRW_Character_Selected",
  "CharacterSelected",
  function(context)
    return context:character():has_military_force()
  end,
  function(context)
    SRW_selected_character = context:character();

  end,
  true
)

-- core:add_listener(
--   "SRW_UnitTooltip_lord_upkeep",
--   "ComponentMouseOn",
--   function(context)
--     local component = UIComponent(context.component):Id()
--     return component == "dy_upkeep" and player_supply_custom_mult ~=0 and uiFactionChecker()
--   end,
--   function(context)
--     local component = UIComponent(context.component)

--     set_army_supply_tooltip(component)
    
--   end,
--   true
-- )

