
local enable_logging = false
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
local SRW_selected_character = nil;
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


local building_unit_bonus = {
--wef
  ["wh_dlc05_wef_spellsingers_1"] = 2,
  ["wh_dlc05_wef_spellsingers_2"] = 3,
  ["wh_dlc05_wef_spellsingers_3"] = 4,
  ["wh_dlc05_wef_cavalry_1"] = 2,
  ["wh_dlc05_wef_cavalry_2"] = 3,
  ["wh_dlc05_wef_cavalry_3"] = 5,
  ["wh_dlc05_wef_dragons_1"] = 5,
  ["wh_dlc05_wef_flying_1"] = 3,
  ["wh_dlc05_wef_flying_2"] = 4,
  ["wh_dlc05_wef_melee_1"] = 1,
  ["wh_dlc05_wef_melee_2"] = 2,
  ["wh_dlc05_wef_melee_3"] = 3,
  ["wh_dlc05_wef_ranged_1"] = 1,
  ["wh_dlc05_wef_ranged_2"] = 2,
  ["wh_dlc05_wef_ranged_3"] = 4,
  ["wh_dlc05_wef_tree_spirits_1"] = 1,
  ["wh_dlc05_wef_tree_spirits_2"] = 3,
  ["wh_dlc05_wef_tree_spirits_3"] = 5,
  ["wh_dlc05_wef_outpost_replenishment_1"] = 3,
  ["wh_dlc05_wef_armoury_1"] = 2,
  ["wh_dlc05_wef_armoury_2"] = 3,
  ["wh_dlc05_wef_fletcher_1"] = 2,
  ["wh_dlc05_wef_fletcher_2"] = 3,
  ["wh_dlc05_wef_outpost_minor_dwarfhold_1"] = 1,
  ["wh_dlc05_wef_outpost_minor_dwarfhold_1_coast"] = 1,
  ["wh_dlc05_wef_outpost_major_dwarfhold_1"] = 1,
  ["wh_dlc05_wef_outpost_major_dwarfhold_1_coast"] = 1,
  ["wh_dlc05_wef_outpost_major_human_1"] = 1,
  ["wh_dlc05_wef_outpost_major_human_1_coast"] = 1,
  ["wh_dlc05_wef_outpost_major_norsca_1"] = 1,
  ["wh_dlc05_wef_outpost_major_norsca_coast_1"] = 1,
  ["wh_dlc05_wef_outpost_minor_human_1"] = 1,
  ["wh_dlc05_wef_outpost_minor_human_1_coast"] = 1,
  ["wh_dlc05_wef_outpost_minor_norsca_1"] = 1,
  ["wh_dlc05_wef_outpost_minor_norsca_coast_1"] = 1,
  ["wh_dlc05_wef_garrison_1"] = -1,
  ["wh_dlc05_wef_garrison_2"] = -1,
  ["wh_dlc05_wef_garrison_3"] = -1,
  ["wh_dlc05_wef_walls_1"] = -1,
  ["wh_dlc05_wef_walls_2"] = -1,
  ["wh_dlc05_wef_walls_3"] = -1,
--brt
  ["wh_main_brt_barracks_1"] = 1,
  ["wh_main_brt_barracks_2"] = 2,
  ["wh_main_brt_barracks_3"] = 3,
  ["wh_main_brt_barracks_4"] = 4,
  ["wh_main_brt_carpenter_1"] = 2,
  ["wh_main_brt_carpenter_2"] = 5,
  ["wh_main_brt_farm_1"] = 1,
  ["wh_main_brt_farm_2"] = 2,
  ["wh_main_brt_farm_3"] = 3,
  ["wh_main_brt_stables_1"] = 1,
  ["wh_main_brt_stables_2"] = 2,
  ["wh_main_brt_stables_3"] = 3,
  ["wh_main_brt_stables_4"] = 4,
  ["wh_main_brt_stables_5"] = 5,
  ["wh_main_brt_worship_1"] = 2,
  ["wh_main_brt_worship_2"] = 3,
  ["wh_main_brt_worship_3"] = 5,
  ["wh_main_brt_smiths_1"] = 2,
  ["wh_main_brt_smiths_2"] = 4,
  ["wh_main_brt_garrison_1"] = -1,
  ["wh_main_brt_garrison_2"] = -1,
  ["wh_main_brt_walls_1"] = -1,
  ["wh_main_brt_walls_2"] = -1,
  ["wh_main_brt_walls_3"] = -1,
  ["wh2_main_brt_defence_norsca_1"] = -1,
--dwarves
  ["wh_main_dwf_barracks_1"] = 1,
  ["wh_main_dwf_barracks_2"] = 2,
  ["wh_main_dwf_barracks_3"] = 3,
  ["wh_main_dwf_barracks_4"] = 4,
  ["wh_main_dwf_slayer_1"] = 3,
  ["wh_main_dwf_slayer_2"] = 4,
  ["wh_main_dwf_workshop_1"] = 2,
  ["wh_main_dwf_workshop_2"] = 3,
  ["wh_main_dwf_workshop_3"] = 4,
  ["wh_main_dwf_workshop_4"] = 5,
  ["wh_main_dwf_engineer_1"] = 4,
  ["wh_main_dwf_engineer_2"] = 5,
  ["wh_main_dwf_smith_1"] = 3,
  ["wh_main_dwf_smith_2"] = 4,
  ["wh_main_dwf_smith_3"] = 5,
  --["wh_main_dwf_tavern_1"] = 2,
  --["wh_main_dwf_tavern_2"] = 3,
  --["wh_main_dwf_tavern_3"] = 4,
  ["wh_dlc06_dwf_ranger_hub_1"] = 1,
  ["wh_dlc06_dwf_ranger_hub_1_all"] = 3,
  ["wh_dlc06_dwf_ranger_hub_2"] = 3,
  ["wh2_main_dwf_defence_norsca_1"] = -1,
  ["wh_main_dwf_garrison_1"] = -1,
  ["wh_main_dwf_garrison_2"] = -1,
  ["wh_main_dwf_wall_1"] = -1,
  ["wh_main_dwf_wall_2"] = -1,
  ["wh_main_dwf_wall_3"] = -1,
  ["kraka_smith_1"] = 3,
  ["kraka_smith_2"] = 4,
  ["kraka_smith_3"] = 5,
  ["kraka_refugees_1"] = 2,
  ["kraka_refugees_2"] = 3,
  ["kraka_slayer"] = 3,
  ["kraka_barracks_4"] = 4,
  
--empire
  ["wh_main_emp_barracks_1"] = 1,
  ["wh_main_emp_barracks_2"] = 2,
  ["wh_main_emp_barracks_3"] = 3,
  ["wh_main_emp_forges_1"] = 3,
  ["wh_main_emp_forges_2"] = 4,
  ["wh_main_emp_forges_3"] = 5,
  ["wh_main_emp_stables_1"] = 2,
  ["wh_main_emp_stables_2"] = 3,
  ["wh_main_emp_stables_3"] = 4,
  ["wh_main_emp_wizards_1"] = 3,
  ["wh_main_emp_wizards_2"] = 5,
  ["wh_main_emp_worship_1"] = 3,
  ["wh_main_emp_worship_2"] = 4,
  ["wh_main_emp_worship_3"] = 5,
  ["wh_main_emp_smiths_1"] = 2,
  ["wh_main_emp_smiths_2"] = 3,
  ["wh2_main_emp_academy_1"] = 5,
  ["wh_main_special_reiksfort"] = 3,
  ["wh_main_emp_garrison_1"] = -1,
  ["wh_main_emp_garrison_2"] = -1,
  ["wh_main_emp_walls_1"] = -1,
  ["wh_main_emp_walls_2"] = -1,
  ["wh_main_emp_walls_3"] = -1,
  ["wh2_main_emp_defence_norsca_1"] = -1,
--greenskins
  ["wh_dlc06_grn_boars_1_skarsnik"] = 3,
  ["wh_dlc06_grn_boars_2_skarsnik"] = 4,
  ["wh_dlc06_grn_eight_peaks_1"] = 1,
  ["wh_dlc06_grn_eight_peaks_2"] = 4,
  ["wh_dlc06_grn_eight_peaks_3"] = 5,
  ["wh_dlc06_grn_military_1_skarsnik"] = 1,
  ["wh_dlc06_grn_military_2_skarsnik"] = 2,
  ["wh_dlc06_grn_military_3_skarsnik"] = 3,
  ["wh_dlc06_grn_military_4_skarsnik"] = 4,
  ["wh_dlc06_grn_resource_animals"] = 3,
  ["wh_dlc06_grn_squigs_1"] = 3,
  ["wh_main_grn_boars_1"] = 3,
  ["wh_main_grn_boars_2"] = 4,
  ["wh_main_grn_forest_beasts_1"] = 2,
  ["wh_main_grn_forest_beasts_2"] = 3,
  ["wh_main_grn_forest_beasts_3"] = 4,
  ["wh_main_grn_military_1"] = 1,
  ["wh_main_grn_military_2"] = 2,
  ["wh_main_grn_military_3"] = 3,
  ["wh_main_grn_military_4"] = 4,
  ["wh_main_grn_monsters_1"] = 3,
  ["wh_main_grn_monsters_2"] = 5,
  ["wh_main_grn_workshop_1"] = 3,
  ["wh_main_grn_workshop_2"] = 4,
  ["wh_main_grn_shaman_1"] = 3,
  ["wh_main_grn_shaman_2"] = 4,
  ["wh_main_special_savage_orc_camp_1"] = 1,
  ["wh_main_special_savage_orc_camp_2"] = 2,
  ["wh_main_special_savage_orc_camp_3"] = 3,
  ["wh_dlc06_grn_garrison_1_skarsnik"] = -1,
  ["wh_dlc06_grn_garrison_1_wurrzag"] = -1,
  ["wh_dlc06_grn_garrison_2_skarsnik"] = -1,
  ["wh_dlc06_grn_garrison_2_wurrzag"] = -1,
  ["wh_main_grn_garrison_1"] = -1,
  ["wh_main_grn_garrison_2"] = -1,
  ["wh_dlc06_grn_walls_1_skarsnik"] = -1,
  ["wh_dlc06_grn_walls_1_wurrzag"] = -1,
  ["wh_dlc06_grn_walls_2_skarsnik"] = -1,
  ["wh_dlc06_grn_walls_2_wurrzag"] = -1,
  ["wh_dlc06_grn_walls_3_skarsnik"] = -1,
  ["wh_dlc06_grn_walls_3_wurrzag"] = -1,
  ["wh_main_grn_walls_1"] = -1,
  ["wh_main_grn_walls_2"] = -1,
  ["wh_main_grn_walls_3"] = -1,
  ["wh2_main_grn_defence_norsca_1"] = -1,
  ["wh2_main_savageorc_defence_norsca_1"] = -1,
  ["wh_main_savage_garrison_1"] = -1,
  ["wh_main_savage_garrison_2"] = -1,
--special emp
  ["wh_main_kislev_worship_1"] = 3,
  ["wh_main_kislev_worship_2"] = 4,
  ["wh_main_middenheim_worship_1"] = 3,
  ["wh_main_middenheim_worship_2"] = 4,
--norsca
  ["wh_main_nor_beasts_1"] = 1,
  ["wh_main_nor_beasts_2"] = 3,
  ["wh_main_nor_beasts_3"] = 4,
  ["wh_main_nor_chaos_1"] = 4,
  ["wh_main_nor_chaos_2"] = 5,
  ["wh_main_nor_creatures_1"] = 3,
  ["wh_main_nor_creatures_2"] = 4,
  ["wh_main_nor_creatures_3"] = 5,
  ["wh_main_nor_erengrad_unique"] = 3,
  ["wh_main_nor_military_1"] = 1,
  ["wh_main_nor_military_2"] = 2,
  ["wh_main_nor_military_3"] = 3,
  ["wh_main_nor_outpost_military_1"] = 1,
  ["wh_main_nor_outpost_military_2"] = 2,
  ["wh_main_nor_outpost_military_3"] = 3,
  ["wh_main_nor_outpost_stables_1"] = 1,
  ["wh_main_nor_outpost_stables_2"] = 2,
  ["wh_main_nor_outpost_stables_3"] = 3,
  ["wh_main_nor_offerings_1"] = 3,
  ["wh_main_nor_offerings_2"] = 4,
  ["wh_main_nor_stables_1"] = 1,
  ["wh_main_nor_stables_2"] = 2,
  ["wh_main_nor_stables_3"] = 3,
  ["wh_main_nor_smith_1"] = 2,
  ["wh_main_nor_smith_2"] = 3,
  ["wh_main_nor_smith_3"] = 4,
  ["wh_main_nor_garrison_1"] = -1,
  ["wh_main_nor_garrison_2"] = -1,
  ["wh_main_nor_garrison_3"] = -1,
  ["wh_main_nor_outpost_garrison_1"] = -1,
  ["wh_main_nor_outpost_garrison_2"] = -1,
  ["wh_main_nor_outpost_garrison_3"] = -1,
  ["wh_main_nor_walls_1"] = -1,
  ["wh_main_nor_walls_2"] = -1,
  ["wh_main_nor_walls_3"] = -1,
--other
  ["wh_main_savage_boars_1"] = 3,
  ["wh_main_savage_military_1"] = 1,
  ["wh_main_savage_military_2"] = 2,
  ["wh_main_savage_military_3"] = 3,
  ["wh_main_talabec_worship_1"] = 3,
  ["wh_main_talabec_worship_2"] = 4,
  ["wh_main_teb_worship_1"] = 3,
  ["wh_main_teb_worship_2"] = 4,
  ["wh_main_ksl_walls_1"] = -1,
  ["wh_main_ksl_walls_2"] = -1,
  ["wh_main_ksl_walls_3"] = -1,
  ["wh_main_teb_walls_1"] = -1,
  ["wh_main_teb_walls_2"] = -1,
  ["wh_main_teb_walls_3"] = -1,
--counts
  ["wh_main_vmp_bindingcircle_1"] = 2,
  ["wh_main_vmp_bindingcircle_2"] = 3,
  ["wh_main_vmp_bindingcircle_3"] = 4,
  ["wh_main_vmp_cemetary_1"] = 1,
  ["wh_main_vmp_cemetary_2"] = 2,
  ["wh_main_vmp_cemetary_3"] = 3,
  ["wh_main_vmp_forest_1"] = 1,
  ["wh_main_vmp_forest_2"] = 3,
  ["wh_main_vmp_forest_3"] = 3,
  ["wh_main_vmp_necromancers_1"] = 4,
  ["wh_main_vmp_necromancers_2"] = 5,
  ["wh_main_vmp_vampires_1"] = 4,
  ["wh_main_vmp_vampires_2"] = 5,
  ["wh2_main_vmp_terrorgheists_1"] = 5,
  ["wh2_main_vmp_wraiths_1"] = 3,
  ["wh2_main_vmp_wraiths_2"] = 4,
  ["wh_main_vmp_armoury_1"] = 2,
  ["wh_main_vmp_armoury_2"] = 3,
  ["wh_main_vmp_walls_1"] = -1,
  ["wh_main_vmp_walls_2"] = -1,
  ["wh_main_vmp_walls_3"] = -1,
  ["wh_main_vmp_garrison_1"] = -1,
  ["wh_main_vmp_garrison_2"] = -1,
  ["wh2_main_vmp_defence_norsca_1"] = -1,
--tomb kings
  ["wh2_dlc09_tmb_arkhan_burial_mound"] = 1,
  ["wh2_dlc09_tmb_arkhan_burial_mound_2"] = 3,
  ["wh2_dlc09_tmb_cavalry_1"] = 2,
  ["wh2_dlc09_tmb_cavalry_2"] = 3,
  ["wh2_dlc09_tmb_cavalry_3"] = 4,
  ["wh2_dlc09_tmb_cavalry_4"] = 5,
  ["wh2_dlc09_tmb_chariots_1"] = 1,
  ["wh2_dlc09_tmb_chariots_2"] = 2,
  ["wh2_dlc09_tmb_chariots_3"] = 3,
  ["wh2_dlc09_tmb_estate_1"] = 4,
  ["wh2_dlc09_tmb_hierotitan_1"] = 5,
  ["wh2_dlc09_tmb_infantry_1"] = 1,
  ["wh2_dlc09_tmb_infantry_2"] = 2,
  ["wh2_dlc09_tmb_infantry_3"] = 3,
  ["wh2_dlc09_tmb_necrosphinx_1"] = 5,
  ["wh2_dlc09_tmb_public_order_2"] = 2,
  ["wh2_dlc09_tmb_public_order_3"] = 3,
  ["wh2_dlc09_tmb_scorpions_1"] = 4,
  ["wh2_dlc09_tmb_ushabti_1"] = 3,
  ["wh2_dlc09_tmb_ushabti_2"] = 4,
  ["wh2_dlc09_tmb_warsphinx_1"] = 5,
--coast
  ["wh2_dlc11_vampirecoast_military_barracks_1"] = 1,
  ["wh2_dlc11_vampirecoast_military_barracks_2"] = 2,
  ["wh2_dlc11_vampirecoast_military_barracks_3"] = 4,
  ["wh2_dlc11_vampirecoast_military_barracks_4"] = 5,
  ["wh2_dlc11_vampirecoast_military_flying_1"] = 1,
  ["wh2_dlc11_vampirecoast_military_flying_2"] = 3,
  ["wh2_dlc11_vampirecoast_military_flying_3"] = 4,
  ["wh2_dlc11_vampirecoast_military_flying_4"] = 5,
  ["wh2_dlc11_vampirecoast_military_ranged_1"] = 1,
  ["wh2_dlc11_vampirecoast_military_ranged_2"] = 2,
  ["wh2_dlc11_vampirecoast_military_ranged_3"] = 3,
  ["wh2_dlc11_vampirecoast_military_ranged_4"] = 4,
  ["wh2_dlc11_vampirecoast_ship_cannons_1"] = 1,
  ["wh2_dlc11_vampirecoast_ship_cannons_2"] = 2,
  ["wh2_dlc11_vampirecoast_ship_cannons_3"] = 3,
  ["wh2_dlc11_vampirecoast_ship_crows_nest_1"] = 0,
  ["wh2_dlc11_vampirecoast_ship_crows_nest_2"] = 2,
  ["wh2_dlc11_vampirecoast_ship_crows_nest_3"] = 3,
  ["wh2_dlc11_vampirecoast_ship_crows_nest_4"] = 4,
  ["wh2_dlc11_vampirecoast_ship_gunports_1"] = 0,
  ["wh2_dlc11_vampirecoast_ship_gunports_2"] = 1,
  ["wh2_dlc11_vampirecoast_ship_gunports_3"] = 2,
  ["wh2_dlc11_vampirecoast_ship_gunports_4"] = 3,
  ["wh2_dlc11_vampirecoast_ship_hold_1"] = 1,
  ["wh2_dlc11_vampirecoast_ship_hold_2"] = 2,
  ["wh2_dlc11_vampirecoast_ship_hold_3"] = 4,
  ["wh2_dlc11_vampirecoast_ship_hull_3"] = 4,
  ["wh2_dlc11_vampirecoast_ship_main_deck_1"] = 0,
  ["wh2_dlc11_vampirecoast_ship_main_deck_2"] = 1,
  ["wh2_dlc11_vampirecoast_ship_main_deck_3"] = 3,
  ["wh2_dlc11_vampirecoast_ship_main_deck_4"] = 4,
  ["wh2_dlc11_vampirecoast_support_artillery_1"] = 2,
  ["wh2_dlc11_vampirecoast_support_artillery_2"] = 3,
  ["wh2_dlc11_vampirecoast_support_artillery_3"] = 4,
  ["wh2_dlc11_vampirecoast_support_monsters_1"] = 2,
  ["wh2_dlc11_vampirecoast_support_monsters_2"] = 3,
  ["wh2_dlc11_vampirecoast_support_monsters_3"] = 5,
  ["wh2_dlc11_vampirecoast_support_necrofex_1"] = 5,
  ["wh2_dlc11_vampirecoast_defence_garrison_1"] = -1,
  ["wh2_dlc11_vampirecoast_defence_garrison_2"] = -1,
  ["wh2_dlc11_vampirecoast_defence_norsca_1"] = -1,
  ["wh2_dlc11_vampirecoast_defence_walls_1"] = -1,
  ["wh2_dlc11_vampirecoast_defence_walls_2"] = -1,
  ["wh2_dlc11_vampirecoast_defence_walls_3"] = -1,
--dark elves
  ["wh2_main_def_sorcery_1"] = 3,
  ["wh2_main_def_sorcery_2"] = 5,
  ["wh2_main_def_barracks_1"] = 1,
  ["wh2_main_def_barracks_2"] = 2,
  ["wh2_main_def_barracks_3"] = 3,
  ["wh2_main_def_beasts_1"] = 3,
  ["wh2_main_def_beasts_2"] = 4,
  ["wh2_main_def_beasts_3"] = 5,
  ["wh2_main_def_coldones_1"] = 4,
  ["wh2_main_def_coldones_2"] = 5,
  ["wh2_main_def_exiles_1"] = 2,
  ["wh2_main_def_exiles_2"] = 3,
  ["wh2_main_def_murder_2"] = 5,
  ["wh2_main_def_pleasure_cult_1"] = 1,
  ["wh2_main_def_pleasure_cult_2"] = 2,
  ["wh2_main_def_pleasure_cult_3"] = 3,
  ["wh2_main_def_pleasure_cult_4"] = 4,
  ["wh2_main_def_pleasure_cult_5"] = 5,
  ["wh2_main_def_riders_1"] = 2,
  ["wh2_main_def_riders_2"] = 3,
  ["wh2_main_def_worship_1"] = 3,
  ["wh2_main_def_worship_2"] = 4,
  ["wh2_main_def_worship_3"] = 5,
  ["wh2_main_def_defence_major_1"] = -1,
  ["wh2_main_def_defence_major_2"] = -1,
  ["wh2_main_def_defence_major_3"] = -1,
  ["wh2_main_def_defence_minor_1"] = -1,
  ["wh2_main_def_defence_minor_2"] = -1,
  ["wh2_main_def_defence_norsca_1"] = -1,
--hight elves
  ["wh2_dlc10_hef_aesanar_camp"] = 2,
  ["wh2_main_hef_barracks_1"] = 1,
  ["wh2_main_hef_barracks_2"] = 2,
  ["wh2_main_hef_barracks_3"] = 3,
  ["wh2_main_hef_dragons_1"] = 4,
  ["wh2_main_hef_dragons_2"] = 5,
  ["wh2_main_hef_hunters_1"] = 3,
  ["wh2_main_hef_mages_1"] = 3,
  ["wh2_main_hef_mages_2"] = 4,
  ["wh2_main_hef_mages_3"] = 5,
  ["wh2_main_hef_smith_1"] = 3,
  ["wh2_main_hef_smith_2"] = 4,
  ["wh2_main_hef_stables_1"] = 2,
  ["wh2_main_hef_stables_2"] = 3,
  ["wh2_main_hef_worship_1"] = 3,
  ["wh2_main_hef_worship_2"] = 4,
  ["wh2_main_hef_worship_3"] = 5,
  ["wh2_dlc10_hef_handmaidens"] = 4,
  ["wh2_dlc10_hef_handmaidens_alarielle"] = 3,
  ["wh2_dlc15_hef_field_hq_1"] = 3,
  ["wh2_dlc15_hef_field_hq_2"] = 4,
  ["wh2_dlc15_hef_field_hq_3"] = 5,
  ["wh2_main_hef_defence_major_1"] = -1,
  ["wh2_main_hef_defence_major_2"] = -1,
  ["wh2_main_hef_defence_major_3"] = -1,
  ["wh2_main_hef_defence_minor_1"] = -1,
  ["wh2_main_hef_defence_minor_2"] = -1,
  ["wh2_main_hef_defence_norsca_1"] = -1,
--lizardmen
  ["wh2_main_lzd_beasts_1"] = 3,
  ["wh2_main_lzd_beasts_2"] = 4,
  ["wh2_main_lzd_beasts_3"] = 5,
  ["wh2_main_lzd_coldones_1"] = 3,
  ["wh2_main_lzd_resource_animals_3"] = 3,
  ["wh2_main_lzd_saurus_1"] = 1,
  ["wh2_main_lzd_saurus_2"] = 2,
  ["wh2_main_lzd_saurus_3"] = 4,
  ["wh2_main_lzd_skinks_1"] = 1,
  ["wh2_main_lzd_skinks_2"] = 2,
  ["wh2_main_lzd_skinks_3"] = 3,
  ["wh2_main_lzd_terradons_1"] = 3,
  ["wh2_dlc12_lzd_terradons_2"] = 4,
  ["wh2_main_lzd_terradons_1_tiktakto"] = 2,
  ["wh2_main_lzd_terradons_2_tiktakto"] = 3,
  ["wh2_main_lzd_worship_oldones_1"] = 3,
  ["wh2_main_lzd_worship_oldones_2"] = 4,
  ["wh2_main_lzd_worship_oldones_3"] = 5,
  ["wh2_main_lzd_worship_sotek_1"] = 3,
  ["wh2_main_lzd_worship_sotek_2"] = 4,
  ["wh2_main_lzd_worship_sotek_3"] = 5,
  ["wh2_main_lzd_smith_1"] = 3,
  ["wh2_dlc13_horde_lizardmen_slann_1"] = 2,
  ["wh2_dlc13_horde_lizardmen_slann_2"] = 3,
  ["wh2_dlc13_horde_lizardmen_slann_3"] = 4,
  ["wh2_main_lzd_slann_1"] = 3,
  ["wh2_main_lzd_defence_major_1"] = -1,
  ["wh2_main_lzd_defence_major_2"] = -1,
  ["wh2_main_lzd_defence_major_3"] = -1,
  ["wh2_main_lzd_defence_minor_1"] = -1,
  ["wh2_main_lzd_defence_minor_2"] = -1,
  ["wh2_main_lzd_defence_norsca_1"] = -1,
--skaven
  ["wh2_main_skv_assassins_1"] = 2,
  ["wh2_main_skv_assassins_2"] = 3,
  ["wh2_main_skv_assassins_3"] = 4,
  ["wh2_main_skv_clanrats_1"] = 1,
  ["wh2_main_skv_clanrats_2"] = 2,
  ["wh2_main_skv_clanrats_3"] = 3,
  ["wh2_main_skv_engineers_1"] = 3,
  ["wh2_main_skv_engineers_2"] = 4,
  ["wh2_main_skv_engineers_3"] = 5,
  ["wh2_main_skv_monsters_1"] = 3,
  ["wh2_main_skv_monsters_2"] = 5,
  ["wh2_main_skv_plagues_1"] = 3,
  ["wh2_main_skv_plagues_2"] = 4,
  ["wh2_main_skv_plagues_3"] = 5,
  ["wh2_dlc14_skv_weaponteams_1"] = 2,
  ["wh2_main_skv_weaponteams_1"] = 3,
  ["wh2_main_skv_weaponteams_2"] = 4,
  ["wh2_dlc14_skv_eshin_assassins_1"] = 1,
  ["wh2_dlc14_skv_eshin_assassins_2"] = 2,
  ["wh2_dlc14_skv_eshin_assassins_3"] = 3,
  ["wh2_dlc12_special_warpstone_tractor_beam_1"] = 1,
  ["wh2_dlc12_special_warpstone_tractor_beam_2"] = 3,
  ["wh2_dlc14_special_skv_eshin_den"] = 2,
  ["wh2_dlc14_skv_weaponteams_1"] = 2,
  ["wh2_main_special_mors_hq_1"] = 2,
  ["wh2_main_special_corrupted_spawning_pool_1"] = 2,
  --walls
  ["wh2_main_skv_defence_major_1"] = -1,
  ["wh2_main_skv_defence_major_2"] = -1,
  ["wh2_main_skv_defence_major_3"] = -1,
  ["wh2_main_skv_defence_minor_1"] = -1,
  ["wh2_main_skv_defence_minor_2"] = -1,
  ["wh2_main_skv_defence_norsca_1"] = -1,
--mixu mousilion
  ["mixu_msl_barracks_1"] = 2,
  ["mixu_msl_barracks_2"] = 3,
  ["mixu_msl_wraiths_1"] = 3,
  ["mixu_msl_wraiths_2"] = 4,
  ["mixu_msl_binding_circle_1"] = 2,
  ["mixu_msl_binding_circle_2"] = 3,
  ["mixu_msl_binding_circle_3"] = 4,
  ["mixu_msl_carpenter_1"] = 2,
  ["mixu_msl_carpenter_2"] = 4,
--skaven clans
  ["thom_ferrik_barracks_1"] = 1,
  ["thom_ferrik_barracks_2"] = 2,
  ["thom_ferrik_barracks_3"] = 3,
  ["thom_ferrik_forge_1"] = 3,
  ["thom_ferrik_forge_2"] = 4,
  ["thom_ferrik_forge_3"] = 5,
  ["thom_ferrik_HQ_1"] = 0,
  ["thom_ferrik_HQ_2"] = 1,
  ["thom_ferrik_HQ_3"] = 2,
  ["thom_ferrik_weaponteams_1"] = 2,
  ["thom_ferrik_weaponteams_2"] = 3,
  ["thom_ferrik_weaponteams_3"] = 4,
  ["thom_ferrik_HQ_4"] = 3,
  ["thom_ferrik_HQ_5"] = 4,
  ["thom_vulkan_barracks_1"] = 1,
  ["thom_vulkan_barracks_2"] = 2,
  ["thom_vulkan_barracks_3"] = 3,
  ["thom_vulkan_engineers_1"] = 3,
  ["thom_vulkan_engineers_2"] = 4,
  ["thom_vulkan_engineers_3"] = 5,
  ["thom_vulkan_HQ_1"] = 1,
  ["thom_vulkan_HQ_2"] = 2,
  ["thom_vulkan_HQ_3"] = 3,
  ["thom_vulkan_weapon_teams_1"] = 2,
  ["thom_vulkan_weapon_teams_2"] = 3,
  ["thom_vulkan_weapon_teams_3"] = 4,
--Lanmarks
  ["wh2_dlc15_special_fortress_of_vorag_tower_of_the_bloodytooth"] = 2,
--Grn wez
  ["ws_grn_squigs_2"] = 4,
  ["ws_grn_forest_beasts_0"] = 1,
  ["ws_grn_shaman_1"] = 3,
  ["ws_grn_shaman_2"] = 4,
  ["ws_grn_shaman_3"] = 5,
  ["ws_grn_fungal_cave_1"] = 2,
  ["ws_grn_fungal_cave_2"] = 3,
  ["ws_grn_fungal_cave_3"] = 4,
  ["ws_savage_military_1"] = 2,
  ["ws_savage_military_2"] = 3,
  ["ws_savage_military_3"] = 4,
  ["ws_grn_military_1"] = 1,
  ["ws_grn_military_2"] = 2,
  ["ws_grn_military_3"] = 3,
  ["ws_grn_military_4"] = 4,
}


