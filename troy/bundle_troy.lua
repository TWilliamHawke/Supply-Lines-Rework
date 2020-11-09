local enable_logging = true
local enable_logging_ai = false
local enable_logging_debug = false

local function SRWLOGCORE(text)
  local logText = tostring(text)
  local popLog = io.open("supply_rework_log.txt","a")
  popLog :write("SRW: "..logText .. "  \n")
  popLog :flush()
  popLog :close()
end

local function SRWLOG(text)
  if not enable_logging then
    return;
  end
  SRWLOGCORE(text)
end

local function SRWLOGAI(text)
  if not enable_logging_ai then
    return;
  end
  SRWLOGCORE(text)
end

local function SRWLOGDEBUG(text)
  if not enable_logging_debug then
    return;
  end
  SRWLOGCORE(text)
end

local function SRWNEWLOG()
  local logTimeStamp = os.date("%d, %m %Y %X")

  local popLog = io.open("supply_rework_log.txt","w+")
  popLog :write("NEW LOG ["..logTimeStamp.."] \n")
  popLog :flush()
  popLog :close() 
end
SRWNEWLOG()

--logging function.
local SRW_selected_character = "";
local max_supply_per_army = 38;  -- max effect number in effect_bundles_tables
local ai_supply_enabled = false;
local ai_supply_mult = 0
local player_supply_custom_mult = "disabled"
local bretonnia_supply = false
local basic_unit_supply = 0
local basic_lord_supply = 0
local enable_supply_balance = false
local max_balance_per_buildings = 3
local max_balance_per_army = 30
local game_lang = false

