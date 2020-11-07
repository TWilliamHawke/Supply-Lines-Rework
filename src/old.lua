--logging function.
local function SRWLOG(text)
  if not __write_output_to_logfile then
    return;
  end

  local logText = tostring(text)
  local logTimeStamp = os.date("%d, %m %Y %X")
  local popLog = io.open("supply_rework_log.txt","a")
  --# assume logTimeStamp: string
  popLog :write("SUPPLY REWORK:  [".. logTimeStamp .. "]:  "..logText .. "  \n")
  popLog :flush()
  popLog :close()
end

local function SRWNEWLOG()
  if not (__write_output_to_logfile or __enable_jadlog) then
    return;
  end
  local logTimeStamp = os.date("%d, %m %Y %X")
  --# assume logTimeStamp: string

  local popLog = io.open("supply_rework_log.txt","w+")
  popLog :write("NEW LOG ["..logTimeStamp.."] \n")
  popLog :flush()
  popLog :close() 
end
SRWNEWLOG()

local SRW_selected_character = nil;

local SRW_Free_Units = {
--Empire

  ["wh_main_emp_inf_greatswords-emp_karl_franz"] = 1,
  ["wh_main_emp_cav_reiksguard-emp_karl_franz"] = 1,
  ["wh_dlc04_emp_cav_zintlers_reiksguard_0-emp_karl_franz"] = 1,
  ["wh2_dlc13_emp_cav_reiksguard_imperial_supply-emp_karl_franz"] = 1,
  ["wh2_dlc13_emp_inf_greatswords_imperial_supply-emp_karl_franz"] = 1,
  ["wh2_dlc13_emp_inf_greatswords_ror_0-emp_karl_franz"] = 1,
  ["wh2_dlc13_emp_inf_huntsmen_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 1,
  ["wh2_dlc13_emp_inf_huntsmen_0_imperial_supply-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 1,
  ["wh2_dlc13_emp_inf_huntsmen_ror_0-wh2_dlc13_emp_cha_markus_wulfhart_0"] = 1,
  --mixu
  ["wh_main_emp_cav_reiksguard-emp_marius_leitdorf"] = 1,
  ["wh_main_emp_cav_empire_knights-emp_marius_leitdorf"] = 1,
  ["wh_dlc04_emp_cav_zintlers_reiksguard_0-emp_marius_leitdorf"] = 1,
  ["wh_dlc04_emp_cav_knights_blazing_sun_0-emp_marius_leitdorf"] = 1,
  ["wh2_dlc13_emp_cav_empire_knights_ror_0-emp_marius_leitdorf"] = 1,
  ["wh2_dlc13_emp_cav_empire_knights_ror_1-emp_marius_leitdorf"] = 1,
  ["wh2_dlc13_emp_cav_empire_knights_ror_2-emp_marius_leitdorf"] = 1,
  ["wh2_dlc13_emp_cav_reiksguard_imperial_supply-emp_marius_leitdorf"] = 1,
  ["wh2_dlc13_emp_cav_empire_knights_imperial_supply-emp_marius_leitdorf"] = 1,
  ["wh2_dlc13_emp_cav_knights_blazing_sun_0_imperial_supply-emp_marius_leitdorf"] = 1,
  ["wh_main_emp_inf_handgunners-emp_aldebrand_ludenhof"] = 1,
  ["wh_dlc04_emp_inf_silver_bullets_0-emp_aldebrand_ludenhof"] = 1,
  ["wh2_dlc13_emp_inf_handgunners_ror_0-emp_aldebrand_ludenhof"] = 1,
  ["wh2_dlc13_emp_inf_handgunners_imperial_supply-emp_aldebrand_ludenhof"] = 1,
  ["emp_long_rifles-emp_aldebrand_ludenhof"] = 1,
  ["emp_nuln_ironsides-emp_aldebrand_ludenhof"] = 1,
  ["wh_dlc04_emp_inf_silver_bullets_0-dlc03_emp_boris_todbringer"] = 1,
  ["wh_main_emp_inf_handgunners-dlc03_emp_boris_todbringer"] = 1,
  ["wh_main_emp_inf_halberdiers-dlc03_emp_boris_todbringer"] = 1,
  ["wh2_dlc13_emp_inf_halberdiers_imperial_supply-dlc03_emp_boris_todbringer"] = 1,
  ["wh2_dlc13_emp_inf_halberdiers_ror_0-dlc03_emp_boris_todbringer"] = 1,
  ["wh2_dlc13_emp_inf_handgunners_imperial_supply-dlc03_emp_boris_todbringer"] = 1,
  ["wh2_dlc13_emp_inf_handgunners_ror_0-dlc03_emp_boris_todbringer"] = 1,
  ["wh_dlc04_emp_inf_silver_bullets_0-dlc03_emp_boris_todbringer"] = 1,
  ["wh_main_emp_inf_halberdiers-emp_valmir_von_raukov"] = 1,
  ["wh2_dlc13_emp_inf_halberdiers_ror_0-emp_valmir_von_raukov"] = 1,
  ["wh2_dlc13_emp_inf_halberdiers_imperial_supply-emp_valmir_von_raukov"] = 1,
  ["wh2_dlc13_emp_cav_demigryph_knights_0_imperial_supply-emp_helmut_feuerbach"] = 1,
  ["wh2_dlc13_emp_cav_demigryph_knights_1_imperial_supply-emp_helmut_feuerbach"] = 1,
  ["wh2_dlc13_emp_veh_steam_tank_imperial_supply-emp_helmut_feuerbach"] = 1,
  ["wh_main_emp_cav_demigryph_knights_0-emp_helmut_feuerbach"] = 1,
  ["wh_main_emp_cav_demigryph_knights_1-emp_helmut_feuerbach"] = 1,
  ["wh_dlc04_emp_cav_royal_altdorf_gryphites_0-emp_helmut_feuerbach"] = 1,
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
  ["wh2_dlc13_emp_inf_huntsmen_ror_0-emp_edward_van_der_kraal"] = 1,
  ["wh2_dlc13_emp_inf_archers_ror_0-emp_edward_van_der_kraal"] = 1,
  ["wh_dlc04_emp_inf_sigmars_sons_0-emp_edward_van_der_kraal"] = 1,
  ["wh_dlc04_emp_inf_stirlands_revenge_0-emp_edward_van_der_kraal"] = 1,
  ["wh_dlc04_emp_inf_tattersouls_0-emp_edward_van_der_kraal"] = 1,
  ["wh_dlc04_emp_inf_silver_bullets_0-emp_edward_van_der_kraal"] = 1,
  ["wh_dlc04_emp_cav_zintlers_reiksguard_0-emp_edward_van_der_kraal"] = 1,
  ["wh2_dlc13_emp_veh_war_wagon_ror_0-emp_edward_van_der_kraal"] = 1,
  ["wh_dlc04_emp_art_hammer_of_the_witches_0-emp_edward_van_der_kraal"] = 1,
  ["wh_dlc04_emp_art_sunmaker_0-emp_edward_van_der_kraal"] = 1,
  ["wh_dlc04_emp_veh_templehof_luminark_0-emp_edward_van_der_kraal"] = 1,
  ["wh_dlc04_emp_cav_royal_altdorf_gryphites_0-emp_edward_van_der_kraal"] = 1,
  ["wh_main_emp_inf_greatswords-mixu_katarin_the_ice_queen"] = 1,

--Dwarves
  ["wh_main_dwf_inf_slayers-dwf_ungrim_ironfist"] = 1,
  ["wh2_dlc10_dwf_inf_giant_slayers-dwf_ungrim_ironfist"] = 1,
  ["wh_dlc06_dwf_inf_dragonback_slayers_0-dwf_ungrim_ironfist"] = 1,
  ["wh_main_dwf_inf_hammerers-dwf_thorgrim_grudgebearer"] = 1,
  ["wh_main_dwf_inf_longbeards-dwf_thorgrim_grudgebearer"] = 1,
  ["wh_main_dwf_inf_longbeards_1-dwf_thorgrim_grudgebearer"] = 1,
  ["wh_dlc06_dwf_inf_old_grumblers_0-dwf_thorgrim_grudgebearer"] = 1,
  ["wh_dlc06_dwf_inf_peak_gate_guard_0-dwf_thorgrim_grudgebearer"] = 1,
  ["wh_main_dwf_inf_ironbreakers-dwf_kazador_dragonslayer"] = 1,
  ["wh_dlc06_dwf_inf_norgrimlings_ironbreakers_0-dwf_kazador_dragonslayer"] = 1,
  ["dwf_huskarls-dwf_kraka_drak"] = 1,
  
--Vampire Counts
  ["wh_dlc04_vmp_inf_sternsmen_0-vmp_mannfred_von_carstein"] = 1,
  ["wh_main_vmp_inf_grave_guard_0-vmp_mannfred_von_carstein"] = 1,
  ["wh_main_vmp_inf_grave_guard_1-vmp_mannfred_von_carstein"] = 1,
  ["wh_main_vmp_cav_black_knights_0-vmp_mannfred_von_carstein"] = 1,
  ["wh_main_vmp_cav_black_knights_3-vmp_mannfred_von_carstein"] = 1,
  ["wh_dlc04_vmp_cav_vereks_reavers_0-vmp_mannfred_von_carstein"] = 1,
--Greenskins
  ["wh_main_grn_inf_black_orcs-grn_grimgor_ironhide"] = 1,
  ["wh_main_grn_inf_orc_big_uns-grn_grimgor_ironhide"] = 1,
  ["wh_main_grn_cav_orc_boar_boy_big_uns-grn_grimgor_ironhide"] = 1,
  ["wh_dlc06_grn_inf_krimson_killerz_0-grn_grimgor_ironhide"] = 1,
  ["wh_main_grn_inf_night_goblins-dlc06_grn_skarsnik"] = 1,
  ["wh_dlc06_grn_cav_squig_hoppers_0-dlc06_grn_skarsnik"] = 1,
  ["wh_dlc06_grn_inf_da_warlords_boyz_0-dlc06_grn_skarsnik"] = 1,
  ["wh_main_grn_inf_night_goblin_archers-dlc06_grn_skarsnik"] = 1,
  ["wh_main_grn_inf_night_goblin_fanatics-dlc06_grn_skarsnik"] = 1,
  ["wh_dlc06_grn_inf_da_rusty_arrers_0-dlc06_grn_skarsnik"] = 1,
  ["wh_main_grn_inf_night_goblin_fanatics_1-dlc06_grn_skarsnik"] = 1,
  ["wh_dlc06_grn_inf_da_eight_peaks_loonies_0-dlc06_grn_skarsnik"] = 1,
  ["wh_main_grn_inf_savage_orc_big_uns-dlc06_grn_wurrzag_da_great_prophet"] = 1,
  ["wh_main_grn_cav_savage_orc_boar_boy_big_uns-dlc06_grn_wurrzag_da_great_prophet"] = 1,
  ["grn_black_orc_shields-grn_grimgor_ironhide"] = 1,
  ["grn_savage_big_great-dlc06_grn_wurrzag_da_great_prophet"] = 1,
--Wood Elves
  ["wh_dlc05_wef_cav_wild_riders_0-dlc05_wef_orion"] = 1,
  ["wh_dlc05_wef_cav_wild_riders_1-dlc05_wef_orion"] = 1,
  ["wh_dlc05_wef_cav_sisters_thorn_0-dlc05_wef_orion"] = 1,
  ["wh_pro04_wef_cav_wild_riders_ror_0-dlc05_wef_orion"] = 1,
  ["wh_dlc05_wef_mon_treekin_0-dlc05_wef_durthu"] = 1,
  ["wh_dlc05_wef_mon_treeman_0-dlc05_wef_durthu"] = 1,
  ["wh_pro04_wef_mon_treekin_ror_0-dlc05_wef_durthu"] = 1,
  ["wh_dlc05_wef_cav_hawk_riders_0-wef_naieth_the_prophetess"] = 1,
  ["wh_dlc05_wef_mon_great_eagle_0-wef_naieth_the_prophetess"] = 1,
  ["wh_dlc05_wef_cav_sisters_thorn_0-wef_naieth_the_prophetess"] = 1,
  ["wh_pro04_wef_inf_waywatchers_ror_0-wef_daith"] = 1,
  ["wh_dlc05_wef_inf_deepwood_scouts_1-wef_daith"] = 1,
  ["wh_dlc05_wef_inf_deepwood_scouts_1_qb-wef_daith"] = 1,
  ["wh_dlc05_wef_inf_waywatchers_0-wef_daith"] = 1,

  -- ["wef_daith"] =						"mixu_defeated_trait_wef_daith"
  --wef_naieth_the_prophetess
--Norsca
  ["wh_dlc08_nor_inf_marauder_champions_0-wh_dlc08_nor_wulfrik"] = 1,
  ["wh_dlc08_nor_inf_marauder_champions_1-wh_dlc08_nor_wulfrik"] = 1,
  ["wh_dlc08_nor_mon_norscan_ice_trolls_0-wh_dlc08_nor_throgg"] = 1,
  ["nor_whaler-wh_dlc08_nor_wulfrik"] = 1,
--Hight Elves
  ["wh2_main_hef_cav_silver_helms_0-wh2_main_hef_tyrion"] = 1,
  ["wh2_main_hef_cav_silver_helms_1-wh2_main_hef_tyrion"] = 1,
  ["wh2_dlc10_hef_inf_shadow_walkers_0-wh2_dlc10_hef_alith_anar"] = 1,
  ["wh2_main_hef_inf_white_lions_of_chrace_0-wh2_main_hef_prince_alastar"] = 1,
  ["wh2_dlc10_hef_inf_the_silverpelts_ror_0-wh2_main_hef_prince_alastar"] = 1,
  ["wh2_dlc10_hef_inf_sisters_of_avelorn_0-wh2_dlc10_hef_alarielle"] = 1,
  --mixu
  ["wh2_main_hef_mon_moon_dragon-hef_prince_imrik"] = 1,
  ["wh2_main_hef_mon_star_dragon-hef_prince_imrik"] = 1,
  ["wh2_main_hef_mon_sun_dragon-hef_prince_imrik"] = 1,
  ["wh2_main_hef_cav_dragon_princes-hef_prince_imrik"] = 1,
  ["wh2_dlc10_hef_cav_the_fireborn_ror_0-hef_prince_imrik"] = 1,
  ["wh2_main_hef_inf_white_lions_of_chrace_0-hef_korhil"] = 1,
  ["wh2_dlc10_hef_inf_the_silverpelts_ror_0-hef_korhil"] = 1,
  ["wh2_main_hef_inf_swordmasters_of_hoeth_0-hef_belannaer"] = 1,
  ["wh2_main_hef_inf_phoenix_guard-hef_bloodline_caradryan"] = 1,
  ["wh2_main_hef_mon_phoenix_flamespyre-hef_bloodline_caradryan"] = 1,
  ["wh2_main_hef_mon_phoenix_frostheart-hef_bloodline_caradryan"] = 1,
  ["wh2_dlc10_hef_inf_keepers_of_the_flame_ror_0-hef_bloodline_caradryan"] = 1,

--Dark elves
  ["wh2_main_def_inf_black_guard_0-wh2_main_def_malekith"] = 1,
  ["wh2_main_def_inf_black_ark_corsairs_0-wh2_dlc11_def_lokhir"] = 1,
  ["wh2_main_def_inf_black_ark_corsairs_1-wh2_dlc11_def_lokhir"] = 1,
  ["wh2_main_def_inf_witch_elves_0-wh2_dlc10_def_crone_hellebron"] = 1,
  ["wh2_dlc10_def_inf_sisters_of_slaughter-wh2_dlc10_def_crone_hellebron"] = 1,
  ["wh2_main_def_inf_har_ganeth_executioners_0-wh2_dlc10_def_crone_hellebron"] = 1,
  ["wh2_dlc10_def_inf_blades_of_the_blood_queen_ror_0-wh2_dlc10_def_crone_hellebron"] = 1,
  ["wh2_dlc10_def_inf_sisters_of_the_singing_doom_ror_0-wh2_dlc10_def_crone_hellebron"] = 1,
  ["wh2_main_def_cav_cold_one_chariot-wh2_dlc14_def_malus_darkblade"] = 1,
  ["wh2_main_def_cav_cold_one_knights_0-wh2_dlc14_def_malus_darkblade"] = 1,
  ["wh2_main_def_cav_cold_one_knights_1-wh2_dlc14_def_malus_darkblade"] = 1,
  ["wh2_dlc10_def_cav_knights_of_the_ebon_claw_ror_0-wh2_dlc14_def_malus_darkblade"] = 1,
  ["wh2_main_def_inf_witch_elves_0-def_tullaris_dreadbringer"] = 1,
  ["wh2_main_def_inf_har_ganeth_executioners_0-def_tullaris_dreadbringer"] = 1,
  ["wh2_dlc10_def_inf_blades_of_the_blood_queen_ror_0-def_tullaris_dreadbringer"] = 1,
  ["wh2_dlc10_def_inf_sisters_of_the_singing_doom_ror_0-def_tullaris_dreadbringer"] = 1,

--Lizardmen
  ["wh2_main_lzd_cav_cold_ones_1-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_cav_horned_ones_0-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_cav_cold_one_spearmen_1-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_cav_horned_ones_blessed_0-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_dlc12_lzd_cav_cold_one_spearriders_ror_0-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_cav_cold_one_spearriders_blessed_0-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_inf_saurus_spearmen_0-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_inf_saurus_spearmen_1-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_inf_saurus_warriors_0-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_inf_saurus_warriors_1-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_dlc12_lzd_inf_saurus_warriors_ror_0-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_inf_saurus_spearmen_blessed_1-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_inf_saurus_warriors_blessed_1-wh2_main_lzd_kroq_gar"] = 1,
  ["wh2_main_lzd_inf_temple_guards-wh2_main_lzd_lord_mazdamundi"] = 1,
  ["wh2_dlc12_lzd_inf_temple_guards_ror_0-wh2_main_lzd_lord_mazdamundi"] = 1,
  ["wh2_main_lzd_inf_temple_guards_blessed-wh2_main_lzd_lord_mazdamundi"] = 1,
  ["wh2_main_lzd_cav_terradon_riders_1-wh2_dlc12_lzd_tiktaqto"] = 1,
  ["wh2_dlc12_lzd_cav_terradon_riders_ror_0-wh2_dlc12_lzd_tiktaqto"] = 1,
  ["wh2_dlc12_lzd_cav_ripperdactyl_riders_0-wh2_dlc12_lzd_tiktaqto"] = 1,
  ["wh2_dlc12_lzd_cav_terradon_riders_1_tlaqua-wh2_dlc12_lzd_tiktaqto"] = 1,
  ["wh2_main_lzd_cav_terradon_riders_blessed_1-wh2_dlc12_lzd_tiktaqto"] = 1,
  ["wh2_dlc12_lzd_cav_ripperdactyl_riders_ror_0-wh2_dlc12_lzd_tiktaqto"] = 1,
  ["wh2_dlc12_lzd_mon_salamander_pack_ror_0-lzd_tetto_eko"] = 1,
  ["wh2_dlc12_lzd_mon_salamander_pack_0-lzd_tetto_eko"] = 1,
  ["wh2_dlc12_lzd_mon_ancient_salamander_0-lzd_tetto_eko"] = 1,
  ["wh2_main_lzd_inf_chameleon_skinks_0-lzd_oxyotl"] = 1,
  ["wh2_main_lzd_inf_chameleon_skinks_blessed_0-lzd_oxyotl"] = 1,
  ["wh2_main_lzd_inf_saurus_spearmen_0-wh2_dlc13_lzd_gor_rok"] = 1,
  ["wh2_main_lzd_inf_saurus_spearmen_1-wh2_dlc13_lzd_gor_rok"] = 1,
  ["wh2_main_lzd_inf_saurus_warriors_0-wh2_dlc13_lzd_gor_rok"] = 1,
  ["wh2_main_lzd_inf_saurus_warriors_1-wh2_dlc13_lzd_gor_rok"] = 1,
  ["wh2_dlc12_lzd_inf_saurus_warriors_ror_0-wh2_dlc13_lzd_gor_rok"] = 1,
  ["wh2_main_lzd_inf_saurus_spearmen_blessed_1-wh2_dlc13_lzd_gor_rok"] = 1,
  ["wh2_main_lzd_inf_saurus_warriors_blessed_1-wh2_dlc13_lzd_gor_rok"] = 1,
  ["wh2_main_lzd_mon_kroxigors-wh2_dlc13_lzd_nakai"] = 1,
  ["wh2_main_lzd_mon_kroxigors_blessed-wh2_dlc13_lzd_nakai"] = 1,
  ["wh2_dlc13_lzd_mon_sacred_kroxigors_0-wh2_dlc13_lzd_nakai"] = 1,
  ["wh2_dlc13_lzd_mon_sacred_kroxigors_0_nakai-wh2_dlc13_lzd_nakai"] = 1,
  ["wh2_dlc13_lzd_mon_sacred_kroxigors_ror_0-wh2_dlc13_lzd_nakai"] = 1,

--Skaven
  ["wh2_main_skv_inf_stormvermin_0-wh2_main_skv_queek_headtaker"] = 1,
  ["wh2_main_skv_inf_stormvermin_1-wh2_main_skv_queek_headtaker"] = 1,
  ["wh2_dlc12_skv_inf_clanrats_ror_0-wh2_main_skv_queek_headtaker"] = 1,
  ["wh2_dlc12_skv_inf_stormvermin_ror_0-wh2_main_skv_queek_headtaker"] = 1,
  ["wh2_main_skv_art_plagueclaw_catapult-wh2_main_skv_lord_skrolk"] = 1,
  ["wh2_main_skv_inf_plague_monks-wh2_main_skv_lord_skrolk"] = 1,
  ["wh2_main_skv_inf_plague_monk_censer_bearer-wh2_main_skv_lord_skrolk"] = 1,
  ["wh2_dlc12_skv_inf_plague_monk_censer_bearer_ror_0-wh2_main_skv_lord_skrolk"] = 1,
  ["wh2_dlc12_skv_inf_ratling_gun_0-wh2_dlc12_skv_ikit_claw"] = 1,
  ["wh2_dlc12_skv_inf_ratling_gun_ror_0-wh2_dlc12_skv_ikit_claw"] = 1,
  ["wh2_main_skv_inf_warpfire_thrower-wh2_dlc12_skv_ikit_claw"] = 1,
  ["wh2_dlc12_skv_inf_warplock_jezzails_0-wh2_dlc12_skv_ikit_claw"] = 1,
  ["wh2_dlc12_skv_inf_warplock_jezzails_ror_0-wh2_dlc12_skv_ikit_claw"] = 1,
  ["wh2_dlc12_skv_inf_ratling_gun_ror_tech_lab_0-wh2_dlc12_skv_ikit_claw"] = 1,
  ["wh2_dlc12_skv_inf_warpfire_thrower_ror_tech_lab_0-wh2_dlc12_skv_ikit_claw"] = 1,
  ["wh2_dlc12_skv_art_warplock_jezzails_ror_tech_lab_0-wh2_dlc12_skv_ikit_claw"] = 1,

--Vampire Coast
  ["wh2_dlc11_cst_inf_syreens-wh2_dlc11_cst_cylostra"] = 1,
  ["wh2_dlc11_cst_mon_mournguls_0-wh2_dlc11_cst_cylostra"] = 1,
  ["wh2_dlc11_cst_mon_mournguls_ror_0-wh2_dlc11_cst_cylostra"] = 1,
  ["wh2_dlc11_cst_mon_necrofex_colossus_0-wh2_dlc11_cst_noctilus"] = 1,
  ["wh2_dlc11_cst_mon_necrofex_colossus_ror_0-wh2_dlc11_cst_noctilus"] = 1,

  --Other LL
    -- dlc04_emp_volkmar
    -- emp_balthasar_gelt
    -- dlc06_dwf_belegar
    -- pro01_dwf_grombrindal
    -- dlc04_vmp_vlad_con_carstein
    -- dlc04_vmp_helman_ghorst
    -- pro02_vmp_isabella_von_carstein
    -- grn_azhag_the_slaughterer
    -- wh2_main_hef_teclis
    -- wh2_dlc10_hef_alarielle
    -- wh2_main_def_morathi
    -- wh2_dlc09_skv_tretch_craventail
    -- wh2_dlc11_cst_harkon
    -- wh2_dlc11_cst_aranessa
    -- wh2_dlc13_lzd_gor_rok

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
  ["wh2_dlc13_emp_inf_huntsmen_0"] = 1,
  ["wh2_dlc13_emp_veh_war_wagon_0"] = 1,
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
  ["wh2_dlc13_emp_veh_war_wagon_1_imperial_supply"] = 2,
  ["wh_main_emp_cav_reiksguard"] = 2,
  ["wh_dlc04_emp_cav_knights_blazing_sun_0"] = 2,
  -- elite
  ["wh2_dlc13_emp_veh_luminark_of_hysh_0_imperial_supply"] = 3,
  ["wh2_dlc13_emp_veh_war_wagon_1"] = 3,
  ["wh2_dlc13_huntmarshall_veh_obsinite_gyrocopter_0"] = 3,
  ["wh2_dlc13_emp_art_great_cannon_imperial_supply"] = 3,
  ["wh2_dlc13_emp_art_helblaster_volley_gun_imperial_supply"] = 3,
  ["wh2_dlc13_emp_art_helstorm_rocket_battery_imperial_supply"] = 3,
  ["wh_main_emp_art_great_cannon"] = 3,
  ["wh_main_emp_art_helblaster_volley_gun"] = 3,
  ["wh_main_emp_art_helstorm_rocket_battery"] = 3,
  ["wh_main_emp_art_mortar"] = 3,
  ["wh_main_emp_veh_luminark_of_hysh_0"] = 3,
  ["wh2_dlc13_emp_cav_demigryph_knights_0_imperial_supply"] = 4,
  ["wh2_dlc13_emp_cav_demigryph_knights_1_imperial_supply"] = 4,
  ["wh2_dlc13_emp_veh_steam_tank_imperial_supply"] = 4,
  ["wh_main_emp_cav_demigryph_knights_0"] = 4,
  ["wh_main_emp_cav_demigryph_knights_1"] = 4,
  ["wh_main_emp_veh_steam_tank"] = 4,
  --emp special
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
  ["wh2_dlc13_emp_veh_steam_tank_ror_0"] = 3, --sfo balance

  -- ROR
  ["wh2_dlc13_emp_inf_huntsmen_ror_0"] = 1,
  ["wh2_dlc13_emp_inf_archers_ror_0"] = 1,
  ["wh_dlc04_emp_inf_sigmars_sons_0"] = 1,
  ["wh_dlc04_emp_inf_stirlands_revenge_0"] = 1,
  ["wh_dlc04_emp_inf_tattersouls_0"] = 1,
  ["wh_dlc04_emp_inf_silver_bullets_0"] = 1,
  ["wh_dlc04_emp_cav_zintlers_reiksguard_0"] = 2,
  ["wh2_dlc13_emp_veh_war_wagon_ror_0"] = 3,
  ["wh_dlc04_emp_art_hammer_of_the_witches_0"] = 3,
  ["wh_dlc04_emp_art_sunmaker_0"] = 3,
  ["wh_dlc04_emp_veh_templehof_luminark_0"] = 3,
  ["wh_dlc04_emp_cav_royal_altdorf_gryphites_0"] = 4,
-- Dwarfs
  --core
  ["wh_main_dwf_inf_miners_0"] = 0,
  ["wh_main_dwf_inf_miners_1"] = 0,
  ["wh_dlc06_dwf_inf_rangers_0"] = 0,
  ["wh_main_dwf_inf_quarrellers_0"] = 0,
  ["wh_main_dwf_inf_quarrellers_1"] = 0,
  -- special
  ["wh_main_dwf_inf_slayers"] = 2,
  ["wh_main_dwf_inf_dwarf_warrior_0"] = 1,
  ["wh_main_dwf_inf_dwarf_warrior_1"] = 1,
  ["wh_dlc06_dwf_inf_bugmans_rangers_0"] = 1,
  ["wh_dlc06_dwf_inf_rangers_1"] = 1,
  ["wh_main_dwf_inf_thunderers_0"] = 1,
  -- rare
  ["wh_dlc06_dwf_art_bolt_thrower_0"] = 2,
  ["wh_main_dwf_inf_longbeards"] = 2,
  ["wh_main_dwf_inf_longbeards_1"] = 2,
  ["wh_main_dwf_art_grudge_thrower"] = 2,
  -- elite
  ["wh2_dlc10_dwf_inf_giant_slayers"] = 3,
  ["wh_main_dwf_veh_gyrocopter_1"] = 3,
  ["wh_main_dwf_inf_irondrakes_0"] = 3,
  ["wh_main_dwf_inf_irondrakes_2"] = 3,
  ["wh_main_dwf_veh_gyrobomber"] = 3,
  ["wh_main_dwf_veh_gyrocopter_0"] = 3,
  ["wh_main_dwf_art_cannon"] = 3,
  ["wh_main_dwf_art_flame_cannon"] = 3,
  ["wh_main_dwf_art_organ_gun"] = 3,
  ["wh_main_dwf_inf_hammerers"] = 3,
  ["wh_main_dwf_inf_ironbreakers"] = 4,
  -- ROR
  ["wh_dlc06_dwf_inf_ekrund_miners_0"] = 1,
  ["wh_dlc06_dwf_inf_warriors_dragonfire_pass_0"] = 1,
  ["wh_dlc06_dwf_inf_dragonback_slayers_0"] = 2,
  ["wh_dlc06_dwf_inf_ulthars_raiders_0"] = 1,
  ["wh_dlc06_dwf_inf_old_grumblers_0"] = 2,
  ["wh_dlc06_dwf_inf_norgrimlings_irondrakes_0"] = 3,
  ["wh_dlc06_dwf_veh_skyhammer_0"] = 3,
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

  -- special
  ["wh_main_grn_cav_orc_boar_chariot"] = 1,
  ["wh_dlc06_grn_cav_squig_hoppers_0"] = 1,
  ["wh_main_grn_cav_orc_boar_boy_big_uns"] = 1,
  ["wh_main_grn_cav_savage_orc_boar_boy_big_uns"] = 1,
  ["wh_main_grn_inf_night_goblin_fanatics"] = 1,
  ["wh_main_grn_inf_savage_orc_big_uns"] = 1,
  ["wh_main_grn_inf_night_goblins"] = 1,
  ["wh_main_grn_inf_orc_big_uns"] = 1,
  ["wh_main_grn_inf_night_goblin_archers"] = 1,
  ["wh_main_grn_inf_night_goblin_fanatics_1"] = 1,
  -- rare
  ["wh_main_grn_mon_trolls"] = 3,
  ["wh_main_grn_inf_black_orcs"] = 2,
  -- elite
  ["wh_main_grn_art_doom_diver_catapult"] = 3,
  ["wh_main_grn_art_goblin_rock_lobber"] = 3,
  ["wh_main_grn_mon_arachnarok_spider_0"] = 4,
  ["wh_main_grn_mon_giant"] = 4,
  -- ROR
  ["wh_dlc06_grn_cav_deff_creepers_0"] = 1,
  ["wh_dlc06_grn_cav_mogrubbs_marauders_0"] = 1,
  ["wh_dlc06_grn_cav_moon_howlers_0"] = 1,
  ["wh_dlc06_grn_cav_teef_robbers_0"] = 1,
  ["wh_dlc06_grn_cav_broken_tusks_mob_0"] = 1,
  ["wh_dlc06_grn_cav_durkits_squigs_0"] = 1,
  ["wh_dlc06_grn_inf_da_eight_peaks_loonies_0"] = 1,
  ["wh_dlc06_grn_inf_da_warlords_boyz_0"] = 1,
  ["wh_dlc06_grn_inf_da_rusty_arrers_0"] = 1,
  ["wh_dlc06_grn_inf_krimson_killerz_0"] = 2,
  ["wh_dlc06_grn_art_hammer_of_gork_0"] = 3,
  ["wh_dlc06_grn_mon_venom_queen_0"] = 4,
--Vampire counts
  ["wh_dlc04_vmp_veh_corpse_cart_0"] = 0,
  ["wh_dlc04_vmp_veh_corpse_cart_1"] = 0,
  ["wh_dlc04_vmp_veh_corpse_cart_2"] = 0,
  ["wh_main_vmp_inf_skeleton_warriors_0"] = 0,
  ["wh_main_vmp_inf_skeleton_warriors_1"] = 0,
  ["wh_main_vmp_inf_zombie"] = 0,
  ["wh_main_vmp_mon_dire_wolves"] = 0,
  ["wh_main_vmp_mon_fell_bats"] = 0,
  -- special
  ["wh_main_vmp_inf_crypt_ghouls"] = 1,
  ["wh_main_vmp_cav_black_knights_0"] = 1,
  ["wh_main_vmp_cav_black_knights_3"] = 1,
  -- rare
  ["wh_main_vmp_mon_crypt_horrors"] = 2,
  ["wh_main_vmp_inf_cairn_wraiths"] = 2,
  ["wh_main_vmp_inf_grave_guard_0"] = 2,
  ["wh_main_vmp_inf_grave_guard_1"] = 2,
  ["wh_main_vmp_mon_vargheists"] = 2,
  ["wh_main_vmp_veh_black_coach"] = 2,
  ["wh_dlc04_vmp_veh_mortis_engine_0"] = 2,
  -- elite
  ["wh_main_vmp_cav_hexwraiths"] = 3,
  ["wh_main_vmp_mon_varghulf"] = 3,
  ["wh_main_vmp_mon_terrorgheist"] = 3,
  ["wh_dlc02_vmp_cav_blood_knights_0"] = 4,
  -- ROR
  ["wh_dlc04_vmp_inf_feasters_in_the_dusk_0"] = 1,
  ["wh_dlc04_vmp_inf_konigstein_stalkers_0"] = 1,
  ["wh_dlc04_vmp_inf_tithe_0"] = 1,
  ["wh_dlc04_vmp_mon_direpack_0"] = 1,
  ["wh_dlc04_vmp_cav_vereks_reavers_0"] = 1,
  ["wh_dlc04_vmp_inf_sternsmen_0"] = 2,
  ["wh_dlc04_vmp_cav_chillgheists_0"] = 3,
  ["wh_dlc04_vmp_mon_devils_swartzhafen_0"] = 2,
  ["wh_dlc04_vmp_veh_claw_of_nagash_0"] = 2,
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
  ["wh_dlc05_wef_forest_dragon_0"] = 2,
  ["wh_dlc05_wef_mon_treeman_0"] = 2,
  -- ROR
  ["wh_pro04_wef_inf_eternal_guard_ror_0"] = 1,
  ["wh_pro04_wef_mon_treekin_ror_0"] = 2,
  ["wh_pro04_wef_cav_wild_riders_ror_0"] = 2,
  ["wh_pro04_wef_inf_wildwood_rangers_ror_0"] = 2,
  ["wh_pro04_wef_inf_waywatchers_ror_0"] = 2,
  
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
  -- special
  ["wh_dlc08_nor_veh_marauder_warwolves_chariot_0"] = 1,
  ["wh_main_nor_cav_chaos_chariot"] = 1,
  ["wh_dlc08_nor_mon_skinwolves_0"] = 1,
  ["wh_dlc08_nor_mon_skinwolves_1"] = 1,
  ["wh_dlc08_nor_inf_marauder_berserkers_0"] = 1,
  ["wh_dlc08_nor_feral_manticore"] = 1,
  ["wh_main_nor_mon_chaos_trolls"] = 1,
  --rare
  ["wh_dlc08_nor_inf_marauder_champions_0"] = 2,
  ["wh_dlc08_nor_inf_marauder_champions_1"] = 2,
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
  ["wh_pro04_nor_mon_marauder_warwolves_ror_0"] = 1,
  ["wh_pro04_nor_mon_skinwolves_ror_0"] = 1,
  ["wh_dlc08_nor_mon_war_mammoth_ror_1"] = 1,
  ["wh_pro04_nor_mon_fimir_ror_0"] = 1,
  ["wh_dlc08_nor_mon_frost_wyrm_ror_0"] = 2,
  ["wh_pro04_nor_mon_war_mammoth_ror_0"] = 2,
  ["wh_dlc08_nor_art_hellcannon_battery"] = 2,
  --============================================================
--Hight Elves
  ["wh2_main_hef_cav_ellyrian_reavers_0"] = 0,
  ["wh2_main_hef_cav_ellyrian_reavers_1"] = 0,
  ["wh2_main_hef_inf_archers_0"] = 0,
  ["wh2_main_hef_inf_archers_1"] = 0,
  ["wh2_main_hef_inf_spearmen_0"] = 0,
  -- special
  ["wh2_main_hef_inf_white_lions_of_chrace_0"] = 1,
  ["wh2_main_hef_inf_lothern_sea_guard_0"] = 1,
  ["wh2_main_hef_inf_lothern_sea_guard_1"] = 1,
  ["wh2_dlc10_hef_inf_shadow_warriors_0"] = 1,
  -- rare
  ["wh2_main_hef_mon_great_eagle"] = 2,
  ["wh2_main_hef_cav_silver_helms_0"] = 2,
  ["wh2_main_hef_cav_silver_helms_1"] = 2,
  ["wh2_dlc10_hef_inf_shadow_walkers_0"] = 2,
  ["wh2_dlc10_hef_mon_treekin_0"] = 2,
  ["wh2_main_hef_cav_ithilmar_chariot"] = 2,
  ["wh2_main_hef_cav_tiranoc_chariot"] = 2,
  ["wh2_main_hef_art_eagle_claw_bolt_thrower"] = 2,
  -- elite
  ["wh2_dlc10_hef_inf_sisters_of_avelorn_0"] = 3,
  ["wh2_main_hef_mon_sun_dragon"] = 3,
  ["wh2_main_hef_mon_phoenix_flamespyre"] = 3,
  ["wh2_main_hef_mon_phoenix_frostheart"] = 3,
  ["wh2_main_hef_inf_swordmasters_of_hoeth_0"] = 3,
  ["wh2_dlc10_hef_mon_treeman_0"] = 4,
  ["wh2_main_hef_mon_moon_dragon"] = 4,
  ["wh2_main_hef_mon_star_dragon"] = 4,
  ["wh2_main_hef_inf_phoenix_guard"] = 4,
  ["wh2_main_hef_cav_dragon_princes"] = 4,
  -- ROR
  ["wh2_dlc10_hef_inf_the_scions_of_mathlann_ror_0"] = 1,
  ["wh2_dlc10_hef_inf_the_silverpelts_ror_0"] = 1,
  ["wh2_dlc10_hef_cav_the_heralds_of_the_wind_ror_0"] = 1,
  ["wh2_dlc10_hef_inf_the_grey_ror_0"] = 1,
  ["wh2_dlc10_hef_inf_the_storm_riders_ror_0"] = 1,
  ["wh2_dlc10_hef_inf_everqueens_court_guards_ror_0"] = 3,
  ["wh2_dlc10_hef_inf_keepers_of_the_flame_ror_0"] = 4,
  ["wh2_dlc10_hef_cav_the_fireborn_ror_0"] = 4,
--Dark Elves
  ["wh2_main_def_cav_dark_riders_0"] = 0,
  ["wh2_main_def_cav_dark_riders_1"] = 0,
  ["wh2_main_def_cav_dark_riders_2"] = 0,
  ["wh2_main_def_inf_bleakswords_0"] = 0,
  ["wh2_main_def_inf_darkshards_0"] = 0,
  ["wh2_main_def_inf_darkshards_1"] = 0,
  ["wh2_main_def_inf_dreadspears_0"] = 0,
  ["wh2_main_def_inf_harpies"] = 0,
  -- special
  ["wh2_dlc10_def_cav_doomfire_warlocks_0"] = 1,
  ["wh2_main_def_inf_black_ark_corsairs_0"] = 1,
  ["wh2_main_def_inf_black_ark_corsairs_1"] = 1,
  ["wh2_main_def_inf_witch_elves_0"] = 1,
  -- rare
  ["wh2_main_def_inf_shades_0"] = 2,
  ["wh2_main_def_inf_shades_1"] = 2,
  ["wh2_main_def_inf_shades_2"] = 2,
  ["wh2_main_def_cav_cold_one_chariot"] = 2,
  ["wh2_main_def_cav_cold_one_knights_0"] = 2,
  ["wh2_dlc10_def_mon_feral_manticore_0"] = 2,
  ["wh2_dlc14_def_cav_scourgerunner_chariot_0"] = 2,
  ["wh2_dlc10_def_inf_sisters_of_slaughter"] = 2,
  -- elite
  ["wh2_dlc14_def_mon_bloodwrack_medusa_0"] = 3,
  ["wh2_dlc14_def_veh_bloodwrack_shrine_0"] = 3,
  ["wh2_main_def_mon_war_hydra"] = 3,
  ["wh2_dlc10_def_mon_kharibdyss_0"] = 3,
  ["wh2_main_def_cav_cold_one_knights_1"] = 3,
  ["wh2_main_def_art_reaper_bolt_thrower"] = 3,
  ["wh2_main_def_inf_har_ganeth_executioners_0"] = 3,
  ["wh2_main_def_inf_black_guard_0"] = 3,
  ["wh2_main_def_mon_black_dragon"] = 4,
  --ROR
  ["wh2_dlc14_def_inf_harpies_ror_0"] = 1,
  ["wh2_dlc10_def_inf_the_bolt_fiends_ror_0"] = 1,
  ["wh2_dlc10_def_inf_sisters_of_the_singing_doom_ror_0"] = 1,
  ["wh2_dlc10_def_inf_the_hellebronai_ror_0"] = 1,
  ["wh2_dlc10_def_cav_slaanesh_harvesters_ror_0"] = 1,
  ["wh2_dlc10_def_cav_raven_heralds_ror_0"] = 1,
  ["wh2_dlc10_def_cav_knights_of_the_ebon_claw_ror_0"] = 3,
  ["wh2_dlc10_def_mon_chill_of_sontar_ror_0"] = 3,
  ["wh2_dlc14_def_cav_scourgerunner_chariot_ror_0"] = 2,
  ["wh2_dlc14_def_mon_bloodwrack_medusa_ror_0"] = 3,
  ["wh2_dlc10_def_inf_blades_of_the_blood_queen_ror_0"] = 3,
  
--Lizardmen
  ["wh2_main_lzd_cav_cold_ones_feral_0"] = 0,
  ["wh2_main_lzd_inf_skink_cohort_0"] = 0,
  ["wh2_main_lzd_inf_skink_cohort_1"] = 0,
  ["wh2_main_lzd_inf_skink_skirmishers_0"] = 0,
  ["wh2_main_lzd_inf_skink_skirmishers_blessed_0"] = 0,
  ["wh2_dlc12_lzd_inf_skink_red_crested_0"] = 0,
  -- special
  ["wh2_main_lzd_inf_chameleon_skinks_0"] = 1,
  ["wh2_main_lzd_inf_chameleon_skinks_blessed_0"] = 1,
  ["wh2_main_lzd_cav_cold_one_spearmen_1"] = 1,
  ["wh2_main_lzd_cav_cold_one_spearriders_blessed_0"] = 1,
  ["wh2_main_lzd_cav_cold_ones_1"] = 1,
  ["wh2_main_lzd_inf_saurus_spearmen_0"] = 1,
  ["wh2_main_lzd_inf_saurus_spearmen_1"] = 2,
  ["wh2_main_lzd_inf_saurus_spearmen_blessed_1"] = 2,
  ["wh2_main_lzd_inf_saurus_warriors_0"] = 1,
  ["wh2_main_lzd_inf_saurus_warriors_1"] = 2,
  ["wh2_main_lzd_inf_saurus_warriors_blessed_1"] = 2,
  ["wh2_dlc12_lzd_cav_terradon_riders_1_tlaqua"] = 1,
  ["wh2_main_lzd_cav_terradon_riders_0"] = 1,
  ["wh2_main_lzd_cav_terradon_riders_1"] = 1,
  ["wh2_main_lzd_cav_terradon_riders_blessed_1"] = 1,
  ["wh2_dlc12_lzd_mon_salamander_pack_0"] = 1,
  ["wh2_dlc13_lzd_mon_razordon_pack_0"] = 1,
  
  -- rare
  ["wh2_main_lzd_cav_horned_ones_0"] = 3,
  ["wh2_main_lzd_cav_horned_ones_blessed_0"] = 1,
  ["wh2_main_lzd_inf_temple_guards"] = 3,
  ["wh2_main_lzd_inf_temple_guards_blessed"] = 3,
  ["wh2_dlc12_lzd_mon_ancient_salamander_0"] = 2,
  ["wh2_dlc12_lzd_mon_bastiladon_3"] = 2,
  ["wh2_main_lzd_mon_bastiladon_0"] = 2,
  ["wh2_main_lzd_mon_bastiladon_1"] = 2,
  ["wh2_main_lzd_mon_bastiladon_2"] = 2,
  ["wh2_main_lzd_mon_bastiladon_blessed_2"] = 2,
  ["wh2_dlc12_lzd_cav_ripperdactyl_riders_0"] = 2,
  ["wh2_main_lzd_mon_kroxigors"] = 2,
  ["wh2_main_lzd_mon_kroxigors_blessed"] = 2,
  ["wh2_dlc13_lzd_mon_sacred_kroxigors_0"] = 2,
  ["wh2_dlc13_lzd_mon_sacred_kroxigors_0_nakai"] = 2,
  -- elite
  ["wh2_main_lzd_mon_stegadon_1"] = 3,
  ["wh2_main_lzd_mon_stegadon_0"] = 3,
  ["wh2_main_lzd_mon_stegadon_blessed_1"] = 3,
  ["wh2_dlc12_lzd_mon_ancient_stegadon_1"] = 3,
  ["wh2_main_lzd_mon_ancient_stegadon"] = 3,
  ["wh2_main_lzd_mon_carnosaur_0"] = 4,
  ["wh2_main_lzd_mon_carnosaur_blessed_0"] = 4,
  ["wh2_dlc13_lzd_mon_dread_saurian_0"] = 6,
  ["wh2_dlc13_lzd_mon_dread_saurian_1"] = 6,
  --ROR
  ["wh2_dlc12_lzd_inf_skink_red_crested_ror_0"] = 1,
  ["wh2_dlc12_lzd_cav_cold_one_spearriders_ror_0"] = 1,
  ["wh2_dlc12_lzd_mon_salamander_pack_ror_0"] = 1,
  ["wh2_dlc12_lzd_inf_saurus_warriors_ror_0"] = 1,
  ["wh2_dlc12_lzd_cav_terradon_riders_ror_0"] = 1,
  ["wh2_dlc13_lzd_mon_razordon_pack_ror_0"] = 1,
  ["wh2_dlc12_lzd_inf_temple_guards_ror_0"] = 2,
  ["wh2_dlc12_lzd_cav_ripperdactyl_riders_ror_0"] = 2,
  ["wh2_dlc12_lzd_mon_ancient_stegadon_ror_0"] = 3,
  ["wh2_dlc13_lzd_mon_sacred_kroxigors_ror_0"] = 2,
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
  -- rare
  ["wh2_main_skv_mon_rat_ogres"] = 2,
  ["wh2_dlc14_skv_inf_warp_grinder_0"] = 2,
  ["wh2_main_skv_inf_death_globe_bombardiers"] = 2,
  ["wh2_main_skv_inf_poison_wind_globadiers"] = 2,
  ["wh2_main_skv_inf_warpfire_thrower"] = 2,
  -- elite
  ["wh2_dlc12_skv_inf_ratling_gun_0"] = 3,
  ["wh2_dlc12_skv_veh_doom_flayer_0"] = 3,
  ["wh2_dlc14_skv_inf_poison_wind_mortar_0"] = 3,
  ["wh2_dlc12_skv_inf_warplock_jezzails_0"] = 3,
  ["wh2_main_skv_art_plagueclaw_catapult"] = 3,
  ["wh2_main_skv_art_warp_lightning_cannon"] = 3,
  --
  ["wh2_main_skv_veh_doomwheel"] = 4,
  ["wh2_main_skv_mon_hell_pit_abomination"] = 4,
  --ROR
  ["wh2_dlc14_skv_inf_death_runners_ror_0"] = 1,
  ["wh2_dlc14_skv_inf_eshin_triads_ror_0"] = 1,
  ["wh2_dlc12_skv_inf_clanrats_ror_0"] = 1,
  ["wh2_dlc12_skv_inf_plague_monk_censer_bearer_ror_0"] = 1,
  ["wh2_dlc12_skv_inf_stormvermin_ror_0"] = 1,
  ["wh2_dlc12_skv_inf_warpfire_thrower_ror_tech_lab_0"] = 2,
  ["wh2_dlc12_skv_inf_ratling_gun_ror_0"] = 3,
  ["wh2_dlc12_skv_inf_ratling_gun_ror_tech_lab_0"] = 3,
  ["wh2_dlc14_skv_inf_poison_wind_mortar_ror_0"] = 3,
  ["wh2_dlc12_skv_veh_doom_flayer_ror_tech_lab_0"] = 3,
  ["wh2_dlc12_skv_veh_doom_flayer_ror_0"] = 3,
  ["wh2_dlc12_skv_inf_warplock_jezzails_ror_0"] = 3,
  ["wh2_dlc12_skv_art_warp_lightning_cannon_ror_0"] = 3,
  ["wh2_dlc12_skv_art_warplock_jezzails_ror_tech_lab_0"] = 3,
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
  -- special
  ["wh2_dlc11_cst_inf_zombie_gunnery_mob_2"] = 1,
  ["wh2_dlc11_cst_cav_deck_droppers_0"] = 1,
  ["wh2_dlc11_cst_cav_deck_droppers_1"] = 1,
  ["wh2_dlc11_cst_cav_deck_droppers_2"] = 1,
  -- rare
  ["wh2_dlc11_cst_inf_syreens"] = 3,
  ["wh2_dlc11_cst_mon_animated_hulks_0"] = 3,
  ["wh2_dlc11_cst_inf_depth_guard_0"] = 2,
  ["wh2_dlc11_cst_inf_depth_guard_1"] = 2,
  ["wh2_dlc11_cst_mon_rotting_prometheans_0"] = 2,
  ["wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0"] = 2,
  -- elite
  ["wh2_dlc11_cst_inf_deck_gunners_0"] = 3,
  ["wh2_dlc11_cst_mon_mournguls_0"] = 3,
  ["wh2_dlc11_cst_art_carronade"] = 3,
  ["wh2_dlc11_cst_art_mortar"] = 3,
  ["wh2_dlc11_cst_mon_necrofex_colossus_0"] = 4,
  ["wh2_dlc11_cst_mon_rotting_leviathan_0"] = 4,
  ["wh2_dlc11_cst_mon_terrorgheist"] = 4,
  --ROR
  ["wh2_dlc11_cst_inf_zombie_gunnery_mob_ror_0"] = 1,
  ["wh2_dlc11_cst_inf_zombie_deckhands_mob_ror_0"] = 1,
  ["wh2_dlc11_cst_cav_deck_droppers_ror_0"] = 1,
  ["wh2_dlc11_cst_inf_depth_guard_ror_0"] = 2,
  ["wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_ror"] = 2,
  ["wh2_dlc11_cst_inf_deck_gunners_ror_0"] = 3,
  ["wh2_dlc11_cst_mon_mournguls_ror_0"] = 3,
  ["wh2_dlc11_cst_mon_necrofex_colossus_ror_0"] = 4,
  ["wh2_dlc11_cst_art_queen_bess"] = 4,

--sfo
  ["dwf_oathsworn"] = 0,
  ["emp_flagellants_ext"] = 0,
  ["emp_hound"] = 0,
  ["emp_ulric_sons"] = 0,
  ["grn_boom_squig"] = 0,
  ["grn_forest_spear"] = 0,
  ["grn_zombie_boyz"] = 0,
  ["lzd_skinks_red"] = 0,
  ["cst_boarding_crew"] = 2,
  ["cst_carronade"] = 3,
  ["cst_pirate_merc"] = 1,
  ["cst_raiders"] = 1,
  ["dwf_sniper"] = 3,
  ["emp_officer_squad"] = 2,
  ["emp_tank_ror"] = 5,
  ["dwf_thunderers_1"] = 1,
  ["emp_carroburg"] = 1,
  ["emp_knights_panther"] = 2,
  ["emp_long_rifles"] = 2,
  ["emp_nuln_ironsides"] = 2,
  ["emp_sigmar_war"] = 1,
  ["emp_witch_squad"] = 1,
  ["emp_wolf_guard"] = 2,
  ["emp_wolf_kin"] = 1,
  ["emp_wolf_knight"] =2,
  ["grn_black_orc_shields"] = 2,
  ["grn_giant_squig"] = 3,
  ["grn_savage_big_great"] = 2,
  ["grn_wyvern"] = 3,
  ["wh_main_chs_inf_chosen_0"] = 3,
  ["wh_main_chs_inf_chosen_1"] = 3,
  ["wh_dlc01_chs_inf_chosen_2"] = 3,
  ["nor_whaler"] = 1,
  ["wh2_main_hef_inf_gate_guard"] = 2,
  ["hef_talons"] = 1,
  ["vmp_blood_dragon"] = 4,
  ["vmp_zombie_dragon"] = 4,
  ["wef_eternal_sword"] = 3,
  ["wef_wildwood_warden"] = 3,
  --SFO legendary
  ["emp_imp_guard"] = 6,
  ["dwf_daemon_slayer"] =6,
  ["dwf_everguard"] = 6,
  ["grn_black_orc_boss"] = 6,
  ["vmp_black_grail"] = 6, 
  ["def_dread"] =6,
  ["wef_shadowdancer"] = 6,
  ["chs_marauder_mutant"] = 6,
  ["hef_handmaidens"] = 6,
  ["def_manticore_knight"] = 6,
  ["lzd_eternity"] = 6,
  ["skv_black13"] = 6,

--Southern Realms
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
  ["dwf_cannon_teb"]= 3,
  ["dwf_organ_teb"]= 3,

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

--Kraka Drac
  ["kraka_quarrel_2h"] = 0,
  ["dwf_orgi"] = 0,

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
  ["wh2_mixu_vmp_cav_black_knights_lance"] = 1,
  
  ["wh2_mixu_vmp_inf_wailing_hags"] = 2,
  ["wh2_mixu_vmp_art_trebuchet"] = 2,
  ["wh2_mixu_vmp_art_cursed_trebuchet"] = 2,
  ["wh2_mixu_vmp_cav_knights_errant"] = 2,
  ["wh2_mixu_vmp_cav_knights_of_the_realm"] = 3,
  ["wh2_mixu_vmp_cav_questing_knights"] = 3,
  ["wh2_mixu_vmp_cav_black_grail_knights"] = 4,

  ["wh2_mixu_vmp_ror_the_hungry"] = 1,
  ["wh2_mixu_vmp_ror_bastardiers_of_chalons"] = 1,
  ["wh2_mixu_vmp_ror_the_ghosts_of_glanbor"] = 1,
  ["wh2_mixu_vmp_ror_midnight_ravens_of_rachard"] = 1,
  ["wh2_mixu_vmp_ror_silver_shriekers"] = 2,
  ["wh2_mixu_vmp_ror_doom_reliquae_of_mordac"] = 2,
  ["wh2_mixu_vmp_ror_the_rose_lances"] = 3,
  ["wh2_mixu_vmp_ror_the_dreadwings"] = 4,

};  

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

local max_supply_per_army = 25;  -- max effect number in effect_bundles_tables

--Support script

--calculate upkeep modificator
local function srw_get_diff_mult()
  local difficulty = cm:model():combined_difficulty_level();

  local mod = 10;				-- easy
  if difficulty == 0 then
    mod = 7;				-- normal
  elseif difficulty == -1 then
    mod = 5;					-- hard
  elseif difficulty == -2 then
    mod = 3;			-- very hard
  elseif difficulty == -3 then
    mod = 3;			-- legendary
  end;

  return mod;
end;

--parts of lower functions to easy edit


--if unit not found in SRW_Supply_Cost
local function calculate_unit_supply(unit)
  local uclass = unit:unit_class();
  local ucat = unit:unit_category();
  if uclass == "com" then
    return 0
  elseif ucat == "artillery" then
    return 3
  elseif ucat == "war_beast" then
    return 4
  elseif uclass == "cav_mel" or uclass == "cav_shk" or ucat== "war_machine" then
    return 2
  end;
  return 1;
end;  

local function calculate_army_supply(unit_list, character)
  local this_army_supply = 0;
  SRWLOG("--------");
  SRWLOG("Lord of this army is "..tostring(character));

  for j = 0, unit_list:num_items() - 1 do
    local unit = unit_list:item_at(j);
    local key = unit:unit_key();
    local val = SRW_Supply_Cost[key] or calculate_unit_supply(unit);
    if SRW_Free_Units[key.."-"..character] == 1 then
      SRWLOG(tostring(key).." IS FREE FOR "..tostring(character));
      val = 0;
    end;
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
  local multiplier = srw_get_diff_mult();
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

--version from hunter & beast patch
local function srw_faction_is_horde(faction)
	return faction:is_allowed_to_capture_territory() == false;
end;

--Main Script

--for faction
local function srw_apply_upkeep_penalty(faction)
  if faction:is_human() then
    local force_list = faction:military_force_list();
    
    for i = 0, force_list:num_items() - 1 do
      local force = force_list:item_at(i);
      
      if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
        SRWLOG("--------");
        SRWLOG("CHECK ARMY #"..tostring(i));
        srw_calculate_upkeep(force)
      end; --of army check
    end; --of army call
  end; -- of local faction
end; -- of function

--single army version of script
local function srw_this_army_upkeep(force)
  if force:faction():is_human() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
    srw_calculate_upkeep(force)
  end; -- of local faction
end;

local function localizator(string)
  local langfile = io.open("data/language.txt","r")
  local lang = langfile:read()
  langfile:close()
  local local_string = string
  if lang == "RU" then 
    local_string = string.."_ru"
  end
  return effect.get_localised_string(local_string)
end;

local function set_tooltip_text_treasury(faction)

  local culture = faction:subculture();
  local treasury_component = find_uicomponent(core:get_ui_root(), "button_finance")
  local global_supply = 0
  local upkeep_percent = -1
  local dif_mod = srw_get_diff_mult();
  local force_list = faction:military_force_list();
  local dummy_text = "SRW_dummy_text"
  local lord_text_key = SRW_Subculture_Text[culture] or dummy_text
  local lord_text = localizator(lord_text_key)


  -- calculate supply and upkeep
  for i = 0, force_list:num_items() - 1 do
    local force = force_list:item_at(i);
    
    if not force:is_armed_citizenry() and force:has_general() and not force:general_character():character_subtype("wh2_main_def_black_ark") then
      local unit_list = force:unit_list();
      local character = force:general_character():character_subtype_key();

      local army_supply = calculate_army_supply(unit_list, character);
      local army_upkeep_effect = math.floor(army_supply/dif_mod)
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

  local supply_text = localizator("SRW_treasury_tooltip_supply")
  supply_text = string.gsub(supply_text, "SRW_supply", tostring(global_supply))

  local tooltip_text = localizator("SRW_treasury_tooltip_main")..lord_text..supply_text..localizator("SRW_treasury_tooltip_upkeep")..tostring(upkeep_percent).."%\n"

  if srw_faction_is_horde(faction) then
    tooltip_text = localizator("SRW_Subculture_Text_hordes")
  elseif culture == "wh2_dlc09_tmb_tomb_kings" then
    tooltip_text = localizator("SRW_Subculture_Text_tomb_kings")
  elseif culture == "wh_main_brt_bretonnia" then
    tooltip_text = localizator("SRW_Subculture_Text_bretonnia")
  end;

  --apply text
  treasury_component:SetTooltipText(tooltip_text, true)
end;

local function set_unit_tooltip(component, text)

  local component_name = component:Id();
  local unit_name = string.gsub(component_name, text, "")
  local old_text = component:GetTooltipText();
  local unit_cost = SRW_Supply_Cost[unit_name]

  --if old_text:find("col:red") then return end
  local supply_text = localizator("SRW_unit_supply_cost_unknown")

  if unit_cost == 0 then
    supply_text = localizator("SRW_unit_supply_cost_zero")
    
  elseif SRW_Free_Units[unit_name.."-"..SRW_selected_character] == 1 or SRW_selected_character == "wh2_main_def_black_ark" then
    supply_text = localizator("SRW_unit_supply_cost_lord")

  elseif unit_cost == 1 then
    supply_text = localizator("SRW_unit_supply_cost_one")

  elseif unit_cost and unit_cost > 1 then
    local imported_text = localizator("SRW_unit_supply_cost_many")

    supply_text = string.gsub(imported_text, "SRW_Cost", tostring(unit_cost))

  end;
  
  if string.find(old_text, supply_text) then return end
  local final_text = string.gsub(old_text, "\n", "\n[[col:yellow]]"..supply_text.."[[/col]]\n", 1)
  if is_uicomponent(component) then 
    component:SetTooltipText(final_text)
  end;
end;
--Listeners start

core:add_listener(
  "SRW_FactionTurnStart",
  "FactionTurnStart",
  function(context)
    local faction = context:faction()
    return (faction:is_human() and not srw_faction_is_horde(faction) and not (faction:culture() == "wh2_dlc09_tmb_tomb_kings") and not (faction:culture() == "wh_main_brt_bretonnia"))
  end,  
  -- true,
  function(context) 
    local faction = context:faction();
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (TURN START)");
      srw_apply_upkeep_penalty(faction);
  end,
  true
);

core:add_listener(
  "SRW_UnitMergedAndDestroyed",
  "UnitMergedAndDestroyed",
  function(context)
    local key = context:unit():unit_key()
    local faction = context:unit():faction()
    return (faction:is_human() and (SRW_Supply_Cost[key] > 0) and not srw_faction_is_horde(faction) and not (faction:culture() == "wh2_dlc09_tmb_tomb_kings") and not (faction:culture() == "wh_main_brt_bretonnia"))
  end,  
  function(context)
    local army = context:unit():military_force();
    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (MERGE)");
      srw_this_army_upkeep(army)
    end, 0.5);
  end,
  true
);

core:add_listener(
  "SRW_UnitDisbanded",
  "UnitDisbanded",
  function(context)
    local key = context:unit():unit_key()
    local faction = context:unit():faction()
    return (faction:is_human() and (SRW_Supply_Cost[key] > 0) and not srw_faction_is_horde(faction) and not (faction:culture() == "wh2_dlc09_tmb_tomb_kings") and not (faction:culture() == "wh_main_brt_bretonnia"))
  end,  
  function(context)
    local army = context:unit():military_force();
    local key = context:unit():unit_key()

    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (DISBAND)");
      srw_this_army_upkeep(army)
    end, 0.5);
  end,
  true
);

