local prefix = "conf_conf_"

local conf_conf = mct:register_mod("conf_conf")
conf_conf:set_title("Configurable Confederations")
conf_conf:set_author("TWilliam")
conf_conf:set_description("Configurable Confederations")


local culture_list = {
  ["wh_main_sc_emp_empire"] = "Empire",
  ["wh_main_sc_brt_bretonnia"] = "Bretonnia",
  ["wh2_main_sc_def_dark_elves"] = "Dark Elves",
  ["wh2_main_sc_hef_high_elves"] = "Hight Elves",
  ["wh2_main_sc_lzd_lizardmen"] = "Lizardmen",
  ["wh2_main_sc_skv_skaven"] = "Skaven",
  ["wh_main_sc_dwf_dwarfs"] = "Dwarfs",
  ["wh_dlc05_sc_wef_wood_elves"] = "Wood Elves",
  ["wh_main_sc_grn_greenskins"] = "Greenskins",
  ["wh_main_sc_nor_norsca"] = "Norsca",
  ["wh_main_sc_vmp_vampire_counts"] = "Vampire Counts",
};

local function global_culture_callback(option)
  local val = option:get_selected_setting()
  local conf_conf_mod = option:get_mod()
  mct:log(val)
  for key, _ in pairs(culture_list) do
    local culture_conf = option:get_mod():get_option_by_key(prefix..key)
    if culture_conf:check_validity(val) then
      culture_conf:set_selected_setting(val)
    end;
  end;
  
end;

local global_conf = conf_conf:add_new_option(prefix.."global", "dropdown")
global_conf:set_text("Global Settings")
global_conf:set_tooltip_text("Select confederation for all cultures")
global_conf:add_dropdown_values({
  {key = "all", text = "Enable", tt = "Confederation rule will be unchanged", is_default = true},
  {key = "minor", text = "Minor only", tt = "AI can confederate only minor factions", is_default = false},
  {key = "none", text = "Disable", tt = "AI factions cannot form confederation with each other", is_default = false},
})
global_conf:add_option_set_callback(global_culture_callback)


local cultural_section = conf_conf:add_new_section("o_cultural_section")
cultural_section:set_localised_text("Cultural Settings")


for key, value in pairs(culture_list) do
  local culture_conf = conf_conf:add_new_option(prefix..key, "dropdown")
  culture_conf:set_text(value)
  culture_conf:set_tooltip_text("mct_conf_conf_max_agents_count_tt", true)
  culture_conf:add_dropdown_values({
    {key = "all", text = "Enable", tt = "Confederation rule will be unchanged", is_default = true},
    {key = "minor", text = "Minor only", tt = "AI can confederate only minor factions", is_default = false},
    {key = "none", text = "Disable", tt = "AI factions cannot form confederation with each other", is_default = false},
  })
end;