local SRW_Supply_Cost = {
--Achean
  --core
  ["troy_achaean_stoneslingers"] = 0,
  ["troy_greek_militia"] = 0,
  ["troy_greek_militia_alt"] = 0,
  ["troy_spearmen"] = 0,
  ["troy_achaean_skirmishers"] = 0,
  ["troy_laconian_militia"] = 0,
  ["troy_light_bowmen"] = 0,
  ["troy_thessaly_javelinmen"] = 0,
  ["troy_islander_skirmishers"] = 0,
  ["troy_islanders"] = 0,

  --special
  ["troy_achaean_spearmen"] = 1,
  ["troy_light_swordsmen"] = 1,
  ["troy_myc_light_javelin_throwers"] = 1,
  ["troy_laconian_axemen"] = 1,
  ["troy_laconian_hillmen"] = 1,
  ["troy_veteran_slingers"] = 1,
  ["troy_pht_aeginian_javelinmen"] = 1,
  ["troy_heavy_thessaly_javelinmen"] = 1,
  ["troy_pht_aeginian_runners"] = 1,
  ["troy_ith_ambushers"] = 1,
  ["troy_ith_elite_ambushers"] = 1, -- 2?
  ["troy_light_spearmen"] = 1,
  ["troy_achaean_bowmen"] = 1,
  ["troy_veteran_islander_skirmishers"] = 1,
  ["troy_veteran_bowmen"] = 1,
  ["troy_swordsmen_skirmishers"] = 1,

  --rare
  ["troy_ach_chariots"] = 2,
  ["troy_ach_skirmish_chariots"] = 2,
  ["troy_heavy_mycenaen_bowmen"] = 2,
  ["troy_heavy_mycenaen_bowmen_tutorial"] = 2,
  ["troy_armoured_axemen"] = 2,
  ["troy_armoured_veteran_slingers"] = 2,
  ["troy_spa_light_spear_runners"] = 2, -- 1?
  ["troy_veteran_laconian_axemen"] = 2,
  ["troy_shielded_spearmen"] = 2,
  ["troy_laconian_swordsmen"] = 2,
  ["troy_veteran_club_warriors"] = 2,
  ["troy_phthian_spears"] = 2,
  ["troy_heavy_achaean_bowmen"] = 2,
  ["troy_pht_thessaly_marines"] = 2,
  ["troy_pht_champions_of_phthia"] = 2,
  ["troy_ith_stalker_skirmishers"] = 2, --3?
  ["troy_heavy_swordsmen_skirmishers"] = 2,
  ["troy_spear_runners"] = 2,
  ["troy_achaean_islanders"] = 2, --1?
  ["troy_dendra_swordsmen"] = 3,
  ["troy_club_warriors_large_shields"] = 2,
  ["troy_club_warriors"] = 2,
  ["troy_heavy_islander_skirmishers"] = 2,

  --elite
  ["troy_myc_mycenaen_temple_guards"] = 3,  --aga
  ["troy_myc_mycenaen_temple_warriors"] = 3, --aga
  ["troy_ach_heavy_reinforced_chariots"] = 3,
  ["troy_ach_heavy_skirmish_chariots"] = 3,
  ["troy_dendra_chargers"] = 3,
  ["troy_dendra_spearmen"] = 3,
  ["troy_spa_champion_axe_warriors"] = 3, --men
  ["troy_spa_heroic_axe_warriors"] = 3, --men
  ["troy_veteran_phthian_spears"] = 3,
  ["troy_heavy_swordsmen"] = 3,
  ["troy_pht_veteran_thessaly_marines"] = 3,
  ["troy_pht_myrmidon_spearmen"] = 3, --ach
  ["troy_pht_myrmidon_swordsmen"] = 3, --ach
  ["troy_ith_odysseus_night_runners"] = 3,
  ["troy_warriors_of_ithaca"] = 3,
  ["troy_heavy_shielded_spearmen"] = 3, --2?

  --

--other

-- Amazon
  --core
  ["troy_dlc1_ama_hip_amazon_archers"] = 0,
  ["troy_dlc1_ama_gen_stoneslingers"] = 0,
  ["troy_dlc1_ama_gen_amazon_chargers"] = 0,
  ["troy_dlc1_ama_gen_initiates"] = 0,
  ["troy_dlc1_ama_pen_warband"] = 0,
  ["troy_dlc1_ama_pen_skirmishers"] = 0,
  --spec
  ["troy_dlc1_ama_hip_hippolytas_chosen"] = 1,
  ["troy_dlc1_ama_hip_war_riders"] = 1,
  ["troy_dlc1_ama_gen_huntress"] = 1,
  ["troy_dlc1_ama_gen_shielded_stoneslingers"] = 1,
  ["troy_dlc1_ama_hip_amazon_swordswomen"] = 1,
  ["troy_dlc1_ama_hip_black_spears"] = 1,
  ["troy_dlc1_ama_gen_horsewomen"] = 1,
  ["troy_dlc1_ama_gen_oathsworn"] = 1,
  ["troy_dlc1_ama_pen_toxares"] = 1,
  ["troy_dlc1_ama_pen_mounted_skirmishers"] = 1,
  ["troy_dlc1_ama_pen_labrys_wielders"] = 1,
  ["troy_dlc1_ama_pen_styganores"] = 1,
  --rare
  ["troy_dlc1_ama_hip_toxoannases"] = 2,
  ["troy_dlc1_ama_hip_followers_of_artemis"] = 2,
  ["troy_dlc1_ama_pen_korynites"] = 2,
  ["troy_dlc1_ama_hip_andromachoi"] = 2,
  ["troy_dlc1_ama_hip_amazon_champions"] = 2,
  ["troy_dlc1_ama_hip_warmaidens"] = 2,
  ["troy_dlc1_ama_hip_chariot_archers"] = 2,
  ["troy_dlc1_ama_pen_chariot_javelins"] = 2,
  ["troy_dlc1_ama_pen_furies"] = 2,
  ["troy_dlc1_ama_pen_daughters_of_ares"] = 2,
  ["troy_dlc1_ama_gen_mounted_huntress"] = 2,
  ["troy_dlc1_ama_pen_themysciras_chosen"] = 2,
  --elite
  ["troy_dlc1_ama_pen_anairetes"] = 3,
  ["troy_dlc1_ama_hip_hippotoxotai"] = 3,
  ["troy_dlc1_ama_hip_aristomachoi"] = 3,
  ["troy_dlc1_ama_hip_antianeirai"] = 3,
  ["troy_dlc1_ama_pen_hippomachoi"] = 3,
  --
  ["troy_dlc1_ama_pen_daughters_of_ares_bloodsworn"] = 3,
  ["troy_dlc1_ama_pen_labrys_wielders_bloodsworn"] = 2,
  ["troy_dlc1_ama_pen_warband_bloodsworn"] = 1,
  --mythic
  ["troy_dlc1_myth_special_armoured_centaur_skirmishers"] = 4,
  ["troy_dlc1_myth_special_armoured_centaur_warriors"] = 4,
  ["troy_dlc1_myth_special_armoured_giant_bowmen"] = 4,
  ["troy_dlc1_myth_special_armoured_giant_spearmen"] = 4,
  ["troy_dlc1_myth_special_armoured_giant_vanguard"] = 4,
  ["troy_dlc1_myth_special_centaur_archers"] = 4,
  ["troy_dlc1_myth_special_centaur_champions"] = 4,
  ["troy_dlc1_myth_special_centaur_elders"] = 4,
  ["troy_dlc1_myth_special_centaur_outriders"] = 4,
  ["troy_dlc1_myth_special_centaur_scouts"] = 4,
  ["troy_dlc1_myth_special_centaur_warriors"] = 4,
  ["troy_dlc1_myth_special_corybantes"] = 4,
  ["troy_dlc1_myth_special_giant_bowmen"] = 4,
  ["troy_dlc1_myth_special_giant_champions"] = 4,
  ["troy_dlc1_myth_special_giant_skirmishers"] = 4,
  ["troy_dlc1_myth_special_giant_spearmen"] = 4,
  ["troy_dlc1_myth_special_giant_vanguard"] = 4,
  ["troy_dlc1_myth_special_giant_warriors"] = 4,
  ["troy_dlc1_myth_special_harpies"] = 4,
  ["troy_dlc1_myth_special_harpies_daimones"] = 4,
  ["troy_dlc1_myth_special_heavy_spartoi"] = 4,
  ["troy_dlc1_myth_special_light_spartoi"] = 4,
  ["troy_dlc1_myth_special_sirens"] = 4,
  ["troy_dlc1_myth_special_spartoi"] = 4,
  ["troy_dlc2_warriors_of_artemis"] = 4,
-- Troyan
  --core
  ["troy_aen_dardanian_gang"] = 0,
  ["troy_aen_dardanian_mob"] = 0,
  ["troy_light_skirmishers"] = 0,
  ["troy_trojan_warriors"] = 0,
  ["troy_trojan_militia"] = 0,
  ["troy_trojan_archers"] = 0,
  ["troy_trojan_stoneslingers"] = 0,
  ["troy_trojan_slingers"] = 0,
  ["troy_lycians"] = 0,
  ["troy_lycian_slingers"] = 0,
  --spec
  ["troy_large_axemen"] = 1,
  ["troy_trojan_swordsmen"] = 1,
  ["troy_veteran_trojan_slingers"] = 1,
  ["troy_veteran_trojan_archers"] = 1, -- 2?
  ["troy_phrygian_axemen"] = 1,
  ["troy_coastal_axe_fighters"] = 1,
  ["troy_coastal_club_fighters"] = 1,
  ["troy_coastal_club_warriors"] = 1,
  ["troy_heavy_anatolian_skirmishers"] = 1, --?
  ["troy_dardanian_stoneslingers"] = 1,
  ["troy_dardanian_zealots"] = 1,
  ["troy_lycian_axe_warriors"] = 1,
  ["troy_lycian_axemen"] = 1,
  ["troy_lycian_archers"] = 1,
  ["troy_eastern_spearmen"] = 1,
  ["troy_myc_light_javelin_throwers"] = 1,
  --rare
  ["troy_trojan_spears"] = 2,
  ["troy_veteran_trojan_swordsmen"] = 2,
  ["troy_hec_guards_of_troy"] = 2,
  ["troy_tro_archer_chariots"] = 2,
  ["troy_tro_trojan_chariots"] = 2,
  ["troy_elite_trojan_slingers"] = 2,
  ["troy_par_trojan_nobles"] = 2,
  ["troy_dardanian_spearmen"] = 2,
  ["troy_anatolian_spears"] = 2,
  ["troy_anatolian_swords"] = 2,
  ["troy_heavy_anatolian_spearmen"] = 2,
  ["troy_heavy_anatolian_swords"] = 2,
  ["troy_heavy_dardanian_zealots"] = 2,
  ["troy_lyc_lycian_light_chariots"] = 2,
  ["troy_armoured_lycian_archers"] = 2,
  ["troy_heavy_lycian_axemen"] = 2,
  ["troy_heavy_eastern_spearmen"] = 2,
  ["troy_khopesh_fighters"] = 2, --1?
  ["troy_phrygian_warriors"] = 2,
  ["troy_trojan_spearmen"] = 2,
  --elite
  ["troy_veteran_khopesh_fighters"] = 3, --2?
  ["troy_hec_par_champions_of_troy"] = 3,
  ["troy_hec_hectors_chosen"] = 3,
  ["troy_heavy_shock_spears"] = 3,
  ["troy_tro_heavy_lycian_chariots"] = 3,
  ["troy_tro_heavy_trojan_chariots"] = 3,
  ["troy_par_elite_trojan_nobles"] = 3,
  ["troy_par_trojan_noble_chariots"] = 3,
  ["troy_aen_elite_dardanian_defenders"] = 3,
  ["troy_aen_elite_dardanian_swordsmen"] = 3,
  ["troy_aen_elite_dardanian_chargers"] = 3,
  ["troy_lycian_veterans"] = 3,
  ["troy_sar_lycian_champions"] = 3,
  ["troy_sar_sapredons_guard"] = 3,
  ["troy_heavy_trojan_spearmen"] = 3,
  ["troy_trojan_defenders"] = 3,
  ["troy_veteran_phrygian_axemen"] = 3,
--myth
  ["troy_myth_armoured_centaur_skirmishers"] = 4,
  ["troy_myth_armoured_centaur_warriors"] = 4,
  ["troy_myth_armoured_giant_bowmen"] = 4,
  ["troy_myth_armoured_giant_spearmen"] = 4,
  ["troy_myth_armoured_giant_vanguard"] = 4,
  ["troy_myth_centaur_archers"] = 4,
  ["troy_myth_centaur_champions"] = 4,
  ["troy_myth_centaur_elders"] = 4,
  ["troy_myth_centaur_outriders"] = 4,
  ["troy_myth_centaur_scouts"] = 4,
  ["troy_myth_centaur_warriors"] = 4,
  ["troy_myth_corybantes"] = 4,
  ["troy_myth_cyclops"] = 4,
  ["troy_myth_giant_bowmen"] = 4,
  ["troy_myth_giant_champions"] = 4,
  ["troy_myth_giant_skirmishers"] = 4,
  ["troy_myth_giant_spearmen"] = 4,
  ["troy_myth_giant_vanguard"] = 4,
  ["troy_myth_giant_warriors"] = 4,
  ["troy_myth_harpies"] = 4,
  ["troy_myth_harpies_daimones"] = 4,
  ["troy_myth_heavy_spartoi"] = 4,
  ["troy_myth_light_spartoi"] = 4,
  ["troy_myth_minotaur"] = 4,
  ["troy_myth_sirens"] = 4,
  ["troy_myth_spartoi"] = 4,
  ["troy_myth_special_cyclops"] = 4,
  ["troy_myth_special_minotaur"] = 4,
--Other
  ["troy_gods_spartoi_warriors"] = 3,
  ["troy_tutorial_battle_ereuthalion"] = 1,
}