local SRW_Subculture_Text = {
  ["wh_main_sc_dwf_dwarfs"] = "SRW_Subculture_Text_dwarves",
  ["wh_main_sc_emp_empire"] = "SRW_Subculture_Text_empire",
  ["wh_main_sc_vmp_vampire_counts"] = "SRW_Subculture_Text_vmp",
  ["wh_dlc05_sc_wef_wood_elves"] = "SRW_Subculture_Text_wood_elves",
  ["wh_main_sc_grn_greenskins"] = "SRW_Subculture_Text_greenskins",
  ["wh_main_sc_nor_norsca"] = "SRW_Subculture_Text_nor",
  ["wh2_dlc11_sc_cst_vampire_coast"] = "SRW_Subculture_Text_cst",
  ["wh2_main_sc_def_dark_elves"] = "SRW_Subculture_Text_def",
  ["wh2_main_sc_hef_high_elves"] = "SRW_Subculture_Text_hef",
  ["wh2_main_sc_lzd_lizardmen"] = "SRW_Subculture_Text_lzd",
  ["wh2_main_sc_skv_skaven"] = "SRW_Subculture_Text_skv"
  -- ["wh_main_sc_ksl_kislev"] = "",
  -- ["wh_main_sc_teb_teb"] = "",
}

local Mixu1_Subculture_Text = {
  ["wh_main_sc_emp_empire"] = "SRW_Subculture_Text_mixu_emp",
  ["wh_main_sc_ksl_kislev"] = "SRW_Subculture_Text_mixu_ksl",
  ["wh_dlc05_sc_wef_wood_elves"] = "SRW_Subculture_Text_mixu_wef",
  ["wh_main_sc_dwf_dwarfs"] = "SRW_Subculture_Text_mixu_dwf"
}

local Mixu2_Subculture_Text = {
  ["wh2_main_sc_hef_high_elves"] = "SRW_Subculture_Text_mixu2_hef",
  ["wh_dlc05_sc_wef_wood_elves"] = "SRW_Subculture_Text_mixu2_wef",
  ["wh2_main_sc_def_dark_elves"] = "SRW_Subculture_Text_mixu2_def",
  ["wh2_main_sc_lzd_lizardmen"] = "SRW_Subculture_Text_mixu2_lzd"
}

local Kraka_Subculture_Text = {
  ["wh_main_sc_dwf_dwarfs"] = "SRW_Subculture_Text_kraka"
}

local Vulcan_Subculture_Text = {
  ["wh2_main_sc_skv_skaven"] = "SRW_Subculture_Text_vulcan"
}

local Wez_Subculture_Text = {
  ["wh_main_sc_grn_savage_orcs"] = "SRW_Subculture_Text_wez"
}


