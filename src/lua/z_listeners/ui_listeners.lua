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
  "SRW_UnitTooltip_merc",
  "ComponentMouseOn",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    local component = UIComponent(context.component):Id()
    return cm.campaign_ui_manager:is_panel_open("units_panel") and player_supply_custom_mult ~=0 and string.find(component, "_mercenary") and factionChecker(faction)
  end,
  function(context)
    local component = UIComponent(context.component)
    set_unit_tooltip(component, "_mercenary")
  end,
  true
)


core:add_listener(
  "SRW_UnitTooltip_rec",
  "ComponentMouseOn",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    local component = UIComponent(context.component):Id()
    return cm.campaign_ui_manager:is_panel_open("units_panel") and player_supply_custom_mult ~=0 and string.find(component, "_recruitable") and factionChecker(faction)
  end,
  function(context)
    local component = UIComponent(context.component)
    set_unit_tooltip(component, "_recruitable")
  end,
  true
)

core:add_listener(
  "SRW_UnitTooltip_new_lord",
  "ComponentMouseOn",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    local component = UIComponent(context.component):Id()
    return component == "button_raise" and player_supply_custom_mult ~=0 and factionChecker(faction)
  end,
  function(context)
    local component = UIComponent(context.component)
    local faction = cm:model():world():whose_turn_is_it()

    set_new_lord_tooltip(component, faction)
    
  end,
  true
)

--USED IN UNIT HINT
core:add_listener(
  "SRW_Character_Selected",
  "CharacterSelected",
  function(context)
    return context:character():faction():is_human() and context:character():has_military_force()
  end,
  function(context)
    SRW_selected_character = context:character();

  end,
  true
)