core:add_listener(
  "SRW_RaiseDead",
  "ComponentLClickUp",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    return (UIComponent(context.component):Id() == "button_raise_dead" and not srw_faction_is_horde(faction))
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
    return (UIComponent(context.component):Id() == "button_hire_blessed" and not srw_faction_is_horde(faction))
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
    return (UIComponent(context.component):Id() == "button_hire_imperial" and not srw_faction_is_horde(faction))
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
    return (UIComponent(context.component):Id() == "button_hire_renown" and not srw_faction_is_horde(faction))
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
    return (faction:is_human() and not srw_faction_is_horde(faction) and not (faction:culture() == "wh2_dlc09_tmb_tomb_kings") and not (faction:culture() == "wh_main_brt_bretonnia"))
  end,  
  function(context)
    local faction = context:confederation();
    cm:callback(function()
      SRWLOG("======================");
      SRWLOG("APPLY UPKEEP (CONFEDERATION)");
      srw_apply_upkeep_penalty(faction);
    end, 0.1);
  end,
  true
);

core:add_listener(
  "SRW_TreasuryTooltip",
  "ComponentMouseOn",
  function(context)
    return (UIComponent(context.component):Id() == "button_finance")
  end,
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    set_tooltip_text_treasury(faction)
  end,
  true
)

core:add_listener(
  "SRW_UnitTooltip_merc",
  "ComponentMouseOn",
  function(context)
    local faction = cm:model():world():whose_turn_is_it()
    local component = UIComponent(context.component):Id()
    return cm.campaign_ui_manager:is_panel_open("units_panel") and string.find(component, "_mercenary") and not srw_faction_is_horde(faction) and not (faction:culture() == "wh2_dlc09_tmb_tomb_kings") and not (faction:culture() == "wh_main_brt_bretonnia")
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
    return cm.campaign_ui_manager:is_panel_open("units_panel") and string.find(component, "_recruitable") and not srw_faction_is_horde(faction) and not (faction:culture() == "wh2_dlc09_tmb_tomb_kings") and not (faction:culture() == "wh_main_brt_bretonnia")
  end,
  function(context)
    local component = UIComponent(context.component)
    set_unit_tooltip(component, "_recruitable")
  end,
  true
)

core:add_listener(
  "SRW_Character_Selected",
  "CharacterSelected",
  function(context)
    return context:character():faction():is_human() and context:character():has_military_force()
  end,
  function(context)
    SRW_selected_character = context:character():character_subtype_key();

  end,
  true
)
