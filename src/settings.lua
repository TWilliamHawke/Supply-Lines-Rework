local loc_prefix = "mct_supply_lines_rw_"

function player_callback(option)
  local val = option:get_selected_setting()

  local player_effect = option:get_mod():get_option_by_key("b_player_effect")
  if val then
    player_effect:set_uic_visibility(true)
  else
    player_effect:set_uic_visibility(false)
  end;
end;

function ai_callback(option)
  local val = option:get_selected_setting()

  local ai_effect = option:get_mod():get_option_by_key("e_ai_effect")
  if val then
    ai_effect:set_uic_visibility(true)
  else
    ai_effect:set_uic_visibility(false)
  end;
end;

-- function effectCallback(option)
--   return function(option)

--   end
-- end

local supply_lines_rw = mct:register_mod("supply_lines_rw")
supply_lines_rw:set_title(loc_prefix.."mod_title", true)
supply_lines_rw:set_author("TWilliam")
supply_lines_rw:set_description(loc_prefix.."mod_desc", true)
supply_lines_rw:set_log_file_path("supply_rework_log.txt")



local enable_player = supply_lines_rw:add_new_option("a_player_enable", "checkbox")
enable_player:set_default_value(true)
enable_player:set_text("mct_supply_lines_rw_a_player_enable_text", true)
enable_player:set_tooltip_text("mct_supply_lines_rw_a_player_enable_tt", true)
enable_player:add_option_set_callback(player_callback)

local player_effect = supply_lines_rw:add_new_option("b_player_effect", "slider")
player_effect:set_text("mct_supply_lines_rw_b_player_effect_text", true)
player_effect:set_tooltip_text("mct_supply_lines_rw_b_player_effect_tt", true)
player_effect:slider_set_min_max(0, 15)
player_effect:set_default_value(5)
player_effect:slider_set_step_size(1)

local enable_bret= supply_lines_rw:add_new_option("c_bret_enable", "checkbox")
enable_bret:set_default_value(false)
enable_bret:set_text("mct_supply_lines_rw_c_bret_enable_text", true)
enable_bret:set_tooltip_text("mct_supply_lines_rw_c_bret_enable_tt", true)
enable_bret:set_uic_visibility(false)

local enable_ai = supply_lines_rw:add_new_option("d_ai_enable", "checkbox")
enable_ai:set_default_value(false)
enable_ai:set_text("mct_supply_lines_rw_d_ai_enable_text", true)
enable_ai:set_tooltip_text("mct_supply_lines_rw_d_ai_enable_tt", true)
enable_ai:add_option_set_callback(ai_callback)

local ai_effect = supply_lines_rw:add_new_option("e_ai_effect", "slider")
ai_effect:set_text("mct_supply_lines_rw_e_ai_effect_text", true)
ai_effect:set_tooltip_text("mct_supply_lines_rw_e_ai_effect_tt", true)
ai_effect:slider_set_min_max(0, 15)
ai_effect:set_default_value(0)
ai_effect:slider_set_step_size(1)

local supply_balance_section = supply_lines_rw:add_new_section("balance_section")
supply_balance_section:set_localised_text("Supply Balance")

local enable_balance = supply_lines_rw:add_new_option("balance_enable", "checkbox")
enable_balance:set_default_value(true)
enable_balance:set_text("mct_supply_lines_rw_a_player_enable_text", true)
enable_balance:set_tooltip_text("mct_supply_lines_rw_a_player_enable_tt", true)
enable_balance:add_option_set_callback(player_callback)


local settings_section = supply_lines_rw:add_new_section("settings_sectiom")
settings_section:set_localised_text("Advanced settings")

local unit_base_supply = supply_lines_rw:add_new_option("c_c_unit_supply", "slider")
unit_base_supply:set_text("mct_supply_lines_rw_c_c_unit_supply_text", true)
unit_base_supply:set_tooltip_text("mct_supply_lines_rw_c_c_unit_supply_tt", true)
unit_base_supply:slider_set_min_max(-3, 3)
unit_base_supply:set_default_value(0)
unit_base_supply:slider_set_step_size(1)

local lord_base_supply = supply_lines_rw:add_new_option("c_d_lord_supply", "slider")
lord_base_supply:set_text("mct_supply_lines_rw_c_d_lord_supply_text", true)
lord_base_supply:set_tooltip_text("mct_supply_lines_rw_c_d_lord_supply_tt", true)
lord_base_supply:slider_set_min_max(0, 30)
lord_base_supply:set_default_value(0)
lord_base_supply:slider_set_step_size(1)

local technical = supply_lines_rw:add_new_section("technical_section")
technical:set_localised_text("Debug section")

local enable_logging = supply_lines_rw:add_new_option("f_enable_logging", "checkbox")
enable_logging:set_default_value(false)
enable_logging:set_text("mct_supply_lines_rw_f_enable_logging_text", true)
enable_logging:set_tooltip_text("mct_supply_lines_rw_f_enable_logging_tt", true)

local enable_logging_ai = supply_lines_rw:add_new_option("g_enable_logging", "checkbox")
enable_logging_ai:set_default_value(false)
enable_logging_ai:set_text("mct_supply_lines_rw_g_enable_logging_text", true)
enable_logging_ai:set_tooltip_text("mct_supply_lines_rw_g_enable_logging_tt", true)

local enable_logging_debug = supply_lines_rw:add_new_option("h_enable_logging_debug", "checkbox")
enable_logging_debug:set_default_value(false)
enable_logging_debug:set_text("mct_supply_lines_rw_h_enable_logging_debug_text", true)
enable_logging_debug:set_tooltip_text("mct_supply_lines_rw_h_enable_debug_logging_tt", true)