local SRW_Free_Units = {

}

local function srw_get_diff_mult()
  return 2
end

-- local function get_language()
--   if game_lang then
--     return game_lang
--   end;

--   game_lang = "en"
--   local langfile, err = io.open(os.getenv("APPDATA") .. "/The Creative Assembly/Troy/scripts/preferences.script.txt", "r")

--   if langfile then
--     local config = langfile:read("*all")
--     local start_pos, endpos = config:find("language_text")
--     if endpos then
--       game_lang = config:sub(endpos + 3, endpos + 4)
--     end
--   end;
--   SRWLOG("game language is"..game_lang)
--   return game_lang
-- end;

local function localizator(string)
  local local_string = string
  -- if get_language() == "ru" then 
  --   local_string = string.."_ru"
  -- end
  return effect.get_localised_string(local_string)
end;

local function calculate_unit_supply(unit)
  local uclass = unit:unit_class();
  --local ucat = unit:unit_category();
  if uclass == "com" then
    return 0
  else
    return 2
  end;
end;  

local function calculate_army_supply(unit_list, character)
  local this_army_supply = 0;
  SRWLOG("--------");
  SRWLOG("Lord of this army is "..tostring(character));

  for j = 0, unit_list:num_items() - 1 do
    local unit = unit_list:item_at(j);
    local key = unit:unit_key();
    local val = SRW_Supply_Cost[key] or calculate_unit_supply(unit);
    this_army_supply = this_army_supply + val;
  end; --units

  return this_army_supply
