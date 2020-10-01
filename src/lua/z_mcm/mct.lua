if not not mcm and not core:get_static_object("mod_configuration_tool") then
  local srw_mcm = mcm:register_mod("supply_lines_rework", "Supply Lines Rework", "Custom supply lines multipliers")
  srw_mcm:add_variable("player_mult", 0, 15, 5, 1, "Player Supply Influence. 2 equals easy, 8 - very hard/legendary", "Select how much unit quality will affect player extra upkeep"):add_callback(function(context)
    player_supply_custom_mult = context:get_mod("supply_lines_rework"):get_variable_with_key("player_mult"):current_value()
     
    SRWLOG("MCM set player_mult to "..player_supply_custom_mult)
  end)
  srw_mcm:add_variable("ai_mult", 0, 15, 0, 1, "AI Supply Influence. High value means fewer AI troops in late game", "Select how much unit quality will affect AI extra upkeep.\n0 means disabling this feature.\nIf you want to activate it I  recomend a value between 5 and 8"):add_callback(function(context)
    ai_supply_mult = context:get_mod("supply_lines_rework"):get_variable_with_key("ai_mult"):current_value()
     
    SRWLOG("MCM set ai_supply_mult to "..ai_supply_mult)
  end)
end