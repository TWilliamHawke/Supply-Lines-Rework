local function init_mcm(context)
  local mct = context:mct()
  local supply_lines_rw = mct:get_mod_by_key("supply_lines_rw")

  local c_bret_enable = supply_lines_rw:get_option_by_key("c_bret_enable")
  bretonnia_supply =  c_bret_enable:get_finalized_setting()
  SRWLOG("Bretonnia supply is "..tostring(bretonnia_supply));
  
  local a_player_enable = supply_lines_rw:get_option_by_key("a_player_enable")
  local is_player_enable =  a_player_enable:get_finalized_setting()
  
  local b_player_effect = supply_lines_rw:get_option_by_key("b_player_effect")
  player_supply_custom_mult =  b_player_effect:get_finalized_setting()
  b_player_effect:set_uic_visibility(is_player_enable)

  if not is_player_enable then
    player_supply_custom_mult = 0
  end;

  local d_ai_enable = supply_lines_rw:get_option_by_key("d_ai_enable")
  local is_ai_enable = d_ai_enable:get_finalized_setting()
  
  local e_ai_effect = supply_lines_rw:get_option_by_key("e_ai_effect")
  ai_supply_mult = e_ai_effect:get_finalized_setting()
  e_ai_effect:set_uic_visibility(is_ai_enable)

  local f_enable_logging = supply_lines_rw:get_option_by_key("f_enable_logging")
  enable_logging = f_enable_logging:get_finalized_setting()

  local g_enable_logging = supply_lines_rw:get_option_by_key("g_enable_logging")
  enable_logging_ai = g_enable_logging:get_finalized_setting()

  local h_enable_logging_debug = supply_lines_rw:get_option_by_key("h_enable_logging_debug")
  enable_logging_debug = h_enable_logging_debug:get_finalized_setting()

  local c_c_unit_supply = supply_lines_rw:get_option_by_key("c_c_unit_supply")
  basic_unit_supply = c_c_unit_supply:get_finalized_setting()

  local c_d_lord_supply = supply_lines_rw:get_option_by_key("c_d_lord_supply")
  basic_lord_supply = c_d_lord_supply:get_finalized_setting()

  local enable_supply_balance_cfg = supply_lines_rw:get_option_by_key("balance_enable")
  enable_supply_balance = enable_supply_balance_cfg:get_finalized_setting()

  local max_balance_per_building_cfg = supply_lines_rw:get_option_by_key("balance_per_building")
  max_balance_per_buildings = max_balance_per_building_cfg:get_finalized_setting()
  max_balance_per_building_cfg:set_uic_visibility(enable_supply_balance)

  local max_balance_per_army_cfg = supply_lines_rw:get_option_by_key("balance_per_army")
  max_balance_per_army = tonumber(max_balance_per_army_cfg:get_finalized_setting())
  max_balance_per_army_cfg:set_uic_visibility(enable_supply_balance)

  local big_empire_penalty_cfg = supply_lines_rw:get_option_by_key("big_empire_penalty")
  big_empire_penalty_start = tonumber(big_empire_penalty_cfg:get_finalized_setting())
  big_empire_penalty_cfg:set_uic_visibility(enable_supply_balance)

  if enable_logging_debug then
    enable_logging = true
    enable_logging_ai = true
    SRWLOGDEBUG("Debug mode is enable");
  end;

  if not is_ai_enable then
    ai_supply_mult = 0
  end;
  SRWLOGDEBUG("Ai supply now is "..tostring(ai_supply_mult));

  local faction = cm:model():world():whose_turn_is_it()
  if not factionChecker(faction) then
    player_supply_custom_mult = 0
  else
    srw_apply_upkeep_penalty(faction);
  end
  
  SRWLOGDEBUG("Player supply now is "..tostring(player_supply_custom_mult));

end;