end;

local function apply_effect(effect_strength, force)
  local upkeep_mod = math.min(effect_strength, max_supply_per_army);
  local effect_bundle = "srw_bundle_force_upkeep_" .. upkeep_mod;
  cm:apply_effect_bundle_to_characters_force(effect_bundle, force:general_character():cqi(), -1, true); 
  SRWLOG("APPLY EFFECT: +"..tostring(upkeep_mod).."% TO UPKEEP");
end;

local function remove_effect(force)
  for k = 1, max_supply_per_army do
    local effect = "srw_bundle_force_upkeep_" .. k
    if force:has_effect_bundle(effect) then
      SRWLOG("this army has "..tostring(effect));
      cm:remove_effect_bundle_from_characters_force(effect, force:general_character():cqi());
    end;   
  end;
end;

local function srw_calculate_upkeep(force)
  local multiplier = srw_get_diff_mult()
  local unit_list = force:unit_list();
  local character = force:general_character():character_subtype_key();

  remove_effect(force)

  local effect_strength = calculate_army_supply(unit_list, character);
  SRWLOG("THIS ARMY REQUIRED "..tostring(effect_strength).." SUPPLY POINTS");
  effect_strength = math.floor(effect_strength/multiplier);

  if effect_strength > 0 then
    apply_effect(effect_strength, force)
  end;