local SRW_Free_Units = {
  --Empire
  
    ["wh_main_emp_cav_reiksguard-emp_karl_franz"] = 0,
    ["wh_dlc04_emp_cav_zintlers_reiksguard_0-emp_karl_franz"] = 1,
    ["wh2_dlc13_emp_cav_reiksguard_imperial_supply-emp_karl_franz"] = 0,
    ["wh_main_emp_inf_greatswords-emp_karl_franz"] = 0,
    ["wh2_dlc13_emp_inf_greatswords_imperial_supply-emp_karl_franz"] = 0,
    ["wh2_dlc13_emp_inf_greatswords_ror_0-emp_karl_franz"] = 0,
    ["wh2_dlc13_emp_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh2_dlc13_emp_inf_huntsmen_0_imperial_supply-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh2_dlc13_emp_inf_huntsmen_ror_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh2_dlc13_emp_inf_archers_ror_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
  
    ["wh2_dlc13_emp_veh_war_wagon_ror_0-emp_balthasar_gelt"] = 3,
    ["wh2_dlc13_emp_art_great_cannon_imperial_supply-emp_balthasar_gelt"] = 2,
    ["wh2_dlc13_emp_art_helblaster_volley_gun_imperial_supply-emp_balthasar_gelt"] = 2,
    ["wh2_dlc13_emp_art_helstorm_rocket_battery_imperial_supply-emp_balthasar_gelt"] = 2,
    ["wh_main_emp_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_emp_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_emp_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_emp_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh2_dlc13_emp_art_mortar_ror_0-emp_balthasar_gelt"] = 2,
    ["wh_dlc04_emp_art_hammer_of_the_witches_0-emp_balthasar_gelt"] = 3,
    ["wh_dlc04_emp_art_sunmaker_0-emp_balthasar_gelt"] = 3,
    ["wh2_dlc13_emp_veh_war_wagon_1_imperial_supply-emp_balthasar_gelt"] = 2,
    ["wh2_dlc13_emp_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
  
  --sword of emp
    ["wh_main_mid_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_avr_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_rek_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_hoc_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_mbg_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_nod_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_osl_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_osm_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_str_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_tab_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_wis_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_sol_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_hun_inf_greatswords-emp_karl_franz"] = 0,
    ["wh_main_mid_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_avr_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_rek_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_hoc_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_mbg_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_nod_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_osl_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_osm_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_str_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_tab_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_wis_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_sol_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_hun_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 0,
    ["wh_main_mid_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_avr_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_rek_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_hoc_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_mbg_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_nod_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_osl_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_osm_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_str_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_tab_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_wis_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_sol_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_hun_art_mortar-emp_balthasar_gelt"] = 2,
    ["wh_main_mid_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_avr_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_rek_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_hoc_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_mbg_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_nod_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_osl_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_osm_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_str_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_tab_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_wis_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_sol_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_hun_art_great_cannon-emp_balthasar_gelt"] = 2,
    ["wh_main_mid_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_avr_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_rek_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_hoc_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_mbg_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_nod_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_osl_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_osm_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_str_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_tab_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_wis_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_sol_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_hun_veh_war_wagon_1-emp_balthasar_gelt"] = 2,
    ["wh_main_mid_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_mid_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_avr_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_avr_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_rek_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_rek_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_hoc_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_hoc_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_mbg_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_mbg_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_nod_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_nod_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_osl_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_osl_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_osm_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_osm_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_str_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_str_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_tab_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_tab_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_wis_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_wis_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_sol_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_sol_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
    ["wh_main_hun_art_helblaster_volley_gun-emp_balthasar_gelt"] = 2,
    ["wh_main_hun_art_helstorm_rocket_battery-emp_balthasar_gelt"] = 2,
  
  
  --mixu emp
    ["wh_main_emp_cav_reiksguard-emp_marius_leitdorf"] = 0,
    ["wh_main_emp_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_mid_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_avr_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_rek_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_hoc_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_mbg_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_nod_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_osl_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_osm_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_str_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_tab_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_wis_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_sol_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_main_hun_cav_empire_knights-emp_marius_leitdorf"] = 0,
    ["wh_dlc04_emp_cav_zintlers_reiksguard_0-emp_marius_leitdorf"] = 0,
    ["wh_dlc04_emp_cav_knights_blazing_sun_0-emp_marius_leitdorf"] = 0,
    ["wh2_dlc13_emp_cav_empire_knights_ror_0-emp_marius_leitdorf"] = 0,
    ["wh2_dlc13_emp_cav_empire_knights_ror_1-emp_marius_leitdorf"] = 0,
    ["wh2_dlc13_emp_cav_empire_knights_ror_2-emp_marius_leitdorf"] = 0,
    ["wh2_dlc13_emp_cav_reiksguard_imperial_supply-emp_marius_leitdorf"] = 0,
    ["wh2_dlc13_emp_cav_empire_knights_imperial_supply-emp_marius_leitdorf"] = 0,
    ["wh2_dlc13_emp_cav_knights_blazing_sun_0_imperial_supply-emp_marius_leitdorf"] = 0,
    ["wh_dlc04_emp_inf_silver_bullets_0-emp_aldebrand_ludenhof"] = 0,
    ["wh2_dlc13_emp_inf_handgunners_ror_0-emp_aldebrand_ludenhof"] = 0,
    ["wh2_dlc13_emp_inf_handgunners_imperial_supply-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_emp_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_mid_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_avr_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_rek_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_hoc_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_mbg_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_nod_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_osl_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_osm_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_str_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_tab_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_wis_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_sol_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_main_hun_inf_handgunners-emp_aldebrand_ludenhof"] = 0,
    ["wh_dlc04_emp_inf_silver_bullets_0-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_emp_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh2_dlc13_emp_inf_halberdiers_imperial_supply-dlc03_emp_boris_todbringer"] = 0,
    ["wh2_dlc13_emp_inf_halberdiers_ror_0-dlc03_emp_boris_todbringer"] = 0,
    ["wh2_dlc13_emp_inf_handgunners_imperial_supply-dlc03_emp_boris_todbringer"] = 0,
    ["wh2_dlc13_emp_inf_handgunners_ror_0-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_emp_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_mid_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_avr_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_rek_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_hoc_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_mbg_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_nod_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_osl_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_osm_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_str_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_tab_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_wis_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_sol_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_hun_inf_handgunners-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_mid_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_avr_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_rek_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_hoc_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_mbg_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_nod_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_osl_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_osm_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_str_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_tab_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_wis_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_sol_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_hun_inf_halberdiers-dlc03_emp_boris_todbringer"] = 0,
    ["wh_dlc04_emp_inf_silver_bullets_0-dlc03_emp_boris_todbringer"] = 0,
    ["wh_main_emp_inf_halberdiers-emp_valmir_von_raukov"] = 0,
    ["wh2_dlc13_emp_inf_halberdiers_ror_0-emp_valmir_von_raukov"] = 0,
    ["wh2_dlc13_emp_inf_halberdiers_imperial_supply-emp_valmir_von_raukov"] = 0,
    ["wh2_dlc13_emp_cav_demigryph_knights_0_imperial_supply-emp_helmut_feuerbach"] = 2,
    ["wh2_dlc13_emp_cav_demigryph_knights_1_imperial_supply-emp_helmut_feuerbach"] = 2,
    ["wh2_dlc13_emp_veh_steam_tank_imperial_supply-emp_helmut_feuerbach"] = 2,
    ["wh_main_emp_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_emp_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_mid_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_avr_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_rek_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_hoc_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_mbg_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_nod_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_osl_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_osm_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_str_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_tab_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_wis_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_sol_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_hun_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 2,
    ["wh_main_mid_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_avr_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_rek_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_hoc_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_mbg_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_nod_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_osl_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_osm_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_str_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_tab_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_wis_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_sol_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
    ["wh_main_hun_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 2,
  
    ["wh_dlc04_emp_cav_royal_altdorf_gryphites_0-emp_helmut_feuerbach"] = 3,
    ["wh2_dlc13_emp_art_great_cannon_imperial_supply-mixu_elspeth_von_draken"] = 1,
    ["wh2_dlc13_emp_art_helblaster_volley_gun_imperial_supply-mixu_elspeth_von_draken"] = 1,
    ["wh2_dlc13_emp_art_helstorm_rocket_battery_imperial_supply-mixu_elspeth_von_draken"] = 1,
    ["wh_main_emp_art_great_cannon-mixu_elspeth_von_draken"] = 1,
    ["wh_main_emp_art_helblaster_volley_gun-mixu_elspeth_von_draken"] = 1,
    ["wh_main_emp_art_helstorm_rocket_battery-mixu_elspeth_von_draken"] = 1,
    ["wh_main_emp_art_mortar-mixu_elspeth_von_draken"] = 1,
    ["wh2_dlc13_emp_art_mortar_ror_0-mixu_elspeth_von_draken"] = 1,
    ["wh_dlc04_emp_art_hammer_of_the_witches_0-mixu_elspeth_von_draken"] = 1,
    ["wh_dlc04_emp_art_sunmaker_0-mixu_elspeth_von_draken"] = 1,
    ["wh2_dlc13_emp_veh_war_wagon_1_imperial_supply-mixu_elspeth_von_draken"] = 1,
    ["wh2_dlc13_emp_veh_war_wagon_1-mixu_elspeth_von_draken"] = 1,
    ["wh2_dlc13_emp_inf_huntsmen_ror_0-emp_edward_van_der_kraal"] = 0,
    ["wh2_dlc13_emp_inf_archers_ror_0-emp_edward_van_der_kraal"] = 0,
    ["wh_dlc04_emp_inf_sigmars_sons_0-emp_edward_van_der_kraal"] = 0,
    ["wh_dlc04_emp_inf_stirlands_revenge_0-emp_edward_van_der_kraal"] = 0,
    ["wh_dlc04_emp_inf_tattersouls_0-emp_edward_van_der_kraal"] = 0,
    ["wh_dlc04_emp_inf_silver_bullets_0-emp_edward_van_der_kraal"] = 0,
    ["wh_dlc04_emp_cav_zintlers_reiksguard_0-emp_edward_van_der_kraal"] = 1,
    ["wh2_dlc13_emp_veh_war_wagon_ror_0-emp_edward_van_der_kraal"] = 2,
    ["wh_dlc04_emp_art_hammer_of_the_witches_0-emp_edward_van_der_kraal"] = 2,
    ["wh_dlc04_emp_art_sunmaker_0-emp_edward_van_der_kraal"] = 2,
    ["wh_dlc04_emp_veh_templehof_luminark_0-emp_edward_van_der_kraal"] = 2,
    ["wh_dlc04_emp_cav_royal_altdorf_gryphites_0-emp_edward_van_der_kraal"] = 3,
    ["wh_main_emp_inf_greatswords-mixu_katarin_the_ice_queen"] = 0,
  
  --Dwarves
    ["wh_main_dwf_inf_slayers-dwf_ungrim_ironfist"] = 0,
    ["wh2_dlc10_dwf_inf_giant_slayers-dwf_ungrim_ironfist"] = 1,
    ["wh_dlc06_dwf_inf_dragonback_slayers_0-dwf_ungrim_ironfist"] = 0,
    ["wh_main_dwf_inf_hammerers-dwf_thorgrim_grudgebearer"] = 0,
    ["wh_main_dwf_inf_longbeards-dwf_thorgrim_grudgebearer"] = 0,
    ["wh_main_dwf_inf_longbeards_1-dwf_thorgrim_grudgebearer"] = 0,
    ["wh_dlc06_dwf_inf_old_grumblers_0-dwf_thorgrim_grudgebearer"] = 1,
    ["wh_dlc06_dwf_inf_peak_gate_guard_0-dwf_thorgrim_grudgebearer"] = 2,
    ["wh_main_dwf_inf_ironbreakers-dwf_kazador_dragonslayer"] = 2,
    ["wh_dlc06_dwf_inf_norgrimlings_ironbreakers_0-dwf_kazador_dragonslayer"] = 2,
    ["dwf_huskarls-dwf_kraka_drak"] = 1,
    
  --Vampire Counts
    ["wh_dlc04_vmp_inf_sternsmen_0-vmp_mannfred_von_carstein"] = 1,
    ["wh_main_vmp_inf_grave_guard_0-vmp_mannfred_von_carstein"] = 0,
    ["wh_main_vmp_inf_grave_guard_1-vmp_mannfred_von_carstein"] = 0,
    ["wh_main_vmp_cav_black_knights_0-vmp_mannfred_von_carstein"] = 0,
    ["wh_main_vmp_cav_black_knights_3-vmp_mannfred_von_carstein"] = 0,
    ["wh_dlc04_vmp_cav_vereks_reavers_0-vmp_mannfred_von_carstein"] = 1,
    ["wh_dlc04_vmp_veh_mortis_engine_0-dlc04_vmp_helman_ghorst"] = 0,
    ["wh_dlc04_vmp_veh_claw_of_nagash_0-dlc04_vmp_helman_ghorst"] = 0,
    
  --Greenskins
    ["wh_main_grn_inf_black_orcs-grn_grimgor_ironhide"] = 0,
    ["wh_main_grn_inf_orc_big_uns-grn_grimgor_ironhide"] = 0,
    ["wh_main_grn_cav_orc_boar_boy_big_uns-grn_grimgor_ironhide"] = 0,
    ["wh_dlc06_grn_inf_krimson_killerz_0-grn_grimgor_ironhide"] = 1,
    ["wh_main_grn_inf_night_goblins-dlc06_grn_skarsnik"] = 0,
    ["wh_dlc06_grn_inf_da_warlords_boyz_0-dlc06_grn_skarsnik"] = 0,
    ["wh_main_grn_inf_night_goblin_archers-dlc06_grn_skarsnik"] = 0,
    ["wh_main_grn_inf_night_goblin_fanatics-dlc06_grn_skarsnik"] = 0,
    ["wh_dlc06_grn_inf_da_rusty_arrers_0-dlc06_grn_skarsnik"] = 0,
    ["wh_main_grn_inf_night_goblin_fanatics_1-dlc06_grn_skarsnik"] = 0,
    ["wh_dlc06_grn_inf_da_eight_peaks_loonies_0-dlc06_grn_skarsnik"] = 0,
    ["wh_main_grn_inf_savage_orc_big_uns-dlc06_grn_wurrzag_da_great_prophet"] = 0,
    ["wh_main_grn_cav_savage_orc_boar_boy_big_uns-dlc06_grn_wurrzag_da_great_prophet"] = 0,
    ["grn_black_orc_shields-grn_grimgor_ironhide"] = 0,
    ["wh2_dlc15_grn_veh_snotling_pump_wagon_flappas_0-wh2_dlc15_grn_grom_the_paunch"] = 0,
    ["wh2_dlc15_grn_veh_snotling_pump_wagon_roller_0-wh2_dlc15_grn_grom_the_paunch"] = 0,
    ["wh_main_grn_cav_orc_boar_chariot-wh2_dlc15_grn_grom_the_paunch"] = 0,
    ["wh_main_grn_cav_goblin_wolf_chariot-wh2_dlc15_grn_grom_the_paunch"] = 0,
    ["wh2_dlc15_grn_veh_snotling_pump_wagon_ror_0-wh2_dlc15_grn_grom_the_paunch"] = 0,
    ["wh_dlc06_grn_cav_moon_howlers_0-dlc06_grn_skarsnik"] = 0,
    ["wh_dlc06_grn_cav_deff_creepers_0-dlc06_grn_skarsnik"] = 0,
  
    --extended
    ["goblin_boss-dlc06_grn_skarsnik"] = 0,
    ["grn_inf_black_orc_shields-grn_grimgor_ironhide"] = 0,
    ["grn_inf_black_orc_dual-grn_grimgor_ironhide"] = 0,
    ["grn_big_uns_shields-grn_azhag_the_slaughterer"] = 0,
    ["wh2_dlc15_grn_cav_squig_hoppers_waaagh_0"] = 2,
    ["ws_grn_inf_da_immortulz-grn_grimgor_ironhide"] = 1,
    ["wh2_dlc15_grn_mon_feral_hydra_waaagh_0-ws_grn_grak_beastbasha"] = 1,
    ["wh2_dlc15_grn_mon_river_trolls_0-ws_grn_grak_beastbasha"] = 0,
    ["wh2_dlc15_grn_mon_river_trolls_ror_0-ws_grn_grak_beastbasha"] = 0,
    ["wh2_dlc15_grn_mon_rogue_idol_0-ws_grn_grak_beastbasha"] = 2,
    ["wh2_dlc15_grn_mon_rogue_idol_ror_0-ws_grn_grak_beastbasha"] = 3,
    ["wh2_dlc15_grn_mon_stone_trolls_0-ws_grn_grak_beastbasha"] = 0,
    ["wh2_dlc15_grn_mon_wyvern_waaagh_0-ws_grn_grak_beastbasha"] = 1,
    ["wh_dlc06_grn_mon_venom_queen_0-ws_grn_grak_beastbasha"] = 3,
    ["wh_dlc15_grn_mon_arachnarok_spider_waaagh_0-ws_grn_grak_beastbasha"] = 2,
    ["wh_main_grn_mon_arachnarok_spider_0-ws_grn_grak_beastbasha"] = 2,
    ["wh_main_grn_mon_giant-ws_grn_grak_beastbasha"] = 1,
    ["wh_main_grn_mon_trolls-ws_grn_grak_beastbasha"] = 0,
    ["ws_grn_mon_stegadon_waaagh-ws_grn_grak_beastbasha"] = 1,
    ["ws_mon_little_gork-ws_grn_grak_beastbasha"] = 2,
  
  --Wood Elves
    ["wh_dlc05_wef_cav_wild_riders_0-dlc05_wef_orion"] = 0,
    ["wh_dlc05_wef_cav_wild_riders_1-dlc05_wef_orion"] = 0,
    ["wh_dlc05_wef_cav_sisters_thorn_0-dlc05_wef_orion"] = 0,
    ["wh_pro04_wef_cav_wild_riders_ror_0-dlc05_wef_orion"] = 0,
    ["wh_dlc05_wef_mon_treekin_0-dlc05_wef_durthu"] = 0,
    ["wh_dlc05_wef_mon_treeman_0-dlc05_wef_durthu"] = 1,
    ["wh_pro04_wef_mon_treekin_ror_0-dlc05_wef_durthu"] = 0,
    ["wh_dlc05_wef_cav_hawk_riders_0-wef_naieth_the_prophetess"] = 0,
    ["wh_dlc05_wef_mon_great_eagle_0-wef_naieth_the_prophetess"] = 0,
    ["wh_dlc05_wef_cav_sisters_thorn_0-wef_naieth_the_prophetess"] = 0,
    ["wh_pro04_wef_inf_waywatchers_ror_0-wef_daith"] = 0,
    ["wh_dlc05_wef_inf_deepwood_scouts_1-wef_daith"] = 0,
    ["wh_dlc05_wef_inf_deepwood_scouts_1_qb-wef_daith"] = 0,
    ["wh_dlc05_wef_inf_waywatchers_0-wef_daith"] = 0,
  
    -- ["wef_daith"] =						"mixu_defeated_trait_wef_daith"
    --wef_naieth_the_prophetess
  --Norsca
    ["wh_dlc08_nor_inf_marauder_champions_0-wh_dlc08_nor_wulfrik"] = 0,
    ["wh_dlc08_nor_inf_marauder_champions_1-wh_dlc08_nor_wulfrik"] = 0,
    ["wh_dlc08_nor_inf_marauder_berserkers_0-wh_dlc08_nor_wulfrik"] = 0,
    ["wh_dlc08_nor_mon_norscan_ice_trolls_0-wh_dlc08_nor_throgg"] = 0,
    ["wh_main_nor_mon_chaos_trolls-wh_dlc08_nor_throgg"] = 0,
    ["wh_pro04_nor_inf_chaos_marauders_ror_0-wh_dlc08_nor_wulfrik"] = 0,
    ["wh_pro04_nor_inf_marauder_berserkers_ror_0-wh_dlc08_nor_wulfrik"] = 0,
    ["wh_dlc08_nor_mon_war_mammoth_1-wh_dlc08_nor_wulfrik"] = 1,
    ["wh_dlc08_nor_mon_war_mammoth_2-wh_dlc08_nor_wulfrik"] = 1,
    ["wh_pro04_nor_mon_war_mammoth_ror_0-wh_dlc08_nor_wulfrik"] = 2,
    ["wh_dlc08_nor_mon_war_mammoth_ror_1-wh_dlc08_nor_wulfrik"] = 0,
    ["wh_dlc08_nor_mon_war_mammoth_0-wh_dlc08_nor_wulfrik"] = 0,
  
  
  --Hight Elves
    ["wh2_main_hef_cav_silver_helms_0-wh2_main_hef_tyrion"] = 0,
    ["wh2_main_hef_cav_silver_helms_1-wh2_main_hef_tyrion"] = 0,
    ["wh2_dlc10_hef_inf_the_scions_of_mathlann_ror_0-wh2_main_hef_tyrion"] = 0,
    ["wh2_dlc15_hef_inf_silverin_guard_0-wh2_main_hef_tyrion"] = 0,
    ["wh2_main_hef_inf_lothern_sea_guard_0-wh2_main_hef_tyrion"] = 0,
    ["wh2_main_hef_inf_lothern_sea_guard_1-wh2_main_hef_tyrion"] = 0,
    ["wh2_dlc10_hef_inf_the_storm_riders_ror_0-wh2_main_hef_tyrion"] = 0,
    ["wh2_dlc15_hef_inf_archers_ror_0-wh2_main_hef_tyrion"] = 0,
    ["wh2_dlc10_hef_inf_shadow_warriors_0-wh2_dlc10_hef_alith_anar"] = 0,
    ["wh2_dlc10_hef_inf_shadow_walkers_0-wh2_dlc10_hef_alith_anar"] = 0,
    ["wh2_dlc10_hef_inf_the_grey_ror_0-wh2_dlc10_hef_alith_anar"] = 0,
    ["wh2_main_hef_inf_white_lions_of_chrace_0-wh2_main_hef_prince_alastar"] = 0,
    ["wh2_dlc10_hef_inf_the_silverpelts_ror_0-wh2_main_hef_prince_alastar"] = 0,
    ["wh2_dlc10_hef_inf_sisters_of_avelorn_0-wh2_dlc10_hef_alarielle"] = 1,
    ["wh2_dlc10_hef_inf_everqueens_court_guards_ror_0-wh2_dlc10_hef_alarielle"] = 2,
    ["wh2_main_hef_inf_swordmasters_of_hoeth_0-wh2_main_hef_teclis"] = 1,
    ["wh2_main_hef_mon_phoenix_flamespyre-wh2_main_hef_teclis"] = 1,
    ["wh2_main_hef_mon_phoenix_frostheart-wh2_main_hef_teclis"] = 1,
    ["wh2_main_hef_mon_moon_dragon-wh2_dlc15_hef_imrik"] = 2,
    ["wh2_main_hef_mon_star_dragon-wh2_dlc15_hef_imrik"] = 2,
    ["wh2_main_hef_mon_sun_dragon-wh2_dlc15_hef_imrik"] = 1,
    ["wh2_main_hef_cav_dragon_princes-wh2_dlc15_hef_imrik"] = 2,
    ["wh2_dlc15_hef_mon_black_dragon_imrik-wh2_dlc15_hef_imrik"] = 3,
    ["wh2_dlc15_hef_mon_forest_dragon_0-wh2_dlc15_hef_imrik"] = 2,
    ["wh2_dlc15_hef_mon_forest_dragon_imrik-wh2_dlc15_hef_imrik"] = 2,
    ["wh2_dlc15_hef_mon_moon_dragon_imrik-wh2_dlc15_hef_imrik"] = 3,
    ["wh2_dlc15_hef_mon_star_dragon_imrik-wh2_dlc15_hef_imrik"] = 3,
    ["wh2_dlc15_hef_mon_sun_dragon_imrik-wh2_dlc15_hef_imrik"] = 2,
    ["wh2_dlc15_hef_inf_mistwalkers_faithbearers_0-wh2_dlc15_hef_eltharion"] = 0,
    ["wh2_dlc15_hef_inf_mistwalkers_spireguard_0-wh2_dlc15_hef_eltharion"] = 0,
    ["wh2_dlc15_hef_inf_mistwalkers_sentinels_0-wh2_dlc15_hef_eltharion"] = 0,
    ["wh2_dlc15_hef_inf_mistwalkers_skyhawks_0-wh2_dlc15_hef_eltharion"] = 0,
    ["wh2_dlc15_hef_inf_mistwalkers_griffon_knights_0-wh2_dlc15_hef_eltharion"] = 2,
    ["wh2_dlc15_hef_mon_war_lions_of_chrace_0-wh2_main_hef_prince_alastar"] = 0,
    ["wh2_dlc15_hef_veh_lion_chariot_of_chrace_0-wh2_main_hef_prince_alastar"] = 0,
    ["wh2_dlc15_hef_mon_war_lions_of_chrace_ror_0-wh2_main_hef_prince_alastar"] = 0,
    ["wh2_dlc15_hef_mon_arcane_phoenix_ror_0-wh2_main_hef_teclis"] = 3,
    ["wh2_dlc15_hef_mon_arcane_phoenix_0-wh2_main_hef_teclis"] = 2,
    ["wh2_jmw_hef_mon_forest_dragon-wh2_dlc15_hef_imrik"] = 1,
    ["cal_hef_cav_ghost_warriors-wh2_dlc15_hef_imrik"] = 2,
    ["hef_cal_hef_inf_dragon_guard_ror-wh2_dlc15_hef_imrik"] = 2,
    ["hef_cal_hef_cav_dragonspine_princes_ror-wh2_dlc15_hef_imrik"] = 3,
    ["hef_cal_hef_mon_baith_caradan_ror-wh2_dlc15_hef_imrik"] = 3,
    ["hef_yvr_inf_archers_mistwalkers-wh2_dlc15_hef_eltharion"] = 0,
  
    --mixu
    ["wh2_main_hef_mon_moon_dragon-hef_prince_imrik"] = 2,
    ["wh2_main_hef_mon_star_dragon-hef_prince_imrik"] = 2,
    ["wh2_main_hef_mon_sun_dragon-hef_prince_imrik"] = 2,
    ["wh2_main_hef_cav_dragon_princes-hef_prince_imrik"] = 2,
    ["wh2_dlc10_hef_cav_the_fireborn_ror_0-hef_prince_imrik"] = 2,
    ["wh2_main_hef_inf_white_lions_of_chrace_0-hef_korhil"] = 0,
    ["wh2_dlc10_hef_inf_the_silverpelts_ror_0-hef_korhil"] = 0,
    ["wh2_main_hef_inf_swordmasters_of_hoeth_0-hef_belannaer"] = 0,
    ["wh2_main_hef_inf_phoenix_guard-hef_bloodline_caradryan"] = 1,
    ["wh2_main_hef_mon_phoenix_flamespyre-hef_bloodline_caradryan"] = 1,
    ["wh2_main_hef_mon_phoenix_frostheart-hef_bloodline_caradryan"] = 1,
    ["wh2_dlc10_hef_inf_keepers_of_the_flame_ror_0-hef_bloodline_caradryan"] = 1,
  
  --Dark elves
    ["wh2_main_def_inf_black_guard_0-wh2_main_def_malekith"] = 1,
    ["wh2_dlc10_def_inf_the_hellebronai_ror_0-wh2_main_def_malekith"] = 0,
    ["wh2_main_def_inf_darkshards_1-wh2_main_def_malekith"] = 0,
    ["wh2_dlc10_def_inf_the_bolt_fiends_ror_0-wh2_main_def_malekith"] = 0,
    ["wh2_main_def_inf_black_ark_corsairs_0-wh2_dlc11_def_lokhir"] = 0,
    ["wh2_main_def_inf_black_ark_corsairs_1-wh2_dlc11_def_lokhir"] = 0,
    ["wh2_main_def_inf_witch_elves_0-wh2_dlc10_def_crone_hellebron"] = 0,
    ["wh2_dlc10_def_inf_sisters_of_slaughter-wh2_dlc10_def_crone_hellebron"] = 0,
    ["wh2_main_def_inf_har_ganeth_executioners_0-wh2_dlc10_def_crone_hellebron"] = 1,
    ["wh2_dlc10_def_inf_blades_of_the_blood_queen_ror_0-wh2_dlc10_def_crone_hellebron"] = 2,
    ["wh2_dlc10_def_inf_sisters_of_the_singing_doom_ror_0-wh2_dlc10_def_crone_hellebron"] = 0,
    ["wh2_main_def_cav_cold_one_chariot-wh2_dlc14_def_malus_darkblade"] = 0,
    ["wh2_main_def_cav_cold_one_knights_0-wh2_dlc14_def_malus_darkblade"] = 0,
    ["wh2_main_def_cav_cold_one_knights_1-wh2_dlc14_def_malus_darkblade"] = 0,
    ["wh2_dlc10_def_cav_knights_of_the_ebon_claw_ror_0-wh2_dlc14_def_malus_darkblade"] = 1,
    ["wh2_main_def_inf_witch_elves_0-def_tullaris_dreadbringer"] = 0,
    ["wh2_main_def_inf_har_ganeth_executioners_0-def_tullaris_dreadbringer"] = 1,
    ["wh2_dlc10_def_inf_blades_of_the_blood_queen_ror_0-def_tullaris_dreadbringer"] = 2,
    ["wh2_dlc10_def_inf_sisters_of_the_singing_doom_ror_0-def_tullaris_dreadbringer"] = 0,
    
  --Lizardmen
    ["wh2_main_lzd_cav_cold_ones_1-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_cav_horned_ones_0-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_cav_cold_one_spearmen_1-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_cav_horned_ones_blessed_0-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_dlc12_lzd_cav_cold_one_spearriders_ror_0-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_cav_cold_one_spearriders_blessed_0-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_inf_saurus_spearmen_0-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_inf_saurus_spearmen_1-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_inf_saurus_warriors_0-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_inf_saurus_warriors_1-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_dlc12_lzd_inf_saurus_warriors_ror_0-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_inf_saurus_spearmen_blessed_1-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_inf_saurus_warriors_blessed_1-wh2_main_lzd_kroq_gar"] = 0,
    ["wh2_main_lzd_inf_temple_guards-wh2_main_lzd_lord_mazdamundi"] = 0,
    ["wh2_dlc12_lzd_inf_temple_guards_ror_0-wh2_main_lzd_lord_mazdamundi"] = 1,
    ["wh2_main_lzd_inf_temple_guards_blessed-wh2_main_lzd_lord_mazdamundi"] = 0,
    ["wh2_main_lzd_cav_terradon_riders_1-wh2_dlc12_lzd_tiktaqto"] = 0,
    ["wh2_dlc12_lzd_cav_terradon_riders_ror_0-wh2_dlc12_lzd_tiktaqto"] = 0,
    ["wh2_dlc12_lzd_cav_ripperdactyl_riders_0-wh2_dlc12_lzd_tiktaqto"] = 0,
    ["wh2_dlc12_lzd_cav_terradon_riders_1_tlaqua-wh2_dlc12_lzd_tiktaqto"] = 0,
    ["wh2_main_lzd_cav_terradon_riders_blessed_1-wh2_dlc12_lzd_tiktaqto"] = 0,
    ["wh2_dlc12_lzd_cav_ripperdactyl_riders_ror_0-wh2_dlc12_lzd_tiktaqto"] = 0,
    ["wh2_dlc12_lzd_mon_salamander_pack_ror_0-lzd_tetto_eko"] = 0,
    ["wh2_dlc12_lzd_mon_salamander_pack_0-lzd_tetto_eko"] = 0,
    ["wh2_dlc12_lzd_mon_ancient_salamander_0-lzd_tetto_eko"] = 1,
    ["wh2_main_lzd_inf_saurus_spearmen_0-wh2_dlc13_lzd_gor_rok"] = 0,
    ["wh2_main_lzd_inf_saurus_spearmen_1-wh2_dlc13_lzd_gor_rok"] = 0,
    ["wh2_main_lzd_inf_saurus_warriors_0-wh2_dlc13_lzd_gor_rok"] = 0,
    ["wh2_main_lzd_inf_saurus_warriors_1-wh2_dlc13_lzd_gor_rok"] = 0,
    ["wh2_dlc12_lzd_inf_saurus_warriors_ror_0-wh2_dlc13_lzd_gor_rok"] = 0,
    ["wh2_main_lzd_inf_saurus_spearmen_blessed_1-wh2_dlc13_lzd_gor_rok"] = 0,
    ["wh2_main_lzd_inf_saurus_warriors_blessed_1-wh2_dlc13_lzd_gor_rok"] = 0,
    ["wh2_main_lzd_mon_kroxigors-wh2_dlc13_lzd_nakai"] = 0,
    ["wh2_main_lzd_mon_kroxigors_blessed-wh2_dlc13_lzd_nakai"] = 0,
    ["wh2_dlc13_lzd_mon_sacred_kroxigors_0-wh2_dlc13_lzd_nakai"] = 0,
    ["wh2_dlc13_lzd_mon_sacred_kroxigors_0_nakai-wh2_dlc13_lzd_nakai"] = 0,
    ["wh2_dlc13_lzd_mon_sacred_kroxigors_ror_0-wh2_dlc13_lzd_nakai"] = 1,
  
  --Skaven
    ["wh2_main_skv_inf_stormvermin_0-wh2_main_skv_queek_headtaker"] = 0,
    ["wh2_main_skv_inf_stormvermin_1-wh2_main_skv_queek_headtaker"] = 0,
    ["wh2_dlc12_skv_inf_clanrats_ror_0-wh2_main_skv_queek_headtaker"] = 0,
    ["wh2_dlc12_skv_inf_stormvermin_ror_0-wh2_main_skv_queek_headtaker"] = 0,
    ["thom_ferrik_stormvermin_2h-wh2_main_skv_queek_headtaker"] = 0,
    ["thom_ferrik_stormvermin_halberd-wh2_main_skv_queek_headtaker"] = 0,
    ["thom_ferrik_stormvermin_shield-wh2_main_skv_queek_headtaker"] = 0,
    ["thom_ferrik_forge_guard-wh2_main_skv_queek_headtaker"] = 1,
    ["thom_ferrik_gold_rats-wh2_main_skv_queek_headtaker"] = 1,
    ["thom_ferrik_ironbreaker-wh2_main_skv_queek_headtaker"] = 2,
    ["thom_vulkan_ashen_gaurd_shield-wh2_main_skv_queek_headtaker"] = 1,
    ["thom_vulkan_ashen_gaurd_halberd-wh2_main_skv_queek_headtaker"] = 1,
    ["thom_vulkan_stormvermin_shield-wh2_main_skv_queek_headtaker"] = 0,
    ["thom_vulkan_stormvermin_halberd-wh2_main_skv_queek_headtaker"] = 0,
    ["wh2_main_skv_art_plagueclaw_catapult-wh2_main_skv_lord_skrolk"] = 1,
    ["wh2_main_skv_inf_plague_monks-wh2_main_skv_lord_skrolk"] = 0,
    ["wh2_main_skv_inf_plague_monk_censer_bearer-wh2_main_skv_lord_skrolk"] = 0,
    ["wh2_dlc12_skv_inf_plague_monk_censer_bearer_ror_0-wh2_main_skv_lord_skrolk"] = 0,
    ["wh2_dlc12_skv_inf_ratling_gun_0-wh2_dlc12_skv_ikit_claw"] = 1,
    ["wh2_dlc12_skv_inf_ratling_gun_ror_0-wh2_dlc12_skv_ikit_claw"] = 2,
    ["wh2_main_skv_inf_warpfire_thrower-wh2_dlc12_skv_ikit_claw"] = 0,
    ["wh2_dlc12_skv_inf_warplock_jezzails_0-wh2_dlc12_skv_ikit_claw"] = 1,
    ["wh2_dlc12_skv_inf_warplock_jezzails_ror_0-wh2_dlc12_skv_ikit_claw"] = 2,
    ["wh2_dlc12_skv_inf_ratling_gun_ror_tech_lab_0-wh2_dlc12_skv_ikit_claw"] = 2,
    ["wh2_dlc12_skv_inf_warpfire_thrower_ror_tech_lab_0-wh2_dlc12_skv_ikit_claw"] = 1,
    ["wh2_dlc12_skv_art_warplock_jezzails_ror_tech_lab_0-wh2_dlc12_skv_ikit_claw"] = 2,
    ["thom_vulkan_warpfire_throwers-wh2_dlc12_skv_ikit_claw"] = 0,
    ["thom_vulkan_rattling-wh2_dlc12_skv_ikit_claw"] = 1,
    ["thom_vulkan_jezzail-wh2_dlc12_skv_ikit_claw"] = 1,
    ["thom_ferrik_jezzail-wh2_dlc12_skv_ikit_claw"] = 1,
    ["thom_ferrik_rattling-wh2_dlc12_skv_ikit_claw"] = 1,
    ["wh2_main_skv_inf_gutter_runner_slingers_0-wh2_dlc14_skv_deathmaster_snikch"] = 0,
    ["wh2_main_skv_inf_gutter_runner_slingers_1-wh2_dlc14_skv_deathmaster_snikch"] = 0,
    ["wh2_main_skv_inf_gutter_runners_0-wh2_dlc14_skv_deathmaster_snikch"] = 0,
    ["wh2_main_skv_inf_gutter_runners_1-wh2_dlc14_skv_deathmaster_snikch"] = 0,
    ["wh2_main_skv_inf_warpfire_thrower-Thom_vulkan_moltskin_searflesh"] = 0,
    ["wh2_dlc12_skv_inf_warpfire_thrower_ror_tech_lab_0-Thom_vulkan_moltskin_searflesh"] = 1,
    ["thom_vulkan_warpfire_throwers-Thom_vulkan_moltskin_searflesh"] = 0,
  --Vampire Coast
    ["wh2_dlc11_cst_inf_syreens-wh2_dlc11_cst_cylostra"] = 0,
    ["wh2_dlc11_cst_mon_mournguls_0-wh2_dlc11_cst_cylostra"] = 0,
    ["wh2_dlc11_cst_mon_mournguls_ror_0-wh2_dlc11_cst_cylostra"] = 1,
    ["wh2_dlc11_cst_mon_necrofex_colossus_0-wh2_dlc11_cst_noctilus"] = 2,
    ["wh2_dlc11_cst_mon_necrofex_colossus_ror_0-wh2_dlc11_cst_noctilus"] = 3,
  
    --Other LL
      -- dlc04_emp_volkmar
      -- 
      -- dlc06_dwf_belegar
      -- pro01_dwf_grombrindal
      -- dlc04_vmp_vlad_con_carstein
      --brt_louen_leoncouer
  
  }
  
  
local SRW_Lord_Group = {
  --vcounts
    ["pro02_vmp_isabella_von_carstein"] = "Isabella",
    ["wh2_dlc11_vmp_bloodline_von_carstein"] = "Carstain",
    ["wh2_dlc11_vmp_bloodline_blood_dragon"] = "Blood_Dragon",
    ["wh_dlc05_vmp_red_duke"] = "Blood_Dragon",
    ["wh2_dlc11_vmp_bloodline_strigoi"] = "Strigoi",
    ["dlc04_vmp_helman_ghorst"] = "Ghorst",
    ["vmp_bloodline_fallen_knight"] = "Mixu_Knight",
  --elves
    ["wh2_main_hef_tyrion"] = "Tyrion",
    ["wh2_dlc15_hef_archmage_beasts"] = "Tyrion",
    ["wh2_dlc15_hef_archmage_death"] = "Tyrion",
    ["wh2_dlc15_hef_archmage_fire"] = "Tyrion",
    ["wh2_dlc15_hef_archmage_heavens"] = "Tyrion",
    ["wh2_dlc15_hef_archmage_high"] = "Tyrion",
    ["wh2_dlc15_hef_archmage_life"] = "Tyrion",
    ["wh2_dlc15_hef_archmage_light"] = "Tyrion",
    ["wh2_dlc15_hef_archmage_metal"] = "Tyrion",
    ["wh2_dlc15_hef_archmage_shadows"] = "Tyrion",
    ["wh2_main_hef_prince"] = "Tyrion",
    ["wh2_main_hef_princess"] = "Tyrion",
    ["wh2_dlc10_hef_alarielle"] = "Alarielle",
    ["wh2_main_def_morathi"] = "Morathi",
    ["wh2_dlc14_def_high_beastmaster"] = "BeastMaster",
    ["wh2_main_lzd_saurus_old_blood"] = "Zaurus",
    ["wh2_main_lzd_kroq_gar"] = "Zaurus",
    ["wh2_dlc13_lzd_gor_rok"] = "Zaurus",
  --liz and skav
    ["wh2_dlc12_lzd_red_crested_skink_chief"] = "Skink",
    ["wh2_dlc12_lzd_red_crested_skink_chief_legendary"] = "Skink",
    ["wh2_dlc13_lzd_red_crested_skink_chief_horde"] = "Skink",
    ["wh2_dlc13_lzd_kroxigor_ancient"] = "Kroxi",
    ["wh2_dlc13_lzd_kroxigor_ancient_horde"] = "Kroxi",
    ["wh2_dlc12_lzd_tehenhauin"] = "Tehen",
    ["wh2_dlc09_skv_tretch_craventail"] = "Tretch",
    ["wh2_dlc12_skv_ikit_claw"] = "Ikit",
    ["wh2_dlc12_skv_warlock_master"] = "Warlock",
    ["Thom_vulkan_moltskin_searflesh"] = "Vulcan",
    ["thom_iron_mask"] = "Ferric",
  --vcoast
    ["wh2_dlc14_skv_master_assassin"] = "Assassin",
    ["wh2_dlc11_cst_admiral_fem"] = "Pirate",
    ["wh2_dlc11_cst_admiral_fem_death"] = "Pirate",
    ["wh2_dlc11_cst_admiral_fem_deep"] = "Pirate",
    ["wh2_dlc11_cst_admiral_tech_04"] = "Pirate",
    ["wh2_dlc11_cst_harkon"] = "Harkon",
    ["wh2_dlc11_cst_admiral"] = "Pirate",
    ["wh2_dlc11_cst_admiral_death"] = "Pirate",
    ["wh2_dlc11_cst_admiral_deep"] = "Pirate",
    ["wh2_dlc11_cst_admiral_tech_01"] = "Pirate",
    ["wh2_dlc11_cst_admiral_tech_02"] = "Pirate",
    ["wh2_dlc11_cst_admiral_tech_03"] = "Pirate",
    ["wh2_dlc11_cst_noctilus"] = "Noctil",
    ["wh2_dlc11_cst_aranessa"] = "Aranessa",
  --Old world
    ["wh2_dlc13_emp_cha_huntsmarshal_0"] = "Hunter",
    ["emp_balthasar_gelt"] = "Gelt",
    ["grn_goblin_great_shaman"] = "Goblin",
    ["dlc06_grn_night_goblin_warboss"] = "Goblin",
    ["dlc06_grn_skarsnik"] = "Goblin",
    ["dlc06_grn_wurrzag_da_great_prophet"] = "Wurzag",
    ["grn_azhag_the_slaughterer"] = "Azhag",
    ["wh_dlc08_nor_wulfrik"] = "Wulfrik",
    ["wh_dlc08_nor_throgg"] = "Throgg",
    ["ws_grn_tinitt_foureyes"] = "Forest",
    ["ws_grn_grak_beastbasha"] = "BeastBasha",
  }
  
  
local SRW_Lord_Skills_Cost = {
  --Vampire counts
    ["wh_main_vmp_mon_vargheists-Isabella"] = {"wh2_dlc11_skill_vmp_isabella_unique_3", 0},
    ["wh_main_vmp_mon_varghulf-Isabella"] = {"wh2_dlc11_skill_vmp_isabella_unique_4", 1},
    ["wh_dlc04_vmp_mon_devils_swartzhafen_0-Isabella"] = {"wh2_dlc11_skill_vmp_isabella_unique_3", 1},
    ["wh_main_vmp_mon_terrorgheist-Isabella"] = {"wh2_dlc11_skill_vmp_isabella_unique_5", 2},
    ["wh_dlc04_vmp_mon_devils_swartzhafen_0-Carstain"] = {"wh2_dlc11_skill_vmp_bloodline_von_carstein_unique_brooding_horrors", 2},
    ["wh_main_vmp_mon_vargheists-Carstain"] = {"wh2_dlc11_skill_vmp_bloodline_von_carstein_unique_brooding_horrors", 1},
    ["wh_main_vmp_cav_black_knights_0-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_doomrider", 0},
    ["wh_main_vmp_cav_black_knights_3-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_doomrider", 1},
    ["wh2_mixu_vmp_cav_black_knights_sword-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_doomrider", 0},
    ["wh2_mixu_vmp_cav_black_knights_lance-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_doomrider", 1},
    ["wh_dlc04_vmp_cav_vereks_reavers_0-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_doomrider", 2},
    ["wh_dlc04_vmp_inf_sternsmen_0-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_grave_sentinels", 2},
    ["wh_main_vmp_inf_grave_guard_0-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_grave_sentinels", 1},
    ["wh_main_vmp_inf_grave_guard_1-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_grave_sentinels", 1},
    ["wh_dlc02_vmp_cav_blood_knights_0-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_the_ordo_draconis", 3},
    ["wh2_mixu_vmp_ror_the_dreadwings-Blood_Dragon"] = {"wh2_dlc11_skill_vmp_bloodline_blood_dragon_unique_the_ordo_draconis", 4},
    ["wh_main_vmp_inf_crypt_ghouls-Strigoi"] = {"wh2_dlc11_skill_vmp_bloodline_strigoi_unique_grave_eaters", 0},
    ["mixu_vmp_inf_crypt_ghouls-Strigoi"] = {"wh2_dlc11_skill_vmp_bloodline_strigoi_unique_grave_eaters", 0},
    ["wh_dlc04_vmp_inf_feasters_in_the_dusk_0-Strigoi"] = {"wh2_dlc11_skill_vmp_bloodline_strigoi_unique_grave_eaters", 1},
    ["wh_main_vmp_mon_crypt_horrors-Strigoi"] = {"wh2_dlc11_skill_vmp_bloodline_strigoi_unique_monstrosities_of_morr", 0},
    ["wh_dlc04_vmp_veh_mortis_engine_0-Ghorst"] = {"wh_dlc04_skill_vmp_lord_unique_helman_ghorst_corpse_cart_boost", 0},
    ["wh_main_vmp_veh_black_coach-Ghorst"] = {"wh_dlc04_skill_vmp_lord_unique_helman_ghorst_corpse_cart_boost", 0},
    ["wh_dlc04_vmp_veh_claw_of_nagash_0-Ghorst"] = {"wh_dlc04_skill_vmp_lord_unique_helman_ghorst_corpse_cart_boost", 1},
    ["wh_main_vmp_cav_black_knights_0-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 0},
    ["wh_main_vmp_cav_black_knights_3-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 1},
    ["wh2_mixu_vmp_cav_black_knights_sword-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 0},
    ["wh2_mixu_vmp_cav_black_knights_lance-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 1},
    ["wh_dlc04_vmp_cav_vereks_reavers_0-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 2},
    ["wh_dlc02_vmp_cav_blood_knights_0-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 3},
    ["wh2_mixu_vmp_cav_knights_errant-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 1},
    ["wh2_mixu_vmp_cav_questing_knights-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 2},
    ["wh2_mixu_vmp_cav_knights_of_the_realm-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 2},
    ["wh2_mixu_vmp_ror_the_dreadwings-Mixu_Knight"] = {"mixu_vmp_bloodline_fallen_knight_special_2_brothers_in_death", 4},

  
  --Hight Elves
    ["wh2_main_hef_inf_phoenix_guard-Tyrion"] = {"wh2_main_skill_hef_dedication_asuryan", 2},
    ["wh2_main_hef_inf_phoenix_guard-Tyrion"] = {"wh2_main_skill_hef_dedication_asuryan", 2},
    ["wh2_main_hef_mon_phoenix_flamespyre-Tyrion"] = {"wh2_main_skill_hef_dedication_asuryan", 1},
    ["wh2_main_hef_mon_phoenix_frostheart-Tyrion"] = {"wh2_main_skill_hef_dedication_asuryan", 1},
    ["wh2_dlc15_hef_mon_arcane_phoenix_ror_0-Tyrion"] = {"wh2_main_skill_hef_dedication_asuryan", 3},
    ["wh2_dlc15_hef_mon_arcane_phoenix_0-Tyrion"] = {"wh2_main_skill_hef_dedication_asuryan", 2},  
    ["wh2_dlc10_hef_inf_keepers_of_the_flame_ror_0-Tyrion"] = {"wh2_main_skill_hef_dedication_asuryan", 3},
    ["wh2_main_hef_inf_swordmasters_of_hoeth_0-Tyrion"] = {"wh2_main_skill_hef_dedication_hoeth", 1},
    ["wh2_main_hef_cav_dragon_princes-Tyrion"] = {"wh2_main_skill_hef_dedication_vaul", 3},
    ["wh2_dlc10_hef_cav_the_fireborn_ror_0-Tyrion"] = {"wh2_main_skill_hef_dedication_vaul", 4},
    ["wh2_main_hef_inf_white_lions_of_chrace_0-Tyrion"] = {"wh2_main_skill_hef_dedication_kurnous", 0},
    ["wh2_dlc10_hef_inf_the_silverpelts_ror_0-Tyrion"] = {"wh2_main_skill_hef_dedication_kurnous", 1},
    ["wh2_dlc15_hef_mon_war_lions_of_chrace_ror_0-Tyrion"] = {"wh2_main_skill_hef_dedication_kurnous", 2},
    ["wh2_dlc15_hef_mon_war_lions_of_chrace_0-Tyrion"] = {"wh2_main_skill_hef_dedication_kurnous", 1},
    ["wh2_dlc15_hef_veh_lion_chariot_of_chrace_0-Tyrion"] = {"wh2_main_skill_hef_dedication_kurnous", 1},
    ["wh2_main_hef_mon_sun_dragon-Tyrion"] = {"wh2_main_skill_hef_dedication_addaioth", 2},
    ["wh2_main_hef_mon_moon_dragon-Tyrion"] = {"wh2_main_skill_hef_dedication_addaioth", 3},
    ["wh2_main_hef_mon_star_dragon-Tyrion"] = {"wh2_main_skill_hef_dedication_addaioth", 3},
    ["wh2_dlc15_hef_mon_black_dragon_imrik-Tyrion"] = {"wh2_main_skill_hef_dedication_addaioth", 4},
    ["wh2_dlc15_hef_mon_forest_dragon_0-Tyrion"] = {"wh2_main_skill_hef_dedication_addaioth", 3},
    ["wh2_dlc15_hef_mon_forest_dragon_imrik-Tyrion"] = {"wh2_main_skill_hef_dedication_addaioth", 3},
    ["wh2_dlc15_hef_mon_moon_dragon_imrik-Tyrion"] = {"wh2_main_skill_hef_dedication_addaioth", 4},
    ["wh2_dlc15_hef_mon_sun_dragon_imrik-Tyrion"] = {"wh2_main_skill_hef_dedication_addaioth", 4},
    ["wh2_main_hef_mon_star_dragon-Tyrion"] = {"wh2_main_skill_hef_dedication_addaioth", 3},
    ["wh2_main_hef_cav_ithilmar_chariot-Tyrion"] = {"wh2_main_skill_hef_dedication_hukon", 1},
    ["wh2_main_hef_cav_tiranoc_chariot-Tyrion"] = {"wh2_main_skill_hef_dedication_hukon", 1},
    ["wh2_dlc15_hef_veh_lion_chariot_of_chrace_0-Tyrion"] = {"wh2_main_skill_hef_dedication_hukon", 1},
    ["wh2_dlc10_hef_inf_the_scions_of_mathlann_ror_0-Tyrion"] = {"wh2_main_skill_hef_dedication_isha", 0},
    ["wh2_dlc15_hef_inf_silverin_guard_0-Tyrion"] = {"wh2_main_skill_hef_dedication_isha", 0},
    ["wh2_main_hef_inf_lothern_sea_guard_0-Tyrion"] = {"wh2_main_skill_hef_dedication_mathlann", 0},
    ["wh2_main_hef_inf_lothern_sea_guard_1-Tyrion"] = {"wh2_main_skill_hef_dedication_mathlann", 0},
    ["wh2_dlc10_hef_inf_the_storm_riders_ror_0-Tyrion"] = {"wh2_main_skill_hef_dedication_mathlann", 0},
    ["wh2_dlc15_hef_inf_archers_ror_0-Tyrion"] = {"wh2_main_skill_hef_dedication_isha", 0},
    ["wh2_dlc10_hef_mon_treekin_0-Alarielle"] = {"wh2_dlc10_skill_hef_alarielle_fire_and_blood_4", 0},
    ["wh2_dlc10_hef_mon_treeman_0-Alarielle"] = {"wh2_dlc10_skill_hef_alarielle_fire_and_blood_4", 2},
    
  --Dark Elves
    ["wh2_main_def_inf_shades_0-Morathi"] = {"wh2_main_skill_def_morathi_unique_3_3", 0},
    ["wh2_main_def_inf_shades_1-Morathi"] = {"wh2_main_skill_def_morathi_unique_3_3", 0},
    ["wh2_main_def_inf_shades_2-Morathi"] = {"wh2_main_skill_def_morathi_unique_3_3", 0},
    ["wh2_dlc10_def_cav_doomfire_warlocks_0-Morathi"] = {"wh2_main_skill_def_morathi_unique_3_3", 0},
    ["wh2_dlc10_def_cav_slaanesh_harvesters_ror_0-Morathi"] = {"wh2_main_skill_def_morathi_unique_3_3", 0},
  
    ["wh2_main_def_cav_cold_one_chariot-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_cold_ones", 0},
    ["wh2_dlc14_def_cav_scourgerunner_chariot_0-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_cold_ones", 1},
    ["wh2_main_def_cav_cold_one_knights_1-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_cold_ones", 1},
    ["wh2_main_def_cav_cold_one_knights_0-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_cold_ones", 0},
    ["wh2_dlc14_def_cav_scourgerunner_chariot_ror_0-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_cold_ones", 2},
    ["wh2_dlc10_def_cav_knights_of_the_ebon_claw_ror_0-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_cold_ones", 2},
    ["wh2_dlc14_def_mon_bloodwrack_medusa_0-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_medusas", 2},
    ["wh2_dlc14_def_veh_bloodwrack_shrine_0-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_medusas", 2},
    ["wh2_dlc14_def_mon_bloodwrack_medusa_ror_0-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_medusas", 3},
    ["wh2_main_def_mon_black_dragon-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_black_dragon", 3},
    ["wh2_main_def_mon_war_hydra-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_war_hydra_kharibdyss", 2},
    ["wh2_dlc10_def_mon_kharibdyss_0-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_war_hydra_kharibdyss", 2},
    ["wh2_dlc10_def_mon_chill_of_sontar_ror_0-BeastMaster"] = {"wh2_dlc14_skill_def_beastmaster_war_hydra_kharibdyss", 3},
  --LizardMen
    ["wh2_main_lzd_inf_saurus_spearmen_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 0},
    ["wh2_main_lzd_inf_saurus_warriors_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 0},
    ["wh2_main_lzd_inf_saurus_spearmen_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 0},
    ["wh2_main_lzd_inf_saurus_spearmen_blessed_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 0},
    ["wh2_main_lzd_inf_saurus_warriors_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 0},
    ["wh2_main_lzd_inf_saurus_warriors_blessed_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 0},
    ["wh2_main_lzd_inf_temple_guards-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 0},
    ["wh2_main_lzd_inf_temple_guards_blessed-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 1},
    ["wh2_dlc12_lzd_inf_saurus_warriors_ror_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 1},
    ["wh2_dlc12_lzd_inf_temple_guards_ror_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_quetzl", 2},
  
    ["wh2_main_lzd_cav_cold_one_spearmen_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 0},
    ["wh2_main_lzd_cav_cold_one_spearriders_blessed_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 0},
    ["wh2_main_lzd_cav_cold_ones_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 0},
    ["wh2_dlc12_lzd_cav_terradon_riders_1_tlaqua-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 0},
    ["wh2_main_lzd_cav_terradon_riders_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 0},
    ["wh2_main_lzd_cav_terradon_riders_blessed_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 0},
    ["wh2_dlc12_lzd_mon_salamander_pack_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 0},
    ["wh2_dlc13_lzd_mon_razordon_pack_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 0},
    ["wh2_main_lzd_mon_bastiladon_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 0},
    ["wh2_dlc12_lzd_mon_bastiladon_3-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_main_lzd_mon_bastiladon_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_main_lzd_mon_bastiladon_2-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_main_lzd_mon_bastiladon_blessed_2-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_dlc12_lzd_cav_ripperdactyl_riders_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_main_lzd_cav_horned_ones_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_main_lzd_mon_stegadon_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_dlc12_lzd_mon_ancient_salamander_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 2},
    ["wh2_main_lzd_mon_stegadon_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 2},
    ["wh2_main_lzd_mon_stegadon_blessed_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 2},
    ["wh2_main_lzd_mon_ancient_stegadon-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 3},
    ["wh2_dlc12_lzd_mon_ancient_stegadon_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 3},
    ["wh2_main_lzd_mon_carnosaur_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 3},
    ["wh2_main_lzd_mon_carnosaur_blessed_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 3},
    ["wh2_dlc13_lzd_mon_dread_saurian_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 4},
    ["wh2_dlc13_lzd_mon_dread_saurian_1-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 4},
    ["wh2_dlc12_lzd_cav_cold_one_spearriders_ror_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_dlc12_lzd_mon_salamander_pack_ror_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_dlc12_lzd_cav_terradon_riders_ror_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_dlc13_lzd_mon_razordon_pack_ror_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 1},
    ["wh2_dlc12_lzd_cav_ripperdactyl_riders_ror_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 2},
    ["wh2_dlc12_lzd_mon_ancient_stegadon_ror_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 4},
    ["wh2_dlc13_lzd_mon_dread_saurian_ror_0-Zaurus"] = {"wh2_main_skill_lzd_blessing_itzl", 5},
  
    ["wh2_main_lzd_cav_cold_one_spearmen_1-Skink"] = {"wh2_dlc12_skill_lzd_skink_chief_unique_3", 0},
    ["wh2_main_lzd_cav_cold_one_spearriders_blessed_0-Skink"] = {"wh2_dlc12_skill_lzd_skink_chief_unique_3", 0},
    ["wh2_main_lzd_cav_cold_ones_1-Skink"] = {"wh2_dlc12_skill_lzd_skink_chief_unique_3", 0},
    ["wh2_dlc12_lzd_cav_cold_one_spearriders_ror_0-Skink"] = {"wh2_dlc12_skill_lzd_skink_chief_unique_3", 1},
    ["wh2_main_lzd_cav_horned_ones_0-Skink"] = {"wh2_dlc12_skill_lzd_skink_chief_unique_3", 1},
    ["wh2_dlc12_lzd_cav_terradon_riders_1_tlaqua-Skink"] = {"wh2_dlc12_skill_lzd_skink_chief_unique_3", 0},
    ["wh2_main_lzd_cav_terradon_riders_1-Skink"] = {"wh2_dlc12_skill_lzd_skink_chief_unique_3", 0},
    ["wh2_main_lzd_cav_terradon_riders_blessed_1-Skink"] = {"wh2_dlc12_skill_lzd_skink_chief_unique_3", 0},
    ["wh2_dlc12_lzd_cav_terradon_riders_ror_0-Skink"] = {"wh2_dlc12_skill_lzd_skink_chief_unique_3", 1},
  
    ["wh2_main_lzd_mon_kroxigors-Kroxi"] = {"wh2_dlc13_skill_lzd_ancient_kroxigor_unique_3", 1, "wh2_dlc13_skill_lzd_ancient_kroxigor_unique_4"},
    ["wh2_main_lzd_mon_kroxigors_blessed-Kroxi"] = {"wh2_dlc13_skill_lzd_ancient_kroxigor_unique_3", 1, "wh2_dlc13_skill_lzd_ancient_kroxigor_unique_4"},
    ["wh2_dlc13_lzd_mon_sacred_kroxigors_0-Kroxi"] = {"wh2_dlc13_skill_lzd_ancient_kroxigor_unique_3", 1, "wh2_dlc13_skill_lzd_ancient_kroxigor_unique_4"},
    ["wh2_dlc13_lzd_mon_sacred_kroxigors_0_nakai-Kroxi"] = {"wh2_dlc13_skill_lzd_ancient_kroxigor_unique_3", 1, "wh2_dlc13_skill_lzd_ancient_kroxigor_unique_4"},
    ["wh2_dlc13_lzd_mon_sacred_kroxigors_ror_0-Kroxi"] = {"wh2_dlc13_skill_lzd_ancient_kroxigor_unique_3", 2, "wh2_dlc13_skill_lzd_ancient_kroxigor_unique_4"},
  
    ["wh2_main_lzd_mon_bastiladon_0-Tehen"] = {"wh2_dlc12_skill_lzd_tehenhauin_2", 0, "wh2_dlc12_skill_lzd_tehenhauin_6"},
    ["wh2_dlc12_lzd_mon_bastiladon_3-Tehen"] = {"wh2_dlc12_skill_lzd_tehenhauin_2", 0, "wh2_dlc12_skill_lzd_tehenhauin_6"},
    ["wh2_main_lzd_mon_bastiladon_1-Tehen"] = {"wh2_dlc12_skill_lzd_tehenhauin_2", 0, "wh2_dlc12_skill_lzd_tehenhauin_6"},
    ["wh2_main_lzd_mon_bastiladon_2-Tehen"] = {"wh2_dlc12_skill_lzd_tehenhauin_2", 0, "wh2_dlc12_skill_lzd_tehenhauin_6"},
    ["wh2_main_lzd_mon_bastiladon_blessed_2-Tehen"] = {"wh2_dlc12_skill_lzd_tehenhauin_2", 0, "wh2_dlc12_skill_lzd_tehenhauin_6"},
  --Skaven
    ["wh2_main_skv_inf_stormvermin_0-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 0},
    ["wh2_main_skv_inf_stormvermin_1-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 0},
    ["wh2_dlc12_skv_inf_stormvermin_ror_0-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 0},
    ["thom_ferrik_stormvermin_2h-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 0},
    ["thom_ferrik_stormvermin_halberd-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 0},
    ["thom_ferrik_stormvermin_shield-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 0},
    ["thom_ferrik_forge_guard-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 1},
    ["thom_ferrik_gold_rats-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 1},
    ["thom_ferrik_ironbreaker-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 2},
    ["thom_vulkan_ashen_gaurd_shield-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 1},
    ["thom_vulkan_ashen_gaurd_halberd-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 1},
    ["thom_vulkan_stormvermin_shield-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 0},
    ["thom_vulkan_stormvermin_halberd-Tretch"] = {"wh2_dlc09_skill_skv_lord_unique_tretch_craventail_tretchs_raiders", 0},

    ["wh2_dlc12_skv_veh_doom_flayer_0-Ikit"] = {"wh2_dlc12_skill_skv_ikit_unique_4", 0},
    ["wh2_dlc12_skv_veh_doom_flayer_ror_tech_lab_0-Ikit"] = {"wh2_dlc12_skill_skv_ikit_unique_4", 1},
    ["wh2_dlc12_skv_veh_doom_flayer_ror_0-Ikit"] = {"wh2_dlc12_skill_skv_ikit_unique_4", 1},
    ["wh2_main_skv_veh_doomwheel-Ikit"] = {"wh2_dlc12_skill_skv_ikit_unique_4", 1},
    ["wh2_dlc12_skv_veh_doomwheel_ror_0-Ikit"] = {"wh2_dlc12_skill_skv_ikit_unique_4", 2},
    ["wh2_dlc12_skv_veh_doomwheel_ror_tech_lab_0-Ikit"] = {"wh2_dlc12_skill_skv_ikit_unique_4", 2},
    ["wh2_main_skv_inf_warpfire_thrower-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 1},
    ["wh2_dlc12_skv_inf_warpfire_thrower_ror_tech_lab_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 2},
    ["wh2_dlc12_skv_inf_warplock_jezzails_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 2},
    ["wh2_dlc12_skv_inf_ratling_gun_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 2},
    ["wh2_dlc12_skv_inf_ratling_gun_ror_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 3},
    ["wh2_dlc12_skv_inf_warplock_jezzails_ror_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 3},
    ["wh2_dlc12_skv_inf_ratling_gun_ror_tech_lab_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 3},
    ["wh2_dlc12_skv_art_warplock_jezzails_ror_tech_lab_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 3},
    ["thom_vulkan_warpfire_throwers-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 1},
    ["thom_vulkan_rattling-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 2},
    ["thom_vulkan_jezzail-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 2},
    ["thom_ferrik_jezzail-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 2},
    ["thom_ferrik_rattling-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_3", 2},
    ["wh2_dlc12_skv_veh_doom_flayer_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_2", 1},
    ["wh2_dlc12_skv_veh_doom_flayer_ror_tech_lab_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_2", 2},
    ["wh2_dlc12_skv_veh_doom_flayer_ror_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_2", 2},
    ["wh2_main_skv_veh_doomwheel-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_2", 2},
    ["wh2_dlc12_skv_veh_doomwheel_ror_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_2", 3},
    ["wh2_dlc12_skv_veh_doomwheel_ror_tech_lab_0-Warlock"] = {"wh2_dlc12_skill_skv_engineer_unique_2", 3},
    ["wh2_main_skv_inf_gutter_runner_slingers_0-Assassin"] = {"wh2_dlc14_skill_skv_assassins_missile_damage", 0},
    ["wh2_main_skv_inf_gutter_runner_slingers_1-Assassin"] = {"wh2_dlc14_skill_skv_assassins_missile_damage", 0},
    ["wh2_main_skv_inf_gutter_runners_0-Assassin"] = {"wh2_dlc14_skill_skv_assassins_missile_damage", 0},
    ["wh2_main_skv_inf_gutter_runners_1-Assassin"] = {"wh2_dlc14_skill_skv_assassins_missile_damage", 0},
    ["wh2_main_skv_inf_stormvermin_0-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 0},
    ["wh2_main_skv_inf_stormvermin_1-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 0},
    ["wh2_dlc12_skv_inf_stormvermin_ror_0-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 0},
    ["thom_ferrik_stormvermin_2h-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 0},
    ["thom_ferrik_stormvermin_halberd-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 0},
    ["thom_ferrik_stormvermin_shield-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 0},
    ["thom_ferrik_forge_guard-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 1},
    ["thom_ferrik_gold_rats-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 1},
    ["thom_ferrik_ironbreaker-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 2},
    ["thom_vulkan_ashen_gaurd_shield-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 1},
    ["thom_vulkan_ashen_gaurd_halberd-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 1},
    ["thom_vulkan_stormvermin_shield-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 0},
    ["thom_vulkan_stormvermin_halberd-Ferric"] = {"thom_ferrik_ironmask_unique_raiding_party", 0},
  --VCoast
    ["wh2_dlc11_cst_inf_zombie_deckhands_mob_ror_0-Harkon"] = {"wh2_dlc11_skill_cst_luthor_unique_1", 0},
    ["wh2_dlc11_cst_inf_depth_guard_0-Harkon"] = {"wh2_dlc11_skill_cst_luthor_unique_1", 0},
    ["wh2_dlc11_cst_inf_depth_guard_1-Harkon"] = {"wh2_dlc11_skill_cst_luthor_unique_1", 0},
    ["wh2_dlc11_cst_inf_depth_guard_ror_0-Harkon"] = {"wh2_dlc11_skill_cst_luthor_unique_1", 1},
    ["wh2_dlc11_cst_inf_zombie_gunnery_mob_ror_0-Harkon"] = {"wh2_dlc11_skill_cst_luthor_unique_3", 0},
    ["wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0-Harkon"] = {"wh2_dlc11_skill_cst_luthor_unique_3", 0},
    ["wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_ror-Harkon"] = {"wh2_dlc11_skill_cst_luthor_unique_3", 1},
    ["wh2_dlc11_cst_art_carronade-Harkon"] = {"wh2_dlc11_skill_cst_lord_crime_3", 1},
    ["wh2_dlc11_cst_art_mortar-Harkon"] = {"wh2_dlc11_skill_cst_lord_crime_3", 1},
    ["wh2_dlc11_cst_art_queen_bess-Harkon"] = {"wh2_dlc11_skill_cst_lord_crime_3", 4},
    ["wh2_dlc11_cst_art_carronade-Pirate"] = {"wh2_dlc11_skill_cst_lord_crime_3", 2},
    ["wh2_dlc11_cst_art_mortar-Pirate"] = {"wh2_dlc11_skill_cst_lord_crime_3", 2},
    ["wh2_dlc11_cst_art_queen_bess-Pirate"] = {"wh2_dlc11_skill_cst_lord_crime_3", 5},
    ["wh2_dlc11_cst_mon_rotting_prometheans_0-Aranessa"] = {"wh2_dlc11_skill_cst_aranessa_unique_2", 0},
    ["wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0-Aranessa"] = {"wh2_dlc11_skill_cst_aranessa_unique_2", 0},
    ["wh2_dlc11_cst_mon_rotting_leviathan_0-Aranessa"] = {"wh2_dlc11_skill_cst_aranessa_unique_2", 1},
    ["wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_ror-Aranessa"] = {"wh2_dlc11_skill_cst_aranessa_unique_2", 1},
    ["wh2_dlc11_cst_art_carronade-Aranessa"] = {"wh2_dlc11_skill_cst_aranessa_unique_4", 1},
    ["wh2_dlc11_cst_art_mortar-Aranessa"] = {"wh2_dlc11_skill_cst_aranessa_unique_4", 1},
    ["wh2_dlc11_cst_art_queen_bess-Aranessa"] = {"wh2_dlc11_skill_cst_aranessa_unique_4", 4},
    ["wh2_dlc11_cst_inf_depth_guard_0-Noctil"] = {"wh2_dlc11_skill_cst_noctilus_unique_4", 0},
    ["wh2_dlc11_cst_inf_depth_guard_1-Noctil"] = {"wh2_dlc11_skill_cst_noctilus_unique_4", 0},
    ["wh2_dlc11_cst_inf_depth_guard_ror_0-Noctil"] = {"wh2_dlc11_skill_cst_noctilus_unique_4", 1},
    ["wh2_dlc11_cst_cav_deck_droppers_0-Noctil"] = {"wh2_dlc11_skill_cst_noctilus_unique_4", 0},
    ["wh2_dlc11_cst_cav_deck_droppers_1-Noctil"] = {"wh2_dlc11_skill_cst_noctilus_unique_4", 0},
    ["wh2_dlc11_cst_cav_deck_droppers_2-Noctil"] = {"wh2_dlc11_skill_cst_noctilus_unique_4", 0},
    ["wh2_dlc11_cst_cav_deck_droppers_ror_0-Noctil"] = {"wh2_dlc11_skill_cst_noctilus_unique_4", 0},
    ["wh2_dlc11_cst_mon_terrorgheist-Noctil"] = {"wh2_dlc11_skill_cst_noctilus_unique_4", 1},
  --Empire
    ["wh2_dlc13_emp_cav_outriders_ror_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh2_dlc13_emp_cav_pistoliers_ror_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_emp_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_emp_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh2_dlc13_emp_cav_outriders_1_imperial_supply-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_emp_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_dlc04_emp_inf_silver_bullets_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh2_dlc13_emp_inf_handgunners_ror_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh2_dlc13_emp_inf_handgunners_imperial_supply-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_dlc04_emp_inf_stirlands_revenge_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_mid_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_avr_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_rek_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_hoc_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_mbg_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_nod_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_osl_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_osm_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_str_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_tab_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_wis_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_sol_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_hun_inf_handgunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_mid_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_avr_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_rek_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_hoc_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_mbg_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_nod_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_osl_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_osm_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_str_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_tab_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_wis_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_sol_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_hun_cav_outriders_0-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_mid_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_avr_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_rek_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_hoc_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_mbg_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_nod_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_osl_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_osm_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_str_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_tab_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_wis_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_sol_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_main_hun_cav_outriders_1-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_jmw_emp_inf_death_heads_gunners-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_jmw_emp_inf_ironsides-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
    ["wh_jmw_emp_inf_ironsides_launchers-Gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_2", 0},
  
    ["wh_dlc04_emp_veh_templehof_luminark_0-emp_balthasar_gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_3", 2},
    ["wh_main_emp_veh_luminark_of_hysh_0-emp_balthasar_gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_3", 1},
    ["wh_main_emp_veh_steam_tank-emp_balthasar_gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_3", 3},
    ["wh2_dlc13_emp_veh_steam_tank_ror_0-emp_balthasar_gelt"] = {"wh_dlc08_skill_emp_lord_unique_balthasar_unique_3", 3},
  
    ["wh2_dlc13_emp_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh2_dlc13_emp_inf_huntsmen_0_imperial_supply-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh2_dlc13_emp_inf_huntsmen_ror_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 1},
    ["wh2_dlc13_emp_inf_archers_ror_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_mid_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_avr_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_rek_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_hoc_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_mbg_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_nod_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_osl_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_osm_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_str_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_tab_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_wis_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_sol_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
    ["wh_main_hun_inf_huntsmen_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_1", 0},
  
    ["wh_main_emp_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh2_dlc13_emp_inf_greatswords_imperial_supply-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh2_dlc13_emp_inf_greatswords_ror_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_mid_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_avr_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_rek_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_hoc_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_mbg_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_nod_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_osl_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_osm_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_str_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_tab_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_wis_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_sol_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_hun_inf_greatswords-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 1},
    ["wh_main_emp_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh2_dlc13_emp_inf_halberdiers_ror_0-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh2_dlc13_emp_inf_halberdiers_imperial_supply-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_mid_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_avr_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_rek_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_hoc_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_mbg_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_nod_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_osl_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_osm_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_str_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_tab_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_wis_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_sol_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
    ["wh_main_hun_inf_halberdiers-Hunter"] = {"wh2_dlc13_skill_emp_hunts_marshal_unique_0", 0},
  --Greenskin
    ["wh_main_grn_inf_night_goblins-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_ard_ladz", 0},
    ["wh_dlc06_grn_inf_da_warlords_boyz_0-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_ard_ladz", 0},
    ["wh_main_grn_inf_night_goblin_archers-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_ard_ladz", 0},
    ["wh_main_grn_inf_night_goblin_fanatics-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_ard_ladz", 0},
    ["wh_dlc06_grn_inf_da_rusty_arrers_0-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_ard_ladz", 0},
    ["wh_main_grn_inf_night_goblin_fanatics_1-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_ard_ladz", 0},
    ["wh_dlc06_grn_inf_da_eight_peaks_loonies_0-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_ard_ladz", 0},
    ["wh_dlc06_grn_cav_squig_hoppers_0-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_riderz", 0},
    ["wh_dlc06_grn_cav_durkits_squigs_0-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_riderz", 1},
    ["colossal_squig-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_riderz", 1},
    ["armored_colossal_squig-Goblin"] = {"wh_dlc06_skill_grn_lord_battle_riderz", 2},
    ["grn_savage_big_great-Azhag"] = {"wh_dlc08_skill_grn_azhag_unique_0", 0},
    ["wh_main_grn_cav_orc_boar_boy_big_uns-Azhag"] = {"wh_dlc08_skill_grn_azhag_unique_0", 0},
    ["wh_main_grn_cav_savage_orc_boar_boy_big_uns-Azhag"] = {"wh_dlc08_skill_grn_azhag_unique_0", 0},
    ["wh_main_grn_inf_savage_orc_big_uns-Azhag"] = {"wh_dlc08_skill_grn_azhag_unique_0", 0},
    ["wh_main_grn_inf_orc_big_uns-Azhag"] = {"wh_dlc08_skill_grn_azhag_unique_0", 0},
    ["wh_dlc06_grn_cav_broken_tusks_mob_0-Azhag"] = {"wh_dlc08_skill_grn_azhag_unique_0", 0},
    ["wh2_dlc15_grn_mon_river_trolls_0-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 0},
    ["wh2_dlc15_grn_mon_river_trolls_ror_0-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 0},
    ["wh2_dlc15_grn_mon_stone_trolls_0-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 0},
    ["wh_main_grn_mon_trolls-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 0},
    ["wh_main_grn_mon_giant-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 1},
    ["wh2_dlc15_grn_mon_rogue_idol_0-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 2},
    ["wh2_dlc15_grn_mon_rogue_idol_ror_0-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 3},
    ["wh_main_grn_mon_arachnarok_spider_0-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 2},
    ["wh_dlc15_grn_mon_arachnarok_spider_waaagh_0-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 2},
    ["wh_dlc06_grn_mon_venom_queen_0-Wurzag"] = {"wh2_dlc15_skill_unique_grn_wurrzag_colossal_warpaint", 3},
    ["wh_main_grn_mon_arachnarok_spider_0-Forest"] = {"ws_skill_tinitt_foureyes_ancient_behemoths", 2},
    ["wh_dlc15_grn_mon_arachnarok_spider_waaagh_0-Forest"] = {"ws_skill_tinitt_foureyes_ancient_behemoths", 2},
    ["wh_dlc06_grn_mon_venom_queen_0-Forest"] = {"ws_skill_tinitt_foureyes_ancient_behemoths", 3},
    ["wh_main_grn_inf_savage_orc_big_uns-BeastBasha"] = {"ws_skill_grak_beastbasha_rally_da_boyz", 0},
    ["wh_main_grn_cav_savage_orc_boar_boy_big_uns-BeastBasha"] = {"ws_skill_grak_beastbasha_rally_da_boyz", 0},
  --Norsca
    ["wh_dlc08_nor_mon_skinwolves_0-Wulfrik"] = {"wh_dlc08_skill_nor_wulfrik_battle_fervent_creatures", 0},
    ["wh_dlc08_nor_mon_skinwolves_1-Wulfrik"] = {"wh_dlc08_skill_nor_wulfrik_battle_fervent_creatures", 0},
    ["wh_pro04_nor_mon_skinwolves_ror_0-Wulfrik"] = {"wh_dlc08_skill_nor_wulfrik_battle_fervent_creatures", 0},
    ["wh_dlc08_nor_mon_fimir_0-Throgg"] = {"wh_dlc08_skill_nor_throgg_unique_king_of_trolls", 0},
    ["wh_dlc08_nor_mon_fimir_1-Throgg"] = {"wh_dlc08_skill_nor_throgg_unique_king_of_trolls", 0},
    ["wh_dlc08_nor_mon_frost_wyrm_0-Throgg"] = {"wh_dlc08_skill_nor_throgg_unique_king_of_trolls", 1},
    ["wh_pro04_nor_mon_fimir_ror_0-Throgg"] = {"wh_dlc08_skill_nor_throgg_battle_primordial_masters", 1},
    ["wh_dlc08_nor_mon_frost_wyrm_ror_0-Throgg"] = {"wh_dlc08_skill_nor_throgg_battle_primordial_masters", 2},
  
  }
  
  
local gates_superchain = {
  ["wh2_main_sch_fortress_gate_eagle"] = 1,
  ["wh2_main_sch_fortress_gate_griffon"] = 1,
  ["wh2_main_sch_fortress_gate_phoenix"] = 1,
  ["wh2_main_sch_fortress_gate_unicorn"] = 1,
  ["wh2_main_sch_empire_fort"] = 1,
}

local wood_elves_trees = {
  ["wh_dlc05_sch_wef_settlement_major"] = 1,
  ["wh_dlc05_sch_wef_settlement_major_coast"] = 1,
  ["wh_dlc05_sch_wef_settlement_major_main"] = 1,
  ["wh_dlc05_sch_wef_settlement_minor"] = 1,
  ["wh_dlc05_sch_wef_settlement_minor_coast"] = 1,
}
local SRW_Supply_Cost = {
  -- Empire
    --core
    ["wh2_dlc13_emp_inf_archers_0"] = 0,
    ["wh_dlc04_emp_inf_flagellants_0"] = 0,
    ["wh_dlc04_emp_inf_free_company_militia_0"] = 0,
    ["wh_main_emp_inf_crossbowmen"] = 0,
    ["wh_main_emp_inf_spearmen_0"] = 0,
    ["wh_main_emp_inf_spearmen_1"] = 0,
    ["wh_main_emp_inf_swordsmen"] = 0,
    ["wh2_dlc13_emp_cav_pistoliers_1_imperial_supply"] = 0,
    ["wh_main_emp_cav_pistoliers_1"] = 0,
  
    -- special
    ["wh2_dlc13_emp_cav_empire_knights_imperial_supply"] = 1,
    ["wh2_dlc13_emp_cav_outriders_1_imperial_supply"] = 1,
    ["wh2_dlc13_emp_inf_halberdiers_imperial_supply"] = 1,
    ["wh2_dlc13_emp_inf_handgunners_imperial_supply"] = 1,
    ["wh2_dlc13_emp_veh_war_wagon_0_imperial_supply"] = 1,
    ["wh2_dlc13_emp_inf_huntsmen_0_imperial_supply"] = 1,
    ["wh2_dlc13_emp_veh_war_wagon_0"] = 1,
    ["wh2_dlc13_emp_inf_huntsmen_0"] = 1,
    ["wh_main_emp_inf_halberdiers"] = 1,
    ["wh_main_emp_inf_handgunners"] = 1,
    ["wh_main_emp_cav_empire_knights"] = 1,
    ["wh_main_emp_cav_outriders_0"] = 1,
    ["wh_main_emp_cav_outriders_1"] = 1,
    -- rare
    ["wh_main_emp_inf_greatswords"] = 2,
    ["wh2_dlc13_emp_inf_greatswords_imperial_supply"] = 2,
    ["wh2_dlc13_emp_cav_reiksguard_imperial_supply"] = 2,
    ["wh2_dlc13_emp_cav_knights_blazing_sun_0_imperial_supply"] = 2,
    ["wh_main_emp_cav_reiksguard"] = 2,
    ["wh_dlc04_emp_cav_knights_blazing_sun_0"] = 2,
    ["wh_main_emp_art_mortar"] = 3,
    ["wh2_dlc13_emp_veh_luminark_of_hysh_0_imperial_supply"] = 3,
    ["wh2_dlc13_emp_veh_war_wagon_1_imperial_supply"] = 3,
    ["wh2_dlc13_emp_veh_war_wagon_1"] = 3,
    ["wh2_dlc13_emp_art_great_cannon_imperial_supply"] = 3,
    ["wh2_dlc13_emp_art_helblaster_volley_gun_imperial_supply"] = 3,
    ["wh2_dlc13_emp_art_helstorm_rocket_battery_imperial_supply"] = 3,
    ["wh_main_emp_art_great_cannon"] = 3,
    ["wh_main_emp_art_helblaster_volley_gun"] = 3,
    ["wh_main_emp_art_helstorm_rocket_battery"] = 3,
    ["wh_main_emp_veh_luminark_of_hysh_0"] = 3,
    -- elite
    ["wh2_dlc13_emp_cav_demigryph_knights_0_imperial_supply"] = 4,
    ["wh2_dlc13_emp_cav_demigryph_knights_1_imperial_supply"] = 4,
    ["wh2_dlc13_emp_veh_steam_tank_imperial_supply"] = 4,
    ["wh_main_emp_cav_demigryph_knights_0"] = 4,
    ["wh_main_emp_cav_demigryph_knights_1"] = 4,
    ["wh_main_emp_veh_steam_tank"] = 4,
    --emp special
    ["wh2_dlc13_huntmarshall_veh_obsinite_gyrocopter_0"] = 2,
    ["wh2_dlc13_emp_inf_spearmen_ror_0"] = 1,
    ["wh2_dlc13_emp_inf_swordsmen_ror_0"] = 1,
    ["wh2_dlc13_emp_cav_outriders_ror_0"] = 1,
    ["wh2_dlc13_emp_cav_pistoliers_ror_0"] = 1,
    ["wh2_dlc13_emp_inf_crossbowmen_ror_0"] = 1,
    ["wh2_dlc13_emp_inf_halberdiers_ror_0"] = 1,
    ["wh2_dlc13_emp_inf_handgunners_ror_0"] = 1,
    ["wh2_dlc13_emp_cav_empire_knights_ror_0"] = 2,
    ["wh2_dlc13_emp_cav_empire_knights_ror_1"] = 2,
    ["wh2_dlc13_emp_cav_empire_knights_ror_2"] = 2,
    ["wh2_dlc13_emp_inf_greatswords_ror_0"] = 2,
    ["wh2_dlc13_emp_art_mortar_ror_0"] = 3,
    ["wh2_dlc13_emp_veh_steam_tank_ror_0"] = 4,
  
    -- ROR
    ["wh2_dlc13_emp_inf_huntsmen_ror_0"] = 2,
    ["wh2_dlc13_emp_inf_archers_ror_0"] = 1,
    ["wh_dlc04_emp_inf_sigmars_sons_0"] = 1,
    ["wh_dlc04_emp_inf_stirlands_revenge_0"] = 1,
    ["wh_dlc04_emp_inf_tattersouls_0"] = 1,
    ["wh_dlc04_emp_inf_silver_bullets_0"] = 2,
    ["wh_dlc04_emp_cav_zintlers_reiksguard_0"] = 3,
    ["wh2_dlc13_emp_veh_war_wagon_ror_0"] = 4,
    ["wh_dlc04_emp_art_hammer_of_the_witches_0"] = 4,
    ["wh_dlc04_emp_art_sunmaker_0"] = 4,
    ["wh_dlc04_emp_veh_templehof_luminark_0"] = 4,
    ["wh_dlc04_emp_cav_royal_altdorf_gryphites_0"] = 5,
  
  -- Swords of Empire
    ["wh_main_mid_inf_spearmen_0"] = 0,
    ["wh_main_avr_inf_spearmen_0"] = 0,
    ["wh_main_rek_inf_spearmen_0"] = 0,
    ["wh_main_hoc_inf_spearmen_0"] = 0,
    ["wh_main_mbg_inf_spearmen_0"] = 0,
    ["wh_main_nod_inf_spearmen_0"] = 0,
    ["wh_main_osl_inf_spearmen_0"] = 0,
    ["wh_main_osm_inf_spearmen_0"] = 0,
    ["wh_main_str_inf_spearmen_0"] = 0,
    ["wh_main_tab_inf_spearmen_0"] = 0,
    ["wh_main_wis_inf_spearmen_0"] = 0,
    ["wh_main_sol_inf_spearmen_0"] = 0,
    ["wh_main_hun_inf_spearmen_0"] = 0,
    ["wh_main_mid_inf_archers_0"] = 0,
    ["wh_main_avr_inf_archers_0"] = 0,
    ["wh_main_rek_inf_archers_0"] = 0,
    ["wh_main_hoc_inf_archers_0"] = 0,
    ["wh_main_mbg_inf_archers_0"] = 0,
    ["wh_main_nod_inf_archers_0"] = 0,
    ["wh_main_osl_inf_archers_0"] = 0,
    ["wh_main_osm_inf_archers_0"] = 0,
    ["wh_main_str_inf_archers_0"] = 0,
    ["wh_main_tab_inf_archers_0"] = 0,
    ["wh_main_wis_inf_archers_0"] = 0,
    ["wh_main_sol_inf_archers_0"] = 0,
    ["wh_main_hun_inf_archers_0"] = 0,
    ["wh_main_mid_inf_spearmen_1"] = 0,
    ["wh_main_avr_inf_spearmen_1"] = 0,
    ["wh_main_rek_inf_spearmen_1"] = 0,
    ["wh_main_hoc_inf_spearmen_1"] = 0,
    ["wh_main_mbg_inf_spearmen_1"] = 0,
    ["wh_main_nod_inf_spearmen_1"] = 0,
    ["wh_main_osl_inf_spearmen_1"] = 0,
    ["wh_main_osm_inf_spearmen_1"] = 0,
    ["wh_main_str_inf_spearmen_1"] = 0,
    ["wh_main_tab_inf_spearmen_1"] = 0,
    ["wh_main_wis_inf_spearmen_1"] = 0,
    ["wh_main_sol_inf_spearmen_1"] = 0,
    ["wh_main_hun_inf_spearmen_1"] = 0,
    ["wh_main_mid_inf_swordsmen"] = 0,
    ["wh_main_avr_inf_swordsmen"] = 0,
    ["wh_main_rek_inf_swordsmen"] = 0,
    ["wh_main_hoc_inf_swordsmen"] = 0,
    ["wh_main_mbg_inf_swordsmen"] = 0,
    ["wh_main_nod_inf_swordsmen"] = 0,
    ["wh_main_osl_inf_swordsmen"] = 0,
    ["wh_main_osm_inf_swordsmen"] = 0,
    ["wh_main_str_inf_swordsmen"] = 0,
    ["wh_main_tab_inf_swordsmen"] = 0,
    ["wh_main_wis_inf_swordsmen"] = 0,
    ["wh_main_sol_inf_swordsmen"] = 0,
    ["wh_main_hun_inf_swordsmen"] = 0,
    ["wh_main_mid_inf_free_company_militia_0"] = 0,
    ["wh_main_avr_inf_free_company_militia_0"] = 0,
    ["wh_main_rek_inf_free_company_militia_0"] = 0,
    ["wh_main_hoc_inf_free_company_militia_0"] = 0,
    ["wh_main_mbg_inf_free_company_militia_0"] = 0,
    ["wh_main_nod_inf_free_company_militia_0"] = 0,
    ["wh_main_osl_inf_free_company_militia_0"] = 0,
    ["wh_main_osm_inf_free_company_militia_0"] = 0,
    ["wh_main_str_inf_free_company_militia_0"] = 0,
    ["wh_main_tab_inf_free_company_militia_0"] = 0,
    ["wh_main_wis_inf_free_company_militia_0"] = 0,
    ["wh_main_sol_inf_free_company_militia_0"] = 0,
    ["wh_main_hun_inf_free_company_militia_0"] = 0,
    ["wh_main_mid_inf_crossbowmen"] = 0,
    ["wh_main_mid_cav_pistoliers_1"] = 0,
    ["wh_main_avr_inf_crossbowmen"] = 0,
    ["wh_main_avr_cav_pistoliers_1"] = 0,
    ["wh_main_rek_inf_crossbowmen"] = 0,
    ["wh_main_rek_cav_pistoliers_1"] = 0,
    ["wh_main_hoc_inf_crossbowmen"] = 0,
    ["wh_main_hoc_cav_pistoliers_1"] = 0,
    ["wh_main_mbg_inf_crossbowmen"] = 0,
    ["wh_main_mbg_cav_pistoliers_1"] = 0,
    ["wh_main_nod_inf_crossbowmen"] = 0,
    ["wh_main_nod_cav_pistoliers_1"] = 0,
    ["wh_main_osl_inf_crossbowmen"] = 0,
    ["wh_main_osl_cav_pistoliers_1"] = 0,
    ["wh_main_osm_inf_crossbowmen"] = 0,
    ["wh_main_osm_cav_pistoliers_1"] = 0,
    ["wh_main_str_inf_crossbowmen"] = 0,
    ["wh_main_str_cav_pistoliers_1"] = 0,
    ["wh_main_tab_inf_crossbowmen"] = 0,
    ["wh_main_tab_cav_pistoliers_1"] = 0,
    ["wh_main_wis_inf_crossbowmen"] = 0,
    ["wh_main_wis_cav_pistoliers_1"] = 0,
    ["wh_main_sol_inf_crossbowmen"] = 0,
    ["wh_main_sol_cav_pistoliers_1"] = 0,
    ["wh_main_hun_inf_crossbowmen"] = 0,
    ["wh_main_hun_cav_pistoliers_1"] = 0,
    ["wh_main_mid_inf_handgunners"] = 1,
    ["wh_main_avr_inf_handgunners"] = 1,
    ["wh_main_rek_inf_handgunners"] = 1,
    ["wh_main_hoc_inf_handgunners"] = 1,
    ["wh_main_mbg_inf_handgunners"] = 1,
    ["wh_main_nod_inf_handgunners"] = 1,
    ["wh_main_osl_inf_handgunners"] = 1,
    ["wh_main_osm_inf_handgunners"] = 1,
    ["wh_main_str_inf_handgunners"] = 1,
    ["wh_main_tab_inf_handgunners"] = 1,
    ["wh_main_wis_inf_handgunners"] = 1,
    ["wh_main_sol_inf_handgunners"] = 1,
    ["wh_main_hun_inf_handgunners"] = 1,
    ["wh_main_mid_inf_halberdiers"] = 1,
    ["wh_main_avr_inf_halberdiers"] = 1,
    ["wh_main_rek_inf_halberdiers"] = 1,
    ["wh_main_hoc_inf_halberdiers"] = 1,
    ["wh_main_mbg_inf_halberdiers"] = 1,
    ["wh_main_nod_inf_halberdiers"] = 1,
    ["wh_main_osl_inf_halberdiers"] = 1,
    ["wh_main_osm_inf_halberdiers"] = 1,
    ["wh_main_str_inf_halberdiers"] = 1,
    ["wh_main_tab_inf_halberdiers"] = 1,
    ["wh_main_wis_inf_halberdiers"] = 1,
    ["wh_main_sol_inf_halberdiers"] = 1,
    ["wh_main_hun_inf_halberdiers"] = 1,
    ["wh_main_mid_inf_huntsmen_0"] = 1,
    ["wh_main_avr_inf_huntsmen_0"] = 1,
    ["wh_main_rek_inf_huntsmen_0"] = 1,
    ["wh_main_hoc_inf_huntsmen_0"] = 1,
    ["wh_main_mbg_inf_huntsmen_0"] = 1,
    ["wh_main_nod_inf_huntsmen_0"] = 1,
    ["wh_main_osl_inf_huntsmen_0"] = 1,
    ["wh_main_osm_inf_huntsmen_0"] = 1,
    ["wh_main_str_inf_huntsmen_0"] = 1,
    ["wh_main_tab_inf_huntsmen_0"] = 1,
    ["wh_main_wis_inf_huntsmen_0"] = 1,
    ["wh_main_sol_inf_huntsmen_0"] = 1,
    ["wh_main_hun_inf_huntsmen_0"] = 1,
    ["wh_main_mid_art_mortar"] = 3,
    ["wh_main_avr_art_mortar"] = 3,
    ["wh_main_rek_art_mortar"] = 3,
    ["wh_main_hoc_art_mortar"] = 3,
    ["wh_main_mbg_art_mortar"] = 3,
    ["wh_main_nod_art_mortar"] = 3,
    ["wh_main_osl_art_mortar"] = 3,
    ["wh_main_osm_art_mortar"] = 3,
    ["wh_main_str_art_mortar"] = 3,
    ["wh_main_tab_art_mortar"] = 3,
    ["wh_main_wis_art_mortar"] = 3,
    ["wh_main_sol_art_mortar"] = 3,
    ["wh_main_hun_art_mortar"] = 3,
    ["wh_main_mid_cav_outriders_0"] = 1,
    ["wh_main_avr_cav_outriders_0"] = 1,
    ["wh_main_rek_cav_outriders_0"] = 1,
    ["wh_main_hoc_cav_outriders_0"] = 1,
    ["wh_main_mbg_cav_outriders_0"] = 1,
    ["wh_main_nod_cav_outriders_0"] = 1,
    ["wh_main_osl_cav_outriders_0"] = 1,
    ["wh_main_osm_cav_outriders_0"] = 1,
    ["wh_main_str_cav_outriders_0"] = 1,
    ["wh_main_tab_cav_outriders_0"] = 1,
    ["wh_main_wis_cav_outriders_0"] = 1,
    ["wh_main_sol_cav_outriders_0"] = 1,
    ["wh_main_hun_cav_outriders_0"] = 1,
    ["wh_main_mid_cav_outriders_1"] = 1,
    ["wh_main_avr_cav_outriders_1"] = 1,
    ["wh_main_rek_cav_outriders_1"] = 1,
    ["wh_main_hoc_cav_outriders_1"] = 1,
    ["wh_main_mbg_cav_outriders_1"] = 1,
    ["wh_main_nod_cav_outriders_1"] = 1,
    ["wh_main_osl_cav_outriders_1"] = 1,
    ["wh_main_osm_cav_outriders_1"] = 1,
    ["wh_main_str_cav_outriders_1"] = 1,
    ["wh_main_tab_cav_outriders_1"] = 1,
    ["wh_main_wis_cav_outriders_1"] = 1,
    ["wh_main_sol_cav_outriders_1"] = 1,
    ["wh_main_hun_cav_outriders_1"] = 1,
    ["wh_main_mid_art_great_cannon"] = 3,
    ["wh_main_avr_art_great_cannon"] = 3,
    ["wh_main_rek_art_great_cannon"] = 3,
    ["wh_main_hoc_art_great_cannon"] = 3,
    ["wh_main_mbg_art_great_cannon"] = 3,
    ["wh_main_nod_art_great_cannon"] = 3,
    ["wh_main_osl_art_great_cannon"] = 3,
    ["wh_main_osm_art_great_cannon"] = 3,
    ["wh_main_str_art_great_cannon"] = 3,
    ["wh_main_tab_art_great_cannon"] = 3,
    ["wh_main_wis_art_great_cannon"] = 3,
    ["wh_main_sol_art_great_cannon"] = 3,
    ["wh_main_hun_art_great_cannon"] = 3,
    ["wh_main_mid_veh_war_wagon_0"] = 1,
    ["wh_main_avr_veh_war_wagon_0"] = 1,
    ["wh_main_rek_veh_war_wagon_0"] = 1,
    ["wh_main_hoc_veh_war_wagon_0"] = 1,
    ["wh_main_mbg_veh_war_wagon_0"] = 1,
    ["wh_main_nod_veh_war_wagon_0"] = 1,
    ["wh_main_osl_veh_war_wagon_0"] = 1,
    ["wh_main_osm_veh_war_wagon_0"] = 1,
    ["wh_main_str_veh_war_wagon_0"] = 1,
    ["wh_main_tab_veh_war_wagon_0"] = 1,
    ["wh_main_wis_veh_war_wagon_0"] = 1,
    ["wh_main_sol_veh_war_wagon_0"] = 1,
    ["wh_main_hun_veh_war_wagon_0"] = 1,
    ["wh_main_mid_cav_empire_knights"] = 1,
    ["wh_main_avr_cav_empire_knights"] = 1,
    ["wh_main_rek_cav_empire_knights"] = 1,
    ["wh_main_hoc_cav_empire_knights"] = 1,
    ["wh_main_mbg_cav_empire_knights"] = 1,
    ["wh_main_nod_cav_empire_knights"] = 1,
    ["wh_main_osl_cav_empire_knights"] = 1,
    ["wh_main_osm_cav_empire_knights"] = 1,
    ["wh_main_str_cav_empire_knights"] = 1,
    ["wh_main_tab_cav_empire_knights"] = 1,
    ["wh_main_wis_cav_empire_knights"] = 1,
    ["wh_main_sol_cav_empire_knights"] = 1,
    ["wh_main_hun_cav_empire_knights"] = 1,
    ["wh_main_mid_inf_greatswords"] = 2,
    ["wh_main_avr_inf_greatswords"] = 2,
    ["wh_main_rek_inf_greatswords"] = 2,
    ["wh_main_hoc_inf_greatswords"] = 2,
    ["wh_main_mbg_inf_greatswords"] = 2,
    ["wh_main_nod_inf_greatswords"] = 2,
    ["wh_main_osl_inf_greatswords"] = 2,
    ["wh_main_osm_inf_greatswords"] = 2,
    ["wh_main_str_inf_greatswords"] = 2,
    ["wh_main_tab_inf_greatswords"] = 2,
    ["wh_main_wis_inf_greatswords"] = 2,
    ["wh_main_sol_inf_greatswords"] = 2,
    ["wh_main_hun_inf_greatswords"] = 2,
    ["wh_main_mid_veh_war_wagon_1"] = 3,
    ["wh_main_avr_veh_war_wagon_1"] = 3,
    ["wh_main_rek_veh_war_wagon_1"] = 3,
    ["wh_main_hoc_veh_war_wagon_1"] = 3,
    ["wh_main_mbg_veh_war_wagon_1"] = 3,
    ["wh_main_nod_veh_war_wagon_1"] = 3,
    ["wh_main_osl_veh_war_wagon_1"] = 3,
    ["wh_main_osm_veh_war_wagon_1"] = 3,
    ["wh_main_str_veh_war_wagon_1"] = 3,
    ["wh_main_tab_veh_war_wagon_1"] = 3,
    ["wh_main_wis_veh_war_wagon_1"] = 3,
    ["wh_main_sol_veh_war_wagon_1"] = 3,
    ["wh_main_hun_veh_war_wagon_1"] = 3,
    ["wh_main_mid_art_helblaster_volley_gun"] = 3,
    ["wh_main_mid_art_helstorm_rocket_battery"] = 3,
    ["wh_main_avr_art_helblaster_volley_gun"] = 3,
    ["wh_main_avr_art_helstorm_rocket_battery"] = 3,
    ["wh_main_rek_art_helblaster_volley_gun"] = 3,
    ["wh_main_rek_art_helstorm_rocket_battery"] = 3,
    ["wh_main_hoc_art_helblaster_volley_gun"] = 3,
    ["wh_main_hoc_art_helstorm_rocket_battery"] = 3,
    ["wh_main_mbg_art_helblaster_volley_gun"] = 3,
    ["wh_main_mbg_art_helstorm_rocket_battery"] = 3,
    ["wh_main_nod_art_helblaster_volley_gun"] = 3,
    ["wh_main_nod_art_helstorm_rocket_battery"] = 3,
    ["wh_main_osl_art_helblaster_volley_gun"] = 3,
    ["wh_main_osl_art_helstorm_rocket_battery"] = 3,
    ["wh_main_osm_art_helblaster_volley_gun"] = 3,
    ["wh_main_osm_art_helstorm_rocket_battery"] = 3,
    ["wh_main_str_art_helblaster_volley_gun"] = 3,
    ["wh_main_str_art_helstorm_rocket_battery"] = 3,
    ["wh_main_tab_art_helblaster_volley_gun"] = 3,
    ["wh_main_tab_art_helstorm_rocket_battery"] = 3,
    ["wh_main_wis_art_helblaster_volley_gun"] = 3,
    ["wh_main_wis_art_helstorm_rocket_battery"] = 3,
    ["wh_main_sol_art_helblaster_volley_gun"] = 3,
    ["wh_main_sol_art_helstorm_rocket_battery"] = 3,
    ["wh_main_hun_art_helblaster_volley_gun"] = 3,
    ["wh_main_hun_art_helstorm_rocket_battery"] = 3,
    ["wh_main_mid_cav_demigryph_knights_0"] = 4,
    ["wh_main_avr_cav_demigryph_knights_0"] = 4,
    ["wh_main_rek_cav_demigryph_knights_0"] = 4,
    ["wh_main_hoc_cav_demigryph_knights_0"] = 4,
    ["wh_main_mbg_cav_demigryph_knights_0"] = 4,
    ["wh_main_nod_cav_demigryph_knights_0"] = 4,
    ["wh_main_osl_cav_demigryph_knights_0"] = 4,
    ["wh_main_osm_cav_demigryph_knights_0"] = 4,
    ["wh_main_str_cav_demigryph_knights_0"] = 4,
    ["wh_main_tab_cav_demigryph_knights_0"] = 4,
    ["wh_main_wis_cav_demigryph_knights_0"] = 4,
    ["wh_main_sol_cav_demigryph_knights_0"] = 4,
    ["wh_main_hun_cav_demigryph_knights_0"] = 4,
    ["wh_main_mid_cav_demigryph_knights_1"] = 4,
    ["wh_main_avr_cav_demigryph_knights_1"] = 4,
    ["wh_main_rek_cav_demigryph_knights_1"] = 4,
    ["wh_main_hoc_cav_demigryph_knights_1"] = 4,
    ["wh_main_mbg_cav_demigryph_knights_1"] = 4,
    ["wh_main_nod_cav_demigryph_knights_1"] = 4,
    ["wh_main_osl_cav_demigryph_knights_1"] = 4,
    ["wh_main_osm_cav_demigryph_knights_1"] = 4,
    ["wh_main_str_cav_demigryph_knights_1"] = 4,
    ["wh_main_tab_cav_demigryph_knights_1"] = 4,
    ["wh_main_wis_cav_demigryph_knights_1"] = 4,
    ["wh_main_sol_cav_demigryph_knights_1"] = 4,
    ["wh_main_hun_cav_demigryph_knights_1"] = 4,
    --special
    ["wh_jmw_emp_inf_winterbite_brigade"] = 0,
    ["wh_jmw_emp_inf_winterbite_brigade_spear"] = 0,
    ["wh_jmw_emp_inf_winterbite_brigade_great"] = 2,
    ["wh_jmw_emp_inf_death_heads"] = 0,
    ["wh_jmw_emp_inf_death_heads_spear"] = 0,
    ["wh_jmw_emp_inf_death_heads_crossbow"] = 0,
    ["wh_jmw_emp_inf_death_heads_gunners"] = 1,
    ["wh_jmw_emp_inf_sons_ulric"] = 0,
    ["wh_jmw_emp_inf_hunting_hounds_armoured"] = 0,
    ["wh_jmw_emp_inf_childrenullric_armoured"] = 2,
    --foreign
    ["wh_jmw_emp_cav_norse_expatriate_hosemen"] = 0,
    ["wh_jmw_emp_cav_norse_expatriate_hunters"] = 0,
    ["wh_jmw_emp_inf_norse_expatriate_berserkers"] = 1,
    ["wh_jmw_emp_inf_norse_expatriate_huscarls"] = 0,
    ["wh_jmw_emp_inf_norse_expatriate_huscarls_great"] = 1,
    ["wh_jmw_emp_inf_norse_expatriate_huscarls_spears"] = 0,
    ["wh_jmw_emp_art_cannon_dwf"] = 3,
    ["wh_jmw_emp_art_flame_cannon"] = 3,
    ["wh_jmw_emp_inf_dwarf_warrior_0"] = 1,
    ["wh_jmw_emp_inf_dwarf_warrior_1"] = 1,
    ["wh_jmw_emp_inf_miners_0"] = 0,
    ["wh_jmw_emp_inf_miners_1"] = 0,
    ["wh_jmw_emp_inf_quarrellers_0"] = 1,
    ["wh_jmw_emp_inf_quarrellers_1"] = 1,
    ["wh_jmw_emp_inf_thunderers_0"] = 1,
    ["wh_xou_emp_hef_inf_spearmen_0"] = 1,
    ["wh_xou_emp_hef_inf_archers_0"] = 1,
    ["wh_xou_emp_hef_cav_ellyrian_reavers_0"] = 1,
    ["wh_xou_emp_hef_inf_lothern_sea_guard_0"] = 1,
    ["wh_xou_emp_hef_art_eagle_claw_bolt_thrower"] = 2,
    -- uniq
    ["wh_jmw_emp_inf_rackspire_dead"] = 0,
    ["wh_jmw_emp_inf_mountainguard"] = 0,
    ["wh_jmw_emp_inf_mountainguard_spear"] = 0,
    ["wh_jmw_emp_inf_warriors_ulric"] = 0,
    ["wh_jmw_emp_inf_hunting_hounds"] = 0,
    ["wh_jmw_emp_inf_archers"] = 0,
    ["drakwald_crimsons"] = 1,
    ["wh_jmw_emp_inf_blackclad_sewerjacks"] = 0,
    ["wh_jmw_emp_inf_deepwatch"] = 0,
    ["wh_jmw_emp_inf_iron_company_swords"] = 0,
    ["wh_jmw_emp_inf_iron_company_spears"] = 0,
    ["wh_jmw_emp_inf_mountainguard_crossbow"] = 0,
    ["wh_jmw_emp_inf_winterbite_brigade_crossbow"] = 0,
    ["wh_jmw_emp_inf_mountainguard_gunners"] = 1,
    ["wh_jmw_emp_inf_cultists_of_morr"] = 1,
    ["wh_jmw_emp_inf_cultists_taal"] = 1,
    ["wh_jmw_emp_inf_cultists_manann"] = 1,
    ["wh_jmw_emp_inf_kin_taal"] = 1,
    ["wh_jmw_emp_inf_wolfkin"] = 1,
    ["wh_jmw_emp_inf_huntsmen"] = 1,
    ["wh_jmw_emp_inf_grudgebringer_crossbow"] = 1,
    ["drakwald_surefires"] = 1,
    ["wh_jmw_emp_inf_armbrustschutzen"] = 1,
    ["wh_jmw_emp_inf_mountainguard_halberdiers"] = 1,
    ["drakwald_gruncaps"] = 1,
    ["wh_jmw_emp_inf_winterbite_brigade_halberdiers"] = 1,
    ["wh_jmw_emp_inf_iron_company_halberdiers"] = 1,
    ["wh_jmw_emp_inf_jaegarkorps"] = 1,
    ["wh_jmw_emp_inf_cursed_company"] = 1,
    ["wh_jmw_emp_inf_death_heads_halberdiers"] = 1,
    ["wh_jmw_emp_inf_ironsides"] = 2,
    ["wh_jmw_emp_inf_ironsides_launchers"] = 2,
    ["wh_jmw_emp_cav_horned_hunters"] = 2,
    ["wh_jmw_emp_inf_grudgebringer_cannon"] = 3,
    ["wh_jmw_emp_inf_lions_roar"] = 2,
    ["wh_jmw_emp_inf_daughters_rhya"] = 2,
    ["wh_jmw_emp_inf_carroburg_greatswords"] = 1,
    ["wh_jmw_emp_inf_childrenullric"] = 2,
    ["wh_jmw_emp_inf_wardens"] = 2,
    ["wh_jmw_emp_cav_grudgebringer"] = 2,
    ["wh_jmw_emp_cav_wardens"] = 2,
    ["wh_jmw_emp_inf_grudgebringer"] = 2,
    ["helhunters_redeemers"] = 2,
  -- Dwarfs
    --core
    ["wh_main_dwf_inf_miners_0"] = 0,
    ["wh_main_dwf_inf_miners_1"] = 0,
    ["wh_dlc06_dwf_inf_rangers_0"] = 0,
    ["wh_main_dwf_inf_quarrellers_0"] = 0,
    ["wh_main_dwf_inf_quarrellers_1"] = 0,
    -- special
    ["wh_main_dwf_inf_dwarf_warrior_0"] = 1,
    ["wh_main_dwf_inf_dwarf_warrior_1"] = 1,
    ["wh_dlc06_dwf_inf_bugmans_rangers_0"] = 1,
    ["wh_dlc06_dwf_inf_rangers_1"] = 1,
    ["wh_main_dwf_inf_thunderers_0"] = 1,
    ["wh_main_dwf_inf_slayers"] = 1,
    -- rare
    ["wh_dlc06_dwf_art_bolt_thrower_0"] = 2,
    ["wh_main_dwf_inf_longbeards"] = 2,
    ["wh_main_dwf_inf_longbeards_1"] = 2,
    ["wh_main_dwf_art_grudge_thrower"] = 2,
    ["wh_main_dwf_veh_gyrobomber"] = 2,
    ["wh_main_dwf_veh_gyrocopter_0"] = 2,
    ["wh_main_dwf_veh_gyrocopter_1"] = 2,
    ["wh2_dlc10_dwf_inf_giant_slayers"] = 2,
    -- elite
    ["wh_main_dwf_art_cannon"] = 3,
    ["wh_main_dwf_art_flame_cannon"] = 3,
    ["wh_main_dwf_art_organ_gun"] = 3,
    ["wh_main_dwf_inf_irondrakes_0"] = 3,
    ["wh_main_dwf_inf_irondrakes_2"] = 3,
    ["wh_main_dwf_inf_hammerers"] = 3,
    ["wh_main_dwf_inf_ironbreakers"] = 4,
    -- ROR
    ["wh_dlc06_dwf_inf_ekrund_miners_0"] = 1,
    ["wh_dlc06_dwf_inf_warriors_dragonfire_pass_0"] = 1,
    ["wh_dlc06_dwf_inf_dragonback_slayers_0"] = 1,
    ["wh_dlc06_dwf_inf_ulthars_raiders_0"] = 1,
    ["wh_dlc06_dwf_inf_old_grumblers_0"] = 2,
    ["wh_dlc06_dwf_inf_norgrimlings_irondrakes_0"] = 3,
    ["wh_dlc06_dwf_veh_skyhammer_0"] = 2,
    ["wh_dlc06_dwf_art_gob_lobber_0"] = 2,
    ["wh_dlc06_dwf_inf_peak_gate_guard_0"] = 3,
    ["wh_dlc06_dwf_inf_norgrimlings_ironbreakers_0"] = 4,
  --Greenskins
    ["wh_main_grn_cav_forest_goblin_spider_riders_0"] = 0,
    ["wh_main_grn_cav_forest_goblin_spider_riders_1"] = 0,
    ["wh_main_grn_cav_goblin_wolf_chariot"] = 0,
    ["wh_main_grn_cav_goblin_wolf_riders_0"] = 0,
    ["wh_main_grn_cav_goblin_wolf_riders_1"] = 0,
    ["wh_main_grn_cav_orc_boar_chariot"] = 0,
    ["wh_main_grn_cav_savage_orc_boar_boyz"] = 0,
    ["wh_dlc06_grn_inf_nasty_skulkers_0"] = 0,
    ["wh_dlc06_grn_inf_squig_herd_0"] = 0,
    ["wh_dlc06_grn_mon_spider_hatchlings_0"] = 0,
    ["wh_main_grn_inf_goblin_archers"] = 0,
    ["wh_main_grn_inf_goblin_spearmen"] = 0,
    ["wh_main_grn_inf_orc_arrer_boyz"] = 0,
    ["wh_main_grn_inf_orc_boyz"] = 0,
    ["wh_main_grn_inf_savage_orcs"] = 0,
    ["wh2_dlc15_grn_veh_snotling_pump_wagon_0"] = 0,
    ["wh_dlc06_grn_inf_squig_explosive_0"] = 0,
    -- special
    ["wh2_dlc15_grn_cav_forest_goblin_spider_riders_waaagh_0"] = 1, --go
    ["wh2_dlc15_grn_veh_snotling_pump_wagon_flappas_0"] = 1,
    ["wh_dlc06_grn_cav_squig_hoppers_0"] = 1,
    ["wh_main_grn_cav_orc_boar_chariot"] = 1,
    ["wh_main_grn_cav_orc_boar_boy_big_uns"] = 1,
    ["wh_main_grn_cav_savage_orc_boar_boy_big_uns"] = 1,
    ["wh_main_grn_inf_savage_orc_big_uns"] = 1,
    ["wh_main_grn_inf_orc_big_uns"] = 1,
    ["wh_main_grn_inf_night_goblin_fanatics"] = 1,
    ["wh_main_grn_inf_night_goblins"] = 1,
    ["wh_main_grn_inf_night_goblin_archers"] = 1,
    ["wh_main_grn_inf_night_goblin_fanatics_1"] = 1,
    ["wh_main_grn_mon_trolls"] = 1,
    -- rare
    ["wh2_dlc15_grn_cav_squig_hoppers_waaagh_0"] = 2,
    ["wh2_dlc15_grn_veh_snotling_pump_wagon_roller_0"] = 2,
    ["wh2_dlc15_grn_mon_river_trolls_0"] = 2,
    ["wh2_dlc15_grn_mon_stone_trolls_0"] = 2,
    ["wh_main_grn_inf_black_orcs"] = 2,
    ["wh_main_grn_art_doom_diver_catapult"] = 2,
    ["wh_main_grn_art_goblin_rock_lobber"] = 2,
    -- elite
    ["wh2_dlc15_grn_mon_feral_hydra_waaagh_0"] = 3,
    ["wh2_dlc15_grn_mon_wyvern_waaagh_0"] = 3,
    ["wh2_dlc15_grn_mon_rogue_idol_0"] = 4,
    ["wh_main_grn_mon_arachnarok_spider_0"] = 4,
    ["wh_main_grn_mon_giant"] = 3,
    ["wh_dlc15_grn_mon_arachnarok_spider_waaagh_0"] = 4,
    
    -- ROR
    ["wh2_dlc15_grn_veh_snotling_pump_wagon_ror_0"] = 1,
    ["wh_dlc06_grn_cav_deff_creepers_0"] = 1,
    ["wh_dlc06_grn_cav_mogrubbs_marauders_0"] = 1,
    ["wh_dlc06_grn_cav_moon_howlers_0"] = 1,
    ["wh_dlc06_grn_cav_teef_robbers_0"] = 1,
    ["wh_dlc06_grn_cav_broken_tusks_mob_0"] = 2,
    ["wh_dlc06_grn_cav_durkits_squigs_0"] = 2,
    ["wh_dlc06_grn_inf_da_eight_peaks_loonies_0"] = 2,
    ["wh_dlc06_grn_inf_da_warlords_boyz_0"] = 2,
    ["wh_dlc06_grn_inf_da_rusty_arrers_0"] = 2,
    ["wh2_dlc15_grn_mon_river_trolls_ror_0"] = 3,
    ["wh_dlc06_grn_inf_krimson_killerz_0"] = 3,
    ["wh_dlc06_grn_art_hammer_of_gork_0"] = 3,
    ["wh2_dlc15_grn_mon_rogue_idol_ror_0"] = 5,
    ["wh_dlc06_grn_mon_venom_queen_0"] = 5,
  --Vampire counts
    ["wh_dlc04_vmp_veh_corpse_cart_0"] = 0,
    ["wh_dlc04_vmp_veh_corpse_cart_1"] = 0,
    ["wh_dlc04_vmp_veh_corpse_cart_2"] = 0,
    ["wh_main_vmp_inf_skeleton_warriors_0"] = 0,
    ["wh_main_vmp_inf_skeleton_warriors_1"] = 0,
    ["wh_main_vmp_inf_zombie"] = 0,
    ["wh_main_vmp_mon_dire_wolves"] = 0,
    ["wh_main_vmp_mon_fell_bats"] = 0,
    ["wh2_dlc11_vmp_inf_crossbowmen"] = 0,
    ["wh2_dlc11_vmp_inf_handgunners"] = 0,
    -- special
    ["wh_main_vmp_inf_crypt_ghouls"] = 1,
    ["wh_main_vmp_cav_black_knights_0"] = 1,
    ["wh_main_vmp_cav_black_knights_3"] = 2,
    ["wh_main_vmp_mon_crypt_horrors"] = 1,
    -- rare
    ["wh_main_vmp_inf_grave_guard_0"] = 2,
    ["wh_main_vmp_inf_grave_guard_1"] = 2,
    ["wh_main_vmp_inf_cairn_wraiths"] = 2,
    ["wh_main_vmp_mon_vargheists"] = 2,
    ["wh_main_vmp_veh_black_coach"] = 2,
    ["wh_dlc04_vmp_veh_mortis_engine_0"] = 2,
    -- elite
    ["wh_main_vmp_cav_hexwraiths"] = 3,
    ["wh_main_vmp_mon_varghulf"] = 3,
    ["wh_main_vmp_mon_terrorgheist"] = 4,
    ["wh_dlc02_vmp_cav_blood_knights_0"] = 4,
    -- ROR
    ["wh_dlc04_vmp_inf_konigstein_stalkers_0"] = 1,
    ["wh_dlc04_vmp_inf_tithe_0"] = 1,
    ["wh_dlc04_vmp_mon_direpack_0"] = 1,
    ["wh_dlc04_vmp_inf_feasters_in_the_dusk_0"] = 2,
    ["wh_dlc04_vmp_cav_vereks_reavers_0"] = 3,
    ["wh_dlc04_vmp_inf_sternsmen_0"] = 3,
    ["wh_dlc04_vmp_cav_chillgheists_0"] = 3,
    ["wh_dlc04_vmp_mon_devils_swartzhafen_0"] = 3,
    ["wh_dlc04_vmp_veh_claw_of_nagash_0"] = 3,
  --Wood elves
    ["wh_dlc05_wef_inf_dryads_0"] = 0,
    ["wh_dlc05_wef_inf_eternal_guard_0"] = 0,
    ["wh_dlc05_wef_inf_eternal_guard_1"] = 0,
    ["wh_dlc05_wef_inf_eternal_guard_1_qb"] = 0,
    ["wh_dlc05_wef_inf_glade_guard_0"] = 0,
    ["wh_dlc05_wef_inf_glade_guard_1"] = 0,
    ["wh_dlc05_wef_inf_glade_guard_1_qb"] = 0,
    ["wh_dlc05_wef_inf_glade_guard_2"] = 0,
    ["wh_dlc05_wef_cav_glade_riders_0"] = 0,
    ["wh_dlc05_wef_cav_glade_riders_1"] = 0,
    -- special
    ["wh_dlc05_wef_inf_deepwood_scouts_0"] = 1,
    ["wh_dlc05_wef_inf_wardancers_0"] = 1,
    ["wh_dlc05_wef_inf_wardancers_1"] = 1,
    ["wh_dlc05_wef_cav_hawk_riders_0"] = 1,
    ["wh_dlc05_wef_inf_deepwood_scouts_1"] = 1,
    ["wh_dlc05_wef_inf_deepwood_scouts_1_qb"] = 1,
    ["wh_dlc05_wef_mon_great_eagle_0"] = 1,
    -- rare
    ["wh_dlc05_wef_mon_treekin_0"] = 2,
    ["wh_pro04_wef_mon_treekin_ror_0"] = 2,
    ["wh_dlc05_wef_cav_wild_riders_0"] = 2,
    ["wh_dlc05_wef_cav_wild_riders_1"] = 2,
    ["wh_dlc05_wef_cav_sisters_thorn_0"] = 2,
    ["wh_dlc05_wef_inf_wildwood_rangers_0"] = 2,
    ["wh_dlc05_wef_inf_waywatchers_0"] = 2,
    -- elite
    ["wh_dlc05_wef_forest_dragon_0"] = 3,
    ["wh_dlc05_wef_mon_treeman_0"] = 3,
    -- ROR
    ["wh_pro04_wef_inf_eternal_guard_ror_0"] = 1,
    ["wh_pro04_wef_inf_wardancers_ror_0"] = 2,
    ["wh_pro04_wef_mon_treekin_ror_0"] = 3,
    ["wh_pro04_wef_cav_wild_riders_ror_0"] = 3,
    ["wh_pro04_wef_inf_wildwood_rangers_ror_0"] = 3,
    ["wh_pro04_wef_inf_waywatchers_ror_0"] = 3,
    
    
  --Norsca
    ["wh_dlc08_nor_mon_warwolves_0"] = 0,
    ["wh_main_nor_mon_chaos_warhounds_0"] = 0,
    ["wh_main_nor_mon_chaos_warhounds_1"] = 0,
    ["wh_dlc08_nor_cav_marauder_horsemasters_0"] = 0,
    ["wh_dlc08_nor_inf_marauder_hunters_0"] = 0,
    ["wh_dlc08_nor_inf_marauder_hunters_1"] = 0,
    ["wh_dlc08_nor_inf_marauder_spearman_0"] = 0,
    ["wh_main_nor_cav_marauder_horsemen_0"] = 0,
    ["wh_main_nor_cav_marauder_horsemen_1"] = 0,
    ["wh_main_nor_inf_chaos_marauders_0"] = 0,
    ["wh_main_nor_inf_chaos_marauders_1"] = 0,
    ["wh_dlc08_nor_inf_marauder_berserkers_0"] = 0,
    -- special
    ["wh_dlc08_nor_veh_marauder_warwolves_chariot_0"] = 1,
    ["wh_main_nor_cav_chaos_chariot"] = 1,
    ["wh_dlc08_nor_mon_skinwolves_0"] = 1,
    ["wh_dlc08_nor_mon_skinwolves_1"] = 1,
    ["wh_dlc08_nor_inf_marauder_champions_0"] = 1,
    ["wh_dlc08_nor_inf_marauder_champions_1"] = 1,
    ["wh_dlc08_nor_feral_manticore"] = 1,
    ["wh_main_nor_mon_chaos_trolls"] = 1,
    --rare
    ["wh_dlc08_nor_mon_war_mammoth_0"] = 2,
    ["wh_dlc08_nor_mon_norscan_ice_trolls_0"] = 2,
    ["wh_dlc08_nor_mon_fimir_0"] = 2,
    ["wh_dlc08_nor_mon_fimir_1"] = 2,
    --elite
    ["wh_dlc08_nor_mon_norscan_giant_0"] = 3,
    ["wh_dlc08_nor_mon_frost_wyrm_0"] = 3,
    ["wh_dlc08_nor_mon_war_mammoth_1"] = 3,
    ["wh_dlc08_nor_mon_war_mammoth_2"] = 3,
    -- ROR
    ["wh_pro04_nor_inf_chaos_marauders_ror_0"] = 1,
    ["wh_pro04_nor_inf_marauder_berserkers_ror_0"] = 1,
    ["wh_pro04_nor_mon_marauder_warwolves_ror_0"] = 2,
    ["wh_pro04_nor_mon_skinwolves_ror_0"] = 2,
    ["wh_dlc08_nor_mon_war_mammoth_ror_1"] = 2,
    ["wh_pro04_nor_mon_fimir_ror_0"] = 3,
    ["wh_dlc08_nor_mon_frost_wyrm_ror_0"] = 4,
    ["wh_pro04_nor_mon_war_mammoth_ror_0"] = 4,
    ["wh_dlc08_nor_art_hellcannon_battery"] = 4,
    --============================================================
  --Bretonnia(ai only)
    ["wh_dlc07_brt_inf_men_at_arms_1"] = 1,
    ["wh_main_brt_cav_mounted_yeomen_0"] = 1,
    ["wh_main_brt_cav_mounted_yeomen_1"] = 1,
    ["wh_main_brt_inf_men_at_arms"] = 1,
    ["wh_main_brt_inf_peasant_bowmen"] = 1,
    ["wh_main_brt_inf_spearmen_at_arms"] = 1,
    ["wh_dlc07_brt_inf_peasant_bowmen_1"] = 1,
    ["wh_dlc07_brt_inf_peasant_bowmen_2"] = 1,
    ["wh_dlc07_brt_inf_men_at_arms_2"] = 1,
    ["wh_dlc07_brt_peasant_mob_0"] = 1,
    ["wh_dlc07_brt_inf_spearmen_at_arms_1"] = 1,
    -- special
    ["wh_dlc07_brt_inf_battle_pilgrims_0"] = 1,
    ["wh_dlc07_brt_inf_grail_reliquae_0"] = 1,
    ["wh_dlc07_brt_inf_foot_squires_0"] = 1,
    ["wh_dlc07_brt_cav_knights_errant_0"] = 1,
    --rare
    ["wh_main_brt_cav_knights_of_the_realm"] = 2,
    ["wh_dlc07_brt_cav_questing_knights_0"] = 2,
    ["wh_main_brt_cav_pegasus_knights"] = 2,
    ["wh_main_brt_art_field_trebuchet"] = 2,
    ["wh_dlc07_brt_art_blessed_field_trebuchet_0"] = 2,
    --elite
    ["wh_dlc07_brt_cav_grail_guardians_0"] = 4,
    ["wh_dlc07_brt_cav_royal_pegasus_knights_0"] = 3,
    ["wh_dlc07_brt_cav_royal_hippogryph_knights_0"] = 4,
    ["wh_main_brt_cav_grail_knights"] = 3,
    -- ROR
    ["wh_pro04_brt_inf_battle_pilgrims_ror_0"] = 1,
    ["wh_pro04_brt_inf_foot_squires_ror_0"] = 1,
    ["wh_pro04_brt_cav_knights_errant_ror_0"] = 1,
    ["wh_pro04_brt_cav_knights_of_the_realm_ror_0"] = 2,
    ["wh_pro04_brt_cav_mounted_yeomen_ror_0"] = 1,
    ["wh_pro04_brt_cav_questing_knights_ror_0"] = 2,
  --Hight Elves
    ["wh2_main_hef_cav_ellyrian_reavers_0"] = 0,
    ["wh2_main_hef_cav_ellyrian_reavers_1"] = 0,
    ["wh2_main_hef_inf_archers_0"] = 0,
    ["wh2_main_hef_inf_archers_1"] = 0,
    ["wh2_main_hef_inf_spearmen_0"] = 0,
    ["wh2_dlc10_hef_inf_dryads_0"] = 0,
      
    ["wh2_dlc15_hef_inf_rangers_0"] = 0,
    -- special
    ["wh2_dlc15_hef_inf_silverin_guard_0"] = 1,
    ["wh2_main_hef_inf_white_lions_of_chrace_0"] = 1,
    ["wh2_main_hef_inf_lothern_sea_guard_0"] = 1,
    ["wh2_main_hef_inf_lothern_sea_guard_1"] = 1,
    ["wh2_dlc10_hef_inf_shadow_warriors_0"] = 1,
    ["wh2_dlc10_hef_inf_shadow_walkers_0"] = 1,
    ["wh2_main_hef_mon_great_eagle"] = 1,
    -- rare
    ["wh2_dlc15_hef_mon_war_lions_of_chrace_0"] = 2,
    ["wh2_dlc15_hef_inf_mistwalkers_faithbearers_0"] = 2,
    ["wh2_dlc15_hef_inf_mistwalkers_spireguard_0"] = 2,
    ["wh2_main_hef_cav_silver_helms_0"] = 2,
    ["wh2_main_hef_cav_silver_helms_1"] = 2,
    ["wh2_dlc15_hef_veh_lion_chariot_of_chrace_0"] = 2,
    ["wh2_dlc10_hef_mon_treekin_0"] = 2,
    ["wh2_main_hef_cav_ithilmar_chariot"] = 2,
    ["wh2_main_hef_cav_tiranoc_chariot"] = 2,
    ["wh2_main_hef_art_eagle_claw_bolt_thrower"] = 2,
    ["wh2_main_hef_inf_swordmasters_of_hoeth_0"] = 3,
    ["wh2_dlc15_hef_inf_mistwalkers_sentinels_0"] = 2,
    ["wh2_dlc15_hef_inf_mistwalkers_skyhawks_0"] = 2,
    -- elite
    ["wh2_dlc15_hef_mon_arcane_phoenix_0"] = 4,
    ["wh2_dlc15_hef_inf_mistwalkers_griffon_knights_0"] = 4,
    ["wh2_dlc15_hef_mon_black_dragon_imrik"] = 5,
    ["wh2_dlc15_hef_mon_forest_dragon_0"] = 4,
    ["wh2_dlc15_hef_mon_forest_dragon_imrik"] = 4,
    ["wh2_dlc15_hef_mon_moon_dragon_imrik"] = 5,
    ["wh2_dlc15_hef_mon_star_dragon_imrik"] = 5,
    ["wh2_dlc15_hef_mon_sun_dragon_imrik"] = 4,
    ["wh2_main_hef_mon_sun_dragon"] = 3,
    ["wh2_main_hef_mon_phoenix_flamespyre"] = 3,
    ["wh2_main_hef_mon_phoenix_frostheart"] = 3,
    ["wh2_dlc10_hef_inf_sisters_of_avelorn_0"] = 3,
    ["wh2_dlc10_hef_mon_treeman_0"] = 4,
    ["wh2_main_hef_inf_phoenix_guard"] = 4,
    ["wh2_main_hef_cav_dragon_princes"] = 4,
    ["wh2_main_hef_mon_moon_dragon"] = 4,
    ["wh2_main_hef_mon_star_dragon"] = 4,
    -- ROR
    ["wh2_dlc15_hef_inf_archers_ror_0"] = 1,
    ["wh2_dlc10_hef_inf_the_scions_of_mathlann_ror_0"] = 1,
    ["wh2_dlc10_hef_cav_the_heralds_of_the_wind_ror_0"] = 1,
    ["wh2_dlc10_hef_inf_the_silverpelts_ror_0"] = 2,
    ["wh2_dlc10_hef_inf_the_grey_ror_0"] = 2,
    ["wh2_dlc10_hef_inf_the_storm_riders_ror_0"] = 2,
    ["wh2_dlc15_hef_mon_war_lions_of_chrace_ror_0"] = 3,
    ["wh2_dlc10_hef_inf_everqueens_court_guards_ror_0"] = 4,
    ["wh2_dlc10_hef_inf_keepers_of_the_flame_ror_0"] = 5,
    ["wh2_dlc10_hef_cav_the_fireborn_ror_0"] = 5,
    ["wh2_dlc15_hef_mon_arcane_phoenix_ror_0"] = 5,
  
  
  --Dark Elves
    ["wh2_main_def_cav_dark_riders_0"] = 0,
    ["wh2_main_def_cav_dark_riders_1"] = 0,
    ["wh2_main_def_cav_dark_riders_2"] = 0,
    ["wh2_main_def_inf_bleakswords_0"] = 0,
    ["wh2_main_def_inf_darkshards_0"] = 0,
    ["wh2_main_def_inf_dreadspears_0"] = 0,
    ["wh2_main_def_inf_harpies"] = 0,
    -- special
    ["wh2_main_def_inf_darkshards_1"] = 1,
    ["wh2_dlc10_def_cav_doomfire_warlocks_0"] = 1,
    ["wh2_main_def_inf_black_ark_corsairs_0"] = 1,
    ["wh2_main_def_inf_black_ark_corsairs_1"] = 1,
    ["wh2_main_def_inf_witch_elves_0"] = 1,
    ["wh2_main_def_cav_cold_one_chariot"] = 1,
    ["wh2_dlc10_def_mon_feral_manticore_0"] = 1,
    ["wh2_main_def_cav_cold_one_knights_0"] = 1,
    -- rare
    ["wh2_main_def_inf_shades_0"] = 2,
    ["wh2_main_def_inf_shades_1"] = 2,
    ["wh2_main_def_inf_shades_2"] = 2,
    ["wh2_dlc14_def_cav_scourgerunner_chariot_0"] = 2,
    ["wh2_dlc10_def_inf_sisters_of_slaughter"] = 2,
    ["wh2_main_def_art_reaper_bolt_thrower"] = 2,
    ["wh2_main_def_cav_cold_one_knights_1"] = 2,
    -- elite
    ["wh2_dlc14_def_mon_bloodwrack_medusa_0"] = 3,
    ["wh2_dlc14_def_veh_bloodwrack_shrine_0"] = 3,
    ["wh2_main_def_mon_war_hydra"] = 3,
    ["wh2_dlc10_def_mon_kharibdyss_0"] = 3,
    ["wh2_main_def_inf_har_ganeth_executioners_0"] = 3,
    ["wh2_main_def_inf_black_guard_0"] = 3,
    ["wh2_main_def_mon_black_dragon"] = 4,
    --ROR
    ["wh2_dlc14_def_inf_harpies_ror_0"] = 1,
    ["wh2_dlc10_def_inf_the_bolt_fiends_ror_0"] = 1,
    ["wh2_dlc10_def_inf_sisters_of_the_singing_doom_ror_0"] = 2,
    ["wh2_dlc14_def_cav_scourgerunner_chariot_ror_0"] = 3,
    ["wh2_dlc10_def_inf_the_hellebronai_ror_0"] = 1,
    ["wh2_dlc10_def_cav_slaanesh_harvesters_ror_0"] = 2,
    ["wh2_dlc10_def_cav_raven_heralds_ror_0"] = 1,
    ["wh2_dlc10_def_cav_knights_of_the_ebon_claw_ror_0"] = 3,
    ["wh2_dlc10_def_mon_chill_of_sontar_ror_0"] = 4,
    ["wh2_dlc14_def_mon_bloodwrack_medusa_ror_0"] = 4,
    ["wh2_dlc10_def_inf_blades_of_the_blood_queen_ror_0"] = 4,
    
  --Lizardmen
    ["wh2_main_lzd_cav_cold_ones_feral_0"] = 0,
    ["wh2_main_lzd_inf_skink_cohort_0"] = 0,
    ["wh2_main_lzd_inf_skink_cohort_1"] = 0,
    ["wh2_main_lzd_inf_skink_skirmishers_0"] = 0,
    ["wh2_main_lzd_inf_skink_skirmishers_blessed_0"] = 0,
    ["wh2_dlc12_lzd_inf_skink_red_crested_0"] = 0,
    ["wh2_main_lzd_cav_terradon_riders_0"] = 0,
    ["wh2_main_lzd_inf_chameleon_skinks_0"] = 0,
    ["wh2_main_lzd_inf_chameleon_skinks_blessed_0"] = 0,
    -- special
    ["wh2_main_lzd_cav_cold_one_spearmen_1"] = 1,
    ["wh2_main_lzd_cav_cold_one_spearriders_blessed_0"] = 1,
    ["wh2_main_lzd_cav_cold_ones_1"] = 1,
    ["wh2_main_lzd_inf_saurus_spearmen_0"] = 1,
    ["wh2_main_lzd_inf_saurus_warriors_0"] = 1,
    ["wh2_dlc12_lzd_cav_terradon_riders_1_tlaqua"] = 1,
    ["wh2_main_lzd_cav_terradon_riders_1"] = 1,
    ["wh2_main_lzd_cav_terradon_riders_blessed_1"] = 1,
    ["wh2_dlc12_lzd_mon_salamander_pack_0"] = 1,
    ["wh2_dlc13_lzd_mon_razordon_pack_0"] = 1,
    ["wh2_main_lzd_inf_saurus_spearmen_1"] = 1,
    ["wh2_main_lzd_inf_saurus_spearmen_blessed_1"] = 1,
    ["wh2_main_lzd_inf_saurus_warriors_1"] = 1,
    ["wh2_main_lzd_inf_saurus_warriors_blessed_1"] = 1,
    ["wh2_main_lzd_mon_bastiladon_0"] = 1,
    
    -- rare
    ["wh2_dlc12_lzd_mon_bastiladon_3"] = 2,
    ["wh2_main_lzd_mon_bastiladon_1"] = 2,
    ["wh2_main_lzd_mon_bastiladon_2"] = 2,
    ["wh2_main_lzd_mon_bastiladon_blessed_2"] = 2,
    ["wh2_dlc12_lzd_cav_ripperdactyl_riders_0"] = 2,
    ["wh2_main_lzd_mon_kroxigors"] = 2,
    ["wh2_main_lzd_mon_kroxigors_blessed"] = 2,
    ["wh2_dlc13_lzd_mon_sacred_kroxigors_0"] = 2,
    ["wh2_dlc13_lzd_mon_sacred_kroxigors_0_nakai"] = 2,
    ["wh2_main_lzd_cav_horned_ones_0"] = 2,
    ["wh2_main_lzd_cav_horned_ones_blessed_0"] = 0, --very cheap
    ["wh2_main_lzd_inf_temple_guards"] = 2,
    ["wh2_main_lzd_inf_temple_guards_blessed"] = 2,
    ["wh2_main_lzd_mon_stegadon_0"] = 2,
    -- elite
    ["wh2_dlc12_lzd_mon_ancient_salamander_0"] = 3,
    ["wh2_main_lzd_mon_stegadon_1"] = 3,
    ["wh2_main_lzd_mon_stegadon_blessed_1"] = 3,
    ["wh2_main_lzd_mon_ancient_stegadon"] = 4,
    ["wh2_dlc12_lzd_mon_ancient_stegadon_1"] = 4,
    ["wh2_main_lzd_mon_carnosaur_0"] = 4,
    ["wh2_main_lzd_mon_carnosaur_blessed_0"] = 4,
    ["wh2_dlc13_lzd_mon_dread_saurian_0"] = 5,
    ["wh2_dlc13_lzd_mon_dread_saurian_1"] = 5,
    --ROR
    ["wh2_dlc12_lzd_inf_skink_red_crested_ror_0"] = 1,
    ["wh2_dlc12_lzd_cav_cold_one_spearriders_ror_0"] = 2,
    ["wh2_dlc12_lzd_mon_salamander_pack_ror_0"] = 2,
    ["wh2_dlc12_lzd_inf_saurus_warriors_ror_0"] = 2,
    ["wh2_dlc12_lzd_cav_terradon_riders_ror_0"] = 2,
    ["wh2_dlc13_lzd_mon_razordon_pack_ror_0"] = 2,
    ["wh2_dlc12_lzd_inf_temple_guards_ror_0"] = 3,
    ["wh2_dlc12_lzd_cav_ripperdactyl_riders_ror_0"] = 3,
    ["wh2_dlc13_lzd_mon_sacred_kroxigors_ror_0"] = 3,
    ["wh2_dlc12_lzd_mon_ancient_stegadon_ror_0"] = 5,
    ["wh2_dlc13_lzd_mon_dread_saurian_ror_0"] = 6,
  --Skaven
    ["wh2_main_skv_inf_clanrat_spearmen_0"] = 0,
    ["wh2_main_skv_inf_clanrat_spearmen_1"] = 0,
    ["wh2_main_skv_inf_clanrats_0"] = 0,
    ["wh2_main_skv_inf_clanrats_1"] = 0,
    ["wh2_main_skv_inf_night_runners_0"] = 0,
    ["wh2_main_skv_inf_night_runners_1"] = 0,
    ["wh2_main_skv_inf_skavenslave_slingers_0"] = 0,
    ["wh2_main_skv_inf_skavenslave_spearmen_0"] = 0,
    ["wh2_main_skv_inf_skavenslaves_0"] = 0,
    -- special
    ["wh2_main_skv_inf_plague_monk_censer_bearer"] = 1,
    ["wh2_main_skv_inf_plague_monks"] = 1,
    ["wh2_main_skv_inf_stormvermin_0"] = 1,
    ["wh2_main_skv_inf_stormvermin_1"] = 1,
    ["wh2_main_skv_inf_death_runners_0"] = 1,
    ["wh2_main_skv_inf_gutter_runner_slingers_0"] = 1,
    ["wh2_main_skv_inf_gutter_runner_slingers_1"] = 1,
    ["wh2_main_skv_inf_gutter_runners_0"] = 1,
    ["wh2_main_skv_inf_gutter_runners_1"] = 1,
    ["wh2_dlc14_skv_inf_eshin_triads_0"] = 1,
    ["wh2_main_skv_mon_rat_ogres"] = 1,
    ["wh2_dlc14_skv_inf_warp_grinder_0"] = 1,
    -- rare
    ["wh2_main_skv_inf_death_globe_bombardiers"] = 2,
    ["wh2_main_skv_inf_poison_wind_globadiers"] = 2,
    ["wh2_main_skv_inf_warpfire_thrower"] = 2,
    ["wh2_dlc12_skv_veh_doom_flayer_0"] = 2,
    -- elite
    ["wh2_main_skv_art_plagueclaw_catapult"] = 3,
    ["wh2_main_skv_art_warp_lightning_cannon"] = 3,
    ["wh2_dlc12_skv_inf_ratling_gun_0"] = 3,
    ["wh2_dlc14_skv_inf_poison_wind_mortar_0"] = 3,
    ["wh2_dlc12_skv_inf_warplock_jezzails_0"] = 3,
    ["wh2_main_skv_veh_doomwheel"] = 3,
    ["wh2_main_skv_mon_hell_pit_abomination"] = 3,
    --
    --ROR
    ["wh2_dlc14_skv_inf_death_runners_ror_0"] = 2,
    ["wh2_dlc14_skv_inf_eshin_triads_ror_0"] = 2,
    ["wh2_dlc12_skv_inf_clanrats_ror_0"] = 1,
    ["wh2_dlc12_skv_inf_plague_monk_censer_bearer_ror_0"] = 2,
    ["wh2_dlc12_skv_inf_stormvermin_ror_0"] = 2,
    ["wh2_dlc12_skv_inf_warpfire_thrower_ror_tech_lab_0"] = 3,
    ["wh2_dlc12_skv_veh_doom_flayer_ror_tech_lab_0"] = 3,
    ["wh2_dlc12_skv_veh_doom_flayer_ror_0"] = 3,
    ["wh2_dlc12_skv_inf_ratling_gun_ror_0"] = 4,
    ["wh2_dlc12_skv_inf_ratling_gun_ror_tech_lab_0"] = 4,
    ["wh2_dlc14_skv_inf_poison_wind_mortar_ror_0"] = 4,
    ["wh2_dlc12_skv_inf_warplock_jezzails_ror_0"] = 4,
    ["wh2_dlc12_skv_art_warp_lightning_cannon_ror_0"] = 4,
    ["wh2_dlc12_skv_art_warplock_jezzails_ror_tech_lab_0"] = 4,
    ["wh2_dlc12_skv_veh_doomwheel_ror_0"] = 4,
    ["wh2_dlc12_skv_veh_doomwheel_ror_tech_lab_0"] = 4,
  
  --Vampire Coast
    ["wh2_dlc11_cst_inf_sartosa_free_company_0"] = 0,
    ["wh2_dlc11_cst_inf_sartosa_militia_0"] = 0,
    ["wh2_dlc11_cst_inf_zombie_deckhands_mob_0"] = 0,
    ["wh2_dlc11_cst_inf_zombie_deckhands_mob_1"] = 0,
    ["wh2_dlc11_cst_inf_zombie_gunnery_mob_0"] = 0,
    ["wh2_dlc11_cst_inf_zombie_gunnery_mob_1"] = 0,
    ["wh2_dlc11_cst_inf_zombie_gunnery_mob_3"] = 0,
    ["wh2_dlc11_cst_mon_scurvy_dogs"] = 0,
    ["wh2_dlc11_cst_inf_zombie_gunnery_mob_2"] = 0,
    ["wh2_dlc11_cst_mon_bloated_corpse_0"] = 0,
    -- special
    ["wh2_dlc11_cst_cav_deck_droppers_0"] = 1,
    ["wh2_dlc11_cst_cav_deck_droppers_1"] = 1,
    ["wh2_dlc11_cst_cav_deck_droppers_2"] = 1,
    ["wh2_dlc11_cst_mon_animated_hulks_0"] = 0,
    ["wh2_dlc11_cst_inf_deck_gunners_0"] = 1,
    -- rare
    ["wh2_dlc11_cst_inf_depth_guard_0"] = 2,
    ["wh2_dlc11_cst_inf_depth_guard_1"] = 2,
    ["wh2_dlc11_cst_mon_rotting_prometheans_0"] = 2,
    ["wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0"] = 2,
    ["wh2_dlc11_cst_inf_syreens"] = 2,
    ["wh2_dlc11_cst_mon_mournguls_0"] = 2,
    -- elite
    ["wh2_dlc11_cst_art_carronade"] = 3,
    ["wh2_dlc11_cst_art_mortar"] = 3,
    ["wh2_dlc11_cst_mon_necrofex_colossus_0"] = 4,
    ["wh2_dlc11_cst_mon_rotting_leviathan_0"] = 3,
    ["wh2_dlc11_cst_mon_terrorgheist"] = 3,
    --ROR
    ["wh2_dlc11_cst_inf_zombie_gunnery_mob_ror_0"] = 1,
    ["wh2_dlc11_cst_inf_zombie_deckhands_mob_ror_0"] = 1,
    ["wh2_dlc11_cst_cav_deck_droppers_ror_0"] = 1,
    ["wh2_dlc11_cst_inf_depth_guard_ror_0"] = 2,
    ["wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_ror"] = 2,
    ["wh2_dlc11_cst_inf_deck_gunners_ror_0"] = 1,
    ["wh2_dlc11_cst_mon_mournguls_ror_0"] = 2,
    ["wh2_dlc11_cst_mon_necrofex_colossus_ror_0"] = 4,
    ["wh2_dlc11_cst_art_queen_bess"] = 6,
    
  --Southern Realms
    ["teb_duellists"] = 1,
    ["teb_sisters"] = 2,
    ["teb_xbow_cav"] = 1,
    ["teb_irrana"] = 1,
    ["teb_galloper_horse"] = 2,
    ["teb_galloper"] = 1,
    ["teb_birdmen"] = 1,
    ["teb_roc_01"] = 3,
    ["teb_roc_02"] = 3,
    ["teb_roc_03"] = 1,
    ["teb_roc_04"] = 2,
    ["til_sartosa"] = 0,
    ["bor_archers"] = 0,
    ["bor_light_cav"] = 0,
    ["CTT_teb_archers"] = 0,
    ["CTT_teb_crossbowmen"] = 0,
    ["CTT_teb_spearmen"] = 0,
    ["CTT_teb_swordsmen"] = 0,
    ["CTT_teb_pike"] = 1,
    ["CTT_teb_rangers"] = 1,
    ["CTT_teb_halberdiers"] = 1,
    ["til_pike"] = 1,
    ["til_pavise"] = 1,
    ["til_pavise_col"] = 1,
    ["til_encarmine"] = 1,
    ["til_carabineers"] = 1,
    ["est_royal"] = 1,
    ["est_conqui_foot"] = 1,
    ["est_conqui_foot_col"] = 1,
    ["est_conqui"] = 1,
    ["est_conqui_col"] = 1,
    ["est_cav"] = 1,
    ["est_cav_col"] = 1,
    ["bor_HA"] = 1,
    ["bor_heavy_cav"] = 1,
    ["bor_rangers"] = 1,
    ["dwf_rangers_teb"] = 1,
    ["dwf_warriors2h_teb"] = 1,
    ["dwf_warriors_teb"] = 1,
    ["emp_halb_bor"] = 1,
    ["emp_halb_te"] = 1,
    ---
    ["teb_paymaster"] = 2,
    ["til_broken_lances"] = 2,
    ["til_broken_lances_col"] = 2,
    ["bor_knights"] = 2,
    ["til_greatswords"] = 2,
    ["bor_hop"] = 2,
    ["est_bwatch"] = 2,
    ["til_guard"] = 2,
    ["bor_mercs"] = 2,
    ["bor_mercs_col"] = 2,
    ["est_kotrs"] = 2,
    ["til_ducale"] = 3,
    ["til_ducale_col"] = 3,
    ["til_light_cannon"] = 3,
    ["dwf_cannon_teb"] = 3,
    ["dwf_organ_teb"] = 3,
  
    --ROR
    ["teb_alcatani"] = 1,
    ["teb_pirazzo"] = 1,
    ["teb_muktar"] = 1,
    ["teb_ricco"] = 2,
    ["teb_pirazzo_xbows"] = 2,
    ["teb_leopard"] = 2,
    ["teb_vespero"] = 2,
    ["teb_venators"] = 2,
    ["teb_marksmen"] = 2,
    ["teb_besiegers"] = 2,
    ["teb_amazons"] = 2,
    ["teb_cursed"] = 2,
    ["teb_origo"] = 2,
    ["teb_tichi"] = 2,
    ["teb_manflayers"] = 3,
    ["teb_asarnil"] = 4,
  
    ["teb_roc_verena"] = 1,
    ["teb_roc_gunn"] = 1,
    ["teb_roc_dieterfist"] = 2,
    ["teb_roc_parravon"] = 2,
    ["teb_roc_strygos"] = 2,
    ["teb_roc_broswords"] = 2,
    ["teb_roc_gwatch"] = 2,
    ["teb_roc_montecastello"] = 2,
    ["teb_roc_kotss"] = 3,
    ["teb_roc_organ"] = 3,
  
  --Sons of Asuryan
    ["hef_inf_elven_warriors"] = 0,
    ["wh2_jmw_hef_inf_cothiquan_warriors"] = 0,
    ["wh2_jmw_hef_inf_revenants_khaine_sword"] = 0,
    ["wh2_jmw_hef_inf_chracian_warriors"] = 0,
    ["wh2_jmw_hef_inf_revenants_khaine_spear"] = 0,
    ["wh2_jmw_hef_inf_chracian_spearmen"] = 0,
    ["wh2_jmw_hef_inf_cothiquan_spearmen"] = 0,
    ["wh2_jmw_hef_inf_nightelm_warriors"] = 0,
    ["wh2_jmw_hef_inf_nightelm_spearmen"] = 0,
    ["hef_cav_shoreriders_lance"] = 1,
    ["wh2_jmw_hef_inf_chracian_archers"] = 0,
    ["wh2_jmw_hef_inf_nightelm_archers"] = 1,
    ["wh2_jmw_hef_inf_cothiquan_raiders"] = 1,
    ["hef_cav_shoreriders_archers"] = 1,
    ["wh2_jmw_hef_inf_chracian_beasthunters"] = 1,
    ["wh2_jmw_hef_inf_chracian_hunters"] = 1,
    ["wh2_jmw_hef_inf_cothiquan_worshippers"] = 1,
    ["wh2_jmw_hef_inf_spears_dabbarloc"] = 1,
    ["wh2_jmw_hef_inf_wardens_annulii_mountains"] = 1,
    ["wh2_jmw_hef_mon_forest_dragon"] = 3,
    ["wh2_jmw_hef_mon_griffin_riders"] = 4,
    --ann
    ["wh2_main_hef_inf_spearmen_griffong"] = 0,
    ["wh2_main_hef_inf_guardians_tol_amalir"] = 0,
    ["wh2_main_hef_inf_sapphire_fellowship"] = 0,
    ["wh2_jmw_hef_inf_caladorian_sentinel_archers_gate"] = 1,
    ["wh2_main_hef_inf_archers_griffong"] = 0,
    ["wh2_main_hef_inf_laerin_bows"] = 0,
    ["wh2_main_hef_inf_silver_company"] = 0,
    ["wh2_jmw_hef_inf_unicorng_archers"] = 0,
    ["wh2_main_hef_art_eagle_claw_battery"] = 2,
    ["wh2_main_hef_inf_unicorn_gate_guard"] = 1,
    ["wh2_main_hef_inf_phoenix_gate_guard"] = 1,
    ["wh2_main_hef_inf_griffon_gate_guard"] = 1,
    ["wh2_main_hef_cav_anariel_chariot"] = 2,
    ["wh2_main_hef_inf_eagle_gate_guard"] = 1,
    ["wh2_main_hef_cav_caevar_lancers"] = 1,
    --cal
    ["hef_cal_hef_inf_caladorian_hawkeyes"] = 0,
    ["hef_cal_hef_inf_caladorian_sentinel"] = 0,
    ["hef_cal_hef_inf_caladorian_spearmen"] = 0,
    ["hef_cal_hef_inf_disciples_vaul"] = 0,
    ["cal_hef_inf_drakespine_warriors"] = 1,
    ["cal_hef_cav_ghost_warriors"] = 4,
    ["hef_cal_hef_inf_dragon_guard_ror"] = 4,
    ["hef_cal_hef_cav_dragonspine_princes_ror"] = 5,
    ["hef_cal_hef_mon_baith_caradan_ror"] = 5,
    --yvr
    ["yvr_inf_elven_warriors"] = 0,
    ["yvr_hef_inf_archers_0"] = 0,
    ["hef_yvr_inf_spears_yvresse"] = 0,
    ["yvr_hef_inf_archers_1"] = 0,
    ["yvr_hef_inf_ghost_warriors"] = 1,
    ["yvr_inf_sea_guard"] = 1,
    ["hef_yvr_inf_archers_mistwalkers"] = 1,
    ["yvr_inf_cove_warriors"] = 2,
  
  --Kraka Drac
    ["kraka_quarrel_2h"] = 0,
    ["dwf_orgi"] = 0,
    ["kraka_marauder_horsemen"] = 0,
    ["kraka_marauders_1"] = 0,
    ["kraka_marauders_0"] = 0,
    
    ["dwf_runadiers"] = 1,
    ["kraka_slayers"] = 1,
    ["kraka_wrath"] = 1,
    ["kraka_nor_carrions"] = 1,
    ["kraka_slayers"] = 1,
    ["dwf_needlers"] = 1,
    ["kraka_rangers_2h"] = 1,
    ["kraka_warriors_2h"] = 1,
    ["kraka_thunderbows"] = 1,
    
    ["dwf_acid"] = 2,
    ["kraka_crimsonbane"] = 2,
    ["kraka_stoneguard"] = 2,
    ["dwf_wardbearers"] = 2,
    ["dwf_nutters"] = 2,
    ["dwf_impact"] = 2,
    ["dwf_rust"] = 2,
    ["kraka_losturk"] = 2,
    ["kraka_longbeards_2h"] = 2,
    --
    ["dwf_drillers"] = 3,
    ["dwf_huskarls"] = 3,
    ["kraka_drakeguard"] = 3,
    ["kraka_marauder_champ"] = 3,
    ["kraka_forsaken"] = 3,
    ["kraka_nor_truesons"] = 3,
  
  --Mixu Mousillion
    ["mixu_vmp_mon_fell_bats"] = 0,
    ["mixu_vmp_inf_skeleton_warriors_0"] = 0,
    ["mixu_vmp_inf_skeleton_warriors_1"] = 0,
    ["mixu_vmp_inf_zombie"] = 0,
    ["wh2_mixu_vmp_inf_bowmen_fire"] = 0,
    ["wh2_mixu_vmp_inf_bowmen_poison"] = 0,
    ["wh2_mixu_vmp_inf_men_at_arms_polearms"] = 0,
    ["wh2_mixu_vmp_inf_bowmen"] = 0,
    ["wh2_mixu_vmp_inf_men_at_arms_sword"] = 0,
    ["wh2_mixu_vmp_cav_mounted_yeomen"] = 0,
    ["mixu_vmp_inf_crypt_ghouls"] = 1,
    ["wh2_mixu_vmp_cav_black_knights_sword"] = 1,
    ["wh2_mixu_vmp_cav_black_knights_lance"] = 2,
    
    ["wh2_mixu_vmp_inf_wailing_hags"] = 2,
    ["wh2_mixu_vmp_cav_knights_errant"] = 2,
    ["wh2_mixu_vmp_art_trebuchet"] = 3,
    ["wh2_mixu_vmp_art_cursed_trebuchet"] = 3,
    ["wh2_mixu_vmp_cav_knights_of_the_realm"] = 3,
    ["wh2_mixu_vmp_cav_questing_knights"] = 3,
    ["wh2_mixu_vmp_cav_black_grail_knights"] = 4,
  
    ["wh2_mixu_vmp_ror_the_hungry"] = 2,
    ["wh2_mixu_vmp_ror_bastardiers_of_chalons"] = 1,
    ["wh2_mixu_vmp_ror_the_ghosts_of_glanbor"] = 1,
    ["wh2_mixu_vmp_ror_midnight_ravens_of_rachard"] = 1,
    ["wh2_mixu_vmp_ror_silver_shriekers"] = 3,
    ["wh2_mixu_vmp_ror_doom_reliquae_of_mordac"] = 2,
    ["wh2_mixu_vmp_ror_the_rose_lances"] = 3,
    ["wh2_mixu_vmp_ror_the_dreadwings"] = 5,
  --Orcs and goblins extended
    ["grn_inf_forest_bow"] = 0,
    ["grn_inf_night_goblin_spears"] = 0,
    ["grn_inf_forest_sword"] = 0,
    ["grn_inf_forest_spear"] = 0,
    ["grn_inf_snotling"] = 0,
    ["goblin_boss"] = 1,
    ["grn_inf_orc_boyz_spear"] = 0,
    ["grn_inf_savage_orc_spear"] = 0,
    ["grn_inf_savage_big_great"] = 0,
    ["grn_inf_black_orc_shields"] = 2,
    ["grn_inf_black_orc_dual"] = 2,
    ["grn_big_uns_shields"] = 1,
    ["colossal_squig"] = 2,
    ["armored_colossal_squig"] = 3,
    ["savage_giant"] = 3,
    ["ws_grn_inf_da_immortulz"] = 3,
    ["ws_grn_inf_forest_goblin_hunters"] = 0,
    ["ws_grn_inf_forest_goblins"] = 0,
    ["ws_grn_inf_orc_stikka_boyz"] = 0,
    ["ws_grn_inf_savage_orc_stikkas"] = 0,
    ["ws_grn_inf_snotlings_waaagh"] = 0,
    ["ws_grn_mon_stegadon_waaagh"] = 3,
    ["ws_mon_little_gork"] = 4,
  --Skaven clans
    ["thom_vulkan_stormvermin_shield"] = 1,
    ["thom_vulkan_stormvermin_halberd"] = 1,
    ["Thom_vulkan_clanrat_basic"] = 0,
    ["Thom_vulkan_clanrat_shields"] = 0,
    ["Thom_vulkan_clanrat_spears"] = 0,
    ["Thom_vulkan_clanrat_spears_shields"] = 0,
    ["thom_flameclaw_catapult"] = 3,
    ["thom_vulkan_spider"] = 4,
    ["thom_vulkan_spider_small"] = 0,
    ["thom_vulkan_moltskin_spider"] = 4,
    ["thom_vulkan_fire_wind_mortar"] = 3,
    ["thom_vulkan_fire_wind_globadiers"] = 2,
    ["thom_vulkan_rattling"] = 3,
    ["thom_vulkan_jezzail"] = 3,
    ["thom_vulkan_ashen_gaurd_shield"] = 2,
    ["thom_vulkan_ashen_gaurd_halberd"] = 2,
    ["thom_vulkan_warpfire_cannon"] = 3,
    ["thom_vulkan_warpfire_turret"] = 3,
    ["thom_vulkan_warpfire_throwers"] = 2,
    --ferric
    ["thom_ferrik_skv_inf_clanrat_spearmen_0"] = 0,
    ["thom_ferrik_skv_inf_clanrat_spearmen_1"] = 0,
    ["thom_ferrik_skv_inf_clanrats_0"] = 0,
    ["thom_ferrik_skv_inf_clanrats_1"] = 0,
    ["thom_ferrik_dwf_slave"] = 0,
    ["thom_ferrik_stormvermin_2h"] = 1,
    ["thom_ferrik_stormvermin_halberd"] = 1,
    ["thom_ferrik_stormvermin_shield"] = 1,
    ["thom_ferrik_armoured_rat_ogres"] = 1,
    ["thom_ferrik_art_bolt_thrower_0"] = 2,
    ["thom_ferrik_art_shield_battery"] = 3,
    ["thom_ferrik_fire_wind_globadiers"] = 2,
    ["thom_ferrik_forge_guard"] = 2,
    ["thom_ferrik_gold_rats"] = 2,
    ["thom_ferrik_inf_handguns"] = 1,
    ["thom_ferrik_inf_poison_wind_mortar_0"] = 3,
    ["thom_ferrik_inf_poison_wind_mortar_ror_0"] = 4,
    ["thom_ferrik_ironbreaker"] = 3,
    ["thom_ferrik_mounted_gaurd"] = 3,
    ["thom_ferrik_organ_gun"] = 3,
    ["thom_ferrik_rat_snatchers"] = 2,
    ["thom_ferrik_jezzail"] = 3,
    ["thom_ferrik_rattling"] = 3,
  --Single unit mods
    ["cr_lzd_mon_coatl_0"] = 4,
    ["dwf_runegolem"] = 3,
    ["cr_hef_veh_lothern_skycutter"] = 3,
    ["cr_skv_mon_chimaerat_0"] = 3,
    ["bacr_chs_inf_daemonette"] = 2,
};
  
  
local function apply_effect(effect_strength, force, hide_log)
  local upkeep_mod = math.min(effect_strength, max_supply_per_army);
  local effect_bundle = "srw_bundle_force_upkeep_" .. upkeep_mod;

  cm:apply_effect_bundle_to_characters_force(effect_bundle, force:general_character():cqi(), -1, true);

  if not hide_log then
    SRWLOG("APPLY EFFECT: +"..tostring(upkeep_mod).."% TO UPKEEP");
  end
end;

local function remove_effect(force, hide_log)
  for k = 1, max_supply_per_army do
    local effect = "srw_bundle_force_upkeep_" .. k

    if force:has_effect_bundle(effect) then

      if not hide_log then
        SRWLOG("this army had "..tostring(effect));
      end;

      cm:remove_effect_bundle_from_characters_force(effect, force:general_character():cqi());
    end;

  end;
end;


--calculate upkeep modificator
local function srw_get_diff_mult()
  if player_supply_custom_mult == "disabled" then
    local difficulty = cm:model():combined_difficulty_level();
    local mod = 2;				-- easy
    
    if difficulty == 0 then
      mod = 3;				-- normal
    elseif difficulty == -1 then
      mod = 5;					-- hard
    elseif difficulty == -2 then
      mod = 8;			-- very hard
    elseif difficulty == -3 then
      mod = 8;			-- legendary
    end;

    return mod;

  else
    return player_supply_custom_mult
  end
end;


--version from hunter & beast patch
local function srw_faction_is_horde(faction)
	return faction:is_allowed_to_capture_territory() == false;
end;

local function get_army_count(force_list)
  local army_count = 0

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
      army_count = army_count + 1
    end; --of army check
  end; --of army call

  return army_count
end;
--if unit not found in SRW_Supply_Cost
local function calculate_unit_supply(unit)
  local uclass = unit:unit_class();
  local ucat = unit:unit_category();
  local ucost = unit:get_unit_custom_battle_cost()
  if uclass == "com" then
    return 0
  elseif ucost == 0 then
    return 1 + basic_unit_supply
  elseif ucost >= 1800 then
    return 4 + basic_unit_supply
  elseif ucost >= 1400 then
    return 3 + basic_unit_supply
  elseif ucost >= 1000 then
    return 2 + basic_unit_supply
  elseif ucost >= 600 then
    return 1 + basic_unit_supply
  end;
  return basic_unit_supply;
end; 

local function get_unit_supply(key)
  if SRW_Supply_Cost[key] ~= nil then
    return basic_unit_supply + SRW_Supply_Cost[key]
  else
    return nil
  end
end


local function apply_supply_balance_effect(faction, effect_strength)
  local effect_name = "srw_bundle_supply_balance_"..math.min(effect_strength, 25)
  cm:apply_effect_bundle(effect_name, faction:name(), -1)
end

local function remove_supply_balance_effect(faction)
  for i = 1, 25 do
    local effect_name = "srw_bundle_supply_balance_"..i
    
    if faction:has_effect_bundle(effect_name) then
      cm:remove_effect_bundle(effect_name, faction:name());
    end;

  end;
  
end;

local function get_armies_total_cost(faction)
  local force_list = faction:military_force_list();
  local armies_total_cost = 0
  local army_cost = 0

  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
      armies_total_cost = armies_total_cost + army_cost
      if army_cost < max_balance_per_army then
        army_cost = army_cost + 1
      end;
    end; --of army check
  end; --of army call
  SRWLOG("total army cost is"..tostring(armies_total_cost))
  return armies_total_cost
end;


local function get_main_building_cost(building, faction)
  local main_building_level = building:building_level()
  local main_building_superchain = building:superchain()
  local culture = faction:culture()

  if gates_superchain[main_building_superchain] then
    return 1
  end;

  if culture == "wh_dlc05_wef_wood_elves" then
    if wood_elves_trees[main_building_superchain] then
      return 1
    else
      return 0
    end
  end;

  if main_building_level == 5 then
    return 3
  elseif main_building_level == 4 then
    return 2
  else
    return 1
  end
end
local function get_building_var(faction)
  local supply_form_regions = 0
  local owned_regions = faction:region_list()
  --loop through regions
  for i=0, owned_regions:num_items()-1 do

    local slot_list = owned_regions:item_at(i):slot_list()

    for j=0, slot_list:num_items()-1 do
      if not slot_list:is_empty() then
        if slot_list:item_at(j):has_building() then
          local building = slot_list:item_at(j):building()
          local building_name = building:name()

          if(j == 0) then
            supply_form_regions = supply_form_regions - get_main_building_cost(building, faction)
          end;

          if building_unit_bonus[building_name] then
            supply_form_regions = supply_form_regions + math.min(building_unit_bonus[building_name], max_balance_per_buildings)
          end            
        end
      end
    end
  end

  return supply_form_regions
end
local function get_supply_balance(faction)

  if not enable_supply_balance then
    return 0
  end;

  local army_supply = get_armies_total_cost(faction)
  local region_supply = get_building_var(faction)
  
  return region_supply - army_supply
end

local function calculate_supply_balance(faction)
  remove_supply_balance_effect(faction)

  local supply_balance = get_supply_balance(faction)

  if supply_balance > 0 then
    apply_supply_balance_effect(faction, supply_balance)
  end
end

local function get_supply_penalty(faction)
  local supply_balance = get_supply_balance(faction)

  if supply_balance >= 0 then
    return 0
  end

  local force_list = faction:military_force_list();
  local num_of_armies = get_army_count(force_list)
  supply_balance = 0 - supply_balance

  return math.ceil(supply_balance/math.sqrt(num_of_armies))

end
local function calculate_army_supply(unit_list, commander)
  local this_army_supply = basic_lord_supply;
  local character = commander:character_subtype_key()
  SRWLOG("--------");
  SRWLOG("Lord of this army is "..tostring(character));

  for j = 0, unit_list:num_items() - 1 do
    local unit = unit_list:item_at(j);
    local key = unit:unit_key();
    local val = get_unit_supply(key);

    if val == nil then
      val = calculate_unit_supply(unit)
    end;

    if SRW_Free_Units[key.."-"..character] ~= nil then
      val = SRW_Free_Units[key.."-"..character] + basic_unit_supply;
      SRWLOG(tostring(key).." REQUIRES "..val.."SP IN ARMY OF "..tostring(character));
    end

    if SRW_Lord_Group[character] then
      local name = SRW_Lord_Group[character]

      if SRW_Lord_Skills_Cost[key.."-"..name] ~= nil then
        local bonus_skill = SRW_Lord_Skills_Cost[key.."-"..name][1]
        local bonus_skill2 = SRW_Lord_Skills_Cost[key.."-"..name][3] or "srw_skill"

        if commander:has_skill(bonus_skill) or commander:has_skill(bonus_skill2) then
          val = SRW_Lord_Skills_Cost[key.."-"..name][2] + basic_unit_supply;
          SRWLOG(tostring(name).." HAS "..tostring(bonus_skill).." SO "..tostring(key).." REQUIRES "..val);
        end

      end --of skill in db check
    end --of lord in db check

    if val < 0 then
      val = 0
    end

    this_army_supply = this_army_supply + val;
  end; --of units circle
  
  SRWLOGDEBUG("[]CALCULATION SUPPLY FOR THIS ARMY IS FINISHED");
  return this_army_supply
end;


local function srw_calculate_upkeep(force, supply_penalty)
  local multiplier = srw_get_diff_mult();
  local unit_list = force:unit_list();
  local character = force:general_character();

  remove_effect(force)

  local effect_strength = calculate_army_supply(unit_list, character) + supply_penalty;
  SRWLOG("THIS ARMY REQUIRED "..tostring(effect_strength).." SUPPLY POINTS");
  effect_strength = math.floor(effect_strength*multiplier/24);

  if effect_strength > 0 then
    apply_effect(effect_strength, force)
  end;

  SRWLOGDEBUG("[]CALCULATION UPKEEP FOR THIS ARMY IS FINISHED");
  
end;

local function srw_apply_upkeep_penalty(faction)
  local supply_penalty = get_supply_penalty(faction)

  if faction:is_human() then
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
        SRWLOG("--------");
        SRWLOG("CHECK ARMY #"..tostring(i));
        srw_calculate_upkeep(force, supply_penalty)
      end; --of army check

    end; --of army call

  end; -- of check local faction
  
  SRWLOGDEBUG("[]CALCULATION SUPPLY FOR THIS fACTION IS FINISHED");
end; -- of function

local function srw_remove_upkeep_penalty(faction)
  if faction:is_human() then
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if not force:is_armed_citizenry() and force:has_general() then
        SRWLOG("--------");
        SRWLOG("CHECK ARMY #"..tostring(i));
        remove_effect(force)
      end; --of army check

    end; --of army call

  end; -- of local faction
  
  SRWLOGDEBUG("[]REMOVE SUPPLY FOR THIS fACTION IS FINISHED");
end; -- of function


--single army version of script
local function srw_this_army_upkeep(force)

  if force:faction():is_human() and not force:general_character():character_subtype("wh2_main_def_black_ark") then

    srw_calculate_upkeep(force, 0)
  end; -- of local faction

end;

local function localizator(string)
  local langfile, err = io.open("data/language.txt","r")
  if langfile then
    local lang = langfile:read()
    langfile:close()
    local local_string = string
    if lang == "RU" then 
      local_string = string.."_ru"
    end
    return effect.get_localised_string(local_string)
  else
    return effect.get_localised_string(string)
  end
end;


local function get_unknown_text()
  local unknown_text = localizator("SRW_unit_supply_cost_unknown")
  for n = 0, 4 do
    local this_price_supply = n + basic_unit_supply
    if this_price_supply < 0 then
      this_price_supply = 0
    end
    unknown_text = string.gsub(unknown_text, "SRW_Cost_"..n, tostring(this_price_supply))
  end;
  return unknown_text
end;


local function set_supply_text(cost, is_basic_value)

  if is_basic_value then
    if cost <= 0 then
      return localizator("SRW_unit_supply_cost_zero")
    elseif cost == 1 then
      return localizator("SRW_unit_supply_cost_one")
    else
      local imported_text = localizator("SRW_unit_supply_cost_many")
      return string.gsub(imported_text, "SRW_Cost", tostring(cost))    
    end
  else
    if cost <= 0 then
      return localizator("SRW_unit_supply_cost_lord")
    elseif cost == 1 then
      return localizator("SRW_unit_supply_cost_lord_one")
    else
      local imported_text = localizator("SRW_unit_supply_cost_lord_many")
      return string.gsub(imported_text, "SRW_Cost", tostring(cost))    
    end
  end
  return get_unknown_text()
end

local function set_new_lord_tooltip(component, faction)
  if not enable_supply_balance then
    return
  end;

  local supply_balance = get_supply_balance(faction)

  local force_list = faction:military_force_list();
  local new_army_cost = get_army_count(force_list)

  local negative_balance = new_army_cost
  if supply_balance > 0 then
    negative_balance = new_army_cost - supply_balance
  end
  
  local num_of_armies = new_army_cost + 1
  local upkeep = math.ceil(negative_balance/math.sqrt(num_of_armies))*num_of_armies*srw_get_diff_mult()/24

  local tooltip_text = "Current supply balance is "..supply_balance.."\nNew army will decreace it by "..new_army_cost.."\nYour army upkeep will be increase by "..math.floor(upkeep)

  if is_uicomponent(component) then 
    component:SetTooltipText(tooltip_text, true)
  end;

end


local function set_tooltip_text_treasury(faction, component_name)
  SRWLOGDEBUG("--------");
  SRWLOGDEBUG("SET TREASURY TOOLTIP FUNCTION IS STARTED");

  local culture = faction:subculture();
  local component = find_uicomponent(core:get_ui_root(), component_name)
  local global_supply = 0
  local upkeep_percent = -1
  local dif_mod = srw_get_diff_mult();
  local force_list = faction:military_force_list();
  local dummy_text = "SRW_dummy_text"
  local lord_text_key = SRW_Subculture_Text[culture] or dummy_text
  local lord_text = localizator(lord_text_key)
  local supply_balance = get_supply_balance(faction)
  local supply_penalty = get_supply_penalty(faction)

  -- calculate supply and upkeep
  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
      local unit_list = force:unit_list();
      local character = force:general_character();

      local army_supply = calculate_army_supply(unit_list, character) + supply_penalty;

      local army_upkeep_effect = math.floor(army_supply*dif_mod/24)
      global_supply = global_supply + army_supply
      upkeep_percent = upkeep_percent + math.min(army_upkeep_effect, max_supply_per_army) + 1
    end; --of army check
  end; --of army call
  if upkeep_percent < 0 then upkeep_percent = 0 end;

  --generate text

  if vfs.exists("script/campaign/main_warhammer/mod/mixu_le_bruckner.lua") then
    local mixu1_text = Mixu1_Subculture_Text[culture] or dummy_text
    lord_text = lord_text..localizator(mixu1_text)
  end;

  if vfs.exists("script/campaign/mod/mixu_darkhand.lua") then
    local mixu2_text = Mixu2_Subculture_Text[culture] or dummy_text
    lord_text = lord_text..localizator(mixu2_text)
  end;

  if vfs.exists("script/campaign/mod/cataph_kraka.lua") then
    local kraka_text = Kraka_Subculture_Text[culture] or dummy_text
    lord_text = lord_text..localizator(kraka_text)
  end;

  if vfs.exists("script/campaign/main_warhammer/mod/thom_vulkan.lua") then
    local vulcan_text = Vulcan_Subculture_Text[culture] or dummy_text
    lord_text = lord_text..localizator(vulcan_text)
  end;

  if vfs.exists("script/campaign/mod/ws_big_waaagh.lua") then
    local wez_text = Wez_Subculture_Text[culture] or dummy_text
    lord_text = lord_text..localizator(wez_text)
  end;

  local supply_text = localizator("SRW_treasury_tooltip_supply")
  supply_text = string.gsub(supply_text, "SRW_supply", tostring(global_supply))
  local supply_balance_text = "Your supply balance is "..supply_balance
  if not enable_supply_balance then
    supply_balance_text = ""
  end
  local tooltip_text = localizator("SRW_treasury_tooltip_main")..lord_text..supply_text..localizator("SRW_treasury_tooltip_upkeep")..tostring(upkeep_percent).."%\n"..supply_balance_text

  if srw_faction_is_horde(faction) then
    tooltip_text = localizator("SRW_Subculture_Text_hordes")
  elseif culture == "wh2_dlc09_sc_tmb_tomb_kings" then
    tooltip_text = localizator("SRW_Subculture_Text_tomb_kings")
  elseif culture == "wh_main_sc_brt_bretonnia" then
    tooltip_text = localizator("SRW_Subculture_Text_bretonnia")
  elseif player_supply_custom_mult == 0 then
    tooltip_text = "Your units doesn`t need addition supply"
  end;

  --apply text
  component:SetTooltipText(tooltip_text, true)
  SRWLOGDEBUG("SET TREASURY TOOLTIP FUNCTION IS FINISHED");

end;


local function set_unit_tooltip(component, text)
  SRWLOGDEBUG("--------");
  SRWLOGDEBUG("SET UNIT TOOLTIP FUNCTION IS STARTED");

  local component_name = component:Id();
  local unit_name = string.gsub(component_name, text, "")
  local old_text = component:GetTooltipText();
  local unit_cost = get_unit_supply(unit_name)
  local is_basic_cost = true

  local selected_char = tostring(SRW_selected_character:character_subtype_key())

  if SRW_Free_Units[unit_name.."-"..selected_char] ~= nil then
    unit_cost = SRW_Free_Units[unit_name.."-"..selected_char] + basic_unit_supply  
    is_basic_cost = false
  end
  if SRW_Lord_Group[selected_char] then

    local name = SRW_Lord_Group[selected_char]
    if SRW_Lord_Skills_Cost[unit_name.."-"..name] ~= nil then
      
      local bonus_skill = SRW_Lord_Skills_Cost[unit_name.."-"..name][1]
      local bonus_skill2 = SRW_Lord_Skills_Cost[unit_name.."-"..name][3] or "srw_skill"
      if SRW_selected_character:has_skill(bonus_skill) or SRW_selected_character:has_skill(bonus_skill2) then
        is_basic_cost = false
        unit_cost = SRW_Lord_Skills_Cost[unit_name.."-"..name][2] + basic_unit_supply;      
      end
    end
  end

  SRWLOGDEBUG("SET SUPPLY TEXT FUNCTION IS STARTED");
  local supply_text
  if unit_cost == nil then
    supply_text = get_unknown_text()
  else
    supply_text = set_supply_text(unit_cost, is_basic_cost)
  end
  SRWLOGDEBUG("SET SUPPLY TEXT FUNCTION IS FINISHED");


  if string.find(old_text, supply_text) then return end
  local final_text = string.gsub(old_text, "\n", "\n[[col:yellow]]"..supply_text.."[[/col]]\n", 1)
  if is_uicomponent(component) then 
    component:SetTooltipText(final_text, true)
  end;
  SRWLOGDEBUG("SET UNIT TOOLTIP FUNCTION IS FINISHED");
end;

local function calculate_army_supply_AI(unit_list, character)
  local this_army_supply = basic_lord_supply;

  for j = 0, unit_list:num_items() - 1 do
    local unit = unit_list:item_at(j);
    local key = unit:unit_key();
    local val = get_unit_supply(key) or calculate_unit_supply(unit);
    if val < 0 then
      val = 0
    end;
    this_army_supply = this_army_supply + val;
  end; --units

  return this_army_supply
end;

local function srw_calculate_upkeep_AI(force)
  local unit_list = force:unit_list();
  local character = force:general_character():character_subtype_key();

  remove_effect(force, true)

  if ai_supply_mult > 0 then
    local effect_strength = calculate_army_supply_AI(unit_list, character);
    SRWLOGAI("THIS ARMY HAS "..tostring(unit_list:num_items()).." UNITS");
    SRWLOGAI("THIS ARMY REQUIRED "..tostring(effect_strength).." SUPPLY POINTS");
    effect_strength = math.floor(effect_strength*ai_supply_mult/24);
    if effect_strength > 0 then
      apply_effect(effect_strength, force, true)
      SRWLOGAI("APPLY EFFECT: +"..tostring(effect_strength).."% TO UPKEEP");
    end;
  end
end;


local function srw_apply_upkeep_penalty_AI(faction)
  if not faction:is_human() then
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if not force:is_armed_citizenry() and force:has_general() then
        SRWLOGAI("--------");
        SRWLOGAI("CHECK ARMY #"..tostring(i));
        srw_calculate_upkeep_AI(force)
        SRWLOGDEBUG("CALCULATION SUPPLY FOR THIS ARMY IS FINISHED");
      end; --of army check
    end; --of army call
  end; -- of local faction
end; -- of function


core:add_listener(
  "SRW_FactionTurnStart_ai",
  "FactionTurnStart",
  function(context)
    local faction = context:faction()
    return (not faction:is_human() and not srw_faction_is_horde(faction) and not (faction:culture() == "wh2_dlc09_tmb_tomb_kings"))
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


local function factionChecker(faction)
  local culture = faction:culture()
  if not faction:is_human() then
    return false
  end
  if srw_faction_is_horde(faction) then
    return false
  end
  if culture == "wh_main_brt_bretonnia" and not bretonnia_supply then
    return false
  end
  if culture == "wh2_dlc09_tmb_tomb_kings" then
    return false
  end
  return true
end;


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


function set_value_from_mcm(name, variable)
  local mct = context:mct()
  local supply_lines_rw = mct:get_mod_by_key("supply_lines_rw")

  local mcm_setting = supply_lines_rw:get_option_by_key(name)
  variable =  mcm_setting:get_finalized_setting()

  return mcm_setting
end
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
  end
  
  SRWLOGDEBUG("Player supply now is "..tostring(player_supply_custom_mult));
  srw_apply_upkeep_penalty(faction);

end;


core:add_listener(
    "supply_lines_mct",
    "MctInitialized",
    true,
    function(context)

      init_mcm(context)
    end,
    true
)



core:add_listener(
    "supply_lines_MctFinalized",
    "MctFinalized",
    true,
    function(context)
      init_mcm(context)
    end,
    true
)


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