end;

local function srw_apply_upkeep_penalty(faction)
  if faction:is_human() then
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if not force:is_armed_citizenry() and force:has_general() then
        SRWLOG("--------");
        SRWLOG("CHECK ARMY #"..tostring(i));
        srw_calculate_upkeep(force)
      end; --of army check
    end; --of army call
  end; -- of local faction
end; -- of function


local function set_tooltip_text_treasury(faction, component_name)
  local global_supply = 0
  local upkeep_percent = -1
  local dif_mod = srw_get_diff_mult();

  local treasury_component = find_uicomponent(core:get_ui_root(), "btn_treasury")

  local force_list = faction:military_force_list();

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() then
      local unit_list = force:unit_list();
      local character = force:general_character():character_subtype_key();

      local army_supply = calculate_army_supply(unit_list, character);

      local army_upkeep_effect = math.floor(army_supply/dif_mod)
      global_supply = global_supply + army_supply
      upkeep_percent = upkeep_percent + math.min(army_upkeep_effect, max_supply_per_army) + 1
    end; --of army check
  end; --of army call

  if upkeep_percent < 0 then upkeep_percent = 0 end;

  local supply_text = localizator("SRW_treasury_tooltip_supply")
  supply_text = string.gsub(supply_text, "SRW_supply", tostring(global_supply))

  local tooltip_text = localizator("SRW_treasury_tooltip_main")..supply_text..localizator("SRW_treasury_tooltip_upkeep")..tostring(upkeep_percent).."%\n"
  treasury_component:SetTooltipText(tooltip_text, true)
end;

local function set_unit_tooltip(component, text)

  local component_name = component:Id();
  local unit_name = string.gsub(component_name, text, "")
  local old_text = component:GetTooltipText();
  local unit_cost = SRW_Supply_Cost[unit_name]
  SRWLOG("unit cost is"..unit_cost)

  --if old_text:find("col:red") then return end
  local supply_text = localizator("SRW_unit_supply_cost_unknown")

  if unit_cost == 0 then
    supply_text = localizator("SRW_unit_supply_cost_zero")
    
  elseif SRW_Free_Units[unit_name.."-"..SRW_selected_character] == 1 then
    supply_text = localizator("SRW_unit_supply_cost_lord")

  elseif unit_cost == 1 then
    supply_text = localizator("SRW_unit_supply_cost_one")

  elseif unit_cost and unit_cost > 1 then
    local imported_text = localizator("SRW_unit_supply_cost_many")

    supply_text = string.gsub(imported_text, "SRW_Cost", tostring(unit_cost))

  end;
  
  SRWLOG("supply_text is "..supply_text)

  if string.find(old_text, supply_text) then return end
  SRWLOG("before final text ")

  local final_text = string.gsub(old_text, "\n", "\n[[col:yellow]]"..supply_text.."[[/col]]\n", 1)
  SRWLOG("final_text done ")

  if is_uicomponent(component) then 
  SRWLOG("before set tooltip ")

    component:SetTooltipText(final_text, true)
    SRWLOG("after set tooltip ")

  end;
end;

core:add_listener(
  "SRW_TreasuryTooltip",
  "ComponentMouseOn",
  function(context)
    return (UIComponent(context.component):Id() == "btn_treasury")
  end,
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    set_tooltip_text_treasury(faction, "btn_treasury")
  end,
  true
)

-- core:add_listener(
--   "SRW_TreasuryTooltip_t",
--   "ComponentMouseOn",
--   function(context)
--     local component = UIComponent(context.component):Id()
--     return string.find(component, "troy_")
--   end,
--   function(context)
--     SRWLOG(UIComponent(context.component):Id())
--   end,
--   true
-- )

core:add_listener(
  "SRW_UnitTooltip_rec",
  "ComponentMouseOn",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    local component = UIComponent(context.component):Id()
    return cm.campaign_ui_manager:is_panel_open("units_panel") and string.find(component, "_recruitable")
  end,
  function(context)
    local component = UIComponent(context.component)
    set_unit_tooltip(component, "_recruitable")
  end,
  true
)
